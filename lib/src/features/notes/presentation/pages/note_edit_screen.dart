import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_rich_text_editor.dart';
import '../../data/note_model.dart';

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

  Color _scaffoldColor = Colors.white;
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
          : Colors.white;
    }

    _initialTitle = _titleController.text;
    _initialDate = _selectedDate;
    _initialColor = _scaffoldColor;

    _initQuill();
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

  // Extracts ONLY the text from the Quill editor (ignores images/JSON/obj)
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
    final title = _titleController.text.trim(); // Can be empty
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
    final List<Color> palette = [
      const Color(0xFFFFFFFF), const Color(0xFFFFCC00),
      const Color(0xFFFD7971), const Color(0xFF007AFF),
      const Color(0xFF34C759), const Color(0xFFAF52DE),
    ];

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

  Future<void> _exportToImage() async {
    try {
      RenderRepaintBoundary? boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/note_${DateTime.now().millisecond}.png');
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColorDark = ThemeData.estimateBrightnessForColor(_scaffoldColor) == Brightness.dark;

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
                color: _scaffoldColor, shape: BoxShape.circle,
                border: Border.all(color: isColorDark ? Colors.white54 : Colors.black26),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: () {
              final cleanText = _getCleanPlainText();
              if (cleanText.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: cleanText));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Content copied (Title excluded)"), behavior: SnackBarBehavior.floating),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.ios_share, size: 20),
            onSelected: (val) { if (val == 'image') _exportToImage(); },
            itemBuilder: (ctx) => [const PopupMenuItem(value: 'image', child: Text("Export as Image"))],
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () { _saveNote(); context.pop(); },
          ),
        ],
        body: Hero(
          tag: heroTag,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: CanvasGridPainter(color: isColorDark ? Colors.white10 : Colors.black12)),
                ),
                RepaintBoundary(
                  key: _boundaryKey,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const SizedBox(height: 70),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                          child: TextField(
                            controller: _titleController,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isColorDark ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Title (Optional)',
                              border: InputBorder.none,
                              isDense: true,
                              hintStyle: TextStyle(color: isColorDark ? Colors.white38 : Colors.black38),
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
                                  color: isColorDark ? Colors.white12 : Colors.black12,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  DateFormat('MMM dd, yyyy  •  hh:mm a').format(_selectedDate),
                                  style: TextStyle(color: isColorDark ? Colors.white70 : Colors.black87, fontWeight: FontWeight.bold, fontSize: 11),
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
                            hintText: "Start typing...",
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