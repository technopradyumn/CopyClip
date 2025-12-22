import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';

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

    void addFromBox<T>(String boxName, bool Function(T) filter) {
      if (Hive.isBoxOpen(boxName)) {
        events.addAll(Hive.box<T>(boxName).values.where(filter));
      }
    }

    addFromBox<Note>('notes_box', (e) => !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.updatedAt) == dateKey);
    addFromBox<Todo>('todos_box', (e) => !e.isDeleted && e.dueDate != null && DateFormat('yyyy-MM-dd').format(e.dueDate!) == dateKey);
    addFromBox<Expense>('expenses_box', (e) => !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.date) == dateKey);
    addFromBox<JournalEntry>('journal_box', (e) => !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.date) == dateKey);
    addFromBox<ClipboardItem>('clipboard_box', (e) => !e.isDeleted && DateFormat('yyyy-MM-dd').format(e.createdAt) == dateKey);

    return events;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final selectedEvents = _getEventsForDay(_selectedDay ?? DateTime.now());

    return GlassScaffold(
      showBackArrow: false,
      title: null,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 54),
            _buildHeader(theme, onSurface),
            const SizedBox(height: 10),
            _buildCalendarCard(theme, onSurface),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(theme, "DATA DISTRIBUTION"),
                  const SizedBox(height: 12),
                  _buildAnimatedBarGraph(selectedEvents, onSurface),

                  const SizedBox(height: 24),
                  _sectionLabel(theme, "TASK PROGRESS"),
                  const SizedBox(height: 12),
                  _buildTodoProgressSection(selectedEvents, theme),

                  const SizedBox(height: 24),
                  _sectionLabel(theme, "QUICK STATS"),
                  const SizedBox(height: 12),
                  _buildAnalyticsGrid(selectedEvents, onSurface, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBarGraph(List<dynamic> events, Color onSurface) {
    final Map<String, int> counts = {
      'Notes': events.whereType<Note>().length,
      'Finance': events.whereType<Expense>().length,
      'Journal': events.whereType<JournalEntry>().length,
      'Clips': events.whereType<ClipboardItem>().length,
    };

    final int maxCount = counts.values.isEmpty ? 0 : counts.values.reduce((a, b) => a > b ? a : b);
    const double chartHeight = 100;

    return GlassContainer(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: counts.entries.map((entry) {
          final double ratio = (maxCount == 0) ? 0 : (entry.value / maxCount);
          return Column(
            children: [
              TweenAnimationBuilder<double>(
                key: ValueKey('${_selectedDay}_${entry.key}'),
                tween: Tween(begin: 0, end: ratio * chartHeight),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Container(
                    width: 16,
                    height: value.clamp(4.0, chartHeight),
                    decoration: BoxDecoration(
                      color: _getColorForType(entry.key),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: _getColorForType(entry.key).withOpacity(0.3),
                          blurRadius: 6,
                        )
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                entry.key,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: onSurface.withOpacity(0.6)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTodoProgressSection(List<dynamic> events, ThemeData theme) {
    final todos = events.whereType<Todo>().toList();
    final completed = todos.where((t) => t.isDone).length;
    final double progress = todos.isEmpty ? 0 : completed / todos.length;

    return GlassContainer(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            height: 55,
            width: 55,
            child: Stack(
              children: [
                Center(
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(_selectedDay),
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 6,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      );
                    },
                  ),
                ),
                Center(child: Text("${(progress * 100).toInt()}%", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Task Completion", style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontSize: 14)),
                Text("$completed of ${todos.length} items done", style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Notes': return Colors.amberAccent;
      case 'Finance': return Colors.redAccent;
      case 'Journal': return Colors.blueAccent;
      case 'Clips': return Colors.purpleAccent;
      default: return Colors.greenAccent;
    }
  }

  Widget _buildHeader(ThemeData theme, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: onSurface, size: 20), onPressed: () => context.pop()),
          const Hero(tag: 'calendar_icon', child: Icon(Icons.calendar_month_rounded, size: 26, color: Colors.orangeAccent)),
          const SizedBox(width: 10),
          Text("Calendar", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: onSurface)),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(ThemeData theme, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.only(bottom: 12),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          rowHeight: 48,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getEventsForDay,
          calendarFormat: CalendarFormat.month,
          headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true, headerPadding: EdgeInsets.symmetric(vertical: 8)),
          calendarStyle: CalendarStyle(
            // Styles for the SELECTED day
            selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)]
            ),
            selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),

            // Styles for TODAY (Resolved visibility issue)
            todayDecoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.15), // Subtle fill
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5), width: 1.5), // Clear primary border
            ),
            todayTextStyle: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),

            defaultTextStyle: TextStyle(color: onSurface),
            weekendTextStyle: TextStyle(color: onSurface.withOpacity(0.6)),
            outsideDaysVisible: false,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return const SizedBox();
              return Positioned(bottom: 4, child: _buildAllFiveMarkers(events));
            },
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() { _selectedDay = selectedDay; _focusedDay = focusedDay; });
            Future.delayed(const Duration(milliseconds: 350), () {
              final results = _mapEventsToResults(_getEventsForDay(selectedDay));
              context.push(AppRouter.dateDetail, extra: {'date': selectedDay, 'items': results});
            });
          },
        ),
      ),
    );
  }

  Widget _buildAllFiveMarkers(List<dynamic> events) {
    final colors = <Color>[];
    if (events.any((e) => e is Note)) colors.add(Colors.amberAccent);
    if (events.any((e) => e is Todo)) colors.add(Colors.greenAccent);
    if (events.any((e) => e is Expense)) colors.add(Colors.redAccent);
    if (events.any((e) => e is JournalEntry)) colors.add(Colors.blueAccent);
    if (events.any((e) => e is ClipboardItem)) colors.add(Colors.purpleAccent);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colors.map((c) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.0),
          width: 5, height: 5,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle)
      )).toList(),
    );
  }

  Widget _buildAnalyticsGrid(List<dynamic> events, Color onSurface, ThemeData theme) {
    final expenses = events.whereType<Expense>().fold(0.0, (sum, e) => sum + (e.isIncome ? 0 : e.amount));
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: [
        _statTile("Daily Activity", events.length.toString(), theme.colorScheme.primary, onSurface, 0.46),
        _statTile("Expenses", "\$${expenses.toStringAsFixed(0)}", Colors.redAccent, onSurface, 0.46),
      ],
    );
  }

  Widget _statTile(String label, String value, Color color, Color onSurface, double widthFactor) {
    final screenWidth = MediaQuery.of(context).size.width - 48;
    return GlassContainer(
      width: screenWidth * widthFactor,
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: onSurface)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: onSurface.withOpacity(0.5), letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _sectionLabel(ThemeData theme, String text) {
    return Text(text, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2));
  }

  List<GlobalSearchResult> _mapEventsToResults(List<dynamic> events) {
    return events.map((e) {
      if (e is Note) return GlobalSearchResult(id: e.id, title: e.title, subtitle: e.content, type: 'Note', route: AppRouter.noteEdit, argument: e);
      if (e is Todo) return GlobalSearchResult(id: e.id, title: e.task, subtitle: e.isDone ? "Completed" : "Pending", type: 'Todo', route: AppRouter.todoEdit, argument: e, isCompleted: e.isDone);
      if (e is Expense) return GlobalSearchResult(id: e.id, title: e.title, subtitle: "${e.currency}${e.amount}", type: 'Expense', route: AppRouter.expenseEdit, argument: e);
      if (e is JournalEntry) return GlobalSearchResult(id: e.id, title: e.title, subtitle: e.content, type: 'Journal', route: AppRouter.journalEdit, argument: e);
      return GlobalSearchResult(id: e.id, title: e.content, subtitle: "Clipboard", type: 'Clipboard', route: AppRouter.clipboardEdit, argument: e);
    }).toList();
  }
}