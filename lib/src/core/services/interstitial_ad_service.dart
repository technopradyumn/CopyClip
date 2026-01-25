import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Centralized service for managing interstitial ads
/// Similar pattern to rewarded ads in PremiumProvider
class InterstitialAdService {
  static final InterstitialAdService _instance =
      InterstitialAdService._internal();
  factory InterstitialAdService() => _instance;
  InterstitialAdService._internal();

  dynamic _interstitialAd; // Can be InterstitialAd or RewardedInterstitialAd
  bool _isAdLoading = false;

  bool get isAdReady => _interstitialAd != null;
  bool get isLoading => _isAdLoading;

  /// Get the appropriate ad unit ID based on platform
  String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_INTERSTITIAL_AD_UNIT_ID'] ?? '';
    }
    return '';
  }

  /// Load an interstitial ad
  void loadAd() {
    if (_isAdLoading) return;
    final unitId = _interstitialAdUnitId;
    if (unitId.isEmpty) return;

    _isAdLoading = true;

    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Interstitial Ad Loaded');
          _interstitialAd = ad;
          _isAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Interstitial Ad Failed: $error');
          if (error.message.toLowerCase().contains("format")) {
            debugPrint(
              '🔄 Format mismatch. Trying RewardedInterstitialAd fallback...',
            );
            _loadRewardedInterstitialAd(unitId);
          } else {
            _interstitialAd = null;
            _isAdLoading = false;
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
          debugPrint('✅ Rewarded Interstitial Ad Loaded (Fallback)');
          _interstitialAd = ad;
          _isAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded Interstitial Fallback Failed: $error');
          _interstitialAd = null;
          _isAdLoading = false;
        },
      ),
    );
  }

  /// Show the ad and execute the callback after ad is dismissed
  /// If ad is not ready, callback is executed immediately
  void showAd(VoidCallback onComplete) {
    if (_interstitialAd == null) {
      debugPrint('⚠️ Ad not ready, proceeding with action...');
      onComplete(); // Proceed if ad failed to load
      loadAd(); // Try loading for next time
      return;
    }

    // ✅ CRITICAL: Safely consume ad instance to prevent Double-Show / NullPointer
    final ad = _interstitialAd;
    _interstitialAd = null;

    if (ad is InterstitialAd) {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('👋 Ad Dismissed - Executing Action');
          ad.dispose();
          loadAd(); // Preload next one
          onComplete(); // ✅ Execute callback HERE
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('❌ Ad Failed to Show - Executing Action');
          ad.dispose();
          loadAd();
          onComplete(); // Ensure action happens even if ad fails
        },
      );
      try {
        ad.setImmersiveMode(true);
      } catch (e) {
        debugPrint("⚠️ Failed to set immersive mode: $e");
      }
      ad.show();
    } else if (ad is RewardedInterstitialAd) {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('👋 Ad Dismissed - Executing Action');
          ad.dispose();
          loadAd();
          onComplete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('❌ Ad Failed to Show - Executing Action');
          ad.dispose();
          loadAd();
          onComplete();
        },
      );
      ad.show(onUserEarnedReward: (ad, reward) => null);
    }
  }

  /// Dispose the ad (call this when needed)
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
