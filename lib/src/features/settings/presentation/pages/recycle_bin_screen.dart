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
  String _sortBy = 'date';

  List<dynamic> _getAllDeleted() {
    List<dynamic> allDeleted = [];

    void addFromBox<T>(String boxName) {
      if (Hive.isBoxOpen(boxName)) {
        allDeleted.addAll(Hive.box<T>(boxName).values.where((e) {
          // Access isDeleted via dynamic check if no common base class exists
          try { return (e as dynamic).isDeleted == true; } catch (err) { return false; }
        }));
      }
    }

    addFromBox<Note>('notes_box');
    addFromBox<Todo>('todos_box');
    addFromBox<Expense>('expenses_box');
    addFromBox<JournalEntry>('journal_box');
    addFromBox<ClipboardItem>('clipboard_box');

    if (_sortBy == 'date') {
      allDeleted.sort((a, b) => ((b as dynamic).deletedAt ?? DateTime.now())
          .compareTo((a as dynamic).deletedAt ?? DateTime.now()));
    } else {
      allDeleted.sort((a, b) => a.runtimeType.toString().compareTo(b.runtimeType.toString()));
    }
    return allDeleted;
  }

  // --- Helper to get Title, Subtitle and Icon based on Model Type ---
  Map<String, dynamic> _getItemDisplayData(dynamic item) {
    if (item is Note) {
      return {'title': item.title.isEmpty ? "Untitled Note" : item.title, 'subtitle': item.content, 'icon': Icons.note_alt_rounded, 'color': Colors.amberAccent};
    } else if (item is Todo) {
      return {'title': item.task, 'subtitle': "Due: ${item.dueDate != null ? DateFormat('MMM dd').format(item.dueDate!) : 'No date'}", 'icon': Icons.check_circle_rounded, 'color': Colors.greenAccent};
    } else if (item is Expense) {
      return {'title': item.title, 'subtitle': "${item.currency}${item.amount}", 'icon': Icons.account_balance_wallet_rounded, 'color': Colors.redAccent};
    } else if (item is JournalEntry) {
      return {'title': item.title, 'subtitle': item.mood, 'icon': Icons.book_rounded, 'color': Colors.blueAccent};
    } else if (item is ClipboardItem) {
      return {'title': item.content, 'subtitle': "Copied Text", 'icon': Icons.copy_rounded, 'color': Colors.purpleAccent};
    }
    return {'title': "Unknown", 'subtitle': "", 'icon': Icons.help_outline, 'color': Colors.grey};
  }

  void _restoreItem(dynamic item) {
    setState(() {
      item.isDeleted = false;
      item.deletedAt = null;
      item.save();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item restored"), behavior: SnackBarBehavior.floating));
  }

  void _permanentlyDeleteItem(dynamic item) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Permanent Delete",
        content: "This action cannot be undone.",
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final items = _getAllDeleted();

    return GlassScaffold(
      title: null,
      showBackArrow: true,
      actions: [
        if (items.isNotEmpty)
          TextButton.icon(
            onPressed: () {}, // Logic for Empty Trash
            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 20),
            label: const Text("Empty", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          )
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text("Recycle Bin", style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          _buildSortChips(theme),
          const SizedBox(height: 10),
          Expanded(
            child: items.isEmpty ? _buildEmptyState(onSurface) : _buildList(items, onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChips(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _filterChip("Recently Deleted", _sortBy == 'date', () => setState(() => _sortBy = 'date')),
          const SizedBox(width: 8),
          _filterChip("By Category", _sortBy == 'type', () => setState(() => _sortBy = 'type')),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 20,
        color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.transparent,
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _buildList(List<dynamic> items, Color onSurface) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final data = _getItemDisplayData(item);
        final deleteDate = item.deletedAt != null ? DateFormat('MMM dd, hh:mm a').format(item.deletedAt!) : "";

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassContainer(
            borderRadius: 20,
            padding: const EdgeInsets.all(4),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: data['color'].withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(data['icon'], color: data['color'], size: 20),
              ),
              title: Text(data['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text("Deleted $deleteDate", style: TextStyle(fontSize: 11, color: onSurface.withOpacity(0.5))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actionBtn(Icons.restore_rounded, Colors.greenAccent, () => _restoreItem(item)),
                  const SizedBox(width: 4),
                  _actionBtn(Icons.delete_forever_rounded, Colors.redAccent, () => _permanentlyDeleteItem(item)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, color: color, size: 22),
      onPressed: onTap,
    );
  }

  Widget _buildEmptyState(Color onSurface) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline_rounded, size: 80, color: onSurface.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text("Recycle Bin is empty", style: TextStyle(color: onSurface.withOpacity(0.4), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}