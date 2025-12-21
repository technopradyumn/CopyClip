import 'dart:async';
import 'dart:ui';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/glass_dialog.dart';

class JournalEditScreen extends StatefulWidget {
  final JournalEntry? entry;
  const JournalEditScreen({super.key, this.entry});

  @override
  State<JournalEditScreen> createState() => _JournalEditScreenState();
}

class _JournalSnapshot {
  final String title;
  final String content;
  final String mood;
  final List<String> tags;
  _JournalSnapshot(this.title, this.content, this.mood, this.tags);
}

class _JournalEditScreenState extends State<JournalEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  late DateTime _selectedDate;
  String _selectedMood = 'Neutral';
  bool _isFavorite = false;

  final List<_JournalSnapshot> _undoStack = [];
  final List<_JournalSnapshot> _redoStack = [];
  Timer? _debounceTimer;
  bool _isInternalUpdate = false;

  final List<String> _moods = ['Happy', 'Excited', 'Neutral', 'Sad', 'Stressed'];

  String _initialTitle = "";
  String _initialContent = "";

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _tagsController.text = widget.entry!.tags.join(', ');
      _selectedDate = widget.entry!.date;
      _selectedMood = widget.entry!.mood;
      _isFavorite = widget.entry!.isFavorite;
    } else {
      _selectedDate = DateTime.now();
    }

    _initialTitle = _titleController.text;
    _initialContent = _contentController.text;
    _undoStack.add(_JournalSnapshot(_titleController.text, _contentController.text, _selectedMood, []));

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_isInternalUpdate) return;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final t = _titleController.text;
      final c = _contentController.text;
      final tagString = _tagsController.text;
      final tagList = tagString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      if (_undoStack.isNotEmpty) {
        final last = _undoStack.last;
        if (last.title == t && last.content == c && last.mood == _selectedMood && last.tags.length == tagList.length) return;
      }
      if (mounted) {
        setState(() {
          _undoStack.add(_JournalSnapshot(t, c, _selectedMood, tagList));
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
      final prev = _undoStack.last;
      _titleController.text = prev.title;
      _contentController.text = prev.content;
      _selectedMood = prev.mood;
      _tagsController.text = prev.tags.join(', ');
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
      _selectedMood = next.mood;
      _tagsController.text = next.tags.join(', ');
      _isInternalUpdate = false;
    });
  }

  Future<bool> _onWillPop() async {
    if (_titleController.text != _initialTitle || _contentController.text != _initialContent) {
      final result = await showDialog<String>(
        context: context,
        builder: (ctx) => GlassDialog(
          title: "Unsaved Changes",
          content: "Save changes?",
          confirmText: "Save",
          cancelText: "Discard",
          onConfirm: () => Navigator.pop(ctx, 'save'),
          onCancel: () => Navigator.pop(ctx, 'discard'),
        ),
      );

      if (result == 'save') _saveEntry();
      if (result == 'discard') return true;
      return result != null;
    }
    return true;
  }

  void _saveEntry() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (content.isEmpty && title.isEmpty) return;

    final List<String> tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final box = Hive.box<JournalEntry>('journal_box');
    if (widget.entry != null) {
      widget.entry!.title = title;
      widget.entry!.content = content;
      widget.entry!.date = _selectedDate;
      widget.entry!.mood = _selectedMood;
      widget.entry!.tags = tags;
      widget.entry!.isFavorite = _isFavorite;
      widget.entry!.save();
    } else {
      box.add(JournalEntry(
        id: const Uuid().v4(),
        title: title,
        content: content,
        date: _selectedDate,
        mood: _selectedMood,
        tags: tags,
        isFavorite: _isFavorite,
      ));
    }
    _initialTitle = title;
    _initialContent = content;
  }

  void _deleteEntry() {
    widget.entry?.delete();
    context.pop();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: "${_titleController.text}\n\n${_contentController.text}"));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Copied",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      behavior: SnackBarBehavior.floating,)
    );
  }

  void _shareEntry() {
    Share.share("${_titleController.text}\n\n${_contentController.text}");
  }

  Future<void> _pickDate() async {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Theme.of(context).colorScheme.surface, // Use theme surface
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => Navigator.pop(context), child: Text("Done", style: TextStyle(color: Theme.of(context).colorScheme.primary))),
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

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Happy': return '😊';
      case 'Excited': return '🤩';
      case 'Neutral': return '😐';
      case 'Sad': return '😔';
      case 'Stressed': return '😫';
      default: return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = widget.entry != null ? 'journal_bg_${widget.entry!.id}' : 'journal_new';
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final dividerColor = Theme.of(context).dividerColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textTheme = Theme.of(context).textTheme;
    final errorColor = Theme.of(context).colorScheme.error;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GlassScaffold(
        showBackArrow: true,
        title: widget.entry == null ? 'New Entry' : 'Edit Entry',
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.star : Icons.star_border, color: _isFavorite ? Colors.amberAccent : onSurfaceColor.withOpacity(0.6)),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          IconButton(icon: Icon(Icons.copy, color: onSurfaceColor.withOpacity(0.6)), onPressed: _copyToClipboard),
          IconButton(icon: Icon(Icons.share, color: onSurfaceColor.withOpacity(0.6)), onPressed: _shareEntry),
          if (widget.entry != null)
            IconButton(icon: Icon(Icons.delete_outline, color: errorColor), onPressed: _deleteEntry),
          IconButton(
            icon: Icon(Icons.check, color: primaryColor),
            onPressed: () {
              _saveEntry();
              context.pop();
            },
          ),
        ],
        body: Column(
          children: [
            // Top Controls (Date, Mood, Undo/Redo)
            Padding(
              padding: const EdgeInsets.only(top: 90, left: 16.0, right: 16.0, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Date Chip
                      GestureDetector(
                        onTap: _pickDate,
                        child: GlassContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          opacity: 0.1,
                          borderRadius: 20,
                          child: Row(children: [
                            const Icon(Icons.calendar_today, size: 12, color: Colors.blueAccent),
                            const SizedBox(width: 6),
                            Text(DateFormat('MMM dd, h:mm a').format(_selectedDate), style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.7))),
                          ]),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Undo/Redo
                      IconButton(icon: Icon(Icons.undo, size: 20, color: _undoStack.length > 1 ? onSurfaceColor : onSurfaceColor.withOpacity(0.24)), onPressed: _undoStack.length > 1 ? _undo : null, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                      IconButton(icon: Icon(Icons.redo, size: 20, color: _redoStack.isNotEmpty ? onSurfaceColor : onSurfaceColor.withOpacity(0.24)), onPressed: _redoStack.isNotEmpty ? _redo : null, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                    ],
                  ),
                ],
              ),
            ),

            // Mood Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedMood = mood);
                      _onTextChanged();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor.withOpacity(0.3) : surfaceColor.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: primaryColor) : null,
                      ),
                      child: Text(_getMoodEmoji(mood), style: const TextStyle(fontSize: 22)),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Editor
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Hero(
                  tag: heroTag,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: onSurfaceColor),
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: textTheme.headlineSmall?.copyWith(color: onSurfaceColor.withOpacity(0.24)),
                            border: InputBorder.none,
                          ),
                        ),
                        // Tag Input
                        TextField(
                          controller: _tagsController,
                          style: textTheme.bodyMedium?.copyWith(color: primaryColor),
                          decoration: InputDecoration(
                            hintText: '#Tags (comma separated)...',
                            hintStyle: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.12)),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.tag, size: 16, color: onSurfaceColor.withOpacity(0.24)),
                            prefixIconConstraints: const BoxConstraints(minWidth: 20),
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                        Divider(color: dividerColor),
                        Expanded(
                          child: TextField(
                            controller: _contentController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor.withOpacity(0.8), height: 1.6),
                            decoration: InputDecoration(
                              hintText: 'What\'s on your mind?',
                              hintStyle: textTheme.bodyLarge?.copyWith(color: onSurfaceColor.withOpacity(0.24)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
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