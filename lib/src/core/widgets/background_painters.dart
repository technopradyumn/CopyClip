import 'dart:math' as math;
import 'package:flutter/material.dart';

abstract class BaseBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;
  final bool isDark;

  BaseBackgroundPainter({
    required this.animationValue,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  bool shouldRepaint(covariant BaseBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.isDark != isDark;
  }

  double uiLerp(double a, double b, double t) => a + (b - a) * t;
}

/// 1. Classic Bubbles - Dynamic floating orbs with depth
class BubblesPainter extends BaseBackgroundPainter {
  BubblesPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);

    for (int i = 0; i < 8; i++) {
      // Varying depth and size
      final radius = random.nextDouble() * 120 + 60;
      final speed = random.nextDouble() * 0.15 + 0.05;
      final t = (animationValue * speed + random.nextDouble()) % 1.0;

      final x =
          size.width * (random.nextDouble() + math.sin(t * math.pi * 2) * 0.1);
      final y = size.height * (1.1 - t * 1.2); // Move upwards

      final opacity = math.sin(t * math.pi) * (isDark ? 0.25 : 0.15);
      paint.color = primaryColor.withValues(alpha: opacity.clamp(0, 1));
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }
}

/// 2. Floating Stars - Twinkling deep space with nebula glow
class StarsPainter extends BaseBackgroundPainter {
  StarsPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(1234);

    // Background Nebula Glow
    final nebulaPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100)
      ..color = primaryColor.withValues(alpha: isDark ? 0.15 : 0.08);
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.3),
      200,
      nebulaPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      250,
      nebulaPaint,
    );

    // Twinkling Stars
    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 2.5 + 0.5;

      final twinkle =
          math.sin(
                animationValue * math.pi * 3 * (random.nextDouble() + 0.2) + i,
              ) *
              0.5 +
          0.5;

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: twinkle * (isDark ? 0.7 : 0.4));
      canvas.drawCircle(Offset(x, y), starSize, paint);

      if (random.nextDouble() > 0.92) {
        final glowPaint = Paint()
          ..color = primaryColor.withValues(alpha: twinkle * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        canvas.drawCircle(Offset(x, y), starSize * 4, glowPaint);
      }
    }
  }
}

/// 3. Mesh Gradient - Fluid liquid colors morphing
class MeshPainter extends BaseBackgroundPainter {
  MeshPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final points = [
      Offset(
        size.width * 0.5 + math.sin(animationValue * 1.2) * size.width * 0.4,
        size.height * 0.5 + math.cos(animationValue * 0.8) * size.height * 0.3,
      ),
      Offset(
        size.width * 0.8 + math.cos(animationValue * 1.5) * size.width * 0.3,
        size.height * 0.2 + math.sin(animationValue * 1.1) * size.height * 0.2,
      ),
      Offset(
        size.width * 0.2 + math.sin(animationValue * 0.9) * size.width * 0.3,
        size.height * 0.8 + math.cos(animationValue * 1.4) * size.height * 0.3,
      ),
    ];

    final colors = [
      primaryColor.withValues(alpha: isDark ? 0.35 : 0.2),
      primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
      primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
    ];

    for (int i = 0; i < points.length; i++) {
      final rect = Rect.fromCircle(center: points[i], radius: size.width * 0.8);
      paint.shader = RadialGradient(
        colors: [colors[i], Colors.transparent],
        stops: const [0.2, 1.0],
      ).createShader(rect);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }
}

/// 4. Nebula Cloud - Deep space galactic nebulas with dust particles
class NebulaPainter extends BaseBackgroundPainter {
  NebulaPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    // Swirling nebula clouds
    for (int i = 0; i < 4; i++) {
      final t = (animationValue * 0.08 + i / 4) % 1.0;
      final x = size.width * (0.5 + math.sin(t * math.pi * 2 + i) * 0.3);
      final y = size.height * (0.5 + math.cos(t * math.pi * 2 + i) * 0.3);

      paint.color = primaryColor.withValues(alpha: isDark ? 0.25 : 0.12);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: size.width,
          height: size.height * 0.6,
        ),
        paint,
      );
    }

    // Cosmic Dust Particles
    final random = math.Random(999);
    final dustPaint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.15 : 0.05);
    for (int i = 0; i < 100; i++) {
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        0.8,
        dustPaint,
      );
    }
  }
}

/// 5. Particle Flow - Interactive-feel stream of flowing energy
class ParticlePainter extends BaseBackgroundPainter {
  ParticlePainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(555);
    final paint = Paint()
      ..color = primaryColor.withValues(alpha: isDark ? 0.4 : 0.25);
    final linePaint = Paint()
      ..color = primaryColor.withValues(alpha: isDark ? 0.15 : 0.08)
      ..strokeWidth = 1.0;

    final List<Offset> particles = [];
    for (int i = 0; i < 35; i++) {
      final t = (animationValue * 0.08 + random.nextDouble()) % 1.0;
      final x =
          (math.sin(t * math.pi * 2 + i) * 0.1 + random.nextDouble()) *
          size.width;
      final y = t * size.height;
      particles.add(Offset(x, y));
    }

    for (int i = 0; i < particles.length; i++) {
      canvas.drawCircle(particles[i], 2.0, paint);
      for (int j = i + 1; j < particles.length; j++) {
        final dist = (particles[i] - particles[j]).distance;
        if (dist < 120) {
          final opacity = (1.0 - dist / 120.0) * (isDark ? 0.2 : 0.1);
          linePaint.color = primaryColor.withValues(alpha: opacity);
          canvas.drawLine(particles[i], particles[j], linePaint);
        }
      }
    }
  }
}

/// 6. Geometric Float - Modern abstract 3D geometry with glassmorphism feel
class GeometricPainter extends BaseBackgroundPainter {
  GeometricPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(77);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = primaryColor.withValues(alpha: isDark ? 0.3 : 0.15);

    for (int i = 0; i < 12; i++) {
      final t = (animationValue * 0.06 + random.nextDouble()) % 1.0;
      final x = random.nextDouble() * size.width;
      final y = (1.1 - t) * size.height;
      final rotation = animationValue * math.pi * random.nextDouble() * 2;
      final length = random.nextDouble() * 50 + 20;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      if (i % 3 == 0) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: length, height: length),
          paint,
        );
      } else if (i % 3 == 1) {
        final path = Path();
        path.moveTo(0, -length / 2);
        path.lineTo(length / 2, length / 2);
        path.lineTo(-length / 2, length / 2);
        path.close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawCircle(Offset.zero, length / 2, paint);
      }

      canvas.restore();
    }
  }
}

/// 7. snowfall - Peace and calm winter atmosphere
class SnowPainter extends BaseBackgroundPainter {
  SnowPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(1);
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.4)
          : Colors.white.withValues(alpha: 0.6);

    for (int i = 0; i < 70; i++) {
      final speed = random.nextDouble() * 0.15 + 0.05;
      final t = (animationValue * speed + random.nextDouble()) % 1.0;
      final drift = math.sin(animationValue + i) * 30;
      final x = random.nextDouble() * (size.width + 60) - 30 + drift;
      final y = t * size.height;
      final r = random.nextDouble() * 3 + 1;

      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }
}

/// 8. Matrix Stylized - Falling cipher code (Digital Rain)
class MatrixPainter extends BaseBackgroundPainter {
  MatrixPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(7);
    final color = isDark
        ? primaryColor
        : primaryColor.withBlue(100).withGreen(100);

    final textStyle = TextStyle(
      color: color.withValues(alpha: isDark ? 0.6 : 0.4),
      fontSize: 13,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );

    const columns = 22;
    final colWidth = size.width / columns;

    for (int i = 0; i < columns; i++) {
      final speed = 0.3 + random.nextDouble() * 0.7;
      final offset = random.nextDouble() * size.height;
      final t = (animationValue * speed * 200 + offset) % size.height;

      // Draw string of characters
      for (int j = 0; j < 12; j++) {
        final charY = t - (j * 15);
        if (charY < -20 || charY > size.height + 20) continue;

        final opacity = (1.0 - (j / 12.0)).clamp(0.0, 1.0);
        final span = TextSpan(
          text: String.fromCharCode(
            random.nextInt(26) + 65 + random.nextInt(10),
          ),
          style: textStyle.copyWith(
            color: color.withValues(alpha: opacity * (isDark ? 0.6 : 0.4)),
            fontSize: j == 0 ? 15 : 13, // Leading char is bigger
          ),
        );
        final tp = TextPainter(text: span, textDirection: TextDirection.ltr)
          ..layout();
        tp.paint(canvas, Offset(i * colWidth, charY));
      }
    }
  }
}

/// 9. Wave Motion - Soothing ocean ebb and flow
class WavePainter extends BaseBackgroundPainter {
  WavePainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final path = Path();
      final offset = i * size.height * 0.08;
      final t = animationValue * 1.5 * math.pi + i * 0.5;

      paint.color = primaryColor.withValues(alpha: 
        isDark ? (0.1 + i * 0.05) : (0.05 + i * 0.03),
      );

      path.moveTo(0, size.height);
      path.lineTo(0, size.height * 0.6 + offset);

      for (double x = 0; x <= size.width; x += 15) {
        final y = size.height * 0.6 + offset + math.sin(x / 80 + t) * 25;
        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }
}

/// 10. Bokeh Blur - Dreamy out-of-focus light leaks
class BokehPainter extends BaseBackgroundPainter {
  BokehPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(88);
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    for (int i = 0; i < 18; i++) {
      final t = (animationValue * 0.04 + random.nextDouble()) % 1.0;
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final r = random.nextDouble() * 60 + 30;

      final opacity = math.sin(t * math.pi) * (isDark ? 0.3 : 0.15);
      paint.color = primaryColor.withValues(alpha: opacity.clamp(0, 1));
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }
}

/// 11. Aurora - Northern lights shimmering effect
class AuroraPainter extends BaseBackgroundPainter {
  AuroraPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    for (int i = 0; i < 5; i++) {
      final xBase = size.width * (0.1 + i * 0.2);
      final xDrift = math.sin(animationValue * 0.8 + i) * size.width * 0.15;
      final x = xBase + xDrift;

      final path = Path();
      path.moveTo(x - 80, -100);
      path.quadraticBezierTo(
        x + 120 + math.cos(animationValue + i) * 50,
        size.height / 2,
        x - 120,
        size.height + 100,
      );
      path.lineTo(x + 100, size.height + 100);
      path.quadraticBezierTo(
        x + 300 + math.sin(animationValue + i) * 60,
        size.height / 2,
        x + 100,
        -100,
      );
      path.close();

      final opacity =
          (0.1 + math.sin(animationValue * 0.5 + i).abs() * 0.2) *
          (isDark ? 1.0 : 0.6);
      paint.color = primaryColor.withValues(alpha: opacity.clamp(0, 1));
      canvas.drawPath(path, paint);
    }
  }
}

/// 12. Magical Spells - Sparkles and glowing paths (Harry Potter inspiration)
class MagicalPainter extends BaseBackgroundPainter {
  MagicalPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(13);

    // Flying Sparkles
    for (int i = 0; i < 40; i++) {
      final t = (animationValue * 0.15 + random.nextDouble()) % 1.0;
      final x =
          random.nextDouble() * size.width + math.sin(t * math.pi * 4) * 20;
      final y = (1.1 - t) * size.height;

      final opacity = math.sin(t * math.pi) * (isDark ? 0.8 : 0.5);
      final paint = Paint()
        ..color = primaryColor.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(x, y), random.nextDouble() * 2 + 1, paint);

      if (random.nextDouble() > 0.9) {
        // Cross flare
        final flarePaint = Paint()
          ..color = Colors.white.withValues(alpha: opacity * 0.5)
          ..strokeWidth = 0.5;
        canvas.drawLine(Offset(x - 4, y), Offset(x + 4, y), flarePaint);
        canvas.drawLine(Offset(x, y - 4), Offset(x, y + 4), flarePaint);
      }
    }

    // Wand Paths (curved light streaks)
    for (int i = 0; i < 3; i++) {
      final t = (animationValue * 0.1 + i / 3) % 1.0;
      final path = Path();
      final startX = size.width * (i / 3);
      path.moveTo(startX, size.height + 50);
      path.quadraticBezierTo(
        size.width / 2 + math.sin(t * math.pi) * 100,
        size.height / 2,
        size.width * (1 - i / 3),
        -50,
      );

      final streakPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = primaryColor.withValues(alpha: math.sin(t * math.pi) * 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawPath(path, streakPaint);
    }
  }
}

/// 13. Deep Forest - Silhouetted nature landscape with atmospheric fog
class ForestPainter extends BaseBackgroundPainter {
  ForestPainter({
    required super.animationValue,
    required super.primaryColor,
    required super.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Sky/Background Gradient
    final bgPaint = Paint();
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    bgPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor.withValues(alpha: isDark ? 0.05 : 0.02),
        primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
      ],
    ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // 2. Distant Trees (Silhouettes)
    final treePaint = Paint();
    for (int i = 0; i < 8; i++) {
      final x = (i * size.width / 7) + math.sin(animationValue * 0.2 + i) * 10;
      final h = 100.0 + (math.sin(i.toDouble()) * 40).abs();

      treePaint.color = primaryColor.withValues(alpha: isDark ? 0.15 : 0.08);
      _drawTree(canvas, Offset(x, size.height), h, treePaint);
    }

    // 3. Rolling Fog
    final fogPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    for (int i = 0; i < 3; i++) {
      final t = (animationValue * 0.05 + i / 3) % 1.0;
      final fogX = -size.width + (t * size.width * 2);
      fogPaint.color = primaryColor.withValues(alpha: isDark ? 0.1 : 0.05);
      canvas.drawOval(
        Rect.fromLTWH(fogX, size.height - 150, size.width, 200),
        fogPaint,
      );
    }
  }

  void _drawTree(Canvas canvas, Offset bottom, double height, Paint paint) {
    final path = Path();
    path.moveTo(bottom.dx, bottom.dy);
    path.lineTo(bottom.dx - 15, bottom.dy);
    path.lineTo(bottom.dx, bottom.dy - height);
    path.lineTo(bottom.dx + 15, bottom.dy);
    path.close();
    canvas.drawPath(path, paint);

    // Simple branches
    for (int i = 1; i < 4; i++) {
      final y = bottom.dy - (height * i / 4);
      final w = 20.0 * (4 - i);
      canvas.drawLine(
        Offset(bottom.dx - w, y),
        Offset(bottom.dx + w, y),
        paint,
      );
    }
  }
}
