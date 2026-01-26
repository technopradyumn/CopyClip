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
  final String? noteId;

  const NoteEditScreen({super.key, this.note, this.noteId});

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

  // Local reference to the note being edited (either from widget or fetched)
  Note? _editingNote;

  Color _scaffoldColor = AppContentPalette.palette.first;
  late Color _initialColor;

  String _initialTitle = "";
  String _initialContentJson = "";

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
      // Ensure box is open (Deep Link Fix)
      if (!Hive.isBoxOpen('notes_box')) {
        await Hive.openBox<Note>('notes_box');
      }
      _notesBox = Hive.box<Note>('notes_box');

      // Resolve Note
      _editingNote = widget.note;
      if (_editingNote == null && widget.noteId != null) {
        debugPrint("NoteEditScreen: Resolving ID ${widget.noteId}");
        _editingNote = _notesBox.get(widget.noteId);
        debugPrint("NoteEditScreen: Found Note? ${_editingNote != null}");
      }

      if (_editingNote != null) {
        _titleController.text = _editingNote!.title;
        _selectedDate = _editingNote!.updatedAt;
        _scaffoldColor = _editingNote!.colorValue != null
            ? Color(_editingNote!.colorValue!)
            : AppContentPalette.palette.first;
      } else {
        _selectedDate = DateTime.now();
        _scaffoldColor = AppContentPalette.palette.first;
      }

      _initialColor = _scaffoldColor;
      _initialTitle = _titleController.text;

      // Apply dynamic default color if creating a new note
      if (_editingNote == null &&
          _scaffoldColor == AppContentPalette.palette.first) {
        if (mounted) {
          final defaultColor = AppContentPalette.getDefaultColor(context);
          if (_scaffoldColor != defaultColor) {
            _scaffoldColor = defaultColor;
            _initialColor = defaultColor;
          }
        }
      }

      _initQuill();
    } catch (e) {
      debugPrint("Error initializing Note data: $e");
      // Fallback init to prevent crash
      _selectedDate = DateTime.now();
      _scaffoldColor = AppContentPalette.palette.first;
      _initQuill();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
    super.dispose();
  }

  void _initQuill() {
    Document doc;
    try {
      if (_editingNote != null && _editingNote!.content.isNotEmpty) {
        doc = Document.fromJson(jsonDecode(_editingNote!.content));
      } else {
        doc = Document();
      }
    } catch (e) {
      doc = Document()..insert(0, _editingNote?.content ?? "");
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

    // Robust Save Logic
    if (_editingNote != null) {
      debugPrint("NoteEditScreen: Saving existing note (${_editingNote!.id})");

      _editingNote!.title = title;
      _editingNote!.content = contentJson;
      _editingNote!.updatedAt = _selectedDate;
      _editingNote!.colorValue = _scaffoldColor.value;

      if (_editingNote!.isInBox) {
        _editingNote!.save();
        debugPrint("NoteEditScreen: Saved using .save()");
      } else {
        debugPrint(
          "NoteEditScreen: Note not in box! Attempting to locate key.",
        );
        try {
          // Find real note by ID
          final realNoteIndex = _notesBox.values.toList().indexWhere(
            (n) => n.id == _editingNote!.id,
          );
          if (realNoteIndex != -1) {
            final key = _notesBox.keyAt(realNoteIndex);
            _notesBox.put(key, _editingNote!);
            debugPrint("NoteEditScreen: Saved using box.put($key)");
          } else {
            // Re-add if lost
            debugPrint("NoteEditScreen: Note lost. Re-adding.");
            _notesBox.add(_editingNote!);
          }
        } catch (e) {
          debugPrint("NoteEditScreen: Error saving: $e");
        }
      }
    } else {
      debugPrint("NoteEditScreen: Creating NEW note");
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
      _editingNote = newNote;
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

    final heroTag = _editingNote != null
        ? 'note_background_${_editingNote!.id}'
        : 'new_note_hero';

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
        _saveNote();
        return true;
      },
      child: GlassScaffold(
        showBackArrow: true,
        backgroundColor: _scaffoldColor,
        centerTitle: false,
        titleSpacing: 0,
        title: AnimatedTopBarTitle(
          title: _editingNote == null ? 'New Note' : 'Edit Note',
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
                  if (_editingNote != null) {
                    showDialog(
                      context: context,
                      builder: (ctx) => GlassDialog(
                        title: "Move to Bin?",
                        content: "You can restore this note later.",
                        confirmText: "Move",
                        isDestructive: true,
                        onConfirm: () {
                          Navigator.pop(ctx); // Close dialog
                          _editingNote!.isDeleted = true;
                          _editingNote!.deletedAt = DateTime.now();
                          _editingNote!.save();
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
