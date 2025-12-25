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
import '../../../journal/presentation/widgets/journal_card.dart';
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
  late List<GlobalSearchResult> _allData;
  String _searchQuery = "";
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Note", "Todo", "Expense", "Journal", "Clipboard"];

  @override
  void initState() {
    super.initState();
    _allData = List.from(widget.items);
  }

  // --- REFRESH LOGIC ---
  void _refreshData() {
    final dateKey = DateFormat('yyyy-MM-dd').format(widget.date);
    List<GlobalSearchResult> freshResults = [];

    void addFromBox<T>(String boxName, GlobalSearchResult Function(T) mapper) {
      if (Hive.isBoxOpen(boxName)) {
        freshResults.addAll(Hive.box<T>(boxName).values
            .where((e) => !(e as dynamic).isDeleted &&
            DateFormat('yyyy-MM-dd').format((e as dynamic).date ?? (e as dynamic).updatedAt ?? (e as dynamic).createdAt) == dateKey)
            .map(mapper));
      }
    }

    // Individual loaders to handle model differences
    addFromBox<Note>('notes_box', (e) => GlobalSearchResult(id: e.id, title: e.title, subtitle: e.content, type: 'Note', route: AppRouter.noteEdit, argument: e));
    addFromBox<Todo>('todos_box', (e) => GlobalSearchResult(id: e.id, title: e.task, subtitle: e.isDone ? "Completed" : "Pending", type: 'Todo', route: AppRouter.todoEdit, argument: e, isCompleted: e.isDone));
    addFromBox<Expense>('expenses_box', (e) => GlobalSearchResult(id: e.id, title: e.title, subtitle: "${e.currency}${e.amount}", type: 'Expense', route: AppRouter.expenseEdit, argument: e));
    addFromBox<JournalEntry>('journal_box', (e) => GlobalSearchResult(id: e.id, title: e.title, subtitle: e.content, type: 'Journal', route: AppRouter.journalEdit, argument: e));
    addFromBox<ClipboardItem>('clipboard_box', (e) => GlobalSearchResult(id: e.id, title: e.content, subtitle: "Clipboard", type: 'Clipboard', route: AppRouter.clipboardEdit, argument: e));

    if (mounted) setState(() => _allData = freshResults);
  }

  // --- FILTERING ENGINE ---
  List<GlobalSearchResult> _getFilteredItems() {
    return _allData.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == "All" || item.type == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final displayItems = _getFilteredItems();

    return GlassScaffold(
      showBackArrow: false,
      title: null,
      body: Column(
        children: [
          _buildTopBar(theme, onSurface),
          _buildSearchBar(theme, onSurface),
          _buildFilterChips(theme, onSurface),

          Expanded(
            child: displayItems.isEmpty
                ? _buildEmptyState(onSurface)
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
              physics: const BouncingScrollPhysics(),
              itemCount: displayItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildItemCard(displayItems[index]),
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
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: onSurface, size: 20),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              DateFormat('MMMM d, yyyy').format(widget.date),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: onSurface),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: onSurface.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text("${_allData.length} total", style: TextStyle(fontSize: 11, color: onSurface.withOpacity(0.6))),
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
          onChanged: (val) => setState(() => _searchQuery = val),
          style: TextStyle(color: onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: "Search in this day...",
            hintStyle: TextStyle(color: onSurface.withOpacity(0.4), fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.primary, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme, Color onSurface) {
    return SizedBox(
      height: 50, // Slightly increased height to accommodate the chips comfortably
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
                filter == "Todo" ? "To-Dos" : filter == "Expense" ? "Finance" : filter,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? theme.colorScheme.primary : onSurface.withOpacity(0.8),
                ),
              ),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedFilter = filter),

              // --- BACKGROUND COLORS ---
              // Color when the chip is NOT selected
              backgroundColor: onSurface.withOpacity(0.06),
              // Color when the chip IS selected
              selectedColor: theme.colorScheme.primary.withOpacity(0.15),

              // --- UI REFINEMENTS ---
              checkmarkColor: theme.colorScheme.primary,
              showCheckmark: true, // Set to false if you want a cleaner look
              pressElevation: 2,

              // Border logic
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
          Icon(Icons.search_off_rounded, size: 48, color: onSurface.withOpacity(0.2)),
          const SizedBox(height: 12),
          Text("No items found matching criteria", style: TextStyle(color: onSurface.withOpacity(0.4))),
        ],
      ),
    );
  }

  Widget _buildItemCard(GlobalSearchResult res) {
    switch (res.type) {
      case 'Note':
        return NoteCard(note: res.argument, isSelected: false,
          onTap: () async { await context.push(res.route, extra: res.argument); _refreshData(); },
          onDelete: () => _deleteItem(res),
          onColorChanged: (c) { res.argument.colorValue = c.value; res.argument.save(); setState(() {}); },
          onCopy: () => Clipboard.setData(ClipboardData(text: res.subtitle)),
          onShare: () => Share.share(res.subtitle),
        );
      case 'Todo':
        return TodoCard(todo: res.argument, isSelected: false,
            onTap: () async { await context.push(res.route, extra: res.argument); _refreshData(); },
            onToggleDone: () { res.argument.isDone = !res.argument.isDone; res.argument.save(); _refreshData(); });
      case 'Expense':
        return ExpenseCard(expense: res.argument, isSelected: false,
            onTap: () async { await context.push(res.route, extra: res.argument); _refreshData(); });
      case 'Journal':
        return JournalCard(entry: res.argument, isSelected: false,
          onTap: () async { await context.push(res.route, extra: res.argument); _refreshData(); },
          onDelete: () => _deleteItem(res),
          onColorChanged: (c) { res.argument.colorValue = c.value; res.argument.save(); setState(() {}); },
          onCopy: () => Clipboard.setData(ClipboardData(text: res.subtitle)),
          onShare: () => Share.share(res.subtitle),
        );
      case 'Clipboard':
        return ClipboardCard(item: res.argument, isSelected: false,
          onTap: () async { await context.push(res.route, extra: res.argument); _refreshData(); },
          onDelete: () => _deleteItem(res),
          onColorChanged: (c) { res.argument.colorValue = c.value; res.argument.save(); setState(() {}); },
          onCopy: () => Clipboard.setData(ClipboardData(text: res.title)),
          onShare: () => Share.share(res.title),
        );
      default: return const SizedBox.shrink();
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
          item.isDeleted = true;
          item.deletedAt = DateTime.now();
          item.save();
          Navigator.pop(ctx);
          _refreshData();
        },
      ),
    );
  }
}