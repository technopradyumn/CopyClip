import 'dart:convert';

import 'dart:math';
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

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_rich_text_editor.dart';
import '../../../clipboard/presentation/pages/clipboard_edit_screen.dart';
import '../../data/journal_model.dart';
import '../../../../core/app_content_palette.dart';
import '../../../../core/utils/widget_sync_service.dart';
import '../../../../features/premium/presentation/widgets/premium_lock_dialog.dart';
import '../../../../features/premium/presentation/provider/premium_provider.dart';
import 'package:provider/provider.dart';

import '../designs/journal_page_registry.dart';
import '../widgets/page_design_picker.dart';

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

  // Page Design
  String _selectedPageDesignId = 'default';
  String _initialPageDesignId = 'default';

  final Map<String, String> _moodMap = {
    'Happy': '😊',
    'Excited': '🤩',
    'Neutral': '😐',
    'Sad': '😔',
    'Stressed': '😫',
    'Angry': '😡',
    'Cool': '😎',
    'Love': '😍',
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
      _scaffoldColor = widget.entry!.colorValue != null
          ? Color(widget.entry!.colorValue!)
          : AppContentPalette.palette.first;
      // Load page design
      _selectedPageDesignId = widget.entry!.pageDesignId ?? 'default';
    }

    _initialTitle = _titleController.text;
    _initialDate = _selectedDate;
    _initialColor = _scaffoldColor;
    _initialMood = _selectedMood;
    _initialPageDesignId = _selectedPageDesignId;
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
    WidgetSyncService.syncJournal(); // Sync Widget

    _initialContentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );
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
                child: const Text(
                  "Done",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: Theme.of(context).brightness,
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (val) =>
                      setState(() => _selectedDate = val),
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
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                        : Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 28),
                  ),
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
                  spacing: 12,
                  runSpacing: 12,
                  children: palette.map((color) {
                    final isSelected = _scaffoldColor.value == color.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _scaffoldColor = color);
                        setDialogState(() {});
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.white24,
                            width: isSelected ? 3 : 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
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

  void _showPageDesignPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PageDesignPickerSheet(
        selectedDesignId: _selectedPageDesignId,
        onDesignSelected: (id) {
          setState(() => _selectedPageDesignId = id);
        },
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
      if (attributes['bold'] == true)
        style = style.copyWith(fontWeight: pw.FontWeight.bold);
      if (attributes['italic'] == true)
        style = style.copyWith(fontStyle: pw.FontStyle.italic);
      if (attributes['underline'] == true)
        style = style.copyWith(decoration: pw.TextDecoration.underline);

      if (attributes['header'] != null) {
        final int level = attributes['header'] as int;
        if (level == 1)
          style = style.copyWith(fontSize: 28, fontWeight: pw.FontWeight.bold);
        else if (level == 2)
          style = style.copyWith(fontSize: 24, fontWeight: pw.FontWeight.bold);
        else if (level == 3)
          style = style.copyWith(fontSize: 20, fontWeight: pw.FontWeight.bold);
      }

      if (text.contains('\n')) {
        final parts = text.split('\n');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].isNotEmpty) {
            currentLineSpans.add(pw.TextSpan(text: parts[i], style: style));
          }

          if (i < parts.length - 1) {
            if (currentLineSpans.isNotEmpty) {
              widgets.add(
                pw.RichText(text: pw.TextSpan(children: currentLineSpans)),
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
    final title = _titleController.text.trim().isEmpty
        ? 'Untitled Entry'
        : _titleController.text.trim();

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
                    child: pw.Text(
                      title,
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(moodEmoji, style: const pw.TextStyle(fontSize: 30)),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                DateFormat('MMMM dd, yyyy • hh:mm a').format(_selectedDate),
                style: const pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey700,
                ),
              ),
              if (tags.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Text(
                  tags,
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.blue700,
                  ),
                ),
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
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'journal_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  void _saveEntry() {
    final title = _titleController.text.trim();
    final contentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final box = Hive.box<JournalEntry>('journal_box');
    if (widget.entry != null) {
      widget.entry!.title = title;
      widget.entry!.content = contentJson;
      widget.entry!.date = _selectedDate;
      widget.entry!.mood = _selectedMood;
      widget.entry!.tags = tags;
      widget.entry!.isFavorite = _isFavorite;
      widget.entry!.colorValue = _scaffoldColor.value;
      widget.entry!.pageDesignId = _selectedPageDesignId; // Save new field
      widget.entry!.save();
    } else {
      int newSortIndex = 0;
      if (box.isNotEmpty) {
        final existingIndices = box.values.map((e) => e.sortIndex);
        if (existingIndices.isNotEmpty) {
          newSortIndex =
              existingIndices.reduce(
                (curr, next) => curr < next ? curr : next,
              ) -
              1;
        }
      }

      box.add(
        JournalEntry(
          id: const Uuid().v4(),
          title: title,
          content: contentJson,
          date: _selectedDate,
          mood: _selectedMood,
          tags: tags,
          isFavorite: _isFavorite,
          colorValue: _scaffoldColor.value,
          sortIndex: newSortIndex,
          pageDesignId: _selectedPageDesignId, // Save new field
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isColorDark =
        ThemeData.estimateBrightnessForColor(_scaffoldColor) == Brightness.dark;
    final contrastColor = isColorDark ? Colors.white : Colors.black87;

    final String heroTag = widget.entry != null
        ? 'journal_bg_${widget.entry!.id}'
        : 'journal_new_hero';

    // Page Design Plugin
    final pageDesign = JournalPageRegistry.getDesign(_selectedPageDesignId);

    return WillPopScope(
      onWillPop: () async {
        final currentJson = jsonEncode(
          _quillController.document.toDelta().toJson(),
        );
        bool hasChanges =
            _titleController.text != _initialTitle ||
            currentJson != _initialContentJson ||
            _selectedDate != _initialDate ||
            _selectedMood != _initialMood ||
            _scaffoldColor.value != _initialColor.value ||
            _selectedPageDesignId != _initialPageDesignId;

        if (!hasChanges) return true;
        final result = await showDialog<String>(
          context: context,
          builder: (ctx) => GlassDialog(
            title: "Unsaved Changes",
            content: "Save your journal entry?",
            confirmText: "Save",
            cancelText: "Discard",
            onConfirm: () => Navigator.pop(ctx, 'save'),
            onCancel: () => Navigator.pop(ctx, 'discard'),
          ),
        );
        if (result == 'save') {
          _saveEntry();
          return true;
        }
        return result == 'discard';
      },
      child: GlassScaffold(
        showBackArrow: true,
        backgroundColor: _scaffoldColor,
        resizeToAvoidBottomInset: false, // Fix: Prevent background squashing
        title: widget.entry == null ? 'New Entry' : 'Edit Entry',
        actions: [
          // New Page Design Picker Button
          IconButton(
            icon: Icon(Icons.note_alt_outlined, color: contrastColor),
            onPressed: _showPageDesignPicker,
            tooltip: 'Page Style',
          ),
          GestureDetector(
            onTap: _showColorPicker,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: _scaffoldColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: contrastColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.palette_outlined,
                size: 14,
                color: contrastColor.withOpacity(0.6),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite
                  ? Colors.amberAccent
                  : contrastColor.withOpacity(0.5),
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.ios_share, size: 20, color: contrastColor),
            onSelected: (val) {
              if (val == 'pdf') {
                final provider = Provider.of<PremiumProvider>(
                  context,
                  listen: false,
                );
                if (provider.isPremium) {
                  _exportToPdf();
                } else {
                  PremiumLockDialog.show(
                    context,
                    featureName: 'PDF Export',
                    onUnlockOnce: _exportToPdf,
                  );
                }
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    const Text("Export as PDF"),
                    const SizedBox(width: 8),
                    if (!Provider.of<PremiumProvider>(
                      context,
                      listen: false,
                    ).isPremium)
                      const Icon(Icons.lock, size: 14, color: Colors.amber),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.check, color: contrastColor),
            onPressed: () {
              _saveEntry();
              context.pop();
            },
          ),
        ],
        body: SafeArea(
          child: Hero(
            tag: heroTag,
            child: Material(
              type: MaterialType.transparency,
              child: Stack(
                children: [
                  // BACKGROUND LAYER - Stays Full Screen
                  // Because Scaffold is resizeToAvoidBottomInset: false
                  Positioned.fill(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      // Apply the selected page design painter
                      child: CustomPaint(
                        painter: pageDesign.painterBuilder(_scaffoldColor),
                      ),
                    ),
                  ),

                  // CONTENT LAYER - Handles Insets Manually
                  RepaintBoundary(
                    key: _boundaryKey,
                    child: Container(
                      color: Colors.transparent,
                      // Add bottom padding matching keyboard inset since we disabled resize
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: _pickDateTime,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: contrastColor.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 14,
                                          color: contrastColor.withOpacity(0.7),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat(
                                            'MMM dd, yyyy  •  hh:mm a',
                                          ).format(_selectedDate),
                                          style: TextStyle(
                                            color: contrastColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
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
                                      border: Border.all(
                                        color: contrastColor.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Text(
                                      _moodMap[_selectedMood]!,
                                      style: const TextStyle(fontSize: 22),
                                    ),
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
                                letterSpacing: -0.5,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Entry Title',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: contrastColor.withOpacity(0.25),
                                ),
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
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: '#journal #thoughts',
                                border: InputBorder.none,
                                isDense: true,
                                hintStyle: TextStyle(
                                  color: contrastColor.withOpacity(0.15),
                                ),
                                prefixIcon: Icon(
                                  Icons.local_offer_outlined,
                                  size: 14,
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.6,
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 24,
                                  maxHeight: 20,
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
      ),
    );
  }
}

class JournalPaperPainter extends CustomPainter {
  final Color lineColor;
  final Color marginColor;
  final double spacing;

  static const double _topHeaderSpace = 60.0;
  static const double _leftMarginPos = 50.0;
  static const bool _showHoles = true;

  JournalPaperPainter({
    this.lineColor = const Color(0xFF6B6B6B),
    this.marginColor = const Color(0xFFB85C5C),
    this.spacing = 28.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.transparent, Colors.transparent],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, bgPaint);

    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.1,
        colors: [Colors.transparent, Colors.brown.withOpacity(0.18)],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, vignettePaint);

    final linePaint = Paint()
      ..color = lineColor.withOpacity(0.25)
      ..strokeWidth = 1.0;

    final marginPaint = Paint()
      ..color = marginColor.withOpacity(0.35)
      ..strokeWidth = 1.4;

    final holePaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final rnd = Random(4);

    for (double y = _topHeaderSpace; y < size.height; y += spacing) {
      final wobble = rnd.nextDouble() * 1.2 - 0.6;
      canvas.drawLine(
        Offset(0, y + wobble),
        Offset(size.width, y + wobble),
        linePaint,
      );
    }

    canvas.drawLine(
      const Offset(_leftMarginPos, 0),
      Offset(_leftMarginPos, size.height),
      marginPaint,
    );

    final stainPaint = Paint()
      ..color = Colors.brown.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      final r = 18 + rnd.nextDouble() * 30;
      canvas.drawCircle(Offset(dx, dy), r, stainPaint);
    }

    if (_showHoles) {
      final double holeX = _leftMarginPos / 2;
      final List<double> holeYPositions = [
        size.height * 0.18,
        size.height * 0.50,
        size.height * 0.82,
      ];

      for (double y in holeYPositions) {
        canvas.drawCircle(Offset(holeX, y), 10.5, holePaint);
        canvas.drawCircle(
          Offset(holeX - 1, y - 1),
          10.5,
          Paint()..color = Colors.white.withOpacity(0.25),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant JournalPaperPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.marginColor != marginColor ||
        oldDelegate.spacing != spacing;
  }
}
