import 'package:copyclip/src/core/theme/custom_selection_controls.dart';
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
import '../widgets/canvas_folder_card.dart';
import '../widgets/canvas_sketch_card.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/widgets/search_header_field.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import '../../../../l10n/app_localizations.dart';

// Sorting Enum
enum CanvasSortOption { dateNewest, dateOldest, nameAZ, nameZA }

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen>
    with SingleTickerProviderStateMixin {
  // State
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Favorites'];
  CanvasSortOption _currentSort = CanvasSortOption.dateNewest;

  // Selection Mode State
  bool _isSelectionMode = false;
  final Set<String> _selectedFolderIds = {};
  final Set<String> _selectedNoteIds = {};

  // Search State
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();

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
      _selectedFolderIds.clear();
      _selectedNoteIds.clear();
    });
  }

  void _toggleFolderSelection(String id) {
    setState(() {
      if (_selectedFolderIds.contains(id)) {
        _selectedFolderIds.remove(id);
      } else {
        _selectedFolderIds.add(id);
      }
      _checkSelectionEmpty();
    });
  }

  void _toggleNoteSelection(String id) {
    setState(() {
      if (_selectedNoteIds.contains(id)) {
        _selectedNoteIds.remove(id);
      } else {
        _selectedNoteIds.add(id);
      }
      _checkSelectionEmpty();
    });
  }

  void _checkSelectionEmpty() {
    if (_selectedFolderIds.isEmpty && _selectedNoteIds.isEmpty) {
      _exitSelectionMode();
    }
  }

  void _selectAll() {
    final rootFolders = CanvasDatabase().getRootFolders();
    final notes = _selectedCategory == 'Favorites'
        ? CanvasDatabase().getFavoriteNotes()
        : <CanvasNote>[];

    setState(() {
      _selectedFolderIds.addAll(rootFolders.map((e) => e.id));
      _selectedNoteIds.addAll(notes.map((e) => e.id));
      _isSelectionMode = true;
    });
  }

  // --- DELETE LOGIC (UPDATED) ---
  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: AppLocalizations.of(context)!.permanentlyDelete,
        content: AppLocalizations.of(context)!.deleteSelectionConfirmation(
          _selectedFolderIds.length,
          _selectedNoteIds.length,
        ),
        confirmText: AppLocalizations.of(context)!.deleteForever,
        isDestructive: true,
        onConfirm: () {
          final folderBox = Hive.box<CanvasFolder>(
            CanvasDatabase.foldersBoxName,
          );
          final noteBox = Hive.box<CanvasNote>(CanvasDatabase.notesBoxName);

          for (var folderId in _selectedFolderIds) {
            final sketchesInFolder = noteBox.values
                .where((note) => note.folderId == folderId)
                .toList();

            for (var sketch in sketchesInFolder) {
              noteBox.delete(sketch.id);
            }
            folderBox.delete(folderId);
          }

          for (var id in _selectedNoteIds) {
            noteBox.delete(id);
          }

          Navigator.pop(ctx);
          _exitSelectionMode();
        },
      ),
    );
  }

  // --- Sorting Logic ---

  // --- Helper Methods ---

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

  // --- UI Build ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_isSelectionMode && !_isSearching,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isSelectionMode) {
          _exitSelectionMode();
          return;
        }
        if (_isSearching) {
          _toggleSearch();
          return;
        }
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
                    final rootFolders = CanvasDatabase().getRootFolders();
                    final defaultFolderId = rootFolders.isEmpty
                        ? 'default'
                        : rootFolders.first.id;
                    context.push(
                      AppRouter.canvasEdit,
                      extra: {'folderId': defaultFolderId},
                    );
                  },
                  label: Text(AppLocalizations.of(context)!.newSketch),
                  icon: const Icon(CupertinoIcons.pencil),
                  backgroundColor: const Color(0xFF4DB6AC),
                  foregroundColor: Colors.white,
                ),
              ),
        body: DynamicBackground(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(theme),
                if (!_isSearching) _buildCategorySelector(theme),
                Expanded(
                  child: ValueListenableBuilder<Box<CanvasFolder>>(
                    valueListenable: Hive.box<CanvasFolder>(
                      CanvasDatabase.foldersBoxName,
                    ).listenable(),
                    builder: (context, folderBox, _) {
                      return ValueListenableBuilder<Box<CanvasNote>>(
                        valueListenable: Hive.box<CanvasNote>(
                          CanvasDatabase.notesBoxName,
                        ).listenable(),
                        builder: (context, noteBox, _) {
                          List<CanvasFolder> folders = [];
                          List<CanvasNote> notes = [];

                          if (_isSearching) {
                            final query = _searchController.text.toLowerCase();
                            // Filter active items for search
                            folders = folderBox.values
                                .where(
                                  (f) =>
                                      !f.isDeleted &&
                                      f.name.toLowerCase().contains(query),
                                )
                                .toList();
                            notes = noteBox.values
                                .where(
                                  (n) =>
                                      !n.isDeleted &&
                                      n.title.toLowerCase().contains(query),
                                )
                                .toList();
                          } else {
                            folders = CanvasDatabase().getRootFolders();
                            notes = _selectedCategory == 'Favorites'
                                ? CanvasDatabase().getFavoriteNotes()
                                : [];
                          }

                          // Sort Data
                          if (_currentSort == CanvasSortOption.dateNewest) {
                            notes.sort(
                              (a, b) =>
                                  b.lastModified.compareTo(a.lastModified),
                            );
                          } else if (_currentSort ==
                              CanvasSortOption.dateOldest) {
                            notes.sort(
                              (a, b) =>
                                  a.lastModified.compareTo(b.lastModified),
                            );
                          } else if (_currentSort == CanvasSortOption.nameAZ) {
                            folders.sort(
                              (a, b) => a.name.toLowerCase().compareTo(
                                b.name.toLowerCase(),
                              ),
                            );
                            notes.sort(
                              (a, b) => a.title.toLowerCase().compareTo(
                                b.title.toLowerCase(),
                              ),
                            );
                          } else if (_currentSort == CanvasSortOption.nameZA) {
                            folders.sort(
                              (a, b) => b.name.toLowerCase().compareTo(
                                a.name.toLowerCase(),
                              ),
                            );
                            notes.sort(
                              (a, b) => b.title.toLowerCase().compareTo(
                                a.title.toLowerCase(),
                              ),
                            );
                          }

                          final items = [...folders, ...notes];

                          if (items.isEmpty) {
                            return Center(
                              child: Text(
                                _isSearching
                                    ? AppLocalizations.of(
                                        context,
                                      )!.noResultsFound
                                    : AppLocalizations.of(context)!.noItems,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              bottom: 100,
                              top: 10,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];

                              if (item is CanvasFolder) {
                                return CanvasFolderCard(
                                  folder: item,
                                  isSelected: _selectedFolderIds.contains(
                                    item.id,
                                  ),
                                  onLongPress: () {
                                    _enterSelectionMode();
                                    _toggleFolderSelection(item.id);
                                  },
                                  onTap: () {
                                    if (_isSelectionMode) {
                                      _toggleFolderSelection(item.id);
                                    } else {
                                      context.push(
                                        AppRouter.canvasFolder,
                                        extra: item.id,
                                      );
                                    }
                                  },
                                );
                              } else if (item is CanvasNote) {
                                return CanvasSketchCard(
                                  note: item,
                                  isSelected: _selectedNoteIds.contains(
                                    item.id,
                                  ),
                                  onLongPress: () {
                                    _enterSelectionMode();
                                    _toggleNoteSelection(item.id);
                                  },
                                  onTap: () {
                                    if (_isSelectionMode) {
                                      _toggleNoteSelection(item.id);
                                    } else {
                                      context.push(
                                        AppRouter.canvasEdit,
                                        extra: {'noteId': item.id},
                                      );
                                    }
                                  },
                                );
                              }
                              return const SizedBox.shrink();
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
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    if (_isSelectionMode) {
      final count = _selectedFolderIds.length + _selectedNoteIds.length;
      return SeamlessHeader(
        title: AppLocalizations.of(context)!.selectedCount(count),
        heroTagPrefix: 'canvas',
        showBackButton: true,
        onBackTap: _exitSelectionMode,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.checkmark_square),
            onPressed: _selectAll,
          ),
          IconButton(
            icon: Icon(CupertinoIcons.delete, color: theme.colorScheme.error),
            onPressed: count > 0 ? _deleteSelected : null,
          ),
        ],
      );
    }

    if (_isSearching) {
      return SeamlessHeader(
        title: "",
        heroTagPrefix: 'canvas',
        showBackButton: true,
        onBackTap: _toggleSearch,
        titleWidget: SearchHeaderField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          heroTag: 'search_bar_main',
          hintText: AppLocalizations.of(context)!.searchSketches,
        ),
      );
    }

    return ValueListenableBuilder(
      valueListenable: Hive.box<CanvasNote>(
        CanvasDatabase.notesBoxName,
      ).listenable(),
      builder: (context, _, __) {
        final totalNotes = CanvasDatabase().getTotalNotes();
        final totalFolders = CanvasDatabase().getAllFolders().length;
        return SeamlessHeader(
          title: AppLocalizations.of(context)!.canvas,
          subtitle: AppLocalizations.of(
            context,
          )!.canvasStats(totalNotes, totalFolders),
          icon: CupertinoIcons.scribble,
          iconColor: const Color(0xFF4DB6AC),
          heroTagPrefix: 'canvas',
          actions: [
            PopupMenuButton<CanvasSortOption>(
              icon: const Icon(CupertinoIcons.slider_horizontal_3),
              tooltip: AppLocalizations.of(context)!.sortItems,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (CanvasSortOption result) {
                setState(() => _currentSort = result);
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<CanvasSortOption>>[
                    PopupMenuItem<CanvasSortOption>(
                      value: CanvasSortOption.dateNewest,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.calendar_today,
                            size: 18,
                            color: _currentSort == CanvasSortOption.dateNewest
                                ? const Color(0xFF4DB6AC)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.newestFirst,
                            style: TextStyle(
                              color: _currentSort == CanvasSortOption.dateNewest
                                  ? const Color(0xFF4DB6AC)
                                  : null,
                              fontWeight:
                                  _currentSort == CanvasSortOption.dateNewest
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<CanvasSortOption>(
                      value: CanvasSortOption.dateOldest,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            size: 18,
                            color: _currentSort == CanvasSortOption.dateOldest
                                ? const Color(0xFF4DB6AC)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.oldestFirst,
                            style: TextStyle(
                              color: _currentSort == CanvasSortOption.dateOldest
                                  ? const Color(0xFF4DB6AC)
                                  : null,
                              fontWeight:
                                  _currentSort == CanvasSortOption.dateOldest
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<CanvasSortOption>(
                      value: CanvasSortOption.nameAZ,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.textformat,
                            size: 18,
                            color: _currentSort == CanvasSortOption.nameAZ
                                ? const Color(0xFF4DB6AC)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.sortNameAZ,
                            style: TextStyle(
                              color: _currentSort == CanvasSortOption.nameAZ
                                  ? const Color(0xFF4DB6AC)
                                  : null,
                              fontWeight:
                                  _currentSort == CanvasSortOption.nameAZ
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<CanvasSortOption>(
                      value: CanvasSortOption.nameZA,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.textformat,
                            size: 18,
                            color: _currentSort == CanvasSortOption.nameZA
                                ? const Color(0xFF4DB6AC)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.sortNameZA,
                            style: TextStyle(
                              color: _currentSort == CanvasSortOption.nameZA
                                  ? const Color(0xFF4DB6AC)
                                  : null,
                              fontWeight:
                                  _currentSort == CanvasSortOption.nameZA
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
              icon: const Icon(CupertinoIcons.folder_badge_plus),
              onPressed: _showCreateFolderDialog,
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.search),
              onPressed: _toggleSearch,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4DB6AC)
                    : theme.colorScheme.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
                border: isSelected
                    ? null
                    : Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: AppConstants.borderWidth,
                      ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCreateFolderDialog() {
    final controller = TextEditingController();
    Color selectedColor = const Color(0xFF64B5F6);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.createFolder),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              selectionControls: CustomSelectionControls(),
              controller: controller,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.folderNameHint,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) => Wrap(
                spacing: 12,
                children:
                    [
                          const Color(0xFF64B5F6),
                          const Color(0xFF81C784),
                          const Color(0xFFFFD54F),
                          const Color(0xFFFF8A65),
                          const Color(0xFFBA68C8),
                          const Color(0xFF4DB6AC),
                        ]
                        .map(
                          (c) => GestureDetector(
                            onTap: () => setState(() => selectedColor = c),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: selectedColor == c
                                    ? Border.all(width: 3, color: Colors.white)
                                    : null,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                CanvasDatabase().saveFolder(
                  CanvasFolder(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: controller.text.trim(),
                    color: selectedColor,
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: Text(AppLocalizations.of(context)!.create),
          ),
        ],
      ),
    );
  }
}
