import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';

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

  bool get _isOverdue => todo.dueDate != null && todo.dueDate!.isBefore(DateTime.now()) && !todo.isDone;

  bool get _isDueToday => todo.dueDate != null && _isSameDay(todo.dueDate!, DateTime.now()) && !todo.isDone;

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isVisible ? 1.0 : 0.4,
        child: Container(
          height: isVisible ? null : 0,
          margin: isVisible ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(
              children: [
                GlassContainer(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  borderColor: _getBorderColor(colorScheme),
                  borderWidth: 1,
                  borderRadius: 10,
                  color: _getBackgroundColor(colorScheme),
                  opacity: _getOpacity(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main content row
                      Row(
                        children: [
                          // Checkbox
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
                                  color: todo.isDone ? colorScheme.primary : Colors.transparent,
                                ),
                                child: todo.isDone
                                    ? Icon(Icons.check, size: 14, color: colorScheme.onPrimary)
                                    : null,
                              ),
                            ),
                          // Task text
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
                                    fontWeight: todo.isDone ? FontWeight.w400 : FontWeight.w500,
                                    color: _getTaskTextColor(colorScheme),
                                    decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                    decorationColor: colorScheme.onSurface.withOpacity(0.38),
                                    decorationThickness: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Due date and reminder row
                      if (todo.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: _isOverdue ? colorScheme.error : (_isDueToday ? colorScheme.tertiary : colorScheme.outline),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  DateFormat('MMM d, h:mm a').format(todo.dueDate!),
                                  style: TextStyle(
                                    color: _isOverdue ? colorScheme.error : (_isDueToday ? colorScheme.tertiary : colorScheme.onSurfaceVariant),
                                    fontSize: 11,
                                    fontWeight: _isOverdue ? FontWeight.w600 : (_isDueToday ? FontWeight.w600 : FontWeight.w500),
                                  ),
                                ),
                              ),
                              if (todo.hasReminder)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.notifications_active,
                                    size: 12,
                                    color: colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Selection indicator
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.check_circle,
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

  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    final hash = category.hashCode.abs();
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.error,
    ];
    return colors[hash % colors.length];
  }

  double _getOpacity() => isSelected ? 0.4 : (todo.isDone ? 0.08 : 0.12);

  Color _getBorderColor(ColorScheme colorScheme) {
    if (isSelected) return colorScheme.primary;
    if (todo.isDone) return colorScheme.outlineVariant.withOpacity(0.3);
    if (_isOverdue) return colorScheme.error.withOpacity(0.4);
    if (_isDueToday) return colorScheme.tertiary.withOpacity(0.4);
    return colorScheme.outlineVariant.withOpacity(0.5);
  }

  Color _getCheckboxBorderColor(ColorScheme colorScheme) {
    if (todo.isDone) return colorScheme.primary;
    if (_isOverdue) return colorScheme.error;
    if (_isDueToday) return colorScheme.tertiary;
    return colorScheme.onSurface.withOpacity(0.54);
  }

  Color _getTaskTextColor(ColorScheme colorScheme) {
    if (todo.isDone) return colorScheme.onSurface.withOpacity(0.5);
    if (_isOverdue) return colorScheme.error;
    if (_isDueToday) return colorScheme.tertiary;
    return colorScheme.onSurface;
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (todo.isDone) return colorScheme.surfaceContainerLowest;
    if (_isOverdue) return colorScheme.error.withOpacity(0.5);
    if (_isDueToday) return colorScheme.tertiary.withOpacity(0.5);
    return Colors.transparent;
  }
}