import 'dart:ui';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../data/note_model.dart';
import '../widgets/note_card.dart';

enum NoteSortOption { custom, dateNewest, dateOldest, titleAZ, titleZA }

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedNoteIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  NoteSortOption _currentSort = NoteSortOption.custom;
  List<Note> _reorderingList = [];
  bool _isReordering = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- ACTIONS ---
  void _copyNote(Note note) {
    final text = "${note.title}\n\n${note.content}";
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Note copied", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareNote(Note note) {
    Share.share("${note.title}\n\n${note.content}");
  }

  void _confirmDeleteNote(Note note) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete Note?",
        content: "This action cannot be undone.",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          note.delete();
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_isSelectionMode) {
      setState(() {
        _isSelectionMode = false;
        _selectedNoteIds.clear();
      });
      return false;
    }
    return true;
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedNoteIds.contains(id)) _selectedNoteIds.remove(id);
      else _selectedNoteIds.add(id);
      if (_selectedNoteIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _enterSelectionMode(String id) {
    setState(() {
      _isSelectionMode = true;
      _selectedNoteIds.add(id);
    });
  }

  void _selectAll(List<Note> notes) {
    setState(() {
      final ids = notes.map((e) => e.id).toSet();
      if (_selectedNoteIds.containsAll(ids)) {
        _selectedNoteIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedNoteIds.addAll(ids);
      }
    });
  }

  void _deleteSelected() {
    if (_selectedNoteIds.isEmpty) return;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => GlassDialog(
        title: "Delete ${_selectedNoteIds.length} Notes?",
        content: "This action cannot be undone.",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          final box = Hive.box<Note>('notes_box');
          final notesToDelete = box.values.where((n) => _selectedNoteIds.contains(n.id)).toList();
          for (var note in notesToDelete) note.delete();
          setState(() {
            _selectedNoteIds.clear();
            _isSelectionMode = false;
          });
        },
      ),
    );
  }

  void _deleteAll() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => GlassDialog(
        title: "Delete All Notes?",
        content: "This will permanently remove all notes. This action cannot be undone.",
        confirmText: "Delete All",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          Hive.box<Note>('notes_box').clear();
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

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    setState(() {
      _isReordering = true;
      final item = _reorderingList.removeAt(oldIndex);
      _reorderingList.insert(newIndex, item);
    });

    final box = Hive.box<Note>('notes_box');
    await box.clear();
    await box.addAll(_reorderingList);

    if (mounted) {
      setState(() {
        _isReordering = false;
      });
    }
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sort By", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildSortOption(NoteSortOption.custom, "Custom Order (Drag & Drop)"),
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
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? primaryColor : onSurfaceColor.withOpacity(0.5),
      ),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selected ? onSurfaceColor : onSurfaceColor.withOpacity(0.7))),
      onTap: () {
        setState(() => _currentSort = option);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GlassScaffold(
        title: null,
        floatingActionButton: _isSelectionMode
            ? null
            : FloatingActionButton(
          onPressed: () => _openNoteEditor(null),
          backgroundColor: primaryColor,
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        ),
        body: Column(
          children: [
            _buildCustomTopBar(),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 8),
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onSurfaceColor.withOpacity(0.54)),
                    prefixIcon: Icon(Icons.search, color: onSurfaceColor.withOpacity(0.54), size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: Icon(Icons.close, color: onSurfaceColor.withOpacity(0.54), size: 18),
                    )
                        : null,
                    filled: true,
                    fillColor: onSurfaceColor.withOpacity(0.08),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim().toLowerCase();
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Note>('notes_box').listenable(),
                builder: (_, Box<Note> box, __) {
                  List<Note> notes;

                  if (_isReordering) {
                    notes = _reorderingList;
                  } else {
                    notes = box.values.toList().cast<Note>();
                    if (_searchQuery.isNotEmpty) {
                      notes = notes.where((n) => n.title.toLowerCase().contains(_searchQuery) || n.content.toLowerCase().contains(_searchQuery)).toList();
                    }

                    switch (_currentSort) {
                      case NoteSortOption.dateNewest:
                        notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                        break;
                      case NoteSortOption.dateOldest:
                        notes.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
                        break;
                      case NoteSortOption.titleAZ:
                        notes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
                        break;
                      case NoteSortOption.titleZA:
                        notes.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
                        break;
                      case NoteSortOption.custom:
                        break;
                    }
                    _reorderingList = List.from(notes);
                  }

                  if (notes.isEmpty) {
                    return Center(child: Text("No notes found.", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onSurfaceColor.withOpacity(0.38))));
                  }

                  final canReorder = _currentSort == NoteSortOption.custom && _searchQuery.isEmpty;

                  return ReorderableListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: notes.length,
                    onReorder: canReorder ? _onReorder : (a, b) {},
                    buildDefaultDragHandles: canReorder,
                    proxyDecorator: (child, index, animation) => AnimatedBuilder(animation: animation, builder: (_, __) => Transform.scale(scale: 1.05, child: Material(color: Colors.transparent, child: child))),

                    itemBuilder: (_, index) {
                      final note = notes[index];
                      final selected = _selectedNoteIds.contains(note.id);

                      // --- INTEGRATED NOTE CARD ---
                      return Container(
                        key: ValueKey(note.id),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: NoteCard(
                          note: note,
                          isSelected: selected,
                          onTap: () => _isSelectionMode ? _toggleSelection(note.id) : _openNoteEditor(note),
                          onLongPress: !canReorder ? () => _enterSelectionMode(note.id) : null,
                          onCopy: () => _copyNote(note),
                          onShare: () => _shareNote(note),
                          onDelete: () => _confirmDeleteNote(note),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTopBar() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final errorColor = Theme.of(context).colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isSelectionMode ? Icons.close : Icons.arrow_back_ios_new, color: Theme.of(context).iconTheme.color),
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
                ? Center(child: Text('${_selectedNoteIds.length} Selected', style: Theme.of(context).textTheme.titleLarge))
                : Row(
              children: [
                Hero(tag: 'notes_icon', child: Icon(Icons.note_alt_outlined, size: 32, color: primaryColor)),
                const SizedBox(width: 10),
                Hero(tag: 'notes_title', child: Material(type: MaterialType.transparency, child: Text("Notes", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28)))),
              ],
            ),
          ),
          if (_isSelectionMode) ...[
            IconButton(icon: Icon(Icons.select_all, color: onSurfaceColor), onPressed: () => _selectAll(Hive.box<Note>('notes_box').values.toList().cast<Note>())),
            IconButton(icon: Icon(Icons.delete, color: errorColor), onPressed: _deleteSelected),
          ] else ...[
            IconButton(icon: Icon(Icons.check_circle_outline, color: onSurfaceColor.withOpacity(0.54)), onPressed: () => setState(() => _isSelectionMode = true)),
            IconButton(icon: Icon(Icons.filter_list, color: onSurfaceColor), onPressed: _showFilterMenu),
            IconButton(icon: Icon(Icons.delete_sweep_outlined, color: errorColor), onPressed: _deleteAll),
          ],
        ],
      ),
    );
  }
}