import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../data/note_model.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;

  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteSnapshot {
  final String title;
  final String content;

  _NoteSnapshot(this.title, this.content);
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  late DateTime _selectedDate;
  late Box<Note> _notesBox;

  final List<_NoteSnapshot> _undoStack = [];
  final List<_NoteSnapshot> _redoStack = [];
  Timer? _debounceTimer;
  bool _isInternalUpdate = false;

  String _initialTitle = "";
  String _initialContent = "";

  @override
  void initState() {
    super.initState();
    _notesBox = Hive.box<Note>('notes_box');

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedDate = widget.note!.updatedAt;
    } else {
      _selectedDate = DateTime.now();
    }

    _initialTitle = _titleController.text;
    _initialContent = _contentController.text;
    _undoStack.add(
      _NoteSnapshot(_titleController.text, _contentController.text),
    );

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_isInternalUpdate) return;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final currentTitle = _titleController.text;
      final currentContent = _contentController.text;
      if (_undoStack.isNotEmpty) {
        final last = _undoStack.last;
        if (last.title == currentTitle && last.content == currentContent)
          return;
      }
      if (mounted) {
        setState(() {
          _undoStack.add(_NoteSnapshot(currentTitle, currentContent));
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
      _titleController.text = previous.title;
      _contentController.text = previous.content;
      _isInternalUpdate = false;
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _isInternalUpdate = true;
      final next = _redoStack.removeLast();
      _undoStack.add(next);
      _titleController.text = next.title;
      _contentController.text = next.content;
      _isInternalUpdate = false;
    });
  }

  Future<bool> _onWillPop() async {
    final isDirty =
        _titleController.text != _initialTitle ||
        _contentController.text != _initialContent;

    if (!isDirty) return true;
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Unsaved Changes",
        content: "Do you want to save your note before leaving?",
        confirmText: "Save",
        cancelText: "Discard",
        onConfirm: () => Navigator.pop(ctx, 'save'),
        onCancel: () => Navigator.pop(ctx, 'discard'),
      ),
    );
    if (result == 'save') {
      _saveNote();
      return true;
    } else if (result == 'discard') {
      return true;
    }
    return false;
  }

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

  void _copyToClipboard() {
    final text = "${_titleController.text}\n\n${_contentController.text}";
    if (text.trim().isEmpty) return;

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Copied to clipboard",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Theme.of(context).colorScheme.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareNote() {
    final text = "${_titleController.text}\n\n${_contentController.text}";
    if (text.trim().isEmpty) return;
    Share.share(text);
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    if (widget.note != null) {
      widget.note!.title = title;
      widget.note!.content = content;
      widget.note!.updatedAt = _selectedDate;
      widget.note!.save();
    } else {
      final newNote = Note(
        id: const Uuid().v4(),
        title: title.isEmpty ? 'Untitled' : title,
        content: content,
        updatedAt: _selectedDate,
      );
      _notesBox.put(newNote.id, newNote);
    }
    _initialTitle = _titleController.text;
    _initialContent = _contentController.text;
  }

  void _deleteNote() {
    if (widget.note != null) {
      _notesBox.delete(widget.note!.id);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = widget.note != null
        ? 'note_background_${widget.note!.id}'
        : 'fab_new_note';
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
        title: widget.note == null ? 'New Note' : 'Edit Note',
        actions: [
          IconButton(
            icon: Icon(Icons.copy, color: onSurfaceColor.withOpacity(0.54)),
            onPressed: _copyToClipboard,
            tooltip: 'Copy',
          ),
          IconButton(
            icon: Icon(Icons.share, color: onSurfaceColor.withOpacity(0.54)),
            onPressed: _shareNote,
            tooltip: 'Share',
          ),
          if (widget.note != null)
            IconButton(
              icon: Icon(Icons.delete_outline, color: errorColor),
              onPressed: _deleteNote,
              tooltip: 'Delete',
            ),
          IconButton(
            icon: Icon(Icons.check, color: primaryColor),
            onPressed: () {
              _saveNote();
              context.pop();
            },
            tooltip: 'Save',
          ),
        ],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 90,
                left: 16.0,
                right: 16.0,
                bottom: 0,
              ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: dividerColor.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                size: 14,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat(
                                  'MMM dd, h:mm a',
                                ).format(_selectedDate),
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
                          color: _undoStack.length > 1
                              ? onSurfaceColor
                              : onSurfaceColor.withOpacity(0.3),
                        ),
                        onPressed: _undoStack.length > 1 ? _undo : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.redo,
                          color: _redoStack.isNotEmpty
                              ? onSurfaceColor
                              : onSurfaceColor.withOpacity(0.3),
                        ),
                        onPressed: _redoStack.isNotEmpty ? _redo : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),

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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          bool hasEnoughSpace = constraints.maxHeight > 200;
                          if (hasEnoughSpace) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTitleField(onSurfaceColor, textTheme),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Divider(
                                    color: dividerColor,
                                    height: 24,
                                  ),
                                ),
                                Expanded(
                                  child: _buildContentField(
                                    true,
                                    onSurfaceColor,
                                    textTheme,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTitleField(onSurfaceColor, textTheme),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Divider(
                                      color: dividerColor,
                                      height: 24,
                                    ),
                                  ),
                                  _buildContentField(
                                    false,
                                    onSurfaceColor,
                                    textTheme,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
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

  Widget _buildTitleField(Color onSurfaceColor, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Material(
        type: MaterialType.transparency,
        child: TextField(
          controller: _titleController,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: onSurfaceColor,
          ),
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: textTheme.headlineSmall?.copyWith(
              color: onSurfaceColor.withOpacity(0.24),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildContentField(
    bool expand,
    Color onSurfaceColor,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Material(
        type: MaterialType.transparency,
        child: TextField(
          controller: _contentController,
          maxLines: null,
          minLines: expand ? null : 5,
          expands: expand,
          textAlignVertical: TextAlignVertical.top,
          style: textTheme.bodyLarge?.copyWith(
            color: onSurfaceColor.withOpacity(0.8),
            height: 1.6,
          ),
          decoration: InputDecoration(
            hintText: 'Start typing...',
            hintStyle: textTheme.bodyLarge?.copyWith(
              color: onSurfaceColor.withOpacity(0.24),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
