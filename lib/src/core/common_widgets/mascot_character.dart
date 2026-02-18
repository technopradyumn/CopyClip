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
              // Dynamic Shadow
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
    final coreRadius = size.width * 0.25 * pulse;

    // Draw Aura Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [auraColor.withAlpha(60), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.5));
    canvas.drawCircle(center, size.width * 0.5, glowPaint);

    // Draw Orbital Ring
    _drawOrbitalRing(canvas, center, size.width * 0.45);

    // Draw the Faceted Core
    _drawFacetedCore(canvas, center, coreRadius);

    // Draw Digital Pulse Eyes
    _drawDigitalEyes(canvas, center, coreRadius);
  }

  void _drawFacetedCore(Canvas canvas, Offset center, double radius) {
    final path = Path();
    final points = 6;
    final angleStep = (2 * math.pi) / points;

    // Base shape (Hexagonal Gem)
    for (int i = 0; i < points; i++) {
      final angle = i * angleStep + interactionValue * math.pi;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    path.close();

    final corePaint = Paint()
      ..shader = LinearGradient(
        colors: [auraColor, auraColor.withAlpha(150), auraColor.withValue(0.9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(path, corePaint);

    // Facet lines for high-end look
    final linePaint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep + interactionValue * math.pi;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
        linePaint,
      );
    }
  }

  void _drawOrbitalRing(Canvas canvas, Offset center, double radius) {
    final ringPaint = Paint()
      ..color = auraColor.withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radius * 0.4,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(
      tilt + (state == MascotState.happy ? rotation * 2 : rotation),
    );
    canvas.translate(-center.dx, -center.dy);

    // Draw segmented ring for "tech" feel
    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        rect,
        i * math.pi / 2 + rotation,
        math.pi / 4,
        false,
        ringPaint,
      );
    }

    // Orbital Part (small dot on ring)
    final orbitalPos = Offset(
      center.dx + radius * math.cos(rotation * 3),
      center.dy + radius * 0.2 * math.sin(rotation * 3),
    );
    canvas.drawCircle(
      orbitalPos,
      4,
      Paint()
        ..color = Colors.white
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    canvas.restore();
  }

  void _drawDigitalEyes(Canvas canvas, Offset center, double radius) {
    if (state == MascotState.sleeping) {
      final sleepingPaint = Paint()
        ..color = Colors.white.withAlpha(100)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        center.translate(-10, -5),
        center.translate(-2, -5),
        sleepingPaint,
      );
      canvas.drawLine(
        center.translate(2, -5),
        center.translate(10, -5),
        sleepingPaint,
      );
      return;
    }

    final eyePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double eyeWidth = 12.0;
    if (state == MascotState.amazed) eyeWidth = 18.0;
    if (state == MascotState.sad) eyeWidth = 6.0;

    // Horizontal digital slits
    canvas.drawLine(
      center.translate(-eyeWidth, -5),
      center.translate(-2, -5),
      eyePaint,
    );
    canvas.drawLine(
      center.translate(2, -5),
      center.translate(eyeWidth, -5),
      eyePaint,
    );

    if (state == MascotState.thinking) {
      // Subtle scanning effect
      final scanLine = Paint()
        ..color = Colors.cyanAccent.withAlpha(150)
        ..strokeWidth = 1;
      final y = -5 + 4 * math.sin(rotation * 5);
      canvas.drawLine(
        center.translate(-eyeWidth, y),
        center.translate(eyeWidth, y),
        scanLine,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

extension ColorExt on Color {
  Color withValue(double value) {
    final hsv = HSVColor.fromColor(this);
    return hsv.withValue(value.clamp(0.0, 1.0)).toColor();
  }
}
