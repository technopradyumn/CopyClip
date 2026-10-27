import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/theme/background_design.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/core/widgets/background_painters.dart';

class BackgroundPickerScreen extends StatefulWidget {
  const BackgroundPickerScreen({super.key});

  @override
  State<BackgroundPickerScreen> createState() => _BackgroundPickerScreenState();
}

class _BackgroundPickerScreenState extends State<BackgroundPickerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late BackgroundDesign _selectedDesign;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final currentDesign = context.read<ThemeBloc>().state.backgroundDesign;
    _selectedDesign = currentDesign;
    _currentIndex = BackgroundDesign.values.indexOf(currentDesign);
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.85,
    );
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  String _getDesignName(BackgroundDesign design) {
    switch (design) {
      case BackgroundDesign.classicBubbles:
        return "Bubbles";
      case BackgroundDesign.floatingStars:
        return "Stars";
      case BackgroundDesign.meshGradient:
        return "Mesh";
      case BackgroundDesign.nebulaCloud:
        return "Nebula";
      case BackgroundDesign.particleFlow:
        return "Particles";
      case BackgroundDesign.geometricFloat:
        return "Geometry";
      case BackgroundDesign.snowfall:
        return "Snow";
      case BackgroundDesign.matrixRain:
        return "Matrix";
      case BackgroundDesign.waveMotion:
        return "Waves";
      case BackgroundDesign.bokehBlur:
        return "Bokeh";
      case BackgroundDesign.aurora:
        return "Aurora";
      case BackgroundDesign.magicalSpells:
        return "Magic";
      case BackgroundDesign.deepForest:
        return "Forest";
      case BackgroundDesign.none:
        return "None";
    }
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
          primaryColor: Colors.transparent,
          isDark: isDark,
        );
    }
  }

  static String _getDesignDescription(BackgroundDesign design) {
    switch (design) {
      case BackgroundDesign.classicBubbles:
        return "Soft floating orbs for a calm mood";
      case BackgroundDesign.floatingStars:
        return "Magical night sky with twinkling stars";
      case BackgroundDesign.meshGradient:
        return "Fluid liquid colors morphing together";
      case BackgroundDesign.nebulaCloud:
        return "Deep space galactic nebulas";
      case BackgroundDesign.particleFlow:
        return "Interactive stream of flowing energy";
      case BackgroundDesign.geometricFloat:
        return "Modern abstract 3D geometry";
      case BackgroundDesign.snowfall:
        return "Peaceful winter atmosphere";
      case BackgroundDesign.matrixRain:
        return "Cipher falling like code";
      case BackgroundDesign.waveMotion:
        return "Soothing ocean ebb and flow";
      case BackgroundDesign.bokehBlur:
        return "Dreamy out-of-focus light leaks";
      case BackgroundDesign.aurora:
        return "Northern lights shimmering effect";
      case BackgroundDesign.magicalSpells:
        return "Flying sparkles and mysterious light streaks";
      case BackgroundDesign.deepForest:
        return "Silhouetted nature with atmospheric fog";
      case BackgroundDesign.none:
        return "Minimalist solid background";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 0. Base Solid Background
          Positioned.fill(
            child: Container(color: theme.scaffoldBackgroundColor),
          ),

          // 1. Full Screen Preview Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _selectedDesign == BackgroundDesign.none
                      ? null
                      : _getPainter(
                          _selectedDesign,
                          _animController.value,
                          primaryColor,
                          isDark,
                        ),
                );
              },
            ),
          ),

          // 2. Translucent Overlay
          Positioned.fill(
            child: Container(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.2),
            ),
          ),

          // 3. Main UI Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(
                              alpha: 0.8,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.1),
                            ),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, size: 20),
                        ),
                      ),
                      Text(
                        "Wallpaper Settings",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // 4. PageView Mockups
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: BackgroundDesign.values.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                        _selectedDesign = BackgroundDesign.values[index];
                      });
                      HapticFeedback.selectionClick();
                    },
                    itemBuilder: (context, index) {
                      final design = BackgroundDesign.values[index];
                      final isCurrent = index == _currentIndex;

                      return AnimatedScale(
                        scale: isCurrent ? 1.0 : 0.85,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: isCurrent
                                  ? primaryColor
                                  : theme.dividerColor.withValues(alpha: 0.2),
                              width: isCurrent ? 3 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Stack(
                              children: [
                                // Background In Mockup
                                Positioned.fill(
                                  child: AnimatedBuilder(
                                    animation: _animController,
                                    builder: (context, _) {
                                      return CustomPaint(
                                        painter: design == BackgroundDesign.none
                                            ? null
                                            : _getPainter(
                                                design,
                                                _animController.value,
                                                primaryColor,
                                                isDark,
                                              ),
                                      );
                                    },
                                  ),
                                ),
                                // Overlay Content (Mockup UI)
                                Positioned.fill(
                                  child: Container(
                                    color: theme.scaffoldBackgroundColor
                                        .withValues(alpha: 0.3),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 40),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.lock_outline,
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.4),
                                            size: 40,
                                          ),
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: List.generate(
                                              4,
                                              (i) => Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(flex: 1),

                // 5. Bottom UI
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getDesignName(_selectedDesign),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getDesignDescription(_selectedDesign),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ThemeBloc>().add(
                              ChangeBackgroundDesign(_selectedDesign),
                            );
                            HapticFeedback.mediumImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Wallpaper Applied Successfully!",
                                ),
                              ),
                            );
                            context.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: primaryColor.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Set as Wallpaper",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
