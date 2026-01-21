import 'dart:async';
import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/utils/widget_sync_service.dart';

import '../../../../core/widgets/glass_dialog.dart';

// --- Snapshot Class for Undo/Redo ---
class TodoFormState {
  final String task;
  final String category;
  final DateTime? date;
  final bool hasReminder;
  final bool isDone;
  final String? repeatInterval;
  final List<int>? repeatDays;

  TodoFormState(
    this.task,
    this.category,
    this.date,
    this.hasReminder,
    this.isDone,
    this.repeatInterval,
    this.repeatDays,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoFormState &&
          runtimeType == other.runtimeType &&
          task == other.task &&
          category == other.category &&
          date == other.date &&
          hasReminder == other.hasReminder &&
          isDone == other.isDone &&
          repeatInterval == other.repeatInterval &&
          _listEquals(repeatDays, other.repeatDays);

  bool _listEquals(List<int>? a, List<int>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    task,
    category,
    date,
    hasReminder,
    isDone,
    repeatInterval,
    Object.hashAll(repeatDays ?? []),
  );
}

class TodoEditScreen extends StatefulWidget {
  final Todo? todo;
  const TodoEditScreen({super.key, this.todo});

  @override
  State<TodoEditScreen> createState() => _TodoEditScreenState();
}

class _TodoEditScreenState extends State<TodoEditScreen> {
  late TextEditingController _taskController;
  late TextEditingController _categoryController;

  final FocusNode _categoryFocusNode = FocusNode();
  final FocusNode _taskFocusNode = FocusNode();

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  DateTime? _selectedDate;
  bool _hasReminder = false;
  bool _isDone = false;

  // Repeat State
  String? _repeatInterval;
  List<int>? _repeatDays;

  final List<TodoFormState> _undoStack = [];
  final List<TodoFormState> _redoStack = [];
  Timer? _debounceTimer;

  List<String> _suggestions = ['Work', 'Personal', 'Shopping', 'Health'];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _taskController = TextEditingController(text: widget.todo?.task ?? '');
    _categoryController = TextEditingController(
      text: widget.todo?.category ?? 'General',
    );
    // ✅ DEFAULT: Notifications ON for new tasks
    if (widget.todo == null) {
      _selectedDate = DateTime.now();
      _hasReminder = true;
    } else {
      _selectedDate = widget.todo?.dueDate;
      _hasReminder = widget.todo?.hasReminder ?? false;
    }
    _isDone = widget.todo?.isDone ?? false;
    _repeatInterval = widget.todo?.repeatInterval;
    _repeatDays = widget.todo?.repeatDays != null
        ? List.from(widget.todo!.repeatDays!)
        : [];

    _saveSnapshot(clearRedo: true);

    _categoryFocusNode.addListener(() {
      if (_categoryFocusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });

    _taskController.addListener(_onTextChanged);
    _categoryController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _removeOverlay();
    _categoryFocusNode.dispose();
    _taskFocusNode.dispose();
    _categoryController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  void _loadCategories() {
    if (Hive.isBoxOpen('todos_box')) {
      final box = Hive.box<Todo>('todos_box');
      final existingCategories = box.values
          .where((t) => !t.isDeleted)
          .map((e) => e.category)
          .toSet()
          .toList();
      if (existingCategories.isNotEmpty) {
        setState(() {
          _suggestions = {..._suggestions, ...existingCategories}.toList();
        });
      }
    }
  }

  // --- UNDO / REDO LOGIC ---
  void _saveSnapshot({bool clearRedo = true}) {
    final currentState = TodoFormState(
      _taskController.text,
      _categoryController.text,
      _selectedDate,
      _hasReminder,
      _isDone,
      _repeatInterval,
      _repeatDays != null ? List.from(_repeatDays!) : null,
    );
    if (_undoStack.isNotEmpty && _undoStack.last == currentState) return;
    _undoStack.add(currentState);
    if (clearRedo) _redoStack.clear();
    if (_undoStack.length > 20) _undoStack.removeAt(0);
    if (mounted) setState(() {});
  }

  void _undo() {
    _unfocusAll();
    if (_undoStack.length <= 1) return;
    final currentState = _undoStack.removeLast();
    _redoStack.add(currentState);
    final previousState = _undoStack.last;
    _restoreState(previousState);
  }

  void _redo() {
    _unfocusAll();
    if (_redoStack.isEmpty) return;
    final nextState = _redoStack.removeLast();
    _undoStack.add(nextState);
    _restoreState(nextState);
  }

  void _restoreState(TodoFormState state) {
    setState(() {
      if (_taskController.text != state.task) {
        _taskController.value = TextEditingValue(
          text: state.task,
          selection: TextSelection.collapsed(offset: state.task.length),
        );
      }
      if (_categoryController.text != state.category) {
        _categoryController.value = TextEditingValue(
          text: state.category,
          selection: TextSelection.collapsed(offset: state.category.length),
        );
      }
      _selectedDate = state.date;
      _hasReminder = state.hasReminder;
      _isDone = state.isDone;
      _repeatInterval = state.repeatInterval;
      _repeatDays = state.repeatDays != null
          ? List.from(state.repeatDays!)
          : null;
    });
  }

  void _onTextChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      _saveSnapshot();
    });
  }

  // --- OVERLAY LOGIC ---
  void _showOverlay() {
    if (_isDropdownOpen) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  void _removeOverlay() {
    if (!_isDropdownOpen) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final theme = Theme.of(context);
    final bgColor = theme.colorScheme.surface;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 40,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 60.0),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: bgColor,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
                color: bgColor,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final option = _suggestions[index];
                  return ListTile(
                    title: Text(option, style: theme.textTheme.bodyLarge),
                    onTap: () {
                      _saveSnapshot();
                      _categoryController.text = option;
                      _saveSnapshot();
                      _categoryFocusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _pickDateTime() async {
    _unfocusAll();
    _saveSnapshot();
    DateTime tempDate = _selectedDate ?? DateTime.now();
    if (tempDate.isBefore(DateTime.now()) && _selectedDate == null) {
      tempDate = DateTime.now();
    }

    final theme = Theme.of(context);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: theme.textTheme.bodyMedium),
                    ),
                    Text(
                      'Select Date & Time',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = tempDate;
                          _hasReminder = true;
                        });
                        _saveSnapshot();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: theme.dividerColor, height: 1),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: theme.brightness,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: theme.textTheme.bodyLarge
                          ?.copyWith(fontSize: 18),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: tempDate,
                    mode: CupertinoDatePickerMode.dateAndTime,
                    use24hFormat: false,
                    onDateTimeChanged: (DateTime newDate) {
                      tempDate = newDate;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveTodo() {
    if (_taskController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a task')));
      return;
    }

    final box = Hive.box<Todo>('todos_box');
    final String id =
        widget.todo?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final int notifId = id.hashCode;
    final DateTime? finalDate = _hasReminder ? _selectedDate : null;

    int newSortIndex = widget.todo?.sortIndex ?? 0;

    // If implementing "Newest at Top" logic for NEW items
    if (widget.todo == null && box.isNotEmpty) {
      final existingIndices = box.values.map((e) => e.sortIndex);
      if (existingIndices.isNotEmpty) {
        newSortIndex =
            existingIndices.reduce((curr, next) => curr < next ? curr : next) -
            1;
      }
    }

    final newTodo = Todo(
      id: id,
      task: _taskController.text.trim(),
      category: _categoryController.text.trim().isEmpty
          ? 'General'
          : _categoryController.text.trim(),
      dueDate: finalDate,
      hasReminder: _hasReminder,
      isDone: _isDone,
      sortIndex: newSortIndex,
      repeatInterval: _repeatInterval,
      repeatDays: _repeatDays,
    );

    // ✅ FIX: Use the existing Hive Key if available to prevent duplicates/ghost updates
    if (widget.todo != null && widget.todo!.isInBox) {
      box.put(widget.todo!.key, newTodo);
    } else {
      box.put(id, newTodo);
    }

    // ✅ FIX: Allow scheduling even if date is slightly in the past (e.g. "Just Now")
    // by adding a small buffer or checking if it's clearly in the future.
    // We'll trust the user's intent if it's within the last 5 minutes, treating it as "due now".
    if (_hasReminder && finalDate != null && !_isDone) {
      if (finalDate.isAfter(
        DateTime.now().subtract(const Duration(minutes: 5)),
      )) {
        NotificationService().scheduleNotification(
          id: notifId,
          title: 'Task Due Now',
          body: newTodo.task,
          scheduledDate: finalDate.isBefore(DateTime.now())
              ? DateTime.now().add(
                  const Duration(seconds: 5),
                ) // Fire immediately if "now"
              : finalDate,
          payload: newTodo.id,
        );
      }
    } else {
      NotificationService().cancelNotification(notifId);
    }

    // Sync Widget
    WidgetSyncService.syncTodos();

    context.pop();
  }

  void _deleteTodo() {
    if (widget.todo == null) return;

    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move Task to Recycle Bin?",
        content: "You can restore this task later from settings.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          final todo = widget.todo!;
          todo.isDeleted = true;
          todo.deletedAt = DateTime.now();
          todo.save();
          todo.save();
          NotificationService().cancelNotification(todo.id.hashCode);
          WidgetSyncService.syncTodos(); // Sync Widget
          Navigator.pop(ctx); // Close dialog
          context.pop(); // Go back from edit screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    String dateText = 'Set Due Date';
    if (_selectedDate != null) {
      dateText = DateFormat('EEE, MMM d • h:mm a').format(_selectedDate!);
    } else {
      dateText = 'Today • ${DateFormat('h:mm a').format(DateTime.now())}';
    }

    return GestureDetector(
      onTap: _unfocusAll,
      behavior: HitTestBehavior.opaque,
      child: GlassScaffold(
        showBackArrow: true,
        title: widget.todo == null ? 'New Task' : 'Edit Task',
        actions: [
          IconButton(
            onPressed: _undoStack.length > 1 ? _undo : null,
            icon: Icon(
              Icons.undo,
              color: _undoStack.length > 1
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withOpacity(0.3),
            ),
            tooltip: 'Undo',
          ),
          IconButton(
            onPressed: _redoStack.isNotEmpty ? _redo : null,
            icon: Icon(
              Icons.redo,
              color: _redoStack.isNotEmpty
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withOpacity(0.3),
            ),
            tooltip: 'Redo',
          ),
          if (widget.todo != null)
            IconButton(
              onPressed: _deleteTodo,
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              tooltip: 'Delete Task',
            ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),

              CompositedTransformTarget(
                link: _layerLink,
                child: Hero(
                  tag: 'todo_category_${widget.todo?.id ?? "new"}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: TextField(
                      controller: _categoryController,
                      focusNode: _categoryFocusNode,
                      style: textTheme.bodyLarge,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.onSurface.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isDropdownOpen
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: colorScheme.onSurface.withOpacity(0.54),
                          ),
                          onPressed: () {
                            if (_isDropdownOpen) {
                              _categoryFocusNode.unfocus();
                            } else {
                              _categoryFocusNode.requestFocus();
                            }
                          },
                        ),
                        hintText: 'e.g. Work, Gym',
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'What needs to be done?',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Hero(
                tag: 'todo_task_${widget.todo?.id ?? "new"}',
                child: Material(
                  type: MaterialType.transparency,
                  child: TextField(
                    controller: _taskController,
                    focusNode: _taskFocusNode,
                    style: textTheme.bodyLarge?.copyWith(fontSize: 18),
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.onSurface.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter task details...',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Date & Reminder Container
              GlassContainer(
                onTap: _pickDateTime,
                padding: const EdgeInsets.all(16),
                opacity: _selectedDate != null ? 0.15 : 0.08,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: _selectedDate == null
                          ? colorScheme.onSurface.withOpacity(0.54)
                          : colorScheme.error,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedDate == null ? 'Set Due Date' : 'Due Date',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            dateText,
                            style: TextStyle(
                              color: _selectedDate == null
                                  ? colorScheme.onSurface.withOpacity(0.38)
                                  : colorScheme.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _hasReminder,
                      activeColor: colorScheme.primary,
                      onChanged: (val) {
                        _unfocusAll();
                        _saveSnapshot();
                        setState(() {
                          _hasReminder = val;
                          if (val) {
                            // If turning ON and date is null, set to now
                            if (_selectedDate == null) {
                              _selectedDate = DateTime.now();
                            }
                          } else {
                            // If turning OFF, strictly clear date? Or just keep it but disable flag?
                            // User request: "Default ON". So we keep date references mostly valid.
                            // But for UI consistency, if OFF, we can keep date null or just hide it.
                            // keeping standard behavior:
                            _selectedDate = null;
                          }
                        });
                        _saveSnapshot();
                        if (val) _pickDateTime();
                      },
                    ),
                  ],
                ),
              ),

              if (_hasReminder && _selectedDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12),
                  child: Text(
                    "We'll send you a notification at this time.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // --- REPEAT UI TOGGLE ---
              GlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                opacity: _repeatInterval != null ? 0.15 : 0.08,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.repeat,
                          color: _repeatInterval != null
                              ? colorScheme.primary
                              : colorScheme.onSurface.withOpacity(0.54),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Repeat Task',
                            style: TextStyle(
                              color: _repeatInterval != null
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Switch(
                          value: _repeatInterval != null,
                          activeColor: colorScheme.primary,
                          onChanged: (val) {
                            _unfocusAll();
                            _saveSnapshot();
                            setState(() {
                              _repeatInterval = val ? 'daily' : null;
                              if (val &&
                                  (_repeatDays == null ||
                                      _repeatDays!.isEmpty)) {
                                _repeatDays = [];
                              }
                            });
                            _saveSnapshot();
                          },
                        ),
                      ],
                    ),
                    if (_repeatInterval != null) ...[
                      Divider(color: theme.dividerColor.withOpacity(0.2)),
                      const SizedBox(height: 8),
                      // Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _repeatInterval,
                            isExpanded: true,
                            dropdownColor: theme.cardColor,
                            items:
                                [
                                      'daily',
                                      'weekly',
                                      'monthly',
                                      'yearly',
                                      'custom',
                                    ]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e[0].toUpperCase() + e.substring(1),
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              setState(() {
                                _repeatInterval = val;
                              });
                              _saveSnapshot();
                            },
                          ),
                        ),
                      ),
                      if (_repeatInterval == 'custom') ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: List.generate(7, (index) {
                            final dayIndex = index + 1;
                            final isSelected =
                                _repeatDays?.contains(dayIndex) ?? false;
                            final dayName = [
                              'M',
                              'T',
                              'W',
                              'T',
                              'F',
                              'S',
                              'S',
                            ][index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _repeatDays ??= [];
                                  if (isSelected) {
                                    _repeatDays!.remove(dayIndex);
                                  } else {
                                    _repeatDays!.add(dayIndex);
                                  }
                                });
                                _saveSnapshot();
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? colorScheme.primary
                                        : Colors.transparent,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  dayName,
                                  style: TextStyle(
                                    color: isSelected
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- COMPLETION TOGGLE ---
              GlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                opacity: _isDone ? 0.2 : 0.08,
                child: Row(
                  children: [
                    Icon(
                      _isDone
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _isDone
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.54),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _isDone ? 'Completed' : 'Mark as Completed',
                        style: TextStyle(
                          color: _isDone
                              ? colorScheme.primary
                              : colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isDone,
                      activeColor: colorScheme.primary,
                      onChanged: (val) {
                        _unfocusAll();
                        _saveSnapshot();
                        setState(() => _isDone = val);
                        _saveSnapshot();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _saveTodo,
          backgroundColor: colorScheme.primary,
          label: Text(
            'Save Task',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(Icons.save, color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}
