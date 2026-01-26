import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:go_router/go_router.dart';

class SeamlessHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final String? heroTagPrefix;
  final String? iconHeroTag;
  final String? titleHeroTag;

  final Widget? titleWidget;
  final Widget? customContent;
  final bool showDivider;

  const SeamlessHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.actions,
    this.showBackButton = true,
    this.onBackTap,
    this.heroTagPrefix,
    this.iconHeroTag,
    this.titleHeroTag,
    this.titleWidget,
    this.customContent,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    final String? effectiveIconTag =
        iconHeroTag ?? (heroTagPrefix != null ? '${heroTagPrefix}_icon' : null);
    final String? effectiveTitleTag =
        titleHeroTag ??
        (heroTagPrefix != null ? '${heroTagPrefix}_title' : null);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  icon: Icon(CupertinoIcons.back, color: onSurface, size: 22),
                  onPressed:
                      onBackTap ??
                      () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          context.go('/');
                        }
                      },
                ),

              if (icon != null) ...[
                Hero(
                  tag: effectiveIconTag ?? 'header_icon_$title',
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (iconColor ?? theme.colorScheme.primary)
                          .withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? theme.colorScheme.primary,
                      size: AppConstants.headerIconSize,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              Expanded(
                child:
                    titleWidget ??
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: effectiveTitleTag ?? 'header_title_$title',
                          child: Material(
                            type: MaterialType.transparency,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                title,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: AppConstants.headerTitleSize,
                                  letterSpacing: -1.2,
                                  color: onSurface,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                              fontSize: AppConstants.headerSubtitleSize,
                            ),
                          ),
                      ],
                    ),
              ),

              if (actions != null) ...actions!,
            ],
          ),
        ),

        // Custom content area (search bars, toolbars, etc.)
        if (customContent != null) customContent!,

        // Optional divider
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: theme.dividerColor.withOpacity(0.1),
          ),
      ],
    );
  }
}
