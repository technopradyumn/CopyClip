import 'dart:async';
import 'dart:io';

import 'package:copyclip/src/core/const/premium_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'premium_event.dart';
import 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  static const String _boxName = 'settings';
  static const String _coinsKey = 'user_coins';
  static const String _premiumExpiryKey = 'premium_expiry';

  // Ad Variables
  Object? _ad; // Can be RewardedAd or RewardedInterstitialAd

  PremiumBloc() : super(const PremiumState()) {
    on<LoadPremiumData>(_onLoadPremiumData);
    on<AddCoins>(_onAddCoins);
    on<BuyPremium>(_onBuyPremium);
    on<LoadRewardedAd>(_onLoadRewardedAd);
    on<ShowRewardedAd>(_onShowRewardedAd);
    on<RewardedAdStatusChanged>(_onRewardedAdStatusChanged);
  }

  Future<void> _onLoadPremiumData(
    LoadPremiumData event,
    Emitter<PremiumState> emit,
  ) async {
    // Ensure box is open (should be handled by main init, but safe check)
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
    final box = Hive.box(_boxName);
    final coins = box.get(_coinsKey, defaultValue: 0) as int;
    final expiryString = box.get(_premiumExpiryKey) as String?;

    DateTime? expiry;
    if (expiryString != null) {
      expiry = DateTime.tryParse(expiryString);
    }

    // Check force premium flag from provider default (or env?)
    // For now we default to false.

    emit(
      state.copyWith(
        coins: coins,
        premiumExpiryDate: expiry,
        isPremiumOverride: false,
      ),
    );

    // Proactively load ad
    add(LoadRewardedAd());
  }

  Future<void> _onAddCoins(AddCoins event, Emitter<PremiumState> emit) async {
    final newCoins = state.coins + event.amount;
    final box = Hive.box(_boxName);
    await box.put(_coinsKey, newCoins);
    emit(state.copyWith(coins: newCoins));
  }

  Future<void> _onBuyPremium(
    BuyPremium event,
    Emitter<PremiumState> emit,
  ) async {
    if (state.coins >= PremiumConstants.premiumCost) {
      final newCoins = state.coins - PremiumConstants.premiumCost;

      final now = DateTime.now();
      final start = (state.isPremium && state.premiumExpiryDate != null)
          ? state.premiumExpiryDate!
          : now;
      final newExpiry = start.add(
        const Duration(days: PremiumConstants.premiumDurationDays),
      );

      final box = Hive.box(_boxName);
      await box.put(_coinsKey, newCoins);
      await box.put(_premiumExpiryKey, newExpiry.toIso8601String());

      emit(state.copyWith(coins: newCoins, premiumExpiryDate: newExpiry));
    }
  }

  void _onRewardedAdStatusChanged(
    RewardedAdStatusChanged event,
    Emitter<PremiumState> emit,
  ) {
    emit(
      state.copyWith(isAdReady: event.isReady, isAdLoading: event.isLoading),
    );
  }

  // --- ADS LOGIC ---

  String get _rewardedAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_REWARDED_AD_UNIT_ID'] ??
          'ca-app-pub-3940256099942544/5224354917';
    }
    return '';
  }

  Future<void> _onLoadRewardedAd(
    LoadRewardedAd event,
    Emitter<PremiumState> emit,
  ) async {
    if (state.isAdLoading || state.isAdReady) return;

    final unitId = _rewardedAdUnitId;
    if (unitId.isEmpty) return;

    emit(state.copyWith(isAdLoading: true));

    // We can't await load directly as it's callback based.
    // We'll use a completer to bridge, or just let state update asynchronously?
    // BLoC handlers should ideally be async.
    // Since we need to update state INSIDE callback, we need reference to emit?
    // NO, emit is only valid during the handler execution synchronuously or awaited.
    // We cannot emit after this function returns.
    // So we must await a Completer.

    final completer = Completer<Object?>();

    RewardedAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (!completer.isCompleted) completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) {
            if (error.message.toLowerCase().contains("format")) {
              completer.completeError(error);
            } else {
              completer.complete(null);
            }
          }
        },
      ),
    );

    try {
      final ad = await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          if (!completer.isCompleted) completer.complete(null);
          return null;
        },
      );
      if (ad != null) {
        _ad = ad;
        emit(state.copyWith(isAdLoading: false, isAdReady: true));
      } else {
        // Failed
        emit(state.copyWith(isAdLoading: false, isAdReady: false));
        // Retry with a delay if ad failed to load (to be more aggressive)
        Future.delayed(const Duration(seconds: 5), () {
          if (!isClosed && !state.isAdReady) {
            add(LoadRewardedAd());
          }
        });
      }
    } catch (e) {
      // Try interstitial fallback
      if (e.toString().contains("format")) {
        // Simplified fallback logic for brevity in refactor
        await _loadRewardedInterstitialAd(unitId, emit);
      } else {
        emit(state.copyWith(isAdLoading: false, isAdReady: false));
      }
    }
  }

  Future<void> _loadRewardedInterstitialAd(
    String unitId,
    Emitter<PremiumState> emit,
  ) async {
    final completer = Completer<Object?>();
    RewardedInterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (!completer.isCompleted) completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );

    try {
      final ad = await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          if (!completer.isCompleted) completer.complete(null);
          return null;
        },
      );
      if (ad != null) {
        _ad = ad;
        emit(state.copyWith(isAdLoading: false, isAdReady: true));
      } else {
        emit(state.copyWith(isAdLoading: false, isAdReady: false));
        // Final retry with delay
        Future.delayed(const Duration(seconds: 10), () {
          if (!isClosed && !state.isAdReady) {
            add(LoadRewardedAd());
          }
        });
      }
    } catch (e) {
      emit(state.copyWith(isAdLoading: false, isAdReady: false));
    }
  }

  Future<void> _onShowRewardedAd(
    ShowRewardedAd event,
    Emitter<PremiumState> emit,
  ) async {
    if (_ad == null) {
      if (!state.isAdLoading) {
        add(LoadRewardedAd());
      }
      return;
    }

    // Immediately mark as not ready and clear _ad to prevent double submissions
    final adToBlock = _ad;
    _ad = null;
    emit(state.copyWith(isAdReady: false, isAdLoading: false));

    if (adToBlock is RewardedAd) {
      final ad = adToBlock;
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          add(LoadRewardedAd()); // Preload next
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          add(LoadRewardedAd());
        },
      );
      try {
        await ad.show(
          onUserEarnedReward: (ad, reward) {
            event.onReward(PremiumConstants.rewardCoinAmount);
            add(AddCoins(PremiumConstants.rewardCoinAmount));
          },
        );
      } catch (e) {
        ad.dispose();
        add(LoadRewardedAd());
      }
    } else if (adToBlock is RewardedInterstitialAd) {
      final ad = adToBlock;
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          add(LoadRewardedAd()); // Preload next
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          add(LoadRewardedAd());
        },
      );
      try {
        await ad.show(
          onUserEarnedReward: (ad, reward) {
            event.onReward(PremiumConstants.rewardCoinAmount);
            add(AddCoins(PremiumConstants.rewardCoinAmount));
          },
        );
      } catch (e) {
        ad.dispose();
        add(LoadRewardedAd());
      }
    }
  }
}
