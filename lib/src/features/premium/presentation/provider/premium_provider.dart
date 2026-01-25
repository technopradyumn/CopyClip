import 'dart:async';
import 'dart:io';

import 'package:copyclip/src/core/const/premium_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PremiumProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _coinsKey = 'user_coins';
  static const String _premiumExpiryKey = 'premium_expiry';

  // --- GLOBAL PREMIUM TOGGLE ---
  // Set this to true to unlock all features for testing/distribution
  static const bool forcePremium = false;

  int _coins = 0;
  DateTime? _premiumExpiryDate;

  Object? _ad; // Can be RewardedAd or RewardedInterstitialAd
  bool _isAdLoading = false;
  Completer<void>? _adLoadCompleter;

  int get coins => _coins;
  bool get isPremium {
    if (forcePremium) return true;
    if (_premiumExpiryDate == null) return false;
    return _premiumExpiryDate!.isAfter(DateTime.now());
  }

  DateTime? get premiumExpiryDate => _premiumExpiryDate;
  bool get isAdLoading => _isAdLoading;

  PremiumProvider() {
    _loadData();
    // No automatic load here to avoid race conditions with main.dart init
  }

  Future<void> _loadData() async {
    final box = await Hive.openBox(_boxName);
    _coins = box.get(_coinsKey, defaultValue: 0);
    final expiryString = box.get(_premiumExpiryKey);
    if (expiryString != null) {
      _premiumExpiryDate = DateTime.tryParse(expiryString);
    }
    notifyListeners();
  }

  Future<void> addCoins(int amount) async {
    _coins += amount;
    final box = Hive.box(_boxName);
    await box.put(_coinsKey, _coins);
    notifyListeners();
  }

  Future<bool> buyPremium() async {
    if (_coins >= PremiumConstants.premiumCost) {
      _coins -= PremiumConstants.premiumCost;

      // Extend existing if valid, else start from now
      final now = DateTime.now();
      final start = (isPremium && _premiumExpiryDate != null)
          ? _premiumExpiryDate!
          : now;
      _premiumExpiryDate = start.add(
        const Duration(days: PremiumConstants.premiumDurationDays),
      );

      final box = Hive.box(_boxName);
      await box.put(_coinsKey, _coins);
      await box.put(_premiumExpiryKey, _premiumExpiryDate!.toIso8601String());

      notifyListeners();
      return true;
    }
    return false;
  }
  // --- ADS ---

  String get _rewardedAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_REWARDED_AD_UNIT_ID'] ?? '';
    }
    return '';
  }

  void _loadRewardedAd() {
    if (_adLoading) return;
    final unitId = _rewardedAdUnitId;
    if (unitId.isEmpty) {
      debugPrint('⚠️ Rewarded Ad Unit ID is empty. Waiting...');
      return;
    }

    _isAdLoading = true;

    debugPrint('🚀 Loading Rewarded Ad: $unitId');

    RewardedAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded Ad Loaded');
          _ad = ad;
          _isAdLoading = false;
          _completeAdLoad();
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded Ad Failed: $error');
          // Check for format mismatch
          if (error.message.toLowerCase().contains("format")) {
            debugPrint(
              '🔄 Format mismatch detected. Trying RewardedInterstitialAd...',
            );
            _loadRewardedInterstitialAd(unitId);
          } else {
            _ad = null;
            _isAdLoading = false;
            _failAdLoad(error);
            notifyListeners();
          }
        },
      ),
    );
  }

  void _loadRewardedInterstitialAd(String unitId) {
    RewardedInterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded Interstitial Ad Loaded');
          _ad = ad;
          _isAdLoading = false;
          _completeAdLoad();
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded Interstitial Ad Failed: $error');
          _ad = null;
          _isAdLoading = false;
          _failAdLoad(error);
          notifyListeners();
        },
      ),
    );
  }

  void _completeAdLoad() {
    if (_adLoadCompleter != null && !_adLoadCompleter!.isCompleted) {
      _adLoadCompleter!.complete();
    }
  }

  void _failAdLoad(dynamic error) {
    if (_adLoadCompleter != null && !_adLoadCompleter!.isCompleted) {
      _adLoadCompleter!.completeError(error);
    }
  }

  bool get _adLoading => _isAdLoading;

  Future<void> showRewardedAd({required Function(int) onReward}) async {
    if (_ad == null) {
      debugPrint('⚠️ Ad not ready. Loading new ad...');
      _isAdLoading = true;
      notifyListeners();

      _adLoadCompleter = Completer<void>();
      _loadRewardedAd();

      try {
        await _adLoadCompleter!.future.timeout(const Duration(seconds: 15));
      } catch (e) {
        debugPrint('❌ Ad timeout or error: $e');
        _isAdLoading = false;
        notifyListeners();
        return;
      }
    }

    if (_ad != null) {
      if (_ad is RewardedAd) {
        final ad = _ad as RewardedAd;
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _ad = null;
            _loadRewardedAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _ad = null;
            _loadRewardedAd();
          },
        );
        ad.show(
          onUserEarnedReward: (ad, reward) =>
              onReward(PremiumConstants.rewardCoinAmount),
        );
      } else if (_ad is RewardedInterstitialAd) {
        final ad = _ad as RewardedInterstitialAd;
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _ad = null;
            _loadRewardedAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _ad = null;
            _loadRewardedAd();
          },
        );
        ad.show(
          onUserEarnedReward: (ad, reward) =>
              onReward(PremiumConstants.rewardCoinAmount),
        );
      }
    }
  }
}
