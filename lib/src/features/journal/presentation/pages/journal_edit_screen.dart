import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_rich_text_editor.dart';
import '../../../clipboard/presentation/pages/clipboard_edit_screen.dart';
import '../../data/journal_model.dart';
import '../../../../core/app_content_palette.dart';

class JournalEditScreen extends StatefulWidget {
  final JournalEntry? entry;
  const JournalEditScreen({super.key, this.entry});

  @override
  State<JournalEditScreen> createState() => _JournalEditScreenState();
}

class _JournalEditScreenState extends State<JournalEditScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  late QuillController _quillController;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  DateTime _selectedDate = DateTime.now();
  late DateTime _initialDate;
  String _selectedMood = 'Neutral';
  bool _isFavorite = false;

  Color _scaffoldColor = AppContentPalette.palette.first;
  late Color _initialColor;
  String _initialTitle = "";
  String _initialContentJson = "";
  String _initialMood = "";

  final Map<String, String> _moodMap = {
    'Happy': '😊', 'Excited': '🤩', 'Neutral': '😐',
    'Sad': '😔', 'Stressed': '😫', 'Angry': '😡',
    'Cool': '😎', 'Love': '😍',
  };

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _tagsController.text = widget.entry!.tags.join(', ');
      _selectedDate = widget.entry!.date;
      _selectedMood = widget.entry!.mood;
      _isFavorite = widget.entry!.isFavorite;
      _scaffoldColor = widget.entry!.colorValue != null ? Color(widget.entry!.colorValue!) : AppContentPalette.palette.first;
    }

    _initialTitle = _titleController.text;
    _initialDate = _selectedDate;
    _initialColor = _scaffoldColor;
    _initialMood = _selectedMood;
    _initQuill();

    // ✅ Add focus listener for keyboard handling
    _editorFocusNode.addListener(_onFocusChanged);
  }

  // ✅ Handle focus changes and ensure cursor visibility
  void _onFocusChanged() {
    if (_editorFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _editorScrollController.hasClients) {
          _editorScrollController.animateTo(
            _editorScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _editorFocusNode.removeListener(_onFocusChanged);
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    _quillController.dispose();
    _titleController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _initQuill() {
    Document doc;
    try {
      if (widget.entry != null && widget.entry!.content.isNotEmpty) {
        doc = Document.fromJson(jsonDecode(widget.entry!.content));
      } else {
        doc = Document();
      }
    } catch (e) {
      doc = Document()..insert(0, widget.entry?.content ?? "");
    }
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    _initialContentJson = jsonEncode(_quillController.document.toDelta().toJson());
  }

  void _pickDateTime() {
    _editorFocusNode.unfocus();
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Done", style: TextStyle(fontWeight: FontWeight.bold))
              ),
            ),
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(brightness: Theme.of(context).brightness),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (val) => setState(() => _selectedDate = val),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoodPicker() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => GlassDialog(
          title: "Update Mood",
          confirmText: "Select",
          content: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _moodMap.entries.map((entry) {
              final isSelected = _selectedMood == entry.key;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedMood = entry.key);
                  setDialogState(() {});
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2),
                  ),
                  child: Text(entry.value, style: const TextStyle(fontSize: 28)),
                ),
              );
            }).toList(),
          ),
          onConfirm: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showColorPicker() {
    final List<Color> palette = AppContentPalette.palette;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => GlassDialog(
          title: "Entry Theme",
          confirmText: "Save",
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 12, runSpacing: 12,
                  children: palette.map((color) {
                    final isSelected = _scaffoldColor.value == color.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _scaffoldColor = color);
                        setDialogState(() {});
                      },
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle,
                          border: Border.all(color: isSelected ? Colors.white : Colors.white24, width: isSelected ? 3 : 1.5),
                        ),
                        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ColorPicker(
                      pickerColor: _scaffoldColor,
                      onColorChanged: (color) {
                        setState(() => _scaffoldColor = color);
                        setDialogState(() {});
                      },
                      pickerAreaHeightPercent: 0.4,
                      enableAlpha: false,
                      labelTypes: const [],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onConfirm: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Future<List<pw.Widget>> _buildPdfWidgetsFromDelta(Delta delta) async {
    final List<pw.Widget> widgets = [];
    List<pw.InlineSpan> currentLineSpans = [];

    for (final Operation op in delta.operations) {
      if (op.data == null) continue;

      final dynamic insert = op.data;
      if (insert is! String) continue;

      final String text = insert;
      final attributes = op.attributes ?? {};

      pw.TextStyle style = const pw.TextStyle(fontSize: 16);
      if (attributes['bold'] == true) style = style.copyWith(fontWeight: pw.FontWeight.bold);
      if (attributes['italic'] == true) style = style.copyWith(fontStyle: pw.FontStyle.italic);
      if (attributes['underline'] == true) style = style.copyWith(decoration: pw.TextDecoration.underline);

      if (attributes['header'] != null) {
        final int level = attributes['header'] as int;
        if (level == 1) style = style.copyWith(fontSize: 28, fontWeight: pw.FontWeight.bold);
        else if (level == 2) style = style.copyWith(fontSize: 24, fontWeight: pw.FontWeight.bold);
        else if (level == 3) style = style.copyWith(fontSize: 20, fontWeight: pw.FontWeight.bold);
      }

      if (text.contains('\n')) {
        final parts = text.split('\n');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].isNotEmpty) {
            currentLineSpans.add(pw.TextSpan(text: parts[i], style: style));
          }

          if (i < parts.length - 1) {
            if (currentLineSpans.isNotEmpty) {
              widgets.add(pw.RichText(
                text: pw.TextSpan(children: currentLineSpans),
              ));
              currentLineSpans = [];
            }
            widgets.add(pw.SizedBox(height: 12));
          }
        }
      } else {
        currentLineSpans.add(pw.TextSpan(text: text, style: style));
      }
    }

    if (currentLineSpans.isNotEmpty) {
      widgets.add(pw.RichText(text: pw.TextSpan(children: currentLineSpans)));
    }

    return widgets;
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();
    final delta = _quillController.document.toDelta();
    final title = _titleController.text.trim().isEmpty ? 'Untitled Entry' : _titleController.text.trim();

    final moodEmoji = _moodMap[_selectedMood] ?? '';
    final tags = _tagsController.text.trim();

    final pdfWidgets = await _buildPdfWidgetsFromDelta(delta);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.openSansRegular(),
            bold: await PdfGoogleFonts.openSansBold(),
            italic: await PdfGoogleFonts.openSansItalic(),
            boldItalic: await PdfGoogleFonts.openSansBoldItalic(),
          ),
        ),
        header: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(title, style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Text(moodEmoji, style: const pw.TextStyle(fontSize: 30)),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                DateFormat('MMMM dd, yyyy • hh:mm a').format(_selectedDate),
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
              ),
              if (tags.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Text(tags, style: const pw.TextStyle(fontSize: 12, color: PdfColors.blue700)),
              ],
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 1),
            ],
          ),
        ),
        build: (context) => pdfWidgets,
      ),
    );

    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/journal_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], subject: title);
  }

  void _saveEntry() {
    final title = _titleController.text.trim();
    final contentJson = jsonEncode(_quillController.document.toDelta().toJson());
    final tags = _tagsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    final box = Hive.box<JournalEntry>('journal_box');
    if (widget.entry != null) {
      widget.entry!.title = title;
      widget.entry!.content = contentJson;
      widget.entry!.date = _selectedDate;
      widget.entry!.mood = _selectedMood;
      widget.entry!.tags = tags;
      widget.entry!.isFavorite = _isFavorite;
      widget.entry!.colorValue = _scaffoldColor.value;
      widget.entry!.save();
    } else {
      box.add(JournalEntry(
        id: const Uuid().v4(), title: title, content: contentJson,
        date: _selectedDate, mood: _selectedMood, tags: tags,
        isFavorite: _isFavorite, colorValue: _scaffoldColor.value,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isColorDark = ThemeData.estimateBrightnessForColor(_scaffoldColor) == Brightness.dark;
    final contrastColor = isColorDark ? Colors.white : Colors.black87;

    final String heroTag = widget.entry != null
        ? 'journal_bg_${widget.entry!.id}'
        : 'journal_new_hero';

    return WillPopScope(
      onWillPop: () async {
        final currentJson = jsonEncode(_quillController.document.toDelta().toJson());
        bool hasChanges = _titleController.text != _initialTitle ||
            currentJson != _initialContentJson ||
            _selectedDate != _initialDate ||
            _selectedMood != _initialMood ||
            _scaffoldColor.value != _initialColor.value;

        if (!hasChanges) return true;
        final result = await showDialog<String>(
          context: context, builder: (ctx) => GlassDialog(
          title: "Unsaved Changes", content: "Save your journal entry?",
          confirmText: "Save", cancelText: "Discard",
          onConfirm: () => Navigator.pop(ctx, 'save'),
          onCancel: () => Navigator.pop(ctx, 'discard'),
        ),
        );
        if (result == 'save') { _saveEntry(); return true; }
        return result == 'discard';
      },
      child: GlassScaffold(
        showBackArrow: true,
        backgroundColor: _scaffoldColor,
        title: widget.entry == null ? 'New Entry' : 'Edit Entry',
        actions: [
          GestureDetector(
            onTap: _showColorPicker,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: _scaffoldColor, shape: BoxShape.circle,
                border: Border.all(color: contrastColor.withOpacity(0.4), width: 1.5),
              ),
              child: Icon(Icons.palette_outlined, size: 14, color: contrastColor.withOpacity(0.6)),
            ),
          ),
          IconButton(
            icon: Icon(
                _isFavorite ? Icons.star : Icons.star_border,
                color: _isFavorite ? Colors.amberAccent : contrastColor.withOpacity(0.5)
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.ios_share, size: 20, color: contrastColor),
            onSelected: (val) {
              if (val == 'pdf') _exportToPdf();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'pdf', child: Text("Export as PDF")),
            ],
          ),
          IconButton(
              icon: Icon(Icons.check, color: contrastColor),
              onPressed: () { _saveEntry(); context.pop(); }
          ),
        ],
        body: Hero(
          tag: heroTag,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Positioned.fill(
                    child: CustomPaint(
                        painter: CanvasGridPainter(color: contrastColor.withOpacity(0.08))
                    )
                ),
                RepaintBoundary(
                  key: _boundaryKey,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: _pickDateTime,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: contrastColor.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month, size: 14, color: contrastColor.withOpacity(0.7)),
                                      const SizedBox(width: 8),
                                      Text(
                                          DateFormat('MMM dd, yyyy  •  hh:mm a').format(_selectedDate),
                                          style: TextStyle(color: contrastColor, fontWeight: FontWeight.bold, fontSize: 12)
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _showMoodPicker,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: contrastColor.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: contrastColor.withOpacity(0.1))
                                  ),
                                  child: Text(_moodMap[_selectedMood]!, style: const TextStyle(fontSize: 22)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: TextField(
                            controller: _titleController,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: contrastColor,
                                letterSpacing: -0.5
                            ),
                            decoration: InputDecoration(
                                hintText: 'Entry Title',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: contrastColor.withOpacity(0.25))
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextField(
                            controller: _tagsController,
                            style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500
                            ),
                            decoration: InputDecoration(
                              hintText: '#journal #thoughts',
                              border: InputBorder.none,
                              isDense: true,
                              hintStyle: TextStyle(color: contrastColor.withOpacity(0.15)),
                              prefixIcon: Icon(
                                  Icons.local_offer_outlined,
                                  size: 14,
                                  color: theme.colorScheme.primary.withOpacity(0.6)
                              ),
                              prefixIconConstraints: const BoxConstraints(minWidth: 24, maxHeight: 20),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GlassRichTextEditor(
                            controller: _quillController,
                            focusNode: _editorFocusNode,
                            scrollController: _editorScrollController,
                            editorBackgroundColor: _scaffoldColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CanvasGridPainter extends CustomPainter {
  final Color color;
  CanvasGridPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 0.5;
    for (double i = 0; i < size.width; i += 30) { canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint); }
    for (double i = 0; i < size.height; i += 30) { canvas.drawLine(Offset(0, i), Offset(size.width, i), paint); }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}