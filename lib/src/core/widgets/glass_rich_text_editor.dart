import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:copyclip/src/features/premium/presentation/widgets/premium_lock_dialog.dart';
import 'package:copyclip/src/features/premium/presentation/provider/premium_provider.dart';
import 'package:provider/provider.dart';

import 'timestamp_embed.dart'; // Full color picker

class GlassRichTextEditor extends StatefulWidget {
  final QuillController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final Color editorBackgroundColor;

  const GlassRichTextEditor({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.scrollController,
    required this.editorBackgroundColor,
  });

  @override
  State<GlassRichTextEditor> createState() => _GlassRichTextEditorState();
}

class _GlassRichTextEditorState extends State<GlassRichTextEditor> {
  String? _expandedDropdown;

  int _currentMatchIndex = -1;

  final List<String> _fontFamilies = [
    'Sans Serif',
    'Serif',
    'Monospace',
    'Roboto',
    'Arial',
    'Times New Roman',
    'Courier New',
    'Georgia',
    'Verdana',
    'Helvetica',
  ];

  final List<Map<String, dynamic>> _fontSizes = [
    {'label': 'Small', 'value': 'small'},
    {'label': 'Normal', 'value': null},
    {'label': 'Large', 'value': 'large'},
    {'label': 'Huge', 'value': 'huge'},
    {'label': '10', 'value': '10'},
    {'label': '12', 'value': '12'},
    {'label': '14', 'value': '14'},
    {'label': '16', 'value': '16'},
    {'label': '18', 'value': '18'},
    {'label': '20', 'value': '20'},
    {'label': '24', 'value': '24'},
    {'label': '28', 'value': '28'},
    {'label': '32', 'value': '32'},
    {'label': '36', 'value': '36'},
    {'label': '48', 'value': '48'},
  ];

  final List<Map<String, dynamic>> _lineHeights = [
    {'label': 'Single', 'value': 1.0},
    {'label': 'Tight', 'value': 1.15},
    {'label': 'Normal', 'value': 1.5},
    {'label': 'Relaxed', 'value': 1.75},
    {'label': 'Loose', 'value': 2.0},
  ];

  final List<Map<String, dynamic>> _headings = [
    {'label': 'Normal Text', 'value': 0},
    {'label': 'Heading 1', 'value': 1},
    {'label': 'Heading 2', 'value': 2},
    {'label': 'Heading 3', 'value': 3},
  ];

  bool _showEmojiPicker = false;
  bool _showSearchReplace = false;
  final TextEditingController _findController = TextEditingController();
  final TextEditingController _replaceController = TextEditingController();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
    widget.focusNode.addListener(_onFocusChange);
    _initSpeech();
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ensureCursorVisible();
      });
    }
  }

  void _ensureCursorVisible() {
    if (!mounted || !widget.focusNode.hasFocus) return;

    final selection = widget.controller.selection;
    if (!selection.isCollapsed) return;

    // Wait for keyboard animation to complete
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted || !widget.scrollController.hasClients) return;

      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      if (bottomInset > 100) {
        // Keyboard is visible
        // Scroll to make cursor visible above keyboard
        final currentOffset = widget.scrollController.offset;
        final maxScroll = widget.scrollController.position.maxScrollExtent;

        // Scroll to bottom if needed
        if (currentOffset < maxScroll) {
          widget.scrollController.animateTo(
            maxScroll,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    widget.focusNode.removeListener(_onFocusChange);
    _findController.dispose();
    _replaceController.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  void _toggleDropdown(String dropdown) {
    setState(() {
      _expandedDropdown = _expandedDropdown == dropdown ? null : dropdown;
    });
    if (_expandedDropdown != null) {
      FocusScope.of(context).unfocus();
    }
  }

  void _closeAllDropdowns() {
    setState(() => _expandedDropdown = null);
  }

  void _insertTimestamp() {
    final now = DateTime.now();
    final timeString = DateFormat('HH:mm').format(now);
    final index = widget.controller.selection.baseOffset;
    final length = widget.controller.selection.extentOffset - index;
    widget.controller.replaceText(index, length, timeString, null);
  }

  void _insertDate() {
    final now = DateTime.now();
    final dateString = DateFormat('yyyy-MM-dd').format(now);
    final index = widget.controller.selection.baseOffset;
    final length = widget.controller.selection.extentOffset - index;
    widget.controller.replaceText(index, length, dateString, null);
  }

  void _insertHorizontalLine() {
    final index = widget.controller.selection.baseOffset;
    widget.controller.replaceText(index, 0, '\n───────────────────\n', null);
  }

  void _showWordCount() {
    final text = widget.controller.document.toPlainText();
    final wordCount = text
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    final charCount = text.length;
    final readingTime = (wordCount / 200).ceil();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Document Statistics'),
        content: Text(
          'Words: $wordCount\nCharacters: $charCount\nEstimated Reading Time: $readingTime min',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _selectAll() {
    widget.controller.updateSelection(
      TextSelection(
        baseOffset: 0,
        extentOffset: widget.controller.document.length - 1,
      ),
      ChangeSource.local,
    );
  }

  Future<void> _copy() async {
    final selection = widget.controller.selection;
    if (selection.isCollapsed) {
      // No text selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No text selected to copy'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final selectedText = widget.controller.document.getPlainText(
      selection.start,
      selection.end - selection.start,
    );

    await Clipboard.setData(ClipboardData(text: selectedText));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _paste() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

    if (clipboardData == null ||
        clipboardData.text == null ||
        clipboardData.text!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Clipboard is empty'),
            duration: Duration(seconds: 1),
          ),
        );
      }
      return;
    }

    final index = widget.controller.selection.baseOffset;
    widget.controller.replaceText(index, 0, clipboardData.text!, null);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text pasted from clipboard'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _toggleReadOnly() {
    setState(() => widget.controller.readOnly = !widget.controller.readOnly);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.controller.readOnly ? 'Editor locked' : 'Editor unlocked',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  bool _hasAttribute(Attribute attribute) {
    final style = widget.controller.getSelectionStyle();
    final attr = style.attributes[attribute.key];
    if (attr == null) return false;
    // For attributes with non-null value (like script: 'sub' or 'super'), check value match
    if (attribute.value != null) {
      return attr.value == attribute.value;
    }
    // For boolean-like attributes (bold, italic, etc.), presence means active
    return true;
  }

  String? _getCurrentAttributeValue(String key) {
    final attr = widget.controller.getSelectionStyle().attributes[key];
    return attr?.value?.toString();
  }

  String _getDropdownDisplayText(String dropdownKey) {
    switch (dropdownKey) {
      case 'fontSize':
        final currentSize = _getCurrentAttributeValue('size');
        if (currentSize == null) return 'Normal';
        final size = _fontSizes.firstWhere(
          (s) => s['value']?.toString() == currentSize,
          orElse: () => {
            'label': currentSize ?? 'Normal',
            'value': currentSize,
          },
        );
        return size['label'];
      case 'fontFamily':
        return _getCurrentAttributeValue('font') ?? 'Font';
      case 'heading':
        final currentHeader = _getCurrentAttributeValue('header');
        if (currentHeader == null) return 'Normal';
        final heading = _headings.firstWhere(
          (h) => h['value'].toString() == currentHeader,
          orElse: () => {'label': 'H$currentHeader', 'value': currentHeader},
        );
        return heading['label'];
      case 'lineHeight':
        final currentLineHeight = _getCurrentAttributeValue('line-height');
        if (currentLineHeight == null) return 'Spacing';
        final height = _lineHeights.firstWhere(
          (h) => h['value'].toString() == currentLineHeight,
          orElse: () => {
            'label': currentLineHeight ?? 'Normal',
            'value': currentLineHeight,
          },
        );
        return height['label'];
      default:
        return '';
    }
  }

  bool _isAlignmentActive(Attribute alignment) {
    final style = widget.controller.getSelectionStyle();
    final attr = style.attributes['align'];
    if (attr == null) return alignment.value == 'left'; // default is left
    return attr.value == alignment.value;
  }

  bool _isListActive(Attribute listType) {
    final style = widget.controller.getSelectionStyle();
    final attr = style.attributes['list'];
    if (attr == null) return false;
    return attr.value == listType.value;
  }

  void _toggleAlignment(Attribute alignment) {
    final isActive = _isAlignmentActive(alignment);
    widget.controller.formatSelection(
      isActive ? Attribute.clone(alignment, null) : alignment,
    );
  }

  void _toggleList(Attribute listType) {
    final isActive = _isListActive(listType);
    widget.controller.formatSelection(
      isActive ? Attribute.clone(listType, null) : listType,
    );
  }

  void _toggleFormat(Attribute attribute) {
    final isActive = _hasAttribute(attribute);
    widget.controller.formatSelection(
      isActive ? Attribute.clone(attribute, null) : attribute,
    );
  }

  Future<void> _pickColor(bool isBackground) async {
    final currentStyle = widget.controller.getSelectionStyle();
    final currentHex = isBackground
        ? currentStyle.attributes['background']?.value as String?
        : currentStyle.attributes['color']?.value as String?;

    Color initialColor = isBackground ? Colors.white : Colors.black;

    if (currentHex != null && currentHex.startsWith('#')) {
      try {
        final String hex = currentHex.startsWith('#')
            ? currentHex.substring(1)
            : currentHex;
        initialColor = Color(
          int.parse(hex.length == 6 ? '0xFF$hex' : '0x$hex'),
        );
      } catch (_) {}
    }

    Color selectedColor = initialColor;

    // We use showDialog with the ColorPicker widget directly for total control
    final Color? picked = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isBackground ? 'Background Color' : 'Text Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: initialColor,
              onColorChanged: (Color color) => selectedColor = color,
              width: 40,
              height: 40,
              borderRadius: 4,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 155,
              heading: const Text('Select Color'),
              subheading: const Text('Select Shade'),
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.wheel: true,
              },
            ),
          ),
          actions: <Widget>[
            // 👇 THE CLEAR BUTTON
            TextButton(
              child: const Text('CLEAR', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Return a special "Sentinel" color (fully transparent)
                Navigator.of(context).pop(const Color(0x00000000));
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(selectedColor),
            ),
          ],
        );
      },
    );

    if (!mounted || picked == null) return;

    final attr = isBackground ? Attribute.background : Attribute.color;

    // 👇 LOGIC FOR CLEAR
    if (picked.value == 0x00000000) {
      // This removes the background color entirely
      widget.controller.formatSelection(Attribute.fromKeyValue(attr.key, null));
    } else {
      // This applies the selected hex color
      final int rgb = picked.value & 0xFFFFFF;
      final String hex =
          '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
      widget.controller.formatSelection(Attribute.clone(attr, hex));
    }

    setState(() {});
  }

  void _clearFormat() {
    final List<Attribute<dynamic>> attributesToClear = [
      Attribute.bold,
      Attribute.italic,
      Attribute.underline,
      Attribute.strikeThrough,
      Attribute.subscript,
      Attribute.superscript,
      Attribute.inlineCode,
      Attribute.small,
      Attribute.font,
      Attribute.size,
      Attribute.color,
      Attribute.background,
      Attribute.link,
      Attribute.header,
      Attribute.indent,
      Attribute.align,
      Attribute.direction,
      Attribute.list,
      Attribute.codeBlock,
      Attribute.blockQuote,
      Attribute.lineHeight,
    ];

    for (final attr in attributesToClear) {
      widget.controller.formatSelection(Attribute.clone(attr, null));
    }
  }

  Future<void> _insertLink() async {
    final selection = widget.controller.selection;
    final plainText = widget.controller.document.toPlainText();

    int start = selection.start;
    int end = selection.end;

    // 👇 LOGIC: If selection is just a cursor (collapsed), expand it to the word boundaries
    if (selection.isCollapsed) {
      // Look backwards for space
      while (start > 0 && !RegExp(r'\s').hasMatch(plainText[start - 1])) {
        start--;
      }
      // Look forwards for space
      while (end < plainText.length &&
          !RegExp(r'\s').hasMatch(plainText[end])) {
        end++;
      }
    }

    final selectedText = plainText.substring(start, end);

    final List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        final urlController = TextEditingController(
          text: selectedText.contains('.') ? selectedText : '',
        );
        final textController = TextEditingController(text: selectedText);
        return AlertDialog(
          title: const Text('Insert Link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Display Text'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL (e.g. https://...)',
                ),
                keyboardType: TextInputType.url,
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, [
                textController.text,
                urlController.text,
              ]),
              child: const Text('Insert'),
            ),
          ],
        );
      },
    );

    if (result != null && result[1].isNotEmpty) {
      final display = result[0].isEmpty ? result[1] : result[0];
      final url = result[1];

      // Replace the detected "word" or selection with the link
      widget.controller.replaceText(start, end - start, display, null);
      widget.controller.formatText(
        start,
        display.length,
        Attribute.fromKeyValue('link', url),
      );

      // Move cursor to end
      widget.controller.updateSelection(
        TextSelection.collapsed(offset: start + display.length),
        ChangeSource.local,
      );
    }
  }

  Future<void> _insertFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.first.path!;
      final fileName = result.files.first.name;

      // Get current cursor position
      final index = widget.controller.selection.baseOffset;

      // 1. Insert the text (the filename)
      widget.controller.replaceText(index, 0, fileName, null);

      // 2. Apply the link attribute to the EXACT range of the filename
      // Using formatText is more stable than formatSelection for programmatic links
      widget.controller.formatText(
        index,
        fileName.length,
        Attribute.fromKeyValue('link', 'file://$filePath'),
      );

      // 3. Move cursor to the end of the filename and add a space
      // This "breaks" the link format so the user can continue typing normally
      widget.controller.updateSelection(
        TextSelection.collapsed(offset: index + fileName.length),
        ChangeSource.local,
      );

      // Insert a space to separate the link from next text
      widget.controller.replaceText(index + fileName.length, 0, ' ', null);
      widget.controller.updateSelection(
        TextSelection.collapsed(offset: index + fileName.length + 1),
        ChangeSource.local,
      );
    }
  }

  Future<void> _insertImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final index = widget.controller.selection.baseOffset;
      widget.controller.document.insert(index, BlockEmbed.image(image.path));
      widget.controller.updateSelection(
        TextSelection.collapsed(offset: index + 1),
        ChangeSource.local,
      );
    }
  }

  Future<void> _insertVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final index = widget.controller.selection.baseOffset;
      widget.controller.document.insert(index, BlockEmbed.video(video.path));
      widget.controller.updateSelection(
        TextSelection.collapsed(offset: index + 1),
        ChangeSource.local,
      );
    }
  }

  void _toggleEmojiPicker() =>
      setState(() => _showEmojiPicker = !_showEmojiPicker);

  void _insertEmoji(String emoji) {
    final index = widget.controller.selection.baseOffset;
    final length = widget.controller.selection.extentOffset - index;
    widget.controller.replaceText(index, length, emoji, null);
  }

  void _toggleSearchReplace() =>
      setState(() => _showSearchReplace = !_showSearchReplace);

  List<int> _findAllMatches() {
    final query = _findController.text;
    if (query.isEmpty) return [];

    final plainText = widget.controller.document.toPlainText().toLowerCase();
    final queryLower = query.toLowerCase();

    final List<int> matches = [];
    int index = 0;
    while ((index = plainText.indexOf(queryLower, index)) != -1) {
      matches.add(index);
      index += queryLower.length;
    }
    return matches;
  }

  int _getCurrentMatchIndex(List<int> matches) {
    if (matches.isEmpty) return -1;
    final sel = widget.controller.selection;
    if (sel.isCollapsed) return -1;

    final currentStart = sel.start;
    for (int i = 0; i < matches.length; i++) {
      if (currentStart == matches[i]) {
        _currentMatchIndex = i;
        return i;
      }
    }
    return -1;
  }

  void _updateMatchInfo() {
    setState(() {}); // Trigger rebuild to update match count
  }

  void _findNext() {
    final matches = _findAllMatches();
    if (matches.isEmpty) return;

    final current = _getCurrentMatchIndex(matches);
    final nextIndex = (current + 1) % matches.length;

    final matchStart = matches[nextIndex];
    widget.controller.updateSelection(
      TextSelection(
        baseOffset: matchStart,
        extentOffset: matchStart + _findController.text.length,
      ),
      ChangeSource.local,
    );
    _currentMatchIndex = nextIndex;
  }

  void _findPrevious() {
    final matches = _findAllMatches();
    if (matches.isEmpty) return;

    final current = _getCurrentMatchIndex(matches);
    final prevIndex = current <= 0 ? matches.length - 1 : current - 1;

    final matchStart = matches[prevIndex];
    widget.controller.updateSelection(
      TextSelection(
        baseOffset: matchStart,
        extentOffset: matchStart + _findController.text.length,
      ),
      ChangeSource.local,
    );
    _currentMatchIndex = prevIndex;
  }

  void _replace() {
    final sel = widget.controller.selection;
    if (sel.isCollapsed) return;

    final replaceText = _replaceController.text;

    widget.controller.replaceText(
      sel.start,
      sel.end - sel.start,
      replaceText,
      null,
    );
    _findNext();
  }

  void _replaceAll() {
    final plainText = widget.controller.document.toPlainText();
    final query = _findController.text;
    final replaceText = _replaceController.text;

    if (query.isEmpty) return;

    final newText = plainText.replaceAll(query, replaceText);
    final newDelta = Delta()..insert(newText);

    widget.controller.document = Document.fromDelta(newDelta);
    widget.controller.updateSelection(
      const TextSelection.collapsed(offset: 0),
      ChangeSource.local,
    );
  }

  void _startVoiceTyping() => _speechToText.listen(onResult: _onSpeechResult);

  void _stopVoiceTyping() => _speechToText.stop();

  void _onSpeechResult(SpeechRecognitionResult result) {
    final index = widget.controller.selection.baseOffset;
    widget.controller.replaceText(index, 0, result.recognizedWords, null);
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (ctx) =>
            pw.Center(child: pw.Text(widget.controller.document.toPlainText())),
      ),
    );
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'document.pdf');
  }

  Future<void> _printDocument() async {
    await Printing.layoutPdf(
      onLayout: (_) async {
        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            build: (ctx) => pw.Center(
              child: pw.Text(widget.controller.document.toPlainText()),
            ),
          ),
        );
        return pdf.save();
      },
    );
  }

  void _uppercaseSelection() {
    final sel = widget.controller.selection;
    if (sel.isCollapsed) return;

    final selectedText = widget.controller.document.getPlainText(
      sel.start,
      sel.end - sel.start,
    );
    final upperText = selectedText.toUpperCase();

    widget.controller.replaceText(
      sel.start,
      sel.end - sel.start,
      upperText,
      null,
    );
  }

  void _lowercaseSelection() {
    final sel = widget.controller.selection;
    if (sel.isCollapsed) return;

    final selectedText = widget.controller.document.getPlainText(
      sel.start,
      sel.end - sel.start,
    );
    final lowerText = selectedText.toLowerCase();

    widget.controller.replaceText(
      sel.start,
      sel.end - sel.start,
      lowerText,
      null,
    );
  }

  void _duplicateLine() {
    final sel = widget.controller.selection;
    final plain = widget.controller.document.toPlainText();
    final lineStart = plain.lastIndexOf('\n', sel.baseOffset - 1) + 1;
    final lineEnd = plain.indexOf('\n', sel.baseOffset);
    final lineText = plain.substring(
      lineStart,
      lineEnd == -1 ? plain.length : lineEnd,
    );
    widget.controller.replaceText(
      lineEnd == -1 ? plain.length : lineEnd,
      0,
      '\n$lineText',
      null,
    );
  }

  void _sortLines() {
    final sel = widget.controller.selection;
    if (sel.isCollapsed) return;

    final selectedText = widget.controller.document.getPlainText(
      sel.start,
      sel.end - sel.start,
    );
    final lines = selectedText.split('\n')..sort();
    final sortedText = lines.join('\n');

    widget.controller.replaceText(
      sel.start,
      sel.end - sel.start,
      sortedText,
      null,
    );
  }

  void _insertRandomQuote() {
    const quotes = [
      'The journey of a thousand miles begins with a single step.',
      'To be or not to be, that is the question.',
      'In the middle of difficulty lies opportunity.',
    ];
    final quote = quotes[DateTime.now().millisecond % quotes.length];
    final index = widget.controller.selection.baseOffset;
    widget.controller.replaceText(index, 0, '"$quote"', null);
  }

  void _toggleFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final defaultTextStyle = DefaultTextStyle.of(context);

    final customStyles = DefaultStyles(
      h1: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 34,
          height: 1.083,
          fontWeight: FontWeight.bold,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(16, 0),
        VerticalSpacing.zero,
        null,
      ),
      h2: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 30,
          height: 1.067,
          fontWeight: FontWeight.bold,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(12, 0),
        VerticalSpacing.zero,
        null,
      ),
      h3: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 24,
          height: 1.083,
          fontWeight: FontWeight.bold,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(10, 0),
        VerticalSpacing.zero,
        null,
      ),
      paragraph: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(fontSize: 16, height: 1.5),
        const HorizontalSpacing(0, 0),
        VerticalSpacing.zero,
        VerticalSpacing.zero,
        null,
      ),
      bold: const TextStyle(fontWeight: FontWeight.bold),
      italic: const TextStyle(fontStyle: FontStyle.italic),
      small: const TextStyle(fontSize: 12),
      underline: const TextStyle(decoration: TextDecoration.underline),
      strikeThrough: const TextStyle(decoration: TextDecoration.lineThrough),
      inlineCode: InlineCodeStyle(
        backgroundColor: colorScheme.surfaceContainerHighest,
        radius: const Radius.circular(4),
        style: TextStyle(
          fontSize: 14,
          color: colorScheme.primary,
          fontFamily: 'monospace',
        ),
      ),
      link: TextStyle(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
      placeHolder: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 18,
          height: 1.5,
          color: colorScheme.onSurface.withOpacity(0.4),
        ),
        const HorizontalSpacing(0, 0),
        VerticalSpacing.zero,
        VerticalSpacing.zero,
        null,
      ),
      lists: DefaultListBlockStyle(
        defaultTextStyle.style.copyWith(fontSize: 16, height: 1.5),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(6, 0),
        const VerticalSpacing(0, 6),
        null,
        null,
      ),
      quote: DefaultTextBlockStyle(
        TextStyle(
          color: colorScheme.onSurface.withOpacity(0.7),
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
        const HorizontalSpacing(16, 0),
        const VerticalSpacing(8, 8),
        const VerticalSpacing(6, 2),
        BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 4,
              color: colorScheme.primary.withOpacity(0.3),
            ),
          ),
        ),
      ),
      code: DefaultTextBlockStyle(
        TextStyle(
          color: colorScheme.onSurface,
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.4,
        ),
        const HorizontalSpacing(16, 16),
        const VerticalSpacing(8, 8),
        VerticalSpacing.zero,
        BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    final canUndo = widget.controller.hasUndo;
    final canRedo = widget.controller.hasRedo;

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: QuillEditor(
              controller: widget.controller,
              focusNode: widget.focusNode,
              scrollController: widget.scrollController,
              config: QuillEditorConfig(
                placeholder: "Write here...",
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
                autoFocus: false,
                expands: false,
                scrollable: true,
                scrollPhysics: const BouncingScrollPhysics(),
                enableInteractiveSelection: true,
                showCursor: true,
                // Enable context menu for copy, paste, select all on long press
                contextMenuBuilder: (context, rawEditorState) {
                  return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: rawEditorState.contextMenuAnchors,
                    buttonItems: rawEditorState.contextMenuButtonItems,
                  );
                },
                embedBuilders: [
                  ...FlutterQuillEmbeds.editorBuilders(),
                  TimeStampEmbedBuilder(),
                ],
                customStyles: customStyles,
                onLaunchUrl: (url) async {
                  if (url == null) return;
                  final uri = Uri.tryParse(url);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Horizontal Scrollable Button Row
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  children: [
                    _buildIconButton(
                      icon: Icons.picture_as_pdf,
                      tooltip: 'Export to PDF',
                      isPremiumFeature: true,
                      onPressed: _exportToPdf,
                    ),
                    _buildIconButton(
                      icon: widget.controller.readOnly
                          ? Icons.lock
                          : Icons.lock_open,
                      tooltip: 'Lock/Unlock Editor',
                      onPressed: _toggleReadOnly,
                    ),
                    _buildIconButton(
                      icon: Icons.undo,
                      tooltip: 'Undo',
                      isDisabled: !canUndo,
                      onPressed: canUndo ? widget.controller.undo : null,
                    ),
                    _buildIconButton(
                      icon: Icons.redo,
                      tooltip: 'Redo',
                      isDisabled: !canRedo,
                      onPressed: canRedo ? widget.controller.redo : null,
                    ),
                    _buildIconButton(
                      icon: Icons.copy,
                      tooltip: 'Copy',
                      onPressed: _copy,
                    ),
                    _buildIconButton(
                      icon: Icons.paste,
                      tooltip: 'Paste',
                      onPressed: _paste,
                    ),
                    const SizedBox(width: 4),
                    _buildIconButton(
                      icon: Icons.format_bold,
                      tooltip: 'Bold',
                      isSelected: _hasAttribute(Attribute.bold),
                      onPressed: () => _toggleFormat(Attribute.bold),
                    ),
                    _buildIconButton(
                      icon: Icons.format_italic,
                      tooltip: 'Italic',
                      isSelected: _hasAttribute(Attribute.italic),
                      onPressed: () => _toggleFormat(Attribute.italic),
                    ),
                    _buildIconButton(
                      icon: Icons.format_underlined,
                      tooltip: 'Underline',
                      isSelected: _hasAttribute(Attribute.underline),
                      onPressed: () => _toggleFormat(Attribute.underline),
                    ),
                    _buildIconButton(
                      icon: Icons.strikethrough_s,
                      tooltip: 'Strikethrough',
                      isSelected: _hasAttribute(Attribute.strikeThrough),
                      onPressed: () => _toggleFormat(Attribute.strikeThrough),
                    ),
                    const SizedBox(width: 4),
                    _buildIconButton(
                      icon: Icons.palette,
                      tooltip: 'Text Color',
                      iconColor: () {
                        final style = widget.controller.getSelectionStyle();
                        final hex = style.attributes['color']?.value as String?;
                        if (hex == null || !hex.startsWith('#')) return null;
                        try {
                          return Color(int.parse('0xFF${hex.substring(1)}'));
                        } catch (e) {
                          return null;
                        }
                      }(),
                      onPressed: () => _pickColor(false),
                      isPremiumFeature: true,
                    ),
                    _buildIconButton(
                      icon: Icons.format_color_fill,
                      tooltip: 'Background Color',
                      iconColor: () {
                        final style = widget.controller.getSelectionStyle();
                        final hex =
                            style.attributes['background']?.value as String?;
                        if (hex == null || !hex.startsWith('#')) return null;
                        try {
                          return Color(int.parse('0xFF${hex.substring(1)}'));
                        } catch (e) {
                          return null;
                        }
                      }(),
                      onPressed: () => _pickColor(true),
                      isPremiumFeature: true,
                    ),
                    const SizedBox(width: 4),

                    const SizedBox(width: 4),
                    _buildDropdownButton(
                      title: _getDropdownDisplayText('fontSize'),
                      icon: Icons.format_size,
                      dropdownKey: 'fontSize',
                    ),
                    const SizedBox(width: 4),
                    _buildDropdownButton(
                      title: _getDropdownDisplayText('fontFamily'),
                      icon: Icons.font_download,
                      dropdownKey: 'fontFamily',
                    ),
                    const SizedBox(width: 4),
                    _buildDropdownButton(
                      title: _getDropdownDisplayText('heading'),
                      icon: Icons.title,
                      dropdownKey: 'heading',
                    ),
                    const SizedBox(width: 4),
                    _buildDropdownButton(
                      title: _getDropdownDisplayText('lineHeight'),
                      icon: Icons.format_line_spacing,
                      dropdownKey: 'lineHeight',
                    ),
                    const SizedBox(width: 12),

                    _buildIconButton(
                      icon: Icons.format_align_left,
                      tooltip: 'Align Left',
                      isSelected: _isAlignmentActive(Attribute.leftAlignment),
                      onPressed: () =>
                          _toggleAlignment(Attribute.leftAlignment),
                    ),
                    _buildIconButton(
                      icon: Icons.format_align_center,
                      tooltip: 'Align Center',
                      isSelected: _isAlignmentActive(Attribute.centerAlignment),
                      onPressed: () =>
                          _toggleAlignment(Attribute.centerAlignment),
                    ),
                    _buildIconButton(
                      icon: Icons.format_align_right,
                      tooltip: 'Align Right',
                      isSelected: _isAlignmentActive(Attribute.rightAlignment),
                      onPressed: () =>
                          _toggleAlignment(Attribute.rightAlignment),
                    ),
                    _buildIconButton(
                      icon: Icons.format_align_justify,
                      tooltip: 'Align Justify',
                      isSelected: _isAlignmentActive(
                        Attribute.justifyAlignment,
                      ),
                      onPressed: () =>
                          _toggleAlignment(Attribute.justifyAlignment),
                    ),
                    _buildDivider(),
                    _buildIconButton(
                      icon: Icons.format_list_numbered,
                      tooltip: 'Numbered List',
                      isSelected: _isListActive(Attribute.ol),
                      onPressed: () => _toggleList(Attribute.ol),
                    ),
                    _buildIconButton(
                      icon: Icons.format_list_bulleted,
                      tooltip: 'Bulleted List',
                      isSelected: _isListActive(Attribute.ul),
                      onPressed: () => _toggleList(Attribute.ul),
                    ),
                    _buildIconButton(
                      icon: Icons.checklist,
                      tooltip: 'Checklist',
                      isSelected: _isListActive(Attribute.unchecked),
                      onPressed: () => _toggleList(Attribute.unchecked),
                    ),
                    const SizedBox(width: 12),
                    _buildDivider(),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.subscript,
                      tooltip: 'Subscript',
                      isSelected: _hasAttribute(Attribute.subscript),
                      onPressed: () => _toggleFormat(Attribute.subscript),
                    ),
                    _buildIconButton(
                      icon: Icons.superscript,
                      tooltip: 'Superscript',
                      isSelected: _hasAttribute(Attribute.superscript),
                      onPressed: () => _toggleFormat(Attribute.superscript),
                    ),
                    _buildIconButton(
                      icon: Icons.code,
                      tooltip: 'Inline Code',
                      isSelected: _hasAttribute(Attribute.inlineCode),
                      onPressed: () => _toggleFormat(Attribute.inlineCode),
                    ),
                    _buildIconButton(
                      icon: Icons.format_size,
                      tooltip: 'Small Text',
                      isSelected: _hasAttribute(Attribute.small),
                      onPressed: () => _toggleFormat(Attribute.small),
                    ),
                    const SizedBox(width: 4),
                    _buildDivider(),
                    const SizedBox(width: 4),
                    _buildIconButton(
                      icon: Icons.format_clear,
                      tooltip: 'Clear Format',
                      onPressed: _clearFormat,
                    ),
                    const SizedBox(width: 4),
                    _buildDivider(),
                    const SizedBox(width: 4),
                    _buildIconButton(
                      icon: Icons.format_indent_increase,
                      tooltip: 'Increase Indent',
                      onPressed: () => widget.controller.indentSelection(true),
                    ),
                    _buildIconButton(
                      icon: Icons.format_indent_decrease,
                      tooltip: 'Decrease Indent',
                      onPressed: () => widget.controller.indentSelection(false),
                    ),
                    const SizedBox(width: 4),
                    _buildDivider(),
                    const SizedBox(width: 4),
                    _buildIconButton(
                      icon: Icons.code,
                      tooltip: 'Code Block',
                      isSelected: _hasAttribute(Attribute.codeBlock),
                      onPressed: () => _toggleFormat(Attribute.codeBlock),
                    ),
                    _buildIconButton(
                      icon: Icons.format_quote,
                      tooltip: 'Block Quote',
                      isSelected: _hasAttribute(Attribute.blockQuote),
                      onPressed: () => _toggleFormat(Attribute.blockQuote),
                    ),
                    const SizedBox(width: 4),
                    _buildDivider(),
                    const SizedBox(width: 4),
                    _buildIconButton(
                      icon: Icons.link,
                      tooltip: 'Insert Link',
                      isPremiumFeature: true,
                      onPressed: _insertLink,
                    ),
                    _buildIconButton(
                      icon: Icons.image,
                      tooltip: 'Insert Image',
                      isPremiumFeature: true,
                      onPressed: _insertImage,
                    ),
                    _buildIconButton(
                      icon: Icons.videocam,
                      tooltip: 'Insert Video',
                      isPremiumFeature: true,
                      onPressed: _insertVideo,
                    ),

                    // _buildIconButton(icon: Icons.attach_file, tooltip: 'Insert File', onPressed: _insertFile),
                    _buildDivider(),

                    _buildIconButton(
                      icon: Icons.access_time,
                      tooltip: 'Insert Time',
                      onPressed: _insertTimestamp,
                    ),
                    _buildIconButton(
                      icon: Icons.calendar_today,
                      tooltip: 'Insert Date',
                      onPressed: _insertDate,
                    ),
                    _buildIconButton(
                      icon: Icons.horizontal_rule,
                      tooltip: 'Horizontal Line',
                      onPressed: _insertHorizontalLine,
                    ),
                    _buildIconButton(
                      icon: Icons.analytics,
                      tooltip: 'Word Count',
                      isPremiumFeature: true,
                      onPressed: _showWordCount,
                    ),
                    _buildIconButton(
                      icon: Icons.select_all,
                      tooltip: 'Select All',
                      onPressed: _selectAll,
                    ),
                    _buildIconButton(
                      icon: Icons.search,
                      tooltip: 'Search & Replace',
                      isPremiumFeature: true,
                      onPressed: _toggleSearchReplace,
                    ),
                    _buildIconButton(
                      icon: Icons.emoji_emotions,
                      tooltip: 'Emoji Picker',
                      isPremiumFeature: true,
                      onPressed: _toggleEmojiPicker,
                    ),
                    _buildIconButton(
                      icon: Icons.arrow_upward,
                      tooltip: 'Uppercase Selection',
                      isPremiumFeature: true,
                      isSelected: () {
                        final sel = widget.controller.selection;
                        if (sel.isCollapsed || sel.start >= sel.end)
                          return false;
                        final selectedText = widget.controller.document
                            .getPlainText(sel.start, sel.end - sel.start);
                        if (selectedText.isEmpty) return false;
                        final lettersOnly = selectedText.replaceAll(
                          RegExp(r'[^a-zA-Z]'),
                          '',
                        );
                        if (lettersOnly.isEmpty) return false;
                        return lettersOnly == lettersOnly.toUpperCase();
                      }(),
                      onPressed: _uppercaseSelection,
                    ),
                    _buildIconButton(
                      icon: Icons.arrow_downward,
                      tooltip: 'Lowercase Selection',
                      isPremiumFeature: true,
                      isSelected: () {
                        final sel = widget.controller.selection;
                        if (sel.isCollapsed || sel.start >= sel.end)
                          return false;
                        final selectedText = widget.controller.document
                            .getPlainText(sel.start, sel.end - sel.start);
                        if (selectedText.isEmpty) return false;
                        final lettersOnly = selectedText.replaceAll(
                          RegExp(r'[^a-zA-Z]'),
                          '',
                        );
                        if (lettersOnly.isEmpty) return false;
                        return lettersOnly == lettersOnly.toLowerCase();
                      }(),
                      onPressed: _lowercaseSelection,
                    ),
                    _buildIconButton(
                      icon: Icons.control_point_duplicate_rounded,
                      tooltip: 'Duplicate Line',
                      isPremiumFeature: true,
                      onPressed: _duplicateLine,
                    ),
                    _buildIconButton(
                      icon: Icons.format_quote,
                      tooltip: 'Insert Random Quote',
                      isPremiumFeature: true,
                      onPressed: _insertRandomQuote,
                    ),
                    _buildIconButton(
                      icon: Icons.print,
                      tooltip: 'Print Document',
                      isPremiumFeature: true,
                      onPressed: _printDocument,
                    ),
                  ],
                ),
              ),

              // Expanded Dropdown Content
              if (_expandedDropdown != null)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: _buildDropdownContent(_expandedDropdown!),
                ),

              // Emoji Picker
              if (_showEmojiPicker)
                SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (cat, emoji) => _insertEmoji(emoji.emoji),
                  ),
                ),

              // Search & Replace Panel (full unchanged implementation)
              if (_showSearchReplace)
                Container(
                  constraints: const BoxConstraints(maxHeight: 220),
                  padding: const EdgeInsets.all(16),
                  color: colorScheme.surface,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 6),
                        TextField(
                          controller: _findController,
                          decoration: const InputDecoration(
                            labelText: 'Find',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => _updateMatchInfo(),
                          onSubmitted: (_) => _findNext(),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _replaceController,
                          decoration: const InputDecoration(
                            labelText: 'Replace with',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _replace(),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _findController,
                          builder: (context, value, child) {
                            final matches = _findAllMatches();
                            final currentIndex = _getCurrentMatchIndex(matches);
                            final matchText = matches.isEmpty
                                ? 'No matches'
                                : 'Match ${currentIndex + 1} of ${matches.length}';

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  matchText,
                                  style: TextStyle(
                                    color: matches.isEmpty
                                        ? Colors.grey
                                        : colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_upward),
                                      tooltip: 'Previous Match',
                                      onPressed: matches.isEmpty
                                          ? null
                                          : _findPrevious,
                                      color: colorScheme.primary,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_downward),
                                      tooltip: 'Next Match',
                                      onPressed: matches.isEmpty
                                          ? null
                                          : _findNext,
                                      color: colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _replace,
                              child: const Text('Replace'),
                            ),
                            ElevatedButton(
                              onPressed: _replaceAll,
                              child: const Text('Replace All'),
                            ),
                            OutlinedButton(
                              onPressed: _toggleSearchReplace,
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _buildDivider() => Container(
    width: 1,
    height: 24,
    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
  );

  Widget _buildDropdownButton({
    required String title,
    required IconData icon,
    required String dropdownKey,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isExpanded = _expandedDropdown == dropdownKey;
    return InkWell(
      onTap: () => _toggleDropdown(dropdownKey),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isExpanded
              ? colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isExpanded
                ? colorScheme.primary.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isExpanded ? colorScheme.primary : colorScheme.onSurface,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isExpanded ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: 16,
              color: isExpanded ? colorScheme.primary : colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownContent(String key) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (key) {
      case 'fontSize':
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _fontSizes.length,
          itemBuilder: (_, i) {
            final item = _fontSizes[i];
            final value = item['value']?.toString();
            final selected =
                (_getCurrentAttributeValue('size') == value) ||
                (value == null && _getCurrentAttributeValue('size') == null);
            return InkWell(
              onTap: () {
                widget.controller.formatSelection(
                  value == null
                      ? Attribute.clone(Attribute.size, null)
                      : Attribute.fromKeyValue('size', value),
                );
                _closeAllDropdowns();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (selected)
                      Icon(Icons.check, size: 18, color: colorScheme.primary),
                    if (selected) const SizedBox(width: 8),
                    Text(
                      item['label'],
                      style: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      case 'fontFamily':
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _fontFamilies.length,
          itemBuilder: (_, i) {
            final font = _fontFamilies[i];
            final selected = _getCurrentAttributeValue('font') == font;
            return InkWell(
              onTap: () {
                widget.controller.formatSelection(
                  Attribute.fromKeyValue('font', font),
                );
                _closeAllDropdowns();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (selected)
                      Icon(Icons.check, size: 18, color: colorScheme.primary),
                    if (selected) const SizedBox(width: 8),
                    Text(
                      font,
                      style: TextStyle(
                        fontFamily: font,
                        fontSize: 14,
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      case 'heading':
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _headings.length,
          itemBuilder: (_, i) {
            final item = _headings[i];
            final value = item['value'] as int;
            final currentHeader = _getCurrentAttributeValue('header');
            final selected =
                (currentHeader == null && value == 0) ||
                currentHeader == value.toString();

            return InkWell(
              onTap: () {
                if (value == 0) {
                  // Remove header
                  widget.controller.formatSelection(Attribute.header);
                } else {
                  // Apply specific header level
                  widget.controller.formatSelection(
                    Attribute.fromKeyValue('header', value),
                  );
                }
                _closeAllDropdowns();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (selected)
                      Icon(Icons.check, size: 18, color: colorScheme.primary),
                    if (selected) const SizedBox(width: 8),
                    Text(
                      item['label'],
                      style: TextStyle(
                        fontSize: value == 0 ? 14 : 22 - value * 3,
                        fontWeight: value == 0
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      case 'lineHeight':
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _lineHeights.length,
          itemBuilder: (_, i) {
            final item = _lineHeights[i];
            final value = item['value'];
            final selected =
                _getCurrentAttributeValue('line-height') == value.toString();
            return InkWell(
              onTap: () {
                widget.controller.formatSelection(
                  Attribute.fromKeyValue('line-height', value),
                );
                _closeAllDropdowns();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (selected)
                      Icon(Icons.check, size: 18, color: colorScheme.primary),
                    if (selected) const SizedBox(width: 8),
                    Text(
                      item['label'],
                      style: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    VoidCallback? onPressed,
    bool isSelected = false,
    bool isDisabled = false,
    Color? iconColor, // Optional custom icon color
    bool isPremiumFeature = false, // ✅ NEW: Lock support
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<PremiumProvider>(
      builder: (context, premiumProvider, _) {
        final isLocked = isPremiumFeature && !premiumProvider.isPremium;

        // Determine final icon color
        final Color effectiveIconColor = isDisabled
            ? colorScheme.onSurface.withOpacity(0.3)
            : (iconColor ?? // Use custom color if provided
                  (isSelected
                      ? colorScheme.primary
                      : isLocked
                      ? colorScheme.onSurface.withOpacity(0.4)
                      : colorScheme.onSurface.withOpacity(0.7)));

        return Tooltip(
          message: isLocked ? "$tooltip (Premium)" : tooltip,
          child: InkWell(
            onTap: isDisabled
                ? null
                : () {
                    if (isLocked) {
                      PremiumLockDialog.show(
                        context,
                        featureName: tooltip,
                        onUnlockOnce: onPressed,
                      );
                    } else {
                      onPressed?.call();
                    }
                  },
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary.withOpacity(0.4)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, size: 18, color: effectiveIconColor),
                ),
                // ✅ Show Tiny Lock Badget
                if (isLocked)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.lock, size: 10, color: Colors.amber),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
