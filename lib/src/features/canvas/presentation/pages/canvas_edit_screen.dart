import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/canvas_adapter.dart';
import '../../data/canvas_model.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

enum BrushShape {
  round,
  square,
  marker,
  calligraphy,
  pencil,
  pen,
  highlighter,
  spray,
  technicalPen,
  fountainPen,
  ballpointPen,
  calligraphyPen,
  sketchBrush,
  charcoal,
  crayon,
  inkBrush,
  watercolorBrush,
  airBrush,
  sprayPaint,
  oilBrush,
  neonBrush,
  glitchBrush,
  pixelBrush,
  glowPen,
  shadingBrush,
  blurBrush,
  smudgeTool,
  eraserHard,
  eraserSoft,
}

class CanvasEditScreen extends StatefulWidget {
  final String? noteId;
  final String? folderId;

  const CanvasEditScreen({super.key, required this.noteId, this.folderId});

  @override
  State<CanvasEditScreen> createState() => _CanvasEditScreenState();
}

class _CanvasEditScreenState extends State<CanvasEditScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late CanvasNote _currentNote;
  List<DrawingStroke> _strokes = [];
  List<DrawingStroke> _redoStack = [];
  List<CanvasText> _textElements = [];

  // Page management
  int _currentPageIndex = 0;

  // Drawing state
  bool _isDrawingMode = true;
  bool _isTextMode = false;
  bool _isShapeMode = false;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  double _eraserSize = 20.0;
  bool _isErasing = false;
  BrushShape _brushShape = BrushShape.round;

  // Hand mode (panning & zooming)
  bool _isHandMode = false;

  // Canvas transformation
  double _zoomLevel = 1.0;
  Offset _panOffset = Offset.zero;

  // Selected text for editing
  String? _selectedTextId;

  // Tool options
  bool _showToolOptions = false;
  String _selectedShape = 'line';
  Color _fillColor = Colors.transparent;
  bool _useFill = false;

  late AnimationController _toolbarAnimController;

  @override
  void initState() {
    super.initState();
    _initializeNote();
    _toolbarAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _toolbarAnimController.forward();
  }

  void _initializeNote() {
    final db = CanvasDatabase();
    if (widget.noteId != null) {
      _currentNote = db.getNote(widget.noteId!)!;
      _titleController = TextEditingController(text: _currentNote.title);

      if (_currentNote.pages.isEmpty) {
        _currentNote.pages.add(CanvasPage());
      }
    } else {
      _currentNote = CanvasNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Untitled Note',
        folderId: widget.folderId ?? 'default',
        pages: [CanvasPage()],
      );
      _titleController = TextEditingController(text: 'Untitled Note');
    }
    _loadCurrentPage();
  }

  Future<void> _exportToPdf() async {
    // 1. CRITICAL FIX: Save the current screen state to the note object before exporting
    _saveCurrentPage();

    // Show Loading Indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final pdf = pw.Document();
      final pdfPageFormat = PdfPageFormat.a4;

      // Scaling for print quality
      const double scale = 2.0;
      final double width = pdfPageFormat.width * scale;
      final double height = pdfPageFormat.height * scale;
      final screenSize = MediaQuery.of(context).size;
      final double contentScale = width / screenSize.width;

      // 2. Iterate through all pages
      for (var page in _currentNote.pages) {
        // Optional: Skip completely empty pages to avoid "blank page" issues
        // if (page.strokes.isEmpty && page.textElements.isEmpty && _currentNote.pages.length > 1) continue;

        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, height));

        // A. Draw Background
        final bgPaint = Paint()..color = _currentNote.backgroundColor;
        canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

        // B. Scale and Draw Strokes
        canvas.save();
        canvas.scale(contentScale);

        final painter = DrawingPainter(page.strokes, _currentNote.backgroundColor);
        painter.paint(canvas, Size(screenSize.width, screenSize.height));

        // C. Draw Text
        for (var textElem in page.textElements) {
          final textSpan = TextSpan(
            text: textElem.text,
            style: TextStyle(
              color: Color(textElem.color),
              fontSize: textElem.fontSize,
              fontWeight: textElem.bold ? FontWeight.bold : FontWeight.w500,
              fontStyle: textElem.italic ? FontStyle.italic : FontStyle.normal,
              decoration: textElem.underline ? TextDecoration.underline : TextDecoration.none,
            ),
          );

          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
          );

          textPainter.layout(minWidth: 0, maxWidth: textElem.containerWidth);
          textPainter.paint(canvas, textElem.position);
        }

        canvas.restore();

        // 3. Convert to Image
        final picture = recorder.endRecording();
        final img = await picture.toImage(width.toInt(), height.toInt());
        final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
        final buffer = byteData!.buffer.asUint8List();

        // 4. Add Page to PDF
        pdf.addPage(
          pw.Page(
            pageFormat: pdfPageFormat,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
              return pw.FullPage(
                ignoreMargins: true,
                child: pw.Image(
                  pw.MemoryImage(buffer),
                  fit: pw.BoxFit.fill,
                ),
              );
            },
          ),
        );
      }

      if (mounted) Navigator.pop(context); // Hide Loading

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: '${_currentNote.title.replaceAll(' ', '_')}.pdf',
      );

    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("Error exporting PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export PDF: $e')),
      );
    }
  }

  void _loadCurrentPage() {
    final page = _currentNote.pages[_currentPageIndex];
    _strokes = List.from(page.strokes);
    _textElements = List.from(page.textElements);
    _redoStack.clear();
    setState(() {}); // Ensure UI rebuilds
  }

  void _saveCurrentPage() {
    _currentNote.pages[_currentPageIndex] = CanvasPage(
      strokes: List.from(_strokes),
      textElements: List.from(_textElements),
    );
  }

  void _switchToPage(int index) {
    if (index == _currentPageIndex) return;
    _saveCurrentPage();
    setState(() {
      _currentPageIndex = index;
      _zoomLevel = 1.0;
      _panOffset = Offset.zero;
      _selectedTextId = null;
    });
    _loadCurrentPage();
  }

  void _addNewPage() {
    _saveCurrentPage();
    setState(() {
      _currentNote.pages.add(CanvasPage());
      _currentPageIndex = _currentNote.pages.length - 1;
      _zoomLevel = 1.0;
      _panOffset = Offset.zero;
      _selectedTextId = null;
    });
    _loadCurrentPage();
  }

  void _saveNote() async {
    _saveCurrentPage();
    _currentNote.title = _titleController.text.isEmpty
        ? 'Untitled Note'
        : _titleController.text;

    _currentNote.lastModified = DateTime.now();
    await CanvasDatabase().saveNote(_currentNote);
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _redoStack.add(_strokes.removeLast());
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _strokes.add(_redoStack.removeLast());
      });
    }
  }

  void _enableTextMode() {
    setState(() {
      _isTextMode = true;
      _isDrawingMode = false;
      _isErasing = false;
      _isHandMode = false;
      _selectedTextId = null;
    });
  }

  void _addNewText() {
    final size = MediaQuery.of(context).size;
    final centerX = (size.width / 2 - _panOffset.dx) / _zoomLevel;
    final centerY = (size.height / 2 - _panOffset.dy - 150) / _zoomLevel;

    setState(() {
      final newText = CanvasText(
        id: DateTime.now().toString(),
        text: 'Type here...',
        position: Offset(centerX - 100, centerY - 50),
        color: _selectedColor.value,
        fontSize: 20.0,
        containerWidth: 200.0,
        containerHeight: 100.0,
        bold: false,
        italic: false,
        underline: false,
      );
      _textElements.add(newText);
      _selectedTextId = newText.id;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _toolbarAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        _saveNote();
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildCompactHeader(theme, colorScheme),
              Expanded(child: _buildCanvas(theme, colorScheme)),
              _buildPageTabs(theme, colorScheme),
              _buildMinimalToolbar(theme, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () {
              _saveNote();
              context.pop();
            },
            padding: const EdgeInsets.all(8),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Note title',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    hintStyle: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showDateTimePicker(context),
                  child: Text(
                    DateFormat('MMM d, h:mm a').format(_currentNote.lastModified),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.zoom_out, size: 18),
                  onPressed: () => setState(
                        () => _zoomLevel = (_zoomLevel - 0.2).clamp(0.5, 3.0),
                  ),
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                ),
                Text(
                  '${(_zoomLevel * 100).toInt()}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_in, size: 18),
                  onPressed: () => setState(
                        () => _zoomLevel = (_zoomLevel + 0.2).clamp(0.5, 3.0),
                  ),
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () => _showOptionsMenu(context, theme, colorScheme),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _currentNote.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: _isHandMode
                  ? (details) {
                setState(() {
                  _panOffset += details.delta;
                  _panOffset = _clampOffset(_panOffset);
                });
              }
                  : null,
              onDoubleTap: () {
                setState(() {
                  _zoomLevel = 1.0;
                  _panOffset = Offset.zero;
                });
              },
              child: Transform.translate(
                offset: _panOffset,
                child: Transform.scale(
                  scale: _zoomLevel,
                  alignment: Alignment.center,
                  child: Container(
                    color: _currentNote.backgroundColor,
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        CustomPaint(
                          painter: DrawingPainter(_strokes, _currentNote.backgroundColor),
                          size: Size.infinite,
                        ),
                        ..._textElements.map((text) {
                          final isSelected = _selectedTextId == text.id;
                          return Positioned(
                            left: text.position.dx,
                            top: text.position.dy,
                            child: _buildEditableText(text, isSelected, colorScheme),
                          );
                        }).toList(),
                        if (_isDrawingMode && !_isHandMode)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanStart: (details) {
                              final pos = details.localPosition;
                              final adjusted = Offset(
                                (pos.dx - _panOffset.dx) / _zoomLevel,
                                (pos.dy - _panOffset.dy) / _zoomLevel,
                              );
                              setState(() {
                                _redoStack.clear();
                                _strokes.add(
                                  DrawingStroke(
                                    points: [adjusted.dx, adjusted.dy],
                                    color: _isErasing
                                        ? _currentNote.backgroundColor.value
                                        : _selectedColor.value,
                                    strokeWidth: _isErasing ? _eraserSize : _strokeWidth,
                                    penType: _brushShape.index,
                                  ),
                                );
                              });
                            },
                            onPanUpdate: (details) {
                              final pos = details.localPosition;
                              final adjusted = Offset(
                                (pos.dx - _panOffset.dx) / _zoomLevel,
                                (pos.dy - _panOffset.dy) / _zoomLevel,
                              );
                              setState(() {
                                if (_strokes.isNotEmpty) {
                                  _strokes.last.points.addAll([adjusted.dx, adjusted.dy]);
                                }
                              });
                            },
                            child: Container(color: Colors.transparent),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isTextMode && _selectedTextId == null && !_isHandMode)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: _addNewText,
                  backgroundColor: colorScheme.primary,
                  child: Icon(Icons.add, color: colorScheme.onPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableText(CanvasText text, bool isSelected, ColorScheme colorScheme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final focusNode = FocusNode();

    void unfocus() {
      focusNode.unfocus();
      setState(() {
        _selectedTextId = null;
      });
    }

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          unfocus();
        } else {
          setState(() {
            _selectedTextId = text.id;
          });
          focusNode.requestFocus();
        }
      },
      onPanUpdate: isSelected && !_isHandMode
          ? (details) {
        setState(() {
          text.position += details.delta / _zoomLevel;
        });
      }
          : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: text.containerWidth,
            constraints: BoxConstraints(
              minHeight: text.containerHeight,
              maxWidth: screenWidth * 0.9,
            ),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? colorScheme.primary.withOpacity(0.8) : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              focusNode: focusNode,
              controller: TextEditingController(text: text.text)
                ..selection = TextSelection.collapsed(offset: text.text.length),
              enabled: isSelected,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(
                color: Color(text.color),
                fontSize: text.fontSize,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                text.text = value;
              },
              onSubmitted: (_) => unfocus(),
            ),
          ),

          if (isSelected)
            Positioned(
              top: -12,
              right: -12,
              child: GestureDetector(
                onTapDown: (_) => _deleteText(text.id),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          if (isSelected)
            Positioned(
              bottom: -12,
              right: -12,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    final newWidth = (text.containerWidth + details.delta.dx / _zoomLevel)
                        .clamp(80.0, screenWidth * 0.9);
                    final newHeight = (text.containerHeight + details.delta.dy / _zoomLevel)
                        .clamp(50.0, 600.0);

                    text.containerWidth = newWidth;
                    text.containerHeight = newHeight;
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_outward,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          if (isSelected)
            Positioned(
              top: -12,
              left: -12,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        text.fontSize = (text.fontSize + 3).clamp(10.0, 100.0);
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add, size: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        text.fontSize = (text.fontSize - 3).clamp(10.0, 100.0);
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.remove, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

          if (isSelected)
            Positioned(
              top: -12,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: unfocus,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageTabs(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(_currentNote.pages.length, (index) {
              final isActive = index == _currentPageIndex;
              return GestureDetector(
                onTap: () => _switchToPage(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive ? colorScheme.primary : colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isActive
                        ? [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : null,
                  ),
                  child: Text(
                    'Page ${index + 1}',
                    style: TextStyle(
                      color: isActive ? colorScheme.onPrimary : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addNewPage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.add, color: colorScheme.primary, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalToolbar(ThemeData theme, ColorScheme colorScheme) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(parent: _toolbarAnimController, curve: Curves.easeOut),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              _buildToolButton(Icons.pan_tool, _isHandMode, () {
                setState(() {
                  _isHandMode = !_isHandMode;
                  if (_isHandMode) {
                    _isTextMode = false;
                    _selectedTextId = null;
                  }
                });
              }, colorScheme),
              SizedBox(width: 8),
              _buildToolButton(Icons.edit, _isDrawingMode && !_isErasing && !_isHandMode, () {
                setState(() {
                  _isDrawingMode = true;
                  _isTextMode = false;
                  _isShapeMode = false;
                  _isErasing = false;
                  _isHandMode = false;
                  _selectedTextId = null;
                  if (_brushShape == BrushShape.eraserHard || _brushShape == BrushShape.eraserSoft) {
                    _brushShape = BrushShape.pen;
                  }
                });
              }, colorScheme),
              _buildToolButton(Icons.cleaning_services, _isErasing && !_isHandMode, () {
                setState(() {
                  _isDrawingMode = true;
                  _isErasing = true;
                  _isTextMode = false;
                  _isShapeMode = false;
                  _isHandMode = false;
                  _selectedTextId = null;
                  _brushShape = BrushShape.eraserHard;
                });
              }, colorScheme),
              _buildToolButton(Icons.text_fields, _isTextMode && !_isHandMode, () {
                _enableTextMode();
              }, colorScheme),
              SizedBox(width: 8),
              Container(width: 1, height: 24, color: colorScheme.outline.withOpacity(0.2)),
              SizedBox(width: 8),
              if (!_isErasing && !_isHandMode)
                GestureDetector(
                  onTap: () => _showBrushGrid(context, colorScheme),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getBrushIcon(),
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              if (!_isErasing && !_isHandMode) SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isErasing ? Icons.cleaning_services : Icons.line_weight,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 110,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        activeTrackColor: colorScheme.primary,
                        inactiveTrackColor: colorScheme.onSurface.withOpacity(0.2),
                        thumbColor: colorScheme.primary,
                        overlayColor: colorScheme.primary.withOpacity(0.15),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                        trackShape: const RoundedRectSliderTrackShape(),
                      ),
                      child: Slider(
                        value: _isErasing ? _eraserSize : _strokeWidth,
                        min: _isErasing ? 5 : 1,
                        max: _isErasing ? 50 : 15,
                        onChanged: _isHandMode
                            ? null
                            : (val) {
                          setState(() {
                            if (_isErasing) {
                              _eraserSize = val;
                            } else {
                              _strokeWidth = val;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 28,
                    alignment: Alignment.center,
                    child: Text(
                      '${(_isErasing ? _eraserSize : _strokeWidth).toInt()}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: (_isHandMode || _isErasing) ? null : () => _showAdvancedColorPicker(isBackground: false),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.3), width: 1.5),
                  ),
                ),
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: _isHandMode ? null : () => _showAdvancedColorPicker(isBackground: true),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _currentNote.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.3), width: 1.5),
                  ),
                  child: const Icon(Icons.format_color_fill, size: 16, color: Colors.white),
                ),
              ),
              SizedBox(width: 8),
              _buildToolButton(
                Icons.undo,
                false,
                _strokes.isEmpty || _isHandMode ? () {} : _undo,
                colorScheme,
                enabled: _strokes.isNotEmpty && !_isHandMode,
              ),
              _buildToolButton(
                Icons.redo,
                false,
                _redoStack.isEmpty || _isHandMode ? () {} : _redo,
                colorScheme,
                enabled: _redoStack.isNotEmpty && !_isHandMode,
              ),
              _buildToolButton(Icons.delete_outline, false, _isHandMode ? () {} : () {
                _showClearDialog(theme);
              }, colorScheme, enabled: !_isHandMode),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _saveNote();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Saved'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 16, color: colorScheme.onPrimary),
                      const SizedBox(width: 4),
                      Text(
                        'Save',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
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
    );
  }

  IconData _getBrushIcon() {
    return _getBrushIconForShape(_brushShape);
  }

  IconData _getBrushIconForShape(BrushShape shape) {
    switch (shape) {
      case BrushShape.round: return Icons.circle_outlined;
      case BrushShape.square: return Icons.square_outlined;
      case BrushShape.marker: return Icons.brush;
      case BrushShape.calligraphy: return Icons.edit_outlined;
      case BrushShape.pencil: return Icons.create;
      case BrushShape.pen: return Icons.mode_edit_outline;
      case BrushShape.highlighter: return Icons.highlight;
      case BrushShape.spray: return Icons.water_drop_outlined;
      case BrushShape.technicalPen: return Icons.edit;
      case BrushShape.fountainPen: return Icons.edit_outlined;
      case BrushShape.ballpointPen: return Icons.create;
      case BrushShape.calligraphyPen: return Icons.edit_attributes;
      case BrushShape.sketchBrush: return Icons.brush;
      case BrushShape.charcoal: return Icons.grain;
      case BrushShape.crayon: return Icons.color_lens;
      case BrushShape.inkBrush: return Icons.brush;
      case BrushShape.watercolorBrush: return Icons.format_paint;
      case BrushShape.airBrush: return Icons.air;
      case BrushShape.sprayPaint: return Icons.water_drop;
      case BrushShape.oilBrush: return Icons.format_paint;
      case BrushShape.neonBrush: return Icons.lightbulb_outline;
      case BrushShape.glitchBrush: return Icons.bug_report;
      case BrushShape.pixelBrush: return Icons.grid_on;
      case BrushShape.glowPen: return Icons.light_mode;
      case BrushShape.shadingBrush: return Icons.gradient;
      case BrushShape.blurBrush: return Icons.blur_on;
      case BrushShape.smudgeTool: return Icons.touch_app;
      case BrushShape.eraserHard: return Icons.cleaning_services;
      case BrushShape.eraserSoft: return Icons.cleaning_services;
    }
  }

  String _getBrushName(BrushShape shape) {
    switch (shape) {
      case BrushShape.round: return 'Round';
      case BrushShape.square: return 'Square';
      case BrushShape.marker: return 'Marker';
      case BrushShape.calligraphy: return 'Calligraphy';
      case BrushShape.pencil: return 'Pencil';
      case BrushShape.pen: return 'Pen';
      case BrushShape.highlighter: return 'Highlighter';
      case BrushShape.spray: return 'Spray';
      case BrushShape.technicalPen: return 'Technical Pen';
      case BrushShape.fountainPen: return 'Fountain Pen';
      case BrushShape.ballpointPen: return 'Ballpoint Pen';
      case BrushShape.calligraphyPen: return 'Calligraphy Pen';
      case BrushShape.sketchBrush: return 'Sketch Brush';
      case BrushShape.charcoal: return 'Charcoal';
      case BrushShape.crayon: return 'Crayon';
      case BrushShape.inkBrush: return 'Ink Brush';
      case BrushShape.watercolorBrush: return 'Watercolor';
      case BrushShape.airBrush: return 'Air Brush';
      case BrushShape.sprayPaint: return 'Spray Paint';
      case BrushShape.oilBrush: return 'Oil Brush';
      case BrushShape.neonBrush: return 'Neon';
      case BrushShape.glitchBrush: return 'Glitch';
      case BrushShape.pixelBrush: return 'Pixel';
      case BrushShape.glowPen: return 'Glow Pen';
      case BrushShape.shadingBrush: return 'Shading';
      case BrushShape.blurBrush: return 'Blur';
      case BrushShape.smudgeTool: return 'Smudge';
      case BrushShape.eraserHard: return 'Eraser (Hard)';
      case BrushShape.eraserSoft: return 'Eraser (Soft)';
    }
  }

  void _showBrushGrid(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) {
        final height = MediaQuery.of(context).size.height;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: height * 0.7),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Select Brush', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: BrushShape.values.length,
                      itemBuilder: (context, index) {
                        final brush = BrushShape.values[index];
                        final isSelected = _brushShape == brush;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _brushShape = brush;
                              _isErasing = (brush == BrushShape.eraserHard || brush == BrushShape.eraserSoft);
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? colorScheme.primary.withOpacity(0.15) : colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.3),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getBrushIconForShape(brush),
                                  size: 28,
                                  color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getBrushName(brush),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolButton(
      IconData icon,
      bool isActive,
      VoidCallback onTap,
      ColorScheme colorScheme, {
        bool enabled = true,
      }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? (isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7))
              : colorScheme.onSurface.withOpacity(0.3),
        ),
      ),
    );
  }

  void _showAdvancedColorPicker({required bool isBackground}) {
    Color pickerColor = isBackground ? _currentNote.backgroundColor : _selectedColor;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator.resolveFrom(context),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      isBackground ? 'Background Color' : 'Brush Color',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Done'),
                      onPressed: () {
                        setState(() {
                          if (isBackground) {
                            _currentNote.backgroundColor = pickerColor;
                          } else {
                            _selectedColor = pickerColor;
                          }
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                height: 80,
                decoration: BoxDecoration(
                  color: pickerColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: pickerColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color color) {
                          pickerColor = color;
                          (context as Element).markNeedsBuild();
                        },
                        colorPickerWidth: MediaQuery.of(context).size.width - 60,
                        pickerAreaHeightPercent: 0.7,
                        enableAlpha: false,
                        displayThumbColor: true,
                        paletteType: PaletteType.hsvWithHue,
                        labelTypes: const [],
                        pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(12)),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 1,
                        color: CupertinoColors.separator.resolveFrom(context),
                        margin: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Quick Colors',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      BlockPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color color) {
                          pickerColor = color;
                          (context as Element).markNeedsBuild();
                        },
                        availableColors: const [
                          Colors.red,
                          Colors.pink,
                          Colors.purple,
                          Colors.deepPurple,
                          Colors.indigo,
                          Colors.blue,
                          Colors.lightBlue,
                          Colors.cyan,
                          Colors.teal,
                          Colors.green,
                          Colors.lightGreen,
                          Colors.lime,
                          Colors.yellow,
                          Colors.amber,
                          Colors.orange,
                          Colors.deepOrange,
                          Colors.brown,
                          Colors.grey,
                          Colors.blueGrey,
                          Colors.black,
                          Colors.white,
                        ],
                        layoutBuilder: (context, colors, child) {
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: [for (Color color in colors) child(color)],
                          );
                        },
                        itemBuilder: (color, isCurrentColor, changeColor) {
                          return GestureDetector(
                            onTap: changeColor,
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isCurrentColor
                                      ? CupertinoColors.activeBlue
                                      : CupertinoColors.separator.resolveFrom(context),
                                  width: isCurrentColor ? 3 : 1,
                                ),
                                boxShadow: isCurrentColor
                                    ? [
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                                    : [],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDateTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: _currentNote.lastModified,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _currentNote.lastModified = newDateTime;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Reset Zoom'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _zoomLevel = 1.0;
                _panOffset = Offset.zero;
              });
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Export as PDF'),
            onPressed: () {
              Navigator.pop(context);
              _exportToPdf();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Note Info'),
            onPressed: () {
              Navigator.pop(context);
              _showNoteInfo(theme);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Clear All', style: TextStyle(color: CupertinoColors.destructiveRed)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _strokes.clear();
                _redoStack.clear();
                _textElements.clear();
              });
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _deleteText(String id) {
    setState(() {
      _textElements.removeWhere((t) => t.id == id);
      _selectedTextId = null;
    });
  }

  void _showClearDialog(ThemeData theme) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Clear Canvas?'),
        content: const Text('All drawings and text will be erased.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              setState(() {
                _strokes.clear();
                _redoStack.clear();
                _textElements.clear();
              });
              Navigator.pop(ctx);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showNoteInfo(ThemeData theme) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Note Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Created: ${DateFormat('MMM d, y • h:mm a').format(_currentNote.createdAt)}'),
            const SizedBox(height: 4),
            Text('Strokes: ${_strokes.length}'),
            const SizedBox(height: 4),
            Text('Text Elements: ${_textElements.length}'),
            const SizedBox(height: 4),
            Text('Zoom: ${(_zoomLevel * 100).toStringAsFixed(0)}%'),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  Offset _clampOffset(Offset offset) {
    final maxX = ((_zoomLevel - 1.0) * 300).abs();
    final maxY = ((_zoomLevel - 1.0) * 300).abs();
    return Offset(offset.dx.clamp(-maxX, maxX), offset.dy.clamp(-maxY, maxY));
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final Color backgroundColor;

  DrawingPainter(this.strokes, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      final paint = Paint()
        ..color = Color(stroke.color)
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final brushShape = BrushShape.values[stroke.penType.clamp(0, BrushShape.values.length - 1)];

      // Glow for neon/glow
      if (brushShape == BrushShape.neonBrush || brushShape == BrushShape.glowPen) {
        final glowPaint = Paint()
          ..color = Color(stroke.color).withOpacity(0.5)
          ..strokeWidth = stroke.strokeWidth * 3
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, stroke.strokeWidth * 1.2);
        for (int i = 0; i < stroke.points.length - 2; i += 2) {
          canvas.drawLine(
            Offset(stroke.points[i], stroke.points[i + 1]),
            Offset(stroke.points[i + 2], stroke.points[i + 3]),
            glowPaint,
          );
        }
      }

      // Texture noise for charcoal/crayon/sketch
      if ([BrushShape.charcoal, BrushShape.crayon, BrushShape.sketchBrush].contains(brushShape)) {
        final random = Random(stroke.points.hashCode);
        final noise = brushShape == BrushShape.charcoal ? 5.0 : 2.5;
        for (int i = 0; i < stroke.points.length - 2; i += 2) {
          final offset1 = Offset((random.nextDouble() - 0.5) * noise, (random.nextDouble() - 0.5) * noise);
          final offset2 = Offset((random.nextDouble() - 0.5) * noise, (random.nextDouble() - 0.5) * noise);
          canvas.drawLine(
            Offset(stroke.points[i], stroke.points[i + 1]) + offset1,
            Offset(stroke.points[i + 2], stroke.points[i + 3]) + offset2,
            paint..color = paint.color.withOpacity(0.8),
          );
        }
        continue;
      }

      // Pixel brush
      if (brushShape == BrushShape.pixelBrush) {
        paint.style = PaintingStyle.fill;
        for (int i = 0; i < stroke.points.length; i += 2) {
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(stroke.points[i], stroke.points[i + 1]),
              width: stroke.strokeWidth,
              height: stroke.strokeWidth,
            ),
            paint,
          );
        }
        continue;
      }

      // Eraser opacity
      if (brushShape == BrushShape.eraserSoft) {
        paint.color = paint.color.withOpacity(0.4);
      } else if (brushShape == BrushShape.eraserHard) {
        paint.color = paint.color.withOpacity(1.0);
      }

      // Style tweaks
      switch (brushShape) {
        case BrushShape.round:
          paint.strokeCap = StrokeCap.round;
          break;
        case BrushShape.square:
          paint.strokeCap = StrokeCap.square;
          break;
        case BrushShape.marker:
        case BrushShape.highlighter:
          paint.color = paint.color.withOpacity(brushShape == BrushShape.highlighter ? 0.4 : 0.7);
          paint.strokeCap = brushShape == BrushShape.highlighter ? StrokeCap.square : StrokeCap.round;
          break;
        case BrushShape.watercolorBrush:
        case BrushShape.blurBrush:
          paint.color = paint.color.withOpacity(0.5);
          paint.maskFilter = MaskFilter.blur(BlurStyle.normal, stroke.strokeWidth / 4);
          break;
        default:
          break;
      }

      // Special drawing logic
      if (brushShape == BrushShape.calligraphy) {
        for (int i = 0; i < stroke.points.length - 2; i += 2) {
          final dx = stroke.points[i + 2] - stroke.points[i];
          final dy = stroke.points[i + 3] - stroke.points[i + 1];
          final angle = atan2(dy, dx);

          final path = Path();
          final halfWidth = stroke.strokeWidth / 2;

          path.moveTo(stroke.points[i] - sin(angle) * halfWidth, stroke.points[i + 1] + cos(angle) * halfWidth);
          path.lineTo(stroke.points[i + 2] - sin(angle) * halfWidth, stroke.points[i + 3] + cos(angle) * halfWidth);
          path.lineTo(stroke.points[i + 2] + sin(angle) * halfWidth * 0.3, stroke.points[i + 3] - cos(angle) * halfWidth * 0.3);
          path.lineTo(stroke.points[i] + sin(angle) * halfWidth * 0.3, stroke.points[i + 1] - cos(angle) * halfWidth * 0.3);
          path.close();

          canvas.drawPath(path, paint..style = PaintingStyle.fill);
        }
      } else if ([BrushShape.spray, BrushShape.sprayPaint, BrushShape.airBrush].contains(brushShape)) {
        final random = Random(stroke.points.hashCode);
        final density = brushShape == BrushShape.airBrush ? 10 : (brushShape == BrushShape.sprayPaint ? 6 : 3);
        for (int i = 0; i < stroke.points.length; i += 2) {
          for (int j = 0; j < density; j++) {
            final offsetX = (random.nextDouble() - 0.5) * stroke.strokeWidth * 2;
            final offsetY = (random.nextDouble() - 0.5) * stroke.strokeWidth * 2;
            canvas.drawCircle(
              Offset(stroke.points[i] + offsetX, stroke.points[i + 1] + offsetY),
              stroke.strokeWidth * 0.2,
              paint,
            );
          }
        }
      } else {
        // Standard line drawing
        for (int i = 0; i < stroke.points.length - 2; i += 2) {
          canvas.drawLine(
            Offset(stroke.points[i], stroke.points[i + 1]),
            Offset(stroke.points[i + 2], stroke.points[i + 3]),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) =>
      oldDelegate.strokes != strokes || oldDelegate.backgroundColor != backgroundColor;
}