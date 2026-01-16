import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';
import '../../../../core/app_content_palette.dart';

class ClipboardCard extends StatelessWidget {
  final ClipboardItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final Function(Color) onColorChanged;

  const ClipboardCard({
    super.key,
    required this.item,
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
      if (!jsonSource.startsWith('[')) return {"text": jsonSource, "imageUrl": null};
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

  IconData _getTypeIconData(String type) {
    switch (type) {
      case 'link': return Icons.link;
      case 'phone': return Icons.phone;
      default: return Icons.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parsed = _parseContent(item.content);
    final String previewText = parsed['text'];
    final String? imageUrl = parsed['imageUrl'];

    final Color clipThemeColor = item.colorValue != null
        ? Color(item.colorValue!)
        : theme.colorScheme.surface;

    final Color contentColor = AppContentPalette.getContrastColor(clipThemeColor);

    // ✅ OPTIMIZATION: High-performance Decoration (Replaces GlassContainer)
    final decoration = BoxDecoration(
      color: clipThemeColor.withOpacity(isSelected ? 0.6 : 0.65),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5
      ),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4)
        )
      ],
    );

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: 'clip_bg_${item.id}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: isSelected ? Matrix4.identity().scaled(0.98) : Matrix4.identity(),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: decoration, // Using the fast decoration
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(_getTypeIconData(item.type), color: contentColor.withOpacity(0.5), size: 20),
                      const SizedBox(width: 8),
                      Material(
                        type: MaterialType.transparency,
                        child: Text(
                          DateFormat('MMM dd, h:mm a').format(item.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(color: contentColor.withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 20,
                    color: isSelected ? theme.colorScheme.primary : contentColor.withOpacity(0.2),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imageUrl),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              Material(
                type: MaterialType.transparency,
                child: Text(
                  previewText,
                  maxLines: imageUrl != null ? 2 : 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(color: contentColor, height: 1.3),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _QuickColorPicker(
                    onColorSelected: onColorChanged,
                    currentColor: clipThemeColor,
                  ),
                  const Spacer(),
                  IgnorePointer(
                    ignoring: isSelected,
                    child: Row(
                      children: [
                        _smallBtn(Icons.copy_rounded, onCopy, contentColor),
                        _smallBtn(Icons.share_rounded, onShare, contentColor),
                        _smallBtn(Icons.delete_outline_rounded, onDelete, Colors.redAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallBtn(IconData icon, VoidCallback onPressed, Color color) {
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
    final List<Color> palette = AppContentPalette.palette;
    final theme = Theme.of(context);

    return Row(
      children: palette.map((color) {
        final isSelected = currentColor.value == color.value;
        final contrastColor = AppContentPalette.getContrastColor(color);
        final primaryColor = theme.colorScheme.primary;

        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 6),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? primaryColor
                    : contrastColor.withOpacity(0.2),
                width: isSelected ? 2.5 : 1,
              ),
            ),
            child: isSelected
                ? Icon(
              Icons.check,
              size: 14,
              color: contrastColor,
            )
                : null,
          ),
        );
      }).toList(),
    );
  }
}