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

    final borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(4),
      bottomLeft: Radius.circular(4),
      topRight: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'journal_list_${entry.id}',
        child: Container(
          height: 180,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            color: cardBaseColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: isSelected ? primaryColor : Colors.black.withOpacity(0.06),
              width: isSelected ? 3.0 : 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: CustomPaint(
              painter: design.painterBuilder(cardBaseColor),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              DateFormat('dd').format(entry.date),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: contentColor,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'MMM',
                              ).format(entry.date).toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: contentColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _getMoodEmoji(entry.mood),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  entry.title.isNotEmpty
                                      ? entry.title
                                      : "Untitled",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: contentColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: contentColor.withOpacity(0.6),
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
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'design',
                                      child: Row(
                                        children: [
                                          Icon(Icons.palette_outlined),
                                          SizedBox(width: 8),
                                          Text("Change Design"),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'copy',
                                      child: Row(
                                        children: [
                                          Icon(Icons.copy),
                                          SizedBox(width: 8),
                                          Text("Copy"),
                                        ],
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
                                          Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (imageUrl != null)
                            Container(
                              height: 60,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                image: DecorationImage(
                                  image: FileImage(File(imageUrl)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              previewText,
                              maxLines: imageUrl != null ? 2 : 5,
                              overflow: TextOverflow.fade,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: contentColor.withOpacity(0.85),
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (entry.tags.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.tag,
                                    size: 12,
                                    color: contentColor.withOpacity(0.5),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      entry.tags.join(", "),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontSize: 10,
                                            color: contentColor.withOpacity(
                                              0.6,
                                            ),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
