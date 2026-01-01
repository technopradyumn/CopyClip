import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/canvas_adapter.dart';
import '../../data/canvas_model.dart';
import '../widgets/drawing_painter.dart';

enum BrushShape {
  round, square, marker, calligraphy, pencil, pen, highlighter, spray,
  technicalPen, fountainPen, ballpointPen, calligraphyPen, sketchBrush,
  charcoal, crayon, inkBrush, watercolorBrush, airBrush, sprayPaint,
  oilBrush, neonBrush, glitchBrush, pixelBrush, glowPen, shadingBrush,
  blurBrush, smudgeTool, eraserHard, eraserSoft,
}

enum PageScrollAxis { horizontal, vertical, none }

class CanvasEditScreen extends StatefulWidget {
  final String? noteId;
  final String? folderId;

  const CanvasEditScreen({super.key, required this.noteId, this.folderId});

  @override
  State<CanvasEditScreen> createState() => _CanvasEditScreenState();
}

class _CanvasEditScreenState extends State<CanvasEditScreen> with TickerProviderStateMixin {
  late TextEditingController _titleController;
  late CanvasNote _currentNote;
  List<DrawingStroke> _strokes = [];
  List<DrawingStroke> _redoStack = [];
  List<CanvasText> _textElements = [];

  // Page management
  int _currentPageIndex = 0;
  bool _isMovingForward = true; // Tracks flip direction

  // Drawing state
  bool _isDrawingMode = true;
  bool _isTextMode = false;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  double _eraserSize = 20.0;
  bool _isErasing = false;
  BrushShape _brushShape = BrushShape.round;

  // Hand / Interaction Mode
  bool _isHandMode = false;
  PageScrollAxis _pageScrollAxis = PageScrollAxis.horizontal;
  bool _canTriggerPageSwitch = true;
  Offset _dragAccumulator = Offset.zero;

  // Visuals
  bool _showPageIndicator = false;
  Timer? _pageIndicatorTimer;
  String? _selectedTextId;

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
      if (_currentNote.pages.isEmpty) _currentNote.pages.add(CanvasPage());
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
    _saveCurrentPage();
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    try {
      final pdf = pw.Document();
      final pdfPageFormat = PdfPageFormat.a4;
      const double scale = 2.0;
      final double width = pdfPageFormat.width * scale;
      final double height = pdfPageFormat.height * scale;
      final screenSize = MediaQuery.of(context).size;
      final double contentScale = width / screenSize.width;

      for (var page in _currentNote.pages) {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, height));
        final bgPaint = Paint()..color = _currentNote.backgroundColor;
        canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);
        canvas.save();
        canvas.scale(contentScale);
        final painter = DrawingPainter(page.strokes, _currentNote.backgroundColor);
        painter.paint(canvas, Size(screenSize.width, screenSize.height));
        for (var textElem in page.textElements) {
          final textSpan = TextSpan(
            text: textElem.text,
            style: TextStyle(color: Color(textElem.color), fontSize: textElem.fontSize, fontWeight: textElem.bold ? FontWeight.bold : FontWeight.w500, fontStyle: textElem.italic ? FontStyle.italic : FontStyle.normal, decoration: textElem.underline ? TextDecoration.underline : TextDecoration.none),
          );
          final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.left);
          textPainter.layout(minWidth: 0, maxWidth: textElem.containerWidth);
          textPainter.paint(canvas, textElem.position);
        }
        canvas.restore();
        final picture = recorder.endRecording();
        final img = await picture.toImage(width.toInt(), height.toInt());
        final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
        final buffer = byteData!.buffer.asUint8List();
        pdf.addPage(pw.Page(pageFormat: pdfPageFormat, margin: pw.EdgeInsets.zero, build: (_) => pw.FullPage(ignoreMargins: true, child: pw.Image(pw.MemoryImage(buffer), fit: pw.BoxFit.fill))));
      }
      if (mounted) Navigator.pop(context);
      await Printing.sharePdf(bytes: await pdf.save(), filename: '${_currentNote.title.replaceAll(' ', '_')}.pdf');
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  void _loadCurrentPage() {
    final page = _currentNote.pages[_currentPageIndex];
    _strokes = List.from(page.strokes);
    _textElements = List.from(page.textElements);
    _redoStack.clear();
    setState(() {});
  }

  void _saveCurrentPage() {
    _currentNote.pages[_currentPageIndex] = CanvasPage(
      strokes: List.from(_strokes),
      textElements: List.from(_textElements),
    );
  }

  void _switchToPage(int index) {
    if (index == _currentPageIndex) return;
    if (index < 0 || index >= _currentNote.pages.length) return;

    _saveCurrentPage();
    setState(() {
      _isMovingForward = index > _currentPageIndex;
      _currentPageIndex = index;
      _selectedTextId = null;
    });
    _loadCurrentPage();
    _triggerPageIndicator();
  }

  void _addNewPage() {
    _saveCurrentPage();
    setState(() {
      _isMovingForward = true;
      _currentNote.pages.add(CanvasPage());
      _currentPageIndex = _currentNote.pages.length - 1;
      _selectedTextId = null;
    });
    _loadCurrentPage();
    _triggerPageIndicator();
  }

  void _triggerPageIndicator() {
    setState(() => _showPageIndicator = true);
    _pageIndicatorTimer?.cancel();
    _pageIndicatorTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showPageIndicator = false);
    });
  }

  void _saveNote() async {
    _saveCurrentPage();
    _currentNote.title = _titleController.text.isEmpty ? 'Untitled Note' : _titleController.text;
    _currentNote.lastModified = DateTime.now();
    await CanvasDatabase().saveNote(_currentNote);
  }

  void _undo() {
    if (_strokes.isNotEmpty) setState(() => _redoStack.add(_strokes.removeLast()));
  }

  void _redo() {
    if (_redoStack.isNotEmpty) setState(() => _strokes.add(_redoStack.removeLast()));
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
    final centerX = size.width / 2;
    final centerY = size.height / 2 - 150;
    setState(() {
      final newText = CanvasText(id: DateTime.now().toString(), text: 'Type here...', position: Offset(centerX - 100, centerY - 50), color: _selectedColor.value, fontSize: 20.0, containerWidth: 200.0, containerHeight: 100.0, bold: false, italic: false, underline: false);
      _textElements.add(newText);
      _selectedTextId = newText.id;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _toolbarAnimController.dispose();
    _pageIndicatorTimer?.cancel();
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
          child: Stack(
            children: [
              // 1. Main Layout (Header, Canvas, Toolbar)
              Column(
                children: [
                  _buildCompactHeader(theme, colorScheme),
                  Expanded(child: _buildCanvasArea(theme, colorScheme)),
                  _buildMinimalToolbar(theme, colorScheme),
                ],
              ),

              // 2. Page Number Indicator (Centered)
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: _showPageIndicator ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                            "Page ${_currentPageIndex + 1} of ${_currentNote.pages.length}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),

              if (_isTextMode)
                Positioned(
                  bottom: 90,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _addNewText,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 4,
                    child: const Icon(Icons.sort_by_alpha),
                  ),
                ),
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
              padding: const EdgeInsets.all(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: _titleController,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        hintText: 'Note title',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        hintStyle: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.4)))),
                GestureDetector(
                    onTap: () => _showDateTimePicker(context),
                    child: Text(
                        DateFormat('MMM d, h:mm a')
                            .format(_currentNote.lastModified),
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5)))),
              ],
            ),
          ),

          // --- NEW: Page Number Indicator ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${_currentPageIndex + 1} / ${_currentNote.pages.length}",
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // ----------------------------------

          IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () => _showOptionsMenu(context, theme, colorScheme),
              padding: const EdgeInsets.all(8)),
        ],
      ),
    );
  }

  // --- THE CANVAS STACK WITH BOOK EFFECT ---
  Widget _buildCanvasArea(ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onPanStart: (details) {
        _dragAccumulator = Offset.zero;
        _canTriggerPageSwitch = true;
        if (_isDrawingMode && !_isHandMode) {
          final pos = details.localPosition;
          setState(() { _redoStack.clear(); _strokes.add(DrawingStroke(points: [pos.dx, pos.dy], color: _isErasing ? _currentNote.backgroundColor.value : _selectedColor.value, strokeWidth: _isErasing ? _eraserSize : _strokeWidth, penType: _brushShape.index)); });
        }
      },
      onPanUpdate: (details) {
        if (_isHandMode) {
          if (_canTriggerPageSwitch && _pageScrollAxis != PageScrollAxis.none) {
            _dragAccumulator += details.delta;
            final size = MediaQuery.of(context).size;
            final double thresholdX = size.width * 0.15;
            final double thresholdY = size.height * 0.15;
            int targetPage = _currentPageIndex;
            bool switched = false;

            if (_pageScrollAxis == PageScrollAxis.horizontal) {
              if (_dragAccumulator.dx > thresholdX) { targetPage = _currentPageIndex - 1; switched = true; }
              else if (_dragAccumulator.dx < -thresholdX) { targetPage = _currentPageIndex + 1; switched = true; }
            } else if (_pageScrollAxis == PageScrollAxis.vertical) {
              if (_dragAccumulator.dy > thresholdY) { targetPage = _currentPageIndex - 1; switched = true; }
              else if (_dragAccumulator.dy < -thresholdY) { targetPage = _currentPageIndex + 1; switched = true; }
            }

            if (switched) {
              if (targetPage >= 0 && targetPage < _currentNote.pages.length) {
                HapticFeedback.mediumImpact();
                _switchToPage(targetPage);
              }
              _canTriggerPageSwitch = false;
            }
          }
        } else if (_isDrawingMode) {
          final pos = details.localPosition;
          setState(() { if (_strokes.isNotEmpty) _strokes.last.points.addAll([pos.dx, pos.dy]); });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // --- FAKE STACK PAGES (DEPTH VISUALS) ---
            _buildStackLayer(theme, 3, 10, 0.85),
            _buildStackLayer(theme, 2, 6, 0.90),
            _buildStackLayer(theme, 1, 3, 0.95),

            // --- ACTIVE PAGE WITH 3D FLIP ---
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              layoutBuilder: (currentChild, previousChildren) {
                // Ensure stacked layout for proper flip visuals
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              transitionBuilder: (Widget child, Animation<double> animation) {
                // 3D Rotation Transition
                final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
                return AnimatedBuilder(
                  animation: rotateAnim,
                  child: child,
                  builder: (context, child) {
                    final isUnder = (ValueKey(_currentPageIndex) != child!.key);
                    var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                    tilt *= isUnder ? -1.0 : 1.0;

                    // Determine rotation axis based on scroll settings
                    final isVertical = _pageScrollAxis == PageScrollAxis.vertical;
                    // Adjust rotation direction based on Forward/Backward nav
                    final double radians = _isMovingForward
                        ? (1.0 - animation.value) * -pi / 2 // Flip to Left/Top
                        : (1.0 - animation.value) * pi / 2; // Flip to Right/Bottom

                    return Transform(
                      transform: Matrix4.rotationY(isVertical ? 0 : radians)
                        ..rotateX(isVertical ? -radians : 0) // Flip vertically if needed
                        ..setEntry(3, 0, tilt),
                      alignment: isVertical
                          ? (_isMovingForward ? Alignment.bottomCenter : Alignment.topCenter)
                          : (_isMovingForward ? Alignment.centerRight : Alignment.centerLeft),
                      child: child,
                    );
                  },
                );
              },
              child: Container(
                key: ValueKey<int>(_currentPageIndex),
                decoration: BoxDecoration(
                  color: _currentNote.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
                  ],
                ),
                width: double.infinity,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      CustomPaint(painter: DrawingPainter(_strokes, _currentNote.backgroundColor), size: Size.infinite),
                      ..._textElements.map((text) => Positioned(left: text.position.dx, top: text.position.dy, child: _buildEditableText(text, _selectedTextId == text.id, colorScheme))).toList(),
                      if (_isDrawingMode && !_isHandMode) GestureDetector(behavior: HitTestBehavior.opaque, child: Container(color: Colors.transparent)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build the visual stack layers underneath
  Widget _buildStackLayer(ThemeData theme, int index, double offset, double scale) {
    return Positioned(
      top: offset * 2,
      bottom: 0, // Anchor bottom
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: MediaQuery.of(context).size.width - 40, // Approx width
          height: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, offset),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableText(CanvasText text, bool isSelected, ColorScheme colorScheme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final focusNode = FocusNode();
    void unfocus() { focusNode.unfocus(); setState(() => _selectedTextId = null); }

    return GestureDetector(
      onTap: () {
        if (_isHandMode) return;
        if (isSelected) unfocus(); else { setState(() => _selectedTextId = text.id); focusNode.requestFocus(); }
      },
      onPanUpdate: (isSelected && !_isHandMode) ? (details) { setState(() => text.position += details.delta); } : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: text.containerWidth, constraints: BoxConstraints(minHeight: text.containerHeight, maxWidth: screenWidth * 0.9), padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(border: Border.all(color: isSelected ? colorScheme.primary.withOpacity(0.8) : Colors.transparent, width: isSelected ? 2 : 1), borderRadius: BorderRadius.circular(8)),
            child: TextField(focusNode: focusNode, controller: TextEditingController(text: text.text)..selection = TextSelection.collapsed(offset: text.text.length), enabled: isSelected, maxLines: null, keyboardType: TextInputType.multiline, textAlignVertical: TextAlignVertical.top, style: TextStyle(color: Color(text.color), fontSize: text.fontSize, fontWeight: FontWeight.w500, height: 1.4), decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero), onChanged: (value) => text.text = value, onSubmitted: (_) => unfocus()),
          ),
          if (isSelected) ...[
            Positioned(top: -12, right: -12, child: GestureDetector(onTapDown: (_) => _deleteText(text.id), child: Container(width: 30, height: 30, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]), child: const Icon(Icons.close, size: 18, color: Colors.white)))),
            Positioned(bottom: -12, right: -12, child: GestureDetector(onPanUpdate: (details) { setState(() { text.containerWidth = (text.containerWidth + details.delta.dx).clamp(80.0, screenWidth * 0.9); text.containerHeight = (text.containerHeight + details.delta.dy).clamp(50.0, 600.0); }); }, child: Container(width: 30, height: 30, decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]), child: const Icon(Icons.arrow_outward, size: 16, color: Colors.white)))),
            Positioned(top: -12, left: -12, child: Column(children: [GestureDetector(onTap: () => setState(() => text.fontSize = (text.fontSize + 3).clamp(10.0, 100.0)), child: Container(width: 30, height: 30, decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]), child: const Icon(Icons.add, size: 18, color: Colors.white))), const SizedBox(height: 6), GestureDetector(onTap: () => setState(() => text.fontSize = (text.fontSize - 3).clamp(10.0, 100.0)), child: Container(width: 30, height: 30, decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]), child: const Icon(Icons.remove, size: 18, color: Colors.white)))])),
            Positioned(top: -12, left: 0, right: 0, child: Center(child: GestureDetector(onTap: unfocus, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]), child: Text('Done', style: TextStyle(color: colorScheme.onPrimary, fontSize: 13, fontWeight: FontWeight.w600)))))),
          ]
        ],
      ),
    );
  }

  Widget _buildMinimalToolbar(ThemeData theme, ColorScheme colorScheme) {
    final bool canEdit = !_isHandMode;
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: _toolbarAnimController, curve: Curves.easeOut)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(color: theme.cardColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))]),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              _buildToolButton(Icons.pan_tool, _isHandMode, () { setState(() { _isHandMode = !_isHandMode; if (_isHandMode) { _isTextMode = false; _selectedTextId = null; } }); }, colorScheme),
              SizedBox(width: 8),
              _buildToolButton(Icons.edit, _isDrawingMode && !_isErasing && canEdit, () { setState(() { _isDrawingMode = true; _isTextMode = false; _isErasing = false; _isHandMode = false; _selectedTextId = null; if (_brushShape == BrushShape.eraserHard || _brushShape == BrushShape.eraserSoft) _brushShape = BrushShape.pen; }); }, colorScheme, enabled: canEdit),
              _buildToolButton(Icons.cleaning_services, _isErasing && canEdit, () { setState(() { _isDrawingMode = true; _isErasing = true; _isTextMode = false; _isHandMode = false; _selectedTextId = null; _brushShape = BrushShape.eraserHard; }); }, colorScheme, enabled: canEdit),
              _buildToolButton(Icons.text_fields, _isTextMode && canEdit, () => _enableTextMode(), colorScheme, enabled: canEdit),
              SizedBox(width: 8),
              // ADD PAGE BUTTON
              GestureDetector(onTap: _addNewPage, child: Container(padding: const EdgeInsets.all(8), margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.note_add, size: 20, color: colorScheme.primary))),
              SizedBox(width: 8),
              Container(width: 1, height: 24, color: colorScheme.outline.withOpacity(0.2)),
              SizedBox(width: 8),
              if (!_isErasing) Opacity(opacity: canEdit ? 1.0 : 0.4, child: GestureDetector(onTap: canEdit ? () => _showBrushGrid(context, colorScheme) : null, child: Container(padding: const EdgeInsets.all(8), margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: canEdit ? colorScheme.primary.withOpacity(0.1) : Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(_getBrushIcon(), size: 20, color: canEdit ? colorScheme.primary : Colors.grey)))),
              if (!_isErasing) SizedBox(width: 4),
              Opacity(opacity: canEdit ? 1.0 : 0.4, child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(_isErasing ? Icons.cleaning_services : Icons.line_weight, size: 16, color: colorScheme.onSurface.withOpacity(canEdit ? 0.7 : 0.3)), const SizedBox(width: 8), SizedBox(width: 110, child: SliderTheme(data: SliderTheme.of(context).copyWith(trackHeight: 4, activeTrackColor: canEdit ? colorScheme.primary : Colors.grey, inactiveTrackColor: colorScheme.onSurface.withOpacity(0.2), thumbColor: canEdit ? colorScheme.primary : Colors.grey, overlayColor: colorScheme.primary.withOpacity(0.15), overlayShape: const RoundSliderOverlayShape(overlayRadius: 14), thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7), trackShape: const RoundedRectSliderTrackShape()), child: Slider(value: _isErasing ? _eraserSize : _strokeWidth, min: _isErasing ? 5 : 1, max: _isErasing ? 50 : 15, onChanged: canEdit ? (val) { setState(() { if (_isErasing) _eraserSize = val; else _strokeWidth = val; }); } : null))), const SizedBox(width: 6), Container(width: 28, alignment: Alignment.center, child: Text('${(_isErasing ? _eraserSize : _strokeWidth).toInt()}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withOpacity(canEdit ? 0.7 : 0.3))))])),
              SizedBox(width: 4),
              Opacity(opacity: (canEdit && !_isErasing) ? 1.0 : 0.4, child: GestureDetector(onTap: (canEdit && !_isErasing) ? () => _showAdvancedColorPicker(isBackground: false) : null, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: _selectedColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: colorScheme.outline.withOpacity(0.3), width: 1.5))))),
              SizedBox(width: 4),
              Opacity(opacity: canEdit ? 1.0 : 0.4, child: GestureDetector(onTap: canEdit ? () => _showAdvancedColorPicker(isBackground: true) : null, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: _currentNote.backgroundColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: colorScheme.outline.withOpacity(0.3), width: 1.5)), child: const Icon(Icons.format_color_fill, size: 16, color: Colors.white)))),
              SizedBox(width: 8),
              _buildToolButton(Icons.undo, false, _strokes.isEmpty ? () {} : _undo, colorScheme, enabled: _strokes.isNotEmpty && canEdit),
              _buildToolButton(Icons.redo, false, _redoStack.isEmpty ? () {} : _redo, colorScheme, enabled: _redoStack.isNotEmpty && canEdit),
              _buildToolButton(Icons.delete_outline, false, () => _showClearDialog(theme), colorScheme, enabled: canEdit),
              SizedBox(width: 8),
              GestureDetector(onTap: () { _saveNote(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Saved'), duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16))); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check, size: 16, color: colorScheme.onPrimary), const SizedBox(width: 4), Text('Save', style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.w600, fontSize: 13))]))),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helpers ---
  IconData _getBrushIcon() => _getBrushIconForShape(_brushShape);
  IconData _getBrushIconForShape(BrushShape shape) {
    switch (shape) { case BrushShape.round: return Icons.circle_outlined; case BrushShape.square: return Icons.square_outlined; case BrushShape.marker: return Icons.brush; case BrushShape.calligraphy: return Icons.edit_outlined; case BrushShape.pencil: return Icons.create; case BrushShape.pen: return Icons.mode_edit_outline; case BrushShape.highlighter: return Icons.highlight; case BrushShape.spray: return Icons.water_drop_outlined; case BrushShape.technicalPen: return Icons.edit; case BrushShape.fountainPen: return Icons.edit_outlined; case BrushShape.ballpointPen: return Icons.create; case BrushShape.calligraphyPen: return Icons.edit_attributes; case BrushShape.sketchBrush: return Icons.brush; case BrushShape.charcoal: return Icons.grain; case BrushShape.crayon: return Icons.color_lens; case BrushShape.inkBrush: return Icons.brush; case BrushShape.watercolorBrush: return Icons.format_paint; case BrushShape.airBrush: return Icons.air; case BrushShape.sprayPaint: return Icons.water_drop; case BrushShape.oilBrush: return Icons.format_paint; case BrushShape.neonBrush: return Icons.lightbulb_outline; case BrushShape.glitchBrush: return Icons.bug_report; case BrushShape.pixelBrush: return Icons.grid_on; case BrushShape.glowPen: return Icons.light_mode; case BrushShape.shadingBrush: return Icons.gradient; case BrushShape.blurBrush: return Icons.blur_on; case BrushShape.smudgeTool: return Icons.touch_app; case BrushShape.eraserHard: return Icons.cleaning_services; case BrushShape.eraserSoft: return Icons.cleaning_services; }
  }
  String _getBrushName(BrushShape shape) {
    switch (shape) { case BrushShape.round: return 'Round'; case BrushShape.square: return 'Square'; case BrushShape.marker: return 'Marker'; case BrushShape.calligraphy: return 'Calligraphy'; case BrushShape.pencil: return 'Pencil'; case BrushShape.pen: return 'Pen'; case BrushShape.highlighter: return 'Highlighter'; case BrushShape.spray: return 'Spray'; case BrushShape.technicalPen: return 'Technical Pen'; case BrushShape.fountainPen: return 'Fountain Pen'; case BrushShape.ballpointPen: return 'Ballpoint Pen'; case BrushShape.calligraphyPen: return 'Calligraphy Pen'; case BrushShape.sketchBrush: return 'Sketch Brush'; case BrushShape.charcoal: return 'Charcoal'; case BrushShape.crayon: return 'Crayon'; case BrushShape.inkBrush: return 'Ink Brush'; case BrushShape.watercolorBrush: return 'Watercolor'; case BrushShape.airBrush: return 'Air Brush'; case BrushShape.sprayPaint: return 'Spray Paint'; case BrushShape.oilBrush: return 'Oil Brush'; case BrushShape.neonBrush: return 'Neon'; case BrushShape.glitchBrush: return 'Glitch'; case BrushShape.pixelBrush: return 'Pixel'; case BrushShape.glowPen: return 'Glow Pen'; case BrushShape.shadingBrush: return 'Shading'; case BrushShape.blurBrush: return 'Blur'; case BrushShape.smudgeTool: return 'Smudge'; case BrushShape.eraserHard: return 'Eraser (Hard)'; case BrushShape.eraserSoft: return 'Eraser (Soft)'; }
  }
  void _showBrushGrid(BuildContext context, ColorScheme colorScheme) {
    showDialog(context: context, builder: (context) {
      final height = MediaQuery.of(context).size.height; final int selectedIndex = BrushShape.values.indexOf(_brushShape);
      return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: ConstrainedBox(constraints: BoxConstraints(maxHeight: height * 0.5), child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('Select Brush', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 16), Expanded(child: LayoutBuilder(builder: (context, constraints) { const int crossAxisCount = 3; const double crossAxisSpacing = 12.0; const double mainAxisSpacing = 12.0; const double childAspectRatio = 1.2; final double gridWidth = constraints.maxWidth; final double itemWidth = (gridWidth - ((crossAxisCount - 1) * crossAxisSpacing)) / crossAxisCount; final double itemHeight = itemWidth / childAspectRatio; final int targetRow = selectedIndex ~/ crossAxisCount; final double rowHeight = itemHeight + mainAxisSpacing; double scrollOffset = (targetRow * rowHeight) - (constraints.maxHeight / 2) + (itemHeight / 2); if (scrollOffset < 0) scrollOffset = 0; final ScrollController scrollController = ScrollController(initialScrollOffset: scrollOffset); return GridView.builder(controller: scrollController, physics: const BouncingScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, crossAxisSpacing: crossAxisSpacing, mainAxisSpacing: mainAxisSpacing, childAspectRatio: childAspectRatio), itemCount: BrushShape.values.length, itemBuilder: (context, index) { final brush = BrushShape.values[index]; final isSelected = _brushShape == brush; return GestureDetector(onTap: () { setState(() { _brushShape = brush; _isErasing = (brush == BrushShape.eraserHard || brush == BrushShape.eraserSoft); }); Navigator.pop(context); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), decoration: BoxDecoration(color: isSelected ? colorScheme.primary.withOpacity(0.15) : colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.3), width: isSelected ? 2 : 1)), child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_getBrushIconForShape(brush), size: 28, color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7)), const SizedBox(height: 4), Flexible(child: Text(_getBrushName(brush), style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7)), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis))]))); }); }))]))));
    });
  }
  Widget _buildToolButton(IconData icon, bool isActive, VoidCallback onTap, ColorScheme colorScheme, {bool enabled = true}) {
    return GestureDetector(onTap: enabled ? onTap : null, child: Container(padding: const EdgeInsets.all(8), margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: isActive ? colorScheme.primary.withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 20, color: enabled ? (isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7)) : colorScheme.onSurface.withOpacity(0.3))));
  }
  void _showAdvancedColorPicker({required bool isBackground}) {
    Color pickerColor = isBackground ? _currentNote.backgroundColor : _selectedColor;
    showCupertinoModalPopup(context: context, builder: (BuildContext context) { return Container(height: MediaQuery.of(context).size.height * 0.75, decoration: BoxDecoration(color: CupertinoColors.systemBackground.resolveFrom(context), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))), child: Column(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(border: Border(bottom: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [CupertinoButton(padding: EdgeInsets.zero, child: const Text('Cancel'), onPressed: () => Navigator.pop(context)), Text(isBackground ? 'Background Color' : 'Brush Color', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)), CupertinoButton(padding: EdgeInsets.zero, child: const Text('Done'), onPressed: () { setState(() { if (isBackground) _currentNote.backgroundColor = pickerColor; else _selectedColor = pickerColor; }); Navigator.pop(context); })])), Container(margin: const EdgeInsets.all(20), height: 80, decoration: BoxDecoration(color: pickerColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 1), boxShadow: [BoxShadow(color: pickerColor.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)])), Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [ColorPicker(pickerColor: pickerColor, onColorChanged: (Color color) { pickerColor = color; (context as Element).markNeedsBuild(); }, colorPickerWidth: MediaQuery.of(context).size.width - 60, pickerAreaHeightPercent: 0.7, enableAlpha: false, displayThumbColor: true, paletteType: PaletteType.hsvWithHue, labelTypes: const [], pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(12))), const SizedBox(height: 24), BlockPicker(pickerColor: pickerColor, onColorChanged: (Color color) { pickerColor = color; (context as Element).markNeedsBuild(); }, availableColors: const [Colors.red, Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan, Colors.teal, Colors.green, Colors.lightGreen, Colors.lime, Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange, Colors.brown, Colors.grey, Colors.blueGrey, Colors.black, Colors.white], layoutBuilder: (context, colors, child) => GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 7, crossAxisSpacing: 8, mainAxisSpacing: 8, children: [for (Color color in colors) child(color)]), itemBuilder: (color, isCurrentColor, changeColor) => GestureDetector(onTap: changeColor, child: Container(decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: isCurrentColor ? CupertinoColors.activeBlue : CupertinoColors.separator.resolveFrom(context), width: isCurrentColor ? 3 : 1), boxShadow: isCurrentColor ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 1)] : [])))), const SizedBox(height: 20)])))])); });
  }
  void _showDateTimePicker(BuildContext context) { showCupertinoModalPopup(context: context, builder: (BuildContext context) => Container(height: 300, padding: const EdgeInsets.only(top: 6.0), margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), color: CupertinoColors.systemBackground.resolveFrom(context), child: SafeArea(top: false, child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [CupertinoButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()), CupertinoButton(child: const Text('Done'), onPressed: () { setState(() {}); Navigator.of(context).pop(); })]), Expanded(child: CupertinoDatePicker(mode: CupertinoDatePickerMode.dateAndTime, initialDateTime: _currentNote.lastModified, onDateTimeChanged: (DateTime newDateTime) { setState(() { _currentNote.lastModified = newDateTime; }); }))])))); }
  void _showOptionsMenu(BuildContext context, ThemeData theme, ColorScheme colorScheme) { showCupertinoModalPopup(context: context, builder: (BuildContext context) => CupertinoActionSheet(title: const Text("Options"), actions: <CupertinoActionSheetAction>[CupertinoActionSheetAction(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Hand Scroll: ', style: TextStyle(color: theme.textTheme.bodyMedium?.color)), Text(_pageScrollAxis == PageScrollAxis.horizontal ? 'Left/Right' : (_pageScrollAxis == PageScrollAxis.vertical ? 'Top/Bottom' : 'Off'), style: const TextStyle(fontWeight: FontWeight.bold))]), onPressed: () { Navigator.pop(context); _showScrollDirectionPicker(context); }), CupertinoActionSheetAction(child: const Text('Export as PDF'), onPressed: () { Navigator.pop(context); _exportToPdf(); }), CupertinoActionSheetAction(child: const Text('Note Info'), onPressed: () { Navigator.pop(context); _showNoteInfo(theme); }), CupertinoActionSheetAction(child: const Text('Clear All', style: TextStyle(color: CupertinoColors.destructiveRed)), onPressed: () { Navigator.pop(context); _showClearDialog(theme); })], cancelButton: CupertinoActionSheetAction(child: const Text('Cancel'), onPressed: () => Navigator.pop(context)))); }
  void _showScrollDirectionPicker(BuildContext context) { showCupertinoModalPopup(context: context, builder: (ctx) => CupertinoActionSheet(title: const Text('Page Scroll Direction (Hand Mode)'), actions: [CupertinoActionSheetAction(child: const Text('Horizontal (Left/Right)'), onPressed: () { setState(() => _pageScrollAxis = PageScrollAxis.horizontal); Navigator.pop(ctx); }), CupertinoActionSheetAction(child: const Text('Vertical (Top/Bottom)'), onPressed: () { setState(() => _pageScrollAxis = PageScrollAxis.vertical); Navigator.pop(ctx); }), CupertinoActionSheetAction(child: const Text('Off (Pan Only)'), onPressed: () { setState(() => _pageScrollAxis = PageScrollAxis.none); Navigator.pop(ctx); })], cancelButton: CupertinoActionSheetAction(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)))); }
  void _deleteText(String id) { setState(() { _textElements.removeWhere((t) => t.id == id); _selectedTextId = null; }); }
  void _showClearDialog(ThemeData theme) { showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(title: const Text('Clear Canvas?'), content: const Text('All drawings and text will be erased.'), actions: [CupertinoDialogAction(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)), CupertinoDialogAction(isDestructiveAction: true, onPressed: () { setState(() { _strokes.clear(); _redoStack.clear(); _textElements.clear(); }); Navigator.pop(ctx); }, child: const Text('Clear'))])); }
  void _showNoteInfo(ThemeData theme) { showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(title: const Text('Note Information'), content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 8), Text('Created: ${DateFormat('MMM d, y • h:mm a').format(_currentNote.createdAt)}'), const SizedBox(height: 4), Text('Strokes: ${_strokes.length}'), const SizedBox(height: 4), Text('Text Elements: ${_textElements.length}')]), actions: [CupertinoDialogAction(child: const Text('Close'), onPressed: () => Navigator.pop(ctx))])); }
}
