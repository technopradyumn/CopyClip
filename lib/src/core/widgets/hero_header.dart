import 'package:flutter/material.dart';

class HeroHeader extends StatelessWidget {
  final String tagPrefix;
  final String title;
  final IconData icon;
  final Color color;

  const HeroHeader({
    super.key,
    required this.tagPrefix,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Row(
        children: [
          Hero(
            tag: '${tagPrefix}_icon',
            child: Icon(icon, size: 50, color: color),
          ),
          const SizedBox(width: 16),
          Hero(
            tag: '${tagPrefix}_title',
            child: Material(
              color: Colors.transparent,
              child: Text(
                title,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onSurfaceColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}