import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import '../../data/canvas_adapter.dart';

enum BrushShape { round, square, marker, calligraphy, pencil, pen, highlighter, spray }

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

  // Drawing state
  bool _isDrawingMode = true;
  bool _isTextMode = false;
  bool _isShapeMode = false;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  double _eraserSize = 20.0;
  bool _isErasing = false;
  BrushShape _brushShape = BrushShape.round;

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
      _strokes = List.from(_currentNote.strokes);
    } else {
      _currentNote = CanvasNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Untitled Note',
        folderId: widget.folderId ?? 'default',
      );
      _titleController = TextEditingController(text: 'Untitled Note');
    }
  }

  void _saveNote() async {
    _currentNote.title = _titleController.text.isEmpty
        ? 'Untitled Note'
        : _titleController.text;
    _currentNote.strokes = _strokes;
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
      _selectedTextId = null;
    });
  }

  void _addNewText() {
    // Add text in center of visible canvas area
    final centerX = (MediaQuery.of(context).size.width / 2 - _panOffset.dx) / _zoomLevel;
    final centerY = (MediaQuery.of(context).size.height / 2 - _panOffset.dy) / _zoomLevel;

    setState(() {
      final newText = CanvasText(
        id: DateTime.now().toString(),
        text: 'Type here...',
        position: Offset(centerX - 75, centerY - 25), // Center the default text box
        color: _selectedColor,
        fontSize: 20,
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
            icon: Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () {
              _saveNote();
              context.pop();
            },
            padding: EdgeInsets.all(8),
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
                    contentPadding: EdgeInsets.symmetric(
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
                  icon: Icon(Icons.zoom_out, size: 18),
                  onPressed: () => setState(
                        () => _zoomLevel = (_zoomLevel - 0.2).clamp(0.5, 3.0),
                  ),
                  padding: EdgeInsets.all(6),
                  constraints: BoxConstraints(),
                ),
                Text(
                  '${(_zoomLevel * 100).toInt()}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.zoom_in, size: 18),
                  onPressed: () => setState(
                        () => _zoomLevel = (_zoomLevel + 0.2).clamp(0.5, 3.0),
                  ),
                  padding: EdgeInsets.all(6),
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, size: 20),
            onPressed: () => _showOptionsMenu(context, theme, colorScheme),
            padding: EdgeInsets.all(8),
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
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                if (!_isDrawingMode && !_isTextMode) {
                  setState(() {
                    _panOffset += details.delta;
                    _panOffset = _clampOffset(_panOffset);
                  });
                }
              },
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
                          painter: DrawingPainter(_strokes),
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
                        if (_isDrawingMode)
                          GestureDetector(
                            onPanDown: (details) {
                              setState(() {
                                _redoStack.clear();
                                _strokes.add(
                                  DrawingStroke(
                                    points: [
                                      (details.localPosition.dx - _panOffset.dx) / _zoomLevel,
                                      (details.localPosition.dy - _panOffset.dy) / _zoomLevel,
                                    ],
                                    color: _isErasing
                                        ? _currentNote.backgroundColor.value
                                        : _selectedColor.value,
                                    strokeWidth: _isErasing ? _eraserSize : _strokeWidth,
                                    penType: _isErasing ? 0 : _brushShape.index,
                                  ),
                                );
                              });
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                if (_strokes.isNotEmpty) {
                                  _strokes.last.points.addAll([
                                    (details.localPosition.dx - _panOffset.dx) / _zoomLevel,
                                    (details.localPosition.dy - _panOffset.dy) / _zoomLevel,
                                  ]);
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
            // Floating Add Text Button (only show in text mode when no text is selected)
            if (_isTextMode && _selectedTextId == null)
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTextId = isSelected ? null : text.id;
        });
      },
      onPanUpdate: isSelected ? (details) {
        setState(() {
          text.position += details.delta / _zoomLevel;
        });
      } : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            constraints: BoxConstraints(
              minWidth: text.containerWidth,
              minHeight: text.containerHeight,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary.withOpacity(0.8)
                    : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: TextField(
                  controller: TextEditingController(text: text.text)
                    ..selection = TextSelection.collapsed(offset: text.text.length),
                  enabled: isSelected,
                  maxLines: null,
                  style: TextStyle(
                    color: text.color,
                    fontSize: text.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    text.text = value;
                  },
                  onTap: () {
                    setState(() {
                      _selectedTextId = text.id;
                    });
                  },
                ),
              ),
            ),
          ),
          // Delete button (top-right)
          if (isSelected)
            Positioned(
              top: -10,
              right: -10,
              child: GestureDetector(
                onTap: () => _deleteText(text.id),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Resize handle (bottom-right)
          if (isSelected)
            Positioned(
              bottom: -10,
              right: -10,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // Resize container
                    text.containerWidth = (text.containerWidth + details.delta.dx / _zoomLevel)
                        .clamp(50.0, 500.0);
                    text.containerHeight = (text.containerHeight + details.delta.dy / _zoomLevel)
                        .clamp(30.0, 500.0);

                    // Also increase font size proportionally
                    final sizeDelta = (details.delta.dx + details.delta.dy) / 2;
                    text.fontSize = (text.fontSize + sizeDelta / (_zoomLevel * 10))
                        .clamp(10.0, 100.0);
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_outward,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Zoom in/out buttons (top-left and below it)
          if (isSelected)
            Positioned(
              top: -10,
              left: -10,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        text.fontSize = (text.fontSize + 2).clamp(10.0, 100.0);
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        text.fontSize = (text.fontSize - 2).clamp(10.0, 100.0);
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Offset _clampOffset(Offset offset) {
    final maxX = ((_zoomLevel - 1.0) * 200).abs();
    final maxY = ((_zoomLevel - 1.0) * 200).abs();
    return Offset(offset.dx.clamp(-maxX, maxX), offset.dy.clamp(-maxY, maxY));
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
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              _buildToolButton(Icons.edit, _isDrawingMode && !_isErasing, () {
                setState(() {
                  _isDrawingMode = true;
                  _isTextMode = false;
                  _isShapeMode = false;
                  _isErasing = false;
                  _selectedTextId = null;
                });
              }, colorScheme),
              _buildToolButton(Icons.cleaning_services, _isErasing, () {
                setState(() {
                  _isDrawingMode = true;
                  _isErasing = true;
                  _isTextMode = false;
                  _isShapeMode = false;
                  _selectedTextId = null;
                });
              }, colorScheme),
              _buildToolButton(Icons.text_fields, _isTextMode, () {
                _enableTextMode();
              }, colorScheme),
              SizedBox(width: 8),
              Container(width: 1, height: 24, color: colorScheme.outline.withOpacity(0.2)),
              SizedBox(width: 8),
              if (!_isErasing)
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
              if (!_isErasing) SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isErasing ? Icons.cleaning_services : Icons.line_weight,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  SizedBox(
                    width: 100,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 2,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      ),
                      child: Slider(
                        value: _isErasing ? _eraserSize : _strokeWidth,
                        min: _isErasing ? 5 : 1,
                        max: _isErasing ? 50 : 15,
                        onChanged: (val) => setState(() {
                          if (_isErasing) {
                            _eraserSize = val;
                          } else {
                            _strokeWidth = val;
                          }
                        }),
                      ),
                    ),
                  ),
                  Text(
                    '${_isErasing ? _eraserSize.toInt() : _strokeWidth.toInt()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: () => _showAdvancedColorPicker(isBackground: false),
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
                onTap: () => _showAdvancedColorPicker(isBackground: true),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _currentNote.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.3), width: 1.5),
                  ),
                  child: Icon(Icons.format_color_fill, size: 16, color: Colors.white),
                ),
              ),
              SizedBox(width: 8),
              _buildToolButton(
                Icons.undo,
                false,
                _strokes.isEmpty ? () {} : _undo,
                colorScheme,
                enabled: _strokes.isNotEmpty,
              ),
              _buildToolButton(
                Icons.redo,
                false,
                _redoStack.isEmpty ? () {} : _redo,
                colorScheme,
                enabled: _redoStack.isNotEmpty,
              ),
              _buildToolButton(Icons.delete_outline, false, () {
                _showClearDialog(theme);
              }, colorScheme),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _saveNote();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Saved'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
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
                      SizedBox(width: 4),
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
    switch (_brushShape) {
      case BrushShape.round:
        return Icons.circle_outlined;
      case BrushShape.square:
        return Icons.square_outlined;
      case BrushShape.marker:
        return Icons.brush;
      case BrushShape.calligraphy:
        return Icons.edit_outlined;
      case BrushShape.pencil:
        return Icons.create;
      case BrushShape.pen:
        return Icons.mode_edit_outline;
      case BrushShape.highlighter:
        return Icons.highlight;
      case BrushShape.spray:
        return Icons.water_drop_outlined;
    }
  }

  String _getBrushName(BrushShape shape) {
    switch (shape) {
      case BrushShape.round:
        return 'Round';
      case BrushShape.square:
        return 'Square';
      case BrushShape.marker:
        return 'Marker';
      case BrushShape.calligraphy:
        return 'Calligraphy';
      case BrushShape.pencil:
        return 'Pencil';
      case BrushShape.pen:
        return 'Pen';
      case BrushShape.highlighter:
        return 'Highlighter';
      case BrushShape.spray:
        return 'Spray';
    }
  }

  void _showBrushGrid(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Brush',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: BrushShape.values.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final brush = BrushShape.values[index];
                    final isSelected = _brushShape == brush;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _brushShape = brush);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withOpacity(0.2)
                              : colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getBrushIconForShape(brush),
                              size: 28,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withOpacity(0.7),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _getBrushName(brush),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.onSurface.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getBrushIconForShape(BrushShape shape) {
    switch (shape) {
      case BrushShape.round:
        return Icons.circle_outlined;
      case BrushShape.square:
        return Icons.square_outlined;
      case BrushShape.marker:
        return Icons.brush;
      case BrushShape.calligraphy:
        return Icons.edit_outlined;
      case BrushShape.pencil:
        return Icons.create;
      case BrushShape.pen:
        return Icons.mode_edit_outline;
      case BrushShape.highlighter:
        return Icons.highlight;
      case BrushShape.spray:
        return Icons.water_drop_outlined;
    }
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      isBackground ? 'Background Color' : 'Brush Color',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text('Done'),
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
                margin: EdgeInsets.all(20),
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                      SizedBox(height: 24),
                      Container(
                        height: 1,
                        color: CupertinoColors.separator.resolveFrom(context),
                        margin: EdgeInsets.symmetric(vertical: 12),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Quick Colors',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
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
                            physics: NeverScrollableScrollPhysics(),
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
                      SizedBox(height: 20),
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
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text('Done'),
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
            child: Text('Reset Zoom'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _zoomLevel = 1.0;
                _panOffset = Offset.zero;
              });
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Note Info'),
            onPressed: () {
              Navigator.pop(context);
              _showNoteInfo(theme);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Clear All', style: TextStyle(color: CupertinoColors.destructiveRed)),
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
          child: Text('Cancel'),
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
        title: Text('Clear Canvas?'),
        content: Text('All drawings and text will be erased.'),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
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
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showNoteInfo(ThemeData theme) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text('Note Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text('Created: ${DateFormat('MMM d, y • h:mm a').format(_currentNote.createdAt)}'),
            SizedBox(height: 4),
            Text('Strokes: ${_strokes.length}'),
            SizedBox(height: 4),
            Text('Text Elements: ${_textElements.length}'),
            SizedBox(height: 4),
            Text('Zoom: ${(_zoomLevel * 100).toStringAsFixed(0)}%'),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('Close'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }
}

// Drawing Painter with Brush Shapes
class DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;

  DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      final paint = Paint()
        ..color = Color(stroke.color)
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final brushShape = BrushShape.values[stroke.penType.clamp(0, BrushShape.values.length - 1)];

      if (stroke.strokeWidth < 20) {
        switch (brushShape) {
          case BrushShape.round:
            paint.strokeCap = StrokeCap.round;
            break;
          case BrushShape.square:
            paint.strokeCap = StrokeCap.square;
            break;
          case BrushShape.marker:
            paint.strokeCap = StrokeCap.round;
            paint.color = paint.color.withOpacity(0.7);
            break;
          case BrushShape.calligraphy:
            paint.strokeCap = StrokeCap.square;
            break;
          case BrushShape.pencil:
            paint.strokeCap = StrokeCap.round;
            paint.color = paint.color.withOpacity(0.8);
            break;
          case BrushShape.pen:
            paint.strokeCap = StrokeCap.round;
            break;
          case BrushShape.highlighter:
            paint.strokeCap = StrokeCap.square;
            paint.color = paint.color.withOpacity(0.4);
            break;
          case BrushShape.spray:
            paint.strokeCap = StrokeCap.round;
            paint.color = paint.color.withOpacity(0.6);
            break;
        }
      } else {
        paint.strokeCap = StrokeCap.round;
      }

      for (int i = 0; i < stroke.points.length - 2; i += 2) {
        if (brushShape == BrushShape.calligraphy && stroke.strokeWidth < 20) {
          final dx = stroke.points[i + 2] - stroke.points[i];
          final dy = stroke.points[i + 3] - stroke.points[i + 1];
          final angle = atan2(dy, dx);

          final path = Path();
          final width = stroke.strokeWidth;
          final halfWidth = width / 2;

          path.moveTo(
            stroke.points[i] - sin(angle) * halfWidth,
            stroke.points[i + 1] + cos(angle) * halfWidth,
          );
          path.lineTo(
            stroke.points[i + 2] - sin(angle) * halfWidth,
            stroke.points[i + 3] + cos(angle) * halfWidth,
          );
          path.lineTo(
            stroke.points[i + 2] + sin(angle) * halfWidth * 0.3,
            stroke.points[i + 3] - cos(angle) * halfWidth * 0.3,
          );
          path.lineTo(
            stroke.points[i] + sin(angle) * halfWidth * 0.3,
            stroke.points[i + 1] - cos(angle) * halfWidth * 0.3,
          );
          path.close();

          canvas.drawPath(path, paint..style = PaintingStyle.fill);
        } else if (brushShape == BrushShape.spray && stroke.strokeWidth < 20) {
          final random = Random(i);
          for (int j = 0; j < 3; j++) {
            final offsetX = (random.nextDouble() - 0.5) * stroke.strokeWidth;
            final offsetY = (random.nextDouble() - 0.5) * stroke.strokeWidth;
            canvas.drawCircle(
              Offset(stroke.points[i] + offsetX, stroke.points[i + 1] + offsetY),
              stroke.strokeWidth * 0.15,
              paint,
            );
          }
        } else {
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
  bool shouldRepaint(DrawingPainter oldDelegate) => oldDelegate.strokes != strokes;
}

// Canvas Text Model - Updated with container size properties
class CanvasText {
  final String id;
  String text;
  Offset position;
  final Color color;
  double fontSize;
  double containerWidth;
  double containerHeight;

  CanvasText({
    required this.id,
    required this.text,
    required this.position,
    required this.color,
    required this.fontSize,
    this.containerWidth = 150.0,
    this.containerHeight = 50.0,
  });
}