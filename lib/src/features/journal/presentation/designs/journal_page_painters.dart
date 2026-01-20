import 'package:flutter/material.dart';
import 'dart:math';

// --- BASE PAGE PAINTER ---
abstract class PageDesignPainter extends CustomPainter {
  final Color color;
  PageDesignPainter({required this.color});

  @override
  bool shouldRepaint(covariant PageDesignPainter oldDelegate) =>
      color != oldDelegate.color;
}

// 1. DEFAULT (Blank)
class BlankPagePainter extends PageDesignPainter {
  BlankPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {}
}

// 2. RULED (Wide)
class RuledWidePainter extends PageDesignPainter {
  RuledWidePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double y = 60; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Margin
    final marginPaint = Paint()
      ..color = Colors.red.withOpacity(0.1)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(40, 0), Offset(40, size.height), marginPaint);
  }
}

// 3. RULED (College)
class RuledCollegePainter extends PageDesignPainter {
  RuledCollegePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double y = 60; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Margin
    final marginPaint = Paint()
      ..color = Colors.red.withOpacity(0.1)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(40, 0), Offset(40, size.height), marginPaint);
  }
}

// 4. GRID (Graph)
class GridPagePainter extends PageDesignPainter {
  GridPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
}

// 5. DOT GRID
class DotGridPagePainter extends PageDesignPainter {
  DotGridPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    const step = 25.0;
    for (double x = step / 2; x < size.width; x += step) {
      for (double y = step / 2; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }
}

// 6. ISOMETRIC DOTS
class IsometricDotsPainter extends PageDesignPainter {
  IsometricDotsPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    const step = 30.0;
    for (double y = 0; y < size.height; y += step * 0.866) {
      bool oddRow = (y / (step * 0.866)).round().isOdd;
      for (double x = oddRow ? step / 2 : 0; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }
}

// 7. CRUMPLED PAPER
class CrumpledPagePainter extends PageDesignPainter {
  CrumpledPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final r = Random(1234);
    for (int i = 0; i < 20; i++) {
      Path p = Path();
      p.moveTo(r.nextDouble() * size.width, r.nextDouble() * size.height);
      p.lineTo(r.nextDouble() * size.width, r.nextDouble() * size.height);
      p.lineTo(r.nextDouble() * size.width, r.nextDouble() * size.height);
      canvas.drawPath(p, paint);
    }
  }
}

// 8. WATERCOLOR
class WatercolorPagePainter extends PageDesignPainter {
  WatercolorPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Subtle watercolor washes
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.purple.withOpacity(0.05),
          Colors.blue.withOpacity(0.05),
          Colors.transparent,
        ],
        radius: 0.8,
        center: const Alignment(0.5, -0.2),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.pink.withOpacity(0.05),
          Colors.orange.withOpacity(0.03),
          Colors.transparent,
        ],
        radius: 0.6,
        center: const Alignment(-0.3, 0.4),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint2);
  }
}

// 9. NIGHT SKY
class NightSkyPagePainter extends PageDesignPainter {
  NightSkyPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // bg variable removed

    // Actually, effective only if container color is dark or we draw bg.
    // Since we support custom colors, we'll just draw stars overlay.

    final starPaint = Paint()..color = Colors.white.withOpacity(0.3);
    final r = Random(999);

    for (int i = 0; i < 100; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 1.5,
        starPaint,
      );
    }
  }
}

// 10. GALAXY
class GalaxyPagePainter extends PageDesignPainter {
  GalaxyPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.deepPurple.withOpacity(0.1),
          Colors.indigo.withOpacity(0.1),
          Colors.pink.withOpacity(0.1),
          Colors.deepPurple.withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Stars
    final starPaint = Paint()..color = Colors.white.withOpacity(0.2);
    final r = Random(444);
    for (int i = 0; i < 60; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 1.2,
        starPaint,
      );
    }
  }
}

// 11. SUNSET
class SunsetPagePainter extends PageDesignPainter {
  SunsetPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.orange.withOpacity(0.1),
          Colors.pink.withOpacity(0.1),
          Colors.purple.withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }
}

// 12. FOREST
class ForestPagePainter extends PageDesignPainter {
  ForestPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green.withOpacity(0.05);

    final path = Path();
    // Draw some treeline at bottom?
    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 20) {
      path.lineTo(x, size.height - (x % 40 == 0 ? 30 : 10));
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Leaves/Particles
    final r = Random(55);
    for (int i = 0; i < 50; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        2,
        paint,
      );
    }
  }
}

// 13. BEACH
class BeachPagePainter extends PageDesignPainter {
  BeachPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Sand bottom, Ocean top
    final water = Paint()..color = Colors.cyan.withOpacity(0.05);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), water);

    final sand = Paint()..color = Colors.amber.withOpacity(0.1);
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.8,
      0,
      size.height * 0.9,
    );
    path.close();
    canvas.drawPath(path, sand);
  }
}

// 14. SOFT GRADIENT (Cotton Candy)
class SoftGradientPainter extends PageDesignPainter {
  SoftGradientPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.cyanAccent.withOpacity(0.05),
          Colors.pinkAccent.withOpacity(0.05),
          Colors.white.withOpacity(0.0),
        ],
        radius: 1.0,
        center: Alignment.center,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }
}

// 15. GEOMETRIC SHAPES
class GeometricShapesPainter extends PageDesignPainter {
  GeometricShapesPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black.withOpacity(0.05)
      ..strokeWidth = 1;
    final r = Random(99);

    for (int i = 0; i < 15; i++) {
      double s = r.nextDouble() * 50 + 20;
      double x = r.nextDouble() * size.width;
      double y = r.nextDouble() * size.height;
      if (r.nextBool()) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: s, height: s),
          paint,
        );
      } else {
        canvas.drawCircle(Offset(x, y), s / 2, paint);
      }
    }
  }
}

// 16. ABSTRACT CURVES
class AbstractCurvesPainter extends PageDesignPainter {
  AbstractCurvesPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.teal.withOpacity(0.05)
      ..strokeWidth = 2;
    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width,
      size.height * 0.3,
    );

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.6,
      size.width,
      size.height * 0.5,
    );

    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.9,
      size.width,
      size.height * 0.85,
    );
    canvas.drawPath(path, paint);
  }
}

// 17. MUSIC
class MusicPagePainter extends PageDesignPainter {
  MusicPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 1;

    // Staff lines
    for (double y = 60; y < size.height; y += 60) {
      for (int i = 0; i < 5; i++) {
        canvas.drawLine(
          Offset(0, y + i * 8),
          Offset(size.width, y + i * 8),
          linePaint,
        );
      }
    }
  }
}

// 18. CHECKLIST
class ChecklistPagePainter extends PageDesignPainter {
  ChecklistPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 1;
    final boxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1;

    for (double y = 60; y < size.height; y += 30) {
      canvas.drawLine(Offset(50, y), Offset(size.width, y), linePaint);
      canvas.drawRect(Rect.fromLTWH(20, y - 15, 15, 15), boxPaint);
    }
  }
}

// 19. TRIANGLES
class TrianglesPagePainter extends PageDesignPainter {
  TrianglesPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo.withOpacity(0.03)
      ..style = PaintingStyle.fill;
    final r = Random(33);
    for (int i = 0; i < 30; i++) {
      Path p = Path();
      double x = r.nextDouble() * size.width;
      double y = r.nextDouble() * size.height;
      p.moveTo(x, y);
      p.lineTo(x + 20, y + 40);
      p.lineTo(x - 20, y + 40);
      p.close();
      canvas.drawPath(p, paint);
    }
  }
}

// 20. HEXAGONS
class HexagonPagePainter extends PageDesignPainter {
  HexagonPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.05)
      ..style = PaintingStyle.stroke;

    // Just drawing a few big ones for style
    final r = Random(99);
    for (int i = 0; i < 10; i++) {
      double sizeR = r.nextDouble() * 40 + 20;
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;

      Path p = Path();
      for (int k = 0; k < 6; k++) {
        double angle = (pi / 3) * k;
        double x = cx + sizeR * cos(angle);
        double y = cy + sizeR * sin(angle);
        if (k == 0)
          p.moveTo(x, y);
        else
          p.lineTo(x, y);
      }
      p.close();
      canvas.drawPath(p, paint);
    }
  }
}

// 21. BLUEPRINT (Internal)
class BlueprintPagePainter extends PageDesignPainter {
  BlueprintPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Usually blueprint is white lines on blue, but if user picks this, they likely set bg blue.
    // So we draw white grid.
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1;
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
}