import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/const/constant.dart';
import '../../data/calendar_event_model.dart';
import '../widgets/event_card.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  CalendarEvent? _event;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    final box = Hive.box<CalendarEvent>('calendar_events_box');
    final event = box.get(widget.eventId);
    if (mounted) {
      setState(() => _event = event);
    }
  }

  Future<void> _deleteEvent() async {
    final box = Hive.box<CalendarEvent>('calendar_events_box');
    final event = box.get(widget.eventId);
    if (event != null) {
      event.isDeleted = true;
      await event.save();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted')),
        );
      }
    }
  }

  Future<void> _editEvent() async {
    context.pushNamed(
      AppRouter.calendarEventEdit,
      pathParameters: {'id': widget.eventId},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GlassScaffold(
      title: 'Event Details',
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 100), () {
                  _editEvent();
                });
              },
              child: const Row(
                children: [
                  Icon(CupertinoIcons.pencil_outline),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () {
                Navigator.pop(context);
                _deleteEvent();
              },
              child: const Row(
                children: [
                  Icon(CupertinoIcons.delete),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IgnorePointer(
              child: EventCard(
                event: _event!,
                onTap: null,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Title', _event!.title),
                    _buildInfoRow('Start', _formatDate(_event!.startDate, includeTime: true)),
                    if (_event!.endDate != null)
                      _buildInfoRow('End', _formatDate(_event!.endDate!, includeTime: true)),
                    if ((_event!.location ?? '').isNotEmpty)
                      _buildInfoRow('Location', _event!.location!),
                    if ((_event!.description ?? '').isNotEmpty)
                      _buildInfoRow('Notes', _event!.description!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, {bool includeTime = false}) {
    final format = includeTime 
        ? DateFormat('MMM dd, yyyy • h:mm a') 
        : DateFormat('MMM dd, yyyy');
    return format.format(date);
  }
}

