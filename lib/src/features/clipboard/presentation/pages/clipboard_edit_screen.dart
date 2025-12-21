import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';

import '../../data/clipboard_model.dart';

class ClipboardEditScreen extends StatefulWidget {
  final ClipboardItem? item;
  const ClipboardEditScreen({super.key, this.item});

  @override
  State<ClipboardEditScreen> createState() => _ClipboardEditScreenState();
}

// Snapshot class for Undo/Redo
class _ClipboardSnapshot {
  final String content;
  _ClipboardSnapshot(this.content);
}

class _ClipboardEditScreenState extends State<ClipboardEditScreen> {
  final _controller = TextEditingController();
  late DateTime _selectedDate;
  late Box<ClipboardItem> _clipboardBox;

  // Undo/Redo State
  final List<_ClipboardSnapshot> _undoStack = [];
  final List<_ClipboardSnapshot> _redoStack = [];
  Timer? _debounceTimer;
  bool _isInternalUpdate = false;
  String _initialContent = "";

  @override
  void initState() {
    super.initState();
    _clipboardBox = Hive.box<ClipboardItem>('clipboard_box');

    if (widget.item != null) {
      _controller.text = widget.item!.content;
      _selectedDate = widget.item!.createdAt;
    } else {
      _selectedDate = DateTime.now();
    }

    _initialContent = _controller.text;
    _undoStack.add(_ClipboardSnapshot(_controller.text));

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // --- UNDO / REDO LOGIC ---

  void _onTextChanged() {
    if (_isInternalUpdate) return;

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final currentContent = _controller.text;

      if (_undoStack.isNotEmpty) {
        if (_undoStack.last.content == currentContent) return;
      }

      if (mounted) {
        setState(() {
          _undoStack.add(_ClipboardSnapshot(currentContent));
          _redoStack.clear();
        });
      }
    });
  }

  void _undo() {
    if (_undoStack.length <= 1) return;
    setState(() {
      _isInternalUpdate = true;
      _redoStack.add(_undoStack.removeLast());
      final previous = _undoStack.last;
      _controller.text = previous.content;
      _isInternalUpdate = false;
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _isInternalUpdate = true;
      final next = _redoStack.removeLast();
      _undoStack.add(next);
      _controller.text = next.content;
      _isInternalUpdate = false;
    });
  }

  // --- NAVIGATION GUARD ---

  Future<bool> _onWillPop() async {
    final isDirty = _controller.text != _initialContent;

    if (!isDirty) return true;
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Unsaved Changes",
        content: "Do you want to save your clip before leaving?",
        confirmText: "Save",
        cancelText: "Discard",
        onConfirm: () => Navigator.pop(ctx, 'save'),
        onCancel: () => Navigator.pop(ctx, 'discard'),
      ),
    );

    if (result == 'save') {
      _save();
      return true;
    } else if (result == 'discard') {
      return true;
    }
    return false;
  }

  // --- DATE PICKER ---

  void _pickDateTime() {
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

  // --- ACTIONS ---

  void _save() {
    if (_controller.text.isEmpty) return;

    final id = widget.item?.id ?? const Uuid().v4();
    final type = _detectType(_controller.text);

    final newItem = ClipboardItem(
      id: id,
      content: _controller.text,
      createdAt: _selectedDate,
      type: type,
      sortIndex: widget.item?.sortIndex ?? 0,
    );

    _clipboardBox.put(id, newItem);
    _initialContent = _controller.text;
  }

  String _detectType(String text) {
    if (text.startsWith('http')) return 'link';
    if (RegExp(r'^\+?[0-9]{7,15}$').hasMatch(text)) return 'phone';
    if (text.startsWith('#') || text.startsWith('Color')) return 'color';
    return 'text';
  }

  void _delete() {
    if (widget.item != null) {
      _clipboardBox.delete(widget.item!.id);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = widget.item != null ? 'clip_bg_${widget.item!.id}' : 'new_clip';

    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final errorColor = Theme.of(context).colorScheme.error;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final dividerColor = Theme.of(context).dividerColor;
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GlassScaffold(
        showBackArrow: true,
        title: widget.item == null ? 'New Clip' : 'Edit Clip',
        actions: [
          IconButton(
            icon: Icon(Icons.copy, color: onSurfaceColor.withOpacity(0.54)),
            tooltip: 'Copy',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _controller.text));
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Copied"), behavior: SnackBarBehavior.floating)
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: onSurfaceColor.withOpacity(0.54)),
            tooltip: 'Share',
            onPressed: () => Share.share(_controller.text),
          ),
          if (widget.item != null)
            IconButton(
              icon: Icon(Icons.delete_outline, color: errorColor),
              tooltip: 'Delete',
              onPressed: _delete,
            ),
          IconButton(
            icon: Icon(Icons.check, color: primaryColor),
            tooltip: 'Save',
            onPressed: () {
              _save();
              context.pop();
            },
          ),
        ],
        body: Column(
          children: [
            // --- TOP BAR (Date + Undo/Redo) ---
            Padding(
              padding: const EdgeInsets.only(top: 90, left: 16.0, right: 16.0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _pickDateTime,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: surfaceColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: dividerColor.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_filled, size: 14, color: primaryColor),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('MMM dd, h:mm a').format(_selectedDate),
                                style: textTheme.bodySmall?.copyWith(
                                  color: onSurfaceColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.undo,
                          color: _undoStack.length > 1 ? onSurfaceColor : onSurfaceColor.withOpacity(0.3),
                        ),
                        onPressed: _undoStack.length > 1 ? _undo : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.redo,
                          color: _redoStack.isNotEmpty ? onSurfaceColor : onSurfaceColor.withOpacity(0.3),
                        ),
                        onPressed: _redoStack.isNotEmpty ? _redo : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- EDITOR AREA ---
            Expanded(
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: surfaceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            surfaceColor.withOpacity(0.15),
                            surfaceColor.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Material(
                          type: MaterialType.transparency,
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: textTheme.bodyLarge?.copyWith(
                              color: onSurfaceColor.withOpacity(0.9),
                              height: 1.6,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Paste or type content here...',
                              hintStyle: textTheme.bodyLarge?.copyWith(
                                color: onSurfaceColor.withOpacity(0.24),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}