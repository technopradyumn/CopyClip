import 'package:flutter/material.dart';

abstract class EventCardPainter extends CustomPainter {
  @override
  bool shouldRepaint(EventCardPainter oldDelegate) => false;
}

/// Helper extension for Size
extension SizeRect on Size {
  Rect rect() => Rect.fromLTWH(0, 0, width, height);
}

/// Minimal solid backgrounds
class SolidPainter extends EventCardPainter {
  final Color color;
  SolidPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.15);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)),
      paint,
    );
  }
}

/// Glass/Wave effect
class WaveGlassPainter extends EventCardPainter {
  final Color baseColor;
  WaveGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [baseColor.withOpacity(0.1), Colors.transparent],
        stops: const [0.0, 1.0],
      ).createShader(size.rect())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)),
      paint,
    );
  }
}

class DiamondGlassPainter extends EventCardPainter {
  final Color baseColor;
  DiamondGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = baseColor.withOpacity(0.2);
    // Simple diamond pattern
    final center = size.center(Offset.zero);
    final path = Path()
      ..moveTo(center.dx, center.dy - 20)
      ..lineTo(center.dx + 20, center.dy)
      ..lineTo(center.dx, center.dy + 20)
      ..lineTo(center.dx - 20, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }
}

class RippleGlassPainter extends EventCardPainter {
  final Color baseColor;
  RippleGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = baseColor.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final center = size.center(Offset.zero);
    for (double r = 10; r < size.width / 2; r += 15) {
      canvas.drawCircle(center, r, paint);
    }
  }
}

class HexGlassPainter extends EventCardPainter {
  final Color baseColor;
  HexGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = baseColor.withOpacity(0.15);
    // Simple hex pattern
    final rect = size.rect();
    for (double y = 0; y < size.height; y += 30) {
      for (double x = (y / 30 % 2) * 15; x < size.width; x += 30) {
        final path = Path()
          ..moveTo(x, y + 5)
          ..lineTo(x + 15, y)
          ..lineTo(x + 20, y + 10)
          ..lineTo(x + 15, y + 20)
          ..lineTo(x, y + 15)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }
}

class ShineGlassPainter extends EventCardPainter {
  final Color baseColor;
  ShineGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    // Shine highlight
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.4), Colors.transparent],
      ).createShader(Rect.fromLTWH(size.width * 0.7, 0, size.width * 0.3, size.height));
    canvas.drawRect(Rect.fromLTWH(size.width * 0.7, 0, size.width * 0.3, size.height), highlightPaint);
    
    // Base glass
    final glassPaint = Paint()..color = baseColor.withOpacity(0.2);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), glassPaint);
  }
}

class BlurGlassPainter extends EventCardPainter {
  final Color baseColor;
  BlurGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = baseColor.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), paint);
  }
}

// Gradient Painters
class LinearGradientPainter extends EventCardPainter {
  final List<Color> colors;
  LinearGradientPainter(this.colors);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(colors: colors).createShader(size.rect());
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), paint);
  }
}

class RadialGradientPainter extends EventCardPainter {
  final List<Color> colors;
  RadialGradientPainter(this.colors);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(colors: colors, radius: 0.8).createShader(size.rect());
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }
}

class SweepGradientPainter extends EventCardPainter {
  final Color color1, color2;
  SweepGradientPainter(this.color1, this.color2);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [color1, color2],
      ).createShader(size.rect());
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }
}

// Neumorphic
class NeumorphicPainter extends EventCardPainter {
  final Color color;
  final bool light;
  NeumorphicPainter(this.color, {this.light = true});
  @override
  void paint(Canvas canvas, Size size) {
    final lightShadow = Paint()
      ..color = (light ? Colors.white : Colors.black).withOpacity(0.5);
    final darkShadow = Paint()
      ..color = (light ? Colors.black : Colors.white).withOpacity(0.5);
    final bgPaint = Paint()..color = color;

    // Outer light shadow
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().deflate(2), const Radius.circular(16)), lightShadow);
    // Outer dark shadow
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().inflate(2), const Radius.circular(16)), darkShadow);
    // Background
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), bgPaint);
  }
}

class FoldGlassPainter extends EventCardPainter {
  final Color baseColor;
  FoldGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = baseColor.withOpacity(0.2);
    final paint2 = Paint()..color = baseColor.withOpacity(0.1);
    
    // Main card
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), paint1);
    
    // Fold shadow
    final foldRect = Rect.fromLTWH(0, size.height * 0.3, size.width, size.height * 0.1);
    canvas.drawRect(foldRect, paint2);
  }
}

class OrbitGlassPainter extends EventCardPainter {
  final Color baseColor;
  OrbitGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = baseColor.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final center = size.center(Offset.zero);
    canvas.drawCircle(center, size.width * 0.4, paint);
    canvas.drawCircle(center, size.width * 0.2, paint);
  }
}

class PulseGlassPainter extends EventCardPainter {
  final Color baseColor;
  PulseGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    for (int i = 1; i <= 3; i++) {
      final paint = Paint()
        ..color = baseColor.withOpacity(0.3 / i)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, size.width * 0.4 * i / 3, paint);
    }
  }
}

class SparkleGlassPainter extends EventCardPainter {
  final Color baseColor;
  SparkleGlassPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = baseColor.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    // Sparkle stars
    final sparkles = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.8),
    ];
    for (var pos in sparkles) {
      canvas.drawCircle(pos, 4, paint);
    }
  }
}

class EmbossPainter extends EventCardPainter {
  final Color baseColor;
  EmbossPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final light = Paint()..color = baseColor.withOpacity(0.6);
    final dark = Paint()..color = baseColor.withOpacity(0.2);
    final bg = Paint()..color = baseColor.withOpacity(0.1);
    
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().inflate(2), const Radius.circular(16)), light);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().deflate(2), const Radius.circular(16)), dark);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), bg);
  }
}

class PressedNeumorphicPainter extends EventCardPainter {
  final Color baseColor;
  PressedNeumorphicPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final dark = Paint()..color = baseColor.withOpacity(0.6);
    final light = Paint()..color = baseColor.withOpacity(0.2);
    final bg = Paint()..color = baseColor.withOpacity(0.1);
    
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().deflate(2), const Radius.circular(16)), dark);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().inflate(2), const Radius.circular(16)), light);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), bg);
  }
}

class DeepShadowPainter extends EventCardPainter {
  final Color baseColor;
  DeepShadowPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final shadow = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    final bg = Paint()..color = baseColor.withOpacity(0.15);
    
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().inflate(8), const Radius.circular(16)), shadow);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), bg);
  }
}

class ConcavePainter extends EventCardPainter {
  final Color baseColor;
  ConcavePainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final innerShadow = Paint()..color = Colors.black.withOpacity(0.4);
    final bg = Paint()..color = baseColor.withOpacity(0.2);
    
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().deflate(4), const Radius.circular(16)), innerShadow);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), bg);
  }
}

class RidgePainter extends EventCardPainter {
  final Color baseColor;
  RidgePainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final ridgeLight = Paint()..color = Colors.white.withOpacity(0.5);
    final ridgeDark = Paint()..color = Colors.black.withOpacity(0.3);
    final bg = Paint()..color = baseColor.withOpacity(0.15);
    
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().deflate(1), const Radius.circular(16)), ridgeLight);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().inflate(1), const Radius.circular(16)), ridgeDark);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), bg);
  }
}

class GlowNeumorphicPainter extends EventCardPainter {
  final Color baseColor;
  GlowNeumorphicPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = baseColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    final bg = Paint()..color = baseColor.withOpacity(0.2);
    
    canvas.drawCircle(size.center(Offset.zero), size.width / 2 + 10, glow);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), bg);
  }
}

class MatteNeumorphicPainter extends EventCardPainter {
  final Color baseColor;
  MatteNeumorphicPainter(this.baseColor);
  @override
  void paint(Canvas canvas, Size size) {
    final subtleShadow = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final bg = Paint()..color = baseColor.withOpacity(0.12);
    
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect().inflate(2), const Radius.circular(16)), subtleShadow);
    canvas.drawRRect(RRect.fromRectAndRadius(size.rect(), const Radius.circular(16)), bg);
  }
}

