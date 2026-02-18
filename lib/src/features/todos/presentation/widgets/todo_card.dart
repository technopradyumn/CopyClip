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
    return todo.dueDate!.isAfter(todayStart) && !_isDueToday;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final stateColor = _getTaskTextColor(colorScheme);
    final backgroundColor = _getBackgroundColor(colorScheme);
    final borderColor = _getBorderColor(colorScheme);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isVisible ? 1.0 : 0.0,
        child: Container(
          height: isVisible ? null : 0,
          margin: isVisible
              ? const EdgeInsets.only(bottom: 12)
              : EdgeInsets.zero,
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Hero(
              tag: 'todo_container_${todo.id}',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(
                    AppConstants.cornerRadius,
                  ),
                  border: Border.all(
                    color: borderColor,
                    width: AppConstants.borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: stateColor.withValues(alpha: 0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!isSelected) _buildCheckbox(colorScheme),
                          Expanded(
                            child: Text(
                              todo.task,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: todo.isDone
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                                color: stateColor.withValues(alpha: 
                                  todo.isDone ? 0.6 : 1.0,
                                ),
                                decoration: todo.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: stateColor.withValues(alpha: 0.4),
                                decorationThickness: 2,
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: colorScheme.primary,
                              size: 22,
                            ),
                        ],
                      ),
                      if (todo.dueDate != null) _buildDueDateRow(stateColor),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: onToggleDone,
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _getCheckboxBorderColor(colorScheme),
            width: 2.5,
          ),
          color: todo.isDone
              ? _getTaskTextColor(colorScheme).withValues(alpha: 0.8)
              : Colors.transparent,
        ),
        child: todo.isDone
            ? const Icon(
                CupertinoIcons.checkmark,
                size: 15,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  Widget _buildDueDateRow(Color stateColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 38),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.calendar,
                size: 13,
                color: stateColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 5),
              Text(
                DateFormat('MMM d • h:mm a').format(todo.dueDate!),
                style: TextStyle(
                  color: stateColor.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          if (todo.hasReminder)
            Icon(
              CupertinoIcons.bell_fill,
              size: 13,
              color: stateColor.withValues(alpha: 0.7),
            ),
          if (todo.repeatInterval != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.repeat,
                  size: 13,
                  color: stateColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  todo.repeatInterval![0].toUpperCase() +
                      todo.repeatInterval!.substring(1),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: stateColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    if (isSelected) return colorScheme.primary;
    if (todo.isDone) return colorScheme.outlineVariant.withValues(alpha: 0.2);
    if (_isOverdue) return colorScheme.error.withValues(alpha: 0.2);
    if (_isDueToday) return colorScheme.tertiary.withValues(alpha: 0.2);
    if (_isFuture) return colorScheme.primary.withValues(alpha: 0.2);
    return colorScheme.outlineVariant.withValues(alpha: 0.2);
  }

  Color _getCheckboxBorderColor(ColorScheme colorScheme) {
    if (todo.isDone) return _getTaskTextColor(colorScheme).withValues(alpha: 0.8);
    if (_isOverdue) return colorScheme.error;
    if (_isDueToday) return colorScheme.tertiary;
    if (_isFuture) return colorScheme.primary;
    return colorScheme.onSurface.withValues(alpha: 0.4);
  }

  Color _getTaskTextColor(ColorScheme colorScheme) {
    if (todo.isDone) return colorScheme.onSurface.withValues(alpha: 0.5);
    if (_isOverdue) return colorScheme.error;
    if (_isDueToday) return colorScheme.tertiary;
    if (_isFuture) return colorScheme.primary;
    return colorScheme.onSurface;
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (todo.isDone) return colorScheme.surfaceContainerHighest.withValues(alpha: 0.2);
    if (_isOverdue) return colorScheme.error.withValues(alpha: 0.12);
    if (_isDueToday) return colorScheme.tertiary.withValues(alpha: 0.12);
    if (_isFuture) return colorScheme.primary.withValues(alpha: 0.12);
    return colorScheme.surface.withValues(alpha: isSelected ? 0.4 : 0.2);
  }
}
