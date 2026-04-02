import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/widgets/dynamic_background.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/gamification_service.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../data/calendar_event_model.dart';
import '../../presentation/widgets/event_card.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:copyclip/src/features/gamification/presentation/widgets/medal_widget.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../widgets/calendar_design_picker_sheet.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import '../../services/event_notification_service.dart';
import 'package:table_calendar/table_calendar.dart' show isSameDay; // Ensure we can still access it if needed, but we'll use our own

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedDesignId = 'min_1';

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _initData();
  }

  Future<void> _initData() async {
    final settingsBox = Hive.box('settings');
    final savedDesign = settingsBox.get('calendar_card_design', defaultValue: 'min_1');
    if (mounted) setState(() => _selectedDesignId = savedDesign);

    await LazyBoxLoader.loadAllBoxes();
    if (mounted) {
      setState(() {});
      Hive.box('notes_box').listenable().addListener(_onDataChanged);
      Hive.box('todos_box').listenable().addListener(_onDataChanged);
      Hive.box('expenses_box').listenable().addListener(_onDataChanged);
      Hive.box('journal_box').listenable().addListener(_onDataChanged);
      Hive.box<CalendarEvent>('calendar_events_box').listenable().addListener(_onDataChanged);
    }
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // Clean up listeners
    if (Hive.isBoxOpen('notes_box')) Hive.box('notes_box').listenable().removeListener(_onDataChanged);
    if (Hive.isBoxOpen('todos_box')) Hive.box('todos_box').listenable().removeListener(_onDataChanged);
    if (Hive.isBoxOpen('expenses_box')) Hive.box('expenses_box').listenable().removeListener(_onDataChanged);
    if (Hive.isBoxOpen('journal_box')) Hive.box('journal_box').listenable().removeListener(_onDataChanged);
    if (Hive.isBoxOpen('calendar_events_box')) Hive.box<CalendarEvent>('calendar_events_box').listenable().removeListener(_onDataChanged);
    super.dispose();
  }

  // --- DATA FETCHING ---
  bool _isSameDayCustom(DateTime a, DateTime b) {
    final localA = a.toLocal();
    // b from TableCalendar is UTC midnight — compare date components only
    return localA.year == b.year &&
        localA.month == b.month &&
        localA.day == b.day;
  }

  List<dynamic> _getActivityForDay(DateTime day) {
    if (!mounted) return [];
    final List<dynamic> events = [];

    // Helper: safely read from a typed Hive box
    void addFromTypedBox<T>(String boxName, bool Function(T) filter) {
      try {
        if (!Hive.isBoxOpen(boxName)) return;
        final box = Hive.box<T>(boxName);
        events.addAll(box.values.where((e) => filter(e)));
      } catch (e) {
        debugPrint("ActivityCalendar: Failed to access $boxName: $e");
      }
    }

    addFromTypedBox<Note>('notes_box', (e) {
      if (e.isDeleted) return false;
      return _isSameDayCustom(e.updatedAt, day);
    });
    addFromTypedBox<Todo>('todos_box', (e) {
      if (e.isDeleted || e.dueDate == null) return false;
      return _isSameDayCustom(e.dueDate!, day);
    });
    addFromTypedBox<Expense>('expenses_box', (e) {
      if (e.isDeleted) return false;
      return _isSameDayCustom(e.date, day);
    });
    addFromTypedBox<JournalEntry>('journal_box', (e) {
      if (e.isDeleted) return false;
      return _isSameDayCustom(e.date, day);
    });
    addFromTypedBox<ClipboardItem>('clipboard_box', (e) {
      if (e.isDeleted) return false;
      return _isSameDayCustom(e.createdAt, day);
    });
    addFromTypedBox<CalendarEvent>('calendar_events_box', (e) {
      if (e.isDeleted) return false;
      return _isSameDayCustom(e.startDate, day) || _isSameDayCustom(e.endDate, day);
    });

    return events;
  }

  // --- UI BUILDERS ---
  List<CalendarEvent> _getRecentEvents([int limit = 5]) {
    if (!Hive.isBoxOpen('calendar_events_box')) return [];
    final box = Hive.box<CalendarEvent>('calendar_events_box');
    final events = box.values.where((e) => !e.isDeleted).toList();
    events.sort((a, b) => b.startDate.compareTo(a.startDate));
    return events.take(limit).toList();
  }

  Widget _buildAllEventsTile(ThemeData theme, Color onSurface) {
    final recentEvents = _getRecentEvents(3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(theme, 'All Events'),
        const SizedBox(height: 12),
        if (recentEvents.isEmpty)
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            ),
            child: Center(
              child: Text(
                'No events yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: onSurface.withOpacity(0.5),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentEvents.length + 1,
              itemBuilder: (context, index) {
                if (index < recentEvents.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 280,
                      child: EventCard(
                        event: recentEvents[index],
                        onTap: () => context.push('/calendar/detail/${recentEvents[index].id}'),
                        onDelete: () => _deleteEvent(recentEvents[index]),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => context.push(AppRouter.allEvents),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.chevron_right_circle,
                            color: theme.colorScheme.primary,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'View All',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    // Get events for the currently selected day
    final selectedEvents = _getActivityForDay(_selectedDay ?? DateTime.now());

    return GlassScaffold(
      showBackArrow: false,
      title: null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.calendarEventEdit, extra: null),
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(CupertinoIcons.add, color: Colors.white),
        label: const Text('New Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(CupertinoIcons.ellipsis, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          onSelected: (value) {
            if (value == 'design') {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => CalendarDesignPickerSheet(
                  currentDesignId: _selectedDesignId,
                  onDesignSelected: (designId) {
                    final settingsBox = Hive.box('settings');
                    settingsBox.put('calendar_card_design', designId);
                    if (mounted) setState(() => _selectedDesignId = designId);
                  },
                ),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'design',
              child: Row(
                children: [
                  Icon(Icons.palette, size: 20),
                  SizedBox(width: 12),
                  Text('Change Card Design'),
                ],
              ),
            ),
          ],
        ),
      ],
      body: DynamicBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildHeader(theme, onSurface),
              const SizedBox(height: 8),
              _buildXpIndicator(theme),
              const SizedBox(height: 16),
              
              // All Events tile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                child: _buildAllEventsTile(theme, onSurface),
              ),
              
              const SizedBox(height: 10),
              _buildCalendarCard(theme, onSurface),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel(
                      theme,
                      AppLocalizations.of(context)!.dataDistribution,
                    ),
                    const SizedBox(height: 12),
                    // ✅ Optimized Bar Graph
                    _buildAnimatedBarGraph(selectedEvents, onSurface, theme),

                    const SizedBox(height: 24),
                    _sectionLabel(
                      theme,
                      AppLocalizations.of(context)!.taskProgress,
                    ),
                    const SizedBox(height: 12),
                    // ✅ Optimized Progress Section
                    _buildTodoProgressSection(selectedEvents, theme),

                    const SizedBox(height: 24),
                    _sectionLabel(
                      theme,
                      AppLocalizations.of(context)!.quickStats,
                    ),
                    const SizedBox(height: 12),
                    // ✅ Optimized Stats Grid
                    _buildAnalyticsGrid(selectedEvents, onSurface, theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color onSurface) {
    return SeamlessHeader(
      title: AppLocalizations.of(context)!.calendarScreenTitle,
      subtitle: AppLocalizations.of(context)!.upcomingEvents,
      icon: CupertinoIcons.calendar,
      iconColor: Colors.orangeAccent,
      heroTagPrefix: 'calendar',
    );
  }

  Widget _buildXpIndicator(ThemeData theme) {
    return Consumer<GamificationService>(
      builder: (context, service, _) {
        final model = service.model;
        final medal = GamificationService.getMedalTier(model.level);
        return GestureDetector(
          onTap: () => context.push(AppRouter.xpDetail),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                  width: AppConstants.borderWidth,
                ),
              ),
              child: Row(
                children: [
                  MedalWidget(level: model.level, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.level} ${model.level} ($medal)',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: model.progressToNextLevel,
                            minHeight: 5,
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${model.totalXp} XP',
                        style: theme.textTheme.bodyMedium?.copyWith(

                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '🔥 ${model.streak}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarCard(ThemeData theme, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(
            alpha: 0.6,
          ), // Fast transparency
          borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: AppConstants.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          rowHeight: 48,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getActivityForDay,
          calendarFormat: CalendarFormat.month,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            headerPadding: const EdgeInsets.symmetric(vertical: 8),
            titleTextStyle: TextStyle(
              fontSize: 16,
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
            // Selected Day
            selectedDecoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),

            // Today
            todayDecoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            todayTextStyle: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),

            defaultTextStyle: TextStyle(color: onSurface),
            weekendTextStyle: TextStyle(
              color: onSurface.withValues(alpha: 0.6),
            ),
            outsideDaysVisible: false,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return const SizedBox();
              return Positioned(bottom: 6, child: _buildAllFiveMarkers(events));
            },
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            // Navigate to details after a short delay for visual feedback
            Future.delayed(const Duration(milliseconds: 250), () {
              final results = _mapEventsToResults(
                _getActivityForDay(selectedDay),
              );
              context.push(
                AppRouter.dateDetail,
                extra: {'date': selectedDay, 'items': results},
              );
            });
          },
        ),
      ),
    );
  }

  // ✅ High Performance Bar Graph Container
  Widget _buildAnimatedBarGraph(
    List<dynamic> events,
    Color onSurface,
    ThemeData theme,
  ) {
    final Map<String, int> counts = {
      'Events': events.whereType<CalendarEvent>().length,
      'Notes': events.whereType<Note>().length,
      'Todos': events.whereType<Todo>().length,
      'Finance': events.whereType<Expense>().length,
      'Journal': events.whereType<JournalEntry>().length,
      'Clips': events.whereType<ClipboardItem>().length,
    };

    final int maxCount = counts.values.isEmpty
        ? 0
        : counts.values.reduce((a, b) => a > b ? a : b);
    const double chartHeight = 100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
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
                    width: 18, // Slightly thicker bars
                    height: value.clamp(4.0, chartHeight),
                    decoration: BoxDecoration(
                      color: _getColorForType(entry.key),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ✅ High Performance Progress Card
  Widget _buildTodoProgressSection(List<dynamic> events, ThemeData theme) {
    final todos = events.whereType<Todo>().toList();
    final completed = todos.where((t) => t.isDone).length;
    final double progress = todos.isEmpty ? 0 : completed / todos.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
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
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                        strokeCap: StrokeCap.round,
                      );
                    },
                  ),
                ),
                Center(
                  child: Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.taskCompletion,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$completed of ${todos.length} items done",
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllFiveMarkers(List<dynamic> events) {
    final colors = <Color>[];
    if (events.any((e) => e is CalendarEvent)) colors.add(Colors.deepOrangeAccent); // Events
    if (events.any((e) => e is Note)) colors.add(Colors.amberAccent); // Notes
    if (events.any((e) => e is Todo)) colors.add(Colors.greenAccent); // Todos
    if (events.any((e) => e is Expense)) colors.add(Colors.redAccent); // Finance
    if (events.any((e) => e is JournalEntry)) colors.add(Colors.blueAccent); // Journal
    if (events.any((e) => e is ClipboardItem)) colors.add(Colors.purpleAccent); // Clips

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors
          .map(
            (c) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 7, // Increased from 5 to 7
              height: 7, // Increased from 5 to 7
              decoration: BoxDecoration(
                color: c, 
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAnalyticsGrid(
    List<dynamic> events,
    Color onSurface,
    ThemeData theme,
  ) {
    final expenseList = events.whereType<Expense>().toList();
    final expenses = expenseList.fold(
      0.0,
      (sum, e) => sum + (e.isIncome ? 0 : e.amount),
    );

    // Get the most common currency from the expenses, or default to '$'
    String currency = '\$';
    if (expenseList.isNotEmpty) {
      final currencyMap = <String, int>{};
      for (var expense in expenseList) {
        if (!expense.isIncome) {
          currencyMap[expense.currency] =
              (currencyMap[expense.currency] ?? 0) + 1;
        }
      }
      if (currencyMap.isNotEmpty) {
        currency = currencyMap.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
      }
    }

    return Row(
      children: [
        Expanded(
          child: _statTile(
            AppLocalizations.of(context)!.dailyActivity,
            events.length.toString(),
            theme.colorScheme.primary,
            onSurface,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statTile(
            AppLocalizations.of(context)!.expenses,
            "$currency${expenses.toStringAsFixed(0)}",
            Colors.redAccent,
            onSurface,
            theme,
          ),
        ),
      ],
    );
  }

  // ✅ High Performance Stat Tile
  Widget _statTile(
    String label,
    String value,
    Color color,
    Color onSurface,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.1),
          width: AppConstants.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: onSurface.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Events':
        return Colors.deepOrangeAccent;
      case 'Notes':
        return Colors.amberAccent;
      case 'Todos':
        return Colors.greenAccent;
      case 'Finance':
        return Colors.redAccent;
      case 'Journal':
        return Colors.blueAccent;
      case 'Clips':
        return Colors.purpleAccent;
      default:
        return Colors.greenAccent;
    }
  }

  List<GlobalSearchResult> _mapEventsToResults(List<dynamic> events) {
    return events.map((e) {
      if (e is Note) {
        return GlobalSearchResult(
          id: e.id,
          title: e.title,
          subtitle: e.content,
          type: 'Note',
          route: AppRouter.noteEdit,
          argument: e,
        );
      }
      if (e is Todo) {
        return GlobalSearchResult(
          id: e.id,
          title: e.task,
          subtitle: e.isDone ? "Completed" : "Pending",
          type: 'Todo',
          route: AppRouter.todoEdit,
          argument: e,
          isCompleted: e.isDone,
        );
      }
      if (e is Expense) {
        return GlobalSearchResult(
          id: e.id,
          title: e.title,
          subtitle: "${e.currency}${e.amount}",
          type: 'Expense',
          route: AppRouter.expenseEdit,
          argument: e,
        );
      }
      if (e is JournalEntry) {
        return GlobalSearchResult(
          id: e.id,
          title: e.title,
          subtitle: e.content,
          type: 'Journal',
          route: AppRouter.journalEdit,
          argument: e,
        );
      }
      if (e is CalendarEvent) {
        return GlobalSearchResult(
          id: e.id,
          title: e.title,
          subtitle: e.description.isNotEmpty ? e.description : "Event",
          type: 'Event',
          route: AppRouter.calendarEventEdit,
          argument: e,
        );
      }
      return GlobalSearchResult(
        id: e.id,
        title: e.content ?? "Clipboard",
        subtitle: "Clipboard",
        type: 'Clipboard',
        route: AppRouter.clipboardEdit,
        argument: e,
      );
    }).toList();
  }

  void _deleteEvent(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: AppLocalizations.of(context)!.deleteItemQuestion,
        content: AppLocalizations.of(context)!.deleteItemConfirmation,
        confirmText: AppLocalizations.of(context)!.delete,
        isDestructive: true,
        onConfirm: () async {
          try {
            event.isDeleted = true;
            await event.save();
            
            // ✅ NEW: Cancel notifications for the event
            await EventNotificationService.cancelNotifications(event);
            
            if (mounted) setState(() {});
          } catch (e) {
            debugPrint("Error deleting event: $e");
          }
          Navigator.pop(ctx);
        },
      ),
    );
  }
}
