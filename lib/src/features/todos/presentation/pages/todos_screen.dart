import 'dart:ui';
import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

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

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> with SingleTickerProviderStateMixin {
  bool _isSelectionMode = false;
  final Set<String> _selectedTodoIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  TodoSortOption _currentSort = TodoSortOption.custom;
  final Map<String, bool> _categoryExpansionState = {};
  List<ListItem> _reorderingList = [];
  bool _isReordering = false;

  late AnimationController _entryAnimationController;

  @override
  void initState() {
    super.initState();
    _entryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _entryAnimationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _entryAnimationController.dispose();
    super.dispose();
  }

  Widget _buildBouncingItem(int index, Widget child, Key key) {
    return AnimatedBuilder(
      key: key,
      animation: _entryAnimationController,
      builder: (context, child) {
        final double start = (index * 0.05).clamp(0.0, 0.8);
        final double end = (start + 0.4).clamp(0.0, 1.0);

        if (_entryAnimationController.value >= end) {
          return child!;
        }

        final animation = CurvedAnimation(
          parent: _entryAnimationController,
          curve: Interval(start, end, curve: Curves.elasticOut),
        );

        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Future<bool> _onWillPop() async {
    if (_isSelectionMode) {
      setState(() {
        _isSelectionMode = false;
        _selectedTodoIds.clear();
      });
      return false;
    }
    return true;
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedTodoIds.contains(id)) _selectedTodoIds.remove(id);
      else _selectedTodoIds.add(id);
      if (_selectedTodoIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _toggleCategorySelection(String category, List<Todo> allTodos) {
    final categoryTodos = allTodos.where((t) => t.category == category).toList();
    final allSelected = categoryTodos.every((t) => _selectedTodoIds.contains(t.id));

    setState(() {
      if (allSelected) {
        for (var t in categoryTodos) _selectedTodoIds.remove(t.id);
      } else {
        for (var t in categoryTodos) _selectedTodoIds.add(t.id);
      }
      if (_selectedTodoIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _selectAll(List<Todo> todos) {
    setState(() {
      final ids = todos.map((e) => e.id).toSet();
      if (_selectedTodoIds.containsAll(ids)) {
        _selectedTodoIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedTodoIds.addAll(ids);
      }
    });
  }

  void _deleteSelected() {
    if (_selectedTodoIds.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move ${_selectedTodoIds.length} Tasks to Bin?",
        content: "You can restore them later from settings.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          final box = Hive.box<Todo>('todos_box');
          final now = DateTime.now();
          for (var id in _selectedTodoIds) {
            final item = box.get(id);
            if (item != null) {
              item.isDeleted = true;
              item.deletedAt = now;
              item.save();
              NotificationService().cancelNotification(id.hashCode);
            }
          }
          setState(() {
            _selectedTodoIds.clear();
            _isSelectionMode = false;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _deleteAll() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move All Tasks to Bin?",
        content: "This will move all active tasks to the recycle bin.",
        confirmText: "Move All",
        isDestructive: true,
        onConfirm: () {
          final box = Hive.box<Todo>('todos_box');
          final now = DateTime.now();
          final activeTodos = box.values.where((t) => !t.isDeleted).toList();

          for (var todo in activeTodos) {
            todo.isDeleted = true;
            todo.deletedAt = now;
            todo.save();
            NotificationService().cancelNotification(todo.id.hashCode);
          }
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showFilterMenu() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sort By", style: theme.textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildSortOption(TodoSortOption.custom, "Custom Order (Drag & Drop)"),
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
    return ListTile(
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: selected ? theme.colorScheme.primary : theme.iconTheme.color?.withOpacity(0.5)),
      title: Text(label, style: theme.textTheme.bodyLarge?.copyWith(color: selected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.7))),
      onTap: () {
        setState(() => _currentSort = option);
        Navigator.pop(context);
      },
    );
  }

  void _openTodoEditor(Todo? todo) {
    if (_isSelectionMode) {
      if (todo != null) _toggleSelection(todo.id);
      return;
    }
    context.push(AppRouter.todoEdit, extra: todo);
  }

  void _toggleTodoDone(Todo todo) {
    if (_isSelectionMode) return;
    todo.isDone = !todo.isDone;
    todo.save();
  }

  List<ListItem> _generateFlatList(List<Todo> todos) {
    Map<String, List<Todo>> grouped = {};
    for (var todo in todos) {
      if (!grouped.containsKey(todo.category)) grouped[todo.category] = [];
      grouped[todo.category]!.add(todo);
    }

    var sortedCategories = grouped.keys.toList();
    if (_currentSort == TodoSortOption.custom) {
      sortedCategories.sort((a, b) {
        int indexA = grouped[a]!.isEmpty ? 999999 : grouped[a]!.map((t) => t.sortIndex).reduce((val, el) => val < el ? val : el);
        int indexB = grouped[b]!.isEmpty ? 999999 : grouped[b]!.map((t) => t.sortIndex).reduce((val, el) => val < el ? val : el);
        return indexA.compareTo(indexB);
      });
    } else {
      sortedCategories.sort();
    }

    List<ListItem> flatList = [];
    for (var category in sortedCategories) {
      final categoryTodos = grouped[category]!;
      if (_currentSort == TodoSortOption.custom) categoryTodos.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
      final isExpanded = _categoryExpansionState[category] ?? true;
      final completedCount = categoryTodos.where((t) => t.isDone).length;
      final activeCount = categoryTodos.length - completedCount;

      flatList.add(HeaderItem(category, completedCount, categoryTodos.length, isExpanded));

      if (isExpanded) {
        // Add active todos
        final activeTodos = categoryTodos.where((t) => !t.isDone).toList();
        for (var todo in activeTodos) {
          flatList.add(TodoItemWrapper(todo, isVisible: true));
        }

        // Add divider if there are completed todos
        if (completedCount > 0) {
          flatList.add(DividerItem());

          // Add completed todos
          final completedTodos = categoryTodos.where((t) => t.isDone).toList();
          for (var todo in completedTodos) {
            flatList.add(TodoItemWrapper(todo, isVisible: true));
          }
        }
      }
    }
    return flatList;
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final movedItem = _reorderingList[oldIndex];
    if (movedItem is HeaderItem || movedItem is DividerItem) return;

    if (movedItem is TodoItemWrapper) {
      setState(() {
        _isReordering = true;
        _reorderingList.removeAt(oldIndex);
        _reorderingList.insert(newIndex, movedItem);
      });

      String currentCategory = movedItem.todo.category;
      for (int i = newIndex; i >= 0; i--) {
        if (_reorderingList[i] is HeaderItem) {
          currentCategory = (_reorderingList[i] as HeaderItem).category;
          break;
        }
      }
      int globalSortIndex = 0;
      for (var item in _reorderingList) {
        if (item is TodoItemWrapper) {
          final todo = item.todo;
          if (todo == movedItem.todo) todo.category = currentCategory;
          todo.sortIndex = globalSortIndex++;
          todo.save();
        }
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _isReordering = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GlassScaffold(
        title: null,
        floatingActionButton: _isSelectionMode ? null : FloatingActionButton(onPressed: () => _openTodoEditor(null), backgroundColor: colorScheme.primary, heroTag: 'fab_new_todo', child: Icon(Icons.add, color: colorScheme.onPrimary)),
        body: Column(
          children: [
            _buildCustomTopBar(),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 0),
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  style: textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.5), size: 20),
                    suffixIcon: _searchQuery.isNotEmpty ? GestureDetector(onTap: () { _searchController.clear(); setState(() => _searchQuery = ''); }, child: Icon(Icons.close, color: colorScheme.onSurface.withOpacity(0.5), size: 18)) : null,
                    filled: true,
                    fillColor: colorScheme.onSurface.withOpacity(0.08),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value.trim().toLowerCase()),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Todo>('todos_box').listenable(),
                builder: (_, Box<Todo> box, __) {
                  List<Todo> todos = box.values.where((t) => !t.isDeleted).toList();
                  if (_searchQuery.isNotEmpty) {
                    todos = todos.where((t) => t.task.toLowerCase().contains(_searchQuery) || t.category.toLowerCase().contains(_searchQuery)).toList();
                  }

                  final flatList = _generateFlatList(todos);
                  if (!_isReordering) _reorderingList = List.from(flatList);

                  if (todos.isEmpty) return Center(child: Text("No tasks found.", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.4))));

                  final canReorder = _currentSort == TodoSortOption.custom && _searchQuery.isEmpty && !_isSelectionMode;

                  return ReorderableListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    itemCount: _isReordering ? _reorderingList.length : flatList.length,
                    buildDefaultDragHandles: false,
                    onReorder: canReorder ? _onReorder : (a, b) {},
                    proxyDecorator: (child, index, animation) => AnimatedBuilder(animation: animation, builder: (_, __) => Transform.scale(scale: 1.05, child: Material(color: Colors.transparent, child: child))),

                    itemBuilder: (_, index) {
                      final item = _isReordering ? _reorderingList[index] : flatList[index];

                      Key itemKey;
                      Widget childWidget;

                      if (item is HeaderItem) {
                        itemKey = ValueKey('header_${item.category}');
                        childWidget = Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 0),
                          child: _buildHeader(item, todos),
                        );
                      } else if (item is DividerItem) {
                        itemKey = ValueKey('divider_$index');
                        childWidget = Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (item is TodoItemWrapper) {
                        itemKey = ValueKey(item.todo.id);
                        childWidget = Container(
                          margin: EdgeInsets.zero,
                          child: item.isVisible ? TodoCard(
                            todo: item.todo,
                            isSelected: _selectedTodoIds.contains(item.todo.id),
                            onTap: () => _isSelectionMode ? _toggleSelection(item.todo.id) : _openTodoEditor(item.todo),
                            onLongPress: !canReorder ? () => _toggleSelection(item.todo.id) : null,
                            onToggleDone: () => _toggleTodoDone(item.todo),
                          ) : const SizedBox(),
                        );

                        if (canReorder) {
                          childWidget = ReorderableDelayedDragStartListener(
                            index: index,
                            child: childWidget,
                          );
                        }
                      } else {
                        itemKey = ValueKey('empty_$index');
                        childWidget = const SizedBox.shrink();
                      }

                      return _buildBouncingItem(index, childWidget, itemKey);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HeaderItem item, List<Todo> allTodos) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryTodos = allTodos.where((t) => t.category == item.category).toList();
    final allSelected = categoryTodos.isNotEmpty && categoryTodos.every((t) => _selectedTodoIds.contains(t.id));
    final someSelected = categoryTodos.any((t) => _selectedTodoIds.contains(t.id)) && !allSelected;

    return GestureDetector(
      onTap: () {
        if (_isSelectionMode) _toggleCategorySelection(item.category, allTodos);
        else setState(() => _categoryExpansionState[item.category] = !item.isExpanded);
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        child: Row(
          children: [
            AnimatedRotation(turns: item.isExpanded ? 0.25 : 0.0, duration: const Duration(milliseconds: 200), child: Icon(Icons.keyboard_arrow_right, color: colorScheme.onSurface.withOpacity(0.7), size: 20)),
            const SizedBox(width: 8),
            Expanded(child: Text(item.category.toUpperCase(), style: TextStyle(color: item.isExpanded ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7), fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13))),
            if (_isSelectionMode) Icon(allSelected ? Icons.check_circle : (someSelected ? Icons.remove_circle_outline : Icons.circle_outlined), color: (allSelected || someSelected) ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.38), size: 20)
            else Container(
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withOpacity(0.38)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('${item.count}/${item.total}', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.38), fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTopBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), child: Row(children: [IconButton(icon: Icon(_isSelectionMode?Icons.close:Icons.arrow_back_ios_new, color: theme.iconTheme.color), onPressed: () => _isSelectionMode ? setState((){_isSelectionMode=false;_selectedTodoIds.clear();}) : context.pop()), Expanded(child: _isSelectionMode ? Center(child: Text('${_selectedTodoIds.length} Selected', style: theme.textTheme.titleLarge)) : Row(children: [Hero(tag:'todos', child: Icon(Icons.check_circle_outline, size: 32, color: colorScheme.primary)), const SizedBox(width: 10), Hero(tag:'todos_title', child: Material(type:MaterialType.transparency, child: Text("To-Dos", style: theme.textTheme.titleLarge?.copyWith(fontSize: 28))))])), if(_isSelectionMode) ...[IconButton(icon: Icon(Icons.select_all, color: theme.iconTheme.color), onPressed: () => _selectAll(Hive.box<Todo>('todos_box').values.where((t) => !t.isDeleted).toList())), IconButton(icon: Icon(Icons.delete, color: colorScheme.error), onPressed: _deleteSelected)] else ...[IconButton(icon: Icon(Icons.check_circle_outline, color: theme.iconTheme.color?.withOpacity(0.54)), onPressed: ()=>setState(()=>_isSelectionMode=true)), IconButton(icon: Icon(Icons.filter_list, color: theme.iconTheme.color), onPressed: _showFilterMenu), IconButton(icon: Icon(Icons.delete_sweep_outlined, color: colorScheme.error), onPressed: _deleteAll)]]));
  }
}