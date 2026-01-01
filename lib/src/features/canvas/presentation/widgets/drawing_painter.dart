import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import '../../data/canvas_model.dart';
import '../pages/canvas_edit_screen.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final Color backgroundColor;

  DrawingPainter(this.strokes, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      if (stroke.points.length < 2) continue;

      final brushShape = BrushShape.values[stroke.penType.clamp(0, BrushShape.values.length - 1)];

      final paint = Paint()
        ..color = Color(stroke.color)
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      // --- ROUTING LOGIC ---
      if (_isBristleBrush(brushShape)) {
        _drawBristles(canvas, stroke, paint, brushShape);
      } else if (_isParticleBrush(brushShape)) {
        _drawParticles(canvas, stroke, paint, brushShape);
      } else if (_isCalligraphicBrush(brushShape)) {
        _drawCalligraphic(canvas, stroke, paint, brushShape);
      } else if (_isEffectBrush(brushShape)) {
        _drawEffects(canvas, stroke, paint, brushShape);
      } else {
        _drawStandard(canvas, stroke, paint, brushShape);
      }
    }
  }

  // --- 1. BRISTLE / HAIR BRUSHES (Oil, Sketch, Ink) ---
  bool _isBristleBrush(BrushShape shape) {
    return [
      BrushShape.oilBrush,
      BrushShape.sketchBrush,
      BrushShape.inkBrush,
      BrushShape.shadingBrush,
    ].contains(shape);
  }

  void _drawBristles(Canvas canvas, DrawingStroke stroke, Paint paint, BrushShape shape) {
    final random = Random(stroke.points.hashCode);

    // Config based on brush type
    int hairs;
    double spread;
    double opacityMultiplier;

    switch (shape) {
      case BrushShape.oilBrush:
        hairs = 10;
        spread = 0.8;
        opacityMultiplier = 0.6;
        break;
      case BrushShape.sketchBrush:
        hairs = 5;
        spread = 1.5;
        opacityMultiplier = 0.4;
        break;
      case BrushShape.shadingBrush:
        hairs = 20;
        spread = 2.0;
        opacityMultiplier = 0.1;
        break;
      default: // Ink
        hairs = 3;
        spread = 0.3;
        opacityMultiplier = 0.8;
    }

    paint.color = paint.color.withOpacity(paint.color.opacity * opacityMultiplier);
    // Bristles are thinner than the main stroke width
    paint.strokeWidth = max(1.0, stroke.strokeWidth / (hairs / 2));

    for (int i = 0; i < stroke.points.length - 2; i += 2) {
      final p1 = Offset(stroke.points[i], stroke.points[i + 1]);
      final p2 = Offset(stroke.points[i + 2], stroke.points[i + 3]);

      // Draw multiple parallel lines with jitter to simulate hairs
      for (int h = 0; h < hairs; h++) {
        // Calculate a random offset for each hair
        final offsetX = (random.nextDouble() - 0.5) * stroke.strokeWidth * spread;
        final offsetY = (random.nextDouble() - 0.5) * stroke.strokeWidth * spread;

        canvas.drawLine(
          p1.translate(offsetX, offsetY),
          p2.translate(offsetX, offsetY),
          paint,
        );
      }
    }
  }

  // --- 2. PARTICLE / TEXTURE BRUSHES (Spray, Charcoal, Crayon) ---
  bool _isParticleBrush(BrushShape shape) {
    return [
      BrushShape.spray,
      BrushShape.sprayPaint,
      BrushShape.airBrush,
      BrushShape.charcoal,
      BrushShape.crayon,
      BrushShape.pixelBrush,
    ].contains(shape);
  }

  void _drawParticles(Canvas canvas, DrawingStroke stroke, Paint paint, BrushShape shape) {
    final random = Random(stroke.points.hashCode);

    if (shape == BrushShape.pixelBrush) {
      paint.style = PaintingStyle.fill;
      for (int i = 0; i < stroke.points.length; i += 2) {
        // Snap to grid logic
        final x = (stroke.points[i] / stroke.strokeWidth).floor() * stroke.strokeWidth;
        final y = (stroke.points[i + 1] / stroke.strokeWidth).floor() * stroke.strokeWidth;
        canvas.drawRect(
          Rect.fromLTWH(x, y, stroke.strokeWidth, stroke.strokeWidth),
          paint,
        );
      }
      return;
    }

    // Config
    int density;
    double scatterRadius;
    bool drawDots; // if true draws circles, if false draws jittered lines

    switch (shape) {
      case BrushShape.airBrush:
        density = 15;
        scatterRadius = 1.0;
        drawDots = true;
        paint.color = paint.color.withOpacity(0.3);
        break;
      case BrushShape.sprayPaint:
        density = 40;
        scatterRadius = 1.5;
        drawDots = true;
        paint.color = paint.color.withOpacity(0.8);
        break;
      case BrushShape.charcoal:
        density = 5;
        scatterRadius = 0.5;
        drawDots = false; // Jittered lines
        paint.color = paint.color.withOpacity(0.6);
        break;
      case BrushShape.crayon:
      default:
        density = 3;
        scatterRadius = 0.3;
        drawDots = false;
        paint.color = paint.color.withOpacity(0.9);
        break;
    }

    for (int i = 0; i < stroke.points.length; i += 2) {
      final center = Offset(stroke.points[i], stroke.points[i + 1]);

      if (drawDots) {
        // Spray/Airbrush logic
        for (int d = 0; d < density; d++) {
          final angle = random.nextDouble() * 2 * pi;
          final radius = sqrt(random.nextDouble()) * stroke.strokeWidth * scatterRadius;
          final offset = Offset(cos(angle) * radius, sin(angle) * radius);

          canvas.drawCircle(center + offset, random.nextDouble() * 1.5, paint);
        }
      } else {
        // Charcoal/Crayon logic (Texture via jitter)
        if (i < stroke.points.length - 2) {
          final next = Offset(stroke.points[i + 2], stroke.points[i + 3]);
          for (int d = 0; d < density; d++) {
            final jitter1 = Offset(
                (random.nextDouble() - 0.5) * stroke.strokeWidth * scatterRadius,
                (random.nextDouble() - 0.5) * stroke.strokeWidth * scatterRadius
            );
            final jitter2 = Offset(
                (random.nextDouble() - 0.5) * stroke.strokeWidth * scatterRadius,
                (random.nextDouble() - 0.5) * stroke.strokeWidth * scatterRadius
            );
            canvas.drawLine(center + jitter1, next + jitter2, paint);
          }
        }
      }
    }
  }

  // --- 3. CALLIGRAPHIC / FLAT BRUSHES ---
  bool _isCalligraphicBrush(BrushShape shape) {
    return [
      BrushShape.calligraphy,
      BrushShape.calligraphyPen,
      BrushShape.marker,
      BrushShape.highlighter,
      BrushShape.fountainPen,
    ].contains(shape);
  }

  void _drawCalligraphic(Canvas canvas, DrawingStroke stroke, Paint paint, BrushShape shape) {
    paint.style = PaintingStyle.fill;

    double angleOffset = 0; // The angle of the flat tip
    double tipWidthRatio = 0.2; // How thin the flat side is

    switch (shape) {
      case BrushShape.highlighter:
        paint.color = paint.color.withOpacity(0.4);
        paint.blendMode = BlendMode.srcOver; // Highlighters layer
        angleOffset = pi / 4; // 45 degrees
        break;
      case BrushShape.marker:
        paint.color = paint.color.withOpacity(0.7);
        angleOffset = 0;
        break;
      case BrushShape.fountainPen:
        angleOffset = pi / 3; // 60 degrees
        tipWidthRatio = 0.1;
        break;
      default:
        angleOffset = pi / 4;
    }

    final path = Path();

    // We construct a ribbon path
    for (int i = 0; i < stroke.points.length - 2; i += 2) {
      final p1 = Offset(stroke.points[i], stroke.points[i + 1]);
      final p2 = Offset(stroke.points[i + 2], stroke.points[i + 3]);

      // Calculate perpendicular vector for the flat tip
      // For a fixed angle brush, the offset is constant regardless of stroke direction
      final dx = cos(angleOffset) * stroke.strokeWidth / 2;
      final dy = sin(angleOffset) * stroke.strokeWidth / 2;

      // Draw a quad from p1 to p2 with the brush thickness
      final p1Top = Offset(p1.dx - dx, p1.dy - dy);
      final p1Bot = Offset(p1.dx + dx, p1.dy + dy);
      final p2Top = Offset(p2.dx - dx, p2.dy - dy);
      final p2Bot = Offset(p2.dx + dx, p2.dy + dy);

      final segmentPath = Path()
        ..moveTo(p1Top.dx, p1Top.dy)
        ..lineTo(p2Top.dx, p2Top.dy)
        ..lineTo(p2Bot.dx, p2Bot.dy)
        ..lineTo(p1Bot.dx, p1Bot.dy)
        ..close();

      path.addPath(segmentPath, Offset.zero);
    }
    canvas.drawPath(path, paint);
  }

  // --- 4. EFFECT BRUSHES (Neon, Glow, Blur, Glitch) ---
  bool _isEffectBrush(BrushShape shape) {
    return [
      BrushShape.neonBrush,
      BrushShape.glowPen,
      BrushShape.blurBrush,
      BrushShape.glitchBrush,
      BrushShape.watercolorBrush,
    ].contains(shape);
  }

  void _drawEffects(Canvas canvas, DrawingStroke stroke, Paint paint, BrushShape shape) {
    final path = Path();
    if (stroke.points.length > 1) {
      path.moveTo(stroke.points[0], stroke.points[1]);
      for (int i = 0; i < stroke.points.length - 2; i += 2) {
        path.lineTo(stroke.points[i + 2], stroke.points[i + 3]);
      }
    }

    if (shape == BrushShape.neonBrush || shape == BrushShape.glowPen) {
      // 1. Draw outer glow (Blurred)
      paint.color = Color(stroke.color).withOpacity(0.5);
      paint.strokeWidth = stroke.strokeWidth * 3;
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, stroke.strokeWidth);
      canvas.drawPath(path, paint);

      // 2. Draw inner core (White/Bright)
      paint.maskFilter = null;
      paint.color = Colors.white.withOpacity(0.9);
      paint.strokeWidth = stroke.strokeWidth / 1.5;
      canvas.drawPath(path, paint);
    }
    else if (shape == BrushShape.watercolorBrush) {
      // Low opacity, high blur, overlapping strokes
      paint.color = paint.color.withOpacity(0.3);
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, stroke.strokeWidth / 2);
      // Watercolor looks better if we draw segment by segment to get buildup
      for (int i = 0; i < stroke.points.length - 2; i += 2) {
        canvas.drawLine(
            Offset(stroke.points[i], stroke.points[i+1]),
            Offset(stroke.points[i+2], stroke.points[i+3]),
            paint
        );
      }
    }
    else if (shape == BrushShape.glitchBrush) {
      final random = Random(stroke.points.hashCode);
      paint.color = paint.color.withOpacity(0.8);

      for (int i = 0; i < stroke.points.length - 2; i += 2) {
        if (random.nextDouble() > 0.7) {
          // Horizontal offset glitch
          final shift = (random.nextDouble() - 0.5) * 20;
          canvas.drawLine(
              Offset(stroke.points[i] + shift, stroke.points[i+1]),
              Offset(stroke.points[i+2] + shift, stroke.points[i+3]),
              paint..color = [Colors.red, Colors.blue, Colors.green][random.nextInt(3)].withOpacity(0.6)
          );
        } else {
          canvas.drawLine(
              Offset(stroke.points[i], stroke.points[i+1]),
              Offset(stroke.points[i+2], stroke.points[i+3]),
              paint..color = Color(stroke.color)
          );
        }
      }
    }
    else if (shape == BrushShape.blurBrush) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, stroke.strokeWidth);
      paint.color = paint.color.withOpacity(0.5);
      canvas.drawPath(path, paint);
    }
  }

  // --- 5. STANDARD BRUSHES & ERASERS ---
  void _drawStandard(Canvas canvas, DrawingStroke stroke, Paint paint, BrushShape shape) {
    if (shape == BrushShape.eraserHard) {
      paint.color = backgroundColor; // Or transparent if using layers
      paint.blendMode = BlendMode.src; // Basic erasing
    } else if (shape == BrushShape.eraserSoft) {
      paint.color = backgroundColor;
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, stroke.strokeWidth / 2);
    } else if (shape == BrushShape.square) {
      paint.strokeCap = StrokeCap.square;
    } else {
      // Round, Technical Pen, etc.
      paint.strokeCap = StrokeCap.round;
    }

    final path = Path();
    if (stroke.points.length > 1) {
      path.moveTo(stroke.points[0], stroke.points[1]);
      for (int i = 0; i < stroke.points.length - 2; i += 2) {
        // Quadratic bezier for smoothness if it's a standard pen
        final p0 = Offset(stroke.points[i], stroke.points[i + 1]);
        final p1 = Offset(stroke.points[i + 2], stroke.points[i + 3]);

        if (shape == BrushShape.technicalPen) {
          canvas.drawLine(p0, p1, paint); // Technical pen is rigid
        } else {
          // Smoother lines for basic pens
          final midPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
          if (i == 0) {
            path.lineTo(midPoint.dx, midPoint.dy);
          } else {
            path.quadraticBezierTo(p0.dx, p0.dy, midPoint.dx, midPoint.dy);
          }
        }
      }
      // Finish the path
      if (stroke.points.length > 2 && shape != BrushShape.technicalPen) {
        final lastIndex = stroke.points.length - 2;
        path.lineTo(stroke.points[lastIndex], stroke.points[lastIndex+1]);
      }
    }

    if (shape != BrushShape.technicalPen) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) =>
      oldDelegate.strokes != strokes || oldDelegate.backgroundColor != backgroundColor;
}