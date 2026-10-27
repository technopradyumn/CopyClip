import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/widgets/ad_widget/banner_ad_widget.dart';

class GlassScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final dynamic title;
  final List<Widget>? actions;
  final bool showBackArrow;
  final Color? backgroundColor;
  // enableGlassEffect is now ignored for performance, or used to toggle gradients
  final bool enableGlassEffect;
  final bool resizeToAvoidBottomInset;
  final bool centerTitle;
  final double? titleSpacing;
  final Widget? leading;
  final bool showDrawer;
  final Widget? drawer;

  const GlassScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.title,
    this.actions,
    this.showBackArrow = false,
    this.backgroundColor,
    this.enableGlassEffect = true,
    this.resizeToAvoidBottomInset = true,
    this.centerTitle = true,
    this.titleSpacing,
    this.leading,
    this.showDrawer = false,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = backgroundColor ?? theme.scaffoldBackgroundColor;
    final bool isDark =
        ThemeData.estimateBrightnessForColor(baseColor) == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;
    final overlayStyle = isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: baseColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: true,
        drawer: drawer,
        drawerEnableOpenDragGesture: false,
        appBar: title != null
            ? AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                centerTitle: centerTitle,
                titleSpacing: titleSpacing,
                systemOverlayStyle: overlayStyle,
                leading:
                    leading ??
                    (showDrawer
                        ? Builder(
                            builder: (scaffoldContext) => IconButton(
                              icon: const Icon(
                                CupertinoIcons.line_horizontal_3,
                                size: 20,
                              ),
                              color: contentColor,
                              onPressed: () =>
                                  Scaffold.of(scaffoldContext).openDrawer(),
                            ),
                          )
                        : (showBackArrow
                              ? IconButton(
                                  icon: Icon(
                                    CupertinoIcons.back,
                                    size: 20,
                                    color: contentColor,
                                  ),
                                  onPressed: () {
                                    if (context.canPop()) {
                                      context.pop();
                                    } else {
                                      context.go('/');
                                    }
                                  },
                                )
                              : null)),
                title: title is Widget
                    ? title as Widget
                    : Text(
                        title.toString(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: contentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                actions: actions,
              )
            : null,
        body: Stack(
          children: [
            // 1. Solid Background
            Positioned.fill(child: ColoredBox(color: baseColor)),

            // 2. High-Performance Gradient Overlay (Replaces Blur)
            // This mimics the depth of glass without the expensive calculation
            if (enableGlassEffect)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Colors.white.withValues(alpha: 0.05),
                              Colors.transparent,
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.4),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                    ),
                  ),
                ),
              ),

            // 3. Body Content (SafeArea applied here)
            Positioned.fill(
              child: SafeArea(
                // Remove bottom SafeArea if you want content to go behind nav bar,
                // but usually true is safer for lists
                bottom: false,
                child: Column(children: [Expanded(child: body)]),
              ),
            ),
            if (showDrawer && drawer != null)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 24,
                child: Builder(
                  builder: (scaffoldContext) {
                    var dragDistance = 0.0;
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragStart: (_) => dragDistance = 0,
                      onHorizontalDragUpdate: (details) {
                        dragDistance += details.primaryDelta ?? 0;
                      },
                      onHorizontalDragEnd: (_) {
                        final shouldOpen = dragDistance > 80;
                        dragDistance = 0;
                        if (shouldOpen && scaffoldContext.mounted) {
                          Scaffold.of(scaffoldContext).openDrawer();
                        }
                      },
                      onHorizontalDragCancel: () => dragDistance = 0,
                      child: const SizedBox.expand(),
                    );
                  },
                ),
              ),
          ],
        ),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: const BannerAdWidget(hideOnKeyboard: true),
      ),
    );
  }
}
