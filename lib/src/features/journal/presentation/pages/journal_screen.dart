import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:share_plus/share_plus.dart';

// Core Widgets
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:copyclip/src/core/utils/widget_sync_service.dart';
import '../../../../core/router/app_router.dart';

// Data
import 'package:copyclip/src/features/journal/data/journal_model.dart';

// Widgets
import '../widgets/journal_card.dart';

enum JournalSortOption { custom, dateNewest, dateOldest, mood }

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // UI Controllers
  final TextEditingController _searchController = TextEditingController();

  // ✅ PERFORMANCE: This is the ONLY thing that triggers list rebuilds now
  final ValueNotifier<List<JournalEntry>> _filteredEntriesNotifier =
      ValueNotifier([]);

  // Data State
  List<JournalEntry> _rawEntries = [];
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  // Filter State
  String _searchQuery = "";
  JournalSortOption _currentSort = JournalSortOption.custom;

  // Daily Wisdom Quote
  final List<String> _quotes = [
    "The best way to predict the future is to create it.",
    "Wealth consists not in having great possessions, but in having few wants.",
    "Time is the ultimate currency.",
    "Success is not final, failure is not fatal.",
    "Focus on the solution, not the problem.",
    "Your network is your net worth.",
  ];
  late String _dailyQuote;

  @override
  void initState() {
    super.initState();
    _dailyQuote = _quotes[Random().nextInt(_quotes.length)];

    // Ensure box is loaded before use
    _ensureBoxLoaded();

    // Efficient Search Listener (No setState)
    _searchController.addListener(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  /// ✅ OPTIMIZATION: Ensure box is loaded before use
  Future<void> _ensureBoxLoaded() async {
    await LazyBoxLoader.getBox<JournalEntry>('journal_box');
    if (mounted) {
      _refreshEntries();
      // Database Listener (Background update)
      Hive.box<JournalEntry>(
        'journal_box',
      ).listenable().addListener(_refreshEntries);
    }
  }

  @override
  void dispose() {
    Hive.box<JournalEntry>(
      'journal_box',
    ).listenable().removeListener(_refreshEntries);
    _searchController.dispose();
    _filteredEntriesNotifier.dispose();
    super.dispose();
  }

  // --- DATA LOGIC ---

  void _refreshEntries() {
    if (!Hive.isBoxOpen('journal_box')) return;
    final box = Hive.box<JournalEntry>('journal_box');

    // Get all non-deleted entries
    // We do this calculation here, NOT in the build method
    _rawEntries = box.values.where((e) => !e.isDeleted).toList();
    _applyFilters();
  }

  void _applyFilters() {
    List<JournalEntry> result = List.from(_rawEntries);

    // 1. Search Filter
    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (e) =>
                e.title.toLowerCase().contains(_searchQuery) ||
                e.content.toLowerCase().contains(_searchQuery) ||
                (e.tags != null &&
                    e.tags!.any(
                      (tag) => tag.toLowerCase().contains(_searchQuery),
                    )),
          )
          .toList();
    }

    // 2. Sort
    switch (_currentSort) {
      case JournalSortOption.dateNewest:
        result.sort((a, b) => b.date.compareTo(a.date));
        break;
      case JournalSortOption.dateOldest:
        result.sort((a, b) => a.date.compareTo(b.date));
        break;
      case JournalSortOption.mood:
        result.sort((a, b) => a.mood.compareTo(b.mood));
        break;
      case JournalSortOption.custom:
        result.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
        break;
    }

    // Update UI via Notifier
    _filteredEntriesNotifier.value = result;
  }

  // --- ACTIONS ---

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    final currentList = List<JournalEntry>.from(_filteredEntriesNotifier.value);
    final item = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, item);

    // Update UI immediately (Smoothness)
    _filteredEntriesNotifier.value = currentList;

    // Update DB in background (Don't await)
    for (int i = 0; i < currentList.length; i++) {
      currentList[i].sortIndex = i;
      currentList[i].save();
    }
  }

  String _formatJournalForExport(JournalEntry entry) {
    String body = "";
    try {
      final List<dynamic> delta = jsonDecode(entry.content);
      for (var op in delta) {
        if (op is Map && op['insert'] is String) body += op['insert'];
      }
    } catch (e) {
      body = entry.content;
    }

    final dateStr = DateFormat('EEEE, MMM dd, yyyy').format(entry.date);
    final tagsStr = (entry.tags != null && entry.tags!.isNotEmpty)
        ? "\nTags: #${entry.tags!.join(' #')}"
        : "";

    return "📅 $dateStr\nMood: ${_getMoodEmoji(entry.mood)} ${entry.mood}\n\nTITLE: ${entry.title}\n--------------------------\n${body.trim()}\n$tagsStr";
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Happy':
        return '😊';
      case 'Excited':
        return '🤩';
      case 'Neutral':
        return '😐';
      case 'Sad':
        return '😔';
      case 'Stressed':
        return '😫';
      default:
        return '😐';
    }
  }

  void _copyEntry(JournalEntry entry) {
    Clipboard.setData(ClipboardData(text: _formatJournalForExport(entry)));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Entry copied"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareEntry(JournalEntry entry) {
    Share.share(_formatJournalForExport(entry));
  }

  void _confirmDeleteEntry(JournalEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move to Bin?",
        content: "You can restore this later.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          entry.isDeleted = true;
          entry.deletedAt = DateTime.now();
          entry.save();
        },
      ),
    );
  }

  void _deleteSelected() {
    final now = DateTime.now();
    for (var id in _selectedIds) {
      try {
        final entry = _rawEntries.firstWhere((e) => e.id == id);
        entry.isDeleted = true;
        entry.deletedAt = now;
        entry.save();
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
        content: "Move all active entries to Recycle Bin?",
        confirmText: "Delete All",
        isDestructive: true,
        onConfirm: () {
          final now = DateTime.now();
          for (var entry in _rawEntries) {
            entry.isDeleted = true;
            entry.deletedAt = now;
            entry.save();
          }
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _openEditor(JournalEntry? entry) {
    if (_isSelectionMode) {
      if (entry != null) _toggleSelection(entry.id);
      return;
    }
    context.push(AppRouter.journalEdit, extra: entry);
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
      if (_selectedIds.length == _rawEntries.length) {
        _selectedIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedIds.addAll(_rawEntries.map((e) => e.id));
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
                onPressed: () => _openEditor(null),
                backgroundColor: FeatureColors.journal,
                child: Icon(
                  CupertinoIcons.add,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
        body: Column(
          children: [
            _buildCustomTopBar(),

            // Daily Quote (Static content, cheap to build)
            if (!_isSelectionMode && _searchQuery.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: onSurfaceColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(
                      AppConstants.cornerRadius,
                    ),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.1),
                      width: AppConstants.borderWidth,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.lightbulb,
                        color: Colors.amberAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _dailyQuote,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onSurfaceColor.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Search Bar (Static container)
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                top: 0,
                bottom: 8,
              ),
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
                    hintText: 'Search memories...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: onSurfaceColor.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: onSurfaceColor.withOpacity(0.5),
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              CupertinoIcons.xmark_circle,
                              size: 18,
                            ),
                            onPressed: _searchController.clear,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),

            // Entry List
            // ✅ OPTIMIZATION: Only this part rebuilds on data change
            Expanded(
              child: ValueListenableBuilder<List<JournalEntry>>(
                valueListenable: _filteredEntriesNotifier,
                builder: (context, entries, _) {
                  if (entries.isEmpty) {
                    return Center(
                      child: Text(
                        "Start writing your story.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: onSurfaceColor.withOpacity(0.4),
                        ),
                      ),
                    );
                  }

                  // ✅ OPTIMIZATION: Grid View with Reorder support
                  return ReorderableGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.70, // Book-like aspect ratio
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    physics: const BouncingScrollPhysics(),
                    // Custom Drag Feedback: Transparent bg + Scale up
                    dragWidgetBuilder: (index, child) {
                      return Material(
                        color: Colors
                            .transparent, // Remove default elevation color
                        child: Transform.scale(
                          scale: 1.08, // Increase size to indicate drag
                          child: child,
                        ),
                      );
                    },
                    onReorder: _onReorder,
                    children: entries.map((entry) {
                      return Container(
                        key: ValueKey(entry.id),
                        child: JournalCard(
                          entry: entry,
                          isSelected: _selectedIds.contains(entry.id),
                          onTap: () => _openEditor(entry),
                          onLongPress: null, // Allow GridView drag
                          onCopy: () => _copyEntry(entry),
                          onShare: () => _shareEntry(entry),
                          onDelete: () => _confirmDeleteEntry(entry),
                          onColorChanged: (c) {
                            entry.colorValue = c.value;
                            entry.save();
                          },
                          onDesignChanged: (designId) {
                            entry.designId = designId;
                            entry.save();
                            WidgetSyncService.syncJournal();
                          },
                        ),
                      );
                    }).toList(),
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
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;

    if (_isSelectionMode) {
      return SeamlessHeader(
        title: '${_selectedIds.length} Selected',
        heroTagPrefix: 'journal',
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
      title: "Journal",
      subtitle: "My Memories",
      icon: CupertinoIcons.book,
      iconColor: Colors.blueAccent,
      heroTagPrefix: 'journal',
      actions: [
        IconButton(
          icon: Icon(
            CupertinoIcons.checkmark_circle,
            color: onSurfaceColor.withOpacity(0.54),
          ),
          onPressed: () => setState(() => _isSelectionMode = true),
        ),
        // SORT MENU
        PopupMenuButton<JournalSortOption>(
          icon: Icon(CupertinoIcons.slider_horizontal_3, color: onSurfaceColor),
          tooltip: 'Sort Journal',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (JournalSortOption result) {
            setState(() {
              _currentSort = result;
              _applyFilters();
            });
          },
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<JournalSortOption>>[
                PopupMenuItem<JournalSortOption>(
                  value: JournalSortOption.custom,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.arrow_up_arrow_down,
                        size: 18,
                        color: _currentSort == JournalSortOption.custom
                            ? FeatureColors.journal
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Custom Order",
                        style: TextStyle(
                          color: _currentSort == JournalSortOption.custom
                              ? FeatureColors.journal
                              : null,
                          fontWeight: _currentSort == JournalSortOption.custom
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<JournalSortOption>(
                  value: JournalSortOption.dateNewest,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar_today,
                        size: 18,
                        color: _currentSort == JournalSortOption.dateNewest
                            ? FeatureColors.journal
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Newest First",
                        style: TextStyle(
                          color: _currentSort == JournalSortOption.dateNewest
                              ? FeatureColors.journal
                              : null,
                          fontWeight:
                              _currentSort == JournalSortOption.dateNewest
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<JournalSortOption>(
                  value: JournalSortOption.dateOldest,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.time,
                        size: 18,
                        color: _currentSort == JournalSortOption.dateOldest
                            ? FeatureColors.journal
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Oldest First",
                        style: TextStyle(
                          color: _currentSort == JournalSortOption.dateOldest
                              ? FeatureColors.journal
                              : null,
                          fontWeight:
                              _currentSort == JournalSortOption.dateOldest
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<JournalSortOption>(
                  value: JournalSortOption.mood,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.smiley,
                        size: 18,
                        color: _currentSort == JournalSortOption.mood
                            ? FeatureColors.journal
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "By Mood",
                        style: TextStyle(
                          color: _currentSort == JournalSortOption.mood
                              ? FeatureColors.journal
                              : null,
                          fontWeight: _currentSort == JournalSortOption.mood
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
