import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:copyclip/src/core/const/constant.dart';

import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

// Core
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';

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
                backgroundColor: FeatureColors.clipboard,
                child: Icon(
                  CupertinoIcons.add,
                  color: theme.colorScheme.onPrimary,
                ),
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
                  borderRadius: BorderRadius.circular(
                    AppConstants.cornerRadius,
                  ),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.1),
                    width: AppConstants.borderWidth,
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
                      CupertinoIcons.search,
                      color: onSurfaceColor.withOpacity(0.5),
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                            },
                            child: Icon(
                              CupertinoIcons.xmark_circle,
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

    if (_isSelectionMode) {
      return SeamlessHeader(
        title: '${_selectedIds.length} Selected',
        heroTagPrefix: 'clipboard',
        showBackButton: true,
        onBackTap: () => setState(() {
          _isSelectionMode = false;
          _selectedIds.clear();
        }),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.square_list, color: onSurfaceColor),
            onPressed: _selectAll,
          ),
          IconButton(
            icon: Icon(CupertinoIcons.delete, color: theme.colorScheme.error),
            onPressed: _deleteSelected,
          ),
        ],
      );
    }

    return SeamlessHeader(
      title: "Clipboard",
      subtitle: "Recent Clips",
      icon: CupertinoIcons.doc_on_clipboard,
      iconColor: FeatureColors.clipboard,
      heroTagPrefix: 'clipboard',
      actions: [
        IconButton(
          icon: Icon(
            CupertinoIcons.checkmark_circle,
            color: onSurfaceColor.withOpacity(0.54),
          ),
          onPressed: () => setState(() => _isSelectionMode = true),
        ),
        // SORT MENU
        PopupMenuButton<ClipSortOption>(
          icon: Icon(CupertinoIcons.slider_horizontal_3, color: onSurfaceColor),
          tooltip: 'Sort Clips',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (ClipSortOption result) {
            setState(() {
              _currentSort = result;
              _applyFilters();
            });
          },
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<ClipSortOption>>[
                PopupMenuItem<ClipSortOption>(
                  value: ClipSortOption.custom,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.arrow_up_arrow_down,
                        size: 18,
                        color: _currentSort == ClipSortOption.custom
                            ? FeatureColors.clipboard
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Custom Order",
                        style: TextStyle(
                          color: _currentSort == ClipSortOption.custom
                              ? FeatureColors.clipboard
                              : null,
                          fontWeight: _currentSort == ClipSortOption.custom
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<ClipSortOption>(
                  value: ClipSortOption.dateNewest,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar_today,
                        size: 18,
                        color: _currentSort == ClipSortOption.dateNewest
                            ? FeatureColors.clipboard
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Newest First",
                        style: TextStyle(
                          color: _currentSort == ClipSortOption.dateNewest
                              ? FeatureColors.clipboard
                              : null,
                          fontWeight: _currentSort == ClipSortOption.dateNewest
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<ClipSortOption>(
                  value: ClipSortOption.dateOldest,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.time,
                        size: 18,
                        color: _currentSort == ClipSortOption.dateOldest
                            ? FeatureColors.clipboard
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Oldest First",
                        style: TextStyle(
                          color: _currentSort == ClipSortOption.dateOldest
                              ? FeatureColors.clipboard
                              : null,
                          fontWeight: _currentSort == ClipSortOption.dateOldest
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<ClipSortOption>(
                  value: ClipSortOption.contentAZ,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.textformat,
                        size: 18,
                        color: _currentSort == ClipSortOption.contentAZ
                            ? FeatureColors.clipboard
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Content: A-Z",
                        style: TextStyle(
                          color: _currentSort == ClipSortOption.contentAZ
                              ? FeatureColors.clipboard
                              : null,
                          fontWeight: _currentSort == ClipSortOption.contentAZ
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
          icon: const Icon(CupertinoIcons.trash, color: Colors.redAccent),
          onPressed: _deleteAll,
        ),
      ],
    );
  }
}
