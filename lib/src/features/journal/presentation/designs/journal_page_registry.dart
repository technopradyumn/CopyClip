import 'package:flutter/material.dart';
import 'journal_page_painters.dart';

class JournalPageDesign {
  final String id;
  final String name;
  final CustomPainter Function(Color baseColor) painterBuilder;
  final IconData icon;

  const JournalPageDesign({
    required this.id,
    required this.name,
    required this.painterBuilder,
    this.icon = Icons.note_outlined,
  });
}

class JournalPageRegistry {
  static final List<JournalPageDesign> designs = [
    JournalPageDesign(
      id: 'default',
      name: 'Blank',
      painterBuilder: (c) => BlankPagePainter(color: c),
      icon: Icons.check_box_outline_blank,
    ),
    JournalPageDesign(
      id: 'ruled_wide',
      name: 'Ruled (Wide)',
      painterBuilder: (c) => RuledWidePainter(color: c),
      icon: Icons.format_align_justify,
    ),
    JournalPageDesign(
      id: 'ruled_college',
      name: 'Ruled (College)',
      painterBuilder: (c) => RuledCollegePainter(color: c),
      icon: Icons.format_align_left,
    ),
    JournalPageDesign(
      id: 'grid',
      name: 'Grid',
      painterBuilder: (c) => GridPagePainter(color: c),
      icon: Icons.grid_3x3,
    ),
    JournalPageDesign(
      id: 'dot_grid',
      name: 'Dot Grid',
      painterBuilder: (c) => DotGridPagePainter(color: c),
      icon: Icons.apps,
    ),
    JournalPageDesign(
      id: 'isometric',
      name: 'Isometric',
      painterBuilder: (c) => IsometricDotsPainter(color: c),
      icon: Icons.change_history,
    ),
    JournalPageDesign(
      id: 'checklist',
      name: 'Checklist',
      painterBuilder: (c) => ChecklistPagePainter(color: c),
      icon: Icons.checklist,
    ),
    JournalPageDesign(
      id: 'music',
      name: 'Sheet Music',
      painterBuilder: (c) => MusicPagePainter(color: c),
      icon: Icons.music_note,
    ),
    JournalPageDesign(
      id: 'crumpled',
      name: 'Crumpled',
      painterBuilder: (c) => CrumpledPagePainter(color: c),
      icon: Icons.texture,
    ),
    JournalPageDesign(
      id: 'watercolor',
      name: 'Watercolor',
      painterBuilder: (c) => WatercolorPagePainter(color: c),
      icon: Icons.brush,
    ),
    JournalPageDesign(
      id: 'soft_gradient',
      name: 'Gradient',
      painterBuilder: (c) => SoftGradientPainter(color: c),
      icon: Icons.gradient,
    ),
    JournalPageDesign(
      id: 'night_sky',
      name: 'Night Sky',
      painterBuilder: (c) => NightSkyPagePainter(color: c),
      icon: Icons.nights_stay,
    ),
    JournalPageDesign(
      id: 'galaxy',
      name: 'Galaxy',
      painterBuilder: (c) => GalaxyPagePainter(color: c),
      icon: Icons.auto_awesome,
    ),
    JournalPageDesign(
      id: 'sunset',
      name: 'Sunset',
      painterBuilder: (c) => SunsetPagePainter(color: c),
      icon: Icons.sunny,
    ),
    JournalPageDesign(
      id: 'forest',
      name: 'Forest',
      painterBuilder: (c) => ForestPagePainter(color: c),
      icon: Icons.forest,
    ),
    JournalPageDesign(
      id: 'beach',
      name: 'Beach',
      painterBuilder: (c) => BeachPagePainter(color: c),
      icon: Icons.beach_access,
    ),
    JournalPageDesign(
      id: 'geometric',
      name: 'Geometric',
      painterBuilder: (c) => GeometricShapesPainter(color: c),
      icon: Icons.category,
    ),
    JournalPageDesign(
      id: 'abstract',
      name: 'Abstract',
      painterBuilder: (c) => AbstractCurvesPainter(color: c),
      icon: Icons.waves,
    ),
    JournalPageDesign(
      id: 'triangles',
      name: 'Triangles',
      painterBuilder: (c) => TrianglesPagePainter(color: c),
      icon: Icons.change_history,
    ),
    JournalPageDesign(
      id: 'hexagons',
      name: 'Hexagon',
      painterBuilder: (c) => HexagonPagePainter(color: c),
      icon: Icons.hive,
    ),
    JournalPageDesign(
      id: 'blueprint',
      name: 'Blueprint',
      painterBuilder: (c) => BlueprintPagePainter(color: c),
      icon: Icons.architecture,
    ),
    JournalPageDesign(
      id: 'cornell',
      name: 'Cornell',
      painterBuilder: (c) => CornellPagePainter(color: c),
      icon: Icons.note_alt_outlined,
    ),
    JournalPageDesign(
      id: 'storyboard',
      name: 'Storyboard',
      painterBuilder: (c) => StoryboardPagePainter(color: c),
      icon: Icons.crop_landscape,
    ),
    JournalPageDesign(
      id: 'handwriting',
      name: 'Handwriting',
      painterBuilder: (c) => HandwritingPagePainter(color: c),
      icon: Icons.text_fields,
    ),
    JournalPageDesign(
      id: 'engineering',
      name: 'Engineering',
      painterBuilder: (c) => EngineeringGridPainter(color: c),
      icon: Icons.grid_on,
    ),
    JournalPageDesign(
      id: 'code_editor',
      name: 'Code Editor',
      painterBuilder: (c) => CodeEditorPainter(color: c),
      icon: Icons.code,
    ),
    JournalPageDesign(
      id: 'diamond',
      name: 'Diamond',
      painterBuilder: (c) => DiamondGridPainter(color: c),
      icon: Icons.diamond_outlined,
    ),
    JournalPageDesign(
      id: 'confetti',
      name: 'Confetti',
      painterBuilder: (c) => ConfettiPainter(color: c),
      icon: Icons.celebration,
    ),
    JournalPageDesign(
      id: 'bamboo',
      name: 'Bamboo',
      painterBuilder: (c) => BambooPainter(color: c),
      icon: Icons.grass,
    ),
    JournalPageDesign(
      id: 'cross_grid',
      name: 'Cross Grid',
      painterBuilder: (c) => CrossGridPainter(color: c),
      icon: Icons.add,
    ),
    JournalPageDesign(
      id: 'rainy_day',
      name: 'Rainy Day',
      painterBuilder: (c) => RainyDayPainter(color: c),
      icon: Icons.umbrella,
    ),
    JournalPageDesign(
      id: 'grand_staff',
      name: 'Grand Staff',
      painterBuilder: (c) => GrandStaffPainter(color: c),
      icon: Icons.music_note_outlined,
    ),
    JournalPageDesign(
      id: 'dotted_line',
      name: 'Dotted Line',
      painterBuilder: (c) => DottedLinePainter(color: c),
      icon: Icons.more_horiz,
    ),
  ];

  static JournalPageDesign getDesign(String? id) {
    return designs.firstWhere((d) => d.id == id, orElse: () => designs.first);
  }
}
