import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/bloc/theme_bloc.dart';
import '../theme/background_design.dart';
import 'background_painters.dart';

class DynamicBackground extends StatefulWidget {
  final Widget child;

  const DynamicBackground({super.key, required this.child});

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // ✅ High Precision Ticker for smooth 144FPS scrolling/animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        final primaryColor = state.primaryColor;
        final design = state.backgroundDesign;

        if (design == BackgroundDesign.none) return widget.child;

        return Stack(
          children: [
            // Background Animation Layer
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _getPainter(
                        design,
                        _controller.value,
                        primaryColor,
                        isDark,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Content Mask (Optional if you want to fade background more)
            // Positioned.fill(
            //   child: Container(
            //     color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.1),
            //   ),
            // ),

            // Main Content
            Positioned.fill(child: widget.child),
          ],
        );
      },
    );
  }

  CustomPainter _getPainter(
    BackgroundDesign design,
    double value,
    Color color,
    bool isDark,
  ) {
    switch (design) {
      case BackgroundDesign.classicBubbles:
        return BubblesPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.floatingStars:
        return StarsPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.meshGradient:
        return MeshPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.nebulaCloud:
        return NebulaPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.particleFlow:
        return ParticlePainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.geometricFloat:
        return GeometricPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.snowfall:
        return SnowPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.matrixRain:
        return MatrixPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.waveMotion:
        return WavePainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.bokehBlur:
        return BokehPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.aurora:
        return AuroraPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.magicalSpells:
        return MagicalPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.deepForest:
        return ForestPainter(
          animationValue: value,
          primaryColor: color,
          isDark: isDark,
        );
      case BackgroundDesign.none:
        return BubblesPainter(
          animationValue: value,
          primaryColor:
              Colors.transparent, // Solid background handled by scaffold
          isDark: isDark,
        );
    }
  }
}
