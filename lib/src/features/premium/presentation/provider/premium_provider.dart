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

  bool _isAdLoading = false;
  RewardedAd? _rewardedAd;
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
    _loadRewardedAd();
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
      return dotenv.env['ANDROID_REWARDED_AD_UNIT_ID'] ??
          'ca-app-pub-3940256099942544/5224354917'; // Test ID
    } else if (Platform.isIOS) {
      return dotenv.env['IOS_REWARDED_AD_UNIT_ID'] ??
          'ca-app-pub-3940256099942544/1712485313'; // Test ID
    }
    return 'ca-app-pub-3940256099942544/5224354917';
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded Ad Loaded');
          _rewardedAd = ad;
          _isAdLoading = false;
          if (_adLoadCompleter != null && !_adLoadCompleter!.isCompleted) {
            _adLoadCompleter!.complete();
          }
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded Ad Failed: $error');
          _rewardedAd = null;
          _isAdLoading = false;
          if (_adLoadCompleter != null && !_adLoadCompleter!.isCompleted) {
            _adLoadCompleter!.completeError(error);
          }
          notifyListeners();
        },
      ),
    );
  }

  Future<void> showRewardedAd({required Function(int) onReward}) async {
    if (_rewardedAd == null) {
      debugPrint('⚠️ Ad not ready. Loading new ad...');
      _isAdLoading = true;
      notifyListeners();

      _adLoadCompleter = Completer<void>();
      _loadRewardedAd();

      try {
        await _adLoadCompleter!.future.timeout(const Duration(seconds: 10));
      } catch (e) {
        debugPrint('❌ Ad timeout or error: $e');
        _isAdLoading = false;
        notifyListeners();
        return;
      }
    }

    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          _loadRewardedAd(); // Preload next
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('❌ Ad failed to show: $error');
          ad.dispose();
          _rewardedAd = null;
          _loadRewardedAd();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (adWithoutView, rewardItem) {
          onReward(PremiumConstants.rewardCoinAmount);
        },
      );
    }
  }
}
