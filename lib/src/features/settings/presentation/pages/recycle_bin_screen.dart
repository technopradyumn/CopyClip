import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';

class RecycleBinScreen extends StatefulWidget {
  const RecycleBinScreen({super.key});

  @override
  State<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  String _sortBy = 'date'; // 'date' or 'type'

  List<dynamic> _getAllDeleted() {
    List<dynamic> allDeleted = [];

    // 1. Notes
    if (Hive.isBoxOpen('notes_box')) {
      allDeleted.addAll(Hive.box<Note>('notes_box').values.where((e) => e.isDeleted == true));
    }
    // 2. Todos
    if (Hive.isBoxOpen('todos_box')) {
      allDeleted.addAll(Hive.box<Todo>('todos_box').values.where((e) => e.isDeleted == true));
    }
    // 3. Expenses
    if (Hive.isBoxOpen('expenses_box')) {
      allDeleted.addAll(Hive.box<Expense>('expenses_box').values.where((e) => e.isDeleted == true));
    }
    // 4. Journal
    if (Hive.isBoxOpen('journal_box')) {
      allDeleted.addAll(Hive.box<JournalEntry>('journal_box').values.where((e) => e.isDeleted == true));
    }
    // 5. Clipboard
    if (Hive.isBoxOpen('clipboard_box')) {
      allDeleted.addAll(Hive.box<ClipboardItem>('clipboard_box').values.where((e) => e.isDeleted == true));
    }

    // Sorting logic
    if (_sortBy == 'date') {
      allDeleted.sort((a, b) => (b.deletedAt ?? DateTime.now()).compareTo(a.deletedAt ?? DateTime.now()));
    } else {
      allDeleted.sort((a, b) => a.runtimeType.toString().compareTo(b.runtimeType.toString()));
    }

    return allDeleted;
  }

  void _restoreItem(dynamic item) {
    setState(() {
      item.isDeleted = false;
      item.deletedAt = null;
      item.save();
    });
  }

  void _permanentlyDeleteItem(dynamic item) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Permanent Delete",
        content: "This item will be gone forever. Proceed?",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () {
          item.delete();
          Navigator.pop(ctx);
          setState(() {});
        },
      ),
    );
  }

  void _emptyTrash() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Empty Trash?",
        content: "All items in the Recycle Bin will be permanently deleted.",
        confirmText: "Empty All",
        isDestructive: true,
        onConfirm: () async {
          final items = _getAllDeleted();
          for (var item in items) { await item.delete(); }
          Navigator.pop(ctx);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deletedItems = _getAllDeleted();

    return GlassScaffold(
      title: "Recycle Bin",
      showBackArrow: true,
      actions: [
        if (deletedItems.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
            onPressed: _emptyTrash,
          ),
      ],
      body: Column(
        children: [
          const SizedBox(height: 90),
          // Sorting Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text("Sort by:", style: theme.textTheme.bodySmall),
                TextButton(
                  onPressed: () => setState(() => _sortBy = 'date'),
                  child: Text("Date", style: TextStyle(color: _sortBy == 'date' ? theme.primaryColor : Colors.grey)),
                ),
                TextButton(
                  onPressed: () => setState(() => _sortBy = 'type'),
                  child: Text("Category", style: TextStyle(color: _sortBy == 'type' ? theme.primaryColor : Colors.grey)),
                ),
              ],
            ),
          ),

          Expanded(
            child: deletedItems.isEmpty
                ? const Center(child: Text("Recycle Bin is empty"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: deletedItems.length,
              itemBuilder: (context, index) {
                final item = deletedItems[index];
                String title = "";
                // Handle different model titles
                try { title = item.title ?? item.task ?? item.content; } catch(_) { title = "Untitled Item"; }
                if (title.length > 30) title = "${title.substring(0, 30)}...";

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(12),
                    opacity: 0.1,
                    child: ListTile(
                      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "${item.runtimeType.toString().replaceAll('Entry', '')} • ${DateFormat('MMM dd').format(item.deletedAt!)}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.restore, color: Colors.greenAccent),
                            onPressed: () => _restoreItem(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
                            onPressed: () => _permanentlyDeleteItem(item),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}