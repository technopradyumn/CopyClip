import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../data/canvas_adapter.dart';
import '../../data/canvas_model.dart';
import '../widgets/canvas_sketch_card.dart';

// Sorting options for the folder view
enum FolderSortOption { dateNewest, dateOldest, nameAZ, nameZA }

class CanvasFolderScreen extends StatefulWidget {
  final String folderId;

  const CanvasFolderScreen({super.key, required this.folderId});

  @override
  State<CanvasFolderScreen> createState() => _CanvasFolderScreenState();
}

class _CanvasFolderScreenState extends State<CanvasFolderScreen> with SingleTickerProviderStateMixin {
  late CanvasFolder _folder;
  late AnimationController _animationController;

  // Sorting State
  FolderSortOption _currentSort = FolderSortOption.dateNewest;

  // Selection Mode State
  bool _isSelectionMode = false;
  final Set<String> _selectedNoteIds = {};

  // Search State
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Safely get folder, fallback if deleted
    _folder = CanvasDatabase().getFolder(widget.folderId) ??
        CanvasFolder(id: 'temp', name: 'Unknown', color: Colors.grey);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();

    // Listen to search for live updates
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // --- Selection Logic ---

  void _enterSelectionMode() {
    setState(() => _isSelectionMode = true);
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedNoteIds.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedNoteIds.contains(id)) {
        _selectedNoteIds.remove(id);
      } else {
        _selectedNoteIds.add(id);
      }
      if (_selectedNoteIds.isEmpty) {
        _exitSelectionMode();
      }
    });
  }

  void _deleteSelected() {
    if (_selectedNoteIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Sketches?"),
        content: Text("Delete ${_selectedNoteIds.length} sketches? This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              for (var id in _selectedNoteIds) {
                CanvasDatabase().deleteNote(id);
              }
              Navigator.pop(ctx);
              _exitSelectionMode();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _selectAll() {
    final allNotes = CanvasDatabase().getNotesByFolder(widget.folderId);
    setState(() {
      _selectedNoteIds.addAll(allNotes.map((n) => n.id));
    });
  }

  // --- Sorting Logic ---

  void _showSortMenu() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
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
              "Sort Sketches",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSortOption(FolderSortOption.dateNewest, "Newest First"),
            _buildSortOption(FolderSortOption.dateOldest, "Oldest First"),
            _buildSortOption(FolderSortOption.nameAZ, "Name (A-Z)"),
            _buildSortOption(FolderSortOption.nameZA, "Name (Z-A)"),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(FolderSortOption option, String label) {
    final selected = _currentSort == option;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        setState(() => _currentSort = option);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Search Logic ---

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        FocusScope.of(context).unfocus();
      } else {
        _searchFocusNode.requestFocus();
      }
    });
  }

  // --- UI Construction ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          _exitSelectionMode();
          return false;
        }
        if (_isSearching) {
          _toggleSearch();
          return false;
        }
        return true;
      },
      child: GlassScaffold(
        floatingActionButton: (_isSearching || _isSelectionMode)
            ? null
            : ScaleTransition(
          scale: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
          ),
          child: FloatingActionButton.extended(
            onPressed: () {
              context.push(
                AppRouter.canvasEdit,
                extra: {'noteId': null, 'folderId': widget.folderId},
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('New Sketch'),
            backgroundColor: _folder.color,
            foregroundColor: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(theme, colorScheme),

              Expanded(
                child: ValueListenableBuilder<Box<CanvasNote>>(
                  valueListenable: Hive.box<CanvasNote>(CanvasDatabase.notesBoxName).listenable(),
                  builder: (context, box, _) {
                    // 1. Get Data
                    List<CanvasNote> notes = CanvasDatabase().getNotesByFolder(widget.folderId);

                    // 2. Filter (Search)
                    if (_isSearching && _searchController.text.isNotEmpty) {
                      final query = _searchController.text.toLowerCase();
                      notes = notes.where((n) => n.title.toLowerCase().contains(query)).toList();
                    }

                    // 3. Sort
                    if (_currentSort == FolderSortOption.dateNewest) {
                      notes.sort((a, b) => b.lastModified.compareTo(a.lastModified));
                    } else if (_currentSort == FolderSortOption.dateOldest) {
                      notes.sort((a, b) => a.lastModified.compareTo(b.lastModified));
                    } else if (_currentSort == FolderSortOption.nameAZ) {
                      notes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
                    } else if (_currentSort == FolderSortOption.nameZA) {
                      notes.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
                    }

                    // 4. Empty State
                    if (notes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isSearching ? Icons.search_off : Icons.note_outlined,
                              size: 64,
                              color: colorScheme.onSurface.withOpacity(0.2),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isSearching ? 'No sketches found' : 'No sketches yet',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // 5. Grid View
                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        final isSelected = _selectedNoteIds.contains(note.id);

                        return CanvasSketchCard(
                          note: note,
                          isSelected: isSelected,
                          onLongPress: () {
                            _enterSelectionMode();
                            _toggleSelection(note.id);
                          },
                          onTap: () {
                            if (_isSelectionMode) {
                              _toggleSelection(note.id);
                            } else {
                              context.push(AppRouter.canvasEdit, extra: {'noteId': note.id});
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    // SELECTION MODE HEADER
    if (_isSelectionMode) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _exitSelectionMode,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${_selectedNoteIds.length} Selected",
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: _selectAll,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              onPressed: _selectedNoteIds.isNotEmpty ? _deleteSelected : null,
            ),
          ],
        ),
      );
    }

    // STANDARD HEADER
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              if (_isSearching) {
                _toggleSearch();
              } else {
                context.pop();
              }
            },
          ),
          const SizedBox(width: 8),

          Expanded(
            child: _isSearching
                ? Hero(
              tag: 'search_bar_folder',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: "Search in ${_folder.name}...",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => _searchController.clear(),
                      ),
                    ),
                  ),
                ),
              ),
            )
                : Row(
              children: [
                Hero(
                  tag: 'folder_${widget.folderId}',
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _folder.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: _folder.color,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'folder_name_${widget.folderId}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            _folder.name,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: Hive.box<CanvasNote>(CanvasDatabase.notesBoxName).listenable(),
                        builder: (context, _, __) {
                          final count = CanvasDatabase().getNoteCount(widget.folderId);
                          return Text(
                            '$count sketches',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (!_isSearching)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showSortMenu,
                ),
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: _toggleSearch,
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'rename', child: Text('Rename')),
                    const PopupMenuItem(value: 'color', child: Text('Change Color')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete Folder')),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'rename':
                        _showRenameDialog(theme);
                        break;
                      case 'color':
                        _showColorPicker(theme);
                        break;
                      case 'delete':
                        _showDeleteFolderDialog(theme);
                        break;
                    }
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  // --- Dialogs ---

  void _showRenameDialog(ThemeData theme) {
    final controller = TextEditingController(text: _folder.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Folder name...'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _folder.name = controller.text.trim());
                CanvasDatabase().saveFolder(_folder);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(ThemeData theme) {
    final colors = [
      const Color(0xFF64B5F6), const Color(0xFF81C784), const Color(0xFFFFD54F),
      const Color(0xFFFF8A65), const Color(0xFFBA68C8), const Color(0xFF4DB6AC),
      const Color(0xFFFFB300), const Color(0xFFEF5350), const Color(0xFF9575CD),
      const Color(0xFF4FC3F7),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose Color', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: colors.map((color) => GestureDetector(
                  onTap: () {
                    setState(() => _folder.color = color);
                    CanvasDatabase().saveFolder(_folder);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: _folder.color.value == color.value
                          ? Border.all(width: 3, color: Colors.white)
                          : null,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteFolderDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Folder?'),
        content: const Text('All sketches in this folder will be deleted permanently.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              CanvasDatabase().deleteFolder(widget.folderId);
              Navigator.pop(ctx); // Close dialog
              context.pop(); // Go back to main screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}