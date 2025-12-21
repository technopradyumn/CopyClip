import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
    required this.onCopy,
    required this.onShare,
    required this.onDelete,
  });

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24 && date.day == now.day) return '${diff.inHours}h ago';
    if (date.day == now.day - 1) return 'Yesterday';
    return DateFormat('MMM dd').format(date);
  }

  String _stripMarkdown(String markdown) {
    if (markdown.isEmpty) return "No content";
    return markdown
        .replaceAll(RegExp(r'[#*\[\]\(\)`>_]'), '')
        .replaceAll(RegExp(r'\n+'), ' ')
        .trim();
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
        splashRadius: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: 'note_background_${note.id}',
        child: Stack(
          children: [
            GlassContainer(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(12),
              opacity: isSelected ? 0.3 : 0.1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            note.title.isNotEmpty ? note.title : "Untitled",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(fontSize: 17),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        type: MaterialType.transparency,
                        child: Text(
                          _formatTimeAgo(note.updatedAt),
                          style: theme.textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.38)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      _stripMarkdown(note.content),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: theme.dividerColor, height: 1),
                  const SizedBox(height: 4),
                  // ACTION BUTTONS PRESERVED
                  IgnorePointer(
                    ignoring: isSelected, // Disable buttons in selection mode
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildActionButton(context, Icons.copy, onCopy, "Copy"),
                        const SizedBox(width: 12),
                        _buildActionButton(context, Icons.share, onShare, "Share"),
                        const SizedBox(width: 12),
                        _buildActionButton(context, Icons.delete_outline, onDelete, "Delete", isDestructive: true),
                      ],
                    ),
                  ),
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
                    shape: BoxShape.circle,
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