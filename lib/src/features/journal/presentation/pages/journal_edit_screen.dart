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
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_rich_text_editor.dart';
import '../../../clipboard/presentation/pages/clipboard_edit_screen.dart';
import '../../data/journal_model.dart';

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

  Color _scaffoldColor = Colors.white;
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
      _scaffoldColor = widget.entry!.colorValue != null ? Color(widget.entry!.colorValue!) : Colors.white;
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
    final isColorDark = ThemeData.estimateBrightnessForColor(_scaffoldColor) == Brightness.dark;
    final textColor = isColorDark ? Colors.white : Colors.black87;

    // MATCHING HERO TAG: Must be identical to the tag in JournalCard
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
          IconButton(
            icon: Icon(_isFavorite ? Icons.star : Icons.star_border, color: _isFavorite ? Colors.amberAccent : textColor.withOpacity(0.5)),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: () => Clipboard.setData(ClipboardData(text: _quillController.document.toPlainText())),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.ios_share, size: 20),
            onSelected: (val) { if (val == 'image') _exportToImage(); },
            itemBuilder: (ctx) => [const PopupMenuItem(value: 'image', child: Text("Export as Image"))],
          ),
          IconButton(icon: const Icon(Icons.check), onPressed: () { _saveEntry(); context.pop(); }),
        ],
        // WRAP BODY IN HERO
        body: Hero(
          tag: heroTag,
          child: Material(
            type: MaterialType.transparency, // Required for clean text flight
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: CanvasGridPainter(color: isColorDark ? Colors.white10 : Colors.black12))),
                RepaintBoundary(
                  key: _boundaryKey,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
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
                                  decoration: BoxDecoration(color: isColorDark ? Colors.white12 : Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month, size: 14, color: textColor.withOpacity(0.7)),
                                      const SizedBox(width: 8),
                                      Text(DateFormat('MMM dd, yyyy  •  hh:mm a').format(_selectedDate), style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _showMoodPicker,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
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
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -0.5),
                            decoration: InputDecoration(hintText: 'Entry Title', border: InputBorder.none, hintStyle: TextStyle(color: textColor.withOpacity(0.25))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextField(
                            controller: _tagsController,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500
                            ),
                            decoration: InputDecoration(
                              hintText: '#journal #thoughts',
                              border: InputBorder.none,
                              isDense: true,
                              hintStyle: TextStyle(color: textColor.withOpacity(0.15)),
                              prefixIcon: Icon(
                                  Icons.local_offer_outlined,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6)
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
                            hintText: "Dear Diary...",
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