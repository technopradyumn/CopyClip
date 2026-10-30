import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/widgets/ad_widget/banner_ad_widget.dart';

class GlassScaffold extends StatefulWidget {
  static const double drawerWidthFraction = 0.8;

  static void openDrawer(BuildContext context) {
    final state = context.findAncestorStateOfType<_GlassScaffoldState>();
    if (state == null) {
      throw FlutterError('No GlassScaffold found above this context.');
    }
    state._animateDrawerOpen();
  }

  static void closeDrawer(BuildContext context) {
    final state = context.findAncestorStateOfType<_GlassScaffoldState>();
    if (state == null) {
      throw FlutterError('No GlassScaffold found above this context.');
    }
    state._animateDrawerClose();
  }

  final Widget body;
  final Widget? floatingActionButton;
  final dynamic title;
  final List<Widget>? actions;
  final bool showBackArrow;
  final Color? backgroundColor;
  final bool enableGlassEffect;
  final bool resizeToAvoidBottomInset;
  final bool centerTitle;
  final double? titleSpacing;
  final Widget? leading;
  final bool showDrawer;
  final Widget? drawer;

  /// If true, enables real-time finger-following drawer swipe gesture.
  /// The drawer will move smoothly with your finger as you swipe.
  final bool enableRealTimeSwipeDrawer;

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
    this.enableRealTimeSwipeDrawer = true,
  });

  @override
  State<GlassScaffold> createState() => _GlassScaffoldState();
}

class _GlassScaffoldState extends State<GlassScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? _activePointer;
  Offset? _pointerStartPosition;
  double _progressAtPointerStart = 0.0;
  VelocityTracker? _velocityTracker;
  double _dragProgress = 0.0; // 0.0 = closed, 1.0 = fully open
  bool _isDragging = false;
  bool _pointerStartedOutsideDrawer = false;

  static const double _minSwipeDistance =
      20.0; // Min distance to start tracking

  double get _drawerWidth =>
      MediaQuery.sizeOf(context).width * GlassScaffold.drawerWidthFraction;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _drawerController.addListener(() {
      if (!_isDragging && mounted) {
        setState(() {
          _dragProgress = _drawerController.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  bool get _canHandleDrawerGestures =>
      widget.showDrawer &&
      widget.drawer != null &&
      widget.enableRealTimeSwipeDrawer;

  void _handlePointerDown(PointerDownEvent event) {
    if (!_canHandleDrawerGestures || _activePointer != null) return;

    _activePointer = event.pointer;
    _pointerStartPosition = event.position;
    _progressAtPointerStart = _dragProgress;
    _pointerStartedOutsideDrawer =
        _dragProgress > 0.001 &&
        event.localPosition.dx >= _drawerWidth * _dragProgress;
    _velocityTracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.position);
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer || _pointerStartPosition == null) {
      return;
    }

    _velocityTracker?.addPosition(event.timeStamp, event.position);
    final offset = event.position - _pointerStartPosition!;

    if (!_isDragging) {
      if (offset.distance < _minSwipeDistance) return;
      if (offset.dy.abs() > offset.dx.abs()) {
        _resetPointerTracking();
        return;
      }

      final drawerIsOpen = _progressAtPointerStart > 0.001;
      if ((!drawerIsOpen && offset.dx <= 0) ||
          (drawerIsOpen && offset.dx >= 0)) {
        _resetPointerTracking();
        return;
      }

      _drawerController.stop();
      _isDragging = true;
    }

    final progress = (_progressAtPointerStart + offset.dx / _drawerWidth).clamp(
      0.0,
      1.0,
    );
    _drawerController.value = progress;
    setState(() {
      _dragProgress = progress;
    });
  }

  void _handlePointerUp(PointerEvent event) {
    if (event.pointer != _activePointer) return;
    _velocityTracker?.addPosition(event.timeStamp, event.position);
    final velocity = _velocityTracker?.getVelocity().pixelsPerSecond.dx ?? 0;
    final wasDragging = _isDragging;
    final shouldCloseFromOutsideTap =
        _pointerStartedOutsideDrawer && !wasDragging;
    _resetPointerTracking();

    if (!wasDragging) {
      if (shouldCloseFromOutsideTap) _animateDrawerClose();
      return;
    }

    final shouldOpen =
        velocity > 300 || (velocity >= -300 && _dragProgress > 0.4);
    if (shouldOpen) {
      _animateDrawerOpen();
    } else {
      _animateDrawerClose();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (event.pointer != _activePointer) return;
    final wasDragging = _isDragging;
    _resetPointerTracking();
    if (!wasDragging) return;

    if (_dragProgress > 0.4) {
      _animateDrawerOpen();
    } else {
      _animateDrawerClose();
    }
  }

  void _resetPointerTracking() {
    _activePointer = null;
    _pointerStartPosition = null;
    _velocityTracker = null;
    _isDragging = false;
    _pointerStartedOutsideDrawer = false;
  }

  void _handleBackNavigation(bool didPop) {
    if (!didPop && _dragProgress > 0.001) {
      _animateDrawerClose();
    }
  }

  void _animateDrawerOpen() {
    _drawerController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _animateDrawerClose() {
    _drawerController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInCubic,
    );
  }

  void _toggleDrawer() {
    if (_dragProgress > 0.5) {
      _animateDrawerClose();
    } else {
      _animateDrawerOpen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.backgroundColor ?? theme.scaffoldBackgroundColor;
    final bool isDark =
        ThemeData.estimateBrightnessForColor(baseColor) == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;
    final overlayStyle = isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    final bool hasDrawer = widget.showDrawer && widget.drawer != null;

    return PopScope<Object?>(
      canPop: !hasDrawer || _dragProgress <= 0.001,
      onPopInvokedWithResult: (didPop, _) => _handleBackNavigation(didPop),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: _handlePointerDown,
          onPointerMove: _handlePointerMove,
          onPointerUp: _handlePointerUp,
          onPointerCancel: _handlePointerCancel,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                key: _scaffoldKey,
                backgroundColor: baseColor,
                resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                extendBodyBehindAppBar: true,
                drawer: null,
                drawerEnableOpenDragGesture: false,
                appBar: widget.title != null
                    ? AppBar(
                        backgroundColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: widget.centerTitle,
                        titleSpacing: widget.titleSpacing,
                        systemOverlayStyle: overlayStyle,
                        leading:
                            widget.leading ??
                            (widget.showDrawer
                                ? Builder(
                                    builder: (scaffoldContext) => IconButton(
                                      icon: const Icon(
                                        CupertinoIcons.line_horizontal_3,
                                        size: 20,
                                      ),
                                      color: contentColor,
                                      onPressed: _toggleDrawer,
                                    ),
                                  )
                                : (widget.showBackArrow
                                      ? IconButton(
                                          icon: const Icon(
                                            CupertinoIcons.back,
                                            size: 20,
                                          ),
                                          color: contentColor,
                                          onPressed: () {
                                            if (context.canPop()) {
                                              context.pop();
                                            } else {
                                              context.go('/');
                                            }
                                          },
                                        )
                                      : null)),
                        title: widget.title is Widget
                            ? widget.title as Widget
                            : Text(
                                widget.title.toString(),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: contentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                        actions: widget.actions,
                      )
                    : null,
                body: SizedBox.expand(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(child: ColoredBox(color: baseColor)),
                      if (widget.enableGlassEffect)
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
                      Positioned.fill(
                        child: SafeArea(
                          bottom: false,
                          child: Column(children: [Expanded(child: widget.body)]),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: widget.floatingActionButton,
                bottomNavigationBar: const BannerAdWidget(hideOnKeyboard: true),
              ),
              if (hasDrawer)
                Positioned.fill(
                  child: _DrawerBackdrop(
                    progress: _dragProgress,
                    onTap: _animateDrawerClose,
                  ),
                ),
              if (hasDrawer)
                Positioned.fill(
                  child: _RealTimeDrawer(
                    progress: _dragProgress,
                    drawerWidth: _drawerWidth,
                    isDark: isDark,
                    drawer: widget.drawer!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom drawer that slides over the current screen without resizing it.
/// Uses Transform.translate for smooth off-screen positioning
class _RealTimeDrawer extends StatelessWidget {
  final double progress;
  final double drawerWidth;
  final bool isDark;
  final Widget drawer;

  const _RealTimeDrawer({
    required this.progress,
    required this.drawerWidth,
    required this.isDark,
    required this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final bool isClosed = progress <= 0.001;
    final double translateX = -drawerWidth * (1.0 - progress);
    final double opacity = progress.clamp(0.0, 1.0);

    return Offstage(
      offstage: isClosed,
      child: IgnorePointer(
        ignoring: isClosed,
        child: Align(
          alignment: Alignment.topLeft,
          child: Transform.translate(
            offset: Offset(translateX, 0),
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                width: drawerWidth,
                height: MediaQuery.of(context).size.height,
                child: drawer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Backdrop that darkens the main content when drawer opens
class _DrawerBackdrop extends StatelessWidget {
  final double progress;
  final VoidCallback onTap;

  const _DrawerBackdrop({required this.progress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isClosed = progress <= 0.001;

    return Offstage(
      offstage: isClosed,
      child: IgnorePointer(
        ignoring: isClosed,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedOpacity(
            opacity: (progress * 0.4).clamp(0.0, 0.4), // Max 40% dim
            duration: Duration.zero,
            child: const ColoredBox(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
