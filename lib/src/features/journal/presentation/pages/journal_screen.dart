import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

// Core Widgets
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
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
                backgroundColor: theme.colorScheme.primary,
                child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
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
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
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
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.1),
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
                      Icons.search,
                      color: onSurfaceColor.withOpacity(0.5),
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18),
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

                  final canReorder =
                      _currentSort == JournalSortOption.custom &&
                      _searchQuery.isEmpty &&
                      !_isSelectionMode;

                  if (canReorder) {
                    return ReorderableListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: entries.length,
                      onReorder: _onReorder,
                      // Lightweight proxy decoration
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
                        final entry = entries[index];
                        return Container(
                          key: ValueKey(entry.id),
                          child: JournalCard(
                            entry: entry,
                            isSelected: _selectedIds.contains(entry.id),
                            onTap: () => _openEditor(entry),
                            onLongPress: null, // Allow drag
                            onCopy: () => _copyEntry(entry),
                            onShare: () => _shareEntry(entry),
                            onDelete: () => _confirmDeleteEntry(entry),
                            onColorChanged: (c) {
                              entry.colorValue = c.value;
                              entry.save();
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    // ✅ OPTIMIZATION: Standard ListView with Cache Extent & RepaintBoundary
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: entries.length,
                      cacheExtent: 1500, // Pre-render more items
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return RepaintBoundary(
                          child: JournalCard(
                            key: ValueKey(entry.id), // Important for diffing
                            entry: entry,
                            isSelected: _selectedIds.contains(entry.id),
                            onTap: () => _openEditor(entry),
                            onLongPress: () => setState(() {
                              _isSelectionMode = true;
                              _selectedIds.add(entry.id);
                            }),
                            onCopy: () => _copyEntry(entry),
                            onShare: () => _shareEntry(entry),
                            onDelete: () => _confirmDeleteEntry(entry),
                            onColorChanged: (c) {
                              entry.colorValue = c.value;
                              entry.save();
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
                      const Hero(
                        tag: 'journal_icon',
                        child: Icon(
                          Icons.book_outlined,
                          size: 28,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Hero(
                        tag: 'journal_title',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "Journal",
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
      builder: (context) => StatefulBuilder(
        // Enables instant UI updates in sheet
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // Solid color
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildSortOption(
                  JournalSortOption.custom,
                  "Custom Order (Drag & Drop)",
                ),
                _buildSortOption(JournalSortOption.dateNewest, "Newest First"),
                _buildSortOption(JournalSortOption.dateOldest, "Oldest First"),
                _buildSortOption(JournalSortOption.mood, "Group by Mood"),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOption(JournalSortOption option, String label) {
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
