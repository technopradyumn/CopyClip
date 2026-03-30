import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/const/constant.dart';
import '../../data/calendar_event_model.dart';
import '../widgets/event_card.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      title: 'All Events',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.calendarEventEdit),
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(CupertinoIcons.add, color: Colors.white),
        label: const Text('New Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ValueListenableBuilder<Box<CalendarEvent>>(
        valueListenable: Hive.box<CalendarEvent>('calendar_events_box').listenable(),
        builder: (context, box, _) {
          final allEvents = box.values.where((e) => !e.isDeleted).toList();
          allEvents.sort((a, b) => b.startDate.compareTo(a.startDate));

          if (allEvents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.calendar_badge_plus,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No events yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first event',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            itemCount: allEvents.length,
            itemBuilder: (context, index) {
              final event = allEvents[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EventCard(
                  key: ValueKey(event.id),
                  event: event,
                  onTap: () => context.push(AppRouter.calendarEventDetail, extra: event),
                  onDelete: () {
                    setState(() {
                      event.isDeleted = true;
                      event.save();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Event deleted'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

