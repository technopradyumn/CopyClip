import 'package:flutter/material.dart';
import 'dart:math';

// --- BASE PAINTER ---
abstract class DesignPainter extends CustomPainter {
  final Color color;
  DesignPainter({required this.color});

  @override
  bool shouldRepaint(covariant DesignPainter oldDelegate) =>
      color != oldDelegate.color;
}

// 1. DEFAULT
class DefaultDesignPainter extends DesignPainter {
  DefaultDesignPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {} // No extra paint
}

// 2. CLASSIC RULED
class RuledPaperPainter extends DesignPainter {
  RuledPaperPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final redLine = Paint()
      ..color = Colors.red.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double y = 40.0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      y += 30.0;
    }

    canvas.drawLine(const Offset(40, 0), Offset(40, size.height), redLine);
  }
}

// 3. GRID PAPER
class GridPaperPainter extends DesignPainter {
  GridPaperPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
}

// 4. DOT GRID
class DotGridPainter extends DesignPainter {
  DotGridPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    const step = 20.0;
    for (double x = step; x < size.width; x += step) {
      for (double y = step; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }
}

// 5. VINTAGE PAPER
class VintagePaperPainter extends DesignPainter {
  VintagePaperPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.brown.withValues(alpha: 0.05),
          Colors.brown.withValues(alpha: 0.2),
        ],
        radius: 1.5,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Add some "stains"
    final stainPaint = Paint()..color = Colors.brown.withValues(alpha: 0.1);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      30,
      stainPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.9),
      20,
      stainPaint,
    );
  }
}

// 6. BLUEPRINT
class BlueprintPainter extends DesignPainter {
  BlueprintPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    const step = 25.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Crosshairs
    final crossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width / 2 - 10, size.height / 2),
      Offset(size.width / 2 + 10, size.height / 2),
      crossPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - 10),
      Offset(size.width / 2, size.height / 2 + 10),
      crossPaint,
    );
  }
}

// 7. SPIRAL NOTEBOOK
class SpiralNotebookPainter extends DesignPainter {
  SpiralNotebookPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Notebook lines
    final linePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    for (double y = 40; y < size.height; y += 25) {
      canvas.drawLine(Offset(30, y), Offset(size.width, y), linePaint);
    }

    // Spirals
    final spiralPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final holePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.fill;

    for (double y = 30; y < size.height - 20; y += 30) {
      canvas.drawCircle(Offset(14, y + 2), 6, shadowPaint);
      canvas.drawCircle(Offset(12, y), 6, holePaint);

      final path = Path();
      path.moveTo(8, y);
      path.quadraticBezierTo(0, y + 15, 8, y + 30);
      canvas.drawPath(path, spiralPaint);
    }
  }
}

// 8. COMPOSITION BOOK
class CompositionBookPainter extends DesignPainter {
  CompositionBookPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.15);

    for (int i = 0; i < 200; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double r = random.nextDouble() * 5 + 2;
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // Label area
    final labelPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final labelBorder = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.3),
        width: size.width * 0.7,
        height: 60,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, labelPaint);
    canvas.drawRRect(rect, labelBorder);
  }
}

// 9. LEATHER
class LeatherTexturePainter extends DesignPainter {
  LeatherTexturePainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          color // Use the passed color
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.black.withValues(alpha: 0.2),
          Colors.transparent,
          Colors.white.withValues(alpha: 0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Stitching
    final stitchPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Path removed as it was unused

    // Dashed effect
    // Simplified: Just draw continuous for performance, or dotted
    for (double i = 10; i < size.width - 10; i += 8) {
      canvas.drawLine(Offset(i, 10), Offset(i + 4, 10), stitchPaint);
      canvas.drawLine(
        Offset(i, size.height - 10),
        Offset(i + 4, size.height - 10),
        stitchPaint,
      );
    }
    for (double i = 10; i < size.height - 10; i += 8) {
      canvas.drawLine(Offset(10, i), Offset(10, i + 4), stitchPaint);
      canvas.drawLine(
        Offset(size.width - 10, i),
        Offset(size.width - 10, i + 4),
        stitchPaint,
      );
    }
  }
}

// 10. CANVAS
class CanvasTexturePainter extends DesignPainter {
  CanvasTexturePainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Hatching
    for (double i = 0; i < size.width + size.height; i += 4) {
      canvas.drawLine(Offset(i, 0), Offset(0, i), paint); // Diagonal /
    }
  }
}

// 11. LEGAL PAD
class LegalPadPainter extends DesignPainter {
  LegalPadPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    for (double y = 50; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final marginPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.3)
      ..strokeWidth = 2;

    canvas.drawLine(Offset(50, 0), Offset(50, size.height), marginPaint);
    canvas.drawLine(Offset(54, 0), Offset(54, size.height), marginPaint);
  }
}

// 12. DARK MODE (Midnight)
class DarkModePainter extends DesignPainter {
  DarkModePainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final r = Random(123);
    for (int i = 0; i < 30; i++) {
      double x = r.nextDouble() * size.width;
      double y = r.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), r.nextDouble() * 2, paint);
    }
  }
}

// 13. PASTEL GEOMETRIC
class PastelGeometricPainter extends DesignPainter {
  PastelGeometricPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = Colors.pinkAccent.withValues(alpha: 0.05);
    canvas.drawCircle(Offset(size.width, 0), 100, paint);

    paint.color = Colors.blueAccent.withValues(alpha: 0.05);
    canvas.drawCircle(Offset(0, size.height), 80, paint);

    paint.color = Colors.amberAccent.withValues(alpha: 0.05);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.4, size.height * 0.2, 50, 50),
      paint,
    );
  }
}

// 14. WATERCOLOR
class WatercolorPainter extends DesignPainter {
  WatercolorPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.blue.withValues(alpha: 0.1),
          Colors.purple.withValues(alpha: 0.1),
          Colors.pink.withValues(alpha: 0.1),
          Colors.blue.withValues(alpha: 0.1),
        ],
        center: Alignment.center,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }
}

// 15. STARRY NIGHT
class StarryNightPainter extends DesignPainter {
  StarryNightPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final random = Random(999);

    for (int i = 0; i < 50; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double opacity = random.nextDouble() * 0.4 + 0.1;
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.5, paint);
    }

    // Moon
    paint.color = Colors.yellowAccent.withValues(alpha: 0.1);
    canvas.drawCircle(Offset(size.width - 30, 30), 15, paint);
  }
}

// 16. GEOMETRIC MODERN
class GeometricModernPainter extends DesignPainter {
  GeometricModernPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.8,
        height: size.height * 0.8,
      ),
      paint,
    );
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }
}

// 17. CIRCUIT BOARD
class CircuitBoardPainter extends DesignPainter {
  CircuitBoardPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final dotPaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    // Simple procedural circuits
    for (int i = 0; i < 5; i++) {
      double x = (i + 1) * (size.width / 6);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height * 0.4), paint);
      canvas.drawCircle(Offset(x, size.height * 0.4), 3, dotPaint);
    }
  }
}

// 18. WOOD GRAIN
class WoodGrainPainter extends DesignPainter {
  WoodGrainPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (double i = 0; i < size.height; i += 10) {
      Path path = Path();
      path.moveTo(0, i);
      // Wavy lines
      for (double x = 0; x <= size.width; x += 20) {
        path.quadraticBezierTo(x + 10, i + sin(x) * 5, x + 20, i);
      }
      canvas.drawPath(path, paint);
    }
  }
}

// 19. MARBLE
class MarbleTexturePainter extends DesignPainter {
  MarbleTexturePainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Random jagged lines
    final r = Random(55);
    for (int i = 0; i < 5; i++) {
      Path path = Path();
      path.moveTo(r.nextDouble() * size.width, 0);
      double x = r.nextDouble() * size.width;
      double y = 0;
      while (y < size.height) {
        x += (r.nextDouble() - 0.5) * 40;
        y += r.nextDouble() * 50;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }
}

// 20. CORK BOARD
class CorkBoardPainter extends DesignPainter {
  CorkBoardPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.brown.withValues(alpha: 0.15);
    final r = Random(77);

    for (int i = 0; i < 500; i++) {
      double x = r.nextDouble() * size.width;
      double y = r.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), r.nextDouble() * 2, paint);
    }
  }
}

// 21. CRUMPLED PAPER
class CrumpledPaperPainter extends DesignPainter {
  CrumpledPaperPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final r = Random(88);

    // Random polygons
    for (int i = 0; i < 10; i++) {
      Path path = Path();
      path.moveTo(r.nextDouble() * size.width, r.nextDouble() * size.height);
      path.lineTo(r.nextDouble() * size.width, r.nextDouble() * size.height);
      path.lineTo(r.nextDouble() * size.width, r.nextDouble() * size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }
}

class UserExperience {
  static const leatherColor = Color(0xFF8B4513);
}

// ─────────────── NEW DESIGNS ────────────────────────────────────────────────

// 22. KAWAII / CARTOON
class KawaiiPainter extends DesignPainter {
  KawaiiPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final r = Random(21);
    // Pastel rainbow gradient background strip
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFD6E7),
          const Color(0xFFFFF9C4),
          const Color(0xFFD4F1F9),
          const Color(0xFFE8F5E9),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Cute hearts
    final heartColors = [
      Colors.pinkAccent.withValues(alpha: 0.45),
      Colors.redAccent.withValues(alpha: 0.3),
      Colors.deepPurpleAccent.withValues(alpha: 0.25),
    ];
    for (int i = 0; i < 12; i++) {
      final hx = r.nextDouble() * size.width;
      final hy = r.nextDouble() * size.height;
      final hs = r.nextDouble() * 14 + 8;
      final hp = Paint()..color = heartColors[i % heartColors.length];
      _drawHeart(canvas, Offset(hx, hy), hs, hp);
    }

    // Stars
    final starPaint = Paint()
      ..color = Colors.amberAccent.withValues(alpha: 0.5);
    for (int i = 0; i < 8; i++) {
      final sx = r.nextDouble() * size.width;
      final sy = r.nextDouble() * size.height;
      _drawStar(canvas, Offset(sx, sy), r.nextDouble() * 8 + 5, starPaint);
    }

    // Bubbles / circles
    final bubblePaint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (int i = 0; i < 10; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 18 + 6,
        bubblePaint,
      );
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.35);
    path.cubicTo(
      center.dx - size * 0.8,
      center.dy - size * 0.2,
      center.dx - size * 1.2,
      center.dy + size * 0.6,
      center.dx,
      center.dy + size,
    );
    path.cubicTo(
      center.dx + size * 1.2,
      center.dy + size * 0.6,
      center.dx + size * 0.8,
      center.dy - size * 0.2,
      center.dx,
      center.dy + size * 0.35,
    );
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5) - pi / 2;
      final innerAngle = angle + pi / 5;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      final ix = center.dx + radius * 0.4 * cos(innerAngle);
      final iy = center.dy + radius * 0.4 * sin(innerAngle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant KawaiiPainter old) => color != old.color;
}

// 23. NEON CITY
class NeonCityPainter extends DesignPainter {
  NeonCityPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Dark bg gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF0D0221), const Color(0xFF150639)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Neon horizon glow
    final horizonPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              const Color(0xFFFF00FF).withValues(alpha: 0.25),
            ],
          ).createShader(
            Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
          );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
      horizonPaint,
    );

    // Grid lines (retrowave)
    final gridPaint = Paint()
      ..color = const Color(0xFFFF00FF).withValues(alpha: 0.25)
      ..strokeWidth = 0.8;
    for (double x = 0; x <= size.width; x += size.width / 8) {
      canvas.drawLine(
        Offset(x, size.height * 0.55),
        Offset(size.width / 2, size.height),
        gridPaint,
      );
    }
    for (int row = 1; row <= 5; row++) {
      final yFrac = size.height * 0.55 + (size.height * 0.45) * (row / 5);
      canvas.drawLine(Offset(0, yFrac), Offset(size.width, yFrac), gridPaint);
    }

    // Neon building silhouettes (simplified)
    _drawBuilding(canvas, size, 0, 0.4, 0.18, const Color(0xFF00FFFF));
    _drawBuilding(canvas, size, 0.2, 0.35, 0.15, const Color(0xFFFF00FF));
    _drawBuilding(canvas, size, 0.38, 0.45, 0.12, const Color(0xFF00FFFF));
    _drawBuilding(canvas, size, 0.55, 0.32, 0.2, const Color(0xFFFF00FF));
    _drawBuilding(canvas, size, 0.78, 0.42, 0.22, const Color(0xFF00FFFF));

    // Neon lines
    final neonLine = Paint()
      ..color = const Color(0xFF00FFFF).withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width, size.height * 0.55),
      neonLine,
    );

    // Stars
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.5);
    final rng = Random(42);
    for (int i = 0; i < 30; i++) {
      canvas.drawCircle(
        Offset(
          rng.nextDouble() * size.width,
          rng.nextDouble() * size.height * 0.5,
        ),
        rng.nextDouble() * 1.2,
        starPaint,
      );
    }
  }

  void _drawBuilding(
    Canvas canvas,
    Size size,
    double xFrac,
    double hFrac,
    double wFrac,
    Color neonColor,
  ) {
    final left = size.width * xFrac;
    final bWidth = size.width * wFrac;
    final bHeight = size.height * hFrac;
    final top = size.height * 0.55 - bHeight;

    final silhouette = Paint()..color = const Color(0xFF05010F);
    canvas.drawRect(Rect.fromLTWH(left, top, bWidth, bHeight), silhouette);

    // Neon window glow
    final glowPaint = Paint()
      ..color = neonColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.2;
    for (double wy = top + 6; wy < size.height * 0.55 - 6; wy += 10) {
      for (double wx = left + 4; wx < left + bWidth - 4; wx += 10) {
        if (Random(wx.toInt() + wy.toInt()).nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(wx, wy, 4, 4),
            Paint()..color = neonColor.withValues(alpha: 0.35),
          );
        }
      }
    }
    // Outline glow
    canvas.drawRect(
      Rect.fromLTWH(left, top, bWidth, bHeight),
      glowPaint..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant NeonCityPainter old) => color != old.color;
}

// 24. GALAXY / SPACE
class GalaxyPainter extends DesignPainter {
  GalaxyPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Deep space gradient
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 1.2,
        colors: [
          const Color(0xFF2D1B69),
          const Color(0xFF0B0B2E),
          const Color(0xFF000010),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Milky way band
    final mwPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          const Color(0xFF9C27B0).withValues(alpha: 0.15),
          const Color(0xFF3F51B5).withValues(alpha: 0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), mwPaint);

    // Stars
    final rng = Random(77);
    for (int i = 0; i < 120; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final rad = rng.nextDouble() * 1.5 + 0.3;
      final alpha = rng.nextDouble() * 0.7 + 0.2;
      final colors = [
        Colors.white,
        Colors.lightBlueAccent,
        Colors.purpleAccent,
        Colors.pinkAccent,
      ];
      canvas.drawCircle(
        Offset(x, y),
        rad,
        Paint()..color = colors[i % colors.length].withValues(alpha: alpha),
      );
    }

    // Nebula clouds
    final nebulaPaints = [
      Paint()
        ..color = const Color(0xFF7B1FA2).withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
      Paint()
        ..color = const Color(0xFF1565C0).withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
      Paint()
        ..color = const Color(0xFFAD1457).withValues(alpha: 0.09)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35),
    ];
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      size.width * 0.35,
      nebulaPaints[0],
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.6),
      size.width * 0.3,
      nebulaPaints[1],
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.8),
      size.width * 0.25,
      nebulaPaints[2],
    );

    // Planet
    final planetPaint = Paint()
      ..shader =
          RadialGradient(
            center: const Alignment(-0.3, -0.4),
            radius: 1.0,
            colors: [const Color(0xFF80CBC4), const Color(0xFF26A69A)],
          ).createShader(
            Rect.fromLTWH(size.width * 0.72, size.height * 0.08, 40, 40),
          );
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.15),
      20,
      planetPaint,
    );

    // Planet ring
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.82, size.height * 0.15),
        width: 50,
        height: 12,
      ),
      Paint()
        ..color = const Color(0xFF80CBC4).withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant GalaxyPainter old) => color != old.color;
}

// 25. TROPICAL / SUMMER
class TropicalPainter extends DesignPainter {
  TropicalPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Sky gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00B4D8),
          const Color(0xFF90E0EF),
          const Color(0xFFFFD166),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Sun
    final sunPaint = Paint()
      ..color = const Color(0xFFFFD166).withValues(alpha: 0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.18),
      28,
      sunPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.18),
      20,
      Paint()..color = const Color(0xFFFFE599),
    );

    // Waves
    final wavePaint = Paint()
      ..color = const Color(0xFF0077B6).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (int w = 0; w < 3; w++) {
      final yBase = size.height * (0.6 + w * 0.1);
      final path = Path()..moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 30) {
        path.quadraticBezierTo(x + 15, yBase - 10 + w * 3, x + 30, yBase);
      }
      canvas.drawPath(path, wavePaint);
    }

    // Sand
    final sandPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFD166).withValues(alpha: 0.0),
              const Color(0xFFE9C46A),
            ],
          ).createShader(
            Rect.fromLTWH(
              0,
              size.height * 0.75,
              size.width,
              size.height * 0.25,
            ),
          );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.75, size.width, size.height * 0.25),
      sandPaint,
    );

    // Palm tree trunk
    final trunkPaint = Paint()
      ..color = const Color(0xFF8B5E3C)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final trunkPath = Path()
      ..moveTo(size.width * 0.12, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.15,
        size.height * 0.5,
        size.width * 0.1,
        size.height * 0.28,
      );
    canvas.drawPath(trunkPath, trunkPaint);

    // Palm leaves
    final leafPaint = Paint()
      ..color = const Color(0xFF2D6A4F)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final leafTip = Offset(size.width * 0.1, size.height * 0.28);
    for (int l = 0; l < 6; l++) {
      final angle = -pi * 0.8 + l * (pi * 1.6 / 5);
      canvas.drawLine(
        leafTip,
        Offset(leafTip.dx + 40 * cos(angle), leafTip.dy + 30 * sin(angle)),
        leafPaint,
      );
    }

    // Clouds
    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.7);
    _drawCloud(canvas, Offset(size.width * 0.3, size.height * 0.1), cloudPaint);
    _drawCloud(
      canvas,
      Offset(size.width * 0.55, size.height * 0.08),
      cloudPaint,
    );
  }

  void _drawCloud(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 12, paint);
    canvas.drawCircle(Offset(center.dx + 14, center.dy + 4), 10, paint);
    canvas.drawCircle(Offset(center.dx - 12, center.dy + 4), 9, paint);
    canvas.drawRect(
      Rect.fromLTWH(center.dx - 20, center.dy + 4, 50, 12),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant TropicalPainter old) => color != old.color;
}

// 26. GRAFFITI / POP ART
class GraffitiPainter extends DesignPainter {
  GraffitiPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Bold halftone-style background
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFFF6B35), const Color(0xFFFFBE0B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Halftone dots
    final dotPaint = Paint()..color = Colors.black.withValues(alpha: 0.08);
    for (double x = 0; x < size.width; x += 12) {
      for (double y = 0; y < size.height; y += 12) {
        canvas.drawCircle(Offset(x, y), 3, dotPaint);
      }
    }

    // Bold color splashes
    final splashes = [
      [0.1, 0.15, 55.0, const Color(0xFFFF006E)],
      [0.85, 0.2, 45.0, const Color(0xFF3A86FF)],
      [0.5, 0.8, 60.0, const Color(0xFF8338EC)],
      [0.15, 0.7, 40.0, const Color(0xFF06D6A0)],
      [0.75, 0.6, 35.0, const Color(0xFFFFBE0B)],
    ];
    for (final s in splashes) {
      canvas.drawCircle(
        Offset(size.width * (s[0] as double), size.height * (s[1] as double)),
        s[2] as double,
        Paint()
          ..color = (s[3] as Color).withValues(alpha: 0.55)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      );
    }

    // Bold outline strokes
    final strokePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width * 0.3, size.height * 0.5),
      strokePaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width * 0.7, size.height * 0.5),
      strokePaint,
    );

    // Comic-style border
    final borderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawRect(
      const Rect.fromLTWH(
        6,
        6,
        0,
        0,
      ).expandToInclude(Rect.fromLTWH(6, 6, size.width - 12, size.height - 12)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GraffitiPainter old) => color != old.color;
}

// 27. TIE-DYE
class TieDyePainter extends DesignPainter {
  TieDyePainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rings = [
      const Color(0xFFFF006E),
      const Color(0xFFFFBE0B),
      const Color(0xFF06D6A0),
      const Color(0xFF3A86FF),
      const Color(0xFF8338EC),
      const Color(0xFFFF6B35),
      const Color(0xFFFFD6E7),
    ];
    final maxRadius = sqrt(size.width * size.width + size.height * size.height);
    for (int i = rings.length - 1; i >= 0; i--) {
      canvas.drawCircle(
        center,
        maxRadius * (i + 1) / rings.length,
        Paint()..color = rings[i].withValues(alpha: 0.72),
      );
    }
    // Swirl lines
    final swirlPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (int s = 0; s < 12; s++) {
      final angle = s * pi / 6;
      canvas.drawLine(
        center,
        Offset(
          center.dx + size.width * cos(angle),
          center.dy + size.height * sin(angle),
        ),
        swirlPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TieDyePainter old) => color != old.color;
}

// 28. BOHO MANDALA
class BohoMandalaPainter extends DesignPainter {
  BohoMandalaPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Warm sandy background
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
        radius: 1.2,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final center = Offset(size.width / 2, size.height / 2);
    final mandalaColors = [
      const Color(0xFFBF7C2A),
      const Color(0xFF8B3A3A),
      const Color(0xFF4A7C59),
      const Color(0xFF2D5F8A),
    ];

    // Concentric ring petals
    for (int ring = 1; ring <= 4; ring++) {
      final radius = ring * (min(size.width, size.height) * 0.1);
      final ringPaint = Paint()
        ..color = mandalaColors[(ring - 1) % mandalaColors.length].withValues(
          alpha: 0.55,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, radius, ringPaint);
      // Petals
      final petalPaint = Paint()
        ..color = mandalaColors[(ring - 1) % mandalaColors.length].withValues(
          alpha: 0.3,
        )
        ..style = PaintingStyle.fill;
      for (int p = 0; p < 8; p++) {
        final angle = p * pi / 4;
        final px = center.dx + radius * cos(angle);
        final py = center.dy + radius * sin(angle);
        canvas.drawCircle(Offset(px, py), radius * 0.3, petalPaint);
      }
    }
    // Center dot
    canvas.drawCircle(center, 5, Paint()..color = const Color(0xFFBF7C2A));

    // Decorative border diamonds
    final diamondPaint = Paint()
      ..color = const Color(0xFFBF7C2A).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (int d = 0; d < 8; d++) {
      final angle = d * pi / 4;
      final dx = center.dx + size.width * 0.44 * cos(angle);
      final dy = center.dy + size.height * 0.44 * sin(angle);
      _drawDiamond(canvas, Offset(dx, dy), 8, diamondPaint);
    }
  }

  void _drawDiamond(Canvas canvas, Offset center, double s, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - s)
      ..lineTo(center.dx + s, center.dy)
      ..lineTo(center.dx, center.dy + s)
      ..lineTo(center.dx - s, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BohoMandalaPainter old) => color != old.color;
}

// 29. CANDY STRIPE
class CandyStripePainter extends DesignPainter {
  CandyStripePainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    const stripeColors = [
      Color(0xFFFF6B9D),
      Color(0xFFFFFFFF),
      Color(0xFF85D8CE),
      Color(0xFFFFFFFF),
    ];
    const stripeWidth = 28.0;
    int i = 0;
    for (
      double x = -size.height;
      x < size.width + size.height;
      x += stripeWidth
    ) {
      final paint = Paint()
        ..color = stripeColors[i % stripeColors.length].withValues(alpha: 0.85);
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + stripeWidth, 0)
        ..lineTo(x + stripeWidth + size.height, size.height)
        ..lineTo(x + size.height, size.height)
        ..close();
      canvas.drawPath(path, paint);
      i++;
    }

    // White scallop border
    final scallop = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (double cx = 10; cx < size.width; cx += 20) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, 0), radius: 10),
        0,
        pi,
        false,
        scallop,
      );
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, size.height), radius: 10),
        pi,
        pi,
        false,
        scallop,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CandyStripePainter old) => color != old.color;
}

// 30. FOREST / NATURE
class ForestNaturePainter extends DesignPainter {
  ForestNaturePainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Sky-to-ground gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF87CEEB),
          const Color(0xFF4CAF50),
          const Color(0xFF2E7D32),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Trees
    final treeTrunk = Paint()..color = const Color(0xFF795548);
    final treeLeaves = Paint()
      ..color = const Color(0xFF388E3C).withValues(alpha: 0.85);
    final treeLeavesDark = Paint()
      ..color = const Color(0xFF1B5E20).withValues(alpha: 0.7);

    final treePosXs = [0.1, 0.25, 0.45, 0.65, 0.82];
    for (int ti = 0; ti < treePosXs.length; ti++) {
      final tx = size.width * treePosXs[ti];
      final tHeight = size.height * (0.25 + (ti % 2) * 0.1);
      final groundY = size.height * 0.6;
      // Trunk
      canvas.drawRect(
        Rect.fromLTWH(tx - 4, groundY - tHeight * 0.4, 8, tHeight * 0.4),
        treeTrunk,
      );
      // Layered triangles
      for (int layer = 0; layer < 3; layer++) {
        final layerY = groundY - tHeight * (0.35 + layer * 0.22);
        final halfWidth = (tHeight * 0.28) - layer * 8;
        final path = Path()
          ..moveTo(tx, layerY - tHeight * 0.25)
          ..lineTo(tx + halfWidth, layerY)
          ..lineTo(tx - halfWidth, layerY)
          ..close();
        canvas.drawPath(path, layer == 2 ? treeLeavesDark : treeLeaves);
      }
    }

    // Birds
    final birdPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (int b = 0; b < 5; b++) {
      final bx = size.width * (0.2 + b * 0.14);
      final by = size.height * (0.1 + (b % 2) * 0.06);
      final path = Path()
        ..moveTo(bx - 8, by)
        ..quadraticBezierTo(bx - 4, by - 5, bx, by)
        ..quadraticBezierTo(bx + 4, by - 5, bx + 8, by);
      canvas.drawPath(path, birdPaint);
    }

    // Wildflowers
    final flower = Paint()
      ..color = const Color(0xFFE91E63).withValues(alpha: 0.8);
    final flowerRng = Random(33);
    for (int f = 0; f < 12; f++) {
      final fx = flowerRng.nextDouble() * size.width;
      final fy =
          size.height * 0.62 + flowerRng.nextDouble() * size.height * 0.15;
      canvas.drawCircle(Offset(fx, fy), 3, flower);
    }
  }

  @override
  bool shouldRepaint(covariant ForestNaturePainter old) => color != old.color;
}

// 31. OCEAN WAVES
class OceanWavesPainter extends DesignPainter {
  OceanWavesPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Deep ocean gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0277BD),
          const Color(0xFF006064),
          const Color(0xFF00363A),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Wave layers
    for (int w = 5; w >= 0; w--) {
      final yBase = size.height * (0.2 + w * 0.13);
      final waveAlpha = 0.12 + w * 0.06;
      final waveColor = Color.lerp(
        const Color(0xFF80DEEA),
        const Color(0xFFE0F7FA),
        w / 5,
      )!.withValues(alpha: waveAlpha);
      final wavePaint = Paint()..color = waveColor;
      final path = Path()..moveTo(0, yBase);
      double amp = 12 - w * 1.5;
      for (double x = 0; x <= size.width; x += 40) {
        path.quadraticBezierTo(x + 20, yBase - amp, x + 40, yBase);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, wavePaint);
    }

    // Sunlight shimmer
    final shimmerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int sh = 0; sh < 8; sh++) {
      canvas.drawLine(
        Offset(size.width * 0.55 + sh * 15, 0),
        Offset(size.width * 0.3 + sh * 20, size.height * 0.4),
        shimmerPaint,
      );
    }

    // Bubbles
    final bubblePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final bRng = Random(55);
    for (int b = 0; b < 15; b++) {
      canvas.drawCircle(
        Offset(bRng.nextDouble() * size.width, bRng.nextDouble() * size.height),
        bRng.nextDouble() * 8 + 2,
        bubblePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant OceanWavesPainter old) => color != old.color;
}

// 32. RETRO 80s
class Retro80sPainter extends DesignPainter {
  Retro80sPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Dual-tone gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFFFE4365), const Color(0xFFFCE38A)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Horizontal scan lines
    final scanPaint = Paint()..color = Colors.black.withValues(alpha: 0.04);
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanPaint);
    }

    // Diagonal bold stripe
    final stripePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 30;
    canvas.drawLine(
      Offset(0, size.height * 0.2),
      Offset(size.width * 1.3, size.height * 0.8),
      stripePaint,
    );

    // Geometric shapes
    final shapePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.7, size.height * 0.05, 40, 40),
      shapePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.15),
      22,
      shapePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.05),
      Offset(size.width * 0.6, size.height * 0.3),
      shapePaint,
    );

    // Bottom grid (retro VHS look)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 0.8;
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(
        Offset(x, size.height * 0.7),
        Offset(size.width / 2, size.height),
        gridPaint,
      );
    }
    for (int row = 1; row <= 4; row++) {
      final y = size.height * 0.7 + (size.height * 0.3) * row / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant Retro80sPainter old) => color != old.color;
}

// 33. ANIME SAKURA
class AnimeSakuraPainter extends DesignPainter {
  AnimeSakuraPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Soft pink sky
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFE4E1),
          const Color(0xFFFFC0CB),
          const Color(0xFFFFB7C5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Tree branch
    final branchPaint = Paint()
      ..color = const Color(0xFF6D4C41)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.1, size.height),
      Offset(size.width * 0.5, size.height * 0.3),
      branchPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.3),
      Offset(size.width * 0.85, size.height * 0.5),
      branchPaint..strokeWidth = 2.5,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.3),
      Offset(size.width * 0.35, size.height * 0.1),
      branchPaint..strokeWidth = 2,
    );

    // Sakura petals scattered
    final rng = Random(13);
    final petalColors = [
      const Color(0xFFFF69B4).withValues(alpha: 0.75),
      const Color(0xFFFFB7C5).withValues(alpha: 0.85),
      const Color(0xFFFF1493).withValues(alpha: 0.45),
    ];
    for (int p = 0; p < 30; p++) {
      final px = rng.nextDouble() * size.width;
      final py = rng.nextDouble() * size.height;
      final pSize = rng.nextDouble() * 8 + 4;
      _drawSakuraPetal(
        canvas,
        Offset(px, py),
        pSize,
        Paint()..color = petalColors[p % petalColors.length],
      );
    }

    // Mountain silhouette in background
    final mountainPaint = Paint()
      ..color = const Color(0xFFE8A0B4).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    final mountainPath = Path()
      ..moveTo(0, size.height * 0.7)
      ..lineTo(size.width * 0.3, size.height * 0.35)
      ..lineTo(size.width * 0.6, size.height * 0.55)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(mountainPath, mountainPaint);
  }

  void _drawSakuraPetal(
    Canvas canvas,
    Offset center,
    double size,
    Paint paint,
  ) {
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * pi / 5;
      final petalCenter = Offset(
        center.dx + size * 0.5 * cos(angle),
        center.dy + size * 0.5 * sin(angle),
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: petalCenter,
          width: size * 0.7,
          height: size * 0.45,
        ),
        paint,
      );
    }
    canvas.drawCircle(
      center,
      size * 0.2,
      Paint()..color = Colors.yellow.withValues(alpha: 0.6),
    );
  }

  @override
  bool shouldRepaint(covariant AnimeSakuraPainter old) => color != old.color;
}

// 34. SPORTS / ENERGY
class SportsEnergyPainter extends DesignPainter {
  SportsEnergyPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Bold dynamic gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1A237E),
          const Color(0xFF283593),
          const Color(0xFF0D47A1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Dynamic diagonal slashes
    final slashPaint = Paint()
      ..color = const Color(0xFFFF6F00)
      ..style = PaintingStyle.fill;
    final slash1 = Path()
      ..moveTo(size.width * 0.55, 0)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(size.width * 0.45, size.height)
      ..lineTo(size.width * 0.25, size.height)
      ..close();
    canvas.drawPath(slash1, slashPaint);

    final slash2 = Path()
      ..moveTo(size.width * 0.75, 0)
      ..lineTo(size.width * 0.85, 0)
      ..lineTo(size.width * 0.65, size.height)
      ..lineTo(size.width * 0.55, size.height)
      ..close();
    canvas.drawPath(
      slash2,
      Paint()..color = const Color(0xFFFF8F00).withValues(alpha: 0.6),
    );

    // Speed lines
    final speedPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (int i = 0; i < 20; i++) {
      final y = i * size.height / 20;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width * 0.5, y + size.height * 0.05),
        speedPaint,
      );
    }

    // Hexagons
    final hexPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    _drawHex(canvas, Offset(size.width * 0.1, size.height * 0.2), 30, hexPaint);
    _drawHex(canvas, Offset(size.width * 0.9, size.height * 0.7), 25, hexPaint);
    _drawHex(
      canvas,
      Offset(size.width * 0.15, size.height * 0.75),
      20,
      hexPaint,
    );

    // Stars / energy sparks
    final sparkPaint = Paint()
      ..color = Colors.amberAccent.withValues(alpha: 0.7);
    final sRng = Random(7);
    for (int i = 0; i < 6; i++) {
      canvas.drawCircle(
        Offset(sRng.nextDouble() * size.width, sRng.nextDouble() * size.height),
        sRng.nextDouble() * 2 + 1,
        sparkPaint,
      );
    }
  }

  void _drawHex(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3 - pi / 6;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SportsEnergyPainter old) => color != old.color;
}

// 35. HALLOWEEN / SPOOKY
class HalloweenPainter extends DesignPainter {
  HalloweenPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Eerie dark bg
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF1A0000),
          const Color(0xFF2D0A00),
          const Color(0xFF1C0C00),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Moon
    final moonPaint = Paint()
      ..color = const Color(0xFFFFFDE7).withValues(alpha: 0.85)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.15),
      30,
      moonPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.15),
      24,
      Paint()..color = const Color(0xFFFFF9C4),
    );

    // Clouds
    final cloudPaint = Paint()
      ..color = Colors.grey.shade800.withValues(alpha: 0.75)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.65, size.height * 0.14),
        width: 60,
        height: 24,
      ),
      cloudPaint,
    );

    // Stars
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.4);
    final rng = Random(31);
    for (int i = 0; i < 30; i++) {
      canvas.drawCircle(
        Offset(
          rng.nextDouble() * size.width,
          rng.nextDouble() * size.height * 0.5,
        ),
        rng.nextDouble() * 1.2 + 0.3,
        starPaint,
      );
    }

    // Pumpkin-orange glow
    final glowPaint = Paint()
      ..color = const Color(0xFFFF6F00).withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.75),
      60,
      glowPaint,
    );

    // Ground silhouette
    final groundPaint = Paint()..color = const Color(0xFF0D0000);
    final groundPath = Path()
      ..moveTo(0, size.height * 0.78)
      ..lineTo(size.width * 0.05, size.height * 0.7)
      ..lineTo(size.width * 0.12, size.height * 0.78)
      ..lineTo(size.width * 0.18, size.height * 0.68)
      ..lineTo(size.width * 0.25, size.height * 0.78)
      ..lineTo(size.width, size.height * 0.78)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(groundPath, groundPaint);

    // Bat silhouettes
    final batPaint = Paint()..color = Colors.black87;
    _drawBat(
      canvas,
      Offset(size.width * 0.35, size.height * 0.28),
      12,
      batPaint,
    );
    _drawBat(canvas, Offset(size.width * 0.6, size.height * 0.18), 9, batPaint);

    // Jack-o-lantern eyes glow
    final eyePaint = Paint()
      ..color = const Color(0xFFFF6F00).withValues(alpha: 0.85)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.18, size.height * 0.76),
        width: 10,
        height: 8,
      ),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.24, size.height * 0.76),
        width: 10,
        height: 8,
      ),
      eyePaint,
    );
  }

  void _drawBat(Canvas canvas, Offset center, double r, Paint paint) {
    // Body
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r, height: r * 0.6),
      paint,
    );
    // Wings
    final wPath = Path()
      ..moveTo(center.dx - r * 0.5, center.dy)
      ..cubicTo(
        center.dx - r * 2,
        center.dy - r,
        center.dx - r * 2.5,
        center.dy + r * 0.5,
        center.dx - r * 1.5,
        center.dy + r * 0.5,
      )
      ..close();
    canvas.drawPath(wPath, paint);
    final wPath2 = Path()
      ..moveTo(center.dx + r * 0.5, center.dy)
      ..cubicTo(
        center.dx + r * 2,
        center.dy - r,
        center.dx + r * 2.5,
        center.dy + r * 0.5,
        center.dx + r * 1.5,
        center.dy + r * 0.5,
      )
      ..close();
    canvas.drawPath(wPath2, paint);
  }

  @override
  bool shouldRepaint(covariant HalloweenPainter old) => color != old.color;
}

// 36. FESTIVE / CHRISTMAS
class FestivePainter extends DesignPainter {
  FestivePainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Deep festive green/red gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Snowflakes
    final snowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final rng = Random(25);
    for (int i = 0; i < 15; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final snowR = rng.nextDouble() * 12 + 6;
      _drawSnowflake(canvas, Offset(cx, cy), snowR, snowPaint);
    }

    // Christmas string lights
    final string = Paint()
      ..color = Colors.brown.shade200.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    const lightColors = [
      Color(0xFFFF1744),
      Color(0xFFFFD600),
      Color(0xFF00E676),
      Color(0xFF2979FF),
    ];
    for (int row = 0; row < 3; row++) {
      final yBase = size.height * (0.2 + row * 0.3);
      final path = Path()..moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 30) {
        path.quadraticBezierTo(x + 15, yBase + 12, x + 30, yBase);
      }
      canvas.drawPath(path, string);
      for (int b = 0; b < 9; b++) {
        final bx = b * size.width / 9 + size.width / 18;
        final by = yBase + 6;
        canvas.drawCircle(
          Offset(bx, by),
          4,
          Paint()
            ..color = lightColors[(b + row) % lightColors.length].withValues(
              alpha: 0.9,
            )
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }

    // Snowfall dots
    final snowDotPaint = Paint()..color = Colors.white.withValues(alpha: 0.4);
    for (int d = 0; d < 40; d++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        rng.nextDouble() * 2.5 + 0.5,
        snowDotPaint,
      );
    }
  }

  void _drawSnowflake(Canvas canvas, Offset center, double r, Paint paint) {
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      canvas.drawLine(
        center,
        Offset(center.dx + r * cos(angle), center.dy + r * sin(angle)),
        paint,
      );
      // Side branches
      final branchAngle1 = angle + pi / 6;
      final branchAngle2 = angle - pi / 6;
      final branchStart = Offset(
        center.dx + r * 0.5 * cos(angle),
        center.dy + r * 0.5 * sin(angle),
      );
      canvas.drawLine(
        branchStart,
        Offset(
          branchStart.dx + r * 0.3 * cos(branchAngle1),
          branchStart.dy + r * 0.3 * sin(branchAngle1),
        ),
        paint,
      );
      canvas.drawLine(
        branchStart,
        Offset(
          branchStart.dx + r * 0.3 * cos(branchAngle2),
          branchStart.dy + r * 0.3 * sin(branchAngle2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FestivePainter old) => color != old.color;
}

// ─────────────────────────────────────────────────────────────────────────────
// BATCH 2: 37 to 56
// ─────────────────────────────────────────────────────────────────────────────

// 37. CYBERPUNK
class CyberpunkPainter extends DesignPainter {
  CyberpunkPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Dark chaotic background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0D0221),
    );

    final r = Random(999);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 30; i++) {
      paint.color = r.nextBool()
          ? const Color(0xFF00FF41).withValues(alpha: 0.6) // matrix green
          : const Color(0xFFFF003C).withValues(alpha: 0.6); // neon red

      double y = r.nextDouble() * size.height;
      if (r.nextBool()) {
        // Horizontal glitch line
        canvas.drawLine(
          Offset(r.nextDouble() * size.width * 0.5, y),
          Offset(size.width * 0.5 + r.nextDouble() * size.width * 0.5, y),
          paint,
        );
      } else {
        // Data blocks
        canvas.drawRect(
          Rect.fromLTWH(
            r.nextDouble() * size.width,
            y,
            r.nextDouble() * 40 + 10,
            r.nextDouble() * 20 + 5,
          ),
          Paint()
            ..color = paint.color.withValues(alpha: 0.3)
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CyberpunkPainter old) => color != old.color;
}

// 38. COTTAGECORE
class CottagecorePainter extends DesignPainter {
  CottagecorePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Warm natural background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFF4E4BC),
    );

    final r = Random(123);
    final vinePaint = Paint()
      ..color = const Color(0xFF6B8E23)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final petalPaint = Paint()
      ..color = const Color(0xFFE6A8D7)
      ..style = PaintingStyle.fill;

    // Hanging vines from top
    for (double x = 10; x < size.width; x += 30) {
      double h = r.nextDouble() * 100 + 40;
      Path p = Path()..moveTo(x, 0);
      p.quadraticBezierTo(x + 10, h / 2, x - 5, h);
      canvas.drawPath(p, vinePaint);

      // Leaves/Flowers on vine
      for (double y = 10; y < h; y += 20) {
        if (r.nextBool()) {
          canvas.drawCircle(
            Offset(x + (r.nextBool() ? 5 : -5), y),
            3,
            petalPaint,
          );
        }
      }
    }

    // Checkered picnic blanket hint at bottom
    final checkPaint = Paint()
      ..color = const Color(0xFFCD5C5C).withValues(alpha: 0.2);
    for (double x = 0; x < size.width; x += 20) {
      for (double y = size.height - 40; y < size.height; y += 20) {
        if ((x / 20).floor() % 2 == (y / 20).floor() % 2) {
          canvas.drawRect(Rect.fromLTWH(x, y, 20, 20), checkPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CottagecorePainter old) => color != old.color;
}

// 39. SYNTHWAVE
class SynthwavePainter extends DesignPainter {
  SynthwavePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Gradient Sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.6),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B0F4C), Color(0xFFF93290)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.6)),
    );

    // Sun
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.6),
      60,
      Paint()
        ..shader =
            const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFD166), Color(0xFFFF2A54)],
            ).createShader(
              Rect.fromLTWH(
                size.width / 2 - 60,
                size.height * 0.6 - 60,
                120,
                120,
              ),
            ),
    );

    // Sun slices (horizontal cuts)
    for (
      double y = size.height * 0.6 - 10;
      y < size.height * 0.6 + 60;
      y += 12
    ) {
      canvas.drawLine(
        Offset(size.width / 2 - 70, y),
        Offset(size.width / 2 + 70, y),
        Paint()
          ..color = const Color(0xFF000000)
          ..strokeWidth = y > size.height * 0.6 ? 4 : 2,
      ); // approximate clear by drawing dark
    }

    // Grid Floor
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4),
      Paint()..color = const Color(0xFF0A0A0A),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFF00FFFF).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Perspective lines
    for (double x = -size.width * 2; x < size.width * 3; x += 40) {
      canvas.drawLine(
        Offset(size.width / 2, size.height * 0.6),
        Offset(x, size.height),
        gridPaint,
      );
    }
    // Horizontal lines getting further apart
    double y = size.height * 0.6;
    double step = 2;
    while (y < size.height) {
      y += step;
      step *= 1.3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SynthwavePainter old) => color != old.color;
}

// 40. STEAMPUNK
class SteampunkPainter extends DesignPainter {
  SteampunkPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Brass/copper background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFB87333), Color(0xFF5C3A21)],
          radius: 1.5,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final r = Random(404);
    final gearPaint = Paint()
      ..color = const Color(0xFFCD7F32).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final rivetPaint = Paint()
      ..color = const Color(0xFF2C1605)
      ..style = PaintingStyle.fill;

    // Draw gears
    for (int i = 0; i < 5; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double radius = r.nextDouble() * 30 + 20;

      // Inner circle
      canvas.drawCircle(Offset(cx, cy), radius, gearPaint);
      canvas.drawCircle(Offset(cx, cy), radius / 3, gearPaint);

      // Gear teeth
      for (int j = 0; j < 8; j++) {
        double angle = j * (pi / 4);
        canvas.drawLine(
          Offset(cx + cos(angle) * radius, cy + sin(angle) * radius),
          Offset(
            cx + cos(angle) * (radius + 8),
            cy + sin(angle) * (radius + 8),
          ),
          gearPaint..strokeWidth = 6,
        );
      }
    }

    // Rivets along borders
    for (double x = 10; x < size.width; x += 30) {
      canvas.drawCircle(Offset(x, 10), 3, rivetPaint);
      canvas.drawCircle(Offset(x, size.height - 10), 3, rivetPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SteampunkPainter old) => color != old.color;
}

// 41. VAPORWAVE
class VaporwavePainter extends DesignPainter {
  VaporwavePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Classic pink/teal gradient
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF71CE), Color(0xFF01CDFE)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Checkerboard ground perspective
    final gridPath = Path();
    gridPath.moveTo(0, size.height * 0.6);
    gridPath.lineTo(size.width, size.height * 0.6);
    gridPath.lineTo(size.width, size.height);
    gridPath.lineTo(0, size.height);
    gridPath.close();

    canvas.drawPath(
      gridPath,
      Paint()..color = Colors.white.withValues(alpha: 0.2),
    );

    final linePaint = Paint()
      ..color = const Color(0xFFB967FF)
      ..strokeWidth = 1;
    for (double x = -size.width; x < size.width * 2; x += 30) {
      canvas.drawLine(
        Offset(size.width / 2, size.height * 0.6),
        Offset(x, size.height),
        linePaint,
      );
    }
    double y = size.height * 0.6;
    double step = 2;
    while (y < size.height) {
      y += step;
      step *= 1.2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Roman bust silhouette hint
    final bustPath = Path();
    bustPath.moveTo(size.width * 0.7, size.height * 0.3);
    bustPath.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.2,
      size.width * 0.8,
      size.height * 0.3,
    );
    bustPath.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.4,
      size.width * 0.75,
      size.height * 0.5,
    );
    bustPath.lineTo(size.width * 0.6, size.height * 0.5);
    bustPath.close();
    canvas.drawPath(
      bustPath,
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );
  }

  @override
  bool shouldRepaint(covariant VaporwavePainter old) => color != old.color;
}

// 42. GOTHIC
class GothicPainter extends DesignPainter {
  GothicPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF121212),
    );

    final ironPaint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Wrought iron gate pattern
    for (double x = 30; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), ironPaint);

      // Spikes at top
      Path spike = Path()
        ..moveTo(x - 5, 20)
        ..lineTo(x, 0)
        ..lineTo(x + 5, 20)
        ..close();
      canvas.drawPath(spike, Paint()..color = const Color(0xFF4A4A4A));

      // Curlicues
      if (x + 60 < size.width) {
        Path curl = Path()
          ..moveTo(x, size.height / 2)
          ..quadraticBezierTo(
            x + 30,
            size.height / 2 - 40,
            x + 60,
            size.height / 2,
          );
        canvas.drawPath(curl, ironPaint..strokeWidth = 2);

        Path curl2 = Path()
          ..moveTo(x, size.height / 2)
          ..quadraticBezierTo(
            x + 30,
            size.height / 2 + 40,
            x + 60,
            size.height / 2,
          );
        canvas.drawPath(curl2, ironPaint..strokeWidth = 2);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GothicPainter old) => color != old.color;
}

// 43. PIXEL ART
class PixelArtPainter extends DesignPainter {
  PixelArtPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF87CEEB), // Sky blue
    );

    final r = Random(888.hashCode);
    const double px = 15; // "Pixel" size

    // Blocky clouds
    final whitePaint = Paint()..color = Colors.white;
    for (int i = 0; i < 3; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * (size.height / 2);

      canvas.drawRect(Rect.fromLTWH(cx, cy, px * 4, px * 2), whitePaint);
      canvas.drawRect(Rect.fromLTWH(cx - px, cy + px, px * 6, px), whitePaint);
      canvas.drawRect(Rect.fromLTWH(cx + px, cy - px, px * 2, px), whitePaint);
    }

    // Blocky grass ground
    final greenPaint = Paint()..color = const Color(0xFF55AA55);
    final darkGreen = Paint()..color = const Color(0xFF227722);

    for (double x = 0; x < size.width; x += px) {
      for (double y = size.height - px * 4; y < size.height; y += px) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, px, px),
          r.nextBool() ? greenPaint : darkGreen,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PixelArtPainter old) => color != old.color;
}

// 44. ABSTRACT
class AbstractArtPainter extends DesignPainter {
  AbstractArtPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFAFAFA),
    );

    final r = Random(987);
    final colors = [
      const Color(0xFFE63946).withValues(alpha: 0.8),
      const Color(0xFFF1FAEE).withValues(alpha: 0.8),
      const Color(0xFFA8DADC).withValues(alpha: 0.8),
      const Color(0xFF457B9D).withValues(alpha: 0.8),
      const Color(0xFF1D3557).withValues(alpha: 0.8),
    ];

    for (int i = 0; i < 8; i++) {
      final paint = Paint()
        ..color = colors[r.nextInt(colors.length)]
        ..style = PaintingStyle.fill;

      Path p = Path();
      p.moveTo(r.nextDouble() * size.width, r.nextDouble() * size.height);
      p.quadraticBezierTo(
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
      );
      p.quadraticBezierTo(
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
      );
      p.close();
      canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant AbstractArtPainter old) => color != old.color;
}

// 45. MINIMALIST
class MinimalistPainter extends DesignPainter {
  MinimalistPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFF5F5F5),
    );

    final linePaint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // A single elegant curved line
    Path p = Path();
    p.moveTo(size.width * 0.2, 0);
    p.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.5,
      size.width * 0.8,
      size.height,
    );
    canvas.drawPath(p, linePaint);

    // A single solid circle
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.3),
      40,
      Paint()..color = const Color(0xFFE0E0E0),
    );
  }

  @override
  bool shouldRepaint(covariant MinimalistPainter old) => color != old.color;
}

// 46. WATERCOLOR LANDSCAPE
class WatercolorLandscapePainter extends DesignPainter {
  WatercolorLandscapePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFFF0F5),
    );

    final r = Random(111);

    // Soft distant mountains
    for (int layer = 0; layer < 3; layer++) {
      final path = Path();
      path.moveTo(0, size.height);

      double startY = size.height * 0.4 + (layer * 40);
      path.lineTo(0, startY);

      for (double x = 0; x <= size.width; x += 40) {
        path.lineTo(x, startY + (r.nextDouble() * 40 - 20));
      }
      path.lineTo(size.width, size.height);
      path.close();

      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(
            0xFF8B5A2B,
          ).withValues(alpha: 0.15 + (layer * 0.1))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant WatercolorLandscapePainter old) =>
      color != old.color;
}

// 47. STARLIGHT
class StarlightPainter extends DesignPainter {
  StarlightPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Deep blue night
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF000033), Color(0xFF003366)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final r = Random(222);
    final starPaint = Paint()..color = Colors.white;
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    for (int i = 0; i < 60; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double radius = r.nextDouble() * 2 + 1;

      canvas.drawCircle(Offset(cx, cy), radius + 2, glowPaint);
      canvas.drawCircle(Offset(cx, cy), radius, starPaint);

      if (r.nextDouble() > 0.9) {
        // Cross sparkle
        canvas.drawLine(Offset(cx - 5, cy), Offset(cx + 5, cy), starPaint);
        canvas.drawLine(Offset(cx, cy - 5), Offset(cx, cy + 5), starPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarlightPainter old) => color != old.color;
}

// 48. NEON FLORA
class NeonFloraPainter extends DesignPainter {
  NeonFloraPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0B0E14),
    );

    final r = Random(333);
    final leafColors = [
      const Color(0xFF00FFCC),
      const Color(0xFFFF00FF),
      const Color(0xFFFFFF00),
    ];

    for (int i = 0; i < 15; i++) {
      final paint = Paint()
        ..color = leafColors[r.nextInt(leafColors.length)].withValues(
          alpha: 0.7,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3);

      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double w = r.nextDouble() * 40 + 20;
      double h = r.nextDouble() * 60 + 40;

      Path leaf = Path();
      leaf.moveTo(cx, cy);
      leaf.quadraticBezierTo(cx + w, cy - h / 2, cx, cy - h);
      leaf.quadraticBezierTo(cx - w, cy - h / 2, cx, cy);

      canvas.drawPath(leaf, paint);

      // Center vein
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx, cy - h + 10),
        paint..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NeonFloraPainter old) => color != old.color;
}

// 49. GEOMETRIC
class GeometricPainter extends DesignPainter {
  GeometricPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFE8ECEF),
    );

    final r = Random(444);
    final colors = [
      const Color(0xFFFFB347).withValues(alpha: 0.6),
      const Color(0xFFFF7B25).withValues(alpha: 0.6),
      const Color(0xFF82B74B).withValues(alpha: 0.6),
      const Color(0xFF405D27).withValues(alpha: 0.6),
    ];

    for (int i = 0; i < 20; i++) {
      final paint = Paint()
        ..color = colors[r.nextInt(colors.length)]
        ..style = PaintingStyle.fill;
      int sides = r.nextInt(3) + 3; // 3 to 5 sides
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double radius = r.nextDouble() * 50 + 20;

      Path poly = Path();
      for (int j = 0; j < sides; j++) {
        double angle = (j * 2 * pi) / sides;
        double x = cx + cos(angle) * radius;
        double y = cy + sin(angle) * radius;
        if (j == 0)
          poly.moveTo(x, y);
        else
          poly.lineTo(x, y);
      }
      poly.close();
      canvas.drawPath(poly, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GeometricPainter old) => color != old.color;
}

// 50. VINTAGE PAPER
class ParchmentPaperPainter extends DesignPainter {
  ParchmentPaperPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFF2EADC), // Parchment
    );

    final r = Random(555);
    final stainPaint = Paint()
      ..color = const Color(0xFFD4C4A8).withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    // Edges
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const RadialGradient(
          colors: [Colors.transparent, Color(0x338B4513)],
          radius: 1.2,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Random stains
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 60 + 30,
        stainPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParchmentPaperPainter old) => color != old.color;
}

// 51. MODERN ART
class ModernArtPainter extends DesignPainter {
  ModernArtPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    final black = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final primary = Paint()
      ..color = const Color(0xFFE22622)
      ..style = PaintingStyle.fill;
    final yellow = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;
    final blue = Paint()
      ..color = const Color(0xFF005BBB)
      ..style = PaintingStyle.fill;

    // Mondrian style lines & blocks
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.3, size.height * 0.4),
      primary,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.7,
        size.height * 0.6,
        size.width * 0.3,
        size.height * 0.4,
      ),
      yellow,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.8, size.width * 0.2, size.height * 0.2),
      blue,
    );

    // Grid lines
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      black..strokeWidth = 8,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      black..strokeWidth = 8,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      black..strokeWidth = 8,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.8),
      Offset(size.width, size.height * 0.8),
      black..strokeWidth = 8,
    );
  }

  @override
  bool shouldRepaint(covariant ModernArtPainter old) => color != old.color;
}

// 52. COSMIC CLOUDS
class CosmicCloudsPainter extends DesignPainter {
  CosmicCloudsPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0D0B14),
    );

    final r = Random(666);

    // Nebula puffs
    for (int i = 0; i < 8; i++) {
      final paint = Paint()
        ..color = [
          Colors.purple,
          Colors.pink,
          Colors.blue,
        ][r.nextInt(3)].withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);

      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 100 + 50,
        paint,
      );
    }

    // Tiny stars
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.6);
    for (int i = 0; i < 100; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 1.5,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CosmicCloudsPainter old) => color != old.color;
}

// 53. ENCHANTED FOREST
class EnchantedForestPainter extends DesignPainter {
  EnchantedForestPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF05110E),
    );

    final r = Random(777);
    final trunk = Paint()
      ..color = const Color(0xFF1E2F23)
      ..strokeWidth = 10;
    final leaf = Paint()
      ..color = const Color(0xFF2A4B3C)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final wisp = Paint()
      ..color = const Color(0xFF7FFFD4).withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);

    // Trees
    for (double x = 20; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, size.height), Offset(x, 0), trunk);
      canvas.drawCircle(Offset(x, size.height / 3), 60, leaf);
      canvas.drawCircle(Offset(x, size.height / 2), 80, leaf);
    }

    // Glowing wisps
    for (int i = 0; i < 30; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 4 + 2,
        wisp,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EnchantedForestPainter old) =>
      color != old.color;
}

// 54. NEON GRID
class NeonGridPainter extends DesignPainter {
  NeonGridPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF000000),
    );

    final line = Paint()
      ..color = const Color(0xFFE02EAC)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant NeonGridPainter old) => color != old.color;
}

// 55. SUNSET HORIZON
class SunsetHorizonPainter extends DesignPainter {
  SunsetHorizonPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Gradient sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C3E50), Color(0xFFE74C3C), Color(0xFFF1C40F)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Solid dark ground
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.8, size.width, size.height * 0.2),
      Paint()..color = const Color(0xFF111111),
    );

    // Setting sun half hidden
    canvas.drawArc(
      Rect.fromLTWH(size.width / 2 - 50, size.height * 0.8 - 50, 100, 100),
      pi,
      pi,
      true,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(covariant SunsetHorizonPainter old) => color != old.color;
}

// 56. OCEANIC DEPTHS
class OceanicDepthsPainter extends DesignPainter {
  OceanicDepthsPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0077BE), Color(0xFF001F3F)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final r = Random(888);
    final bubble = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Bubbles rising
    for (int i = 0; i < 40; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 8 + 2,
        bubble,
      );
    }

    // Light rays coming down
    final ray = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..blendMode = BlendMode.overlay;
    for (int i = 0; i < 5; i++) {
      Path p = Path();
      double sx = r.nextDouble() * size.width;
      p.moveTo(sx, 0);
      p.lineTo(sx + 80, 0);
      p.lineTo(sx - 40, size.height);
      p.lineTo(sx - 120, size.height);
      p.close();
      canvas.drawPath(p, ray);
    }
  }

  @override
  bool shouldRepaint(covariant OceanicDepthsPainter old) => color != old.color;
}

// ─────────────────────────────────────────────────────────────────────────────
// BATCH 3: 57 to 66
// ─────────────────────────────────────────────────────────────────────────────

// 57. POP PUNK
class PopPunkPainter extends DesignPainter {
  PopPunkPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFF00FF), // Hot pink
    );

    final blackLine = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final blackFill = Paint()..color = Colors.black;
    final yellowFill = Paint()..color = Colors.yellowAccent;

    // Diagonal stripes tape
    Path tape = Path()
      ..moveTo(-20, 50)
      ..lineTo(size.width, size.height / 2 + 50)
      ..lineTo(size.width, size.height / 2 + 80)
      ..lineTo(-20, 80)
      ..close();
    canvas.drawPath(tape, blackFill);

    // Safety pins or random Xs
    final r = Random(1234);
    for (int i = 0; i < 8; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      if (r.nextBool()) {
        canvas.drawLine(
          Offset(cx - 10, cy - 10),
          Offset(cx + 10, cy + 10),
          blackLine,
        );
        canvas.drawLine(
          Offset(cx + 10, cy - 10),
          Offset(cx - 10, cy + 10),
          blackLine,
        );
      } else {
        canvas.drawCircle(Offset(cx, cy), 15, yellowFill);
        canvas.drawCircle(Offset(cx, cy), 15, blackLine);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PopPunkPainter old) => color != old.color;
}

// 58. DESERT OASIS
class DesertOasisPainter extends DesignPainter {
  DesertOasisPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE08E79), Color(0xFFF1D4AF)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Sand dunes
    final dune1 = Paint()..color = const Color(0xFFC29B70);
    final dune2 = Paint()..color = const Color(0xFFD4B483);

    Path d1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(d1, dune1);

    Path d2 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.9)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.6,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(d2, dune2);

    // Small sun
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3),
      30,
      Paint()..color = const Color(0xFFFFFBEA).withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant DesertOasisPainter old) => color != old.color;
}

// 59. AUTUMN LEAVES
class AutumnLeavesPainter extends DesignPainter {
  AutumnLeavesPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFFF8E7),
    );

    final r = Random(999);
    final colors = [
      const Color(0xFFD35400).withValues(alpha: 0.6), // Orange
      const Color(0xFFC0392B).withValues(alpha: 0.6), // Red
      const Color(0xFFF39C12).withValues(alpha: 0.6), // Yellow
      const Color(0xFF795548).withValues(alpha: 0.6), // Brown
    ];

    for (int i = 0; i < 25; i++) {
      final paint = Paint()
        ..color = colors[r.nextInt(colors.length)]
        ..style = PaintingStyle.fill;
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double w = r.nextDouble() * 20 + 10;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(r.nextDouble() * pi);

      Path leaf = Path();
      leaf.moveTo(0, -w);
      leaf.quadraticBezierTo(w, -w / 2, 0, w);
      leaf.quadraticBezierTo(-w, -w / 2, 0, -w);
      canvas.drawPath(leaf, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant AutumnLeavesPainter old) => color != old.color;
}

// 60. SPRING BREEZE
class SpringBreezePainter extends DesignPainter {
  SpringBreezePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFE0F7FA), Color(0xFFF1F8E9)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final r = Random(111);
    final petalPaint = Paint()
      ..color = const Color(0xFFFCE4EC).withValues(alpha: 0.8);
    final windPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Wind curves
    for (int i = 0; i < 3; i++) {
      Path wind = Path();
      wind.moveTo(-40, r.nextDouble() * size.height);
      wind.quadraticBezierTo(
        size.width / 2,
        r.nextDouble() * size.height,
        size.width + 40,
        r.nextDouble() * size.height,
      );
      canvas.drawPath(wind, windPaint);
    }

    // Floating petals
    for (int i = 0; i < 40; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
            r.nextDouble() * size.width,
            r.nextDouble() * size.height,
          ),
          width: 12,
          height: 6,
        ),
        petalPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SpringBreezePainter old) => color != old.color;
}

// 61. WINTER FROST
class WinterFrostPainter extends DesignPainter {
  WinterFrostPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFE3F2FD),
    );

    final r = Random(222);
    final frost = Paint()..color = Colors.white.withValues(alpha: 0.6);

    // Frost spreading from corners
    for (int i = 0; i < 40; i++) {
      double cx = (r.nextDouble() < 0.5)
          ? r.nextDouble() * 50
          : size.width - r.nextDouble() * 50;
      double cy = (r.nextDouble() < 0.5)
          ? r.nextDouble() * 50
          : size.height - r.nextDouble() * 50;

      Path p = Path();
      p.moveTo(cx, cy);
      p.lineTo(cx + r.nextDouble() * 20 - 10, cy + r.nextDouble() * 20 - 10);
      p.lineTo(cx + r.nextDouble() * 20 - 10, cy + r.nextDouble() * 20 - 10);
      canvas.drawPath(
        p,
        frost
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Snowflakes
    for (int i = 0; i < 20; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 3,
        frost..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WinterFrostPainter old) => color != old.color;
}

// 62. MAJESTIC MOUNTAINS
class MajesticMountainsPainter extends DesignPainter {
  MajesticMountainsPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFFE0F6FF)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Back mountain
    Path m1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.3, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height)
      ..close();
    canvas.drawPath(m1, Paint()..color = const Color(0xFF90A4AE));

    // Front mountains
    Path m2 = Path()
      ..moveTo(-50, size.height)
      ..lineTo(size.width * 0.15, size.height * 0.6)
      ..lineTo(size.width * 0.5, size.height)
      ..close();
    canvas.drawPath(m2, Paint()..color = const Color(0xFF607D8B));

    Path m3 = Path()
      ..moveTo(size.width * 0.4, size.height)
      ..lineTo(size.width * 0.8, size.height * 0.5)
      ..lineTo(size.width + 50, size.height)
      ..close();
    canvas.drawPath(m3, Paint()..color = const Color(0xFF546E7A));

    // Snow caps
    Path s3 = Path()
      ..moveTo(size.width * 0.8, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.6)
      ..lineTo(size.width * 0.75, size.height * 0.65)
      ..lineTo(size.width * 0.8, size.height * 0.6)
      ..lineTo(size.width * 0.85, size.height * 0.65)
      ..lineTo(size.width * 0.9, size.height * 0.6)
      ..close();
    canvas.drawPath(s3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant MajesticMountainsPainter old) =>
      color != old.color;
}

// 63. STARRY NIGHT (Van Gogh inspired)
class VanGoghStarryPainter extends DesignPainter {
  VanGoghStarryPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0F2046),
    );

    final r = Random(333);
    final swirlPaint = Paint()
      ..color = const Color(0xFF4A90E2).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Swirls
    for (int i = 0; i < 5; i++) {
      Path swirl = Path();
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      swirl.moveTo(cx, cy);
      for (double t = 0; t < 4 * pi; t += 0.1) {
        // spiral math
        double rad = t * 10;
        swirl.lineTo(cx + rad * cos(t), cy + rad * sin(t));
      }
      canvas.drawPath(swirl, swirlPaint);
    }

    // Glowing stars
    final starPaint = Paint()..color = Colors.yellowAccent;
    final starGlow = Paint()
      ..color = Colors.yellowAccent.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    for (int i = 0; i < 10; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height * 0.7;
      canvas.drawCircle(Offset(cx, cy), 20, starGlow);
      canvas.drawCircle(Offset(cx, cy), 8, starGlow);
      canvas.drawCircle(Offset(cx, cy), 3, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant VanGoghStarryPainter old) => color != old.color;
}

// 64. DREAMCATCHER
class DreamcatcherPainter extends DesignPainter {
  DreamcatcherPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFAF0E6),
    );

    final linePaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final featherPaint = Paint()
      ..color = const Color(0xFF20B2AA)
      ..style = PaintingStyle.fill;

    // Main circle positioned top-center
    Offset center = Offset(size.width / 2, size.height * 0.3);
    canvas.drawCircle(center, 60, linePaint);
    canvas.drawCircle(center, 50, linePaint..strokeWidth = 1);

    // Web inside
    Path web = Path();
    for (int i = 0; i < 8; i++) {
      double a1 = i * (pi / 4);
      double a2 = (i + 1) * (pi / 4);
      web.moveTo(center.dx + cos(a1) * 60, center.dy + sin(a1) * 60);
      web.lineTo(
        center.dx + cos(a1 + (pi / 8)) * 30,
        center.dy + sin(a1 + (pi / 8)) * 30,
      );
      web.lineTo(center.dx + cos(a2) * 60, center.dy + sin(a2) * 60);
    }
    canvas.drawPath(web, linePaint);

    // Hanging feathers
    void drawFeather(Offset start, double length) {
      canvas.drawLine(start, Offset(start.dx, start.dy + length), linePaint);
      Path f = Path();
      f.moveTo(start.dx, start.dy + length * 0.2);
      f.quadraticBezierTo(
        start.dx + 15,
        start.dy + length * 0.5,
        start.dx,
        start.dy + length,
      );
      f.quadraticBezierTo(
        start.dx - 15,
        start.dy + length * 0.5,
        start.dx,
        start.dy + length * 0.2,
      );
      canvas.drawPath(f, featherPaint);
    }

    drawFeather(Offset(size.width / 2, center.dy + 60), 80);
    drawFeather(Offset(size.width / 2 - 40, center.dy + 45), 60);
    drawFeather(Offset(size.width / 2 + 40, center.dy + 45), 60);
  }

  @override
  bool shouldRepaint(covariant DreamcatcherPainter old) => color != old.color;
}

// 65. KALEIDOSCOPE
class KaleidoscopePainter extends DesignPainter {
  KaleidoscopePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    final r = Random(444);
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
    ];

    Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 5; i++) {
      final p = Paint()
        ..color = colors[r.nextInt(colors.length)].withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;
      double dist = r.nextDouble() * 50 + 20;
      double radius = r.nextDouble() * 30 + 10;

      for (int j = 0; j < 8; j++) {
        double angle = j * (pi / 4);
        canvas.drawCircle(
          Offset(center.dx + cos(angle) * dist, center.dy + sin(angle) * dist),
          radius,
          p,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant KaleidoscopePainter old) => color != old.color;
}

// 66. COMIC BOOK
class ComicBookPainter extends DesignPainter {
  ComicBookPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFADA5E),
    );

    final black = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final blueDot = Paint()
      ..color = Colors.blue.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Halftone dot bg
    for (double x = 10; x < size.width; x += 20) {
      for (double y = 10; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), ((x + y) % 40 == 0) ? 3 : 5, blueDot);
      }
    }

    // Action lines radiating from center
    Offset center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 12; i++) {
      double angle = i * (pi / 6);
      Path p = Path();
      p.moveTo(center.dx + cos(angle) * 50, center.dy + sin(angle) * 50);
      p.lineTo(
        center.dx + cos(angle - 0.1) * 300,
        center.dy + sin(angle - 0.1) * 300,
      );
      p.lineTo(
        center.dx + cos(angle + 0.1) * 300,
        center.dy + sin(angle + 0.1) * 300,
      );
      p.close();
      canvas.drawPath(p, Paint()..color = Colors.redAccent);
      canvas.drawPath(p, black);
    }

    // Starburst center Pow!
    Path star = Path();
    for (int i = 0; i < 10; i++) {
      double a1 = i * (pi / 5);
      double a2 = a1 + (pi / 10);
      if (i == 0)
        star.moveTo(center.dx + cos(a1) * 80, center.dy + sin(a1) * 80);
      else
        star.lineTo(center.dx + cos(a1) * 80, center.dy + sin(a1) * 80);
      star.lineTo(center.dx + cos(a2) * 30, center.dy + sin(a2) * 30);
    }
    star.close();
    canvas.drawPath(star, Paint()..color = Colors.yellow);
    canvas.drawPath(star, black);
  }

  @override
  bool shouldRepaint(covariant ComicBookPainter old) => color != old.color;
}
