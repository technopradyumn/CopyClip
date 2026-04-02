import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

enum MascotState {
  idle, happy, encouraging, sad, amazed, thinking, sleeping,
  angry, excited, confused, laughing, cool, love, shocked,
  proud, scared, tired, cheeky, dizzy
}

class MascotCharacter extends StatefulWidget {
  final MascotState state;
  final double size;
  final VoidCallback? onTap;
  final bool useThemeColor;
  final Color? color;

  const MascotCharacter({
    super.key,
    this.state = MascotState.idle,
    this.size = 150,
    this.onTap,
    this.useThemeColor = true,
    this.color,
  });

  @override
  State<MascotCharacter> createState() => _MascotCharacterState();
}

class _MascotCharacterState extends State<MascotCharacter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _interactionController;

  late Animation<double> _driftAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _orbitalTiltAnimation;
  late Animation<double> _interactionPulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _interactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _driftAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -15.0,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -15.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50,
      ),
    ]).animate(_controller);

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.08,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _interactionPulse = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.5,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
    ]).animate(_interactionController);

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _orbitalTiltAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: -0.2,
          end: 0.2,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.2,
          end: -0.2,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  void _handleTap() {
    if (widget.onTap != null) widget.onTap!();
    if (!_interactionController.isAnimating) {
      _interactionController.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(MascotCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      _updateAnimationSpeed();
    }
  }

  void _updateAnimationSpeed() {
    // Trigger burst animation on state change for snappy transitions
    if (!_interactionController.isAnimating) {
      _interactionController.forward(from: 0.0);
    }
    switch (widget.state) {
      case MascotState.happy:
      case MascotState.excited:
      case MascotState.laughing:
        _controller.duration = const Duration(milliseconds: 800);
        break;
      case MascotState.sleeping:
      case MascotState.tired:
        _controller.duration = const Duration(milliseconds: 4000);
        break;
      case MascotState.amazed:
      case MascotState.shocked:
      case MascotState.scared:
        _controller.duration = const Duration(milliseconds: 1000);
        break;
      case MascotState.encouraging:
      case MascotState.proud:
      case MascotState.love:
        _controller.duration = const Duration(milliseconds: 900);
        break;
      case MascotState.angry:
        _controller.duration = const Duration(milliseconds: 600);
        break;
      case MascotState.dizzy:
        _controller.duration = const Duration(milliseconds: 500);
        break;
      case MascotState.idle:
      case MascotState.thinking:
      case MascotState.sad:
      case MascotState.confused:
      case MascotState.cool:
      case MascotState.cheeky:
        _controller.duration = const Duration(milliseconds: 1500);
    }
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _interactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auraColor = widget.color ?? (widget.useThemeColor
        ? theme.colorScheme.primary
        : const Color(0xFF6366F1));

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _interactionController]),
        builder: (context, child) {
          final totalPulse = _pulseAnimation.value * _interactionPulse.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: Offset(0, _driftAnimation.value),
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _AuraEntityPainter(
                    state: widget.state,
                    pulse: totalPulse,
                    rotation: _rotationAnimation.value,
                    tilt: _orbitalTiltAnimation.value,
                    auraColor: auraColor,
                    interactionValue: _interactionController.value,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Transform.scale(
                scale: 1.0 - (_driftAnimation.value / -60),
                child: Container(
                  width: widget.size * 0.4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: auraColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: auraColor.withAlpha(15),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AuraEntityPainter extends CustomPainter {
  final MascotState state;
  final double pulse;
  final double rotation;
  final double tilt;
  final Color auraColor;
  final double interactionValue;

  _AuraEntityPainter({
    required this.state,
    required this.pulse,
    required this.rotation,
    required this.tilt,
    required this.auraColor,
    required this.interactionValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.28 * pulse;

    // Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          auraColor.withOpacity(0.35),
          auraColor.withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.5));

    canvas.drawCircle(center, size.width * 0.5, glowPaint);

    _drawOrbitalRing(canvas, center, size.width * 0.45);
    _drawHead(canvas, center, radius);
    _drawEyes(canvas, center, radius);
    _drawMouth(canvas, center, radius);
  }

  void _drawHead(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          auraColor.withOpacity(0.95),
          auraColor.withOpacity(0.75),
          auraColor.withOpacity(0.6),
        ],
        center: Alignment.topLeft,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);

    final highlight = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      center.translate(-radius * 0.3, -radius * 0.3),
      radius * 0.4,
      highlight,
    );
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    final width = size * 2.2;
    final height = size * 2.2;
    
    path.moveTo(center.dx, center.dy + height * 0.25);
    path.cubicTo(
        center.dx + width * 0.6, center.dy - height * 0.15, 
        center.dx + width * 0.4, center.dy - height * 0.6, 
        center.dx, center.dy - height * 0.2);
    path.cubicTo(
        center.dx - width * 0.4, center.dy - height * 0.6, 
        center.dx - width * 0.6, center.dy - height * 0.15, 
        center.dx, center.dy + height * 0.25);
    canvas.drawPath(path, paint);
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyeOffsetX = radius * 0.45;
    final eyeOffsetY = radius * -0.1;
    final eyeRadius = radius * 0.18;

    final white = Paint()..color = Colors.white;
    final pupil = Paint()..color = Colors.black;
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset left = center.translate(-eyeOffsetX, eyeOffsetY);
    Offset right = center.translate(eyeOffsetX, eyeOffsetY);

    if (state == MascotState.sleeping || state == MascotState.tired) {
      canvas.drawLine(left.translate(-8, 0), left.translate(8, 0), linePaint);
      canvas.drawLine(right.translate(-8, 0), right.translate(8, 0), linePaint);
      return;
    }

    if (state == MascotState.laughing) {
      canvas.drawLine(left.translate(-6, -6), left.translate(6, 0), linePaint);
      canvas.drawLine(left.translate(6, 0), left.translate(-6, 6), linePaint);
      canvas.drawLine(right.translate(6, -6), right.translate(-6, 0), linePaint);
      canvas.drawLine(right.translate(-6, 0), right.translate(6, 6), linePaint);
      return;
    }

    if (state == MascotState.encouraging || state == MascotState.proud) {
      canvas.drawArc(Rect.fromCircle(center: left.translate(0, 4), radius: 8), math.pi, math.pi, false, linePaint);
      canvas.drawArc(Rect.fromCircle(center: right.translate(0, 4), radius: 8), math.pi, math.pi, false, linePaint);
      return;
    }

    if (state == MascotState.cool) {
      final glassPaint = Paint()..color = Colors.black87..style = PaintingStyle.fill;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: left, width: eyeRadius*2.5, height: eyeRadius*1.5), const Radius.circular(4)), glassPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: right, width: eyeRadius*2.5, height: eyeRadius*1.5), const Radius.circular(4)), glassPaint);
      canvas.drawLine(left, right, Paint()..color=Colors.black87..strokeWidth=3);
      return;
    }

    if (state == MascotState.love) {
      _drawHeart(canvas, left, eyeRadius, Colors.white);
      _drawHeart(canvas, right, eyeRadius, Colors.white);
      return;
    }

    if (state == MascotState.dizzy) {
      canvas.drawCircle(left, eyeRadius * 0.8, linePaint);
      canvas.drawCircle(left, eyeRadius * 0.4, linePaint);
      canvas.drawCircle(right, eyeRadius * 0.8, linePaint);
      canvas.drawCircle(right, eyeRadius * 0.4, linePaint);
      return;
    }

    if (state == MascotState.cheeky) {
       canvas.drawCircle(left, eyeRadius, white);
       canvas.drawCircle(left, eyeRadius * 0.5, pupil);
       canvas.drawLine(right.translate(-8, 0), right.translate(8, 0), linePaint);
       return;
    }

    double leftRadius = eyeRadius;
    double rightRadius = eyeRadius;
    if (state == MascotState.amazed) {
      leftRadius *= 1.3;
      rightRadius *= 1.3;
    } else if (state == MascotState.confused) {
      leftRadius *= 1.2;
      rightRadius *= 0.8;
    }

    canvas.drawCircle(left, leftRadius, white);
    canvas.drawCircle(right, rightRadius, white);

    double shift = 0;
    if (state == MascotState.thinking) {
      shift = 4 * math.sin(rotation * 3);
    }

    double pupilFactor = 0.5;
    if (state == MascotState.shocked || state == MascotState.scared) pupilFactor = 0.2;
    if (state == MascotState.excited) pupilFactor = 0.7;

    canvas.drawCircle(left.translate(shift, 0), leftRadius * pupilFactor, pupil);
    canvas.drawCircle(right.translate(shift, 0), rightRadius * pupilFactor, pupil);

    if (state == MascotState.angry) {
       final browPaint = Paint()..color = Colors.white..strokeWidth=4..strokeCap=StrokeCap.round;
       canvas.drawLine(left.translate(-10, -15), left.translate(8, -5), browPaint);
       canvas.drawLine(right.translate(10, -15), right.translate(-8, -5), browPaint);
    } else if (state == MascotState.sad) {
       final browPaint = Paint()..color = Colors.white..strokeWidth=3..strokeCap=StrokeCap.round;
       canvas.drawLine(left.translate(-8, -5), left.translate(10, -12), browPaint);
       canvas.drawLine(right.translate(8, -5), right.translate(-10, -12), browPaint);
    }
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final mouthY = center.dy + radius * 0.35;

    switch (state) {
      case MascotState.happy:
      case MascotState.excited:
      case MascotState.love:
      case MascotState.proud:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY),
            width: radius * 1.2,
            height: radius * 0.8,
          ),
          0,
          math.pi,
          false,
          mouthPaint,
        );
        break;

      case MascotState.sad:
      case MascotState.tired:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY + 10),
            width: radius * 1.2,
            height: radius * 0.8,
          ),
          math.pi,
          math.pi,
          false,
          mouthPaint,
        );
        break;

      case MascotState.amazed:
      case MascotState.shocked:
        double r = state == MascotState.shocked ? radius * 0.15 : radius * 0.25;
        canvas.drawCircle(Offset(center.dx, mouthY), r, mouthPaint);
        break;

      case MascotState.angry:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY + 12),
            width: radius * 1.0,
            height: radius * 0.5,
          ),
          math.pi,
          math.pi,
          false,
          mouthPaint,
        );
        break;

      case MascotState.laughing:
        final fillPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY - 5),
            width: radius * 1.4,
            height: radius * 1.4,
          ),
          0,
          math.pi,
          true,
          fillPaint,
        );
        break;

      case MascotState.dizzy:
        final path = Path();
        path.moveTo(center.dx - 15, mouthY);
        path.quadraticBezierTo(center.dx - 7.5, mouthY - 10, center.dx, mouthY);
        path.quadraticBezierTo(center.dx + 7.5, mouthY + 10, center.dx + 15, mouthY);
        canvas.drawPath(path, mouthPaint);
        break;

      case MascotState.cheeky:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY),
            width: radius * 1.0,
            height: radius * 0.6,
          ),
          0,
          math.pi,
          false,
          mouthPaint,
        );
        final tonguePaint = Paint()..color = Colors.pinkAccent..style = PaintingStyle.fill;
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx + 5, mouthY + 8),
            width: radius * 0.4,
            height: radius * 0.6,
          ),
          0,
          math.pi,
          false,
          tonguePaint,
        );
        break;

      case MascotState.confused:
      case MascotState.cool:
      case MascotState.scared:
        canvas.drawLine(
          Offset(center.dx - 10, mouthY),
          Offset(center.dx + 10, mouthY - 3),
          mouthPaint,
        );
        break;

      case MascotState.encouraging:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY),
            width: radius * 1.0,
            height: radius * 0.5,
          ),
          0,
          math.pi,
          false,
          mouthPaint,
        );
        break;

      default:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY),
            width: radius * 0.8,
            height: radius * 0.3,
          ),
          0,
          math.pi,
          false,
          mouthPaint,
        );
    }
  }

  void _drawOrbitalRing(Canvas canvas, Offset center, double radius) {
    final ringPaint = Paint()
      ..color = auraColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radius * 0.4,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(tilt + rotation);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawArc(rect, 0, math.pi * 2, false, ringPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
