import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';

// Models
import '../../../../core/app_content_palette.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';
import '../../../canvas/data/canvas_model.dart';
import '../../../canvas/data/canvas_adapter.dart';

// Cards
import '../../../clipboard/presentation/widgets/clipboard_card.dart';
import '../../../expenses/presentation/widgets/expense_card.dart';
import '../../../journal/presentation/widgets/journal_card.dart';
import '../../../notes/presentation/widgets/note_card.dart';
import '../../../todos/presentation/widgets/todo_card.dart';
import '../../../canvas/presentation/widgets/canvas_sketch_card.dart';
import 'dashboard_screen.dart';

class SearchResult extends GlobalSearchResult {
  final DateTime dateTime;
  final int? colorValue;

  SearchResult({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.type,
    required super.route,
    required this.dateTime,
    this.colorValue,
    super.argument,
  });
}

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // ✅ PERFORMANCE: Notifier for the list content
  // Updates to this notifier only rebuild the ListView, not the whole screen.
  final ValueNotifier<List<SearchResult>> _filteredListNotifier = ValueNotifier(
    [],
  );

  // Data Store
  List<SearchResult> _allData = [];

  // Filter State
  String _query = "";
  String _selectedType = "All";
  String _sortBy = "Newest";
  String _dateRange = "All Time";
  int? _filterColor;

  final List<String> _filterTypes = [
    "All",
    "Note",
    "Todo",
    "Expense",
    "Journal",
    "Clipboard",
    "Canvas",
  ];

  @override
  void initState() {
    super.initState();
    _loadAllData();

    // ✅ Listen to text changes efficiently
    _searchController.addListener(() {
      _query = _searchController.text;
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredListNotifier.dispose();
    super.dispose();
  }

  // --- DATA LOADING ---
  void _loadAllData() {
    List<SearchResult> results = [];

    // ✅ FIX: Change 'Function(T)' to 'SearchResult Function(T)' to prevent type errors
    void safeAdd<T>(String boxName, SearchResult Function(T) mapper) {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box<T>(boxName);
        results.addAll(
          box.values
              .where((e) {
                try {
                  return (e as dynamic).isDeleted == false;
                } catch (_) {
                  return true;
                }
              })
              .map(mapper),
        );
      }
    }

    safeAdd<Note>(
      'notes_box',
      (e) => SearchResult(
        id: e.id,
        title: e.title,
        subtitle: e.content,
        type: 'Note',
        route: AppRouter.noteEdit,
        argument: e,
        dateTime: e.updatedAt,
        colorValue: e.colorValue,
      ),
    );
    safeAdd<JournalEntry>(
      'journal_box',
      (e) => SearchResult(
        id: e.id,
        title: e.title,
        subtitle: e.content,
        type: 'Journal',
        route: AppRouter.journalEdit,
        argument: e,
        dateTime: e.date,
        colorValue: e.colorValue,
      ),
    );
    safeAdd<ClipboardItem>(
      'clipboard_box',
      (e) => SearchResult(
        id: e.id,
        title: e.content,
        subtitle: "Clipboard",
        type: 'Clipboard',
        route: AppRouter.clipboardEdit,
        argument: e,
        dateTime: e.createdAt,
        colorValue: e.colorValue,
      ),
    );
    safeAdd<Todo>(
      'todos_box',
      (e) => SearchResult(
        id: e.id,
        title: e.task,
        subtitle: e.isDone ? "Completed" : "Pending",
        type: 'Todo',
        route: AppRouter.todoEdit,
        argument: e,
        dateTime: e.dueDate ?? DateTime.now(),
      ),
    );
    safeAdd<Expense>(
      'expenses_box',
      (e) => SearchResult(
        id: e.id,
        title: e.title,
        subtitle: "${e.currency}${e.amount}",
        type: 'Expense',
        route: AppRouter.expenseEdit,
        argument: e,
        dateTime: e.date,
      ),
    );
    safeAdd<CanvasNote>(
      'canvas_notes',
      (e) => SearchResult(
        id: e.id,
        title: e.title,
        subtitle: e.description ?? 'Canvas sketch',
        type: 'Canvas',
        route: AppRouter.canvasEdit,
        argument: {'noteId': e.id},
        dateTime: e.lastModified,
      ),
    );

    _allData = results;
    _applyFilters();
  }

  // --- FILTERING ENGINE (Optimized) ---
  void _applyFilters() {
    List<SearchResult> filtered = _allData;
    final queryLower = _query.toLowerCase();

    // 1. Text Search (Fastest check first)
    if (queryLower.isNotEmpty) {
      filtered = filtered
          .where(
            (item) =>
                item.title.toLowerCase().contains(queryLower) ||
                item.subtitle.toLowerCase().contains(queryLower),
          )
          .toList();
    }

    // 2. Type Filter
    if (_selectedType != "All") {
      filtered = filtered.where((item) => item.type == _selectedType).toList();
    }

    // 3. Color Filter
    if (_filterColor != null) {
      filtered = filtered
          .where((item) => item.colorValue == _filterColor)
          .toList();
    }

    // 4. Date Filter
    if (_dateRange != "All Time") {
      final now = DateTime.now();
      if (_dateRange == "Today") {
        filtered = filtered
            .where(
              (item) =>
                  item.dateTime.day == now.day &&
                  item.dateTime.month == now.month &&
                  item.dateTime.year == now.year,
            )
            .toList();
      } else if (_dateRange == "This Week") {
        final lastWeek = now.subtract(const Duration(days: 7));
        filtered = filtered
            .where((item) => item.dateTime.isAfter(lastWeek))
            .toList();
      }
    }

    // 5. Sorting
    if (_sortBy == "Newest") {
      filtered.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (_sortBy == "Oldest") {
      filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (_sortBy == "A-Z") {
      filtered.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    }

    // ✅ UPDATE NOTIFIER: This only triggers the list to rebuild, nothing else
    _filteredListNotifier.value = filtered;
  }

  // --- UI BUILDERS ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassScaffold(
      showBackArrow: false,
      title: null,
      body: Column(
        children: [
          const SizedBox(height: 8), // Top padding
          _buildIntegratedSearchBar(theme),
          const SizedBox(height: 12),
          _buildHorizontalFilterChips(theme),
          const SizedBox(height: 8),

          // ✅ LIST SECTION
          Expanded(
            child: ValueListenableBuilder<List<SearchResult>>(
              valueListenable: _filteredListNotifier,
              builder: (context, filteredItems, _) {
                if (filteredItems.isEmpty) {
                  return Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(color: theme.hintColor),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  physics: const BouncingScrollPhysics(),
                  // ✅ IMPORTANT: Renders items ahead of scroll to prevent stutter
                  cacheExtent: 2000,
                  itemCount: filteredItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    // ✅ IMPORTANT: Caches the card painting
                    return RepaintBoundary(
                      child: _buildResultCard(filteredItems[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegratedSearchBar(ThemeData theme) {
    bool hasActiveFilters =
        _filterColor != null || _dateRange != "All Time" || _sortBy != "Newest";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: theme.textTheme.bodyLarge,
                // Removed onChanged setState; listener handles it
                decoration: InputDecoration(
                  hintText: "Search workspace...",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      // Listener updates automatically
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.tune_rounded,
              color: hasActiveFilters ? theme.colorScheme.primary : null,
            ),
            onPressed: _showSortFilterSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalFilterChips(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filterTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = _filterTypes[index];
          final isSelected = _selectedType == type;

          return GestureDetector(
            onTap: () {
              // We need setState here to update the CHIP color
              setState(() => _selectedType = type);
              // Logic update
              _applyFilters();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: Text(
                type == "Todo"
                    ? "To-Dos"
                    : type == "Expense"
                    ? "Finance"
                    : type,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ IMPROVED VISIBILITY: Solid Background Bottom Sheet
  void _showSortFilterSheet() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Background transparent
      isScrollControlled: true, // Allows sheet to expand properly
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // ✅ Solid color for visibility
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
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

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sort & Filter",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _sortBy = "Newest";
                          _dateRange = "All Time";
                          _filterColor = null;
                        });
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      child: const Text("Reset"),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                _sheetSectionTitle("Sort Order"),
                Wrap(
                  spacing: 8,
                  children: ["Newest", "Oldest", "A-Z"]
                      .map(
                        (s) => ChoiceChip(
                          label: Text(s),
                          selected: _sortBy == s,
                          onSelected: (v) {
                            setSheetState(() => _sortBy = s);
                            setState(() => _sortBy = s);
                            _applyFilters();
                          },
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 16),
                _sheetSectionTitle("Timeframe"),
                Wrap(
                  spacing: 8,
                  children: ["All Time", "Today", "This Week"]
                      .map(
                        (d) => ChoiceChip(
                          label: Text(d),
                          selected: _dateRange == d,
                          onSelected: (v) {
                            setSheetState(() => _dateRange = d);
                            setState(() => _dateRange = d);
                            _applyFilters();
                          },
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 16),
                _sheetSectionTitle("Color Tag"),
                _buildColorFilterRow(setSheetState),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sheetSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
  );

  Widget _buildColorFilterRow(Function setSheetState) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final List<Color> myPalette = AppContentPalette.palette;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: myPalette.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                setSheetState(() => _filterColor = null);
                setState(() => _filterColor = null);
                _applyFilters();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: onSurface.withOpacity(0.1),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: _filterColor == null
                        ? primaryColor
                        : onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            );
          }

          final color = myPalette[index - 1];
          final isSelected = _filterColor == color.value;
          final contrastColor = AppContentPalette.getContrastColor(color);

          return GestureDetector(
            onTap: () {
              setSheetState(() => _filterColor = color.value);
              setState(() => _filterColor = color.value);
              _applyFilters();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : onSurface.withOpacity(0.2),
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 18, color: contrastColor)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultCard(SearchResult res) {
    switch (res.type) {
      case 'Note':
        return NoteCard(
          note: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _loadAllData();
          },
          onCopy: () => _copy(res),
          onShare: () => _share(res),
          onDelete: () => _delete(res),
          onColorChanged: (c) {
            (res.argument as Note).colorValue = c.value;
            (res.argument as Note).save();
            setState(() {});
          },
        );
      case 'Todo':
        return TodoCard(
          todo: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _loadAllData();
          },
          onToggleDone: () {
            (res.argument as Todo).isDone = !(res.argument as Todo).isDone;
            (res.argument as Todo).save();
            _loadAllData();
          },
        );
      case 'Expense':
        return ExpenseCard(
          expense: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _loadAllData();
          },
        );
      case 'Journal':
        return JournalCard(
          entry: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _loadAllData();
          },
          onCopy: () => _copy(res),
          onShare: () => _share(res),
          onDelete: () => _delete(res),
          onColorChanged: (c) {
            (res.argument as JournalEntry).colorValue = c.value;
            (res.argument as JournalEntry).save();
            setState(() {});
          },
        );
      case 'Clipboard':
        return ClipboardCard(
          item: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _loadAllData();
          },
          onCopy: () => _copy(res),
          onShare: () => _share(res),
          onDelete: () => _delete(res),
          onColorChanged: (c) {
            (res.argument as ClipboardItem).colorValue = c.value;
            (res.argument as ClipboardItem).save();
            setState(() {});
          },
        );
      case 'Canvas':
        // Get the actual note from the box
        final note = Hive.isBoxOpen('canvas_notes')
            ? Hive.box<CanvasNote>(
                'canvas_notes',
              ).get((res.argument as Map)['noteId'])
            : null;
        if (note == null) return const SizedBox.shrink();
        return CanvasSketchCard(
          note: note,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _loadAllData();
          },
          onLongPress: () {},
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _copy(SearchResult res) {
    Clipboard.setData(ClipboardData(text: res.title));
  }

  void _share(SearchResult res) {
    Share.share(res.title);
  }

  void _delete(SearchResult res) {
    final item = res.argument;
    try {
      item.isDeleted = true;
      item.deletedAt = DateTime.now();
      item.save();
    } catch (_) {}
    _loadAllData();
  }
}
