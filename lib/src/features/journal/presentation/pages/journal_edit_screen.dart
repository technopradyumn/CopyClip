import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Added Import
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_rich_text_editor.dart';
import '../../../clipboard/presentation/pages/clipboard_edit_screen.dart';
import '../../data/journal_model.dart';
import '../../../../core/app_content_palette.dart'; // Added Import

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

  // --- CUPERTINO DATE PICKER ---
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

  // --- MOOD PICKER ---
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

  // --- COLOR PICKER ---
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

  // --- EXPORT & SHARE ---
  Future<void> _exportToImage() async {
    try {
      RenderRepaintBoundary? boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/journal_${DateTime.now().millisecond}.png');
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Export Error: $e")));
    }
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

    // 1. Centralized Dynamic Contrast Logic
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
          // Color Theme Swatch
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
          // Favorite Star
          IconButton(
            icon: Icon(
                _isFavorite ? Icons.star : Icons.star_border,
                color: _isFavorite ? Colors.amberAccent : contrastColor.withOpacity(0.5)
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          // Share/Export
          PopupMenuButton<String>(
            icon: Icon(Icons.ios_share, size: 20, color: contrastColor),
            onSelected: (val) { if (val == 'image') _exportToImage(); },
            itemBuilder: (ctx) => [const PopupMenuItem(value: 'image', child: Text("Export as Image"))],
          ),
          // Save
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
                // Dynamic Grid Lines
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
                        const SizedBox(height: 80),
                        // Date and Mood Row
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
                        // Title Input
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
                        // Tags Input
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
                        // Editor
                        Expanded(
                          child: GlassRichTextEditor(
                            controller: _quillController,
                            focusNode: _editorFocusNode,
                            scrollController: _editorScrollController,
                            hintText: "Dear Diary...",
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