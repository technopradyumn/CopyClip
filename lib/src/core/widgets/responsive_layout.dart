import 'package:flutter/material.dart';

/// A Helper Widget to manage Responsive Layouts for Mobile, Tablet, and Desktop
class ResponsiveLayout extends StatefulWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  // --- Static Helper Methods for Logic Checks ---
  // These remain in the widget class for easy access
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    // We use MediaQuery here. Since it's inside build(),
    // Flutter will automatically rebuild this widget when screen size changes.
    final Size size = MediaQuery.of(context).size;

    // Desktop layout
    if (size.width >= 1100 && widget.desktop != null) {
      return widget.desktop!;
    }
    // Tablet layout
    else if (size.width >= 600 && widget.tablet != null) {
      return widget.tablet!;
    }
    // Fallback to mobile layout
    else {
      return widget.mobile;
    }
  }
}