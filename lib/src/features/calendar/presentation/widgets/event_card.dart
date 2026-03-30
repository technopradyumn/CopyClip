import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../data/calendar_event_model.dart';
import '../designs/event_design_registry.dart';
import 'calendar_design_picker_sheet.dart';

class EventCard extends StatefulWidget {
  final CalendarEvent event;
  final bool isSelected;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.isSelected = false,
    this.onDelete,
    this.onTap,
  });


  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late EventDesignPattern _pattern;

  @override
  void initState() {
    super.initState();
    _loadPattern();
  }

  void _loadPattern() {
    _pattern = EventDesignRegistry.byId(widget.event.designPatternId ?? 'min_1')!;
  }

  @override
  void didUpdateWidget(covariant EventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.designPatternId != widget.event.designPatternId) {
      _loadPattern();
    }
  }

  Future<void> _showDesignPicker(BuildContext context) async {
    showCalendarDesignPicker(context, widget.event);
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Delete Event',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This event will be permanently deleted.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      widget.onDelete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final EventDesignPattern pattern = _pattern ?? EventDesignRegistry.byId('min_1')!;
    final startFormat = DateFormat('h:mm a').format(widget.event.startDate);
    final endFormat = widget.event.endDate.isAfter(widget.event.startDate.add(const Duration(hours: 1))) 
        ? DateFormat('h:mm a').format(widget.event.endDate) 
        : '';

    return GestureDetector(
onTap: widget.onTap ?? () => context.push('/calendar/detail/${widget.event.id}'),
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: pattern.primaryColor.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomPaint(
          painter: pattern.painter,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Priority indicator
                if (pattern.priorityStyle != PriorityStyle.none)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: pattern.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.event.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (pattern.hasTimeBadge) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.clock,
                              size: 12,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$startFormat${endFormat.isNotEmpty ? ' - $endFormat' : ''}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (pattern.hasLocationBadge && widget.event.location != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: pattern.secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.event.location!,
                      style: theme.textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                PopupMenuButton<String>(
                  icon: Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'design',
                      child: const Row(
                        children: [
                          Icon(Icons.palette, size: 20),
                          SizedBox(width: 12),
                          Text('Change Design'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: const Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: const Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 'design') {
                      await _showDesignPicker(context);
                    } else if (value == 'edit') {
                      context.push(AppRouter.calendarEventEdit);
                    } else if (value == 'delete') {
                      await _showDeleteConfirmation(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

