import 'package:flutter/material.dart';
import 'package:copyclip/src/features/social_post/data/social_post_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';

class SocialPostCard extends StatelessWidget {
  final SocialPost post;
  final VoidCallback onTap;

  const SocialPostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  String _getPreviewText(String content) {
    if (!content.startsWith('[')) return content;
    try {
      final List<dynamic> delta = jsonDecode(content);
      final buffer = StringBuffer();
      for (var op in delta) {
        if (op is Map<String, dynamic> && op['insert'] is String) {
          buffer.write(op['insert']);
        }
      }
      return buffer.toString().trim().replaceAll('\n', ' ');
    } catch (_) {
      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withAlpha(isDark ? 10 : 200),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withAlpha(50),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Social Post",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  timeago.format(post.updatedAt),
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getPreviewText(post.content),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
