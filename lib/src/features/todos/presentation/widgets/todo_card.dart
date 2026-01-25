import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/core/const/constant.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final bool isSelected;
  final bool isVisible;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onToggleDone;

  const TodoCard({
    super.key,
    required this.todo,
    required this.isSelected,
    this.isVisible = true,
    required this.onTap,
    this.onLongPress,
    required this.onToggleDone,
  });

  bool get _isOverdue {
    if (todo.dueDate == null) return false;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    // User Request: "past day without time" -> Only highlight if STRICTLY before today
    return todo.dueDate!.isBefore(todayStart) && !todo.isDone;
  }

  bool get _isDueToday =>
      todo.dueDate != null &&
      _isSameDay(todo.dueDate!, DateTime.now()) &&
      !todo.isDone;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool get _isFuture {
    if (todo.dueDate == null) return false;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    // Future means strictly AFTER today (tomorrow onwards)
    return todo.dueDate!.isAfter(todayStart) && !_isDueToday;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Adaptive color based on state
    final stateColor = _getTaskTextColor(colorScheme);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isVisible ? 1.0 : 0.4,
        child: Container(
          height: isVisible ? null : 0,
          margin: isVisible
              ? const EdgeInsets.only(bottom: 8)
              : EdgeInsets.zero,
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(
              children: [
                // ✅ OPTIMIZATION: Replaced GlassContainer with fast container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(
                      colorScheme,
                    ), // Original logic preserved
                    borderRadius: BorderRadius.circular(
                      AppConstants.cornerRadius,
                    ),
                    border: Border.all(
                      color: _getBorderColor(
                        colorScheme,
                      ), // Original logic preserved
                      width: AppConstants.borderWidth,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!isSelected)
                            GestureDetector(
                              onTap: onToggleDone,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _getCheckboxBorderColor(colorScheme),
                                    width: 2,
                                  ),
                                  color: todo.isDone
                                      ? colorScheme.primary
                                      : Colors.transparent,
                                ),
                                child: todo.isDone
                                    ? Icon(
                                        CupertinoIcons.checkmark,
                                        size: 14,
                                        color: colorScheme.onPrimary,
                                      )
                                    : null,
                              ),
                            ),
                          Expanded(
                            child: Hero(
                              tag: 'todo_task_${todo.id}',
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  todo.task,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: todo.isDone
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                    color: stateColor,
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: colorScheme.onSurface
                                        .withOpacity(0.38),
                                    decorationThickness: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (todo.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 20),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.time,
                                size: 12,
                                color: stateColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  DateFormat(
                                    'MMM d, h:mm a',
                                  ).format(todo.dueDate!),
                                  style: TextStyle(
                                    color: stateColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (todo.hasReminder)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    CupertinoIcons.bell_fill,
                                    size: 12,
                                    // ✅ Fix: Blue only if Future
                                    color: stateColor,
                                  ),
                                ),
                              if (todo.repeatInterval != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.repeat,
                                        size: 12,
                                        color: stateColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        todo.repeatInterval![0].toUpperCase() +
                                            todo.repeatInterval!.substring(1),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: stateColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Retained User Logic Helpers ---
  Color _getBorderColor(ColorScheme colorScheme) {
    if (isSelected) return colorScheme.primary;
    if (todo.isDone) return colorScheme.outlineVariant.withOpacity(0.3);
    if (_isOverdue) return colorScheme.error.withOpacity(0.4);
    if (_isDueToday) return colorScheme.tertiary.withOpacity(0.4);
    if (_isFuture)
      return colorScheme.primary.withOpacity(0.4); // Blue for Future
    return colorScheme.outlineVariant.withOpacity(0.5);
  }

  Color _getCheckboxBorderColor(ColorScheme colorScheme) {
    if (todo.isDone) return colorScheme.primary;
    if (_isOverdue) return colorScheme.error;
    if (_isDueToday) return colorScheme.tertiary;
    if (_isFuture) return colorScheme.primary; // Blue for Future
    return colorScheme.onSurface.withOpacity(0.54);
  }

  Color _getTaskTextColor(ColorScheme colorScheme) {
    if (todo.isDone) return colorScheme.onSurface.withOpacity(0.5);
    if (_isOverdue) return colorScheme.error;
    if (_isDueToday) return colorScheme.tertiary;
    if (_isFuture) return colorScheme.primary; // Blue for Future
    return colorScheme.onSurface;
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    // Opacity logic handled here instead of GlassContainer param
    if (todo.isDone) return colorScheme.surfaceContainerLowest.withOpacity(0.6);
    if (_isOverdue) return colorScheme.error.withOpacity(0.15);
    if (_isDueToday) return colorScheme.tertiary.withOpacity(0.15);
    if (_isFuture)
      return colorScheme.primary.withOpacity(0.15); // Blue for Future
    return colorScheme.surface.withOpacity(isSelected ? 0.3 : 0.12);
  }
}
