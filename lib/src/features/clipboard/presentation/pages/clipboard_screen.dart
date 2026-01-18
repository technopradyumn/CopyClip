import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

// Core
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';

// Data
import '../../data/clipboard_model.dart';

// Widgets (Ensure you use the Optimized ClipboardCard provided earlier)
import '../widgets/clipboard_card.dart';

enum ClipSortOption { custom, dateNewest, dateOldest, contentAZ, contentZA }

class ClipboardScreen extends StatefulWidget {
  const ClipboardScreen({super.key});

  @override
  State<ClipboardScreen> createState() => _ClipboardScreenState();
}

class _ClipboardScreenState extends State<ClipboardScreen> {
  // UI Controllers
  final TextEditingController _searchController = TextEditingController();

  // ✅ PERFORMANCE: Notifier for the filtered list (Isolates updates)
  final ValueNotifier<List<ClipboardItem>> _filteredClipsNotifier =
      ValueNotifier([]);

  // Data State
  List<ClipboardItem> _rawClips = [];
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  // Filter State
  String _searchQuery = "";
  ClipSortOption _currentSort = ClipSortOption.dateNewest;

  // Subscription for Real-time updates
  StreamSubscription? _boxSubscription;

  @override
  void initState() {
    super.initState();
    _initData();

    // Listen for Search efficiently
    _searchController.addListener(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  Future<void> _initData() async {
    await LazyBoxLoader.getBox<ClipboardItem>('clipboard_box');
    if (mounted) {
      final box = Hive.box<ClipboardItem>('clipboard_box');

      // Initial Load
      _refreshClips();

      // ✅ REAL-TIME LISTENER: Watch for ANY change in the box
      _boxSubscription = box.watch().listen((event) {
        if (mounted) {
          debugPrint('🔄 Clipboard Box Changed. Refreshing UI...');
          _refreshClips();
        }
      });
    }
  }

  @override
  void dispose() {
    _boxSubscription?.cancel(); // Cancel stream listener
    _searchController.dispose();
    _filteredClipsNotifier.dispose();
    super.dispose();
  }

  // --- DATA LOGIC ---

  void _refreshClips() {
    if (!Hive.isBoxOpen('clipboard_box')) return;
    final box = Hive.box<ClipboardItem>('clipboard_box');

    // Get all non-deleted clips
    _rawClips = box.values.where((e) => !e.isDeleted).toList();
    _applyFilters();
  }

  void _applyFilters() {
    List<ClipboardItem> result = List.from(_rawClips);

    // 1. Search Filter
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((i) => i.content.toLowerCase().contains(_searchQuery))
          .toList();
    }

    // 2. Sort
    switch (_currentSort) {
      case ClipSortOption.dateNewest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case ClipSortOption.dateOldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case ClipSortOption.contentAZ:
        result.sort(
          (a, b) => a.content.toLowerCase().compareTo(b.content.toLowerCase()),
        );
        break;
      case ClipSortOption.contentZA:
        result.sort(
          (a, b) => b.content.toLowerCase().compareTo(a.content.toLowerCase()),
        );
        break;
      case ClipSortOption.custom:
        result.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
        break;
    }

    // Update the UI
    _filteredClipsNotifier.value = result;
  }

  // --- ACTIONS ---

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    final currentList = List<ClipboardItem>.from(_filteredClipsNotifier.value);
    final item = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, item);

    // Update UI immediately
    _filteredClipsNotifier.value = currentList;

    // Update DB in background
    for (int i = 0; i < currentList.length; i++) {
      currentList[i].sortIndex = i;
      currentList[i].save();
    }
  }

  String _getCleanText(String content) {
    if (!content.startsWith('[')) return content;
    try {
      final List<dynamic> delta = jsonDecode(content);
      String plainText = "";
      for (var op in delta) {
        if (op is Map && op['insert'] is String) plainText += op['insert'];
      }
      return plainText.trim();
    } catch (_) {
      return content;
    }
  }

  void _confirmDelete(ClipboardItem item) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move to Bin?",
        content: "You can restore it later.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          item.isDeleted = true;
          item.deletedAt = DateTime.now();
          item.save();
        },
      ),
    );
  }

  void _deleteSelected() {
    final now = DateTime.now();
    for (var id in _selectedIds) {
      try {
        final item = _rawClips.firstWhere((e) => e.id == id);
        item.isDeleted = true;
        item.deletedAt = now;
        item.save();
      } catch (_) {}
    }
    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }

  void _deleteAll() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete All?",
        content: "Move all clips to Recycle Bin?",
        confirmText: "Delete All",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          final now = DateTime.now();
          for (var item in _rawClips) {
            item.isDeleted = true;
            item.deletedAt = now;
            item.save();
          }
        },
      ),
    );
  }

  void _openEditor(ClipboardItem? item) {
    if (_isSelectionMode) {
      if (item != null) _toggleSelection(item.id);
      return;
    }
    context.push(AppRouter.clipboardEdit, extra: item);
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id))
        _selectedIds.remove(id);
      else
        _selectedIds.add(id);
      if (_selectedIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedIds.length == _filteredClipsNotifier.value.length) {
        _selectedIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedIds.addAll(_filteredClipsNotifier.value.map((e) => e.id));
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
            _selectedIds.clear();
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
                onPressed: () => context.push(AppRouter.clipboardEdit),
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
                height: 44,
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
                    hintText: 'Search clips...',
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),

            // List
            Expanded(
              child: ValueListenableBuilder<List<ClipboardItem>>(
                valueListenable: _filteredClipsNotifier,
                builder: (context, items, _) {
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        "No items found.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: onSurfaceColor.withOpacity(0.4),
                        ),
                      ),
                    );
                  }

                  // ✅ LOGIC: Reorder only if Custom Sort + No Search + Not Selecting
                  final canReorder =
                      _currentSort == ClipSortOption.custom &&
                      _searchQuery.isEmpty &&
                      !_isSelectionMode;

                  if (canReorder) {
                    return ReorderableListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: items.length,
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
                        final item = items[index];
                        return ReorderableDelayedDragStartListener(
                          key: ValueKey(item.id),
                          index: index,
                          enabled: canReorder,
                          child: ClipboardCard(
                            item: item,
                            isSelected: _selectedIds.contains(item.id),
                            onTap: () => _openEditor(item),
                            onLongPress: null, // Allow drag
                            onCopy: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: _getCleanText(item.content),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Copied!"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            onShare: () =>
                                Share.share(_getCleanText(item.content)),
                            onDelete: () => _confirmDelete(item),
                            onColorChanged: (newColor) {
                              item.colorValue = newColor.value;
                              item.save();
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    // ✅ PERFORMANCE: Standard ListView for Search/Other sorts
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: items.length,
                      cacheExtent: 1000,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return RepaintBoundary(
                          child: ClipboardCard(
                            key: ValueKey(item.id),
                            item: item,
                            isSelected: _selectedIds.contains(item.id),
                            onTap: () => _openEditor(item),
                            onLongPress: () => setState(() {
                              _isSelectionMode = true;
                              _selectedIds.add(item.id);
                            }),
                            onCopy: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: _getCleanText(item.content),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Copied!"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            onShare: () =>
                                Share.share(_getCleanText(item.content)),
                            onDelete: () => _confirmDelete(item),
                            onColorChanged: (newColor) {
                              item.colorValue = newColor.value;
                              item.save();
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
    final errorColor = theme.colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                  _selectedIds.clear();
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
                      '${_selectedIds.length} Selected',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Hero(
                        tag: 'clipboard_icon',
                        child: Icon(Icons.paste, color: primaryColor, size: 28),
                      ),
                      const SizedBox(width: 10),
                      Hero(
                        tag: 'clipboard_title',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "Clipboard",
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
              icon: Icon(Icons.delete, color: errorColor),
              onPressed: _deleteSelected,
            ),
          ] else ...[
            IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: onSurfaceColor.withOpacity(0.54),
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

  // ✅ IMPROVED BOTTOM SHEET: Solid Background & StatefulBuilder
  void _showFilterMenu() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // ✅ Solid Surface
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
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
                  "Sort By",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSortOption(
                  ClipSortOption.custom,
                  "Custom Order (Drag)",
                  setSheetState,
                ),
                _buildSortOption(
                  ClipSortOption.dateNewest,
                  "Newest First",
                  setSheetState,
                ),
                _buildSortOption(
                  ClipSortOption.dateOldest,
                  "Oldest First",
                  setSheetState,
                ),
                _buildSortOption(
                  ClipSortOption.contentAZ,
                  "Content: A-Z",
                  setSheetState,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOption(
    ClipSortOption option,
    String label,
    StateSetter setSheetState,
  ) {
    final selected = _currentSort == option;
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() => _currentSort = option);
        setSheetState(() {});
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
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
