import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/widgets/ad_widget/banner_ad_widget.dart';

class GlassScaffold extends StatefulWidget {
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

class _GlassScaffoldState extends State<GlassScaffold> with SingleTickerProviderStateMixin {
  late AnimationController _drawerController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Real-time swipe tracking
  double _dragProgress = 0.0; // 0.0 = closed, 1.0 = fully open
  bool _isDragging = false;
  double _dragStartX = 0;
  bool _wasDrawerOpen = false;

  static const double _drawerWidth = 320.0; // Max drawer width
  static const double _minSwipeDistance = 20.0; // Min distance to start tracking
  static const double _maxVerticalDeviation = 80.0;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _drawerController.addListener(() {
      if (!_isDragging) {
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

  void _handleDragStart(DragStartDetails details) {
    if (!widget.showDrawer || widget.drawer == null || !widget.enableRealTimeSwipeDrawer) return;

    _dragStartX = details.globalPosition.dx;
    _wasDrawerOpen = _dragProgress > 0.5;
    _isDragging = true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || !widget.showDrawer || widget.drawer == null) return;

    final currentX = details.globalPosition.dx;
    final deltaX = currentX - _dragStartX;
    final verticalDelta = (details.globalPosition.dy - details.globalPosition.dy).abs();

    // Cancel if vertical scroll detected
    if (verticalDelta > _maxVerticalDeviation) {
      _cancelDrag();
      return;
    }

    // Only allow rightward swipe to open, leftward to close
    if (deltaX < -_minSwipeDistance && _dragProgress <= 0.01) {
      // Swiping left from closed position - ignore
      return;
    }

    // Calculate progress (0.0 to 1.0)
    // Drawer opens as finger moves right
    final targetProgress = (_dragProgress + deltaX / _drawerWidth).clamp(0.0, 1.0);

    setState(() {
      _dragProgress = targetProgress;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging || !widget.showDrawer || widget.drawer == null) return;

    final velocity = details.velocity.pixelsPerSecond.dx;
    final shouldOpen = velocity > 300 || _dragProgress > 0.4;

    _isDragging = false;

    if (shouldOpen) {
      _animateDrawerOpen();
    } else {
      _animateDrawerClose();
    }
  }

  void _handleDragCancel() {
    _cancelDrag();
  }

  void _cancelDrag() {
    if (!_isDragging) return;
    _isDragging = false;
    if (_wasDrawerOpen || _dragProgress > 0.4) {
      _animateDrawerOpen();
    } else {
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: baseColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        extendBodyBehindAppBar: true,
        // Disable built-in drawer since we use custom real-time drawer
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
        body: Stack(
          children: [
            // 1. Solid Background
            Positioned.fill(child: ColoredBox(color: baseColor)),

            // 2. High-Performance Gradient Overlay (Replaces Blur)
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

            // 3. Main Body Content with Real-Time Swipe Detection
            Positioned.fill(
              child: SafeArea(
                bottom: false,
                child: hasDrawer && widget.enableRealTimeSwipeDrawer
                    ? _RealTimeSwipeDetector(
                        onDragStart: _handleDragStart,
                        onDragUpdate: _handleDragUpdate,
                        onDragEnd: _handleDragEnd,
                        onDragCancel: _handleDragCancel,
                        child: Column(
                          children: [
                            Expanded(child: widget.body),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(child: widget.body),
                        ],
                      ),
              ),
            ),

            // 4. Custom Real-Time Drawer Overlay
            if (hasDrawer)
              _RealTimeDrawer(
                progress: _dragProgress,
                drawerWidth: _drawerWidth,
                isDark: isDark,
                drawer: widget.drawer!,
                onTapClose: _animateDrawerClose,
              ),

            // 5. Dimmed backdrop when drawer is opening
            if (hasDrawer && _dragProgress > 0)
              _DrawerBackdrop(
                progress: _dragProgress,
                onTap: _animateDrawerClose,
              ),
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
        bottomNavigationBar: const BannerAdWidget(hideOnKeyboard: true),
      ),
    );
  }
}

/// Real-time swipe detector that only handles horizontal drag
/// Allows vertical scroll to pass through to child
class _RealTimeSwipeDetector extends StatefulWidget {
  final Widget child;
  final GestureDragStartCallback onDragStart;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;
  final GestureDragCancelCallback onDragCancel;

  const _RealTimeSwipeDetector({
    required this.child,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
  });

  @override
  State<_RealTimeSwipeDetector> createState() => _RealTimeSwipeDetectorState();
}

class _RealTimeSwipeDetectorState extends State<_RealTimeSwipeDetector> {
  // Use a horizontal drag gesture recognizer that competes with child scrollables
  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        // Start tracking for horizontal drag
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        // Only handle horizontal drag, let vertical scroll pass through
        onHorizontalDragStart: widget.onDragStart,
        onHorizontalDragUpdate: widget.onDragUpdate,
        onHorizontalDragEnd: widget.onDragEnd,
        onHorizontalDragCancel: widget.onDragCancel,
        child: widget.child,
      ),
    );
  }
}

/// Custom drawer that animates position/scale/opacity based on progress
class _RealTimeDrawer extends StatelessWidget {
  final double progress;
  final double drawerWidth;
  final bool isDark;
  final Widget drawer;
  final VoidCallback onTapClose;

  const _RealTimeDrawer({
    required this.progress,
    required this.drawerWidth,
    required this.isDark,
    required this.drawer,
    required this.onTapClose,
  });

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    // Calculate drawer position - slides in from left
    final double translateX = -drawerWidth * (1.0 - progress);
    // Scale effect for depth
    final double scale = 0.95 + (0.05 * progress);
    // Opacity
    final double opacity = progress;

    return AnimatedPositioned(
      duration: Duration.zero, // We control animation via progress value
      left: translateX,
      top: 0,
      bottom: 0,
      width: drawerWidth,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.centerLeft,
        child: Opacity(
          opacity: opacity,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: onTapClose,
              behavior: HitTestBehavior.translucent,
              // Prevent taps on drawer from closing it
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: drawerWidth,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF0E0E12).withValues(alpha: 0.98),
                            const Color(0xFF16161C).withValues(alpha: 0.98),
                          ]
                        : [
                            const Color(0xFFFFFFFF).withValues(alpha: 0.98),
                            const Color(0xFFF5F6F9).withValues(alpha: 0.98),
                          ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                  border: Border(
                    right: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withValues(
                            alpha: isDark ? 0.28 : 0.12,
                          ),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.2),
                      blurRadius: 50,
                      offset: const Offset(20, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                  child: drawer,
                ),
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

  const _DrawerBackdrop({
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: progress * 0.4, // Max 40% dim
      duration: Duration.zero,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: ColoredBox(
          color: Colors.black,
        ),
      ),
    );
  }
}