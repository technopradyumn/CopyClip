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
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final redLine = Paint()
      ..color = Colors.red.withOpacity(0.1)
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
      ..color = Colors.black.withOpacity(0.05)
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
      ..color = Colors.black.withOpacity(0.15)
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
        colors: [Colors.brown.withOpacity(0.05), Colors.brown.withOpacity(0.2)],
        radius: 1.5,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Add some "stains"
    final stainPaint = Paint()..color = Colors.brown.withOpacity(0.1);
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
      ..color = Colors.white.withOpacity(0.1)
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
      ..color = Colors.white.withOpacity(0.2)
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
      ..color = Colors.grey.withOpacity(0.3)
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
    final paint = Paint()..color = Colors.white.withOpacity(0.15);

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
          Colors.black.withOpacity(0.2),
          Colors.transparent,
          Colors.white.withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Stitching
    final stitchPaint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.6)
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
      ..color = Colors.grey.withOpacity(0.1)
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
      ..color = Colors.cyan.withOpacity(0.3)
      ..strokeWidth = 1;

    for (double y = 50; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final marginPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
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
      ..color = Colors.white.withOpacity(0.05)
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

    paint.color = Colors.pinkAccent.withOpacity(0.05);
    canvas.drawCircle(Offset(size.width, 0), 100, paint);

    paint.color = Colors.blueAccent.withOpacity(0.05);
    canvas.drawCircle(Offset(0, size.height), 80, paint);

    paint.color = Colors.amberAccent.withOpacity(0.05);
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
          Colors.blue.withOpacity(0.1),
          Colors.purple.withOpacity(0.1),
          Colors.pink.withOpacity(0.1),
          Colors.blue.withOpacity(0.1),
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
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.5, paint);
    }

    // Moon
    paint.color = Colors.yellowAccent.withOpacity(0.1);
    canvas.drawCircle(Offset(size.width - 30, 30), 15, paint);
  }
}

// 16. GEOMETRIC MODERN
class GeometricModernPainter extends DesignPainter {
  GeometricModernPainter({required super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.03)
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
      ..color = Colors.greenAccent.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final dotPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.2)
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
      ..color = Colors.brown.withOpacity(0.1)
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
      ..color = Colors.grey.withOpacity(0.1)
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
    final paint = Paint()..color = Colors.brown.withOpacity(0.15);
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
      ..color = Colors.black.withOpacity(0.05)
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
