import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_router.dart';
import '../../data/calendar_event_model.dart';
import '../designs/event_design_registry.dart';
import './calendar_design_picker_sheet.dart';

class EventCard extends StatefulWidget {
  final CalendarEvent event;
  final bool isSelected;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const EventCard({
    super.key,
    required this.event,
    this.isSelected = false,
    this.onDelete,
    this.onTap,
    this.onLongPress,
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
    if (Hive.isBoxOpen('calendar_events_box')) {
      Hive.box<CalendarEvent>('calendar_events_box').listenable().addListener(_onBoxChanged);
    }
  }

  void _onBoxChanged() {
    if (!mounted) return;
    final box = Hive.box<CalendarEvent>('calendar_events_box');
    final updated = box.get(widget.event.id);
    if (updated != null) {
      _loadPatternById(updated.designPatternId ?? 'min_1');
    }
  }

  @override
  void dispose() {
    if (Hive.isBoxOpen('calendar_events_box')) {
      Hive.box<CalendarEvent>('calendar_events_box').listenable().removeListener(_onBoxChanged);
    }
    super.dispose();
  }

  void _loadPattern() {
    _pattern = EventDesignRegistry.byId(widget.event.designPatternId ?? 'min_1')!;
  }

  void _loadPatternById(String id) {
    final p = EventDesignRegistry.byId(id);
    if (p != null && mounted) {
      setState(() => _pattern = p);
    }
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString.startsWith('http') ? urlString : 'https://$urlString');
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $urlString', style: const TextStyle(fontSize: 12))),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid URL format: $urlString', style: const TextStyle(fontSize: 12))),
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant EventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.designPatternId != widget.event.designPatternId) {
      _loadPattern();
    }
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      context.push(AppRouter.calendarEventDetail.replaceAll(':id', widget.event.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSameDay = widget.event.startDate.year == widget.event.endDate.year &&
                      widget.event.startDate.month == widget.event.endDate.month &&
                      widget.event.startDate.day == widget.event.endDate.day;
    
    String _formatTime(DateTime date) {
      return DateFormat('h:mm a').format(date).replaceAll(' ', '');
    }

    String timeString;
    if (isSameDay) {
      timeString = '${DateFormat('d MMMM yyyy').format(widget.event.startDate)}, ${_formatTime(widget.event.startDate)} - ${_formatTime(widget.event.endDate)}';
    } else {
      timeString = '${DateFormat('d MMMM yyyy').format(widget.event.startDate)}, ${_formatTime(widget.event.startDate)} - ${DateFormat('d MMMM yyyy').format(widget.event.endDate)}, ${_formatTime(widget.event.endDate)}';
    }

    final now = DateTime.now();
    String statusStr;
    Color statusColor;
    if (now.isAfter(widget.event.endDate)) {
      statusStr = 'PAST';
      statusColor = Colors.grey.shade700;
    } else if (now.isBefore(widget.event.startDate)) {
      statusStr = 'UPCOMING';
      statusColor = const Color(0xFF2196F3); // Vibrant Blue
    } else {
      statusStr = 'ONGOING';
      statusColor = const Color(0xFF4CAF50); // Vibrant Green
    }

    return GestureDetector(
      onTap: _handleTap,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: widget.isSelected 
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
            boxShadow: [
              BoxShadow(
                color: _pattern.primaryColor.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _pattern.painter,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_pattern.priorityStyle != PriorityStyle.none)
                            Container(
                              width: 4,
                              height: 16,
                              margin: const EdgeInsets.only(top: 4, right: 8),
                              decoration: BoxDecoration(
                                color: _pattern.primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              widget.event.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildThreeDotsMenu(context, theme),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Time Info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Icon(
                                CupertinoIcons.clock,
                                size: 12,
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                timeString,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.9),
                                  fontSize: 9,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Details Section
                      if (widget.event.description.isNotEmpty || widget.event.location != null || (widget.event.url != null && widget.event.url!.isNotEmpty)) ...[
                        const SizedBox(height: 6),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.event.description.isNotEmpty)
                                Text(
                                  widget.event.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    fontSize: 9,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (widget.event.location != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.location, size: 10, color: theme.colorScheme.primary.withOpacity(0.7)),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        widget.event.location!,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.primary.withOpacity(0.7),
                                          fontSize: 9,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (widget.event.url != null && widget.event.url!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => _launchUrl(widget.event.url!),
                                  child: Row(
                                    children: [
                                      Icon(CupertinoIcons.link, size: 10, color: Colors.blue.withOpacity(0.8)),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          widget.event.url!,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: Colors.blue.withOpacity(0.8),
                                            fontSize: 9,
                                            decoration: TextDecoration.underline,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 8),
                      // Status Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: statusColor.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  statusStr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (widget.isSelected)
                  Positioned.fill(
                    child: Container(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
          ),
        ),
      ),
    );
  }

  Widget _buildThreeDotsMenu(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(
        CupertinoIcons.ellipsis_vertical,
        size: 18,
        color: theme.colorScheme.onSurface.withOpacity(0.5),
      ),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        if (value == 'edit') {
          context.push(AppRouter.calendarEventEdit, extra: widget.event);
        } else if (value == 'design') {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => CalendarDesignPickerSheet(
              event: widget.event,
              currentDesignId: widget.event.designPatternId,
              onDesignSelected: (id) async {
                final event = widget.event;
                event.designPatternId = id;
                await event.save();
              },
            ),
          );
        } else if (value == 'delete') {
          widget.onDelete?.call();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(CupertinoIcons.pencil, size: 18),
              SizedBox(width: 8),
              Text('Edit Info'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'design',
          child: Row(
            children: [
              Icon(CupertinoIcons.paintbrush, size: 18),
              SizedBox(width: 8),
              Text('Change Design'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(CupertinoIcons.trash, size: 18, color: theme.colorScheme.error),
              const SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: theme.colorScheme.error)),
            ],
          ),
        ),
      ],
    );
  }
}
