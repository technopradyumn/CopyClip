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
      child: Hero(
        tag: 'canvas_card_${note.id}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: isSelected
              ? Matrix4.identity().scaled(0.96)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 
              isSelected ? 0.4 : 0.6,
            ),
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.12),
              width: isSelected ? 2.5 : AppConstants.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: (isSelected ? theme.colorScheme.primary : Colors.black)
                    .withValues(alpha: isSelected ? 0.2 : 0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            child: Stack(
              children: [
                Column(
                  children: [
                    // Preview Area (Paper Aspect Ratio)
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: note.backgroundColor,
                          border: Border(
                            bottom: BorderSide(
                              color: theme.colorScheme.onSurface.withValues(alpha: 
                                0.05,
                              ),
                              width: 1,
                            ),
                          ),
                        ),
                        child: CustomPaint(
                          painter: DrawingPreviewPainter(firstPage.strokes),
                        ),
                      ),
                    ),
                    // Info Area
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              note.title.isNotEmpty
                                  ? note.title
                                  : "Untitled Sketch",
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat(
                                    'MMM d, yyyy',
                                  ).format(note.lastModified),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
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

    if (drawingWidth <= 0 || drawingHeight <= 0) return;

    final scaleX = size.width / drawingWidth;
    final scaleY = size.height / drawingHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final dx = (size.width - (drawingWidth * scale)) / 2;
    final dy = (size.height - (drawingHeight * scale)) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);
    canvas.translate(-minX, -minY);

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var stroke in strokes) {
      paint
        ..color = Color(stroke.color)
        ..strokeWidth = stroke.strokeWidth;

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
