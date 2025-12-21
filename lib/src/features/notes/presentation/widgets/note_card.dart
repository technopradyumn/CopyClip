import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure intl package is in pubspec.yaml
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'dart:io';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final Function(Color) onColorChanged;

  const NoteCard({
    super.key,
    required this.note,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
    required this.onCopy,
    required this.onShare,
    required this.onDelete,
    required this.onColorChanged,
  });

  Map<String, dynamic> _parseContent(String jsonSource) {
    if (jsonSource.isEmpty) return {"text": "No content", "imageUrl": null};
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
      return {"text": jsonSource, "imageUrl": null};
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parsed = _parseContent(note.content);
    final String previewText = parsed['text'];
    final String? imageUrl = parsed['imageUrl'];

    final Color noteThemeColor = note.colorValue != null
        ? Color(note.colorValue!)
        : theme.colorScheme.surface;

    final bool isDarkColor = ThemeData.estimateBrightnessForColor(noteThemeColor) == Brightness.dark;
    final Color contentColor = isDarkColor ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: 'note_background_${note.id}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: isSelected ? Matrix4.identity().scaled(0.98) : Matrix4.identity(),
          child: GlassContainer(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            color: noteThemeColor,
            opacity: isSelected ? 0.9 : 0.8,
            blur: 3,
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
                          note.title.isNotEmpty ? note.title : "Untitled",
                          maxLines: 1,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: contentColor,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 20,
                      color: isSelected ? theme.colorScheme.primary : contentColor.withOpacity(0.3),
                    ),
                  ],
                ),

                // Date and Time Pill
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: contentColor.withOpacity(0.5)),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy  •  hh:mm a').format(note.updatedAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: contentColor.withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildImage(imageUrl),
                    ),
                  ),

                Material(
                  type: MaterialType.transparency,
                  child: Text(
                    previewText,
                    maxLines: imageUrl != null ? 2 : 4,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: contentColor.withOpacity(0.8),
                      height: 1.2, // Adjusted for compact look
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _QuickColorPicker(
                      onColorSelected: onColorChanged,
                      currentColor: noteThemeColor,
                    ),
                    const Spacer(),
                    IgnorePointer(
                      ignoring: isSelected,
                      child: Row(
                        children: [
                          _smallActionBtn(Icons.copy_rounded, onCopy, contentColor),
                          _smallActionBtn(Icons.share, onShare, contentColor),
                          _smallActionBtn(Icons.delete_outline_rounded, onDelete, Colors.redAccent),
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

  Widget _buildImage(String url) {
    return Image.file(
      File(url),
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.network(
          url,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _smallActionBtn(IconData icon, VoidCallback onPressed, Color color) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 18, color: color.withOpacity(0.7)),
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
    final List<Color> dotPalette = [
      Colors.white,
      const Color(0xFFFFCC00),
      const Color(0xFFFF3B30),
      const Color(0xFF007AFF),
      const Color(0xFF34C759),
    ];

    return Row(
      children: dotPalette.map((color) {
        final isSelected = currentColor.value == color.value;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.white.withOpacity(0.5),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)] : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}