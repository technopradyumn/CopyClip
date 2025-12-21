import 'dart:ui';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    List<dynamic> events = [];
    final dateKey = DateFormat('yyyy-MM-dd').format(day);

    events.addAll(Hive.box<Note>('notes_box').values.where(
            (e) => DateFormat('yyyy-MM-dd').format(e.updatedAt) == dateKey));
    events.addAll(Hive.box<Todo>('todos_box').values.where(
            (e) => e.dueDate != null && DateFormat('yyyy-MM-dd').format(e.dueDate!) == dateKey));
    events.addAll(Hive.box<Expense>('expenses_box').values.where(
            (e) => DateFormat('yyyy-MM-dd').format(e.date) == dateKey));
    events.addAll(Hive.box<JournalEntry>('journal_box').values.where(
            (e) => DateFormat('yyyy-MM-dd').format(e.date) == dateKey));
    events.addAll(Hive.box<ClipboardItem>('clipboard_box').values.where(
            (e) => DateFormat('yyyy-MM-dd').format(e.createdAt) == dateKey));

    return events;
  }

  List<GlobalSearchResult> _mapEventsToResults(List<dynamic> events) {
    return events.map((e) {
      if (e is Note) {
        return GlobalSearchResult(id: e.id,
            title: e.title,
            subtitle: e.content,
            type: 'Note',
            route: AppRouter.noteEdit,
            argument: e);
      } else if (e is Todo) {
        return GlobalSearchResult(id: e.id,
            title: e.task,
            subtitle: e.isDone ? "Completed" : "Pending",
            type: 'Todo',
            route: AppRouter.todoEdit,
            argument: e,
            isCompleted: e.isDone);
      } else if (e is Expense) {
        return GlobalSearchResult(id: e.id,
            title: e.title,
            subtitle: "${e.isIncome ? '+' : '-'} ${e.currency}${e.amount}",
            type: 'Expense',
            route: AppRouter.expenseEdit,
            argument: e);
      } else if (e is ClipboardItem) {
        return GlobalSearchResult(
            id: e.id,
            title: e.content,
            subtitle: "Copied at ${DateFormat('HH:mm').format(e.createdAt)}",
            type: 'Clipboard',
            route: AppRouter.clipboardEdit,
            argument: e
        );
      } else {
        final j = e as JournalEntry;
        return GlobalSearchResult(id: j.id,
            title: j.title,
            subtitle: j.content,
            type: 'Journal',
            route: AppRouter.journalEdit,
            argument: j);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final iconTheme = Theme.of(context).iconTheme;
    
    return GlassScaffold(
      showBackArrow: false,
      title: null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  // Rely on theme color
                  icon: Icon(Icons.arrow_back_ios_new, color: iconTheme.color),
                  onPressed: () => context.pop(),
                ),
                // Hero 1: Shared Icon tag with Dashboard and Detail
                const Hero(
                    tag: 'calendar_icon',
                    child: Icon(Icons.calendar_today_outlined, size: 32, color: Colors.orangeAccent)
                ),
                const SizedBox(width: 12),
                // Hero 2: Shared Title tag with Dashboard
                Hero(
                  tag: 'calendar_title',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                        "Calendar",
                        // Use theme titleLarge style
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w600)
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassContainer(
              padding: const EdgeInsets.only(bottom: 10),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: _getEventsForDay,
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,

                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: false,
                  leftChevronMargin: const EdgeInsets.only(left: 8),
                  rightChevronMargin: const EdgeInsets.only(right: 8),
                  titleTextFormatter: (date, locale) =>
                      DateFormat('MMMM yyyy').format(date),
                  titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                  // Use theme icon color
                  leftChevronIcon: Icon(Icons.chevron_left, color: iconTheme.color),
                  rightChevronIcon: Icon(Icons.chevron_right, color: iconTheme.color),
                ),

                daysOfWeekStyle: DaysOfWeekStyle(
                  // Use theme bodyMedium/Small color
                  weekdayStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: onSurfaceColor.withOpacity(0.54)),
                  weekendStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: onSurfaceColor.withOpacity(0.54)),
                ),

                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,

                  defaultTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: onSurfaceColor,
                    fontWeight: FontWeight.w500,
                  ),

                  weekendTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: onSurfaceColor.withOpacity(0.8),
                  ),

                  todayDecoration: BoxDecoration(
                    // Use theme surface with opacity
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.16),
                    shape: BoxShape.circle,
                  ),

                  selectedDecoration: BoxDecoration(
                    color: primaryColor, // Use theme primary color
                    shape: BoxShape.circle,
                  ),

                  markerDecoration: BoxDecoration(
                    color: Colors.orangeAccent, // Keeping marker color for now, as it relates to specific event types
                    shape: BoxShape.circle,
                  ),

                  markersMaxCount: 3,
                  markerSize: 5,
                  markersAlignment: Alignment.bottomCenter,
                ),

                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isEmpty) return const SizedBox();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildMarkers(events),
                      ),
                    );
                  },
                ),

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  final results = _mapEventsToResults(_getEventsForDay(selectedDay));

                  context.push(
                    AppRouter.dateDetail,
                    extra: {
                      'date': selectedDay,
                      'items': results,
                    },
                  );
                },
              ),
            ),
          ),
          const Expanded(child: Center(child: Text("Tap a date to view details", style: TextStyle(color: Colors.white24)))),
        ],
      ),
    );
  }

  List<Widget> _buildMarkers(List<dynamic> events) {
    Set<String> types = {};
    for (var e in events) {
      if (e is Note) types.add('Note');
      if (e is Todo) types.add('Todo');
      if (e is Expense) types.add('Expense');
      if (e is JournalEntry) types.add('Journal');
      if (e is ClipboardItem) types.add('Clipboard');
    }
    return types.map((type) {
      Color color;
      final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
      switch (type) {
        case 'Note': color = Colors.amberAccent; break;
        case 'Todo': color = Colors.greenAccent; break;
        case 'Expense': color = Colors.redAccent; break;
        case 'Journal': color = Colors.blueAccent; break;
        case 'Clipboard': color = Colors.purpleAccent; break;
        default: color = onSurfaceColor;
      }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        width: 6, height: 6,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
    }).toList();
  }
}