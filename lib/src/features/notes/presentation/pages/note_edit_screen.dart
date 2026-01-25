import 'dart:convert';

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

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_rich_text_editor.dart';
import '../../data/note_model.dart';
import '../../../../core/app_content_palette.dart';
import '../../../../core/widgets/animated_top_bar_title.dart';
import '../../../../core/utils/widget_sync_service.dart';
import '../../../../core/const/constant.dart';
import '../../../../features/premium/presentation/widgets/premium_lock_dialog.dart';
import '../../../../features/premium/presentation/provider/premium_provider.dart';
import 'package:provider/provider.dart';

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
    } else {
      _selectedDate = DateTime.now();
    }

    _initialColor = _scaffoldColor;
    _initialTitle = _titleController.text;

    _initQuill();

    // ✅ Add focus listener for keyboard handling
    _editorFocusNode.addListener(_onFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Apply dynamic default color if creating a new note
    if (widget.note == null &&
        _scaffoldColor == AppContentPalette.palette.first) {
      // Check if we haven't manually changed it yet (we use the palette first color as a "sentinel" for default)
      // Actually, easier way: just set it here once.
      // But didChangeDependencies runs multiple times.
      // Let's just set it if it matches the hardcoded default we initialized with.
      // A cleaner way for "New Note" logic:
      if (_initialColor == AppContentPalette.palette.first) {
        final defaultColor = AppContentPalette.getDefaultColor(context);
        if (_scaffoldColor != defaultColor) {
          setState(() {
            _scaffoldColor = defaultColor;
            _initialColor = defaultColor;
          });
        }
      }
    }
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
    _initialContentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );
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
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: onSurfaceColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: _selectedDate,
                    onDateTimeChanged: (val) =>
                        setState(() => _selectedDate = val),
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
    final plainText = _quillController.document.toPlainText().trim();

    if (title.isEmpty && plainText.isEmpty) {
      return; // Do not save empty notes
    }

    final contentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );

    if (widget.note != null) {
      widget.note!.title = title;
      widget.note!.content = contentJson;
      widget.note!.updatedAt = _selectedDate;
      widget.note!.colorValue = _scaffoldColor.value;
      widget.note!.save();
    } else {
      int newSortIndex = 0;
      if (_notesBox.isNotEmpty) {
        final existingIndices = _notesBox.values.map((e) => e.sortIndex);
        if (existingIndices.isNotEmpty) {
          // Find min index and subtract 1 to put at top
          newSortIndex =
              existingIndices.reduce(
                (curr, next) => curr < next ? curr : next,
              ) -
              1;
        }
      }

      final newNote = Note(
        id: const Uuid().v4(),
        title: title,
        content: contentJson,
        updatedAt: _selectedDate,
        colorValue: _scaffoldColor.value,
        sortIndex: newSortIndex,
      );
      _notesBox.put(newNote.id, newNote);
    }
    // Sync Widget
    WidgetSyncService.syncNotes();
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
                            width: isSelected
                                ? AppConstants.selectedBorderWidth
                                : AppConstants.borderWidth,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                CupertinoIcons.checkmark,
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
                    borderRadius: BorderRadius.circular(
                      AppConstants.cornerRadius,
                    ),
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
      if (attributes['bold'] == true)
        style = style.copyWith(fontWeight: pw.FontWeight.bold);
      if (attributes['italic'] == true)
        style = style.copyWith(fontStyle: pw.FontStyle.italic);
      if (attributes['underline'] == true)
        style = style.copyWith(decoration: pw.TextDecoration.underline);

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
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'note_export_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isColorDark =
        ThemeData.estimateBrightnessForColor(_scaffoldColor) == Brightness.dark;
    final contrastColor = isColorDark ? Colors.white : Colors.black87;

    final String heroTag = widget.note != null
        ? 'note_background_${widget.note!.id}'
        : 'new_note_hero';

    return WillPopScope(
      onWillPop: () async {
        // Auto-save on back
        _saveNote();
        return true;
      },
      child: GlassScaffold(
        showBackArrow: true,
        backgroundColor: _scaffoldColor,
        centerTitle: false,
        titleSpacing: 0,
        title: AnimatedTopBarTitle(
          title: widget.note == null ? 'New Note' : 'Edit Note',
          icon: CupertinoIcons.doc_text,
          iconHeroTag: 'notes_icon',
          titleHeroTag: 'notes_title',
          color: contrastColor,
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.paintbrush, color: contrastColor),
            tooltip: 'Change Color',
            onPressed: _showColorPicker,
          ),
          IconButton(
            icon: Icon(CupertinoIcons.doc_on_doc, color: contrastColor),
            tooltip: 'Copy Content',
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
            icon: Icon(CupertinoIcons.ellipsis_vertical, color: contrastColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            ),
            onSelected: (val) {
              switch (val) {
                case 'color':
                  _showColorPicker();
                  break;
                case 'copy':
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
                  if (widget.note != null) {
                    showDialog(
                      context: context,
                      builder: (ctx) => GlassDialog(
                        title: "Move to Bin?",
                        content: "You can restore this note later.",
                        confirmText: "Move",
                        isDestructive: true,
                        onConfirm: () {
                          Navigator.pop(ctx); // Close dialog
                          widget.note!.isDeleted = true;
                          widget.note!.deletedAt = DateTime.now();
                          widget.note!.save();
                          Navigator.pop(context); // Close screen
                        },
                      ),
                    );
                  } else {
                    Navigator.pop(context); // Just close if it's new
                  }
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'color',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.paintbrush, size: 18),
                    SizedBox(width: 12),
                    Text("Change Color"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.doc_on_doc, size: 18),
                    SizedBox(width: 12),
                    Text("Copy Content"),
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
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CanvasGridPainter(
                        color: contrastColor.withOpacity(0.08),
                      ),
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
                                hintStyle: TextStyle(
                                  color: contrastColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 4,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: _pickDateTime,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.cornerRadius,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: contrastColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    DateFormat(
                                      'MMM dd, yyyy  •  hh:mm a',
                                    ).format(_selectedDate),
                                    style: TextStyle(
                                      color: contrastColor.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
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
      ),
    );
  }
}

class CanvasGridPainter extends CustomPainter {
  final Color color;

  CanvasGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
