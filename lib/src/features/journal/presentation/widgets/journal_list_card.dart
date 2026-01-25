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
      if (!jsonSource.startsWith('['))
        return {"text": jsonSource, "imageUrl": null};
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
    final parsed = _parseContent(entry.content);
    final String previewText = parsed['text'];
    final String? imageUrl = parsed['imageUrl'];

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
        tag: 'journal_list_${entry.id}',
        child: Container(
          height: 190,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          // Outer container gives the shadow
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(4, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. BINDING / SPINE (Left)
              _buildBinding(design, cardBaseColor),

              // 2. COVER / PAGE (Main)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBaseColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : Colors.black.withOpacity(0.05),
                      width: isSelected ? 3.0 : 0.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: CustomPaint(
                      painter: design.painterBuilder(cardBaseColor),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date & Mood Header
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: contentColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        DateFormat('dd').format(entry.date),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: contentColor,
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        DateFormat(
                                          'MMM',
                                        ).format(entry.date).toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: contentColor.withOpacity(0.7),
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
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: contentColor,
                                                    fontFamily:
                                                        'Serif', // More book-like
                                                  ),
                                            ),
                                          ),
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
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  fontSize: 9,
                                                  color: contentColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                _buildMenuButton(context, contentColor),
                              ],
                            ),
                            const Spacer(),
                            // Content Preview with visual improvement
                            Expanded(
                              // Use expanded to fill remaining space
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

              // 3. PAGE EDGE DEPTH (Right)
              // Simulates the thickness of the book
              Container(
                width: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[200]!,
                      Colors.white,
                      Colors.grey[400]!,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                  border: Border(
                    left: BorderSide(color: Colors.black12, width: 0.5),
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
                color: contentColor.withOpacity(0.8),
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
          color: contentColor.withOpacity(0.8),
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
      return _buildTopBinding(baseColor); // Special case handling?
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

  Widget _buildTopBinding(Color baseColor) {
    // For legal pad, usually red top. But we are vertical list.
    // Let's just do a red strip on left to look like the margin strip
    return Container(
      width: 20,
      color: const Color(0xFFD32F2F), // Legal pad red
    );
  }

  Widget _buildSoftcoverSpine(Color baseColor, Color? defaultColor) {
    // Just a fold
    final spineColor = defaultColor != null
        ? defaultColor.withOpacity(0.9)
        : baseColor.withOpacity(0.9);

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
            color: Colors.black.withOpacity(0.2),
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
          color: color.withOpacity(0.6),
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
