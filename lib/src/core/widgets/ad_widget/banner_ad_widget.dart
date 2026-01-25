import 'dart:io';
import 'dart:ui'; // Required for View.of(context)
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final bool hideOnKeyboard;

  const BannerAdWidget({super.key, this.hideOnKeyboard = true});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  // ✅ TEST ID FALLBACK (Standard Google Test Banner ID)
  // This ensures ads show up even if .env is missing or invalid
  String get _adUnitId {

    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_BANNER_AD_UNIT_ID'] ??
          ''; // Test ID
    }
    // else if (Platform.isIOS) {
    //   return dotenv.env['IOS_BANNER_AD_UNIT_ID'] ??
    //       ''; // Test ID
    // }
    return '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load ad here to have valid MediaQuery context for Adaptive Size
    if (_bannerAd == null) {
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    // 🏷️ ADAPTIVE SIZE: Fills width properly
    final width = MediaQuery.of(context).size.width.truncate();
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );

    if (!mounted) return;

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: size ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('✅ Banner Ad Loaded (${ad.responseInfo?.responseId})');
          if (mounted) setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Banner Ad Failed: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Check if Keyboard is visible
    if (widget.hideOnKeyboard) {
      // ✅ FIX: Use View.of(context).viewInsets.bottom
      // This checks the physical screen insets (raw window), bypassing the
      // Scaffold's resizing logic. It will detect the keyboard even if
      // resizeToAvoidBottomInset is true.
      final bottomInset = View.of(context).viewInsets.bottom;

      if (bottomInset > 0) return const SizedBox.shrink();
    }

    // 2. If Ad is not ready, hide it
    if (!_isAdLoaded || _bannerAd == null) return const SizedBox.shrink();

    // 3. Show Ad
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
