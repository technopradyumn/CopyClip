import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
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
        allDeleted.addAll(
          Hive.box<T>(boxName).values.where((e) {
            try {
              return (e as dynamic).isDeleted == true;
            } catch (_) {
              return false;
            }
          }),
        );
      }
    }

    addFromBox<Note>('notes_box');
    addFromBox<Todo>('todos_box');
    addFromBox<Expense>('expenses_box');
    addFromBox<JournalEntry>('journal_box');
    addFromBox<ClipboardItem>('clipboard_box');

    if (_sortBy == 'date') {
      allDeleted.sort(
        (a, b) => ((b as dynamic).deletedAt ?? DateTime.now()).compareTo(
          (a as dynamic).deletedAt ?? DateTime.now(),
        ),
      );
    } else {
      allDeleted.sort(
        (a, b) => a.runtimeType.toString().compareTo(b.runtimeType.toString()),
      );
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
        'subtitle': cleanContent.length > 40
            ? "${cleanContent.substring(0, 40)}..."
            : cleanContent,
        'icon': CupertinoIcons.doc_text,
        'color': Colors.amberAccent,
      };
    } else if (item is Todo) {
      return {
        'title': item.task,
        'subtitle': "Category: ${item.category}",
        'icon': CupertinoIcons.checkmark_circle,
        'color': Colors.greenAccent,
      };
    } else if (item is Expense) {
      return {
        'title': item.title,
        'subtitle': "${item.currency}${item.amount.toStringAsFixed(2)}",
        'icon': CupertinoIcons.money_dollar,
        'color': Colors.redAccent,
      };
    } else if (item is JournalEntry) {
      final cleanContent = _parsePlainContent(item.content);
      return {
        'title': item.title.isEmpty ? "Daily Entry" : item.title,
        'subtitle': cleanContent.length > 40
            ? "${cleanContent.substring(0, 40)}..."
            : "Mood: ${item.mood}",
        'icon': CupertinoIcons.book,
        'color': Colors.blueAccent,
      };
    } else if (item is ClipboardItem) {
      final cleanClip = item.content.trim().replaceAll(RegExp(r'\s+'), ' ');
      return {
        'title': cleanClip.length > 35
            ? "${cleanClip.substring(0, 35)}..."
            : cleanClip,
        'subtitle': "Clipboard History",
        'icon': CupertinoIcons.doc_on_doc,
        'color': Colors.purpleAccent,
      };
    }
    return {
      'title': "Unknown",
      'subtitle': "",
      'icon': CupertinoIcons.question_circle,
      'color': Colors.grey,
    };
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
        const SnackBar(
          content: Text("Item restored"),
          behavior: SnackBarBehavior.floating,
        ),
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
    final itemsToDelete =
        _getAllDeleted(); // Get currently visible deleted items
    if (itemsToDelete.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Empty Recycle Bin?",
        content:
            "All ${itemsToDelete.length} items will be permanently deleted.",
        confirmText: "Empty Bin",
        isDestructive: true,
        onConfirm: () async {
          // Close dialog first to avoid UI freeze perception
          Navigator.pop(ctx);

          try {
            // Delete all items directly
            for (var item in itemsToDelete) {
              if (item is HiveObject) {
                await item.delete();
              }
            }

            // Wait a tick for Hive to sync
            await Future.delayed(const Duration(milliseconds: 100));

            if (mounted) {
              setState(() {}); // Refresh UI
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Recycle Bin cleared successfully"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } catch (e) {
            debugPrint("Error emptying trash: $e");
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
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
      title: null,
      showBackArrow: false,
      body: Column(
        children: [
          SeamlessHeader(
            title: "Recycle Bin",
            subtitle: items.isNotEmpty ? "${items.length} items" : "Empty",
            icon: CupertinoIcons.trash,
            iconColor: Colors.redAccent,
            heroTagPrefix: 'recycle_bin',
            actions: [
              if (items.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.trash,
                    color: Colors.redAccent,
                  ),
                  onPressed: _emptyTrash,
                ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      _filterChip(
                        "Recent",
                        _sortBy == 'date',
                        () => setState(() => _sortBy = 'date'),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        "Category",
                        _sortBy == 'type',
                        () => setState(() => _sortBy = 'type'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.trash,
                                size: 64,
                                color: onSurface.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Recycle Bin is empty",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ValueListenableBuilder(
                          valueListenable: Hive.box<Note>(
                            'notes_box',
                          ).listenable(),
                          builder: (context, _, __) {
                            return ValueListenableBuilder(
                              valueListenable: Hive.box<Todo>(
                                'todos_box',
                              ).listenable(),
                              builder: (context, _, __) {
                                return ValueListenableBuilder(
                                  valueListenable: Hive.box<Expense>(
                                    'expenses_box',
                                  ).listenable(),
                                  builder: (context, _, __) {
                                    return ValueListenableBuilder(
                                      valueListenable: Hive.box<JournalEntry>(
                                        'journal_box',
                                      ).listenable(),
                                      builder: (context, _, __) {
                                        return ValueListenableBuilder(
                                          valueListenable:
                                              Hive.box<ClipboardItem>(
                                                'clipboard_box',
                                              ).listenable(),
                                          builder: (context, _, __) {
                                            final currentItems =
                                                _getAllDeleted();
                                            return ListView.separated(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              itemCount: currentItems.length,
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(height: 12),
                                              itemBuilder: (context, index) {
                                                final item =
                                                    currentItems[index];
                                                final data =
                                                    _getItemDisplayData(item);
                                                final deletedAt =
                                                    (item as dynamic).deletedAt;
                                                String timeLabel = 'Unknown';
                                                if (deletedAt != null) {
                                                  final now = DateTime.now();
                                                  final diff = now.difference(
                                                    deletedAt,
                                                  );
                                                  if (diff.inMinutes < 1) {
                                                    timeLabel = 'Just now';
                                                  } else if (diff.inHours < 1) {
                                                    timeLabel =
                                                        '${diff.inMinutes}m ago';
                                                  } else if (diff.inDays < 1) {
                                                    timeLabel =
                                                        '${diff.inHours}h ago';
                                                  } else {
                                                    timeLabel =
                                                        '${diff.inDays}d ago';
                                                  }
                                                }
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: theme
                                                        .colorScheme
                                                        .surface
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          AppConstants
                                                              .cornerRadius,
                                                        ),
                                                    border: Border.all(
                                                      color: theme.dividerColor
                                                          .withOpacity(0.1),
                                                      width: AppConstants
                                                          .borderWidth,
                                                    ),
                                                  ),
                                                  child: ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 8,
                                                        ),
                                                    leading: Icon(
                                                      data['icon'] as IconData,
                                                      color:
                                                          data['color']
                                                              as Color,
                                                      size: 30,
                                                    ),
                                                    title: Text(
                                                      data['title'] as String,
                                                      style: theme
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    subtitle: Text(
                                                      "${data['subtitle']} • $timeLabel",
                                                      style: theme
                                                          .textTheme
                                                          .bodySmall,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                            CupertinoIcons
                                                                .arrow_counterclockwise,
                                                          ),
                                                          onPressed: () =>
                                                              _restoreItem(
                                                                item,
                                                              ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            CupertinoIcons
                                                                .delete,
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                          onPressed: () =>
                                                              _permanentlyDeleteItem(
                                                                item,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
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
          borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.3)
                : theme.colorScheme.outline.withOpacity(0.2),
            width: AppConstants.borderWidth,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
