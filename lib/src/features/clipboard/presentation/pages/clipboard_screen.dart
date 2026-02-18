import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:copyclip/src/core/const/constant.dart';
import '../../../../l10n/app_localizations.dart';

import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

// Core
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:copyclip/src/core/widgets/empty_state_widget.dart'; // Added
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
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
    if (content.trim().isEmpty) return "Empty content";
    if (!content.trim().startsWith('[')) return content.trim();
    try {
      final List<dynamic> delta = jsonDecode(content);
      String plainText = "";
      for (var op in delta) {
        if (op is Map && op.containsKey('insert')) {
          final insertData = op['insert'];
          if (insertData is String) plainText += insertData;
        }
      }
      final String trimmed = plainText.trim();
      return trimmed.isEmpty ? "Empty content" : trimmed;
    } catch (_) {
      return content.trim();
    }
  }

  void _confirmDelete(ClipboardItem item) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: AppLocalizations.of(context)!.moveToBinItem,
        content: AppLocalizations.of(context)!.moveToBinConfirmation,
        confirmText: AppLocalizations.of(context)!.move,
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
        title: AppLocalizations.of(context)!.deleteAllQuestion,
        content: AppLocalizations.of(context)!.moveToRecycleBin,
        confirmText: AppLocalizations.of(context)!.deleteAll,
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

  void _addClipboardItem() {
    context.push(AppRouter.clipboardEdit);
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
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

    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isSelectionMode) {
          setState(() {
            _isSelectionMode = false;
            _selectedIds.clear();
          });
        }
      },
      child: GlassScaffold(
        showBackArrow: false,
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
        body: DynamicBackground(
          child: Column(
            children: [
              _buildCustomTopBar(),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: onSurfaceColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(
                      AppConstants.cornerRadius,
                    ),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.1),
                      width: AppConstants.borderWidth,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchClips,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: onSurfaceColor.withValues(alpha: 0.5),
                      ),
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: onSurfaceColor.withValues(alpha: 0.5),
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () => _searchController.clear(),
                              child: Icon(
                                CupertinoIcons.xmark_circle,
                                color: onSurfaceColor.withValues(alpha: 0.5),
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

              // 3. Main List
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    ValueListenableBuilder<List<ClipboardItem>>(
                      valueListenable: _filteredClipsNotifier,
                      builder: (context, items, _) {
                        if (items.isEmpty) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: EmptyStateWidget(
                                message: AppLocalizations.of(
                                  context,
                                )!.clipboardEmpty,
                                subMessage: "Copied items will appear here.",
                                assetPath: "assets/images/clipboard_empty.svg",
                                onAction: _addClipboardItem,
                                actionLabel: AppLocalizations.of(
                                  context,
                                )!.addItem,
                              ),
                            ),
                          );
                        }

                        final canReorder =
                            _currentSort == ClipSortOption.custom &&
                            _searchQuery.isEmpty &&
                            !_isSelectionMode;

                        if (canReorder) {
                          return SliverReorderableList(
                            itemCount: items.length,
                            onReorder: _onReorder,
                            proxyDecorator: (child, index, animation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (BuildContext context, Widget? child) {
                                  final double animValue = Curves.easeInOut
                                      .transform(animation.value);
                                  final double scale = ui.lerpDouble(
                                    1,
                                    1.1,
                                    animValue,
                                  )!;
                                  return Transform.scale(
                                    scale: scale,
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 10,
                                      shadowColor: Colors.black45,
                                      child: child,
                                    ),
                                  );
                                },
                                child: child,
                              );
                            },
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ReorderableDelayedDragStartListener(
                                key: ValueKey(item.id),
                                index: index,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: RepaintBoundary(
                                    child: ClipboardCard(
                                      item: item,
                                      isSelected: _selectedIds.contains(
                                        item.id,
                                      ),
                                      onTap: () => _openEditor(item),
                                      onLongPress: null,
                                      onCopy: () => _copyToClipboard(item),
                                      // ignore: deprecated_member_use
                                      onShare: () => Share.share(
                                        _getCleanText(item.content),
                                      ),
                                      onDelete: () => _confirmDelete(item),
                                      onColorChanged: (newColor) {
                                        item.colorValue = newColor.toARGB32();
                                        item.save();
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final item = items[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: RepaintBoundary(
                                    child: ClipboardCard(
                                      key: ValueKey(item.id),
                                      item: item,
                                      isSelected: _selectedIds.contains(
                                        item.id,
                                      ),
                                      onTap: () => _openEditor(item),
                                      onLongPress: () => setState(() {
                                        _isSelectionMode = true;
                                        _selectedIds.add(item.id);
                                      }),
                                      onCopy: () => _copyToClipboard(item),
                                      // ignore: deprecated_member_use
                                      onShare: () => Share.share(
                                        _getCleanText(item.content),
                                      ),

                                      onDelete: () => _confirmDelete(item),
                                      onColorChanged: (newColor) {
                                        item.colorValue = newColor.toARGB32();
                                        item.save();
                                      },
                                    ),
                                  ),
                                );
                              }, childCount: items.length),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTopBar() {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;

    if (_isSelectionMode) {
      return SeamlessHeader(
        title: AppLocalizations.of(context)!.selectedItems(_selectedIds.length),
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
      title: AppLocalizations.of(context)!.clipboard,
      subtitle: AppLocalizations.of(context)!.recentClips,
      icon: CupertinoIcons.doc_on_clipboard,
      iconColor: FeatureColors.clipboard,
      heroTagPrefix: 'clipboard',
      actions: [
        IconButton(
          icon: Icon(
            CupertinoIcons.checkmark_circle,
            color: onSurfaceColor.withValues(alpha: 0.54),
          ),
          onPressed: () => setState(() => _isSelectionMode = true),
        ),
        // SORT MENU
        PopupMenuButton<ClipSortOption>(
          icon: Icon(CupertinoIcons.slider_horizontal_3, color: onSurfaceColor),
          tooltip: AppLocalizations.of(context)!.sortItems,
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
                        AppLocalizations.of(context)!.customOrder,
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
                        AppLocalizations.of(context)!.newestFirst,
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
                        AppLocalizations.of(context)!.oldestFirst,
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

  void _copyToClipboard(ClipboardItem item) {
    Clipboard.setData(ClipboardData(text: _getCleanText(item.content)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copied),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
