import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/const/constant.dart';
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
    final count = CanvasDatabase().getNoteCount(folder.id);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: 'canvas_folder_${folder.id}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: isSelected
              ? Matrix4.identity().scaled(0.96)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: folder.color.withValues(alpha: isSelected ? 0.3 : 0.45),
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : folder.color.withValues(alpha: 0.35),
              width: isSelected ? 2.5 : AppConstants.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: folder.color.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Abstract Folder Shape Background
              Positioned(
                right: -10,
                top: -10,
                child: Icon(
                  CupertinoIcons.folder_fill,
                  size: 100,
                  color: folder.color.withValues(alpha: 0.12),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: folder.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        CupertinoIcons.folder_open,
                        size: 26,
                        color: folder.color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      folder.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$count ${count == 1 ? 'sketch' : 'sketches'}",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Selection Checkmark Overlay
              if (isSelected)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.checkmark,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
