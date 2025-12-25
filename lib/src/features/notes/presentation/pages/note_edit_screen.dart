import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_rich_text_editor.dart';
import '../../data/note_model.dart';
import '../../../../core/app_content_palette.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  final _titleController = TextEditingController();
  late QuillController _quillController;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  DateTime _selectedDate = DateTime.now();
  late DateTime _initialDate;
  late Box<Note> _notesBox;

  Color _scaffoldColor = AppContentPalette.palette.first;
  late Color _initialColor;

  String _initialTitle = "";
  String _initialContentJson = "";

  @override
  void initState() {
    super.initState();
    _notesBox = Hive.box<Note>('notes_box');

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _selectedDate = widget.note!.updatedAt;
      _scaffoldColor = widget.note!.colorValue != null
          ? Color(widget.note!.colorValue!)
          : AppContentPalette.palette.first;
    }

    _initialTitle = _titleController.text;
    _initialDate = _selectedDate;
    _initialColor = _scaffoldColor;

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
    super.dispose();
  }

  void _initQuill() {
    Document doc;
    try {
      if (widget.note != null && widget.note!.content.isNotEmpty) {
        doc = Document.fromJson(jsonDecode(widget.note!.content));
      } else {
        doc = Document();
      }
    } catch (e) {
      doc = Document()..insert(0, widget.note?.content ?? "");
    }
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    _initialContentJson = jsonEncode(_quillController.document.toDelta().toJson());
  }

  String _getCleanPlainText() {
    return _quillController.document.toPlainText().trim();
  }

  void _pickDateTime() {
    FocusScope.of(context).unfocus();
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 6.0),
          color: surfaceColor,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Done',
                    style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(color: onSurfaceColor, fontSize: 20),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: _selectedDate,
                    onDateTimeChanged: (val) => setState(() => _selectedDate = val),
                    use24hFormat: false,
                    minuteInterval: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final contentJson = jsonEncode(_quillController.document.toDelta().toJson());

    if (widget.note != null) {
      widget.note!.title = title;
      widget.note!.content = contentJson;
      widget.note!.updatedAt = _selectedDate;
      widget.note!.colorValue = _scaffoldColor.value;
      widget.note!.save();
    } else {
      final newNote = Note(
        id: const Uuid().v4(),
        title: title,
        content: contentJson,
        updatedAt: _selectedDate,
        colorValue: _scaffoldColor.value,
      );
      _notesBox.put(newNote.id, newNote);
    }
    _initialTitle = title;
    _initialContentJson = contentJson;
    _initialColor = _scaffoldColor;
    _initialDate = _selectedDate;
  }

  void _showColorPicker() {
    final List<Color> palette = AppContentPalette.palette;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => GlassDialog(
          title: "Note Theme",
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

      if (text.contains('\n')) {
        final parts = text.split('\n');

        for (int i = 0; i < parts.length; i++) {
          if (parts[i].isNotEmpty) {
            currentLineSpans.add(pw.TextSpan(text: parts[i], style: style));
          }

          if (i < parts.length - 1) {
            if (currentLineSpans.isNotEmpty) {
              widgets.add(
                pw.RichText(
                  text: pw.TextSpan(children: currentLineSpans),
                ),
              );
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

    final pdfWidgets = await _buildPdfWidgetsFromDelta(delta);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.openSansRegular(),
            bold: await PdfGoogleFonts.openSansBold(),
            italic: await PdfGoogleFonts.openSansItalic(),
          ),
        ),
        build: (context) => pdfWidgets,
      ),
    );

    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/content_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Exported Content',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isColorDark = ThemeData.estimateBrightnessForColor(_scaffoldColor) == Brightness.dark;
    final contrastColor = isColorDark ? Colors.white : Colors.black87;

    final String heroTag = widget.note != null
        ? 'note_background_${widget.note!.id}'
        : 'new_note_hero';

    return WillPopScope(
      onWillPop: () async {
        final currentJson = jsonEncode(_quillController.document.toDelta().toJson());
        bool hasChanges = _titleController.text != _initialTitle ||
            currentJson != _initialContentJson ||
            _scaffoldColor.value != _initialColor.value ||
            _selectedDate != _initialDate;

        if (!hasChanges) return true;

        final result = await showDialog<String>(
          context: context,
          builder: (ctx) => GlassDialog(
            title: "Unsaved Changes",
            content: "Save your note?",
            confirmText: "Save",
            cancelText: "Discard",
            onConfirm: () => Navigator.pop(ctx, 'save'),
            onCancel: () => Navigator.pop(ctx, 'discard'),
          ),
        );
        if (result == 'save') { _saveNote(); return true; }
        return result == 'discard';
      },
      child: GlassScaffold(
        showBackArrow: true,
        backgroundColor: _scaffoldColor,
        title: widget.note == null ? 'New Note' : 'Edit Note',
        actions: [
          GestureDetector(
            onTap: _showColorPicker,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: _scaffoldColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: contrastColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Icon(Icons.palette_outlined, size: 14, color: contrastColor.withOpacity(0.7)),
            ),
          ),

          IconButton(
            icon: Icon(Icons.copy, size: 18, color: contrastColor),
            onPressed: () {
              final cleanText = _getCleanPlainText();
              if (cleanText.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: cleanText));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Content copied"),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: contrastColor,
                  ),
                );
              }
            },
          ),

          PopupMenuButton<String>(
            icon: Icon(Icons.ios_share, size: 20, color: contrastColor),
            onSelected: (val) { if (val == 'pdf') _exportToPdf(); },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'pdf', child: Text("Export as PDF")),
            ],
          ),

          IconButton(
            icon: Icon(Icons.check, color: contrastColor),
            onPressed: () {
              _saveNote();
              context.pop();
            },
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
                    painter: CanvasGridPainter(color: contrastColor.withOpacity(0.08)),
                  ),
                ),
                RepaintBoundary(
                  key: _boundaryKey,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const SizedBox(height: 0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: TextField(
                            controller: _titleController,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: contrastColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Title (Optional)',
                              border: InputBorder.none,
                              isDense: true,
                              hintStyle: TextStyle(color: contrastColor.withOpacity(0.3)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: _pickDateTime,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: contrastColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  DateFormat('MMM dd, yyyy  •  hh:mm a').format(_selectedDate),
                                  style: TextStyle(
                                      color: contrastColor.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11
                                  ),
                                ),
                              ),
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