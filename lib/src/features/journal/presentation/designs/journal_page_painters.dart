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
      ..color = Colors.black.withOpacity(0.2)
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
      ..color = Colors.blueAccent.withOpacity(0.2)
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
      ..color = Colors.black.withOpacity(0.15)
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
      ..color = Colors.black.withOpacity(0.25)
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
    // Background texture
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final paint = Paint()
      ..color = Colors.black.withOpacity(0.08)
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
          colors: [color.withOpacity(0.15), color.withOpacity(0.0)],
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
          Color(0xFF0F172A).withOpacity(0.2),
          Color(0xFF1E293B).withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final starPaint = Paint()..color = Colors.white.withOpacity(0.4);
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
    final moonPaint = Paint()..color = Colors.yellow[100]!.withOpacity(0.3);
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
          Colors.deepPurple.withOpacity(0.2),
          Colors.pink.withOpacity(0.2),
          Colors.blue.withOpacity(0.2),
          Colors.deepPurple.withOpacity(0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Core glow
    final glow = Paint()
      ..shader = RadialGradient(
        radius: 0.6,
        colors: [Colors.purpleAccent.withOpacity(0.2), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glow);

    // Stars
    final starPaint = Paint()..color = Colors.white.withOpacity(0.5);
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
          Colors.orange.withOpacity(0.3),
          Colors.deepOrange.withOpacity(0.2),
          Colors.purple.withOpacity(0.2),
          Colors.indigo.withOpacity(0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Sun
    final sunPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              Colors.yellow.withOpacity(0.4),
              Colors.orange.withOpacity(0.0),
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
      ..color = Colors.green.withOpacity(0.2);

    final backTree = Paint()..color = Colors.green[800]!.withOpacity(0.15);

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
        colors: [Colors.cyan.withOpacity(0.1), Colors.blue.withOpacity(0.2)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), water);

    // Sand Curve
    final sand = Paint()..color = Colors.amber[200]!.withOpacity(0.3);
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
      ..color = Colors.white.withOpacity(0.3)
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
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1;
    final boxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black.withOpacity(0.3)
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
      ..color = Colors.white.withOpacity(0.3)
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
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Ruling
    for (double y = 60; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Cue Column (Left)
    final cuePaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
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
      ..color = Colors.black.withOpacity(0.15)
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
        ..color = Colors.black.withOpacity(0.1)
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
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1.0;
    final dashed = Paint()
      ..color = Colors.blue.withOpacity(0.2)
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
      ..color = Colors.green.withOpacity(0.1)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minor);
    }
    for (double y = 0; y < size.height; y += 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minor);
    }

    // Major Grid
    final major = Paint()
      ..color = Colors.green.withOpacity(0.25)
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
    final gutterPaint = Paint()..color = Colors.black.withOpacity(0.05);
    canvas.drawRect(Rect.fromLTWH(0, 0, 40, size.height), gutterPaint);

    // Separator
    final linePaint = Paint()..color = Colors.grey.withOpacity(0.2);
    canvas.drawLine(Offset(40, 0), Offset(40, size.height), linePaint);

    // Line Hints
    final contentPaint = Paint()
      ..color = Colors.grey.withOpacity(0.05)
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
      ..color = Colors.black.withOpacity(0.1)
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
      Colors.red.withOpacity(0.15),
      Colors.blue.withOpacity(0.15),
      Colors.green.withOpacity(0.15),
      Colors.yellow.withOpacity(0.15),
      Colors.purple.withOpacity(0.15),
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
      ..color = Colors.green.withOpacity(0.1)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final detail = Paint()
      ..color = Colors.green.withOpacity(0.2)
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
      ..color = Colors.black.withOpacity(0.2)
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
      ..color = Colors.blueGrey.withOpacity(0.2)
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
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1.0;

    // Groups of 5 lines, spaced, then another group
    double y = 80;
    while (y < size.height - 100) {
      // Treble
      for (int i = 0; i < 5; i++)
        canvas.drawLine(
          Offset(0, y + i * 8),
          Offset(size.width, y + i * 8),
          paint,
        );
      // Bass
      double bassY = y + 80;
      for (int i = 0; i < 5; i++)
        canvas.drawLine(
          Offset(0, bassY + i * 8),
          Offset(size.width, bassY + i * 8),
          paint,
        );

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
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1.0;
    for (double y = 40; y < size.height; y += 40) {
      for (double x = 0; x < size.width; x += 6) {
        canvas.drawCircle(Offset(x, y), 0.5, paint);
      }
    }
    final margin = Paint()
      ..color = Colors.red.withOpacity(0.1)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(40, 0), Offset(40, size.height), margin);
  }
}
