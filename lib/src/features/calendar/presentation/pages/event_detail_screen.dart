import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/calendar_event_model.dart';
import '../widgets/event_card.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Future<void> _deleteEvent() async {
    final box = Hive.box<CalendarEvent>('calendar_events_box');
    final event = box.get(widget.eventId);
    if (event != null) {
      event.isDeleted = true;
      await event.save();
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted')),
        );
      }
    }
  }

  Future<void> _editEvent(CalendarEvent event) async {
    context.push(AppRouter.calendarEventEdit, extra: event);
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString.startsWith('http') ? urlString : 'https://$urlString');
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $urlString')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid URL format: $urlString')),
        );
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Delete Event',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
                      onPressed: () => Navigator.pop(ctx, false),
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
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
      await _deleteEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safety: ensure box is open before listening
    if (!Hive.isBoxOpen('calendar_events_box')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return ValueListenableBuilder<Box<CalendarEvent>>(
      valueListenable: Hive.box<CalendarEvent>('calendar_events_box').listenable(),
      builder: (context, box, _) {
        final event = box.get(widget.eventId);

        // If deleted or not found, show loading/gone state
        if (event == null || event.isDeleted) {
          return Scaffold(
            appBar: AppBar(title: const Text('Event Details')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.calendar_badge_minus, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Event not found', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        }

        return GlassScaffold(
          showBackArrow: false,
          title: null,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => Future.delayed(
                    const Duration(milliseconds: 100),
                    () => _editEvent(event),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.pencil_outline),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: () => Future.delayed(
                    const Duration(milliseconds: 100),
                    () => _confirmDelete(),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
          body: DynamicBackground(
            child: Column(
              children: [
                SeamlessHeader(
                  title: 'Event Details',
                  icon: CupertinoIcons.calendar_today,
                  iconColor: const Color(0xFFAB47BC),
                  heroTagPrefix: 'events',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Hero(
                  tag: 'event_${event.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: IgnorePointer(
                      child: EventCard(
                        event: event,
                        onTap: null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Details',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(context, 'Title', event.title),
                        _buildInfoRow(context, 'Start', _formatDate(event.startDate, includeTime: true)),
                        _buildInfoRow(context, 'End', _formatDate(event.endDate, includeTime: true)),
                        if ((event.location ?? '').isNotEmpty)
                          _buildInfoRow(context, 'Location', event.location!),
                        if ((event.url ?? '').isNotEmpty)
                          _buildUrlRow(context, 'Link', event.url!),
                        if ((event.description).isNotEmpty)
                          _buildInfoRow(context, 'Notes', event.description),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editEvent(event),
                        icon: const Icon(CupertinoIcons.pencil),
                        label: const Text('Edit Event'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _confirmDelete,
                        icon: const Icon(CupertinoIcons.delete, color: Colors.white),
                        label: const Text('Delete', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
                          ),
                        ),
                      ),
                    ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
},
);
}

  Widget _buildInfoRow(BuildContext context, String label, String value) {
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

  Widget _buildUrlRow(BuildContext context, String label, String value) {
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
            child: GestureDetector(
              onTap: () => _launchUrl(value),
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, {bool includeTime = false}) {
    final format = includeTime ? DateFormat('MMM dd, yyyy • h:mm a') : DateFormat('MMM dd, yyyy');
    return format.format(date);
  }
}
