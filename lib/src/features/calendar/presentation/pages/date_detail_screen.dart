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

// Feature Models
import '../../../clipboard/data/clipboard_model.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';

// Feature Cards
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
  late List<GlobalSearchResult> _currentItems;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentItems = List.from(widget.items);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _refreshData() {
    final dateKey = DateFormat('yyyy-MM-dd').format(widget.date);
    List<GlobalSearchResult> freshResults = [];

    if (Hive.isBoxOpen('notes_box')) {
      freshResults.addAll(Hive.box<Note>('notes_box').values
          .where((e) => !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.updatedAt) == dateKey)
          .map((e) => GlobalSearchResult(id: e.id, title: e.title, subtitle: e.content, type: 'Note', route: AppRouter.noteEdit, argument: e)));
    }

    if (Hive.isBoxOpen('todos_box')) {
      freshResults.addAll(Hive.box<Todo>('todos_box').values
          .where((e) => !e.isDeleted && e.dueDate != null && DateFormat('yyyy-MM-dd').format(e.dueDate!) == dateKey)
          .map((e) => GlobalSearchResult(id: e.id, title: e.task, subtitle: e.isDone ? "Completed" : "Pending", type: 'Todo', route: AppRouter.todoEdit, argument: e, isCompleted: e.isDone)));
    }

    if (Hive.isBoxOpen('expenses_box')) {
      freshResults.addAll(Hive.box<Expense>('expenses_box').values
          .where((e) => !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.date) == dateKey)
          .map((e) => GlobalSearchResult(id: e.id, title: e.title, subtitle: "${e.isIncome ? '+' : '-'} ${e.currency}${e.amount}", type: 'Expense', route: AppRouter.expenseEdit, argument: e)));
    }

    if (Hive.isBoxOpen('journal_box')) {
      freshResults.addAll(Hive.box<JournalEntry>('journal_box').values
          .where((e) => !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.date) == dateKey)
          .map((e) => GlobalSearchResult(id: e.id, title: e.title, subtitle: e.content, type: 'Journal', route: AppRouter.journalEdit, argument: e)));
    }

    if (Hive.isBoxOpen('clipboard_box')) {
      freshResults.addAll(Hive.box<ClipboardItem>('clipboard_box').values
          .where((e) => !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.createdAt) == dateKey)
          .map((e) => GlobalSearchResult(id: e.id, title: e.content, subtitle: "Copied at ${DateFormat('HH:mm').format(e.createdAt)}", type: 'Clipboard', route: AppRouter.clipboardEdit, argument: e)));
    }

    if (mounted) setState(() => _currentItems = freshResults);
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

  String _getCleanText(String content) {
    if (!content.startsWith('[')) return content;
    try {
      final List<dynamic> delta = jsonDecode(content);
      String plainText = "";
      for (var op in delta) {
        if (op is Map && op.containsKey('insert') && op['insert'] is String) {
          plainText += op['insert'];
        }
      }
      return plainText.trim();
    } catch (_) { return content; }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassScaffold(
      showBackArrow: true,
      title: null,
      body: Column(
        children: [
          const SizedBox(height: 44),
          // --- FIXED HEADER ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => context.pop(),
                ),
                Icon(Icons.event_available, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    DateFormat('EEEE, d MMMM yyyy').format(widget.date),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "${_currentItems.length} items",
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ),
              ],
            ),
          ),

          // --- SCROLLABLE LIST ---
          Expanded(
            child: _currentItems.isEmpty
                ? Center(child: Text("Nothing recorded for this day", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.3))))
                : ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: _currentItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildItemCard(_currentItems[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(GlobalSearchResult res) {
    switch (res.type) {
      case 'Note':
        final note = res.argument as Note;
        return NoteCard(
          note: note, isSelected: false,
          onTap: () async { await context.push(res.route, extra: note); _refreshData(); },
          onCopy: () => Clipboard.setData(ClipboardData(text: _getCleanText(note.content))),
          onShare: () => Share.share(_getCleanText(note.content)),
          onDelete: () => _deleteItem(res),
          onColorChanged: (newColor) { setState(() => note.colorValue = newColor.value); note.save(); },
        );
      case 'Journal':
        final entry = res.argument as JournalEntry;
        return JournalCard(
          entry: entry, isSelected: false,
          onTap: () async { await context.push(res.route, extra: entry); _refreshData(); },
          onCopy: () => Clipboard.setData(ClipboardData(text: _getCleanText(entry.content))),
          onShare: () => Share.share(_getCleanText(entry.content)),
          onDelete: () => _deleteItem(res),
          onColorChanged: (newColor) { setState(() => entry.colorValue = newColor.value); entry.save(); },
        );
      case 'Clipboard':
        final item = res.argument as ClipboardItem;
        return ClipboardCard(
          item: item, isSelected: false,
          onTap: () async { await context.push(res.route, extra: item); _refreshData(); },
          onCopy: () => Clipboard.setData(ClipboardData(text: _getCleanText(item.content))),
          onShare: () => Share.share(_getCleanText(item.content)),
          onDelete: () => _deleteItem(res),
          onColorChanged: (newColor) { setState(() => item.colorValue = newColor.value); item.save(); },
        );
      case 'Todo':
        final todo = res.argument as Todo;
        return TodoCard(
          todo: todo, isSelected: false,
          onTap: () async { await context.push(res.route, extra: todo); _refreshData(); },
          onToggleDone: () { setState(() { todo.isDone = !todo.isDone; todo.save(); _refreshData(); }); },
        );
      case 'Expense':
        final exp = res.argument as Expense;
        return ExpenseCard(
          expense: exp, isSelected: false,
          onTap: () async { await context.push(res.route, extra: exp); _refreshData(); },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}