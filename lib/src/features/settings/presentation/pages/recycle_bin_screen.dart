import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
// import 'package:copyclip/src/core/widgets/glass_container.dart'; // ❌ REMOVED to prevent lag

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
          try {
            return (e as dynamic).isDeleted == true;
          } catch (_) {
            return false;
          }
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

  String _parsePlainContent(String source) {
    if (source.isEmpty) return "No content";
    if (source.startsWith('[')) {
      try {
        final List<dynamic> delta = jsonDecode(source);
        String text = "";
        for (var op in delta) {
          if (op.containsKey('insert') && op['insert'] is String) {
            text += op['insert'];
          }
        }
        return text.trim().replaceAll('\n', ' ');
      } catch (e) {
        return source;
      }
    }
    return source.trim().replaceAll('\n', ' ');
  }

  Map<String, dynamic> _getItemDisplayData(dynamic item) {
    if (item is Note) {
      final cleanContent = _parsePlainContent(item.content);
      return {
        'title': item.title.isEmpty ? "Untitled Note" : item.title,
        'subtitle': cleanContent.length > 40 ? "${cleanContent.substring(0, 40)}..." : cleanContent,
        'icon': Icons.note_alt_rounded,
        'color': Colors.amberAccent
      };
    } else if (item is Todo) {
      return {
        'title': item.task,
        'subtitle': "Category: ${item.category}",
        'icon': Icons.check_circle_rounded,
        'color': Colors.greenAccent
      };
    } else if (item is Expense) {
      return {
        'title': item.title,
        'subtitle': "${item.currency}${item.amount.toStringAsFixed(2)}",
        'icon': Icons.account_balance_wallet_rounded,
        'color': Colors.redAccent
      };
    } else if (item is JournalEntry) {
      final cleanContent = _parsePlainContent(item.content);
      return {
        'title': item.title.isEmpty ? "Daily Entry" : item.title,
        'subtitle': cleanContent.length > 40 ? "${cleanContent.substring(0, 40)}..." : "Mood: ${item.mood}",
        'icon': Icons.book_rounded,
        'color': Colors.blueAccent
      };
    } else if (item is ClipboardItem) {
      final cleanClip = item.content.trim().replaceAll(RegExp(r'\s+'), ' ');
      return {
        'title': cleanClip.length > 35 ? "${cleanClip.substring(0, 35)}..." : cleanClip,
        'subtitle': "Clipboard History",
        'icon': Icons.copy_rounded,
        'color': Colors.purpleAccent
      };
    }
    return {'title': "Unknown", 'subtitle': "", 'icon': Icons.help_outline, 'color': Colors.grey};
  }

  String _getBoxName(dynamic item) {
    if (item is Note) return 'notes_box';
    if (item is Todo) return 'todos_box';
    if (item is Expense) return 'expenses_box';
    if (item is JournalEntry) return 'journal_box';
    if (item is ClipboardItem) return 'clipboard_box';
    return '';
  }

  void _restoreItem(dynamic item) async {
    final boxName = _getBoxName(item);
    if (boxName.isEmpty) return;
    setState(() {
      item.isDeleted = false;
      item.deletedAt = null;
    });
    await item.save();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item restored"), behavior: SnackBarBehavior.floating)
      );
    }
  }

  void _permanentlyDeleteItem(dynamic item) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete Permanently?",
        content: "This action cannot be undone.",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () async {
          await item.delete();
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
        title: "Empty Recycle Bin?",
        content: "All items across all categories will be permanently deleted.",
        confirmText: "Empty Bin",
        isDestructive: true,
        onConfirm: () async {
          Navigator.pop(ctx);
          final boxes = ['notes_box', 'todos_box', 'expenses_box', 'journal_box', 'clipboard_box'];
          for (var boxName in boxes) {
            if (Hive.isBoxOpen(boxName)) {
              final box = Hive.box(boxName);
              final keysToDelete = box.keys.where((key) {
                final val = box.get(key);
                return val != null && (val as dynamic).isDeleted == true;
              }).toList();
              for (var key in keysToDelete) {
                await box.delete(key);
              }
            }
          }
          setState(() {});
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Recycle Bin cleared"), behavior: SnackBarBehavior.floating)
            );
          }
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
      title: "Recycle Bin",
      showBackArrow: true,
      actions: [
        if (items.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
            onPressed: _emptyTrash,
          )
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _filterChip("Recent", _sortBy == 'date', () => setState(() => _sortBy = 'date')),
                const SizedBox(width: 8),
                _filterChip("Category", _sortBy == 'type', () => setState(() => _sortBy = 'type')),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline_rounded, size: 80, color: onSurface.withOpacity(0.1)),
                  const SizedBox(height: 16),
                  Text("Recycle Bin is empty", style: TextStyle(color: onSurface.withOpacity(0.4), fontWeight: FontWeight.w500)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final data = _getItemDisplayData(item);
                final deleteDate = item.deletedAt != null
                    ? DateFormat('MMM dd, hh:mm a').format(item.deletedAt!)
                    : "Unknown date";

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  // ✅ Replaced GlassContainer with a simple Container
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.1), // Simple transparency
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: data['color'].withOpacity(0.15),
                        child: Icon(data['icon'], color: data['color'], size: 20),
                      ),
                      title: Text(data['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['subtitle'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: onSurface.withOpacity(0.7))),
                          Text("Deleted $deleteDate", style: TextStyle(fontSize: 10, color: onSurface.withOpacity(0.4))),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.restore_rounded, color: Colors.greenAccent),
                            onPressed: () => _restoreItem(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
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

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      // ✅ Replaced GlassContainer with a simple Container
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary.withOpacity(0.3) : theme.dividerColor.withOpacity(0.1),
          ),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}