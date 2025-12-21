import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const JournalCard({
    super.key,
    required this.entry,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
    required this.onCopy,
    required this.onShare,
    required this.onDelete,
  });

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Happy': return '😊';
      case 'Excited': return '🤩';
      case 'Neutral': return '😐';
      case 'Sad': return '😔';
      case 'Stressed': return '😫';
      default: return '😐';
    }
  }

  Widget _buildActionButton(BuildContext context, IconData icon, VoidCallback onPressed, String tooltip, {bool isDestructive = false}) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final errorColor = Theme.of(context).colorScheme.error;
    return SizedBox(
      width: 32, height: 32,
      child: IconButton(
          icon: Icon(icon, size: 18, color: isDestructive ? errorColor.withOpacity(0.8) : onSurfaceColor.withOpacity(0.54)),
          onPressed: onPressed,
          tooltip: tooltip,
          padding: EdgeInsets.zero,
          splashRadius: 20
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;
    final dividerColor = theme.dividerColor;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: 'journal_bg_${entry.id}',
        child: Stack(
          children: [
            GlassContainer(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(12),
              opacity: isSelected ? 0.3 : 0.1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Material(type: MaterialType.transparency, child: Text(DateFormat('MMM').format(entry.date).toUpperCase(), style: theme.textTheme.bodySmall?.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor))),
                      Material(type: MaterialType.transparency, child: Text(DateFormat('dd').format(entry.date), style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: onSurfaceColor))),
                      const SizedBox(height: 4),
                      Material(type: MaterialType.transparency, child: Text(_getMoodEmoji(entry.mood), style: const TextStyle(fontSize: 18))),
                      if(entry.isFavorite) ...[
                        const SizedBox(height: 4),
                        const Icon(Icons.star, size: 12, color: Colors.amberAccent),
                      ]
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(width: 1, height: 60, color: dividerColor.withOpacity(0.2)),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            entry.title.isNotEmpty ? entry.title : "Untitled",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: onSurfaceColor),
                          ),
                        ),

                        if (entry.tags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 2),
                            child: Wrap(
                              spacing: 4,
                              children: entry.tags.take(3).map((t) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                                child: Material(
                                    type: MaterialType.transparency,
                                    child: Text("#$t", style: theme.textTheme.bodySmall?.copyWith(color: primaryColor))
                                ),
                              )).toList(),
                            ),
                          ),

                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            entry.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(color: onSurfaceColor.withOpacity(0.7), height: 1.3),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Divider(color: dividerColor),
                        const SizedBox(height: 2),
                        // ACTION BUTTONS PRESERVED
                        IgnorePointer(
                          ignoring: isSelected,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildActionButton(context, Icons.copy, onCopy, "Copy"),
                              const SizedBox(width: 8),
                              _buildActionButton(context, Icons.share, onShare, "Share"),
                              const SizedBox(width: 8),
                              _buildActionButton(context, Icons.delete_outline, onDelete, "Delete", isDestructive: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 10, right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                  child: Icon(Icons.check, size: 12, color: theme.colorScheme.onPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}