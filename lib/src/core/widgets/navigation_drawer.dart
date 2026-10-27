import 'dart:math' as math;

import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/core/utils/app_assets.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CopyClipDrawer extends StatefulWidget {
  const CopyClipDrawer({super.key});

  @override
  State<CopyClipDrawer> createState() => _CopyClipDrawerState();
}

class _CopyClipDrawerState extends State<CopyClipDrawer> {
  final _searchController = TextEditingController();
  late final GoRouter _router;
  bool _isThemeTransitionRunning = false;

  @override
  void initState() {
    super.initState();
    _router = GoRouter.of(context);
    // Rebuild whenever the route changes so the active drawer item stays in sync
    _router.routeInformationProvider.addListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _router.routeInformationProvider.removeListener(_onRouteChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// The current route path (e.g. `/notes`, `/todos`).
  String _routeLocation() => _router.routeInformationProvider.value.uri.path;

  /// Always synchronize the visible section with the selected drawer item.
  void _navigate(BuildContext context, String route) {
    Scaffold.of(context).closeDrawer();
    context.go(route);
  }

  void _changeThemeMode(ThemeMode mode, Offset globalPosition) {
    if (_isThemeTransitionRunning) return;

    final themeBloc = context.read<ThemeBloc>();
    if (themeBloc.state.themeMode == mode) return;

    final oldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final overlay = Overlay.of(context, rootOverlay: true);
    final overlayObject = overlay.context.findRenderObject();
    if (overlayObject is! RenderBox) {
      themeBloc.add(ChangeThemeMode(mode));
      return;
    }

    final origin = overlayObject.globalToLocal(globalPosition);
    late final OverlayEntry entry;
    setState(() => _isThemeTransitionRunning = true);
    entry = OverlayEntry(
      builder: (_) => _CircularThemeReveal(
        origin: origin,
        backgroundColor: oldBackgroundColor,
        onCompleted: () {
          entry.remove();
          entry.dispose();
          if (mounted) {
            setState(() => _isThemeTransitionRunning = false);
          }
        },
      ),
    );
    overlay.insert(entry);
    themeBloc.add(ChangeThemeMode(mode));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark =
        ThemeData.estimateBrightnessForColor(colorScheme.surface) ==
        Brightness.dark;

    // Current route used to highlight the active item in the panel.
    final currentLocation = _routeLocation();

    // Keep the toggle in sync with the theme bloc.
    final themeMode = context.read<ThemeBloc>().state.themeMode;
    final isPremium = context.watch<PremiumBloc>().state.isPremium;

    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(
            context,
          ).size.width.clamp(240, 320)).toDouble(),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0E0E12).withValues(alpha: 0.96),
                    const Color(0xFF16161C).withValues(alpha: 0.96),
                  ]
                : [
                    const Color(0xFFFFFFFF).withValues(alpha: 0.96),
                    const Color(0xFFF5F6F9).withValues(alpha: 0.96),
                  ],
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(26),
            bottomRight: Radius.circular(26),
          ),
          border: Border(
            right: BorderSide(
              color: colorScheme.outline.withValues(
                alpha: isDark ? 0.28 : 0.12,
              ),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.14),
              blurRadius: 44,
              offset: const Offset(14, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(26),
            bottomRight: Radius.circular(26),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _DrawerHeader(
                accent: theme.colorScheme.primary,
                isDark: isDark,
                isPremium: isPremium,
              ),
              const SizedBox(height: 8),

              // ---------- Global search ----------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: _DrawerSearchBar(
                  controller: _searchController,
                  hint: l10n?.search ?? 'Search',
                  onSubmitted: (query) {
                    _searchController.clear();
                    if (query.trim().isNotEmpty) {
                      Scaffold.of(context).closeDrawer();
                      context.push(
                        Uri(
                          path: AppRouter.globalSearch,
                          queryParameters: {'q': query.trim()},
                        ).toString(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),

              // ---------- Features ----------
              _DrawerSectionLabel(context, l10n?.overview ?? 'Your Features'),
              _DrawerItem(
                context: context,
                icon: CupertinoIcons.doc_text,
                title: l10n?.notes ?? 'Notes',
                subtitle:
                    l10n?.featuresNotesDesc ?? 'Create and manage your notes',
                color: FeatureColors.notes,
                route: AppRouter.notes,
                isActive: currentLocation == AppRouter.notes,
                onTap: () => _navigate(context, AppRouter.notes),
              ),
              _DrawerItem(
                context: context,
                icon: CupertinoIcons.checkmark_circle,
                title: l10n?.todos ?? 'To-Dos',
                subtitle: l10n?.featuresTodosDesc ?? 'Keep track of your tasks',
                color: FeatureColors.todos,
                route: AppRouter.todos,
                isActive: currentLocation == AppRouter.todos,
                onTap: () => _navigate(context, AppRouter.todos),
              ),
              _DrawerItem(
                context: context,
                icon: CupertinoIcons.book,
                title: l10n?.journal ?? 'Journal',
                subtitle:
                    l10n?.featuresJournalDesc ?? 'Write down your thoughts',
                color: FeatureColors.journal,
                route: AppRouter.journal,
                isActive: currentLocation == AppRouter.journal,
                onTap: () => _navigate(context, AppRouter.journal),
              ),
              _DrawerItem(
                context: context,
                icon: CupertinoIcons.doc_on_clipboard,
                title: l10n?.clipboard ?? 'Clipboard',
                subtitle:
                    l10n?.featuresClipboardDesc ??
                    'Access your clipboard history',
                color: FeatureColors.clipboard,
                route: AppRouter.clipboard,
                isActive: currentLocation == AppRouter.clipboard,
                onTap: () => _navigate(context, AppRouter.clipboard),
              ),

              const SizedBox(height: 12),
              _DrawerSectionLabel(context, l10n?.settings ?? 'Settings'),
              _DrawerItem(
                context: context,
                icon: CupertinoIcons.settings,
                title: l10n?.settings ?? 'Settings',
                subtitle: l10n?.settingsSubtitle ?? 'Customize Your Experience',
                color: colorScheme.primary,
                route: AppRouter.settings,
                isActive: currentLocation == AppRouter.settings,
                onTap: () => _navigate(context, AppRouter.settings),
              ),
              _DrawerItem(
                context: context,
                icon: CupertinoIcons.delete,
                title: l10n?.recycleBin ?? 'Recycle Bin',
                color: colorScheme.error,
                route: AppRouter.recycleBin,
                isActive: currentLocation == AppRouter.recycleBin,
                onTap: () => _navigate(context, AppRouter.recycleBin),
              ),
              _DrawerItem(
                context: context,
                icon: CupertinoIcons.doc_text,
                title: l10n?.privacyPolicy ?? 'Privacy Policy',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                route: AppRouter.privacyPolicy,
                isActive: currentLocation == AppRouter.privacyPolicy,
                onTap: () => _navigate(context, AppRouter.privacyPolicy),
              ),
              _DrawerItem(
                context: context,
                icon: CupertinoIcons.chat_bubble,
                title: l10n?.sendFeedback ?? 'Send Feedback',
                color: colorScheme.primary,
                route: AppRouter.feedback,
                isActive: currentLocation == AppRouter.feedback,
                onTap: () => _navigate(context, AppRouter.feedback),
              ),

              // _DrawerItem(
              //   context: context,
              //   icon: CupertinoIcons.star,
              //   title: l10n?.premium ?? 'Premium',
              //   subtitle: 'Unlock everything',
              //   color: const Color(0xFFFFB74D),
              //   route: AppRouter.premium,
              //   onTap: () => _navigate(context, AppRouter.premium),
              // ),
              const SizedBox(height: 16),
              _DrawerDivider(label: 'Appearance'),

              _ThemeModeTile(
                title: l10n?.themeMode ?? 'Theme Mode',
                selectedMode: themeMode,
                accent: FeatureColors.journal,
                onSelected: _isThemeTransitionRunning ? null : _changeThemeMode,
              ),

              const SizedBox(height: 22),
              _DrawerFooter(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile({
    required this.title,
    required this.selectedMode,
    required this.accent,
    required this.onSelected,
  });

  final String title;
  final ThemeMode selectedMode;
  final Color accent;
  final void Function(ThemeMode mode, Offset globalPosition)? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final l10n = AppLocalizations.of(context);
    final options = [
      (mode: ThemeMode.system, label: l10n?.system ?? 'System'),
      (mode: ThemeMode.light, label: l10n?.light ?? 'Light'),
      (mode: ThemeMode.dark, label: l10n?.dark ?? 'Dark'),
    ];

    return Container(
      key: const ValueKey('theme_mode_tile'),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: onSurface.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  switch (selectedMode) {
                    ThemeMode.system => CupertinoIcons.device_phone_portrait,
                    ThemeMode.light => CupertinoIcons.sun_max,
                    ThemeMode.dark => CupertinoIcons.moon,
                  },
                  color: accent,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final option in options)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _ThemeModeOption(
                      key: ValueKey('theme_mode_${option.mode.name}'),
                      label: option.label,
                      selected: selectedMode == option.mode,
                      accent: accent,
                      onTap: onSelected == null
                          ? null
                          : (position) => onSelected!(option.mode, position),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  const _ThemeModeOption({
    super.key,
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final ValueChanged<Offset>? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTapUp: onTap == null
            ? null
            : (details) => onTap!(details.globalPosition),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: 0.16)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: selected
                  ? accent.withValues(alpha: 0.42)
                  : colorScheme.outline.withValues(alpha: 0.13),
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected
                  ? accent
                  : colorScheme.onSurface.withValues(alpha: 0.72),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularThemeReveal extends StatefulWidget {
  const _CircularThemeReveal({
    required this.origin,
    required this.backgroundColor,
    required this.onCompleted,
  });

  final Offset origin;
  final Color backgroundColor;
  final VoidCallback onCompleted;

  @override
  State<_CircularThemeReveal> createState() => _CircularThemeRevealState();
}

class _CircularThemeRevealState extends State<_CircularThemeReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onCompleted();
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, _) => CustomPaint(
            painter: _CircularThemeRevealPainter(
              progress: _progress.value,
              origin: widget.origin,
              backgroundColor: widget.backgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularThemeRevealPainter extends CustomPainter {
  const _CircularThemeRevealPainter({
    required this.progress,
    required this.origin,
    required this.backgroundColor,
  });

  final double progress;
  final Offset origin;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final farthestX = math.max(origin.dx, size.width - origin.dx);
    final farthestY = math.max(origin.dy, size.height - origin.dy);
    final radius = math.sqrt(farthestX * farthestX + farthestY * farthestY);

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, Paint()..color = backgroundColor);
    canvas.drawCircle(
      origin,
      radius * progress,
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CircularThemeRevealPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      origin != oldDelegate.origin ||
      backgroundColor != oldDelegate.backgroundColor;
}

class _DrawerHeader extends StatelessWidget {
  final Color accent;
  final bool isDark;
  final bool isPremium;

  const _DrawerHeader({
    required this.accent,
    required this.isDark,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 46, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent.withValues(alpha: 0.85), accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.5),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Image.asset(AppAssets.imageGround),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CopyClip',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n?.productivityCompanion ??
                          'Your productivity companion',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: onSurface.withValues(alpha: 0.68),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              // if (isPremium) ...[
              //   const SizedBox(width: 10),
              //   Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 10,
              //       vertical: 5,
              //     ),
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         colors: [Color(0xFFFFB74D), Color(0xFFFF8C42)],
              //       ),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: const Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(CupertinoIcons.star_fill, size: 12,
              //             color: Colors.black),
              //         SizedBox(width: 6),
              //         Text(
              //           'Premium',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontWeight: FontWeight.w800,
              //             fontSize: 11,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onSubmitted;

  const _DrawerSearchBar({
    required this.controller,
    required this.hint,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.16),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: theme.textTheme.bodyMedium?.copyWith(color: onSurface),
        cursorColor: theme.colorScheme.primary,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: onSurface.withValues(alpha: 0.52),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: onSurface.withValues(alpha: 0.62),
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              CupertinoIcons.xmark_circle,
              color: onSurface.withValues(alpha: 0.5),
              size: 18,
            ),
            onPressed: controller.clear,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          isDense: true,
        ),
      ),
    );
  }
}

class _DrawerSectionLabel extends StatelessWidget {
  final BuildContext context;
  final String label;

  const _DrawerSectionLabel(this.context, this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 16, 10),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          fontWeight: FontWeight.w800,
          letterSpacing: 1.8,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _DrawerDivider extends StatelessWidget {
  final String label;

  const _DrawerDivider({this.label = ''});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.outline.withValues(alpha: 0.14);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Divider(color: color, height: 1)),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 12),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                fontWeight: FontWeight.w800,
                fontSize: 10.5,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(child: Divider(color: color, height: 1)),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final String route;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.context,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    this.route = '',
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;

    final pressed = ValueNotifier<bool>(false);

    return ValueListenableBuilder<bool>(
      valueListenable: pressed,
      builder: (context, isPressed, _) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onHighlightChanged: (value) => pressed.value = value,
            borderRadius: BorderRadius.circular(17),
            splashColor: color.withValues(alpha: isActive ? 0.16 : 0.07),
            highlightColor: color.withValues(alpha: isActive ? 0.1 : 0.04),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              decoration: BoxDecoration(
                color: isActive
                    ? color.withValues(alpha: 0.13)
                    : (isPressed
                          ? color.withValues(alpha: 0.07)
                          : Colors.transparent),
                borderRadius: BorderRadius.circular(17),
                border: isActive
                    ? Border.all(
                        color: color.withValues(alpha: 0.4),
                        width: 1.2,
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.92), color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, color: Colors.white, size: 23),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: isActive
                                  ? color
                                  : onSurface.withValues(alpha: 0.94),
                              fontWeight: FontWeight.w700,
                              fontSize: 16.5,
                              letterSpacing: -0.4,
                            ),
                          ),
                          if (subtitle != null && subtitle!.isNotEmpty)
                            const SizedBox(height: 4),
                          if (subtitle != null && subtitle!.isNotEmpty)
                            Text(
                              subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: onSurface.withValues(alpha: 0.58),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      color: onSurface.withValues(alpha: 0.42),
                      size: 19,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  final BuildContext context;

  const _DrawerFooter(this.context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 20, 4),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Icon(
              CupertinoIcons.info_circle,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.version ?? 'Version',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '1.0.0 · build 100',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
