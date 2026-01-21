import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../data/canvas_model.dart';

class CanvasSketchCard extends StatelessWidget {
  final CanvasNote note;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CanvasSketchCard({
    super.key,
    required this.note,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstPage = note.pages.isNotEmpty ? note.pages.first : CanvasPage();

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          GlassContainer(
            color: theme.colorScheme.surface.withOpacity(0.1),
            borderRadius: 24,
            blur: 10,
            child: Column(
              children: [
                // Preview Area
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: note.backgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: CustomPaint(
                        painter: DrawingPreviewPainter(firstPage.strokes),
                      ),
                    ),
                  ),
                ),
                // Info Area
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMM d').format(note.lastModified),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.4,
                                ),
                              ),
                            ),
                            if (note.isFavorite)
                              const Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: Colors.amberAccent,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

class DrawingPreviewPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  DrawingPreviewPainter(this.strokes);
  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty) return;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (var stroke in strokes.take(15)) {
      paint
        ..color = Color(stroke.color)
        ..strokeWidth = stroke.strokeWidth * 0.6;
      final path = Path();
      for (int i = 0; i < stroke.points.length - 2; i += 2) {
        if (i == 0) path.moveTo(stroke.points[i], stroke.points[i + 1]);
        path.lineTo(stroke.points[i + 2], stroke.points[i + 3]);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
