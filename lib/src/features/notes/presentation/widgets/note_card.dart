import 'dart:convert';
import 'dart:io';
import 'package:copyclip/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import '../../../../core/app_content_palette.dart';
import '../../../../core/const/constant.dart';

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

  Map<String, dynamic> _parseContent(BuildContext context, String jsonSource) {
    if (jsonSource.isEmpty) {
      return {
        "text": AppLocalizations.of(context)!.noContent,
        "imageUrl": null,
      };
    }
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
      return {"text": jsonSource, "imageUrl": null};
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parsed = _parseContent(context, note.content);
    final String previewText = parsed['text'];
    final String? imageUrl = parsed['imageUrl'];

    final Color noteThemeColor = note.colorValue != null
        ? AppContentPalette.getColorFromValue(note.colorValue!)
        : AppContentPalette.palette[0];

    final Color contentColor = AppContentPalette.getContrastColor(
      noteThemeColor,
    );

    // ✅ 2026 UI: Premium Glass Glass Decoration
    final decoration = BoxDecoration(
      color: noteThemeColor.withValues(alpha: isSelected ? 0.3 : 0.4),
      borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
      border: Border.all(
        color: contentColor.withValues(alpha: 0.15),
        width: AppConstants.borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: noteThemeColor.withValues(alpha: 0.15),
          blurRadius: 25,
          offset: const Offset(0, 10),
          spreadRadius: -5,
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: 'note_background_${note.id}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: isSelected
              ? Matrix4.identity().scaled(0.96)
              : Matrix4.identity(),
          margin: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: decoration,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                note.title.isNotEmpty
                                    ? note.title
                                    : AppLocalizations.of(context)!.untitled,
                                maxLines: 1,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: contentColor,
                                  letterSpacing: -0.5,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            duration: const Duration(milliseconds: 300),
                            turns: isSelected ? 0.125 : 0,
                            child: Icon(
                              isSelected
                                  ? CupertinoIcons.check_mark_circled_solid
                                  : CupertinoIcons.circle,
                              size: 20,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : contentColor.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.time,
                                size: 12,
                                color: contentColor.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat(
                                  'MMM dd, yyyy  •  hh:mm a',
                                ).format(note.updatedAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: contentColor.withValues(alpha: 0.6),
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
                            borderRadius: BorderRadius.circular(
                              AppConstants.cornerRadius * 0.5,
                            ),
                            child: Image.file(
                              File(imageUrl),
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const SizedBox.shrink(),
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
                            color: contentColor.withValues(alpha: 0.8),
                            height: 1.2,
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
                                _smallActionBtn(
                                  CupertinoIcons.doc_on_doc,
                                  onCopy,
                                  contentColor,
                                ),
                                _smallActionBtn(
                                  CupertinoIcons.share,
                                  onShare,
                                  contentColor,
                                ),
                                _smallActionBtn(
                                  CupertinoIcons.trash,
                                  onDelete,
                                  Colors.redAccent,
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

  Widget _smallActionBtn(IconData icon, VoidCallback onPressed, Color color) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 18, color: color.withValues(alpha: 0.7)),
      onPressed: onPressed,
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
    final List<Color> dotPalette = AppContentPalette.palette;
    final theme = Theme.of(context);
    final contrastColorForDot = theme.colorScheme.primary;

    return Row(
      children: dotPalette.map((color) {
        final isSelected = currentColor.toARGB32() == color.toARGB32();
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
                color: isSelected
                    ? contrastColorForDot
                    : color.withValues(alpha: 0.5),
                width: isSelected
                    ? AppConstants.selectedBorderWidth
                    : AppConstants.borderWidth,
              ),
            ),
            child: isSelected
                ? Icon(
                    CupertinoIcons.checkmark,
                    size: 14,
                    color: AppContentPalette.getContrastColor(color),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
