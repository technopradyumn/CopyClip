import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';

// Models & Cards
import '../../../clipboard/data/clipboard_model.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';
import '../../../clipboard/presentation/widgets/clipboard_card.dart';
import '../../../expenses/presentation/widgets/expense_card.dart';
import '../../../journal/presentation/widgets/journal_list_card.dart';
import '../../../notes/presentation/widgets/note_card.dart';
import '../../../todos/presentation/widgets/todo_card.dart';

class DateDetailsScreen extends StatefulWidget {
  final DateTime date;
  final List<GlobalSearchResult> items;

  const DateDetailsScreen({super.key, required this.date, required this.items});

  @override
  State<DateDetailsScreen> createState() => _DateDetailsScreenState();
}

class _DateDetailsScreenState extends State<DateDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // ✅ PERFORMANCE: Notifier for the filtered list
  final ValueNotifier<List<GlobalSearchResult>> _filteredListNotifier =
      ValueNotifier([]);

  // Data Source
  late List<GlobalSearchResult> _allData;

  // Filters
  String _searchQuery = "";
  String _selectedFilter = "All";
  final List<String> _filters = [
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
    _allData = List.from(widget.items);
    _applyFilters(); // Initial population

    // Listen to search efficiently
    _searchController.addListener(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredListNotifier.dispose();
    super.dispose();
  }

  // --- DATA LOGIC ---

  void _refreshData() {
    final dateKey = DateFormat('yyyy-MM-dd').format(widget.date);
    List<GlobalSearchResult> freshResults = [];

    void safeAdd<T>(String boxName, GlobalSearchResult Function(T) mapper) {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box<T>(boxName);
        freshResults.addAll(
          box.values
              .where((e) {
                // Safe check for deleted and date match
                try {
                  final dynamic item = e;
                  if (item.isDeleted == true) return false;

                  // Use the unified 'date' getter we added to models
                  final dateToCheck = item.date;
                  if (dateToCheck == null) return false;

                  return DateFormat('yyyy-MM-dd').format(dateToCheck) ==
                      dateKey;
                } catch (_) {
                  return false;
                }
              })
              .map(mapper),
        );
      }
    }

    safeAdd<Note>(
      'notes_box',
      (e) => GlobalSearchResult(
        id: e.id,
        title: e.title,
        subtitle: e.content,
        type: 'Note',
        route: AppRouter.noteEdit,
        argument: e,
      ),
    );
    safeAdd<Todo>(
      'todos_box',
      (e) => GlobalSearchResult(
        id: e.id,
        title: e.task,
        subtitle: e.isDone ? "Completed" : "Pending",
        type: 'Todo',
        route: AppRouter.todoEdit,
        argument: e,
        isCompleted: e.isDone,
      ),
    );
    safeAdd<Expense>(
      'expenses_box',
      (e) => GlobalSearchResult(
        id: e.id,
        title: e.title,
        subtitle: "${e.currency}${e.amount}",
        type: 'Expense',
        route: AppRouter.expenseEdit,
        argument: e,
      ),
    );
    safeAdd<JournalEntry>(
      'journal_box',
      (e) => GlobalSearchResult(
        id: e.id,
        title: e.title,
        subtitle: e.content,
        type: 'Journal',
        route: AppRouter.journalEdit,
        argument: e,
      ),
    );
    safeAdd<ClipboardItem>(
      'clipboard_box',
      (e) => GlobalSearchResult(
        id: e.id,
        title: e.content,
        subtitle: "Clipboard",
        type: 'Clipboard',
        route: AppRouter.clipboardEdit,
        argument: e,
      ),
    );

    _allData = freshResults;
    _applyFilters();
  }

  void _applyFilters() {
    List<GlobalSearchResult> filtered = _allData.where((item) {
      // 1. Text Filter
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        matchesSearch =
            item.title.toLowerCase().contains(_searchQuery) ||
            item.subtitle.toLowerCase().contains(_searchQuery);
      }

      // 2. Type Filter
      bool matchesFilter =
          _selectedFilter == "All" || item.type == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();

    // Update Notifier
    _filteredListNotifier.value = filtered;
  }

  // --- UI BUILDERS ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return GlassScaffold(
      showBackArrow: false,
      title: null,
      body: Column(
        children: [
          _buildTopBar(theme, onSurface),
          _buildSearchBar(theme, onSurface),
          _buildFilterChips(theme, onSurface),

          // ✅ PERFORMANCE: ValueListenableBuilder
          Expanded(
            child: ValueListenableBuilder<List<GlobalSearchResult>>(
              valueListenable: _filteredListNotifier,
              builder: (context, displayItems, _) {
                if (displayItems.isEmpty) {
                  return _buildEmptyState(onSurface);
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: displayItems.length,
                  // ✅ PERFORMANCE: Cache items ahead of scroll
                  cacheExtent: 1000,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    // ✅ PERFORMANCE: RepaintBoundary prevents lag
                    return RepaintBoundary(
                      child: _buildItemCard(displayItems[index]),
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

  Widget _buildTopBar(ThemeData theme, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: onSurface,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              DateFormat('MMMM d, yyyy').format(widget.date),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
          ),
          // Wrap this text in a builder or notifier if the count needs to update dynamically
          // For now, it shows total loaded items which is fine.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${_allData.length} total",
              style: TextStyle(fontSize: 11, color: onSurface.withOpacity(0.6)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: onSurface.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          // Removed setState onChanged; handled by listener
          style: TextStyle(color: onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: "Search in this day...",
            hintStyle: TextStyle(
              color: onSurface.withOpacity(0.4),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.primary,
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
    );
  }

  Widget _buildFilterChips(ThemeData theme, Color onSurface) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter == "Todo"
                    ? "To-Dos"
                    : filter == "Expense"
                    ? "Finance"
                    : filter,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : onSurface.withOpacity(0.8),
                ),
              ),
              selected: isSelected,
              onSelected: (val) {
                setState(() => _selectedFilter = filter);
                _applyFilters();
              },
              backgroundColor: onSurface.withOpacity(0.06),
              selectedColor: theme.colorScheme.primary.withOpacity(0.15),
              checkmarkColor: theme.colorScheme.primary,
              showCheckmark: true,
              pressElevation: 0,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : onSurface.withOpacity(0.12),
                  width: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(Color onSurface) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: onSurface.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Text(
            "No items found matching criteria",
            style: TextStyle(color: onSurface.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(GlobalSearchResult res) {
    // Assuming the Cards (NoteCard, TodoCard, etc.) have been updated to the
    // optimized versions (using BoxDecoration instead of GlassContainer) provided earlier.
    switch (res.type) {
      case 'Note':
        return NoteCard(
          note: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _refreshData();
          },
          onDelete: () => _deleteItem(res),
          onColorChanged: (c) {
            res.argument.colorValue = c.value;
            res.argument.save();
            _refreshData();
          },
          onCopy: () => Clipboard.setData(ClipboardData(text: res.subtitle)),
          onShare: () => Share.share(res.subtitle),
        );
      case 'Todo':
        return TodoCard(
          todo: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _refreshData();
          },
          onToggleDone: () {
            res.argument.isDone = !res.argument.isDone;
            res.argument.save();
            _refreshData();
          },
        );
      case 'Expense':
        return ExpenseCard(
          expense: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _refreshData();
          },
        );
      case 'Journal':
        return JournalListCard(
          entry: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _refreshData();
          },
          onDelete: () => _deleteItem(res),
          onDesignChanged: (id) {
            res.argument.designId = id;
            res.argument.save();
            _refreshData();
          },
          onCopy: () => Clipboard.setData(ClipboardData(text: res.subtitle)),
          onShare: () => Share.share(res.subtitle),
        );
      case 'Clipboard':
        return ClipboardCard(
          item: res.argument,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: res.argument);
            _refreshData();
          },
          onDelete: () => _deleteItem(res),
          onColorChanged: (c) {
            res.argument.colorValue = c.value;
            res.argument.save();
            _refreshData();
          },
          onCopy: () => Clipboard.setData(ClipboardData(text: res.title)),
          onShare: () => Share.share(res.title),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _deleteItem(GlobalSearchResult res) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete Item?",
        content: "This will move the item to the recycle bin.",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () {
          final dynamic item = res.argument;
          try {
            item.isDeleted = true;
            item.deletedAt = DateTime.now();
            item.save();
          } catch (_) {}
          Navigator.pop(ctx);
          _refreshData();
        },
      ),
    );
  }
}
