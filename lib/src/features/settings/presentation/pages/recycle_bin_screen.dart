import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/widgets/empty_state_widget.dart'; // Added
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

  String _parsePlainContent(BuildContext context, String source) {
    if (source.isEmpty) return AppLocalizations.of(context)!.noContent;
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

  Map<String, dynamic> _getItemDisplayData(BuildContext context, dynamic item) {
    final l10n = AppLocalizations.of(context)!;
    if (item is Note) {
      final cleanContent = _parsePlainContent(context, item.content);
      return {
        'title': item.title.isEmpty ? l10n.untitledNote : item.title,
        'subtitle': cleanContent.length > 40
            ? "${cleanContent.substring(0, 40)}..."
            : cleanContent,
        'icon': CupertinoIcons.doc_text,
        'color': Colors.amberAccent,
      };
    } else if (item is Todo) {
      return {
        'title': item.task,
        'subtitle': l10n.categoryLabel(item.category),
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
      final cleanContent = _parsePlainContent(context, item.content);
      return {
        'title': item.title.isEmpty ? l10n.dailyEntry : item.title,
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
        'subtitle': l10n.clipboardHistory,
        'icon': CupertinoIcons.doc_on_doc,
        'color': Colors.purpleAccent,
      };
    }
    return {
      'title': l10n.untitled,
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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.itemRestored),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _permanentlyDeleteItem(dynamic item) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: AppLocalizations.of(context)!.permanentlyDelete,
        content: AppLocalizations.of(context)!.deletePermanentlyContent,
        confirmText: AppLocalizations.of(context)!.delete,
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
        title: AppLocalizations.of(context)!.emptyRecycleBinTitle,
        content: AppLocalizations.of(
          context,
        )!.emptyRecycleBinContent(itemsToDelete.length),
        confirmText: AppLocalizations.of(context)!.emptyBin,
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
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.recycleBinCleared,
                  ),
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
    final items = _getAllDeleted();

    return GlassScaffold(
      title: null,
      showBackArrow: false,
      body: Column(
        children: [
          SeamlessHeader(
            title: AppLocalizations.of(context)!.recycleBin,
            subtitle: items.isNotEmpty
                ? AppLocalizations.of(context)!.selectedCount(items.length)
                : AppLocalizations.of(context)!.empty,
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
                        AppLocalizations.of(context)!.recent,
                        _sortBy == 'date',
                        () => setState(() => _sortBy = 'date'),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        AppLocalizations.of(context)!.category,
                        _sortBy == 'type',
                        () => setState(() => _sortBy = 'type'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: EmptyStateWidget(
                            message: AppLocalizations.of(
                              context,
                            )!.recycleBinEmpty,
                            subMessage: AppLocalizations.of(
                              context,
                            )!.deletedItemsAppearHere,
                            assetPath: "assets/images/recycle_bin_empty.svg",
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
                                                    _getItemDisplayData(
                                                      context,
                                                      item,
                                                    );
                                                final deletedAt =
                                                    (item as dynamic).deletedAt;
                                                String timeLabel =
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.untitled;
                                                if (deletedAt != null) {
                                                  final now = DateTime.now();
                                                  final diff = now.difference(
                                                    deletedAt,
                                                  );
                                                  final l10n =
                                                      AppLocalizations.of(
                                                        context,
                                                      )!;
                                                  if (diff.inMinutes < 1) {
                                                    timeLabel = l10n.justNow;
                                                  } else if (diff.inHours < 1) {
                                                    timeLabel = l10n.minutesAgo(
                                                      diff.inMinutes,
                                                    );
                                                  } else if (diff.inDays < 1) {
                                                    timeLabel = l10n.hoursAgo(
                                                      diff.inHours,
                                                    );
                                                  } else {
                                                    timeLabel = l10n.daysAgo(
                                                      diff.inDays,
                                                    );
                                                  }
                                                }
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: theme
                                                        .colorScheme
                                                        .surface
                                                        .withValues(alpha: 0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          AppConstants
                                                              .cornerRadius,
                                                        ),
                                                    border: Border.all(
                                                      color: theme.dividerColor
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
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
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
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
