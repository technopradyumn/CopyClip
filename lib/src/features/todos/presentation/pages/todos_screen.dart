import 'dart:ui';
import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/utils/widget_sync_service.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../widgets/todo_card.dart';

enum TodoSortOption { custom, dateNewest, dateOldest, nameAZ, nameZA }

abstract class ListItem {}

class HeaderItem extends ListItem {
  final String category;
  final int count;
  final int total;
  final bool isExpanded;
  HeaderItem(this.category, this.count, this.total, this.isExpanded);
}

class DividerItem extends ListItem {
  DividerItem();
}

class TodoItemWrapper extends ListItem {
  final Todo todo;
  final bool isVisible;
  TodoItemWrapper(this.todo, {this.isVisible = true});
}

class QuickAddItem extends ListItem {
  final String category;
  QuickAddItem(this.category);
}

class QuickInputItem extends ListItem {
  final String category;
  QuickInputItem(this.category);
}

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  // ✅ PERFORMANCE: Notifier for the list items
  final ValueNotifier<List<ListItem>> _listItemsNotifier = ValueNotifier([]);

  // Data State
  List<Todo> _rawTodos = [];
  bool _isSelectionMode = false;
  final Set<String> _selectedTodoIds = {};

  // Filter & UI State
  String _searchQuery = "";
  TodoSortOption _currentSort = TodoSortOption.custom;
  final Map<String, bool> _categoryExpansionState = {};

  // Quick Add State
  String? _quickAddCategory;
  final TextEditingController _quickAddController = TextEditingController();
  final FocusNode _quickAddFocus = FocusNode();
  bool _isSaving = false; // LOCK

  // Animation
  late AnimationController _entryAnimationController;

  // ...

  DateTime? _lastSaveTime;
  String? _lastSaveText;

  void _saveQuickTodo(String text, String category) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;
    if (_isSaving) return; // Lock

    // DEDUPLICATION: precise debounce
    final now = DateTime.now();
    if (_lastSaveText == trimmedText &&
        _lastSaveTime != null &&
        now.difference(_lastSaveTime!) < const Duration(milliseconds: 500)) {
      return;
    }

    _isSaving = true;
    _lastSaveText = trimmedText;
    _lastSaveTime = now;

    _quickAddController.clear(); // Clear UI immediately

    try {
      // Calculate Sort Index
      final categoryTodos = _rawTodos
          .where((t) => t.category == category)
          .toList();
      final maxIndex = categoryTodos.isEmpty
          ? 0
          : categoryTodos
                .map((t) => t.sortIndex)
                .reduce((curr, next) => curr > next ? curr : next);

      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        task: trimmedText,
        category: category,
        sortIndex: maxIndex + 1,
        repeatInterval: 'daily',
      );

      if (Hive.isBoxOpen('todos_box')) {
        await Hive.box<Todo>('todos_box').add(newTodo);
      }

      // Hive listener will trigger _refreshTodos(), so we don't need to call it manually
      // except maybe to request focus if lost?
      if (mounted) {
        _quickAddFocus.requestFocus();
      }
    } finally {
      // Small delay to release lock to allow UI to settle
      await Future.delayed(const Duration(milliseconds: 100));
      _isSaving = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();

    // Listen for Search efficiently
    _searchController.addListener(() {
      _searchQuery = _searchController.text.toLowerCase();
      _generateList();
    });

    _entryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _entryAnimationController.forward();

    // REMOVED: Focus listener was causing "Double Save" / "Ghost Task" race conditions.
    // We now rely on 'onSubmitted' (Enter key) which is cleaner for rapid entry.
  }

  Future<void> _initData() async {
    await LazyBoxLoader.getBox<Todo>('todos_box'); // Ensure loaded

    // Auto-cleanup expired tasks (User Request: "not repeat then automatically delete by end of the day")
    _cleanupExpiredTasks();

    if (mounted) {
      _refreshTodos();
      Hive.box<Todo>('todos_box').listenable().addListener(_refreshTodos);
    }
  }

  void _cleanupExpiredTasks() {
    if (!Hive.isBoxOpen('todos_box')) return;
    final box = Hive.box<Todo>('todos_box');
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    for (var todo in box.values) {
      if (todo.isDeleted) continue;
      // Only non-repeating tasks with a set date
      if (todo.repeatInterval == null && todo.dueDate != null) {
        if (todo.dueDate!.isBefore(todayStart)) {
          debugPrint("Auto-deleting expired task: ${todo.task}");
          todo.isDeleted = true;
          todo.deletedAt = now;
          todo.save();
          NotificationService().cancelNotification(todo.id.hashCode);
        }
      }
    }
  }

  @override
  void dispose() {
    if (Hive.isBoxOpen('todos_box')) {
      Hive.box<Todo>('todos_box').listenable().removeListener(_refreshTodos);
    }
    _searchController.dispose();
    _listItemsNotifier.dispose();
    _entryAnimationController.dispose();
    _quickAddController.dispose();
    _quickAddFocus.dispose();
    super.dispose();
  }

  // --- DATA LOGIC ---

  void _refreshTodos() {
    if (!Hive.isBoxOpen('todos_box')) return;
    final box = Hive.box<Todo>('todos_box');

    // Safety: Deduplicate by ID to prevent "Multiple widgets used the same GlobalKey" error
    // caused by previous race conditions or bad data.
    final seenIds = <String>{};
    _rawTodos = [];

    for (var todo in box.values) {
      if (todo.isDeleted) continue;
      if (!seenIds.contains(todo.id)) {
        seenIds.add(todo.id);
        _rawTodos.add(todo);
      }
    }

    _generateList();
  }

  void _generateList() {
    List<Todo> filteredTodos = List.from(_rawTodos);

    // 1. Search Filter
    if (_searchQuery.isNotEmpty) {
      filteredTodos = filteredTodos
          .where(
            (t) =>
                t.task.toLowerCase().contains(_searchQuery) ||
                t.category.toLowerCase().contains(_searchQuery),
          )
          .toList();
    }

    // 2. Grouping & Sorting - WITH "TODAY RELEVANCE" FILTER
    // User Request: "Share only today's task in the todo screen"
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    Map<String, List<Todo>> grouped = {};
    for (var todo in filteredTodos) {
      // FILTER: Show ALL tasks (Past, Today, Future) as per user request.
      bool isRelevant = true;
      // Previous logic to hide future tasks removed.

      // If searching, show all matches regardless of date
      if (_searchQuery.isNotEmpty) isRelevant = true;

      if (isRelevant) {
        if (!grouped.containsKey(todo.category)) grouped[todo.category] = [];
        grouped[todo.category]!.add(todo);
      }
    }

    // Ensure 'General' exists if empty search (so we always have a default list)
    if (!grouped.containsKey('General') && _searchQuery.isEmpty) {
      grouped['General'] = [];
    }

    var sortedCategories = grouped.keys.toList();

    // ... (Sort logic omitted, unchanged) ...
    if (_currentSort == TodoSortOption.custom) {
      // ...
      sortedCategories.sort((a, b) {
        // Existing custom sort logic
        int indexA = grouped[a]!.isEmpty
            ? 999999
            : grouped[a]!
                  .map((t) => t.sortIndex)
                  .reduce((val, el) => val < el ? val : el);
        int indexB = grouped[b]!.isEmpty
            ? 999999
            : grouped[b]!
                  .map((t) => t.sortIndex)
                  .reduce((val, el) => val < el ? val : el);
        return indexA.compareTo(indexB);
      });
    } else {
      sortedCategories.sort();
    }

    // Move 'General' to top if present and standard sorting? Or keep alphabetical?
    // Let's keep existing logic.

    List<ListItem> flatList = [];

    for (var category in sortedCategories) {
      final categoryTodos = grouped[category]!;

      // Sort Items within Category
      switch (_currentSort) {
        case TodoSortOption.dateNewest:
          categoryTodos.sort(
            (a, b) =>
                (b.dueDate ?? DateTime(0)).compareTo(a.dueDate ?? DateTime(0)),
          );
          break;
        case TodoSortOption.dateOldest:
          categoryTodos.sort(
            (a, b) =>
                (a.dueDate ?? DateTime(0)).compareTo(b.dueDate ?? DateTime(0)),
          );
          break;
        case TodoSortOption.nameAZ:
          categoryTodos.sort((a, b) => a.task.compareTo(b.task));
          break;
        case TodoSortOption.nameZA:
          categoryTodos.sort((a, b) => b.task.compareTo(a.task));
          break;
        case TodoSortOption.custom:
          categoryTodos.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
          break;
      }

      final isExpanded = _categoryExpansionState[category] ?? true;
      final completedCount = categoryTodos.where((t) => t.isDone).length;
      final totalCount = categoryTodos.length;

      // Only show header if we have multiple categories OR if it's not "General" only?
      // User might prefer clean look. But keeping it safe.
      flatList.add(
        HeaderItem(category, completedCount, totalCount, isExpanded),
      );

      if (isExpanded) {
        // Active Todos
        final activeTodos = categoryTodos.where((t) => !t.isDone).toList();
        for (var todo in activeTodos) {
          flatList.add(TodoItemWrapper(todo, isVisible: true));
        }

        // ✅ QUICK ADD: Only when NOT searching
        if (_searchQuery.isEmpty) {
          if (_quickAddCategory == category) {
            // CRITICAL: Ensure we don't add duplicate inputs accidentally
            flatList.add(QuickInputItem(category));
          }
          flatList.add(QuickAddItem(category));
        }

        // Divider & Completed Todos
        if (completedCount > 0) {
          if (activeTodos.isNotEmpty) flatList.add(DividerItem());
          final completedTodos = categoryTodos.where((t) => t.isDone).toList();
          for (var todo in completedTodos) {
            flatList.add(TodoItemWrapper(todo, isVisible: true));
          }
        }
      }
    }

    // Update UI via Notifier
    _listItemsNotifier.value = flatList;
  }

  // --- ACTIONS ---

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    final currentList = List<ListItem>.from(_listItemsNotifier.value);
    final movedItem = currentList[oldIndex];

    // Only allow moving Todos
    if (movedItem is! TodoItemWrapper) return;

    currentList.removeAt(oldIndex);
    currentList.insert(newIndex, movedItem);

    // Optimistic UI Update
    _listItemsNotifier.value = currentList;

    // Logic to update DB (find new category and indexes)
    String currentCategory = movedItem.todo.category;
    // Walk backwards to find header
    for (int i = newIndex; i >= 0; i--) {
      if (currentList[i] is HeaderItem) {
        currentCategory = (currentList[i] as HeaderItem).category;
        break;
      }
    }

    int globalSortIndex = 0;
    for (var item in currentList) {
      if (item is TodoItemWrapper) {
        final todo = item.todo;
        if (todo == movedItem.todo) {
          todo.category = currentCategory;
        }
        todo.sortIndex = globalSortIndex++;
        todo.save();
      }
    }

    // Trigger full refresh to correct any headers
    _refreshTodos();
  }

  void _toggleTodoDone(Todo todo) {
    if (_isSelectionMode) return;

    // --- REPEAT LOGIC: RESCHEDULE INSTEAD OF CLONE ---
    // User Request: "do not delete the repeat task only auto update that tasks date"
    // --- REPEAT LOGIC: OLD RESCHEDULE BLOCK REMOVED ---
    // User Request: "show repeat task in complete also in todo screen" -> This means CLONE strategy.
    // We fall through to the clone logic below.

    final box = Hive.box<Todo>('todos_box');

    // --- REPEAT LOGIC ---
    if (!todo.isDone) {
      // MARKING AS DONE
      if (todo.repeatInterval != null) {
        final DateTime baseDate = todo.dueDate ?? DateTime.now();
        DateTime? nextDate;

        switch (todo.repeatInterval) {
          case 'daily':
            nextDate = baseDate.add(const Duration(days: 1));
            break;
          case 'weekly':
            nextDate = baseDate.add(const Duration(days: 7));
            break;
          case 'monthly':
            nextDate = DateTime(
              baseDate.year,
              baseDate.month + 1,
              baseDate.day,
              baseDate.hour,
              baseDate.minute,
            );
            break;
          case 'yearly':
            nextDate = DateTime(
              baseDate.year + 1,
              baseDate.month,
              baseDate.day,
              baseDate.hour,
              baseDate.minute,
            );
            break;
          case 'custom':
            if (todo.repeatDays != null && todo.repeatDays!.isNotEmpty) {
              DateTime current = baseDate;
              for (int i = 1; i <= 7; i++) {
                current = current.add(const Duration(days: 1));
                if (todo.repeatDays!.contains(current.weekday)) {
                  nextDate = current;
                  break;
                }
              }
            }
            break;
        }

        if (nextDate != null) {
          // Generate a fresh unique ID for the new task
          final newId = DateTime.now().millisecondsSinceEpoch.toString();
          final newTodo = Todo(
            id: newId,
            task: todo.task,
            category: todo.category,
            dueDate: nextDate,
            hasReminder: todo.hasReminder,
            isDone: false,
            repeatInterval: todo.repeatInterval,
            repeatDays: todo.repeatDays,
            sortIndex: todo.sortIndex,
          );

          box.put(newId, newTodo);

          // LINK: Store this new ID in the completed task to handle Undo
          todo.nextInstanceId = newId;

          if (newTodo.hasReminder && nextDate.isAfter(DateTime.now())) {
            NotificationService().scheduleNotification(
              id: newId.hashCode,
              title: 'Task Due',
              body: newTodo.task,
              scheduledDate: nextDate,
              payload: newTodo.id,
            );
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Next task created for ${DateFormat('MMM d').format(nextDate)}",
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    // Quick Undo UI Action
                    _toggleTodoDone(todo);
                  },
                ),
              ),
            );
          }
        }
      }
    } else {
      // MARKING AS NOT DONE (UNDOING)
      // Check if we spawned a future task and delete it
      if (todo.nextInstanceId != null) {
        if (box.containsKey(todo.nextInstanceId)) {
          final futureTask = box.get(todo.nextInstanceId);
          if (futureTask != null && !futureTask.isDone) {
            // Safe to delete because it's the auto-generated one and unused
            futureTask.delete();
            NotificationService().cancelNotification(futureTask.id.hashCode);
          }
        }
        todo.nextInstanceId = null; // Clear link
      }
    }

    todo.isDone = !todo.isDone;
    todo.save();

    // Manage notification for THIS task
    if (todo.hasReminder) {
      if (todo.isDone) {
        NotificationService().cancelNotification(todo.id.hashCode);
      } else if (todo.dueDate != null &&
          todo.dueDate!.isAfter(DateTime.now())) {
        // Re-schedule if unchecked
        NotificationService().scheduleNotification(
          id: todo.id.hashCode,
          title: 'Task Due',
          body: todo.task,
          scheduledDate: todo.dueDate!,
          payload: todo.id,
        );
      }
    }

    _refreshTodos();
    WidgetSyncService.syncTodos(); // Sync Widget
  }

  void _cancelQuickAdd() {
    setState(() {
      _quickAddCategory = null;
      _quickAddController.clear();
      _quickAddFocus.unfocus();
    });
    _generateList();
  }

  void _deleteSelected() {
    final now = DateTime.now();
    for (var id in _selectedTodoIds) {
      try {
        final todo = _rawTodos.firstWhere((t) => t.id == id);
        todo.isDeleted = true;
        todo.deletedAt = now;
        todo.save();
        NotificationService().cancelNotification(id.hashCode);
      } catch (_) {}
    }
    setState(() {
      _selectedTodoIds.clear();
      _isSelectionMode = false;
    });
    _refreshTodos();
  }

  void _deleteAll() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete All?",
        content: "Move all active tasks to Recycle Bin?",
        confirmText: "Delete All",
        isDestructive: true,
        onConfirm: () {
          final now = DateTime.now();
          for (var todo in _rawTodos) {
            todo.isDeleted = true;
            todo.deletedAt = now;
            todo.save();
            NotificationService().cancelNotification(todo.id.hashCode);
          }
          Navigator.pop(ctx);
          _refreshTodos();
        },
      ),
    );
  }

  void _openTodoEditor(Todo? todo) async {
    if (_isSelectionMode) {
      if (todo != null) _toggleSelection(todo.id);
      return;
    }
    await context.push(AppRouter.todoEdit, extra: todo);
    // Refresh UI after returning to ensure real-time updates
    _refreshTodos();
    WidgetSyncService.syncTodos();
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedTodoIds.contains(id))
        _selectedTodoIds.remove(id);
      else
        _selectedTodoIds.add(id);
      if (_selectedTodoIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _toggleCategorySelection(String category) {
    final categoryTodos = _rawTodos
        .where((t) => t.category == category)
        .toList();
    final allSelected = categoryTodos.every(
      (t) => _selectedTodoIds.contains(t.id),
    );

    setState(() {
      if (allSelected) {
        for (var t in categoryTodos) _selectedTodoIds.remove(t.id);
      } else {
        for (var t in categoryTodos) _selectedTodoIds.add(t.id);
      }
      if (_selectedTodoIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedTodoIds.length == _rawTodos.length) {
        _selectedTodoIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedTodoIds.addAll(_rawTodos.map((e) => e.id));
      }
    });
  }

  // --- UI BUILDERS ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          setState(() {
            _isSelectionMode = false;
            _selectedTodoIds.clear();
          });
          return false;
        }
        if (_quickAddCategory != null) {
          _cancelQuickAdd();
          return false;
        }
        return true;
      },
      child: GlassScaffold(
        title: null,
        floatingActionButton: _isSelectionMode
            ? null
            : FloatingActionButton(
                onPressed: () =>
                    _openTodoEditor(null), // Traditional add still works
                backgroundColor: colorScheme.primary,
                child: Icon(Icons.add, color: colorScheme.onPrimary),
              ),
        body: Column(
          children: [
            _buildTopBar(),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colorScheme.onSurface.withOpacity(0.5),
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                            },
                            child: Icon(
                              Icons.close,
                              color: colorScheme.onSurface.withOpacity(0.5),
                              size: 18,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),

            // Task List
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Clicking empty space cancels quick add
                  if (_quickAddCategory != null) {
                    if (_quickAddController.text.trim().isNotEmpty) {
                      _saveQuickTodo(
                        _quickAddController.text.trim(),
                        _quickAddCategory!,
                      );
                    } else {
                      _cancelQuickAdd();
                    }
                  }
                },
                child: ValueListenableBuilder<List<ListItem>>(
                  valueListenable: _listItemsNotifier,
                  builder: (context, items, _) {
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          "No tasks found.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      );
                    }

                    // ✅ LOGIC: ReorderableListView only when Custom Sort + No Search + Not Selecting + No Quick Add
                    final canReorder =
                        _currentSort == TodoSortOption.custom &&
                        _searchQuery.isEmpty &&
                        !_isSelectionMode &&
                        _quickAddCategory == null;

                    if (canReorder) {
                      return ReorderableListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: items.length,
                        onReorder: _onReorder,
                        buildDefaultDragHandles: false,
                        proxyDecorator: (child, index, animation) =>
                            AnimatedBuilder(
                              animation: animation,
                              builder: (_, __) => Transform.scale(
                                scale: 1.05,
                                child: Material(
                                  color: Colors.transparent,
                                  child: child,
                                ),
                              ),
                            ),
                        itemBuilder: (context, index) =>
                            _buildListItem(items[index], index, canReorder),
                      );
                    } else {
                      // ✅ PERFORMANCE: Standard ListView for other modes
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: items.length,
                        cacheExtent: 1000,
                        itemBuilder: (context, index) {
                          // RepaintBoundary caches item painting
                          return RepaintBoundary(
                            child: _buildListItem(items[index], index, false),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(ListItem item, int index, bool canReorder) {
    if (item is HeaderItem) {
      return Container(
        key: ValueKey('header_${item.category}'),
        child: _buildHeader(item),
      );
    } else if (item is QuickInputItem) {
      // ✅ QUICK INPUT Field
      return Container(
        key: ValueKey('quick_input_${item.category}'),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _quickAddController,
          focusNode: _quickAddFocus,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Type a new task...",
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.all(8),
          ),
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              _saveQuickTodo(value.trim(), item.category);
            } else {
              _cancelQuickAdd();
            }
          },
        ),
      );
    } else if (item is QuickAddItem) {
      // ✅ QUICK ADD TILE
      return GestureDetector(
        key: ValueKey('quick_add_${item.category}'),
        onTap: () {
          setState(() {
            _quickAddCategory = item.category;
            _quickAddController.clear();
            _generateList(); // Refresh to show input
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          margin: const EdgeInsets.only(bottom: 4, top: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.05),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.add_rounded,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ),
              const SizedBox(width: 12),
              Text(
                "Add a task",
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (item is DividerItem) {
      return Container(
        key: ValueKey('divider_$index'),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Completed',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
      );
    } else if (item is TodoItemWrapper) {
      final widget = Container(
        key: ValueKey(item.todo.id),
        child: TodoCard(
          todo: item.todo,
          isSelected: _selectedTodoIds.contains(item.todo.id),
          onTap: () => _isSelectionMode
              ? _toggleSelection(item.todo.id)
              : _openTodoEditor(item.todo),
          onLongPress: !canReorder
              ? () => setState(() {
                  _isSelectionMode = true;
                  _selectedTodoIds.add(item.todo.id);
                })
              : null,
          onToggleDone: () => _toggleTodoDone(item.todo),
        ),
      );

      if (canReorder) {
        return ReorderableDelayedDragStartListener(
          key: ValueKey(item.todo.id),
          index: index,
          child: widget,
        );
      }
      return widget;
    }
    return const SizedBox.shrink();
  }

  Widget _buildHeader(HeaderItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Check selection state for header icon
    final categoryTodos = _rawTodos
        .where((t) => t.category == item.category)
        .toList();
    final allSelected =
        categoryTodos.isNotEmpty &&
        categoryTodos.every((t) => _selectedTodoIds.contains(t.id));
    final someSelected =
        categoryTodos.any((t) => _selectedTodoIds.contains(t.id)) &&
        !allSelected;

    return GestureDetector(
      onTap: () {
        if (_isSelectionMode)
          _toggleCategorySelection(item.category);
        else {
          setState(
            () => _categoryExpansionState[item.category] = !item.isExpanded,
          );
          _generateList();
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            AnimatedRotation(
              turns: item.isExpanded ? 0.25 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: colorScheme.onSurface.withOpacity(0.7),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.category.toUpperCase(),
                style: TextStyle(
                  color: item.isExpanded
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 13,
                ),
              ),
            ),
            if (_isSelectionMode)
              Icon(
                allSelected
                    ? Icons.check_circle
                    : (someSelected
                          ? Icons.remove_circle_outline
                          : Icons.circle_outlined),
                color: (allSelected || someSelected)
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.38),
                size: 20,
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2,
                ),
                child: Text(
                  '${item.count}/${item.total}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ✅ FIXED: Matches Notes/Expenses screen style & Hero Tags
  Widget _buildTopBar() {
    final theme = Theme.of(context);
    final primaryColor = Colors.greenAccent; // Matches Dashboard 'todos' color

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isSelectionMode ? Icons.close : Icons.arrow_back_ios_new,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              if (_isSelectionMode) {
                setState(() {
                  _isSelectionMode = false;
                  _selectedTodoIds.clear();
                });
              } else {
                context.pop();
              }
            },
          ),
          Expanded(
            child: _isSelectionMode
                ? Center(
                    child: Text(
                      '${_selectedTodoIds.length} Selected',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      // ✅ HERO TAG 1: 'todos_icon' (was 'todos')
                      Hero(
                        tag: 'todos_icon',
                        child: Icon(
                          Icons.check_circle_outline,
                          size: 28,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // ✅ HERO TAG 2: 'todos_title'
                      Hero(
                        tag: 'todos_title',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "To-Dos",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          if (_isSelectionMode) ...[
            IconButton(
              icon: Icon(Icons.select_all, color: theme.iconTheme.color),
              onPressed: _selectAll,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _deleteSelected,
            ),
          ] else ...[
            IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: theme.iconTheme.color?.withOpacity(0.54),
              ),
              onPressed: () => setState(() => _isSelectionMode = true),
            ),
            IconButton(
              icon: Icon(Icons.filter_list, color: theme.iconTheme.color),
              onPressed: _showFilterMenu,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: Colors.redAccent,
              ),
              onPressed: _deleteAll,
            ),
          ],
        ],
      ),
    );
  }

  // ✅ IMPROVED VISIBILITY: Solid Surface Bottom Sheet
  void _showFilterMenu() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, // ✅ Solid background
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Sort By",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption(
              TodoSortOption.custom,
              "Custom Order (Drag & Drop)",
            ),
            _buildSortOption(TodoSortOption.dateNewest, "Date: Newest First"),
            _buildSortOption(TodoSortOption.dateOldest, "Date: Oldest First"),
            _buildSortOption(TodoSortOption.nameAZ, "Name: A-Z"),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(TodoSortOption option, String label) {
    final selected = _currentSort == option;
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() => _currentSort = option);
        _generateList();
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color?.withOpacity(0.5),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
