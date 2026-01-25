import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:flutter/cupertino.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // 1. Initialize the controller
    _controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      ) // Essential for Google Sites
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error: ${error.description}');
          },
        ),
      )
      // 2. Load your Google Site URL here
      ..loadRequest(
        Uri.parse('https://sites.google.com/view/copyclipapp?usp=sharing'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      title: null,
      showBackArrow: false,
      body: Column(
        children: [
          SeamlessHeader(
            title: "Privacy Policy",
            subtitle: "Your data is safe",
            icon: CupertinoIcons.shield_fill,
            iconColor: Colors.green,
            showBackButton: true,
          ),
          Expanded(
            child: Stack(
              children: [
                // The actual scrollable web content
                WebViewWidget(controller: _controller),

                // Show a glass-style loader while the site loads
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
