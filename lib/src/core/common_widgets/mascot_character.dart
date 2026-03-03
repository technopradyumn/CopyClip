import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

enum MascotState { idle, happy, encouraging, sad, amazed, thinking, sleeping }

class MascotCharacter extends StatefulWidget {
  final MascotState state;
  final double size;
  final VoidCallback? onTap;
  final bool useThemeColor;

  const MascotCharacter({
    super.key,
    this.state = MascotState.idle,
    this.size = 150,
    this.onTap,
    this.useThemeColor = true,
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
      duration: const Duration(milliseconds: 3000),
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
    switch (widget.state) {
      case MascotState.happy:
        _controller.duration = const Duration(milliseconds: 1500);
        break;
      case MascotState.sleeping:
        _controller.duration = const Duration(milliseconds: 6000);
        break;
      case MascotState.amazed:
        _controller.duration = const Duration(milliseconds: 2000);
        break;
      default:
        _controller.duration = const Duration(milliseconds: 3000);
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
    final auraColor = widget.useThemeColor
        ? theme.colorScheme.primary
        : const Color(0xFF6366F1);

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

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyeOffsetX = radius * 0.45;
    final eyeOffsetY = radius * -0.1;
    final eyeRadius = radius * 0.18;

    final white = Paint()..color = Colors.white;
    final pupil = Paint()..color = Colors.black;

    Offset left = center.translate(-eyeOffsetX, eyeOffsetY);
    Offset right = center.translate(eyeOffsetX, eyeOffsetY);

    if (state == MascotState.sleeping) {
      final sleep = Paint()
        ..color = Colors.white
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(left.translate(-8, 0), left.translate(8, 0), sleep);
      canvas.drawLine(right.translate(-8, 0), right.translate(8, 0), sleep);
      return;
    }

    canvas.drawCircle(left, eyeRadius, white);
    canvas.drawCircle(right, eyeRadius, white);

    double shift = 0;
    if (state == MascotState.thinking) {
      shift = 4 * math.sin(rotation * 3);
    }

    canvas.drawCircle(left.translate(shift, 0), eyeRadius * 0.5, pupil);
    canvas.drawCircle(right.translate(shift, 0), eyeRadius * 0.5, pupil);
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
        canvas.drawCircle(Offset(center.dx, mouthY), radius * 0.25, mouthPaint);
        break;

      default:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY),
            width: radius,
            height: radius * 0.6,
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
