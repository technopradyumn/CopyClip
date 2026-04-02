import 'package:flutter/material.dart';
import '../designs/event_design_registry.dart';
import '../../data/calendar_event_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CalendarDesignPickerSheet extends StatelessWidget {
  final String? currentDesignId;
  final void Function(String)? onDesignSelected;
  final CalendarEvent? event;

  const CalendarDesignPickerSheet({
    super.key,
    this.currentDesignId,
    this.onDesignSelected,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final designs = EventDesignRegistry.all;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Text(
                  "Event Design",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: designs.length,
              itemBuilder: (context, index) {
                final pattern = designs[index];
                final isSelected = (currentDesignId ?? event?.designPatternId ?? '') == pattern.id;
                return GestureDetector(
                    onTap: () async {
                      if (onDesignSelected != null) {
                        onDesignSelected!(pattern.id);
                      } else if (event != null) {
                        final box = Hive.box<CalendarEvent>('calendar_events_box');
                        final evt = box.get(event!.id);
                        if (evt != null) {
                          evt.designPatternId = pattern.id;
                          await evt.save();
                        }
                      }
                      if (context.mounted) Navigator.pop(context, pattern.id);
                    },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? pattern.primaryColor
                        : pattern.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                          ? theme.colorScheme.primary 
                          : Colors.transparent,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        CustomPaint(
                          painter: pattern.painter,
                          size: Size.infinite,
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void showCalendarDesignPicker(BuildContext context, CalendarEvent event) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CalendarDesignPickerSheet(event: event),
  );
}
