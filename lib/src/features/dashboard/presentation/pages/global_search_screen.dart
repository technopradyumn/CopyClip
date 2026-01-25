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

// Cards
import '../../../clipboard/presentation/widgets/clipboard_card.dart';
import '../../../expenses/presentation/widgets/expense_card.dart';
import '../../../journal/presentation/widgets/journal_list_card.dart';
import '../../../notes/presentation/widgets/note_card.dart';
import '../../../todos/presentation/widgets/todo_card.dart';

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

  // ✅ PERFORMANCE: Debounce timer to prevent freezing on rapid typing
  Timer? _debounce;

  // ✅ STATE MANAGEMENT
  final ValueNotifier<List<SearchResult>> _filteredListNotifier = ValueNotifier(
    [],
  );
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(
    true,
  ); // Start loading
  String? _errorMessage;

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
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Async initialization to not block the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _filteredListNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }

  // ✅ OPTIMIZED: Debounced Search Listener
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _query = _searchController.text;
      _applyFilters();
    });
  }

  // --- DATA LOADING (ASYNC & SAFE) ---
  Future<void> _loadAllData() async {
    _setLoading(true);
    _errorMessage = null;
    List<SearchResult> results = [];

    try {
      // ✅ Helper to safely add data with error isolation
      Future<void> safeAdd<T>(
        String boxName,
        SearchResult Function(T) mapper,
      ) async {
        try {
          if (!Hive.isBoxOpen(boxName)) return; // Skip if box not ready
          final box = Hive.box<T>(boxName);

          // Yield to UI thread to prevent freezing if box is huge
          if (box.length > 500) await Future.delayed(Duration.zero);

          final items = box.values
              .where((e) {
                try {
                  // ✅ Deep Safe Check for corrupted objects
                  if (e == null) return false;
                  return (e as dynamic).isDeleted == false;
                } catch (_) {
                  return true; // Assume not deleted if field missing (backward compat)
                }
              })
              .map((e) {
                try {
                  return mapper(e);
                } catch (e) {
                  return null; // Skip invalid items
                }
              })
              .whereType<SearchResult>()
              .toList();

          results.addAll(items);
        } catch (e) {
          debugPrint("⚠️ Partial Load Error in $boxName: $e");
          // Do not crash app, just log and continue
        }
      }

      // Load all sources
      await safeAdd<Note>(
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

      await safeAdd<JournalEntry>(
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

      await safeAdd<ClipboardItem>(
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

      await safeAdd<Todo>(
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

      await safeAdd<Expense>(
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

      _allData = results;
      _applyFilters();
    } catch (e) {
      debugPrint("❌ Critical Global Search Error: $e");
      setState(
        () => _errorMessage =
            "Unable to load data. Please try restarting the app.",
      );
    } finally {
      if (mounted) _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (mounted) _isLoadingNotifier.value = loading;
  }

  // --- FILTERING ENGINE (Optimized) ---
  Future<void> _applyFilters() async {
    // ✅ Run filtering asynchronously to unblock UI
    // For very large lists, we could perform this in a compute() isolate,
    // but simple async yielding is usually enough for <10k items.

    _setLoading(true); // Show spinner if filtering takes time

    // Simulate slight delay to let UI breathe
    await Future.delayed(Duration.zero);

    List<SearchResult> filtered = List.of(_allData);
    final queryLower = _query.toLowerCase().trim();

    try {
      // 1. Text Search
      if (queryLower.isNotEmpty) {
        filtered = filtered.where((item) {
          final t = item.title.toLowerCase();
          final s = item.subtitle.toLowerCase();
          return t.contains(queryLower) || s.contains(queryLower);
        }).toList();
      }

      // 2. Type Filter
      if (_selectedType != "All") {
        filtered = filtered
            .where((item) => item.type == _selectedType)
            .toList();
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
                    item.dateTime.year == now.year &&
                    item.dateTime.month == now.month &&
                    item.dateTime.day == now.day,
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

      // ✅ Update UI
      if (mounted) _filteredListNotifier.value = filtered;
    } catch (e) {
      debugPrint("⚠️ Filtering Error: $e");
    } finally {
      _setLoading(false);
    }
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
          const SizedBox(height: 8),
          _buildIntegratedSearchBar(theme),
          const SizedBox(height: 12),
          _buildHorizontalFilterChips(theme),
          const SizedBox(height: 8),

          // ✅ LIST SECTION WITH LOADING STATE
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _isLoadingNotifier,
              builder: (context, isLoading, _) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: theme.hintColor),
                        ),
                        TextButton(
                          onPressed: _loadAllData,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                return ValueListenableBuilder<List<SearchResult>>(
                  valueListenable: _filteredListNotifier,
                  builder: (context, filteredItems, _) {
                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: theme.dividerColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No results found",
                              style: TextStyle(color: theme.hintColor),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      physics: const BouncingScrollPhysics(),
                      // ✅ PERFORMANCE: Reasonable cache extent
                      cacheExtent: 500,
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return RepaintBoundary(
                          child: _buildResultCard(filteredItems[index]),
                        );
                      },
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
                // Listener handles updates via debouncer now
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
              setState(() => _selectedType = type);
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

  // ✅ IMPROVED VISIBILITY: Dialog for Sort & Filter
  void _showSortFilterSheet() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sort & Filter"),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _sortBy = "Newest";
                      _dateRange = "All Time";
                      _filterColor = null;
                    });
                    _applyFilters();
                    setSheetState(() {});
                    // Don't close, just reset
                  },
                  child: const Text("Reset"),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
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
        return JournalListCard(
          entry: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _loadAllData();
          },
          onCopy: () => _copy(res),
          onShare: () => _share(res),
          onDelete: () => _delete(res),
          onDesignChanged: (id) {
            (res.argument as JournalEntry).designId = id;
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
    try {
      final item = res.argument;
      item.isDeleted = true;
      item.deletedAt = DateTime.now();
      item.save();
    } catch (_) {}
    _loadAllData();
  }
}
