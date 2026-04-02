import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:copyclip/src/core/widgets/empty_state_widget.dart';
import '../../data/calendar_event_model.dart';
import '../widgets/event_card.dart';
import '../../services/event_notification_service.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';

enum EventSortOption { dateNewest, dateOldest, titleAZ }

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  EventSortOption _currentSort = EventSortOption.dateNewest;

  bool _isSelectionMode = false;
  final Set<String> _selectedEventIds = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CalendarEvent> _filterAndSort(List<CalendarEvent> events) {
    var result = events.where((e) => !e.isDeleted).toList();

    if (_searchQuery.isNotEmpty) {
      result = result.where((e) {
        return e.title.toLowerCase().contains(_searchQuery) ||
            e.description.toLowerCase().contains(_searchQuery) ||
            (e.location?.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }

    switch (_currentSort) {
      case EventSortOption.dateNewest:
        result.sort((a, b) => b.startDate.compareTo(a.startDate));
        break;
      case EventSortOption.dateOldest:
        result.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
      case EventSortOption.titleAZ:
        result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }

    return result;
  }

  void _onLongPress(CalendarEvent event) {
    setState(() {
      _isSelectionMode = true;
      _selectedEventIds.add(event.id);
    });
  }

  void _onTap(CalendarEvent event) {
    if (_isSelectionMode) {
      setState(() {
        if (_selectedEventIds.contains(event.id)) {
          _selectedEventIds.remove(event.id);
          if (_selectedEventIds.isEmpty) _isSelectionMode = false;
        } else {
          _selectedEventIds.add(event.id);
        }
      });
    } else {
      context.push(AppRouter.calendarEventDetail.replaceAll(':id', event.id));
    }
  }

  void _selectAll(List<CalendarEvent> events) {
    setState(() {
      if (_selectedEventIds.length == events.length) {
        _selectedEventIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedEventIds.clear();
        _selectedEventIds.addAll(events.map((e) => e.id));
      }
    });
  }

  Future<void> _deleteSelected() async {
    final box = Hive.box<CalendarEvent>('calendar_events_box');
    for (final id in _selectedEventIds) {
      final event = box.get(id);
      if (event != null) {
        event.isDeleted = true;
        await event.save();
        
        // ✅ NEW: Cancel notifications for each selected event
        await EventNotificationService.cancelNotifications(event);
      }
    }
    final count = _selectedEventIds.length;
    setState(() {
      _selectedEventIds.clear();
      _isSelectionMode = false;
    });
    _showDeleteSnackBar(count);
  }

  void _showDeleteSnackBar(int count) {
    if (!mounted) return;
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.light ? Colors.white : Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(CupertinoIcons.trash, color: Colors.redAccent, size: 20),
              const SizedBox(width: 12),
              Text(
                '$count events deleted',
                style: TextStyle(
                  color: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteSingleEvent(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: 'Delete Event?',
        content: 'Are you sure you want to delete this event?',
        confirmText: 'Delete',
        isDestructive: true,
        onConfirm: () async {
          try {
            event.isDeleted = true;
            await event.save();
            
            // ✅ NEW: Cancel notifications for the event
            await EventNotificationService.cancelNotifications(event);
            
            _showDeleteSnackBar(1);
          } catch (e) {
            debugPrint("Error deleting event: $e");
          }
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return GlassScaffold(
      title: null,
      floatingActionButton: _isSelectionMode ? null : FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.calendarEventEdit, extra: null),
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(CupertinoIcons.add, color: Colors.white),
        label: const Text('New Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: DynamicBackground(
        child: Column(
          children: [
            _buildHeader(onSurface, theme),
            _buildSearchBar(onSurface, theme),
            Expanded(
              child: ValueListenableBuilder<Box<CalendarEvent>>(
                valueListenable: Hive.box<CalendarEvent>('calendar_events_box').listenable(),
                builder: (context, box, _) {
                  final events = _filterAndSort(box.values.toList());
                  if (events.isEmpty) {
                    return Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(200, 200),
                            painter: EventEmptyPainter(color: theme.colorScheme.primary),
                          ),
                          EmptyStateWidget(
                            message: 'No Events Found',
                            subMessage: _searchQuery.isEmpty 
                                ? 'Schedule your first event' 
                                : 'Try a different search term',
                            onAction: () => context.push(AppRouter.calendarEventEdit, extra: null),
                            actionLabel: 'Add Event',
                          ),
                        ],
                      ),
                    );
                  }

                  return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final isSelected = _selectedEventIds.contains(event.id);
                      return Hero(
                        tag: 'event_${event.id}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: EventCard(
                            event: event,
                            isSelected: isSelected,
                            onTap: () => _onTap(event),
                            onLongPress: () => _onLongPress(event),
                            onDelete: () => _deleteSingleEvent(event),
                          ),
                        ),
                      );
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

  Widget _buildHeader(Color onSurface, ThemeData theme) {
    if (_isSelectionMode) {
      return SeamlessHeader(
        title: '${_selectedEventIds.length} Selected',
        heroTagPrefix: 'events',
        showBackButton: true,
        onBackTap: () => setState(() {
          _isSelectionMode = false;
          _selectedEventIds.clear();
        }),
        actions: [
          IconButton(
            icon: Icon(
              _selectedEventIds.length == (Hive.isBoxOpen('calendar_events_box') ? Hive.box<CalendarEvent>('calendar_events_box').values.where((e) => !e.isDeleted).length : 0)
                  ? CupertinoIcons.checkmark_square_fill
                  : CupertinoIcons.checkmark_square,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              if (Hive.isBoxOpen('calendar_events_box')) {
                final box = Hive.box<CalendarEvent>('calendar_events_box');
                final allEvents = box.values.where((e) => !e.isDeleted).toList();
                _selectAll(allEvents);
              }
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.delete, color: Colors.redAccent),
            onPressed: _deleteSelected,
          ),
        ],
      );
    }

    return SeamlessHeader(
      title: 'All Events',
      subtitle: 'Your scheduled events',
      icon: CupertinoIcons.calendar_today,
      iconColor: const Color(0xFFAB47BC), // Matched PURPLE color
      heroTagPrefix: 'events',
      actions: [
        // MORE MENU (As requested)
        PopupMenuButton<String>(
          icon: Icon(CupertinoIcons.ellipsis_vertical, color: onSurface.withOpacity(0.7)),
          onSelected: (value) async {
            if (value == 'select') {
              setState(() => _isSelectionMode = true);
            } else if (value == 'select_all') {
              final box = Hive.box<CalendarEvent>('calendar_events_box');
              final allEvents = box.values.where((e) => !e.isDeleted).toList();
              _selectAll(allEvents);
              setState(() => _isSelectionMode = true);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'select',
              child: Row(
                children: [
                  Icon(CupertinoIcons.checkmark_circle, size: 20),
                  SizedBox(width: 12),
                  Text('Select'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'select_all',
              child: Row(
                children: [
                  Icon(CupertinoIcons.checkmark_square, size: 20),
                  SizedBox(width: 12),
                  Text('Select All'),
                ],
              ),
            ),
          ],
        ),
        PopupMenuButton<EventSortOption>(
          icon: Icon(CupertinoIcons.slider_horizontal_3, color: onSurface.withOpacity(0.7)),
          tooltip: 'Sort Events',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (EventSortOption result) {
            setState(() => _currentSort = result);
          },
          itemBuilder: (context) => <PopupMenuEntry<EventSortOption>>[
            PopupMenuItem<EventSortOption>(
              value: EventSortOption.dateNewest,
              child: _buildSortItem(CupertinoIcons.calendar_today, 'Newest First', _currentSort == EventSortOption.dateNewest, theme),
            ),
             PopupMenuItem<EventSortOption>(
              value: EventSortOption.dateOldest,
              child: _buildSortItem(CupertinoIcons.time, 'Oldest First', _currentSort == EventSortOption.dateOldest, theme),
            ),
             PopupMenuItem<EventSortOption>(
              value: EventSortOption.titleAZ,
              child: _buildSortItem(CupertinoIcons.textformat, 'Title A-Z', _currentSort == EventSortOption.titleAZ, theme),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortItem(IconData icon, String label, bool isSelected, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: isSelected ? theme.colorScheme.primary : null),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.primary : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(Color onSurface, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: onSurface.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppConstants.cornerRadius * 0.75),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.1),
            width: AppConstants.borderWidth,
          ),
        ),
        child: TextField(
          controller: _searchController,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Search events...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: onSurface.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: onSurface.withOpacity(0.5),
              size: 20,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () => _searchController.clear(),
                    child: Icon(
                      CupertinoIcons.xmark,
                      color: onSurface.withOpacity(0.5),
                      size: 18,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}

class EventEmptyPainter extends CustomPainter {
  final Color color;
  EventEmptyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withOpacity(0.04)
      ..style = PaintingStyle.fill;
    
    // Ambient circles
    for (int i = 1; i <= 4; i++) {
        canvas.drawCircle(center, (i * 35).toDouble(), paint);
    }
    
    final accentPaint = Paint()
      ..color = color.withOpacity(0.08)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
      
    // Decorative arcs
    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: 60 + (i * 10).toDouble()),
        (i * 0.5),
        1.5,
        false,
        accentPaint,
      );
    }
    
    // Abstract dots
    final dotPaint = Paint()..color = color.withOpacity(0.08);
    final offsets = [
       Offset(size.width * 0.2, size.height * 0.3),
       Offset(size.width * 0.8, size.height * 0.2),
       Offset(size.width * 0.3, size.height * 0.8),
       Offset(size.width * 0.7, size.height * 0.7),
    ];
    for (var offset in offsets) {
      canvas.drawCircle(offset, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
