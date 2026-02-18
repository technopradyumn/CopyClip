import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';
import 'package:copyclip/src/core/app_content_palette.dart';
import 'package:copyclip/src/core/const/constant.dart';

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
      if (!jsonSource.startsWith('[')) {
        return {"text": jsonSource.trim(), "imageUrl": null};
      }
      final List<dynamic> delta = jsonDecode(jsonSource);
      String plainText = "";
      String? firstImageUrl;

      for (var op in delta) {
        if (op is Map && op.containsKey('insert')) {
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
      final String trimmed = plainText.trim();
      return {
        "text": trimmed.isEmpty ? "Empty content" : trimmed,
        "imageUrl": firstImageUrl,
      };
    } catch (e) {
      final trimmed = jsonSource.trim();
      return {
        "text": trimmed.isEmpty ? "Empty content" : trimmed,
        "imageUrl": null,
      };
    }
  }

  IconData _getTypeIconData(String type) {
    switch (type) {
      case 'link':
        return CupertinoIcons.link;
      case 'phone':
        return CupertinoIcons.phone;
      default:
        return CupertinoIcons.doc_on_clipboard;
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

    final Color contentColor = AppContentPalette.getContrastColor(
      clipThemeColor,
    );

    // ✅ 2026 UI: Premium Glass Glass Decoration
    final decoration = BoxDecoration(
      color: clipThemeColor.withValues(alpha: isSelected ? 0.35 : 0.45),
      borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
      border: Border.all(
        color: contentColor.withValues(alpha: 0.12),
        width: AppConstants.borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: clipThemeColor.withValues(alpha: isSelected ? 0.3 : 0.2),
          blurRadius: 25,
          offset: const Offset(0, 10),
          spreadRadius: -2,
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: 'clip_bg_${item.id}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: isSelected
              ? Matrix4.identity().scaled(0.96)
              : Matrix4.identity(),
          // margin: const EdgeInsets.only(bottom: 16), // Handled by parent
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: decoration,
              child: Stack(
                children: [
                  // Subtle Radial Glow
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            contentColor.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: contentColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getTypeIconData(item.type),
                                  color: contentColor.withValues(alpha: 0.7),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  DateFormat(
                                    'MMM dd • h:mm a',
                                  ).format(item.createdAt),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: contentColor.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            scale: isSelected ? 1.2 : 1.0,
                            child: Icon(
                              isSelected
                                  ? CupertinoIcons.check_mark_circled_solid
                                  : CupertinoIcons.circle,
                              size: 20,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : contentColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (imageUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppConstants.cornerRadius * 0.5,
                            ),
                            child: Image.file(
                              File(imageUrl),
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Material(
                        type: MaterialType.transparency,
                        child: Text(
                          previewText,
                          maxLines: imageUrl != null ? 2 : 4,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: contentColor,
                            height: 1.4,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                                _smallBtn(
                                  CupertinoIcons.doc_on_doc,
                                  onCopy,
                                  contentColor,
                                ),
                                const SizedBox(width: 4),
                                _smallBtn(
                                  CupertinoIcons.share,
                                  onShare,
                                  contentColor,
                                ),
                                const SizedBox(width: 4),
                                _smallBtn(
                                  CupertinoIcons.trash,
                                  onDelete,
                                  Colors.redAccent.withValues(alpha: 0.8),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _smallBtn(IconData icon, VoidCallback onPressed, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        icon: Icon(icon, size: 14, color: color.withValues(alpha: 0.8)),
        onPressed: onPressed,
      ),
    );
  }
}

class _QuickColorPicker extends StatelessWidget {
  final Function(Color) onColorSelected;
  final Color currentColor;
  const _QuickColorPicker({
    required this.onColorSelected,
    required this.currentColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> palette = AppContentPalette.palette;
    final theme = Theme.of(context);

    return Row(
      children: palette.map((color) {
        final isSelected = currentColor.toARGB32() == color.toARGB32();
        final contrastColor = AppContentPalette.getContrastColor(color);
        final primaryColor = theme.colorScheme.primary;

        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 6),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
              border: Border.all(
                color: isSelected
                    ? primaryColor
                    : contrastColor.withValues(alpha: 0.15),
                width: isSelected ? 2.5 : 1.5,
              ),
            ),
            child: isSelected
                ? Icon(CupertinoIcons.checkmark, size: 12, color: contrastColor)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
