import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'timestamp_embed.dart';

class GlassRichTextEditor extends StatefulWidget {
  final QuillController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final String? hintText;

  /// 👇 IMPORTANT: editor background color
  final Color editorBackgroundColor;

  const GlassRichTextEditor({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.scrollController,
    required this.editorBackgroundColor,
    this.hintText,
  });

  @override
  State<GlassRichTextEditor> createState() => _GlassRichTextEditorState();
}

class _GlassRichTextEditorState extends State<GlassRichTextEditor> {
  Brightness? _lastBgBrightness;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bgBrightness =
    ThemeData.estimateBrightnessForColor(widget.editorBackgroundColor);
    final themeBrightness = Theme.of(context).brightness;

    final bool shouldApplyTextColor =
    // White BG + Light Mode
    (bgBrightness == Brightness.light &&
        themeBrightness == Brightness.light) ||

        // White BG + Dark Mode
        (bgBrightness == Brightness.light &&
            themeBrightness == Brightness.dark) ||

        // Black BG + Light Mode
        (bgBrightness == Brightness.dark &&
            themeBrightness == Brightness.light) ||

        // Black BG + Dark Mode
        (bgBrightness == Brightness.dark &&
            themeBrightness == Brightness.dark);

    if (!shouldApplyTextColor) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyDefaultTextColor(
        bgBrightness: bgBrightness,
        themeBrightness: themeBrightness,
      );
    });
  }


  void _applyDefaultTextColor({
    required Brightness bgBrightness,
    required Brightness themeBrightness,
  }) {
    // White BG + Any Mode → BLACK
    if (bgBrightness == Brightness.light) {
      widget.controller.formatSelection(
        Attribute.fromKeyValue('color', '#000000'),
      );
      return;
    }

    // Black BG + Any Mode → WHITE
    if (bgBrightness == Brightness.dark) {
      widget.controller.formatSelection(
        Attribute.fromKeyValue('color', '#ffffff'),
      );
      return;
    }

    // Else → do nothing
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;


    return Column(
      children: [
        // EDITOR
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: QuillEditor(
              controller: widget.controller,
              focusNode: widget.focusNode,
              scrollController: widget.scrollController,
              config: QuillEditorConfig(
                placeholder: widget.hintText ?? 'Start writing...',
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
        ),

        // TOOLBAR
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 38,
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: QuillSimpleToolbar(
              controller: widget.controller,
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
              ),
            ),
          ),
        ),

        AnimatedSize(
          duration: Duration(milliseconds: bottomInset > 0 ? 350 : 350),
          curve: bottomInset > 0
              ? Curves.easeOutCubic
              : Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: bottomInset > 10 ? 10 : 30,
          ),
        )
      ],
    );
  }
}
