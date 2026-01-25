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

  RewardedInterstitialAd? _interstitialAd;
  bool _isAdLoading = false;

  bool get isAdReady => _interstitialAd != null;
  bool get isLoading => _isAdLoading;

  /// Get the appropriate ad unit ID based on platform
  String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_INTERSTITIAL_AD_UNIT_ID'] ??
          '';
    }
    // else if (Platform.isIOS) {
    //   return dotenv.env['IOS_INTERSTITIAL_AD_UNIT_ID'] ??
    //       '';
    // }
    return '';
  }

  /// Load an interstitial ad
  void loadAd() {
    if (_isAdLoading) return;
    _isAdLoading = true;

    RewardedInterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded Interstitial Ad Loaded');
          _interstitialAd = ad;
          _isAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded Interstitial Ad Failed: $error');
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
    final ad = _interstitialAd!;
    _interstitialAd = null;

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

    ad.show(
      onUserEarnedReward: (adWithoutView, rewardItem) {
        // Just proceed, we don't track coins for this simple unlock
      },
    );
  }

  /// Dispose the ad (call this when needed)
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
