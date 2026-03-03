import 'package:flutter/material.dart';
import 'dart:math';

// --- BASE PAGE PAINTER ---
abstract class PageDesignPainter extends CustomPainter {
  final Color color;
  PageDesignPainter({required this.color});

  /// Returns a contrasting color (black or white) based on the background color.
  Color get contrastColor =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.dark
      ? Colors.white
      : Colors.black;

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
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double y = 60; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Margin
    final marginPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.1)
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
      ..color = Colors.blueAccent.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double y = 60; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Margin
    final marginPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.1)
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
      ..color = Colors.black.withValues(alpha: 0.15)
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

// 5. DOT GRID
class DotGridPagePainter extends PageDesignPainter {
  DotGridPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
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
      ..color = Colors.black.withValues(alpha: 0.1)
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
    // Background texture
    final bgPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final r = Random(1234);

    // Draw some shadow patches
    for (int i = 0; i < 8; i++) {
      Path blob = Path();
      blob.moveTo(r.nextDouble() * size.width, r.nextDouble() * size.height);
      for (int j = 0; j < 5; j++) {
        blob.quadraticBezierTo(
          r.nextDouble() * size.width,
          r.nextDouble() * size.height,
          r.nextDouble() * size.width,
          r.nextDouble() * size.height,
        );
      }
      canvas.drawPath(blob, bgPaint);
    }

    // Crease lines
    for (int i = 0; i < 25; i++) {
      Path p = Path();
      double startX = r.nextDouble() * size.width;
      double startY = r.nextDouble() * size.height;
      p.moveTo(startX, startY);
      p.lineTo(
        startX + (r.nextDouble() - 0.5) * 100,
        startY + (r.nextDouble() - 0.5) * 100,
      );
      p.lineTo(
        startX + (r.nextDouble() - 0.5) * 150,
        startY + (r.nextDouble() - 0.5) * 150,
      );
      canvas.drawPath(p, paint);
    }
  }
}

// 8. WATERCOLOR
class WatercolorPagePainter extends PageDesignPainter {
  WatercolorPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final r = Random(99);
    for (int i = 0; i < 5; i++) {
      final center = Offset(
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
      );
      final radius = r.nextDouble() * 300 + 100;
      final color = [
        Colors.purple,
        Colors.blue,
        Colors.pink,
        Colors.teal,
        Colors.orange,
      ][r.nextInt(5)];

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.0)],
          stops: const [0.2, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawCircle(center, radius, paint);
    }
  }
}

// 9. NIGHT SKY
class NightSkyPagePainter extends PageDesignPainter {
  NightSkyPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Dark bg gradient
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0F172A).withValues(alpha: 0.2),
          Color(0xFF1E293B).withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.4);
    final r = Random(999);

    // Stars
    for (int i = 0; i < 150; i++) {
      double s = r.nextDouble();
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        s < 0.9
            ? r.nextDouble() * 1.5
            : r.nextDouble() * 2.5 + 1, // varied sizes
        starPaint,
      );
    }

    // Moon
    final moonPaint = Paint()
      ..color = Colors.yellow[100]!.withValues(alpha: 0.3);
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.1),
      30,
      moonPaint,
    );
  }
}

// 10. GALAXY
class GalaxyPagePainter extends PageDesignPainter {
  GalaxyPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Nebula Clouds
    final paint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        colors: [
          Colors.deepPurple.withValues(alpha: 0.2),
          Colors.pink.withValues(alpha: 0.2),
          Colors.blue.withValues(alpha: 0.2),
          Colors.deepPurple.withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Core glow
    final glow = Paint()
      ..shader = RadialGradient(
        radius: 0.6,
        colors: [
          Colors.purpleAccent.withValues(alpha: 0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glow);

    // Stars
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.5);
    final r = Random(444);
    for (int i = 0; i < 80; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 1.5,
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
          Colors.orange.withValues(alpha: 0.3),
          Colors.deepOrange.withValues(alpha: 0.2),
          Colors.purple.withValues(alpha: 0.2),
          Colors.indigo.withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Sun
    final sunPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              Colors.yellow.withValues(alpha: 0.4),
              Colors.orange.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.8),
              radius: 100,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.8),
      100,
      sunPaint,
    );
  }
}

// 12. FOREST
class ForestPagePainter extends PageDesignPainter {
  ForestPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green.withValues(alpha: 0.2);

    final backTree = Paint()
      ..color = Colors.green[800]!.withValues(alpha: 0.15);

    final path = Path();
    // Background trees
    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 30) {
      path.lineTo(x, size.height - (x % 60 == 0 ? 60 : 20));
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, backTree);

    // Foreground trees shape
    final path2 = Path();
    path2.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 40) {
      path2.lineTo(x, size.height - (x % 80 == 0 ? 50 : 15));
    }
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint);
  }
}

// 13. BEACH
class BeachPagePainter extends PageDesignPainter {
  BeachPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Water
    final water = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
        colors: [
          Colors.cyan.withValues(alpha: 0.1),
          Colors.blue.withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), water);

    // Sand Curve
    final sand = Paint()..color = Colors.amber[200]!.withValues(alpha: 0.3);
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.6,
      0,
      size.height * 0.85,
    );
    path.close();
    canvas.drawPath(path, sand);

    // Foam line
    final foam = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final foamPath = Path();
    foamPath.moveTo(size.width, size.height * 0.7);
    foamPath.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.6,
      0,
      size.height * 0.85,
    );
    canvas.drawPath(foamPath, foam);
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
          Colors.cyanAccent.withValues(alpha: 0.05),
          Colors.pinkAccent.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.0),
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
      ..color = Colors.black.withValues(alpha: 0.05)
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
      ..color = Colors.teal.withValues(alpha: 0.05)
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
      ..color = Colors.black.withValues(alpha: 0.1)
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
      ..color = Colors.black.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    final boxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

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
      ..color = Colors.indigo.withValues(alpha: 0.03)
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
      ..color = Colors.amber.withValues(alpha: 0.05)
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
        if (k == 0) {
          p.moveTo(x, y);
        } else {
          p.lineTo(x, y);
        }
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
      ..color = Colors.white.withValues(alpha: 0.3)
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

// 22. CORNELL NOTES
class CornellPagePainter extends PageDesignPainter {
  CornellPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Ruling
    for (double y = 60; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Cue Column (Left)
    final cuePaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      cuePaint,
    );

    // Summary Section (Bottom)
    final summaryLineY = size.height - (size.height * 0.2);
    canvas.drawLine(
      Offset(0, summaryLineY),
      Offset(size.width, summaryLineY),
      cuePaint,
    );
  }
}

// 23. STORYBOARD
class StoryboardPagePainter extends PageDesignPainter {
  StoryboardPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double boxW = size.width * 0.4;
    final double boxH = boxW * 0.6; // 16:9 ish
    final double margin = (size.width - (boxW * 2)) / 3;

    for (double y = 60; y < size.height; y += boxH + 60) {
      // Left Box
      canvas.drawRect(Rect.fromLTWH(margin, y, boxW, boxH), paint);
      // Right Box
      canvas.drawRect(Rect.fromLTWH(margin * 2 + boxW, y, boxW, boxH), paint);

      // Lines below
      final linePaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.1)
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(margin, y + boxH + 15),
        Offset(margin + boxW, y + boxH + 15),
        linePaint,
      );
      canvas.drawLine(
        Offset(margin, y + boxH + 30),
        Offset(margin + boxW, y + boxH + 30),
        linePaint,
      );

      canvas.drawLine(
        Offset(margin * 2 + boxW, y + boxH + 15),
        Offset(margin * 2 + boxW * 2, y + boxH + 15),
        linePaint,
      );
      canvas.drawLine(
        Offset(margin * 2 + boxW, y + boxH + 30),
        Offset(margin * 2 + boxW * 2, y + boxH + 30),
        linePaint,
      );
    }
  }
}

// 24. HANDWRITING (Primary)
class HandwritingPagePainter extends PageDesignPainter {
  HandwritingPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final solid = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;
    final dashed = Paint()
      ..color = Colors.blue.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    const lineHeight = 60.0;
    for (double y = 60; y < size.height - lineHeight; y += lineHeight) {
      // Top Solid
      canvas.drawLine(Offset(0, y), Offset(size.width, y), solid);
      // Middle Dashed
      for (double x = 0; x < size.width; x += 10) {
        canvas.drawLine(
          Offset(x, y + lineHeight / 2),
          Offset(x + 5, y + lineHeight / 2),
          dashed,
        );
      }
      // Bottom Solid
      canvas.drawLine(
        Offset(0, y + lineHeight),
        Offset(size.width, y + lineHeight),
        solid,
      );
    }
  }
}

// 25. ENGINEERING GRID
class EngineeringGridPainter extends PageDesignPainter {
  EngineeringGridPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Minor Grid
    final minor = Paint()
      ..color = Colors.green.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minor);
    }
    for (double y = 0; y < size.height; y += 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minor);
    }

    // Major Grid
    final major = Paint()
      ..color = Colors.green.withValues(alpha: 0.25)
      ..strokeWidth = 1.0;
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), major);
    }
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), major);
    }
  }
}

// 26. CODE EDITOR
class CodeEditorPainter extends PageDesignPainter {
  CodeEditorPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Line Numbers bg
    final gutterPaint = Paint()..color = Colors.black.withValues(alpha: 0.05);
    canvas.drawRect(Rect.fromLTWH(0, 0, 40, size.height), gutterPaint);

    // Separator
    final linePaint = Paint()..color = Colors.grey.withValues(alpha: 0.2);
    canvas.drawLine(Offset(40, 0), Offset(40, size.height), linePaint);

    // Line Hints
    final contentPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    for (double y = 12; y < size.height; y += 24) {
      canvas.drawLine(Offset(45, y), Offset(size.width, y), contentPaint);
    }
  }
}

// 27. DIAMOND GRID
class DiamondGridPainter extends PageDesignPainter {
  DiamondGridPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    const spacing = 30.0;
    // Diagonals 1
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
    // Diagonals 2
    for (double i = 0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height),
        paint,
      );
    }
  }
}

// 28. CONFETTI
class ConfettiPainter extends PageDesignPainter {
  ConfettiPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final r = Random(777);
    final paint = Paint()..style = PaintingStyle.fill;
    final colors = [
      Colors.red.withValues(alpha: 0.15),
      Colors.blue.withValues(alpha: 0.15),
      Colors.green.withValues(alpha: 0.15),
      Colors.yellow.withValues(alpha: 0.15),
      Colors.purple.withValues(alpha: 0.15),
    ];

    for (int i = 0; i < 100; i++) {
      paint.color = colors[r.nextInt(colors.length)];
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 4 + 2,
        paint,
      );
    }
  }
}

// 29. BAMBOO
class BambooPainter extends PageDesignPainter {
  BambooPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withValues(alpha: 0.1)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final detail = Paint()
      ..color = Colors.green.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    final r = Random(12);

    for (double x = 20; x < size.width; x += 60) {
      for (double y = 0; y < size.height; y += 100) {
        double h = 80 + r.nextDouble() * 20;
        canvas.drawLine(Offset(x, y), Offset(x, y + h), paint);
        canvas.drawLine(Offset(x - 5, y), Offset(x + 5, y), detail); // Node
      }
    }
  }
}

// 30. CROSS GRID
class CrossGridPainter extends PageDesignPainter {
  CrossGridPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    const step = 40.0;

    for (double x = step; x < size.width; x += step) {
      for (double y = step; y < size.height; y += step) {
        canvas.drawLine(Offset(x - 3, y), Offset(x + 3, y), paint);
        canvas.drawLine(Offset(x, y - 3), Offset(x, y + 3), paint);
      }
    }
  }
}

// 31. RAINY DAY
class RainyDayPainter extends PageDesignPainter {
  RainyDayPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.2)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final r = Random(420);

    for (int i = 0; i < 200; i++) {
      double x = r.nextDouble() * size.width;
      double y = r.nextDouble() * size.height;
      canvas.drawLine(Offset(x, y), Offset(x - 5, y + 10), paint);
    }
  }
}

// 32. SHEET MUSIC (Grand)
class GrandStaffPainter extends PageDesignPainter {
  GrandStaffPainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    // Groups of 5 lines, spaced, then another group
    double y = 80;
    while (y < size.height - 100) {
      // Treble
      for (int i = 0; i < 5; i++) {
        canvas.drawLine(
          Offset(0, y + i * 8),
          Offset(size.width, y + i * 8),
          paint,
        );
      }
      // Bass
      double bassY = y + 80;
      for (int i = 0; i < 5; i++) {
        canvas.drawLine(
          Offset(0, bassY + i * 8),
          Offset(size.width, bassY + i * 8),
          paint,
        );
      }

      // Bar line connecting them at start
      canvas.drawLine(Offset(20, y), Offset(20, bassY + 4 * 8), paint);

      y += 180;
    }
  }
}

// 33. DOTTED LINE
class DottedLinePainter extends PageDesignPainter {
  DottedLinePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;
    for (double y = 40; y < size.height; y += 40) {
      for (double x = 0; x < size.width; x += 6) {
        canvas.drawCircle(Offset(x, y), 0.5, paint);
      }
    }
    final margin = Paint()
      ..color = Colors.red.withValues(alpha: 0.1)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(40, 0), Offset(40, size.height), margin);
  }
}

// 41. Wavy Lined
class WavyLinedPagePainter extends PageDesignPainter {
  WavyLinedPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Margin line
    final marginPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.1)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(45, 0), Offset(45, size.height), marginPaint);

    for (double y = 40; y < size.height; y += 30) {
      Path path = Path()..moveTo(0, y);
      for (double x = 0; x <= size.width; x += 20) {
        // More "hand-drawn" wavy look
        path.quadraticBezierTo(x + 10, y + (x % 40 == 0 ? 4 : -4), x + 20, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavyLinedPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 42. Hexagon Grid
class HexagonGridPagePainter extends PageDesignPainter {
  HexagonGridPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double radius = 18;
    double hexHeight = radius * sqrt(3);

    for (double y = 0; y < size.height + hexHeight; y += hexHeight) {
      bool offset = (y / hexHeight).round() % 2 != 0;
      for (
        double x = offset ? -radius * 1.5 : 0;
        x < size.width + radius * 3;
        x += radius * 3
      ) {
        Path hex = Path();
        for (int i = 0; i < 6; i++) {
          double angle = (2 * pi / 6 * i) + (pi / 6); // Rotated for "flat tops"
          double hx = x + radius * cos(angle);
          double hy = y + radius * sin(angle);
          if (i == 0)
            hex.moveTo(hx, hy);
          else
            hex.lineTo(hx, hy);
        }
        hex.close();
        canvas.drawPath(hex, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HexagonGridPagePainter old) =>
      color != old.color;
}

// 43. Triangle Grid
class TriangleGridPagePainter extends PageDesignPainter {
  TriangleGridPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double step = 32;
    // Horizontal lines
    for (double y = 0; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    double hStep = step / tan(pi / 3);
    // Diagonal lines
    for (
      double x = -size.height;
      x < size.width + size.height;
      x += hStep * 2
    ) {
      // Forward slash lines
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height / tan(pi / 3), size.height),
        paint,
      );
      // Back slash lines
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height / tan(pi / 3), size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TriangleGridPagePainter old) =>
      color != old.color;
}

// 44. Brick Wall
class BrickWallPagePainter extends PageDesignPainter {
  BrickWallPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    double h = 24;
    double w = 54;

    for (double y = 0; y < size.height + h; y += h) {
      // Horizontal joint
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

      bool offset = (y / h).round() % 2 != 0;
      for (double x = offset ? -w / 2 : 0; x < size.width + w; x += w) {
        // Vertical joint
        canvas.drawLine(Offset(x, y), Offset(x, y + h), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BrickWallPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 45. Scallop
class ScallopPagePainter extends PageDesignPainter {
  ScallopPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    double radius = 18;
    for (double y = radius; y < size.height + radius * 2; y += radius) {
      bool offset = (y / radius).round() % 2 != 0;
      for (
        double x = offset ? -radius : 0;
        x < size.width + radius * 2;
        x += radius * 2
      ) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(x, y), radius: radius),
          pi,
          pi,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ScallopPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 46. Chevron
class ChevronPagePainter extends PageDesignPainter {
  ChevronPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    double gap = 40;
    for (double y = -gap; y < size.height + gap; y += gap) {
      Path path = Path();
      for (double x = 0; x <= size.width + gap; x += gap) {
        if (x == 0)
          path.moveTo(x, y + (x / gap).round() % 2 * 15);
        else
          path.lineTo(x, y + (x / gap).round() % 2 * 15);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ChevronPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 47. Argyle
class ArgylePagePainter extends PageDesignPainter {
  ArgylePagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = contrastColor.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    final dashPaint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double w = 70;
    double h = 100;
    for (double y = 0; y < size.height + h; y += h) {
      for (double x = 0; x < size.width + w; x += w) {
        // Diamond fill
        Path p = Path()
          ..moveTo(x, y - h / 2)
          ..lineTo(x + w / 2, y)
          ..lineTo(x, y + h / 2)
          ..lineTo(x - w / 2, y)
          ..close();
        if (((x / w).round() + (y / h).round()) % 2 == 0) {
          canvas.drawPath(p, fillPaint);
        }

        // Stitched lines (dashed)
        _drawDashedLine(
          canvas,
          Offset(x - w / 2, y - h / 2),
          Offset(x + w / 2, y + h / 2),
          dashPaint,
        );
        _drawDashedLine(
          canvas,
          Offset(x + w / 2, y - h / 2),
          Offset(x - w / 2, y + h / 2),
          dashPaint,
        );
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashW = 4.0;
    const spaceW = 4.0;
    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;
    double len = sqrt(dx * dx + dy * dy);
    dx /= len;
    dy /= len;
    double cur = 0;
    while (cur < len) {
      canvas.drawLine(
        Offset(p1.dx + dx * cur, p1.dy + dy * cur),
        Offset(
          p1.dx + dx * min(cur + dashW, len),
          p1.dy + dy * min(cur + dashW, len),
        ),
        paint,
      );
      cur += dashW + spaceW;
    }
  }

  @override
  bool shouldRepaint(covariant ArgylePagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 48. Houndstooth
class HoundstoothPagePainter extends PageDesignPainter {
  HoundstoothPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    double sq = 24;
    for (double y = 0; y < size.height + sq * 2; y += sq * 2) {
      for (double x = 0; x < size.width + sq * 2; x += sq * 2) {
        // Main square
        canvas.drawRect(Rect.fromLTWH(x, y, sq, sq), paint);
        // Connecting square
        canvas.drawRect(Rect.fromLTWH(x + sq, y + sq, sq, sq), paint);

        // The "tooth" paths
        Path tooth1 = Path()
          ..moveTo(x, y + sq)
          ..lineTo(x + sq / 2, y + sq * 1.5)
          ..lineTo(x + sq, y + sq)
          ..close();
        canvas.drawPath(tooth1, paint);

        Path tooth2 = Path()
          ..moveTo(x + sq, y)
          ..lineTo(x + sq * 1.5, y + sq / 2)
          ..lineTo(x + sq, y + sq)
          ..close();
        canvas.drawPath(tooth2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HoundstoothPagePainter old) =>
      color != old.color;
}

// 49. Tartan
class TartanPagePainter extends PageDesignPainter {
  TartanPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
    final strongPaint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    // Vertical bands
    for (double x = 0; x < size.width + 100; x += 100) {
      canvas.drawRect(Rect.fromLTWH(x + 10, 0, 30, size.height), paint);
      canvas.drawRect(Rect.fromLTWH(x + 20, 0, 8, size.height), strongPaint);
      canvas.drawRect(Rect.fromLTWH(x + 60, 0, 4, size.height), strongPaint);
    }
    // Horizontal bands
    for (double y = 0; y < size.height + 100; y += 100) {
      canvas.drawRect(Rect.fromLTWH(0, y + 10, size.width, 30), paint);
      canvas.drawRect(Rect.fromLTWH(0, y + 20, size.width, 8), strongPaint);
      canvas.drawRect(Rect.fromLTWH(0, y + 60, size.width, 4), strongPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TartanPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 50. Micro-dot
class MicroDotPagePainter extends PageDesignPainter {
  MicroDotPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    // More precise micro-dots
    for (double y = 8; y < size.height; y += 12) {
      for (double x = 8; x < size.width; x += 12) {
        canvas.drawCircle(Offset(x, y), 0.7, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MicroDotPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 51. Starfield
class StarfieldPagePainter extends PageDesignPainter {
  StarfieldPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    final r = Random(42);
    for (int i = 0; i < 200; i++) {
      double x = r.nextDouble() * size.width;
      double y = r.nextDouble() * size.height;
      double s = r.nextDouble() * 1.5 + 0.5; // Smaller, more delicate stars

      if (r.nextDouble() > 0.8) {
        // Star with 4 points
        Path star = Path()
          ..moveTo(x, y - s * 2)
          ..lineTo(x + s / 2, y - s / 2)
          ..lineTo(x + s * 2, y)
          ..lineTo(x + s / 2, y + s / 2)
          ..lineTo(x, y + s * 2)
          ..lineTo(x - s / 2, y + s / 2)
          ..lineTo(x - s * 2, y)
          ..lineTo(x - s / 2, y - s / 2)
          ..close();
        canvas.drawPath(star, paint);
      } else {
        // Simple dot star
        canvas.drawCircle(Offset(x, y), s / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 52. Plaid
class PlaidPagePainter extends PageDesignPainter {
  PlaidPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()
      ..color = contrastColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final p2 = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double step = 60;
    for (double x = 0; x < size.width + step; x += step) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 20, size.height), p1);
      canvas.drawLine(Offset(x + 30, 0), Offset(x + 30, size.height), p2);
    }
    for (double y = 0; y < size.height + step; y += step) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 20), p1);
      canvas.drawLine(Offset(0, y + 30), Offset(size.width, y + 30), p2);
    }
  }

  @override
  bool shouldRepaint(covariant PlaidPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 53. Abstract Shapes
class AbstractShapesPagePainter extends PageDesignPainter {
  AbstractShapesPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = contrastColor.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final r = Random(99);
    for (int i = 0; i < 35; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double radius = r.nextDouble() * 30 + 10;
      int type = r.nextInt(3);
      if (type == 0) {
        canvas.drawCircle(Offset(cx, cy), radius, fill);
        canvas.drawCircle(Offset(cx, cy), radius, stroke);
      } else if (type == 1) {
        Rect rect = Rect.fromCenter(
          center: Offset(cx, cy),
          width: radius * 1.5,
          height: radius,
        );
        canvas.drawRect(rect, fill);
        canvas.drawRect(rect, stroke);
      } else {
        canvas.drawPath(
          Path()
            ..moveTo(cx, cy - radius)
            ..lineTo(cx + radius, cy + radius)
            ..lineTo(cx - radius, cy + radius)
            ..close(),
          stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant AbstractShapesPagePainter old) =>
      color != old.color;
}

// 54. Circuit Board
class CircuitBoardPagePainter extends PageDesignPainter {
  CircuitBoardPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    final fill = Paint()
      ..color = contrastColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final r = Random(7);
    for (int i = 0; i < 30; i++) {
      double sx = r.nextDouble() * size.width;
      double sy = r.nextDouble() * size.height;

      double dx = sx + (r.nextDouble() > 0.5 ? 50 : -50);
      double dy = sy + (r.nextDouble() > 0.5 ? 50 : -50);

      // Orthogonal paths
      Path path = Path()..moveTo(sx, sy);
      if (r.nextBool()) {
        path.lineTo(dx, sy);
        path.lineTo(dx, dy);
      } else {
        path.lineTo(sx, dy);
        path.lineTo(dx, dy);
      }

      canvas.drawPath(path, paint);
      canvas.drawCircle(Offset(sx, sy), 3.5, fill);
      if (r.nextBool()) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset(dx, dy), width: 7, height: 7),
          fill,
        );
      } else {
        canvas.drawCircle(Offset(dx, dy), 3.5, fill);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CircuitBoardPagePainter old) =>
      color != old.color;
}

// 55. Topography
class TopographyPagePainter extends PageDesignPainter {
  TopographyPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final r = Random(88);
    for (int layer = 0; layer < 6; layer++) {
      Path path = Path();
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;

      for (double angle = 0; angle < pi * 2; angle += 0.1) {
        double rad = 40 + layer * 25 + r.nextDouble() * 15;
        double x = cx + rad * cos(angle);
        double y = cy + rad * sin(angle);
        if (angle == 0)
          path.moveTo(x, y);
        else
          path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TopographyPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 56. Puzzle Pieces
class PuzzlePiecesPagePainter extends PageDesignPainter {
  PuzzlePiecesPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    double sq = 50;
    for (double y = 0; y < size.height + sq; y += sq) {
      for (double x = 0; x < size.width + sq; x += sq) {
        // Horizontal and vertical lines with "tabs"
        _drawPuzzleLine(canvas, Offset(x, y), Offset(x + sq, y), paint, true);
        _drawPuzzleLine(canvas, Offset(x, y), Offset(x, y + sq), paint, false);
      }
    }
  }

  void _drawPuzzleLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint,
    bool horizontal,
  ) {
    double midX = (p1.dx + p2.dx) / 2;
    double midY = (p1.dy + p2.dy) / 2;
    double r = 8;

    if (horizontal) {
      canvas.drawLine(p1, Offset(midX - r, midY), paint);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(midX, midY), radius: r),
        pi,
        pi,
        false,
        paint,
      );
      canvas.drawLine(Offset(midX + r, midY), p2, paint);
    } else {
      canvas.drawLine(p1, Offset(midX, midY - r), paint);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(midX, midY), radius: r),
        -pi / 2,
        pi,
        false,
        paint,
      );
      canvas.drawLine(Offset(midX, midY + r), p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PuzzlePiecesPagePainter old) =>
      color != old.color;
}

// 57. Floral Vintage
class FloralVintagePagePainter extends PageDesignPainter {
  FloralVintagePagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final r = Random(15);
    for (int i = 0; i < 35; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double scale = r.nextDouble() * 0.8 + 0.5;

      // Draw 5-petaled flower
      for (int a = 0; a < 5; a++) {
        double angle = a * 2 * pi / 5;
        double hx = cx + 12 * scale * cos(angle);
        double hy = cy + 12 * scale * sin(angle);
        canvas.drawCircle(Offset(hx, hy), 7 * scale, stroke);
      }
      canvas.drawCircle(Offset(cx, cy), 4 * scale, stroke);

      // Stem/leaf hint
      if (r.nextBool()) {
        canvas.drawArc(
          Rect.fromLTWH(cx - 20, cy + 15, 40, 40),
          pi,
          pi / 2,
          false,
          stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant FloralVintagePagePainter old) =>
      color != old.color;
}

// 58. Music Notes
class MusicNotesPagePainter extends PageDesignPainter {
  MusicNotesPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    final r = Random(999);
    for (int i = 0; i < 35; i++) {
      double x = r.nextDouble() * (size.width - 40) + 20;
      double y = r.nextDouble() * (size.height - 40) + 20;

      // Note head
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-pi / 8);
      canvas.drawOval(Rect.fromLTWH(-5, -4, 10, 8), paint);
      canvas.restore();

      // Stem
      canvas.drawRect(Rect.fromLTWH(x + 4, y - 22, 1.5, 22), paint);

      // Flag or beam
      if (r.nextBool()) {
        canvas.drawRect(
          Rect.fromLTWH(x + 5, y - 22, 10, 4),
          paint,
        ); // Single note beam
      } else {
        Path flag = Path()
          ..moveTo(x + 5, y - 22)
          ..quadraticBezierTo(x + 15, y - 15, x + 12, y - 5)
          ..lineTo(x + 12, y - 2)
          ..quadraticBezierTo(x + 15, y - 12, x + 5, y - 18)
          ..close();
        canvas.drawPath(flag, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MusicNotesPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 59. Film Strip
class FilmStripPagePainter extends PageDesignPainter {
  FilmStripPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final fill = Paint()
      ..color = contrastColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    double stripW = 80;
    for (double x = 40; x < size.width; x += 150) {
      canvas.drawRect(Rect.fromLTWH(x, 0, stripW, size.height), stroke);
      // Sprocket holes
      for (double y = 10; y < size.height; y += 25) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x + 5, y, 10, 12),
            Radius.circular(2),
          ),
          fill,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x + stripW - 15, y, 10, 12),
            Radius.circular(2),
          ),
          fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant FilmStripPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 60. Bookshelf
class BookshelfPagePainter extends PageDesignPainter {
  BookshelfPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = contrastColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final mark = Paint()
      ..color = contrastColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final r = Random(1);

    for (double y = 100; y < size.height; y += 120) {
      // Shelf line
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);

      double x = 20;
      while (x < size.width - 40) {
        double bw = r.nextDouble() * 15 + 10;
        double bh = r.nextDouble() * 50 + 40;

        // Book outline
        canvas.drawRect(Rect.fromLTWH(x, y - bh, bw, bh), line);
        // Design on spine
        if (r.nextBool()) {
          canvas.drawLine(
            Offset(x + 4, y - bh + 10),
            Offset(x + bw - 4, y - bh + 10),
            line,
          );
          canvas.drawLine(
            Offset(x + 4, y - bh + 15),
            Offset(x + bw - 4, y - bh + 15),
            line,
          );
        } else {
          canvas.drawCircle(Offset(x + bw / 2, y - bh + 15), bw / 4, mark);
        }

        x += bw + (r.nextDouble() * 4 + 2);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BookshelfPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 61. Constellations
class ConstellationsPagePainter extends PageDesignPainter {
  ConstellationsPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final fill = Paint()
      ..color = contrastColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final r = Random(12);
    for (int i = 0; i < 18; i++) {
      double sx = r.nextDouble() * (size.width - 60) + 30;
      double sy = r.nextDouble() * (size.height - 60) + 30;

      int starsCount = r.nextInt(4) + 3;
      List<Offset> points = [];
      for (int j = 0; j < starsCount; j++) {
        points.add(
          Offset(
            sx + (r.nextDouble() - 0.5) * 80,
            sy + (r.nextDouble() - 0.5) * 80,
          ),
        );
      }

      for (int j = 0; j < points.length - 1; j++) {
        canvas.drawLine(points[j], points[j + 1], stroke);
      }
      for (var p in points) {
        canvas.drawCircle(p, r.nextDouble() * 2 + 1, fill);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ConstellationsPagePainter old) =>
      color != old.color;
}

// 62. Coffee Stains
class CoffeeStainsPagePainter extends PageDesignPainter {
  CoffeeStainsPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final r = Random(55);
    for (int i = 0; i < 7; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double rad = r.nextDouble() * 45 + 25;
      final stain = Paint()
        ..color = contrastColor.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r.nextDouble() * 3 + 1;

      // Ring stain
      canvas.drawCircle(Offset(cx, cy), rad, stain);
      // Secondary slightly offset ring for "drying" effect
      canvas.drawCircle(
        Offset(cx + 2, cy + 1),
        rad * 0.98,
        stain..strokeWidth = 0.5,
      );

      // splatter
      for (int j = 0; j < 8; j++) {
        double angle = r.nextDouble() * pi * 2;
        double dist = r.nextDouble() * rad * 1.5;
        canvas.drawCircle(
          Offset(cx + cos(angle) * dist, cy + sin(angle) * dist),
          r.nextDouble() * 3 + 0.5,
          Paint()
            ..color = contrastColor.withValues(alpha: 0.05)
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CoffeeStainsPagePainter old) =>
      color != old.color;
}

// 63. Woven
class WovenPagePainter extends PageDesignPainter {
  WovenPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    const step = 20.0;
    for (double i = 0; i < size.width + size.height; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(0, i), paint);
      canvas.drawLine(
        Offset(i - size.height, size.height),
        Offset(i, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WovenPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 64. Scale Pattern
class ScalePatternPagePainter extends PageDesignPainter {
  ScalePatternPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    double r = 20;
    for (double y = 0; y < size.height + r * 2; y += r) {
      bool offset = (y / r).round() % 2 != 0;
      for (double x = offset ? -r : 0; x < size.width + r; x += r * 2) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(x, y), radius: r),
          0,
          pi,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ScalePatternPagePainter old) =>
      color != old.color;
}

// 65. Raindrops
class RaindropsPagePainter extends PageDesignPainter {
  RaindropsPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    final r = Random(22);
    for (int i = 0; i < 45; i++) {
      double dx = r.nextDouble() * size.width;
      double dy = r.nextDouble() * size.height;
      double scale = r.nextDouble() * 0.5 + 0.5;

      Path drop = Path()
        ..moveTo(dx, dy)
        ..quadraticBezierTo(
          dx - (6 * scale),
          dy + (12 * scale),
          dx,
          dy + (18 * scale),
        )
        ..quadraticBezierTo(dx + (6 * scale), dy + (12 * scale), dx, dy)
        ..close();
      canvas.drawPath(drop, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RaindropsPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 66. Mountain Peaks
class MountainPeaksPagePainter extends PageDesignPainter {
  MountainPeaksPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final r = Random(34);
    for (double y = 100; y < size.height + 100; y += 120) {
      Path path = Path()..moveTo(0, y);
      double x = 0;
      while (x < size.width) {
        double segmentW = r.nextDouble() * 40 + 30;
        double peakH = r.nextDouble() * 30 + 15;
        path.lineTo(x + segmentW / 2, y - peakH);
        path.lineTo(x + segmentW, y);
        x += segmentW;
      }
      canvas.drawPath(path, paint);
      // Subtle shading lines
      for (double lx = 20; lx < size.width; lx += 100) {
        canvas.drawLine(Offset(lx, y), Offset(lx + 5, y - 10), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MountainPeaksPagePainter old) =>
      color != old.color;
}

// 67. Wavy Diagonal
class WavyDiagonalPagePainter extends PageDesignPainter {
  WavyDiagonalPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    double spacing = 45;
    for (double i = -size.height; i < size.width; i += spacing) {
      Path p = Path()..moveTo(i, 0);
      for (double y = 0; y < size.height; y += 40) {
        p.quadraticBezierTo(i + y + 15, y + 20, i + y, y + 40);
      }
      canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavyDiagonalPagePainter old) =>
      color != old.color;
}

// 68. Corkboard
class CorkboardPagePainter extends PageDesignPainter {
  CorkboardPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final r = Random(66);
    for (int i = 0; i < 400; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double dim = r.nextDouble() * 2 + 1;
      // Irregular grain
      canvas.drawRect(Rect.fromLTWH(cx, cy, dim, dim * 1.5), paint);
    }
    // Subtle large stains
    final stainPaint = Paint()..color = contrastColor.withValues(alpha: 0.03);
    for (int i = 0; i < 10; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        r.nextDouble() * 60 + 20,
        stainPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CorkboardPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 69. Blueprint
class DraftingBlueprintPagePainter extends PageDesignPainter {
  DraftingBlueprintPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Blueprint should ideally use white lines on blue background.
    // If not blue, we use contrastColor with high visibility.
    final lineAlpha = (color == Colors.blue || color.blue > 150) ? 0.4 : 0.15;

    final linePaint = Paint()
      ..color = (color == Colors.blue ? Colors.white : contrastColor)
          .withValues(alpha: lineAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final thickLine = Paint()
      ..color = (color == Colors.blue ? Colors.white : contrastColor)
          .withValues(alpha: lineAlpha * 1.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    double step = 20;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        x % 100 == 0 ? thickLine : linePaint,
      );
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        y % 100 == 0 ? thickLine : linePaint,
      );
    }

    // Circular technical marking
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      60,
      thickLine,
    );
    canvas.drawLine(
      Offset(size.width * 0.8 - 70, size.height * 0.2),
      Offset(size.width * 0.8 + 70, size.height * 0.2),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.2 - 70),
      Offset(size.width * 0.8, size.height * 0.2 + 70),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant DraftingBlueprintPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 70. Minimalist Grid
class MinimalistGridPagePainter extends PageDesignPainter {
  MinimalistGridPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    double step = 30;
    for (double x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, step), Offset(x, size.height - step), paint);
    }
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(step, y), Offset(size.width - step, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant MinimalistGridPagePainter old) =>
      color != old.color;
}

// 71. Japanese Asanoha
class JapaneseAsanohaPagePainter extends PageDesignPainter {
  JapaneseAsanohaPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    double w = 50;
    double h = w * sqrt(3) / 2;
    for (double y = 0; y < size.height + h * 2; y += h) {
      bool offset = (y / h).round() % 2 != 0;
      for (double x = offset ? -w / 2 : 0; x < size.width + w; x += w) {
        Path p = Path();
        p.moveTo(x, y - h);
        p.lineTo(x + w / 2, y);
        p.lineTo(x, y + h);
        p.lineTo(x - w / 2, y);
        p.close();
        canvas.drawPath(p, paint);
        canvas.drawLine(Offset(x, y - h), Offset(x, y + h), paint);
        canvas.drawLine(
          Offset(x - w / 2, y),
          Offset(x + w / 2, y),
          paint..strokeWidth = 0.6,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant JapaneseAsanohaPagePainter old) =>
      color != old.color;
}

// 72. Honeycomb
class HoneycombPagePainter extends PageDesignPainter {
  HoneycombPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    double r = 20;
    double h = sqrt(3) * r;
    for (double y = 0; y < size.height + h; y += h) {
      bool offset = (y / h).round() % 2 != 0;
      for (
        double x = offset ? -1.5 * r : 0;
        x < size.width + 1.5 * r;
        x += 3 * r
      ) {
        Path hex = Path();
        for (int i = 0; i < 6; i++) {
          double px = x + r * cos(i * pi / 3);
          double py = y + r * sin(i * pi / 3);
          if (i == 0)
            hex.moveTo(px, py);
          else
            hex.lineTo(px, py);
        }
        hex.close();
        canvas.drawPath(hex, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HoneycombPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 73. Polka Dots Large
class PolkaDotsLargePagePainter extends PageDesignPainter {
  PolkaDotsLargePagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    double gap = 70;
    for (double y = 30; y < size.height; y += gap) {
      bool offset = (y / gap).round() % 2 != 0;
      for (double x = offset ? -gap / 2 : 0; x < size.width + gap; x += gap) {
        canvas.drawCircle(Offset(x, y), 18, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PolkaDotsLargePagePainter old) =>
      color != old.color;
}

// 74. Abstract Curves
class AbstractCurvesPagePainter extends PageDesignPainter {
  AbstractCurvesPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (int i = 0; i < 12; i++) {
      Path p = Path()..moveTo(0, i * 110.0);
      p.cubicTo(
        size.width * 0.35,
        i * 110.0 + 80,
        size.width * 0.65,
        i * 110.0 - 80,
        size.width,
        i * 110.0 + 30,
      );
      canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant AbstractCurvesPagePainter old) =>
      color != old.color;
}

// 75. Trellis
class TrellisPagePainter extends PageDesignPainter {
  TrellisPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const step = 50.0;
    for (double x = 0; x < size.width + step; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      canvas.drawLine(
        Offset(x - 8, 0),
        Offset(x - 8, size.height),
        paint..strokeWidth = 0.5,
      );
    }
    for (double y = 0; y < size.height + step; y += step) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint..strokeWidth = 1.5,
      );
      canvas.drawLine(
        Offset(0, y - 8),
        Offset(size.width, y - 8),
        paint..strokeWidth = 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TrellisPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 76. Pinwheels
class PinwheelsPagePainter extends PageDesignPainter {
  PinwheelsPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    double step = 100;
    for (double y = 50; y < size.height + step; y += step) {
      for (double x = 50; x < size.width + step; x += step) {
        _drawPinwheel(canvas, x, y, 20, paint);
      }
    }
  }

  void _drawPinwheel(Canvas canvas, double x, double y, double s, Paint paint) {
    for (int i = 0; i < 4; i++) {
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(i * pi / 2);
      Path p = Path()
        ..moveTo(0, 0)
        ..lineTo(s, 0)
        ..quadraticBezierTo(s, s, 0, s)
        ..close();
      canvas.drawPath(p, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant PinwheelsPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 77. Moroccan Tile
class MoroccanTilePagePainter extends PageDesignPainter {
  MoroccanTilePagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    double step = 70;
    for (double y = 35; y < size.height + step; y += step) {
      for (double x = 35; x < size.width + step; x += step) {
        Path p = Path()
          ..moveTo(x, y - 25)
          ..quadraticBezierTo(x + 12, y - 12, x + 25, y)
          ..quadraticBezierTo(x + 12, y + 12, x, y + 25)
          ..quadraticBezierTo(x - 12, y + 12, x - 25, y)
          ..quadraticBezierTo(x - 12, y - 12, x, y - 25)
          ..close();
        canvas.drawPath(p, paint);
        canvas.drawCircle(Offset(x, y), 4, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
      }
    }
  }

  @override
  bool shouldRepaint(covariant MoroccanTilePagePainter old) =>
      color != old.color;
}

// 78. Plus Grid
class PlusGridPagePainter extends PageDesignPainter {
  PlusGridPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    double step = 40;
    for (double y = 20; y < size.height; y += step) {
      for (double x = 20; x < size.width; x += step) {
        canvas.drawLine(Offset(x - 4, y), Offset(x + 4, y), paint);
        canvas.drawLine(Offset(x, y - 4), Offset(x, y + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PlusGridPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 79. Hex Triangles
class HexTrianglesPagePainter extends PageDesignPainter {
  HexTrianglesPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    double step = 80;
    for (double y = 0; y < size.height + step; y += step) {
      for (double x = 0; x < size.width + step; x += step) {
        // Cross lines
        canvas.drawLine(Offset(x, y), Offset(x + step, y + step), paint);
        canvas.drawLine(Offset(x + step, y), Offset(x, y + step), paint);
        // Vertical/Horizontal central lines
        canvas.drawLine(
          Offset(x + step / 2, y),
          Offset(x + step / 2, y + step),
          paint..strokeWidth = 0.6,
        );
        canvas.drawLine(
          Offset(x, y + step / 2),
          Offset(x + step, y + step / 2),
          paint,
        );
        paint.strokeWidth = 1.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant HexTrianglesPagePainter old) =>
      color != old.color;
}

// 80. Diagonal Dashes
class DiagonalDashesPagePainter extends PageDesignPainter {
  DiagonalDashesPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    double spacing = 35;
    for (double y = -size.width; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += 25) {
        double curY = y + x;
        if (curY >= 0 && curY <= size.height) {
          canvas.drawLine(Offset(x, curY), Offset(x + 10, curY + 10), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant DiagonalDashesPagePainter old) =>
      color != old.color;
}

// 81. Squiggles
class SquigglesPagePainter extends PageDesignPainter {
  SquigglesPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final r = Random(11);
    for (int i = 0; i < 55; i++) {
      double sx = r.nextDouble() * size.width;
      double sy = r.nextDouble() * size.height;
      Path p = Path()..moveTo(sx, sy);
      double curX = sx;
      double curY = sy;
      for (int j = 0; j < 4; j++) {
        double nx = curX + (r.nextDouble() - 0.5) * 60;
        double ny = curY + (r.nextDouble() - 0.5) * 60;
        p.quadraticBezierTo(
          curX + (r.nextDouble() - 0.5) * 30,
          curY + (r.nextDouble() - 0.5) * 30,
          nx,
          ny,
        );
        curX = nx;
        curY = ny;
      }
      canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SquigglesPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 82. Sunbursts
class SunburstsPagePainter extends PageDesignPainter {
  SunburstsPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    double step = 120;
    for (double y = step / 2; y < size.height; y += step) {
      for (double x = step / 2; x < size.width; x += step) {
        for (int i = 0; i < 16; i++) {
          double angle = i * pi / 8;
          canvas.drawLine(
            Offset(x + 8 * cos(angle), y + 8 * sin(angle)),
            Offset(x + 25 * cos(angle), y + 25 * sin(angle)),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant SunburstsPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 83. Origami
class OrigamiPagePainter extends PageDesignPainter {
  OrigamiPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final r = Random(42);
    for (int i = 0; i < 35; i++) {
      double cx = r.nextDouble() * size.width;
      double cy = r.nextDouble() * size.height;
      double s = r.nextDouble() * 30 + 20;

      Path p = Path()
        ..moveTo(cx, cy - s)
        ..lineTo(cx + s * 0.8, cy + s * 0.4)
        ..lineTo(cx - s * 0.4, cy + s * 0.8)
        ..lineTo(cx - s, cy)
        ..close();
      canvas.drawPath(p, paint);
      // Folds
      canvas.drawLine(
        Offset(cx, cy - s),
        Offset(cx - s * 0.4, cy + s * 0.8),
        paint..strokeWidth = 0.5,
      );
      paint.strokeWidth = 1.0;
    }
  }

  @override
  bool shouldRepaint(covariant OrigamiPagePainter oldDelegate) =>
      color != oldDelegate.color;
}

// 84. Retro Circles
class RetroCirclesPagePainter extends PageDesignPainter {
  RetroCirclesPagePainter({required super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contrastColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final paintFill = Paint()
      ..color = contrastColor.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    double step = 100;
    for (double y = 0; y < size.height + step; y += step) {
      for (double x = 0; x < size.width + step; x += step) {
        canvas.drawCircle(Offset(x, y), 40, paint);
        canvas.drawCircle(Offset(x, y), 25, paintFill);
        canvas.drawCircle(Offset(x, y), 12, paint..strokeWidth = 1.0);
        paint.strokeWidth = 2.5;
      }
    }
  }

  @override
  bool shouldRepaint(covariant RetroCirclesPagePainter old) =>
      color != old.color;
}
