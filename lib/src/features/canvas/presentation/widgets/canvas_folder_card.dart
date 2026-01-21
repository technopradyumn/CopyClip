import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../data/canvas_adapter.dart';
import '../../data/canvas_model.dart';

class CanvasFolderCard extends StatelessWidget {
  final CanvasFolder folder;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CanvasFolderCard({
    super.key,
    required this.folder,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          // Main Card Content
          GlassContainer(
            color: folder.color.withOpacity(isSelected ? 0.3 : 0.15),
            borderRadius: 24,
            blur: 15,
            // 1. Force the container to fill the GridCell
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Hero(
                      tag: 'folder_${folder.id}',
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: folder.color.withOpacity(0.2),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                          ),
                        ),
                        child: Icon(
                          Icons.folder_open_rounded,
                          size: 22,
                          color: folder.color,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Hero(
                          tag: 'folder_name_${folder.id}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              folder.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${CanvasDatabase().getNoteCount(folder.id)} sketches",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Selection Checkmark Overlay
          if (isSelected)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
