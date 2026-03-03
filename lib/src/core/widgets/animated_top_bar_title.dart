import 'package:flutter/material.dart';

class AnimatedTopBarTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? iconHeroTag;
  final String? titleHeroTag;
  final Color? color;
  final double iconSize;
  final TextStyle? textStyle;
  final double spacing;

  const AnimatedTopBarTitle({
    super.key,
    required this.title,
    this.icon,
    this.iconHeroTag,
    this.titleHeroTag,
    this.color,
    this.iconSize = 20.0,
    this.textStyle,
    this.spacing = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor =
        color ??
        (ThemeData.estimateBrightnessForColor(theme.scaffoldBackgroundColor) ==
                Brightness.dark
            ? Colors.white
            : Colors.black87);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          if (iconHeroTag != null)
            Hero(
              tag: iconHeroTag!,
              child: Icon(
                icon,
                size: iconSize,
                color: effectiveColor.withValues(alpha: 0.8),
              ),
            )
          else
            Icon(
              icon,
              size: iconSize,
              color: effectiveColor.withValues(alpha: 0.8),
            ),
          SizedBox(width: spacing),
        ],
        if (titleHeroTag != null)
          Flexible(
            child: Hero(
              tag: titleHeroTag!,
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style:
                      textStyle ??
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: effectiveColor,
                      ),
                ),
              ),
            ),
          )
        else
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style:
                  textStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: effectiveColor,
                  ),
            ),
          ),
      ],
    );
  }
}
