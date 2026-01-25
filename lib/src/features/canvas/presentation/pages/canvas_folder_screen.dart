import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/const/constant.dart';
import 'package:flutter/cupertino.dart';
import '../../data/canvas_adapter.dart';
import '../../data/canvas_model.dart';
import '../widgets/canvas_sketch_card.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/widgets/search_header_field.dart';

// Sorting options for the folder view
enum FolderSortOption { dateNewest, dateOldest, nameAZ, nameZA }

class CanvasFolderScreen extends StatefulWidget {
  final String folderId;

  const CanvasFolderScreen({super.key, required this.folderId});

  @override
  State<CanvasFolderScreen> createState() => _CanvasFolderScreenState();
}

class _CanvasFolderScreenState extends State<CanvasFolderScreen>
    with SingleTickerProviderStateMixin {
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
    _folder =
        CanvasDatabase().getFolder(widget.folderId) ??
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
      builder: (ctx) => GlassDialog(
        title: "Delete Sketches?",
        content:
            "Delete ${_selectedNoteIds.length} sketches? This cannot be undone.",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () {
          for (var id in _selectedNoteIds) {
            CanvasDatabase().deleteNote(id);
          }
          Navigator.pop(ctx);
          _exitSelectionMode();
        },
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
                  icon: const Icon(CupertinoIcons.add),
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
                  valueListenable: Hive.box<CanvasNote>(
                    CanvasDatabase.notesBoxName,
                  ).listenable(),
                  builder: (context, box, _) {
                    // 1. Get Data
                    List<CanvasNote> notes = CanvasDatabase().getNotesByFolder(
                      widget.folderId,
                    );

                    // 2. Filter (Search)
                    if (_isSearching && _searchController.text.isNotEmpty) {
                      final query = _searchController.text.toLowerCase();
                      notes = notes
                          .where((n) => n.title.toLowerCase().contains(query))
                          .toList();
                    }

                    // 3. Sort
                    if (_currentSort == FolderSortOption.dateNewest) {
                      notes.sort(
                        (a, b) => b.lastModified.compareTo(a.lastModified),
                      );
                    } else if (_currentSort == FolderSortOption.dateOldest) {
                      notes.sort(
                        (a, b) => a.lastModified.compareTo(b.lastModified),
                      );
                    } else if (_currentSort == FolderSortOption.nameAZ) {
                      notes.sort(
                        (a, b) => a.title.toLowerCase().compareTo(
                          b.title.toLowerCase(),
                        ),
                      );
                    } else if (_currentSort == FolderSortOption.nameZA) {
                      notes.sort(
                        (a, b) => b.title.toLowerCase().compareTo(
                          a.title.toLowerCase(),
                        ),
                      );
                    }

                    // 4. Empty State
                    if (notes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isSearching
                                  ? Icons.search_off
                                  : Icons.note_outlined,
                              size: 64,
                              color: colorScheme.onSurface.withOpacity(0.2),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isSearching
                                  ? 'No sketches found'
                                  : 'No sketches yet',
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                              context.push(
                                AppRouter.canvasEdit,
                                extra: {'noteId': note.id},
                              );
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
    if (_isSelectionMode) {
      return SeamlessHeader(
        title: "${_selectedNoteIds.length} Selected",
        iconHeroTag: 'folder_${widget.folderId}',
        titleHeroTag: 'folder_name_${widget.folderId}',
        showBackButton: true,
        onBackTap: _exitSelectionMode,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.checkmark_square),
            onPressed: _selectAll,
          ),
          IconButton(
            icon: Icon(CupertinoIcons.delete, color: theme.colorScheme.error),
            onPressed: _selectedNoteIds.isNotEmpty ? _deleteSelected : null,
          ),
        ],
      );
    }

    if (_isSearching) {
      return SeamlessHeader(
        title: "",
        iconHeroTag: 'folder_${widget.folderId}',
        titleHeroTag: 'folder_name_${widget.folderId}',
        showBackButton: true,
        onBackTap: _toggleSearch,
        titleWidget: SearchHeaderField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          heroTag: 'search_bar_folder',
          hintText: "Search in ${_folder.name}...",
        ),
      );
    }

    return ValueListenableBuilder(
      valueListenable: Hive.box<CanvasNote>(
        CanvasDatabase.notesBoxName,
      ).listenable(),
      builder: (context, _, __) {
        final count = CanvasDatabase().getNoteCount(widget.folderId);
        return SeamlessHeader(
          title: _folder.name,
          subtitle: '$count sketches',
          icon: CupertinoIcons.folder_fill,
          iconColor: _folder.color,
          iconHeroTag: 'folder_${widget.folderId}',
          titleHeroTag: 'folder_name_${widget.folderId}',
          actions: [
            PopupMenuButton<FolderSortOption>(
              icon: const Icon(CupertinoIcons.slider_horizontal_3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tooltip: 'Sort Sketches',
              onSelected: (FolderSortOption result) {
                setState(() => _currentSort = result);
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<FolderSortOption>>[
                    PopupMenuItem<FolderSortOption>(
                      value: FolderSortOption.dateNewest,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.calendar_today,
                            size: 18,
                            color: _currentSort == FolderSortOption.dateNewest
                                ? theme.colorScheme.primary
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Newest First",
                            style: TextStyle(
                              color: _currentSort == FolderSortOption.dateNewest
                                  ? theme.colorScheme.primary
                                  : null,
                              fontWeight:
                                  _currentSort == FolderSortOption.dateNewest
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<FolderSortOption>(
                      value: FolderSortOption.dateOldest,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            size: 18,
                            color: _currentSort == FolderSortOption.dateOldest
                                ? theme.colorScheme.primary
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Oldest First",
                            style: TextStyle(
                              color: _currentSort == FolderSortOption.dateOldest
                                  ? theme.colorScheme.primary
                                  : null,
                              fontWeight:
                                  _currentSort == FolderSortOption.dateOldest
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<FolderSortOption>(
                      value: FolderSortOption.nameAZ,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.textformat,
                            size: 18,
                            color: _currentSort == FolderSortOption.nameAZ
                                ? theme.colorScheme.primary
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Name (A-Z)",
                            style: TextStyle(
                              color: _currentSort == FolderSortOption.nameAZ
                                  ? theme.colorScheme.primary
                                  : null,
                              fontWeight:
                                  _currentSort == FolderSortOption.nameAZ
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<FolderSortOption>(
                      value: FolderSortOption.nameZA,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.textformat,
                            size: 18,
                            color: _currentSort == FolderSortOption.nameZA
                                ? theme.colorScheme.primary
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Name (Z-A)",
                            style: TextStyle(
                              color: _currentSort == FolderSortOption.nameZA
                                  ? theme.colorScheme.primary
                                  : null,
                              fontWeight:
                                  _currentSort == FolderSortOption.nameZA
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.search),
              onPressed: _toggleSearch,
            ),
            PopupMenuButton(
              icon: const Icon(CupertinoIcons.ellipsis_vertical),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                const PopupMenuItem(
                  value: 'color',
                  child: Text('Change Color'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Folder'),
                ),
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
        );
      },
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
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
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
      const Color(0xFF64B5F6),
      const Color(0xFF81C784),
      const Color(0xFFFFD54F),
      const Color(0xFFFF8A65),
      const Color(0xFFBA68C8),
      const Color(0xFF4DB6AC),
      const Color(0xFFFFB300),
      const Color(0xFFEF5350),
      const Color(0xFF9575CD),
      const Color(0xFF4FC3F7),
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Choose Color'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: colors
                .map(
                  (color) => GestureDetector(
                    onTap: () {
                      setState(() => _folder.color = color);
                      CanvasDatabase().saveFolder(_folder);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: _folder.color.value == color.value
                            ? Border.all(
                                width: 3,
                                color: theme.colorScheme.onSurface,
                              )
                            : null,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDeleteFolderDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Folder?'),
        content: const Text(
          'All sketches in this folder will be deleted permanently.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
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
