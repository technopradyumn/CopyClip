import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final Function(Color) onColorChanged; // Added for real-time color picking

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
  });

  // Logic to extract clean text and find the first image in the Journal content
  Map<String, dynamic> _parseContent(String jsonSource) {
    if (jsonSource.isEmpty) return {"text": "No content", "imageUrl": null};
    if (!jsonSource.startsWith('[')) return {"text": jsonSource, "imageUrl": null};
    try {
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
      case 'Happy': return '😊';
      case 'Excited': return '🤩';
      case 'Neutral': return '😐';
      case 'Sad': return '😔';
      case 'Stressed': return '😫';
      default: return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parsed = _parseContent(entry.content);
    final String previewText = parsed['text'];
    final String? imageUrl = parsed['imageUrl'];

    // Sync color logic with NoteCard
    final Color cardBaseColor = entry.colorValue != null
        ? Color(entry.colorValue!)
        : theme.colorScheme.surface;

    final bool isDarkColor = ThemeData.estimateBrightnessForColor(cardBaseColor) == Brightness.dark;
    final Color contentColor = isDarkColor ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: 'journal_bg_${entry.id}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: isSelected ? Matrix4.identity().scaled(0.98) : Matrix4.identity(),
          child: GlassContainer(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            color: cardBaseColor,
            opacity: isSelected ? 0.9 : 0.8,
            blur: 10,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DATE & MOOD COLUMN
                    Column(
                      children: [
                        Text(DateFormat('MMM').format(entry.date).toUpperCase(),
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                        Text(DateFormat('dd').format(entry.date),
                            style: theme.textTheme.headlineSmall?.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: contentColor)),
                        const SizedBox(height: 8),
                        Text(_getMoodEmoji(entry.mood), style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(width: 8),

                    // MAIN CONTENT COLUMN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    entry.title.isNotEmpty ? entry.title : "Untitled",
                                    maxLines: 1,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: contentColor),
                                  ),
                                ),
                              ),
                              Icon(
                                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                size: 18,
                                color: isSelected ? theme.colorScheme.primary : contentColor.withOpacity(0.2),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // IMAGE PREVIEW
                          if (imageUrl != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(imageUrl),
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.network(imageUrl, height: 100, fit: BoxFit.cover,
                                      errorBuilder: (c,e,s) => const SizedBox.shrink()),
                                ),
                              ),
                            ),

                          Material(
                            type: MaterialType.transparency,
                            child: Text(
                              previewText,
                              maxLines: imageUrl != null ? 2 : 4,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(color: contentColor.withOpacity(0.8), height: 1.4),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _QuickColorPicker(
                      onColorSelected: onColorChanged,
                      currentColor: cardBaseColor,
                    ),
                    const Spacer(),
                    IgnorePointer(
                      ignoring: isSelected,
                      child: Row(
                        children: [
                          _actionBtn(Icons.copy_rounded, onCopy, contentColor),
                          _actionBtn(Icons.share, onShare, contentColor),
                          _actionBtn(Icons.delete_outline_rounded, onDelete, Colors.redAccent),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, VoidCallback onPressed, Color color) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 18, color: color.withOpacity(0.6)),
      onPressed: onPressed,
    );
  }
}

class _QuickColorPicker extends StatelessWidget {
  final Function(Color) onColorSelected;
  final Color currentColor;
  const _QuickColorPicker({required this.onColorSelected, required this.currentColor});

  @override
  Widget build(BuildContext context) {
    final List<Color> palette = [Colors.white, const Color(0xFFFFCC00), const Color(0xFFFF3B30), const Color(0xFF007AFF), const Color(0xFF34C759)];
    return Row(
      children: palette.map((color) {
        final isSelected = currentColor.value == color.value;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            width: 20, height: 20,
            decoration: BoxDecoration(
              color: color, shape: BoxShape.circle,
              border: Border.all(color: isSelected ? Colors.blue : Colors.white.withOpacity(0.5), width: isSelected ? 2 : 1),
            ),
          ),
        );
      }).toList(),
    );
  }
}