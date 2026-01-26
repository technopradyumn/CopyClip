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
import 'package:copyclip/src/core/const/constant.dart';

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
import '../../../../core/widgets/animated_top_bar_title.dart';
import '../../../../core/utils/widget_sync_service.dart';
import '../../../../features/premium/presentation/widgets/premium_lock_dialog.dart';
import '../../../../features/premium/presentation/provider/premium_provider.dart';
import 'package:provider/provider.dart';

import '../designs/journal_page_registry.dart';
import '../widgets/page_design_picker.dart';

class JournalEditScreen extends StatefulWidget {
  final JournalEntry? entry;
  final String? entryId; // Support for Deep Linking

  const JournalEditScreen({super.key, this.entry, this.entryId});

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

  String _initialContentJson = "";

  // Page Design
  String _selectedPageDesignId = 'ruled_wide';

  // Resolved Entry (from widget or ID)
  JournalEntry? _resolvedEntry;

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

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
    // ✅ Add focus listener for keyboard handling
    _editorFocusNode.addListener(_onFocusChanged);
  }

  Future<void> _initData() async {
    try {
      // Ensure box is open
      if (!Hive.isBoxOpen('journal_box')) {
        await Hive.openBox<JournalEntry>('journal_box');
      }

      _resolvedEntry = widget.entry;

      // Resolve by ID if entry is null
      if (_resolvedEntry == null && widget.entryId != null) {
        final box = Hive.box<JournalEntry>('journal_box');
        try {
          _resolvedEntry = box.values.firstWhere((e) => e.id == widget.entryId);
        } catch (e) {
          debugPrint("Error finding journal entry by ID: ${widget.entryId}");
        }
      }

      if (_resolvedEntry != null) {
        _titleController.text = _resolvedEntry!.title;
        _tagsController.text = _resolvedEntry!.tags.join(', ');
        _selectedDate = _resolvedEntry!.date;
        _selectedMood = _resolvedEntry!.mood;
        _isFavorite = _resolvedEntry!.isFavorite;
        _scaffoldColor = _resolvedEntry!.colorValue != null
            ? Color(_resolvedEntry!.colorValue!)
            : AppContentPalette.palette.first;
        // Load page design
        _selectedPageDesignId = _resolvedEntry!.pageDesignId ?? 'default';
      }

      // Dynamic Default Color logic
      if (_resolvedEntry == null) {
        if (_scaffoldColor == AppContentPalette.palette.first) {
          if (mounted) {
            final defaultColor = AppContentPalette.getDefaultColor(context);
            if (_scaffoldColor != defaultColor) {
              _scaffoldColor = defaultColor;
            }
          }
        }
      }

      _initQuill();
    } catch (e) {
      debugPrint("Error initializing Journal data: $e");
      // Fallback init to prevent crash
      _initQuill();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      if (_resolvedEntry != null && _resolvedEntry!.content.isNotEmpty) {
        doc = Document.fromJson(jsonDecode(_resolvedEntry!.content));
      } else {
        doc = Document();
      }
    } catch (e) {
      doc = Document()..insert(0, _resolvedEntry?.content ?? "");
    }
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    WidgetSyncService.syncJournal(); // Sync Widget
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
    final plainText = _quillController.document.toPlainText().trim();

    if (title.isEmpty && plainText.isEmpty) {
      return; // Do not save empty journals
    }

    final contentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final box = Hive.box<JournalEntry>('journal_box');

    // Logic to ensure robust saving
    if (_resolvedEntry != null) {
      debugPrint(
        "JournalEditScreen: Saving existing entry (${_resolvedEntry!.id})",
      );

      _resolvedEntry!.title = title;
      _resolvedEntry!.content = contentJson;
      _resolvedEntry!.date = _selectedDate;
      _resolvedEntry!.mood = _selectedMood;
      _resolvedEntry!.tags = tags;
      _resolvedEntry!.isFavorite = _isFavorite;
      _resolvedEntry!.colorValue = _scaffoldColor.value;
      _resolvedEntry!.pageDesignId = _selectedPageDesignId;

      if (_resolvedEntry!.isInBox) {
        _resolvedEntry!.save();
        debugPrint("JournalEditScreen: Saved using .save()");
      } else {
        debugPrint(
          "JournalEditScreen: Entry not in box! Attempting to locate key.",
        );
        // Fallback: This entry might be a detached copy. Find real entry by ID.
        try {
          final realEntryIndex = box.values.toList().indexWhere(
            (e) => e.id == _resolvedEntry!.id,
          );
          if (realEntryIndex != -1) {
            final key = box.keyAt(realEntryIndex);
            box.put(key, _resolvedEntry!);
            debugPrint("JournalEditScreen: Saved using box.put($key)");
          } else {
            // Not found? Re-add.
            debugPrint("JournalEditScreen: Entry lost. Re-adding.");
            box.add(_resolvedEntry!);
          }
        } catch (e) {
          debugPrint("JournalEditScreen: Error saving: $e");
        }
      }
    } else {
      debugPrint("JournalEditScreen: Creating NEW entry");
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

      final newEntry = JournalEntry(
        id: const Uuid().v4(),
        title: title,
        content: contentJson,
        date: _selectedDate,
        mood: _selectedMood,
        tags: tags,
        isFavorite: _isFavorite,
        colorValue: _scaffoldColor.value,
        sortIndex: newSortIndex,
        pageDesignId: _selectedPageDesignId,
        designId: 'classic_ruled', // Default card design
      );
      box.add(newEntry);

      // Update local reference to avoid creating duplicates on next save
      _resolvedEntry = newEntry;
    }

    // Sync Widget
    WidgetSyncService.syncJournal();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isColorDark =
        ThemeData.estimateBrightnessForColor(_scaffoldColor) == Brightness.dark;
    final contrastColor = isColorDark ? Colors.white : Colors.black87;

    final String heroTag = _resolvedEntry != null
        ? 'journal_bg_${_resolvedEntry!.id}'
        : 'journal_new_hero';

    // Page Design Plugin
    final pageDesign = JournalPageRegistry.getDesign(_selectedPageDesignId);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // Auto-save on back
        _saveEntry();
        return true;
      },
      child: GlassScaffold(
        showBackArrow: true,
        backgroundColor: _scaffoldColor,
        resizeToAvoidBottomInset: false,
        centerTitle: false,
        titleSpacing: 0,
        title: AnimatedTopBarTitle(
          title: _resolvedEntry == null ? 'New Entry' : 'Edit Entry',
          icon: Icons.book,
          iconHeroTag: 'journal_icon',
          titleHeroTag: 'journal_title',
          color: contrastColor,
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.layers, color: contrastColor),
            tooltip: 'Page Style',
            onPressed: _showPageDesignPicker,
          ),
          IconButton(
            icon: Icon(CupertinoIcons.doc_on_doc, color: contrastColor),
            tooltip: 'Copy Content',
            onPressed: () {
              final text = _quillController.document.toPlainText().trim();
              if (text.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: text));
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
            icon: Icon(CupertinoIcons.ellipsis_vertical, color: contrastColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            ),
            onSelected: (val) {
              switch (val) {
                case 'design':
                  _showPageDesignPicker();
                  break;
                case 'mood':
                  _showMoodPicker();
                  break;
                case 'date':
                  _pickDateTime();
                  break;
                case 'favorite':
                  setState(() => _isFavorite = !_isFavorite);
                  break;
                case 'color':
                  _showColorPicker();
                  break;
                case 'pdf':
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
                  break;
                case 'delete':
                  if (widget.entry != null) {
                    showDialog(
                      context: context,
                      builder: (ctx) => GlassDialog(
                        title: "Move to Bin?",
                        content: "You can restore this entry later.",
                        confirmText: "Move",
                        isDestructive: true,
                        onConfirm: () {
                          Navigator.pop(ctx);
                          widget.entry!.isDeleted = true;
                          widget.entry!.deletedAt = DateTime.now();
                          widget.entry!.save();
                          Navigator.pop(context);
                        },
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'design',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.layers, size: 18),
                    SizedBox(width: 12),
                    Text("Page Style"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'mood',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.smiley, size: 18),
                    SizedBox(width: 12),
                    Text("Update Mood"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.calendar, size: 18),
                    SizedBox(width: 12),
                    Text("Change Date"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'favorite',
                child: Row(
                  children: [
                    Icon(
                      _isFavorite
                          ? CupertinoIcons.star_fill
                          : CupertinoIcons.star,
                      size: 18,
                      color: _isFavorite ? Colors.amber : null,
                    ),
                    const SizedBox(width: 12),
                    Text(_isFavorite ? "Unfavorite" : "Favorite"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'color',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.paintbrush, size: 18),
                    SizedBox(width: 12),
                    Text("Page Color"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.share, size: 18),
                    const SizedBox(width: 12),
                    const Text("Export as PDF"),
                    if (!Provider.of<PremiumProvider>(
                      context,
                      listen: false,
                    ).isPremium) ...[
                      const Spacer(),
                      const Icon(
                        CupertinoIcons.lock_fill,
                        size: 14,
                        color: Colors.amber,
                      ),
                    ],
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.trash, size: 18, color: Colors.red),
                    SizedBox(width: 12),
                    Text("Delete", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
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
                              horizontal: 24,
                              vertical: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: InkWell(
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
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            size: 14,
                                            color: contrastColor.withOpacity(
                                              0.7,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              DateFormat(
                                                'MMM dd, yyyy  •  hh:mm a',
                                              ).format(_selectedDate),
                                              style: TextStyle(
                                                color: contrastColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
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
