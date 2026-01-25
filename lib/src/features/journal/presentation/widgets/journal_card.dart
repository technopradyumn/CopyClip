import 'dart:convert';
import 'dart:io';
import 'package:copyclip/src/features/journal/presentation/designs/journal_design_registry.dart'; // Registry
import 'package:copyclip/src/features/journal/presentation/widgets/design_picker_sheet.dart'; // Picker
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/core/const/constant.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final Function(Color) onColorChanged;
  final Function(String) onDesignChanged; // New callback

  const JournalCard({
    super.key,
    required this.entry,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
    required this.onCopy,
    required this.onShare,
    required this.onDelete,
    required this.onColorChanged,
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

    // 1. Get Design
    final design = JournalDesignRegistry.getDesign(entry.designId);

    // 2. Base Color: Design Default > Entry override > Surface
    // Fix: Prioritize Design's intended color (e.g. Blueprint Blue) over manual color to ensure "pure" look.
    final Color cardBaseColor =
        design.defaultColor ??
        (entry.colorValue != null
            ? Color(entry.colorValue!)
            : theme.colorScheme.surface);

    final Color contentColor = design.isDark ? Colors.white : Colors.black87;
    final primaryColor = theme.colorScheme.primary;

    // Asymmetric Radius: Spine (Left) small, Open (Right) large
    final borderRadius = const BorderRadius.only(
      topLeft: const Radius.circular(4),
      bottomLeft: const Radius.circular(4),
      topRight: Radius.circular(AppConstants.cornerRadius),
      bottomRight: Radius.circular(AppConstants.cornerRadius),
    );

    return GestureDetector(
      onTap: onTap,
      // onLongPress removed to allow GridView to handle drag
      child: Hero(
        tag: 'journal_bg_${entry.id}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: isSelected
              ? Matrix4.identity().scaled(0.95)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: cardBaseColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : (theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1)),
              width: isSelected
                  ? AppConstants.selectedBorderWidth
                  : AppConstants.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(2, 4), // Slight offset
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: CustomPaint(
              painter: design.painterBuilder(cardBaseColor),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER: Date & Options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat(
                                'MMM dd',
                              ).format(entry.date).toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: contentColor.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getMoodEmoji(entry.mood),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        // Three Dots Menu
                        Material(
                          color: Colors.transparent,
                          child: PopupMenuButton<String>(
                            icon: Icon(
                              CupertinoIcons.ellipsis_vertical,
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
                                    Icon(CupertinoIcons.paintbrush),
                                    SizedBox(width: 8),
                                    Text("Change Design"),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'copy',
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.doc_on_doc),
                                    SizedBox(width: 8),
                                    Text("Copy"),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'share',
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.share),
                                    SizedBox(width: 8),
                                    Text("Share"),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.trash,
                                      color: Colors.red,
                                    ),
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

                    // TITLE
                    Text(
                      entry.title.isNotEmpty ? entry.title : "Untitled",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: contentColor,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // IMAGE
                    if (imageUrl != null)
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppConstants.cornerRadius * 0.5,
                            ),
                            image: DecorationImage(
                              image: FileImage(File(imageUrl)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                    // PREVIEW TEXT
                    Expanded(
                      flex: imageUrl != null ? 1 : 3,
                      child: Text(
                        previewText,
                        maxLines: 8,
                        overflow: TextOverflow.fade,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: contentColor.withOpacity(0.85),
                          height: 1.3,
                          fontSize: 11,
                        ),
                      ),
                    ),

                    // TAGS (If space permits, or mini version)
                    if (entry.tags != null && entry.tags!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.tag,
                              size: 12,
                              color: contentColor.withOpacity(0.5),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                entry.tags!.join(", "),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                  color: contentColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            CupertinoIcons.checkmark_circle_fill,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
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
