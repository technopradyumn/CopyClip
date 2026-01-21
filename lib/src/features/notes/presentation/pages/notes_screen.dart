import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

// Core
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';

// Data
import '../../data/note_model.dart';

// Widgets
import '../widgets/note_card.dart';

enum NoteSortOption { custom, dateNewest, dateOldest, titleAZ, titleZA }

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // UI Controllers
  final TextEditingController _searchController = TextEditingController();

  // ✅ PERFORMANCE: Notifier isolates list updates from the rest of the UI
  final ValueNotifier<List<Note>> _filteredNotesNotifier = ValueNotifier([]);

  // Data State
  List<Note> _rawNotes = [];
  bool _isSelectionMode = false;
  final Set<String> _selectedNoteIds = {};

  // Filter State
  String _searchQuery = "";
  NoteSortOption _currentSort = NoteSortOption.custom;

  @override
  void initState() {
    super.initState();
    _ensureBoxLoaded();

    // Listen for Search efficiently
    _searchController.addListener(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  /// ✅ OPTIMIZATION: Ensure box is loaded before use
  Future<void> _ensureBoxLoaded() async {
    await LazyBoxLoader.getBox<Note>('notes_box');
    if (mounted) {
      _refreshNotes();
      // Listen to DB changes to keep list in sync
      Hive.box<Note>('notes_box').listenable().addListener(_refreshNotes);
    }
  }

  @override
  void dispose() {
    Hive.box<Note>('notes_box').listenable().removeListener(_refreshNotes);
    _searchController.dispose();
    _filteredNotesNotifier.dispose();
    super.dispose();
  }

  // --- DATA LOGIC ---

  void _refreshNotes() {
    if (!Hive.isBoxOpen('notes_box')) return;
    final box = Hive.box<Note>('notes_box');

    // Get all non-deleted notes
    _rawNotes = box.values.where((n) => !n.isDeleted).toList();
    _applyFilters();
  }

  void _applyFilters() {
    List<Note> result = List.from(_rawNotes);

    // 1. Search Filter
    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (n) =>
                n.title.toLowerCase().contains(_searchQuery) ||
                n.content.toLowerCase().contains(_searchQuery),
          )
          .toList();
    }

    // 2. Sort
    switch (_currentSort) {
      case NoteSortOption.dateNewest:
        result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case NoteSortOption.dateOldest:
        result.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case NoteSortOption.titleAZ:
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case NoteSortOption.titleZA:
        result.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
      case NoteSortOption.custom:
        result.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
        break;
    }

    // Update the UI
    _filteredNotesNotifier.value = result;
  }

  // --- ACTIONS ---

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    final currentList = List<Note>.from(_filteredNotesNotifier.value);
    final item = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, item);

    // Update UI immediately for smoothness
    _filteredNotesNotifier.value = currentList;

    // Update Database in background
    for (int i = 0; i < currentList.length; i++) {
      currentList[i].sortIndex = i;
      currentList[i].save();
    }
  }

  void _copyNote(Note note) {
    try {
      final List<dynamic> delta = jsonDecode(note.content);
      String clean = "";
      for (var op in delta) {
        if (op is Map && op['insert'] is String) clean += op['insert'];
      }
      Clipboard.setData(ClipboardData(text: clean.trim()));
    } catch (_) {
      Clipboard.setData(ClipboardData(text: note.content));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Content copied"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareNote(Note note) {
    try {
      final List<dynamic> delta = jsonDecode(note.content);
      String clean = "";
      for (var op in delta) {
        if (op is Map && op['insert'] is String) clean += op['insert'];
      }
      Share.share(clean.trim());
    } catch (_) {
      Share.share(note.content);
    }
  }

  void _confirmDeleteNote(Note note) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move to Bin?",
        content: "You can restore this note later.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          note.isDeleted = true;
          note.deletedAt = DateTime.now();
          note.save();
        },
      ),
    );
  }

  void _deleteSelected() {
    final now = DateTime.now();
    for (var id in _selectedNoteIds) {
      try {
        final note = _rawNotes.firstWhere((n) => n.id == id);
        note.isDeleted = true;
        note.deletedAt = now;
        note.save();
      } catch (_) {}
    }
    setState(() {
      _selectedNoteIds.clear();
      _isSelectionMode = false;
    });
  }

  void _deleteAll() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete All?",
        content: "Move all notes to Recycle Bin?",
        confirmText: "Delete All",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          final now = DateTime.now();
          for (var n in _rawNotes) {
            n.isDeleted = true;
            n.deletedAt = now;
            n.save();
          }
        },
      ),
    );
  }

  void _openNoteEditor(Note? note) {
    if (_isSelectionMode) {
      if (note != null) _toggleSelection(note.id);
      return;
    }
    context.push(AppRouter.noteEdit, extra: note);
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedNoteIds.contains(id))
        _selectedNoteIds.remove(id);
      else
        _selectedNoteIds.add(id);
      if (_selectedNoteIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedNoteIds.length == _filteredNotesNotifier.value.length) {
        _selectedNoteIds.clear();
      } else {
        _selectedNoteIds.addAll(_filteredNotesNotifier.value.map((e) => e.id));
      }
    });
  }

  // --- UI BUILDERS ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;

    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          setState(() {
            _isSelectionMode = false;
            _selectedNoteIds.clear();
          });
          return false;
        }
        return true;
      },
      child: GlassScaffold(
        title: null,
        floatingActionButton: _isSelectionMode
            ? null
            : FloatingActionButton(
                onPressed: () => _openNoteEditor(null),
                backgroundColor: theme.colorScheme.primary,
                child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
              ),
        body: Column(
          children: [
            _buildCustomTopBar(),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: onSurfaceColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: onSurfaceColor.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: onSurfaceColor.withOpacity(0.5),
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                            },
                            child: Icon(
                              Icons.close,
                              color: onSurfaceColor.withOpacity(0.5),
                              size: 18,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Note List
            Expanded(
              child: ValueListenableBuilder<List<Note>>(
                valueListenable: _filteredNotesNotifier,
                builder: (context, notes, _) {
                  if (notes.isEmpty) {
                    return Center(
                      child: Text(
                        "No notes found.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: onSurfaceColor.withOpacity(0.4),
                        ),
                      ),
                    );
                  }

                  // ✅ LOGIC: Only allow dragging if Custom Sort + No Search
                  final canReorder =
                      _currentSort == NoteSortOption.custom &&
                      _searchQuery.isEmpty;

                  if (canReorder) {
                    // 1. REORDERABLE LIST (For Drag & Drop)
                    // We use buildDefaultDragHandles: true so long-press works naturally
                    return ReorderableListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: notes.length,
                      onReorder: _onReorder,
                      proxyDecorator: (child, index, animation) =>
                          AnimatedBuilder(
                            animation: animation,
                            builder: (_, __) => Transform.scale(
                              scale: 1.05,
                              child: Material(
                                color: Colors.transparent,
                                child: child,
                              ),
                            ),
                          ),
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return NoteCard(
                          key: ValueKey(note.id),
                          note: note,
                          isSelected: _selectedNoteIds.contains(note.id),
                          onTap: () => _openNoteEditor(note),
                          // ✅ IMPORTANT: Pass null to onLongPress so the List handles the Drag!
                          onLongPress: null,
                          onCopy: () => _copyNote(note),
                          onShare: () => _shareNote(note),
                          onDelete: () => _confirmDeleteNote(note),
                          onColorChanged: (c) {
                            note.colorValue = c.value;
                            note.save();
                          },
                        );
                      },
                    );
                  } else {
                    // 2. STANDARD LIST (High Performance for Search/Date Sort)
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: notes.length,
                      cacheExtent: 1000,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return RepaintBoundary(
                          child: NoteCard(
                            key: ValueKey(note.id),
                            note: note,
                            isSelected: _selectedNoteIds.contains(note.id),
                            onTap: () => _openNoteEditor(note),
                            // ✅ Restore Selection Mode on long press when NOT reordering
                            onLongPress: () => setState(() {
                              _isSelectionMode = true;
                              _selectedNoteIds.add(note.id);
                            }),
                            onCopy: () => _copyNote(note),
                            onShare: () => _shareNote(note),
                            onDelete: () => _confirmDeleteNote(note),
                            onColorChanged: (c) {
                              note.colorValue = c.value;
                              note.save();
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTopBar() {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isSelectionMode ? Icons.close : Icons.arrow_back_ios_new,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              if (_isSelectionMode) {
                setState(() {
                  _isSelectionMode = false;
                  _selectedNoteIds.clear();
                });
              } else {
                context.pop();
              }
            },
          ),
          Expanded(
            child: _isSelectionMode
                ? Center(
                    child: Text(
                      '${_selectedNoteIds.length} Selected',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Hero(
                        tag: 'notes_icon',
                        child: Icon(
                          Icons.note_alt_outlined,
                          size: 28,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Hero(
                        tag: 'notes_title',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "Notes",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          if (_isSelectionMode) ...[
            IconButton(
              icon: Icon(Icons.select_all, color: onSurfaceColor),
              onPressed: _selectAll,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _deleteSelected,
            ),
          ] else ...[
            IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: onSurfaceColor.withOpacity(0.6),
              ),
              onPressed: () => setState(() => _isSelectionMode = true),
            ),
            IconButton(
              icon: Icon(Icons.filter_list, color: onSurfaceColor),
              onPressed: _showFilterMenu,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: Colors.redAccent,
              ),
              onPressed: _deleteAll,
            ),
          ],
        ],
      ),
    );
  }

  // ✅ IMPROVED BOTTOM SHEET: Solid Background for Visibility
  void _showFilterMenu() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, // ✅ Solid Surface Color (Not Glass)
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Sort Notes",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildSortOption(
              NoteSortOption.custom,
              "Custom Order (Drag & Drop)",
            ),
            _buildSortOption(NoteSortOption.dateNewest, "Date: Newest First"),
            _buildSortOption(NoteSortOption.dateOldest, "Date: Oldest First"),
            _buildSortOption(NoteSortOption.titleAZ, "Title: A-Z"),
            _buildSortOption(NoteSortOption.titleZA, "Title: Z-A"),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(NoteSortOption option, String label) {
    final selected = _currentSort == option;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        setState(() => _currentSort = option);
        _applyFilters();
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
