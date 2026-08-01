import 'dart:convert';
import 'dart:io';
import 'package:copyclip/src/features/journal/presentation/designs/journal_design_registry.dart';
import 'package:copyclip/src/features/journal/presentation/widgets/design_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';

class JournalListCard extends StatelessWidget {
  final JournalEntry entry;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final Function(String) onDesignChanged;

  const JournalListCard({
    super.key,
    required this.entry,
    required this.isSelected,
    required this.onTap,
    required this.onCopy,
    required this.onShare,
    required this.onDelete,
    required this.onDesignChanged,
  });

  Map<String, dynamic> _parseContent(String jsonSource) {
    if (jsonSource.isEmpty) return {"text": "No content", "imageUrl": null};
    try {
      if (!jsonSource.startsWith('[')) {
        return {"text": jsonSource, "imageUrl": null};
      }
      final List<dynamic> delta = jsonDecode(jsonSource);
      String plainText = "";
      String? firstImageUrl;

      for (var op in delta) {
        if (op.containsKey('insert')) {
          final insertData = op['insert'];
          if (insertData is String) {
            plainText += insertData;
          } else if (insertData is Map && firstImageUrl == null) {
            if (insertData.containsKey('image')) {
              firstImageUrl = insertData['image'];
            }
          }
        }
      }
      return {"text": plainText.trim(), "imageUrl": firstImageUrl};
    } catch (e) {
      return {"text": "Error parsing content", "imageUrl": null};
    }
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Happy':
        return '😊';
      case 'Excited':
        return '🤩';
      case 'Neutral':
        return '😐';
      case 'Sad':
        return '😔';
      case 'Stressed':
        return '😫';
      default:
        return '😐';
    }
  }

  void _showDesignPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => DesignPickerSheet(
        currentDesignId: entry.designId,
        onDesignSelected: onDesignChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final parsed = _parseContent(entry.content);

    final design = JournalDesignRegistry.getDesign(entry.designId);
    final Color cardBaseColor =
        design.defaultColor ??
        (entry.colorValue != null
            ? Color(entry.colorValue!)
            : theme.colorScheme.surface);

    final Color contentColor = design.isDark ? Colors.white : Colors.black87;
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'journal_bg_${entry.id}',
        child: Container(
          constraints: const BoxConstraints(minHeight: 120, maxHeight: 180),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. BINDING / SPINE (Left) - More subtle and unified
              _buildBinding(design, cardBaseColor),

              // 2. COVER / PAGE (Main)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Color.alphaBlend(
                            Colors.black.withValues(alpha: 0.2),
                            cardBaseColor,
                          )
                        : cardBaseColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.05)),
                      width: isSelected ? 2.5 : 1.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: design.painterBuilder(cardBaseColor),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Date & Mood Header
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: contentColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          DateFormat('dd').format(entry.date),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: contentColor,
                                            height: 1.1,
                                          ),
                                        ),
                                        Text(
                                          DateFormat(
                                            'MMM',
                                          ).format(entry.date).toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: contentColor.withValues(
                                              alpha: 0.6,
                                            ),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                entry.title.isNotEmpty
                                                    ? entry.title
                                                    : "Untitled Entry",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: contentColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _getMoodEmoji(entry.mood),
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (entry.tags.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: Text(
                                              entry.tags
                                                  .join(" • ")
                                                  .toUpperCase(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: contentColor.withValues(
                                                  alpha: 0.5,
                                                ),
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  _buildMenuButton(context, contentColor),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Content Preview
                              Expanded(
                                child: _buildContentPreview(
                                  parsed,
                                  contentColor,
                                  theme,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. PAGE EDGE DEPTH (Right) - More subtle
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: CustomPaint(painter: PageEdgePainter()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentPreview(
    Map<String, dynamic> parsed,
    Color contentColor,
    ThemeData theme,
  ) {
    if (parsed['imageUrl'] != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              parsed['text'],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: contentColor.withValues(alpha: 0.8),
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.file(
              File(parsed['imageUrl']),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    } else {
      return Text(
        parsed['text'],
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: contentColor.withValues(alpha: 0.8),
          height: 1.4,
          fontFamily: 'Serif', // Handwriting style preference
        ),
      );
    }
  }

  Widget _buildBinding(JournalDesign design, Color baseColor) {
    // Determine binding type based on design ID
    if (design.id == 'notebook_spiral') {
      return _buildSpiralBinding(baseColor);
    } else if (design.id == 'composition' || design.id.contains('bound')) {
      return _buildHardcoverSpine(baseColor);
    } else if (design.id == 'legal_pad') {
      // return _buildTopBinding(baseColor); // Special case handling?
      // Actually legal pad is top bound, but card is row. We'll simulate side for consistency or adjust.
      // Let's stick to standard notebook binding for card row consistency.
      return _buildWireBinding(baseColor);
    } else {
      return _buildSoftcoverSpine(baseColor, design.defaultColor);
    }
  }

  // --- BINDING WIDGETS ---

  Widget _buildSpiralBinding(Color color) {
    return Container(
      width: 24,
      color: Colors.transparent,
      child: Stack(
        children: [
          // Base hole strip
          Positioned.fill(
            child: Container(
              color: color
                  .withBlue(color.blue - 10)
                  .withRed(color.red - 10)
                  .withGreen(color.green - 10), // slightly darker
            ),
          ),
          // Spirals
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              8,
              (index) => Container(
                height: 12,
                width: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[800], // Wire
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(1, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: Center(
                  child: Container(
                    height: 4,
                    width: 20,
                    color: Colors.grey[400], // Shine
                    margin: const EdgeInsets.only(bottom: 4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWireBinding(Color color) {
    return _buildSpiralBinding(color); // Reuse for now
  }

  Widget _buildHardcoverSpine(Color baseColor) {
    // Leather/Composition spine
    return Container(
      width: 25,
      decoration: BoxDecoration(
        color: Colors.black87, // Often black tape for composition
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.black87, Colors.grey[800]!, Colors.black87],
        ),
      ),
    );
  }

  Widget _buildSoftcoverSpine(Color baseColor, Color? defaultColor) {
    // Just a fold
    final spineColor = defaultColor != null
        ? defaultColor.withValues(alpha: 0.9)
        : baseColor.withValues(alpha: 0.9);

    return Container(
      width: 16,
      decoration: BoxDecoration(
        color: spineColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(1, 0),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, Color color) {
    return SizedBox(
      height: 24,
      width: 24,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_horiz, // more subtle
          color: color.withValues(alpha: 0.6),
          size: 20,
        ),
        onSelected: (value) {
          switch (value) {
            case 'design':
              _showDesignPicker(context);
              break;
            case 'copy':
              onCopy();
              break;
            case 'share':
              onShare();
              break;
            case 'delete':
              onDelete();
              break;
          }
        },
        itemBuilder: (context) {
          final design = JournalDesignRegistry.getDesign(entry.designId);
          return [
            PopupMenuItem(
              value: 'design',
              child: Row(
                children: [
                  Icon(design.icon, size: 20),
                  const SizedBox(width: 8),
                  const Text("Change Design"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'copy',
              child: Row(
                children: [Icon(Icons.copy), SizedBox(width: 8), Text("Copy")],
              ),
            ),
            const PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 8),
                  Text("Share"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Delete", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}

class PageEdgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 0.5;

    for (double y = 4; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
