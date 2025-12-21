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
          // Using margin here to match original spacing logic
          margin: isVisible ? const EdgeInsets.only(bottom: 12) : EdgeInsets.zero,
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(
              children: [
                GlassContainer(
                  margin: EdgeInsets.zero,
                  opacity: isSelected ? 0.3 : 0.1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!isSelected) // Hide checkbox circle in selection mode
                            GestureDetector(
                              onTap: onToggleDone,
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 24, height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: todo.isDone ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.54),
                                      width: 2
                                  ),
                                  color: todo.isDone ? colorScheme.primary.withOpacity(0.5) : Colors.transparent,
                                ),
                                child: todo.isDone ? Icon(Icons.check, size: 16, color: colorScheme.onPrimary) : null,
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
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                    decorationColor: colorScheme.onSurface.withOpacity(0.38),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (todo.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 36, top: 4),
                          child: Material(
                            type: MaterialType.transparency,
                            child: Row(
                              children: [
                                Icon(Icons.access_time, size: 12, color: colorScheme.error),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM d, h:mm a').format(todo.dueDate!),
                                  style: TextStyle(color: colorScheme.error, fontSize: 11, fontWeight: FontWeight.w500),
                                ),
                                if (todo.hasReminder)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.notifications_active, size: 12, color: colorScheme.primary),
                                  )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 10, right: 10,
                    child: Icon(
                        Icons.check_circle,
                        color: colorScheme.primary
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}