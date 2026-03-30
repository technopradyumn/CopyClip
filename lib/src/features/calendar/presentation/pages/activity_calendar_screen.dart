import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/widgets/dynamic_background.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/const/constant.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../clipboard/data/clipboard_model.dart';

class ActivityCalendarScreen extends StatefulWidget {
  const ActivityCalendarScreen({super.key});

  @override
  State<ActivityCalendarScreen> createState() => _ActivityCalendarScreenState();
}

class _ActivityCalendarScreenState extends State<ActivityCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final selectedEvents = _getActivityForDay(_selectedDay ?? DateTime.now());

    return GlassScaffold(
      title: 'Activity Overview',
      body: DynamicBackground(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Daily Activity Calendar',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCalendar(theme, onSurface),
              ),
            ),
            _buildActivityStats(selectedEvents, theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme, Color onSurface) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        eventLoader: _getActivityForDay,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
          leftChevronIcon: Icon(
            CupertinoIcons.left_chevron,
            color: onSurface,
            size: 20,
          ),
          rightChevronIcon: Icon(
            CupertinoIcons.right_chevron,
            color: onSurface,
            size: 20,
          ),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayDecoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          defaultTextStyle: TextStyle(color: onSurface.withOpacity(0.8)),
          weekendTextStyle: TextStyle(color: onSurface.withOpacity(0.6)),
          outsideDaysVisible: false,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return null;
            return Positioned(
              bottom: 4,
              child: _buildActivityMarkers(events),
            );
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
      ),
    );
  }

  Widget _buildActivityMarkers(List<dynamic> events) {
    final colors = <Color>[];
    if (events.any((e) => e is Note)) colors.add(Colors.amber);
    if (events.any((e) => e is Todo)) colors.add(Colors.green);
    if (events.any((e) => e is Expense)) colors.add(Colors.red);
    if (events.any((e) => e is JournalEntry)) colors.add(Colors.blue);
    if (events.any((e) => e is ClipboardItem)) colors.add(Colors.purple);

    if (colors.isEmpty) return const SizedBox();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colors.take(3).map((c) => Container(
        margin: const EdgeInsets.only(left: 1),
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
        ),
      )).toList(),
    );
  }

  Widget _buildActivityStats(List<dynamic> events, ThemeData theme) {
    final Map<String, int> counts = {
      '📝 Notes': events.where((e) => e is Note).length,
      '✅ Todos': events.where((e) => e is Todo).length,
      '💰 Expenses': events.where((e) => e is Expense).length,
      '📔 Journal': events.where((e) => e is JournalEntry).length,
      '📋 Clips': events.where((e) => e is ClipboardItem).length,
    };

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: counts.entries.map((entry) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                entry.key,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${entry.value}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  List<dynamic> _getActivityForDay(DateTime day) {
    final dateKey = DateFormat('yyyy-MM-dd').format(day);
    final events = <dynamic>[];

    void addFromBox(String boxName, bool Function(dynamic) filter) {
      try {
        if (Hive.isBoxOpen(boxName)) {
          final box = Hive.box(boxName);
          events.addAll(box.values.where(filter));
        }
      } catch (e) {
        debugPrint('ActivityCalendar Error: $e');
      }
    }

    addFromBox('notes_box', (dynamic e) {
      if (e is Note && !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.updatedAt) == dateKey) return true;
      return false;
    });
    
    addFromBox('todos_box', (dynamic e) {
      if (e is Todo && !e.isDeleted && e.dueDate != null && DateFormat('yyyy-MM-dd').format(e.dueDate!) == dateKey) return true;
      return false;
    });
    
    addFromBox('expenses_box', (dynamic e) {
      if (e is Expense && !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.date) == dateKey) return true;
      return false;
    });
    
    addFromBox('journal_box', (dynamic e) {
      if (e is JournalEntry && !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.date) == dateKey) return true;
      return false;
    });
    
    addFromBox('clipboard_box', (dynamic e) {
      if (e is ClipboardItem && !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.createdAt) == dateKey) return true;
      return false;
    });

    return events;
  }
}

