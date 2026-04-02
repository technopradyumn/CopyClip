import 'package:flutter/material.dart';
import 'event_design_painters.dart';
import '../../../../core/utils/collection_utils.dart';

/// Registry for 40+ practical event card design patterns.
/// Organized by themes: Minimal, Glass, Gradient, Neumorphic.
/// Each pattern defines painter, colors, layout variant for variety (title left/right, badges top/bottom, etc.).

class EventDesignPattern {
  final String id;
  final String name;
  final EventCardPainter painter;
  final Color primaryColor;
  final Color secondaryColor;
  final EventLayoutVariant layout;
  final PriorityStyle priorityStyle;
  final bool hasTimeBadge;
  final bool hasLocationBadge;

  EventDesignPattern({
    required this.id,
    required this.name,
    required this.painter,
    required this.primaryColor,
    required this.secondaryColor,
    this.layout = EventLayoutVariant.standard,
    this.priorityStyle = PriorityStyle.bar,
    this.hasTimeBadge = true,
    this.hasLocationBadge = true,
  });
}

/// Layout variants for card diversity.
enum EventLayoutVariant {
  standard, // Title top, desc below, badges bottom
  compact, // Single line title+time, desc hidden
  expanded, // Large time/location, small title
  badgeFirst, // Badges top row
  timeline, // Vertical timeline style
}

/// Priority indicator styles.
enum PriorityStyle {
  dot, // Colored dot left
  bar, // Progress bar
  icon, // Priority icon (high/med/low)
  none,
}

class EventDesignRegistry {
  static final List<EventDesignPattern> _patterns = [
    // Minimal Theme (10 patterns - clean, practical for daily view)
    EventDesignPattern(
      id: 'min_1',
      name: 'Minimal Blue',
      painter: SolidPainter(Colors.blue.shade400),
      primaryColor: Colors.blue.shade400,
      secondaryColor: Colors.blue.shade100,
      layout: EventLayoutVariant.standard,
    ),
    EventDesignPattern(
      id: 'min_2',
      name: 'Minimal Green',
      painter: SolidPainter(Colors.green.shade400),
      primaryColor: Colors.green.shade400,
      secondaryColor: Colors.green.shade100,
      layout: EventLayoutVariant.compact,
    ),
    EventDesignPattern(
      id: 'min_3',
      name: 'Minimal Orange',
      painter: SolidPainter(Colors.orange.shade400),
      primaryColor: Colors.orange.shade400,
      secondaryColor: Colors.orange.shade100,
      priorityStyle: PriorityStyle.bar,
    ),
    EventDesignPattern(
      id: 'min_4',
      name: 'Minimal Purple',
      painter: SolidPainter(Colors.purple.shade400),
      primaryColor: Colors.purple.shade400,
      secondaryColor: Colors.purple.shade100,
      layout: EventLayoutVariant.badgeFirst,
    ),
    EventDesignPattern(
      id: 'min_5',
      name: 'Minimal Red',
      painter: SolidPainter(Colors.red.shade400),
      primaryColor: Colors.red.shade400,
      secondaryColor: Colors.red.shade100,
      hasLocationBadge: false,
    ),
    EventDesignPattern(
      id: 'min_6',
      name: 'Minimal Teal',
      painter: SolidPainter(Colors.teal.shade400),
      primaryColor: Colors.teal.shade400,
      secondaryColor: Colors.teal.shade100,
      layout: EventLayoutVariant.timeline,
    ),
    EventDesignPattern(
      id: 'min_7',
      name: 'Minimal Indigo',
      painter: SolidPainter(Colors.indigo.shade400),
      primaryColor: Colors.indigo.shade400,
      secondaryColor: Colors.indigo.shade100,
      priorityStyle: PriorityStyle.icon,
    ),
    EventDesignPattern(
      id: 'min_8',
      name: 'Minimal Pink',
      painter: SolidPainter(Colors.pink.shade400),
      primaryColor: Colors.pink.shade400,
      secondaryColor: Colors.pink.shade100,
    ),
    EventDesignPattern(
      id: 'min_9',
      name: 'Minimal Cyan',
      painter: SolidPainter(Colors.cyan.shade400),
      primaryColor: Colors.cyan.shade400,
      secondaryColor: Colors.cyan.shade100,
    ),
    EventDesignPattern(
      id: 'min_10',
      name: 'Minimal Amber',
      painter: SolidPainter(Colors.amber.shade400),
      primaryColor: Colors.amber.shade400,
      secondaryColor: Colors.amber.shade100,
    ),

    // Glass Theme (10 patterns - frosted glass for modern/practical look)
    EventDesignPattern(
      id: 'glass_1',
      name: 'Glass Wave',
      painter: WaveGlassPainter(Colors.blue.shade300.withOpacity(0.3)),
      primaryColor: Colors.blue.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
      layout: EventLayoutVariant.standard,
    ),
    EventDesignPattern(
      id: 'glass_2',
      name: 'Glass Diamond',
      painter: DiamondGlassPainter(Colors.green.shade300.withOpacity(0.3)),
      primaryColor: Colors.green.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
    ),
    // ... (similar for 3-10: different painters/colors/layouts)
    EventDesignPattern(
      id: 'glass_3',
      name: 'Glass Ripple',
      painter: LinesGlassPainter(Colors.orange.shade300.withOpacity(0.3)),
      primaryColor: Colors.orange.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
    ),
    EventDesignPattern(
      id: 'glass_4',
      name: 'Glass Hex',
      painter: HexGlassPainter(Colors.purple.shade300.withOpacity(0.3)),
      primaryColor: Colors.purple.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
      layout: EventLayoutVariant.expanded,
    ),
    EventDesignPattern(
      id: 'glass_5',
      name: 'Glass Shine',
      painter: ShineGlassPainter(Colors.red.shade300.withOpacity(0.3)),
      primaryColor: Colors.red.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
    ),
    EventDesignPattern(
      id: 'glass_6',
      name: 'Glass Blur',
      painter: BlurGlassPainter(Colors.teal.shade300.withOpacity(0.3)),
      primaryColor: Colors.teal.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
    ),
    EventDesignPattern(
      id: 'glass_7',
      name: 'Glass Fold',
      painter: FoldGlassPainter(Colors.indigo.shade300.withOpacity(0.3)),
      primaryColor: Colors.indigo.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
    ),
    EventDesignPattern(
      id: 'glass_8',
      name: 'Glass Orbit',
      painter: GridGlassPainter(Colors.pink.shade300.withOpacity(0.3)),
      primaryColor: Colors.pink.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
    ),
    EventDesignPattern(
      id: 'glass_9',
      name: 'Glass Pulse',
      painter: StripeGlassPainter(Colors.cyan.shade300.withOpacity(0.3)),
      primaryColor: Colors.cyan.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
    ),
    EventDesignPattern(
      id: 'glass_10',
      name: 'Glass Sparkle',
      painter: ShineGlassPainter(Colors.amber.shade300.withOpacity(0.3)),
      primaryColor: Colors.amber.shade300,
      secondaryColor: Colors.white.withOpacity(0.2),
    ),

    // Gradient Theme (10 patterns - vibrant, eye-catching for dashboard)
    EventDesignPattern(
      id: 'grad_1',
      name: 'Sunrise',
      painter: LinearGradientPainter([
        Colors.orange.shade400,
        Colors.yellow.shade400,
      ]),
      primaryColor: Colors.orange.shade400,
      secondaryColor: Colors.yellow.shade400,
    ),
    // ... (8 more gradients: Aurora, Ocean, Forest, Sunset, etc.)
    EventDesignPattern(
      id: 'grad_2',
      name: 'Aurora',
      painter: RectGradientPainter([
        Colors.purple.shade400,
        Colors.blue.shade400,
        Colors.green.shade400,
      ]),
      primaryColor: Colors.purple.shade400,
      secondaryColor: Colors.blue.shade400,
    ),
    EventDesignPattern(
      id: 'grad_3',
      name: 'Ocean Wave',
      painter: CornerGradientPainter(Colors.blue.shade300, Colors.teal.shade400),
      primaryColor: Colors.blue.shade300,
      secondaryColor: Colors.teal.shade400,
    ),
    EventDesignPattern(
      id: 'grad_4',
      name: 'Forest',
      painter: LinearGradientPainter([
        Colors.green.shade300,
        Colors.green.shade400,
      ]),
      primaryColor: Colors.green.shade400,
      secondaryColor: Colors.green.shade300,
    ),
    EventDesignPattern(
      id: 'grad_5',
      name: 'Sunset',
      painter: LinearGradientPainter([
        Colors.pink.shade400,
        Colors.orange.shade500,
        Colors.red.shade400,
      ]),
      primaryColor: Colors.pink.shade400,
      secondaryColor: Colors.red.shade400,
    ),
    EventDesignPattern(
      id: 'grad_6',
      name: 'Neon',
      painter: LinearGradientPainter([
        Colors.cyan.shade400,
        Colors.purple.shade500,
      ]),
      primaryColor: Colors.cyan.shade400,
      secondaryColor: Colors.purple.shade500,
    ),
    EventDesignPattern(
      id: 'grad_7',
      name: 'Lava',
      painter: RectGradientPainter([
        Colors.red.shade400,
        Colors.orange.shade600,
      ]),
      primaryColor: Colors.red.shade400,
      secondaryColor: Colors.orange.shade600,
    ),
    EventDesignPattern(
      id: 'grad_8',
      name: 'Ice',
      painter: LinearGradientPainter([Colors.lightBlue.shade400, Colors.white]),
      primaryColor: Colors.lightBlue.shade400,
      secondaryColor: Colors.white,
    ),
    EventDesignPattern(
      id: 'grad_9',
      name: 'Golden',
      painter: CornerGradientPainter(
        Colors.amber.shade400,
        const Color(0xFFFFD700),
      ),
      primaryColor: Colors.amber.shade400,
      secondaryColor: const Color(0xFFFFD700),
    ),
    EventDesignPattern(
      id: 'grad_10',
      name: 'Plasma',
      painter: LinearGradientPainter([
        Colors.deepPurple.shade400,
        Colors.pink.shade400,
      ]),
      primaryColor: Colors.deepPurple.shade400,
      secondaryColor: Colors.pink.shade400,
    ),

    // Neumorphic Theme (10 patterns - tactile, practical for cards)
    EventDesignPattern(
      id: 'neo_1',
      name: 'Neumorphic Soft',
      painter: NeumorphicPainter(Colors.grey.shade200, light: true),
      primaryColor: Colors.grey.shade200,
      secondaryColor: Colors.white,
      priorityStyle: PriorityStyle.none,
    ),
    // ... (9 more: different shadows, emboss, press effects)
    EventDesignPattern(
      id: 'neo_2',
      name: 'Neumorphic Blue',
      painter: NeumorphicPainter(Colors.blue.shade100, light: true),
      primaryColor: Colors.blue.shade100,
      secondaryColor: Colors.blue.shade50,
    ),
    EventDesignPattern(
      id: 'neo_3',
      name: 'Neumorphic Dark',
      painter: NeumorphicPainter(Colors.grey.shade800, light: false),
      primaryColor: Colors.grey.shade800,
      secondaryColor: Colors.grey.shade700,
    ),
    EventDesignPattern(
      id: 'neo_4',
      name: 'Neumorphic Green Emboss',
      painter: EmbossPainter(Colors.green.shade200),
      primaryColor: Colors.green.shade200,
      secondaryColor: Colors.green.shade100,
    ),
    EventDesignPattern(
      id: 'neo_5',
      name: 'Neumorphic Purple Pressed',
      painter: PressedNeumorphicPainter(Colors.purple.shade200),
      primaryColor: Colors.purple.shade200,
      secondaryColor: Colors.purple.shade100,
    ),
    EventDesignPattern(
      id: 'neo_6',
      name: 'Neumorphic Shadow Deep',
      painter: DeepShadowPainter(Colors.indigo.shade200),
      primaryColor: Colors.indigo.shade200,
      secondaryColor: Colors.indigo.shade100,
    ),
    EventDesignPattern(
      id: 'neo_7',
      name: 'Neumorphic Concave',
      painter: ConcavePainter(Colors.orange.shade200),
      primaryColor: Colors.orange.shade200,
      secondaryColor: Colors.orange.shade100,
    ),
    EventDesignPattern(
      id: 'neo_8',
      name: 'Neumorphic Ridge',
      painter: RidgePainter(Colors.teal.shade200),
      primaryColor: Colors.teal.shade200,
      secondaryColor: Colors.teal.shade100,
    ),
    EventDesignPattern(
      id: 'neo_9',
      name: 'Neumorphic Glow',
      painter: GlowNeumorphicPainter(Colors.pink.shade200),
      primaryColor: Colors.pink.shade200,
      secondaryColor: Colors.pink.shade100,
    ),
    EventDesignPattern(
      id: 'neo_10',
      name: 'Neumorphic Matte',
      painter: MatteNeumorphicPainter(Colors.amber.shade200),
      primaryColor: Colors.amber.shade200,
      secondaryColor: Colors.amber.shade100,
    ),
  ];

  /// Get all patterns
  static List<EventDesignPattern> get all => List.unmodifiable(_patterns);

  /// Get random pattern
  static EventDesignPattern get random =>
      _patterns[DateTime.now().millisecondsSinceEpoch % _patterns.length];

  /// Get by ID (safe fallback to first)
  static EventDesignPattern? byId(String id) =>
      _patterns.firstWhereOrNull((p) => p.id == id) ?? _patterns.first;

  /// Get practical defaults for events (prioritize hasTimeBadge=true)
  static List<EventDesignPattern> get practicalDefaults =>
      _patterns.where((p) => p.hasTimeBadge).take(20).toList();
}
