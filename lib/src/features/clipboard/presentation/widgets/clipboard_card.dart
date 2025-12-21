import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';

class ClipboardCard extends StatelessWidget {
  final ClipboardItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const ClipboardCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
    required this.onCopy,
    required this.onShare,
    required this.onDelete,
  });

  IconData _getTypeIconData(String type) {
    switch (type) {
      case 'link': return Icons.link;
      case 'phone': return Icons.phone;
      default: return Icons.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Hero(
        tag: 'clip_bg_${item.id}',
        child: Stack(
          children: [
            GlassContainer(
              opacity: isSelected ? 0.3 : 0.1,
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_getTypeIconData(item.type), color: theme.colorScheme.primary.withOpacity(0.5), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            item.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: Text(
                          DateFormat('MMM dd, h:mm a').format(item.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurfaceColor.withOpacity(0.38)
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: isSelected,
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.copy, size: 18, color: onSurfaceColor.withOpacity(0.38)),
                                onPressed: onCopy
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                                icon: Icon(Icons.share, size: 18, color: onSurfaceColor.withOpacity(0.38)),
                                onPressed: onShare
                            ),
                            const SizedBox(width: 4),
                            // Added Delete Button
                            IconButton(
                                icon: Icon(Icons.delete_outline, size: 18, color: errorColor.withOpacity(0.8)),
                                onPressed: onDelete
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle
                  ),
                  child: Icon(Icons.check, size: 14, color: theme.colorScheme.onPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}