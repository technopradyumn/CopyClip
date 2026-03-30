import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/services/gamification_service.dart';

class MedalWidget extends StatelessWidget {
  final int level;
  final String? tier;
  final double size;
  final bool isStreakMedal;

  const MedalWidget({
    super.key,
    required this.level,
    this.tier,
    this.size = 60,
    this.isStreakMedal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isStreakMedal) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: StreakMedalPainter(streakDays: level),
        ),
      );
    }

    final effectiveTier = tier ?? GamificationService.getMedalTier(level);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: MedalPainter(level: level, tier: effectiveTier),
      ),
    );
  }
}

class MedalPainter extends CustomPainter {
  final int level;
  final String tier;

  MedalPainter({required this.level, required this.tier});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final baseColor = _getTierColor();
    final accentColor = _getTierAccentColor();

    // 1. Draw Outer Glow
    final shadowPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, radius * 0.9, shadowPaint);

    // 2. Draw Decorative Element based on level
    if (level > 20) {
      _drawAura(canvas, center, radius * 0.85, baseColor);
    }

    // 3. Draw Main Unique Shape
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [accentColor, baseColor, accentColor.withValues(alpha: 0.8)],
    );

    final medalPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius * 0.7))
      ..style = PaintingStyle.fill;

    _drawUniqueShape(canvas, center, radius * 0.7, medalPaint);

    // 4. Draw Inner Border
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _drawUniqueShape(canvas, center, radius * 0.6, borderPaint);

    // 5. Draw Level Number
    _drawLevelNumber(canvas, center, radius);
  }

  void _drawUniqueShape(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    switch (tier) {
      case 'Bronze': // Triangle/Shield
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx + radius, center.dy + radius * 0.5);
        path.lineTo(center.dx, center.dy + radius);
        path.lineTo(center.dx - radius, center.dy + radius * 0.5);
        path.close();
        break;
      case 'Silver': // Circle
        canvas.drawCircle(center, radius, paint);
        return;
      case 'Gold': // Hexagon
        _addPolygonPoints(path, center, radius, 6);
        break;
      case 'Platinum': // Octagon
        _addPolygonPoints(path, center, radius, 8);
        break;
      case 'Diamond': // Rhombus
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx + radius * 0.8, center.dy);
        path.lineTo(center.dx, center.dy + radius);
        path.lineTo(center.dx - radius * 0.8, center.dy);
        path.close();
        break;
      case 'Emerald': // Pentagram-ish / Flower
        _addPolygonPoints(path, center, radius, 5);
        break;
      case 'Ruby': // Diamond 
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx + radius, center.dy);
        path.lineTo(center.dx, center.dy + radius);
        path.lineTo(center.dx - radius, center.dy);
        path.close();
        break;
      case 'Sapphire': // Rounded Square
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCircle(center: center, radius: radius), Radius.circular(radius * 0.3)), paint);
        return;
      case 'Amethyst': // 12-point star
        _addStarPoints(path, center, radius, 12);
        break;
      case 'Legend': // Grand Sun
        _addStarPoints(path, center, radius, 24);
        break;
      default:
        canvas.drawCircle(center, radius, paint);
        return;
    }
    canvas.drawPath(path, paint);
  }

  void _addPolygonPoints(Path path, Offset center, double radius, int sides) {
    for (int i = 0; i < sides; i++) {
        double angle = (2 * math.pi / sides) * i - math.pi / 2;
        double x = center.dx + radius * math.cos(angle);
        double y = center.dy + radius * math.sin(angle);
        if (i == 0) path.moveTo(x, y);
        else path.lineTo(x, y);
    }
    path.close();
  }

  void _addStarPoints(Path path, Offset center, double radius, int points) {
    double angleStep = math.pi / points;
    for (int i = 0; i < 2 * points; i++) {
        double r = (i % 2 == 0) ? radius : radius * 0.6;
        double angle = i * angleStep - math.pi / 2;
        double x = center.dx + r * math.cos(angle);
        double y = center.dy + r * math.sin(angle);
        if (i == 0) path.moveTo(x, y);
        else path.lineTo(x, y);
    }
    path.close();
  }

  void _drawAura(Canvas canvas, Offset center, double radius, Color color) {
    final auraPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (int i = 0; i < 8; i++) {
        double angle = (2 * math.pi / 8) * i;
        canvas.drawCircle(Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle)), 3, auraPaint);
    }
  }

  void _drawLevelNumber(Canvas canvas, Offset center, double radius) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    textPainter.text = TextSpan(
      text: level.toString(),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: radius * 0.4,
        shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 4, offset: const Offset(1, 1))],
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  Color _getTierColor() {
    switch (tier) {
      case 'Bronze': return const Color(0xFFCD7F32);
      case 'Silver': return const Color(0xFFC0C0C0);
      case 'Gold': return const Color(0xFFFFD700);
      case 'Platinum': return const Color(0xFFE5E4E2);
      case 'Diamond': return const Color(0xFFB9F2FF);
      case 'Emerald': return const Color(0xFF50C878);
      case 'Ruby': return const Color(0xFFE0115F);
      case 'Sapphire': return const Color(0xFF0F52BA);
      case 'Amethyst': return const Color(0xFF9966CC);
      case 'Legend': return const Color(0xFFFF4500);
      default: return Colors.brown;
    }
  }

  Color _getTierAccentColor() {
    switch (tier) {
      case 'Bronze': return const Color(0xFF8B4513);
      case 'Silver': return const Color(0xFF707070);
      case 'Gold': return const Color(0xFFB8860B);
      case 'Platinum': return const Color(0xFF708090);
      case 'Diamond': return const Color(0xFF00BFFF);
      case 'Emerald': return const Color(0xFF006400);
      case 'Ruby': return const Color(0xFF8B0000);
      case 'Sapphire': return const Color(0xFF000080);
      case 'Amethyst': return const Color(0xFF4B0082);
      case 'Legend': return const Color(0xFFFFD700);
      default: return Colors.black;
    }
  }

  @override
  bool shouldRepaint(covariant MedalPainter oldDelegate) => oldDelegate.level != level || oldDelegate.tier != tier;
}

class StreakMedalPainter extends CustomPainter {
  final int streakDays;

  StreakMedalPainter({required this.streakDays});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    Color flameColor = Colors.orange;
    if (streakDays >= 100) flameColor = Colors.purple;
    else if (streakDays >= 30) flameColor = Colors.blue;
    else if (streakDays >= 14) flameColor = Colors.red;
    else if (streakDays >= 7) flameColor = Colors.amber;

    // 1. Glow
    final glowPaint = Paint()
      ..color = flameColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, radius * 0.8, glowPaint);

    // 2. Draw Flame Shape
    final path = Path();
    path.moveTo(center.dx, center.dy + radius * 0.6);
    path.quadraticBezierTo(center.dx + radius * 0.6, center.dy + radius * 0.6, center.dx + radius * 0.4, center.dy - radius * 0.1);
    path.quadraticBezierTo(center.dx + radius * 0.8, center.dy - radius * 0.4, center.dx, center.dy - radius * 0.9);
    path.quadraticBezierTo(center.dx - radius * 0.8, center.dy - radius * 0.4, center.dx - radius * 0.4, center.dy - radius * 0.1);
    path.quadraticBezierTo(center.dx - radius * 0.6, center.dy + radius * 0.6, center.dx, center.dy + radius * 0.6);
    path.close();

    final flamePaint = Paint()
      ..shader = LinearGradient(colors: [flameColor, flameColor.withValues(alpha: 0.6)], begin: Alignment.bottomCenter, end: Alignment.topCenter).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, flamePaint);

    // 3. Draw Milestone Text
    final textPainter = TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    textPainter.text = TextSpan(
      text: streakDays.toString(),
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: radius * 0.45),
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 0.5));
  }

  @override
  bool shouldRepaint(covariant StreakMedalPainter oldDelegate) => oldDelegate.streakDays != streakDays;
}
