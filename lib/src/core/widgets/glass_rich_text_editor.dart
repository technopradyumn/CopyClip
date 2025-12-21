import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'timestamp_embed.dart';

class GlassRichTextEditor extends StatelessWidget {
  final QuillController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final String? hintText;

  const GlassRichTextEditor({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.scrollController,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 54,
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 1.2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5)
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: QuillSimpleToolbar(
              controller: controller,
              config: QuillSimpleToolbarConfig(
                embedButtons: FlutterQuillEmbeds.toolbarButtons(),
                showFontFamily: true,
                showFontSize: true,
                showBoldButton: true,
                showItalicButton: true,
                showUnderLineButton: true,
                showStrikeThrough: true,
                showInlineCode: true,
                showColorButton: true,
                showBackgroundColorButton: true,
                showClearFormat: true,
                showAlignmentButtons: true,
                showHeaderStyle: true,
                showListNumbers: true,
                showListBullets: true,
                showListCheck: true,
                showCodeBlock: true,
                showQuote: true,
                showIndent: true,
                showLink: true,
                showUndo: true,
                showRedo: true,
                showDirection: true,
                showSearchButton: true,
                showSubscript: true,
                showSuperscript: true,
                showClipboardCopy: true,
                showClipboardCut: true,
                showClipboardPaste: true,
                showLineHeightButton: true,
                showSmallButton: true,
                multiRowsDisplay: false,
                toolbarSectionSpacing: 4,
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                    iconTheme: QuillIconTheme(
                      iconButtonSelectedData: IconButtonData(
                        style: IconButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          backgroundColor: colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      iconButtonUnselectedData: IconButtonData(
                        style: IconButton.styleFrom(
                          foregroundColor: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: QuillEditor(
            controller: controller,
            focusNode: focusNode,
            scrollController: scrollController,
            config: QuillEditorConfig(
              placeholder: hintText ?? 'Start writing...',
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              autoFocus: false,
              expands: true,
              scrollable: true,
              scrollPhysics: const BouncingScrollPhysics(),
              embedBuilders: [
                ...FlutterQuillEmbeds.editorBuilders(),
                TimeStampEmbedBuilder(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}