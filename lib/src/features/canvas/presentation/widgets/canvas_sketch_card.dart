import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/const/constant.dart';
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
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.12),
                width: AppConstants.borderWidth,
              ),
            ),
            child: Column(
              children: [
                // Preview Area
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: note.backgroundColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppConstants.cornerRadius - 1),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppConstants.cornerRadius - 1),
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
                                CupertinoIcons.star_fill,
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
                child: const Icon(
                  CupertinoIcons.checkmark_alt,
                  size: 16,
                  color: Colors.white,
                ),
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

    // 1. Calculate Bounds
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    bool hasPoints = false;

    for (var stroke in strokes) {
      for (int i = 0; i < stroke.points.length; i += 2) {
        final x = stroke.points[i];
        final y = stroke.points[i + 1];
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
        hasPoints = true;
      }
    }

    if (!hasPoints) return;

    // Add some padding to bounds
    const padding = 20.0;
    minX -= padding;
    minY -= padding;
    maxX += padding;
    maxY += padding;

    final drawingWidth = maxX - minX;
    final drawingHeight = maxY - minY;

    // 2. Calculate Scale to Fit
    // Ensure we don't divide by zero
    if (drawingWidth <= 0 || drawingHeight <= 0) return;

    final scaleX = size.width / drawingWidth;
    final scaleY = size.height / drawingHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // 3. Center the drawing
    final dx = (size.width - (drawingWidth * scale)) / 2;
    final dy = (size.height - (drawingHeight * scale)) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);
    canvas.translate(-minX, -minY);

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw ALL strokes, not just 15
    for (var stroke in strokes) {
      paint
        ..color = Color(stroke.color)
        ..strokeWidth = stroke.strokeWidth;

      // Optimization: If stroke width is very small after scaling, ensure visibility?
      // Actually standard painting is fine.

      final path = Path();
      if (stroke.points.length >= 2) {
        path.moveTo(stroke.points[0], stroke.points[1]);
        for (int i = 2; i < stroke.points.length - 1; i += 2) {
          path.lineTo(stroke.points[i], stroke.points[i + 1]);
        }
      }
      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
