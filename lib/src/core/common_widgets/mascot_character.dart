import 'dart:math' as math;
import 'package:flutter/material.dart';

enum MascotState { idle, happy, encouraging, sad }

class MascotCharacter extends StatefulWidget {
  final MascotState state;
  final double size;

  const MascotCharacter({
    super.key,
    this.state = MascotState.idle,
    this.size = 150,
  });

  @override
  State<MascotCharacter> createState() => _MascotCharacterState();
}

class _MascotCharacterState extends State<MascotCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<double> _wingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _blinkAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 90),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.1), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: 1.0), weight: 5),
    ]).animate(_controller);

    _wingAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(MascotCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      if (widget.state == MascotState.happy) {
        _controller.duration = const Duration(milliseconds: 800);
      } else {
        _controller.duration = const Duration(milliseconds: 2000);
      }
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _MascotPainter(
            state: widget.state,
            bounce: _bounceAnimation.value,
            blink: _blinkAnimation.value,
            wingFlap: _wingAnimation.value,
          ),
        );
      },
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotState state;
  final double bounce;
  final double blink;
  final double wingFlap;

  _MascotPainter({
    required this.state,
    required this.bounce,
    required this.blink,
    required this.wingFlap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bodyColor = const Color(0xFF4DB6AC);
    final accentColor = const Color(0xFF80CBC4);
    final eyeColor = Colors.white;
    final pupilColor = Colors.black;
    final beakColor = Colors.orange;

    final bodyPaint = Paint()..color = bodyColor;
    final accentPaint = Paint()..color = accentColor;
    final eyePaint = Paint()..color = eyeColor;
    final pupilPaint = Paint()..color = pupilColor;
    final beakPaint = Paint()..color = beakColor;

    // Apply bounce
    double verticalOffset = bounce;
    if (state == MascotState.sad) verticalOffset = 5;

    // Draw Body
    final bodyRect = Rect.fromCenter(
      center: center.translate(0, verticalOffset),
      width: size.width * 0.7,
      height: size.height * 0.75,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(size.width * 0.3)),
      bodyPaint,
    );

    // Draw Belly/Accent
    final bellyRect = Rect.fromCenter(
      center: center.translate(0, verticalOffset + size.height * 0.1),
      width: size.width * 0.5,
      height: size.height * 0.4,
    );
    canvas.drawOval(bellyRect, accentPaint);

    // Draw Wings
    final wingWidth = size.width * 0.15;
    final wingHeight = size.height * 0.25;
    final flapAngle = state == MascotState.happy ? wingFlap * math.pi / 2 : 0.0;

    // Left Wing
    canvas.save();
    canvas.translate(center.dx - size.width * 0.35, center.dy + verticalOffset);
    canvas.rotate(-flapAngle);
    canvas.drawOval(
      Rect.fromLTWH(-wingWidth, -wingHeight / 2, wingWidth, wingHeight),
      bodyPaint,
    );
    canvas.restore();

    // Right Wing
    canvas.save();
    canvas.translate(center.dx + size.width * 0.35, center.dy + verticalOffset);
    canvas.rotate(flapAngle);
    canvas.drawOval(
      Rect.fromLTWH(0, -wingHeight / 2, wingWidth, wingHeight),
      bodyPaint,
    );
    canvas.restore();

    // Draw Eyes
    final eyeSpacing = size.width * 0.18;
    final eyeSize = size.width * 0.12;
    final eyeY = center.dy + verticalOffset - size.height * 0.1;

    void drawEye(Offset eyeCenter) {
      if (state == MascotState.sad) {
        // Draw droopy eyes
        final droopPaint = Paint()
          ..color = pupilColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawArc(
          Rect.fromCenter(center: eyeCenter, width: eyeSize, height: eyeSize),
          0,
          math.pi,
          false,
          droopPaint,
        );
      } else {
        // Draw normal eyes with blink
        final currentEyeHeight =
            eyeSize * (state == MascotState.happy ? 1.2 : blink);
        canvas.drawOval(
          Rect.fromCenter(
            center: eyeCenter,
            width: eyeSize,
            height: currentEyeHeight,
          ),
          eyePaint,
        );
        if (currentEyeHeight > eyeSize * 0.3) {
          canvas.drawCircle(eyeCenter, eyeSize * 0.3, pupilPaint);
        }
      }
    }

    drawEye(Offset(center.dx - eyeSpacing, eyeY));
    drawEye(Offset(center.dx + eyeSpacing, eyeY));

    // Draw Beak
    final beakPath = Path()
      ..moveTo(center.dx - 8, eyeY + 15)
      ..lineTo(center.dx + 8, eyeY + 15)
      ..lineTo(center.dx, eyeY + 25)
      ..close();
    canvas.drawPath(beakPath, beakPaint);
  }

  @override
  bool shouldRepaint(_MascotPainter oldDelegate) => true;
}
