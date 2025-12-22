import 'dart:convert';
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
import '../../../journal/presentation/widgets/journal_card.dart';
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

  // Logic State
  String _query = "";
  String _selectedType = "All";
  String _sortBy = "Newest";
  String _dateRange = "All Time";
  int? _filterColor;

  List<SearchResult> _allData = [];
  final List<String> _filterTypes = ["All", "Note", "Todo", "Expense", "Journal", "Clipboard"];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- DATA LOADING ---
  void _loadAllData() {
    List<SearchResult> results = [];

    // 1. Load Notes
    if (Hive.isBoxOpen('notes_box')) {
      final box = Hive.box<Note>('notes_box');
      results.addAll(box.values.where((e) => !e.isDeleted).map((e) => SearchResult(
        id: e.id,
        title: e.title,
        subtitle: e.content,
        type: 'Note',
        route: AppRouter.noteEdit,
        argument: e,
        dateTime: e.updatedAt,
        colorValue: e.colorValue,
      )));
    }

    // 2. Load Journal
    if (Hive.isBoxOpen('journal_box')) {
      final box = Hive.box<JournalEntry>('journal_box');
      results.addAll(box.values.where((e) => !e.isDeleted).map((e) => SearchResult(
        id: e.id,
        title: e.title,
        subtitle: e.content,
        type: 'Journal',
        route: AppRouter.journalEdit,
        argument: e,
        dateTime: e.date,
        colorValue: e.colorValue,
      )));
    }

    // 3. Load Clipboard
    if (Hive.isBoxOpen('clipboard_box')) {
      final box = Hive.box<ClipboardItem>('clipboard_box');
      results.addAll(box.values.where((e) => !e.isDeleted).map((e) => SearchResult(
        id: e.id,
        title: e.content,
        subtitle: "Clipboard",
        type: 'Clipboard',
        route: AppRouter.clipboardEdit,
        argument: e,
        dateTime: e.createdAt,
        colorValue: e.colorValue,
      )));
    }

    // 4. Load Todos
    if (Hive.isBoxOpen('todos_box')) {
      final box = Hive.box<Todo>('todos_box');
      results.addAll(box.values.where((e) => !e.isDeleted).map((e) => SearchResult(
        id: e.id,
        title: e.task,
        subtitle: e.isDone ? "Completed" : "Pending",
        type: 'Todo',
        route: AppRouter.todoEdit,
        argument: e,
        dateTime: e.dueDate ?? DateTime.now(),
      )));
    }

    // 5. Load Expenses
    if (Hive.isBoxOpen('expenses_box')) {
      final box = Hive.box<Expense>('expenses_box');
      results.addAll(box.values.where((e) => !e.isDeleted).map((e) => SearchResult(
        id: e.id,
        title: e.title,
        subtitle: "${e.currency}${e.amount}",
        type: 'Expense',
        route: AppRouter.expenseEdit,
        argument: e,
        dateTime: e.date,
      )));
    }

    setState(() => _allData = results);
  }

  // --- FILTERING & SORTING ENGINE ---
  List<SearchResult> _getFilteredItems() {
    List<SearchResult> filtered = _allData.where((item) {
      final matchesQuery = item.title.toLowerCase().contains(_query.toLowerCase()) ||
          item.subtitle.toLowerCase().contains(_query.toLowerCase());
      final matchesType = _selectedType == "All" || item.type == _selectedType;
      final matchesColor = _filterColor == null || item.colorValue == _filterColor;

      bool matchesDate = true;
      final now = DateTime.now();
      if (_dateRange == "Today") {
        matchesDate = item.dateTime.day == now.day && item.dateTime.month == now.month && item.dateTime.year == now.year;
      } else if (_dateRange == "This Week") {
        matchesDate = item.dateTime.isAfter(now.subtract(const Duration(days: 7)));
      }

      return matchesQuery && matchesType && matchesColor && matchesDate;
    }).toList();

    if (_sortBy == "Newest") filtered.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    else if (_sortBy == "Oldest") filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    else if (_sortBy == "A-Z") filtered.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    return filtered;
  }

  // --- UI BUILDERS ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _getFilteredItems();

    return GlassScaffold(
      showBackArrow: false,
      title: null,
      body: Column(
        children: [
          const SizedBox(height: 52),
          _buildIntegratedSearchBar(theme),
          const SizedBox(height: 12),
          _buildHorizontalFilterChips(theme),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              cacheExtent: 1000,
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildResultCard(filtered[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegratedSearchBar(ThemeData theme) {
    bool hasActiveFilters = _filterColor != null || _dateRange != "All Time" || _sortBy != "Newest";

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
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: theme.textTheme.bodyLarge,
                onChanged: (val) => setState(() => _query = val),
                decoration: InputDecoration(
                  hintText: "Search workspace...",
                  prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.primary, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.cancel_rounded, size: 18), onPressed: () { _searchController.clear(); setState(() => _query = ""); })
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.tune_rounded, color: hasActiveFilters ? theme.colorScheme.primary : null),
            onPressed: _showSortFilterSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalFilterChips(ThemeData theme) {
    return Container(
      // Optional: add a background to the entire row area
      color: theme.colorScheme.onSurface.withOpacity(0.02),
      height: 50, // Increased slightly to prevent vertical clipping
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: _filterTypes.length,
        itemBuilder: (context, index) {
          final type = _filterTypes[index];
          final isSelected = _selectedType == type;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                type == "Todo" ? "To-Dos" : type == "Expense" ? "Finance" : type,
                style: TextStyle(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedType = type),

              // --- BACKGROUND COLORS ---
              // Background color when NOT selected
              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
              // Background color when SELECTED
              selectedColor: theme.colorScheme.primary.withOpacity(0.15),

              // UI Refinements
              checkmarkColor: theme.colorScheme.primary,
              pressElevation: 0,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSortFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final theme = Theme.of(context);
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sort & Filter", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () { setState(() { _sortBy = "Newest"; _dateRange = "All Time"; _filterColor = null; }); Navigator.pop(context); }, child: const Text("Reset")),
                  ],
                ),
                const SizedBox(height: 16),
                _sheetSectionTitle("Sort Order"),
                Wrap(spacing: 8, children: ["Newest", "Oldest", "A-Z"].map((s) => ChoiceChip(label: Text(s), selected: _sortBy == s, onSelected: (v) { setSheetState(() => _sortBy = s); setState(() => _sortBy = s); })).toList()),
                const SizedBox(height: 16),
                _sheetSectionTitle("Timeframe"),
                Wrap(spacing: 8, children: ["All Time", "Today", "This Week"].map((d) => ChoiceChip(label: Text(d), selected: _dateRange == d, onSelected: (v) { setSheetState(() => _dateRange = d); setState(() => _dateRange = d); })).toList()),
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

  Widget _sheetSectionTitle(String title) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey)));

  Widget _buildColorFilterRow(Function setSheetState) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    // 1. Use your common palette instead of hardcoded list
    final List<Color> myPalette = AppContentPalette.palette;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: myPalette.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // --- Clear Filter Option ---
            return GestureDetector(
              onTap: () {
                setSheetState(() => _filterColor = null);
                setState(() => _filterColor = null);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: onSurface.withOpacity(0.1),
                  child: Icon(
                      Icons.close,
                      size: 16,
                      color: _filterColor == null ? primaryColor : onSurface.withOpacity(0.5)
                  ),
                ),
              ),
            );
          }

          final color = myPalette[index - 1];
          final isSelected = _filterColor == color.value;

          // 2. Determine high-contrast color for the check icon
          final contrastColor = AppContentPalette.getContrastColor(color);

          return GestureDetector(
            onTap: () {
              setSheetState(() => _filterColor = color.value);
              setState(() => _filterColor = color.value);
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
                    color: isSelected ? primaryColor : onSurface.withOpacity(0.2),
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1
                    )
                  ] : null,
                ),
                child: isSelected
                    ? Icon(
                    Icons.check,
                    size: 18,
                    color: contrastColor // Dynamic Black/White checkmark
                )
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
        return NoteCard(note: res.argument, isSelected: false, onTap: () async { await context.push(res.route, extra: res.argument); _loadAllData(); }, onCopy: () => _copy(res), onShare: () => _share(res), onDelete: () => _delete(res), onColorChanged: (c) { (res.argument as Note).colorValue = c.value; (res.argument as Note).save(); setState(() {}); });
      case 'Todo':
        return TodoCard(todo: res.argument, isSelected: false, onTap: () async { await context.push(res.route, extra: res.argument); _loadAllData(); }, onToggleDone: () { (res.argument as Todo).isDone = !(res.argument as Todo).isDone; (res.argument as Todo).save(); _loadAllData(); });
      case 'Expense':
        return ExpenseCard(expense: res.argument, isSelected: false, onTap: () async { await context.push(res.route, extra: res.argument); _loadAllData(); });
      case 'Journal':
        return JournalCard(entry: res.argument, isSelected: false, onTap: () async { await context.push(res.route, extra: res.argument); _loadAllData(); }, onCopy: () => _copy(res), onShare: () => _share(res), onDelete: () => _delete(res), onColorChanged: (c) { (res.argument as JournalEntry).colorValue = c.value; (res.argument as JournalEntry).save(); setState(() {}); });
      case 'Clipboard':
        return ClipboardCard(item: res.argument, isSelected: false, onTap: () async { await context.push(res.route, extra: res.argument); _loadAllData(); }, onCopy: () => _copy(res), onShare: () => _share(res), onDelete: () => _delete(res), onColorChanged: (c) { (res.argument as ClipboardItem).colorValue = c.value; (res.argument as ClipboardItem).save(); setState(() {}); });
      default: return const SizedBox.shrink();
    }
  }

  void _copy(SearchResult res) { Clipboard.setData(ClipboardData(text: res.title)); }
  void _share(SearchResult res) { Share.share(res.title); }
  void _delete(SearchResult res) {
    final item = res.argument;
    item.isDeleted = true;
    item.deletedAt = DateTime.now();
    item.save();
    _loadAllData();
  }
}