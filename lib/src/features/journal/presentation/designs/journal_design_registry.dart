import 'package:copyclip/src/features/journal/presentation/designs/journal_design_painters.dart';
import 'package:flutter/material.dart';

class JournalDesign {
  final String id;
  final String name;
  final CustomPainter Function(Color baseColor) painterBuilder;
  final Color? defaultColor;
  final TextStyle? textStyle;
  final bool isDark;
  final IconData icon;

  const JournalDesign({
    required this.id,
    required this.name,
    required this.painterBuilder,
    this.defaultColor,
    this.textStyle,
    this.isDark = false,
    this.icon = Icons.sticky_note_2_outlined,
  });
}

class JournalDesignRegistry {
  static final List<JournalDesign> designs = [
    JournalDesign(
      id: 'default',
      name: 'Clean Slate',
      painterBuilder: (c) => DefaultDesignPainter(color: c),
      icon: Icons.check_box_outline_blank,
    ),
    JournalDesign(
      id: 'classic_ruled',
      name: 'Classic Ruled',
      painterBuilder: (c) => RuledPaperPainter(color: c),
      defaultColor: const Color(0xFFFDFDFD),
      icon: Icons.format_align_justify,
    ),
    JournalDesign(
      id: 'grid_paper',
      name: 'Graph Paper',
      painterBuilder: (c) => GridPaperPainter(color: c),
      defaultColor: const Color(0xFFFDFDFD),
      icon: Icons.grid_3x3,
    ),
    JournalDesign(
      id: 'dots_grid',
      name: 'Dot Grid',
      painterBuilder: (c) => DotGridPainter(color: c),
      defaultColor: const Color(0xFFFDFDFD),
      icon: Icons.apps,
    ),
    JournalDesign(
      id: 'vintage_paper',
      name: 'Vintage',
      painterBuilder: (c) => VintagePaperPainter(color: c),
      defaultColor: const Color(0xFFE0D8C8),
      icon: Icons.history_edu,
    ),
    JournalDesign(
      id: 'blueprint',
      name: 'Blueprint',
      painterBuilder: (c) => BlueprintPainter(color: c),
      defaultColor: const Color(0xFF1F4E79),
      isDark: true,
      icon: Icons.architecture,
    ),
    JournalDesign(
      id: 'notebook_spiral',
      name: 'Spiral',
      painterBuilder: (c) => SpiralNotebookPainter(color: c),
      defaultColor: const Color(0xFFFDFDFD),
      icon: Icons.assignment,
    ),
    JournalDesign(
      id: 'composition',
      name: 'Composition',
      painterBuilder: (c) => CompositionBookPainter(color: c),
      defaultColor: Colors.black87,
      isDark: true,
      icon: Icons.menu_book,
    ),
    JournalDesign(
      id: 'leather_bound',
      name: 'Leather',
      painterBuilder: (c) => LeatherTexturePainter(color: c),
      defaultColor: const Color(0xFF8B4513),
      isDark: true,
      icon: Icons.book,
    ),
    JournalDesign(
      id: 'canvas',
      name: 'Canvas',
      painterBuilder: (c) => CanvasTexturePainter(color: c),
      defaultColor: const Color(0xFFFAF0E6),
      icon: Icons.texture,
    ),
    JournalDesign(
      id: 'legal_pad',
      name: 'Legal Pad',
      painterBuilder: (c) => LegalPadPainter(color: c),
      defaultColor: const Color(0xFFFFF7D1),
      icon: Icons.article_outlined,
    ),
    JournalDesign(
      id: 'dark_mode',
      name: 'Midnight',
      painterBuilder: (c) => DarkModePainter(color: c),
      defaultColor: const Color(0xFF1E1E1E),
      isDark: true,
      icon: Icons.dark_mode,
    ),
    JournalDesign(
      id: 'pastel_dreams',
      name: 'Pastel',
      painterBuilder: (c) => PastelGeometricPainter(color: c),
      defaultColor: const Color(0xFFFFF0F5),
      icon: Icons.cloud_queue,
    ),
    JournalDesign(
      id: 'watercolor',
      name: 'Watercolor',
      painterBuilder: (c) => WatercolorPainter(color: c),
      defaultColor: const Color(0xFFFFFFFF),
      icon: Icons.brush,
    ),
    JournalDesign(
      id: 'stars_night',
      name: 'Starry Night',
      painterBuilder: (c) => StarryNightPainter(color: c),
      defaultColor: const Color(0xFF0C1445),
      isDark: true,
      icon: Icons.nights_stay,
    ),
    JournalDesign(
      id: 'geometric_modern',
      name: 'Geo Modern',
      painterBuilder: (c) => GeometricModernPainter(color: c),
      defaultColor: const Color(0xFFF5F5F5),
      icon: Icons.category,
    ),
    JournalDesign(
      id: 'circuit_board',
      name: 'Cyber',
      painterBuilder: (c) => CircuitBoardPainter(color: c),
      defaultColor: const Color(0xFF0F172A),
      isDark: true,
      icon: Icons.memory,
    ),
    JournalDesign(
      id: 'wood_grain',
      name: 'Wood',
      painterBuilder: (c) => WoodGrainPainter(color: c),
      defaultColor: const Color(0xFFA67B5B),
      icon: Icons.cabin,
    ),
    JournalDesign(
      id: 'marble',
      name: 'Marble',
      painterBuilder: (c) => MarbleTexturePainter(color: c),
      defaultColor: const Color(0xFFF0F0F0),
      icon: Icons.landscape,
    ),
    JournalDesign(
      id: 'cork_board',
      name: 'Cork',
      painterBuilder: (c) => CorkBoardPainter(color: c),
      defaultColor: const Color(0xFFD7C49E),
      icon: Icons.push_pin,
    ),
    JournalDesign(
      id: 'crumpled_paper',
      name: 'Crumpled',
      painterBuilder: (c) => CrumpledPaperPainter(color: c),
      defaultColor: const Color(0xFFEEEEEE),
      icon: Icons.recycling,
    ),
  ];

  static JournalDesign getDesign(String? id) {
    return designs.firstWhere((d) => d.id == id, orElse: () => designs.first);
  }
}
