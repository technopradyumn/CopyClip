import 'dart:ui';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../clipboard/presentation/widgets/clipboard_card.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../../../core/widgets/glass_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    _currentItems = List.from(widget.items);
  }

  // --- REFRESH LOGIC ---
  void _refreshData() {
    final dateKey = DateFormat('yyyy-MM-dd').format(widget.date);
    List<GlobalSearchResult> freshResults = [];

    // Note
    freshResults.addAll(Hive.box<Note>('notes_box').values
        .where((e) => DateFormat('yyyy-MM-dd').format(e.updatedAt) == dateKey)
        .map((e) => GlobalSearchResult(id: e.id, title: e.title, subtitle: e.content, type: 'Note', route: AppRouter.noteEdit, argument: e)));

    // Todo
    freshResults.addAll(Hive.box<Todo>('todos_box').values
        .where((e) => e.dueDate != null && DateFormat('yyyy-MM-dd').format(e.dueDate!) == dateKey)
        .map((e) => GlobalSearchResult(id: e.id, title: e.task, subtitle: e.isDone ? "Completed" : "Pending", type: 'Todo', route: AppRouter.todoEdit, argument: e, isCompleted: e.isDone)));

    // Expense
    freshResults.addAll(Hive.box<Expense>('expenses_box').values
        .where((e) => DateFormat('yyyy-MM-dd').format(e.date) == dateKey)
        .map((e) => GlobalSearchResult(id: e.id, title: e.title, subtitle: "${e.isIncome ? '+' : '-'} ${e.currency}${e.amount}", type: 'Expense', route: AppRouter.expenseEdit, argument: e)));

    // Journal
    freshResults.addAll(Hive.box<JournalEntry>('journal_box').values
        .where((e) => DateFormat('yyyy-MM-dd').format(e.date) == dateKey)
        .map((e) => GlobalSearchResult(id: e.id, title: e.title, subtitle: e.content, type: 'Journal', route: AppRouter.journalEdit, argument: e)));

    // Clipboard
    freshResults.addAll(Hive.box<ClipboardItem>('clipboard_box').values
        .where((e) => DateFormat('yyyy-MM-dd').format(e.createdAt) == dateKey)
        .map((e) => GlobalSearchResult(id: e.id, title: e.content, subtitle: "Copied at ${DateFormat('HH:mm').format(e.createdAt)}", type: 'Clipboard', route: AppRouter.clipboardEdit, argument: e)));

    if (mounted) {
      setState(() {
        _currentItems = freshResults;
      });
    }
  }

  // --- ACTIONS ---
  void _deleteItem(GlobalSearchResult res) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete Item?",
        content: "This action cannot be undone.",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          // Delete based on type
          if (res.type == 'Note') Hive.box<Note>('notes_box').delete(res.id);
          else if (res.type == 'Todo') Hive.box<Todo>('todos_box').delete(res.id);
          else if (res.type == 'Expense') Hive.box<Expense>('expenses_box').delete(res.id);
          else if (res.type == 'Journal') Hive.box<JournalEntry>('journal_box').delete(res.id);
          else if (res.type == 'Clipboard') Hive.box<ClipboardItem>('clipboard_box').delete(res.id);

          _refreshData(); // Refresh list after delete
        },
      ),
    );
  }

  void _copyContent(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied"), behavior: SnackBarBehavior.floating));
  }

  void _shareContent(String text) => Share.share(text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GlassScaffold(
      showBackArrow: true,
      title: null,
      body: Column(
        children: [
          // --- TOP BAR ---
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 24),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
                  onPressed: () => context.pop(),
                ),
                Hero(
                  tag: 'calendar_icon',
                  child: Icon(Icons.event_available, color: colorScheme.primary, size: 28),
                ),
                const SizedBox(width: 12),
                Hero(
                  tag: 'calendar_title',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      DateFormat('EEEE, d MMMM yyyy').format(widget.date),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                    "${_currentItems.length} items",
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.5))
                ),
              ],
            ),
          ),

          // --- LIST ---
          Expanded(
            child: _currentItems.isEmpty
                ? Center(child: Text("Nothing recorded for this day", style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withOpacity(0.3))))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              itemCount: _currentItems.length,
              itemBuilder: (context, index) {
                final res = _currentItems[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildItemCard(res),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(GlobalSearchResult res) {
    // 1. NOTES
    if (res.type == 'Note') {
      final note = res.argument as Note;
      return NoteCard(
        note: note,
        isSelected: false,
        onTap: () async { await context.push(res.route, extra: note); _refreshData(); },
        onCopy: () => _copyContent(note.content),
        onShare: () => _shareContent("${note.title}\n\n${note.content}"),
        onDelete: () => _deleteItem(res),
      );
    }
    // 2. TODOS
    else if (res.type == 'Todo') {
      final todo = res.argument as Todo;
      return TodoCard(
        todo: todo,
        isSelected: false,
        onTap: () async { await context.push(res.route, extra: todo); _refreshData(); },
        onToggleDone: () {
          setState(() { todo.isDone = !todo.isDone; todo.save(); _refreshData(); });
        },
      );
    }
    // 3. EXPENSES
    else if (res.type == 'Expense') {
      final expense = res.argument as Expense;
      return ExpenseCard(
        expense: expense,
        isSelected: false,
        onTap: () async { await context.push(res.route, extra: expense); _refreshData(); },
      );
    }
    // 4. JOURNAL
    else if (res.type == 'Journal') {
      final entry = res.argument as JournalEntry;
      return JournalCard(
        entry: entry,
        isSelected: false,
        onTap: () async { await context.push(res.route, extra: entry); _refreshData(); },
        onCopy: () => _copyContent(entry.content),
        onShare: () => _shareContent("${entry.title}\n\n${entry.content}"),
        onDelete: () => _deleteItem(res),
      );
    }
    // 5. CLIPBOARD
    else if (res.type == 'Clipboard') {
      final item = res.argument as ClipboardItem;
      return ClipboardCard(
        item: item,
        isSelected: false,
        onTap: () async { await context.push(res.route, extra: item); _refreshData(); },
        onCopy: () => _copyContent(item.content),
        onShare: () => _shareContent(item.content),
        onDelete: () => _deleteItem(res),
      );
    }

    // Fallback (should not happen if data is correct)
    return const SizedBox.shrink();
  }
}