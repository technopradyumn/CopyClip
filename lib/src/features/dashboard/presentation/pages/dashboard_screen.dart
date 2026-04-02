import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/services/interstitial_ad_service.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:copyclip/src/core/common_widgets/mascot_character.dart';
import 'package:copyclip/src/core/common_widgets/micro_animation.dart';
import 'package:copyclip/src/core/services/gamification_service.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../calendar/data/calendar_event_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../canvas/data/canvas_adapter.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_state.dart';
import 'package:copyclip/src/features/gamification/presentation/widgets/medal_widget.dart';
import '../widgets/aura_picker_sheet.dart';

class FeatureItem {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final String description;

  FeatureItem(
    this.id,
    this.title,
    this.icon,
    this.color,
    this.route,
    this.description,
  );
}

class GlobalSearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String route;
  final dynamic argument;
  final bool? isCompleted;

  GlobalSearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.route,
    this.argument,
    this.isCompleted,
  });
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _boxesOpened = false;
  List<String> _order = [];
  late AnimationController _settingsAnimationController;
  final InterstitialAdService _adService = InterstitialAdService();
  bool _showOnboarding = false;
  int _onboardingStep = 0;
  final PageController _onboardingController = PageController();

  late Map<String, FeatureItem> _features;

  late List<OnboardingContent> _onboardingData;

  // State for View Mode
  bool _isGridView = false;

  // Cached previews for performance
  final Map<String, String?> _previews = {};
  final Map<String, StreamSubscription?> _boxSubscriptions = {};

  @override
  void initState() {
    super.initState();
    _settingsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _initHive();
    _adService.loadAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initLocalizedData();
  }

  void _initLocalizedData() {
    final l10n = AppLocalizations.of(context)!;

    _features = {
      'notes': FeatureItem(
        'notes',
        l10n.notes,
        CupertinoIcons.doc_text,
        FeatureColors.notes,
        AppRouter.notes,
        l10n.featuresNotesDesc,
      ),
      'todos': FeatureItem(
        'todos',
        l10n.todos,
        CupertinoIcons.checkmark_circle,
        FeatureColors.todos,
        AppRouter.todos,
        l10n.featuresTodosDesc,
      ),
      'clipboard': FeatureItem(
        'clipboard',
        l10n.clipboard,
        CupertinoIcons.doc_on_clipboard,
        FeatureColors.clipboard,
        AppRouter.clipboard,
        l10n.featuresClipboardDesc,
      ),
      'journal': FeatureItem(
        'journal',
        l10n.journal,
        CupertinoIcons.book,
        FeatureColors.journal,
        AppRouter.journal,
        l10n.featuresJournalDesc,
      ),
      'expenses': FeatureItem(
        'expenses',
        l10n.expenses,
        CupertinoIcons.money_dollar,
        FeatureColors.expenses,
        AppRouter.expenses,
        l10n.featuresExpensesDesc,
      ),
      'calendar': FeatureItem(
        'calendar',
        l10n.calendar,
        CupertinoIcons.calendar,
        FeatureColors.calendar,
        AppRouter.calendar,
        l10n.featuresCalendarDesc,
      ),
      'canvas': FeatureItem(
        'canvas',
        l10n.canvas,
        CupertinoIcons.scribble,
        FeatureColors.canvas,
        AppRouter.canvas,
        l10n.featuresCanvasDesc,
      ),
      'social_post': FeatureItem(
        'social_post',
        l10n.featuresSocialPost,
        CupertinoIcons.share_up,
        FeatureColors.socialPost,
        AppRouter.socialPost,
        l10n.featuresSocialPostDesc,
      ),
'events': FeatureItem(
        'events',
        'Events',
        CupertinoIcons.calendar_today,
        const Color(0xFFAB47BC), // Distinct events purple
        AppRouter.allEvents,
        'View all your events',
      ),
    };

    _onboardingData = [
      OnboardingContent(
        title: l10n.welcomeTitle,
        description: l10n.welcomeDescription,
        icon: CupertinoIcons.square_grid_2x2,
        color: const Color(0xFF6C63FF),
      ),
      OnboardingContent(
        title: l10n.onboardingNotesTitle,
        description: l10n.onboardingNotesDesc,
        icon: CupertinoIcons.doc_text,
        color: FeatureColors.notes,
      ),
      OnboardingContent(
        title: l10n.onboardingTodosTitle,
        description: l10n.onboardingTodosDesc,
        icon: CupertinoIcons.checkmark_circle,
        color: FeatureColors.todos,
      ),
      OnboardingContent(
        title: l10n.onboardingExpensesTitle,
        description: l10n.onboardingExpensesDesc,
        icon: CupertinoIcons.money_dollar,
        color: FeatureColors.expenses,
      ),
      OnboardingContent(
        title: l10n.onboardingJournalTitle,
        description: l10n.onboardingJournalDesc,
        icon: CupertinoIcons.book,
        color: FeatureColors.journal,
      ),
      OnboardingContent(
        title: l10n.onboardingCalendarTitle,
        description: l10n.onboardingCalendarDesc,
        icon: CupertinoIcons.calendar,
        color: FeatureColors.calendar,
      ),
      OnboardingContent(
        title: l10n.onboardingClipboardTitle,
        description: l10n.onboardingClipboardDesc,
        icon: CupertinoIcons.doc_on_clipboard,
        color: FeatureColors.clipboard,
      ),
      OnboardingContent(
        title: l10n.onboardingCanvasTitle,
        description: l10n.onboardingCanvasDesc,
        icon: CupertinoIcons.scribble,
        color: FeatureColors.canvas,
      ),
    ];
  }



  @override
  void dispose() {
    _settingsAnimationController.dispose();
    _onboardingController.dispose();
    for (var sub in _boxSubscriptions.values) {
      sub?.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // _onboardingData initialization moved to didChangeDependencies
  // _adService.loadAd(); // Moved to initState

  Future<void> _initHive() async {
    if (!Hive.isBoxOpen('settings')) await Hive.openBox('settings');

    await Future.wait([
      if (!Hive.isBoxOpen('notes_box')) Hive.openBox<Note>('notes_box'),
      if (!Hive.isBoxOpen('todos_box')) Hive.openBox<Todo>('todos_box'),
      if (!Hive.isBoxOpen('journal_box'))
        Hive.openBox<JournalEntry>('journal_box'),
      if (!Hive.isBoxOpen('clipboard_box'))
        Hive.openBox<ClipboardItem>('clipboard_box'),
      if (!Hive.isBoxOpen('expenses_box'))
        Hive.openBox<Expense>('expenses_box'),
    ]);

    final settingsBox = Hive.box('settings');
    final savedOrder = settingsBox.get('dashboard_order', defaultValue: null);
    final hasSeenOnboarding = settingsBox.get(
      'has_seen_onboarding',
      defaultValue: false,
    );
    // Load view preference
    final savedIsGridView = settingsBox.get(
      'dashboard_is_grid',
      defaultValue: false,
    );

    if (mounted) {
      setState(() {
        if (savedOrder != null) {
          _order = List<String>.from(savedOrder);
          for (var key in _features.keys) {
            if (!_order.contains(key)) _order.add(key);
          }
        } else {
          _order = _features.keys.toList();
        }
        _boxesOpened = true;
        _showOnboarding = !hasSeenOnboarding;
        _isGridView = savedIsGridView;
      });

      // Initialize previews after boxes are opened
      _initPreviews();
    }
  }

  void _initPreviews() {
    _updatePreview('notes');
    _updatePreview('todos');
    _updatePreview('journal');
    _updatePreview('clipboard');
    _updatePreview('expenses');
    _updatePreview('events');

    // Setup listeners for real-time updates without re-sorting everything on every frame
    _boxSubscriptions['notes'] = Hive.box<Note>('notes_box').watch().listen((_) => _updatePreview('notes'));
    _boxSubscriptions['todos'] = Hive.box<Todo>('todos_box').watch().listen((_) => _updatePreview('todos'));
    _boxSubscriptions['journal'] = Hive.box<JournalEntry>('journal_box').watch().listen((_) => _updatePreview('journal'));
    _boxSubscriptions['clipboard'] = Hive.box<ClipboardItem>('clipboard_box').watch().listen((_) => _updatePreview('clipboard'));
    _boxSubscriptions['expenses'] = Hive.box<Expense>('expenses_box').watch().listen((_) => _updatePreview('expenses'));
    _boxSubscriptions['events'] = Hive.box<CalendarEvent>('calendar_events_box').watch().listen((_) => _updatePreview('events'));
  }

  void _updatePreview(String id) {
    if (!mounted) return;
    String? preview;
    switch (id) {
      case 'notes': preview = _getLatestNote(); break;
      case 'todos': preview = _getLatestTodo(); break;
      case 'journal': preview = _getLatestJournal(); break;
      case 'clipboard': 
        final clip = _getLatestClipboard();
        preview = clip != null ? _extractPlainText(clip.content) : null;
        break;
      case 'expenses': preview = _getExpensesSummary(); break;
      case 'events': preview = _getLatestEventPreview(); break;
    }
    setState(() => _previews[id] = preview);
  }

  void _saveViewPreference(bool isGrid) {
    Hive.box('settings').put('dashboard_is_grid', isGrid);
  }

  void _saveOrder() {
    Hive.box('settings').put('dashboard_order', _order);
  }

  // --- Helper to remove JSON formatting (Quill Deltas) ---
  String _extractPlainText(String content) {
    if (content.isEmpty) return "";
    try {
      // If it doesn't look like a JSON list, return it as is
      if (!content.trim().startsWith('[')) return content;

      final decoded = jsonDecode(content);
      if (decoded is List) {
        final buffer = StringBuffer();
        for (var item in decoded) {
          if (item is Map && item.containsKey('insert')) {
            buffer.write(item['insert']);
          }
        }
        return buffer.toString().trim();
      }
      return content;
    } catch (e) {
      // Not JSON, return original
      return content;
    }
  }

  String? _getLatestNote() {
    if (!Hive.isBoxOpen('notes_box')) return null;
    final box = Hive.box<Note>('notes_box');
    final notes = box.values.where((n) => !n.isDeleted).toList();
    if (notes.isEmpty) return null;
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final note = notes.first;
    // Extract plain text from title or content
    final title = _extractPlainText(note.title);
    if (title.isNotEmpty) return title;

    final content = _extractPlainText(note.content);
    return content.split('\n').first;
  }

  String? _getLatestTodo() {
    if (!Hive.isBoxOpen('todos_box')) return null;
    final box = Hive.box<Todo>('todos_box');
    final todos = box.values.where((t) => !t.isDeleted && !t.isDone).toList();
    if (todos.isEmpty) return null;
    todos.sort(
      (a, b) =>
          (b.dueDate ?? DateTime(2000)).compareTo(a.dueDate ?? DateTime(2000)),
    );
    return todos.first.task; // Todos usually plain text
  }

  String? _getLatestJournal() {
    if (!Hive.isBoxOpen('journal_box')) return null;
    final box = Hive.box<JournalEntry>('journal_box');
    final entries = box.values.where((j) => !j.isDeleted).toList();
    if (entries.isEmpty) return null;
    entries.sort((a, b) => b.date.compareTo(a.date));
    // Clean JSON content
    final plainText = _extractPlainText(entries.first.content);
    return plainText.split('\n').first;
  }

  ClipboardItem? _getLatestClipboard() {
    if (!Hive.isBoxOpen('clipboard_box')) return null;
    final box = Hive.box<ClipboardItem>('clipboard_box');
    final items = box.values.where((c) => !c.isDeleted).toList();
    if (items.isEmpty) return null;
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items.first;
  }

  String? _getExpensesSummary() {
    if (!Hive.isBoxOpen('expenses_box')) return null;
    final box = Hive.box<Expense>('expenses_box');
    final now = DateTime.now();
    final thisMonth = box.values
        .where(
          (e) =>
              !e.isDeleted &&
              e.date.year == now.year &&
              e.date.month == now.month,
        )
        .toList();
    if (thisMonth.isEmpty)
      return AppLocalizations.of(context)!.noTransactionsMonth;
    final count = thisMonth.length;
    return AppLocalizations.of(context)!.transactionsThisMonth(count);
  }

  CalendarEvent? _getLatestEvent() {
    if (!Hive.isBoxOpen('calendar_events_box')) return null;
    final box = Hive.box<CalendarEvent>('calendar_events_box');
    final events = box.values.where((e) => !e.isDeleted).toList();
    if (events.isEmpty) return null;
    events.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return events.first;
  }

  String? _getLatestEventPreview() {
    final event = _getLatestEvent();
    if (event == null) return null;
    final format = DateFormat('MMM d, h:mm a');
    return '${event.title} • ${format.format(event.startDate)}';
  }

  void _completeOnboarding() {
    Hive.box('settings').put('has_seen_onboarding', true);
    setState(() => _showOnboarding = false);
  }





  Widget _buildListTile(int index, ThemeData theme) {
    if (index >= _order.length) return const SizedBox.shrink();
    final String id = _order[index];
    final FeatureItem? item = _features[id];
    if (item == null) return const SizedBox.shrink();

    final Color baseColor = item.color;

    final String? preview = _previews[id];

    return _KeepAliveTile(
      key: ValueKey(id),
      child: MicroAnimation(
        type: AnimationType.slide,
        delay: Duration(milliseconds: index * 50),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.08),
              width: AppConstants.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: baseColor.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
              onTap: () {
                if (id == 'calendar') {
                  final isPremium = context.read<PremiumBloc>().state.isPremium;
                  _adService.showAd(() {
                    context.push(item.route);
                  }, isPremium: isPremium);
                } else {
                  context.push(item.route);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Hero(
                      tag: '${id}_icon',
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              baseColor.withValues(alpha: 0.8),
                              baseColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppConstants.cornerRadius * 0.75,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: baseColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: '${id}_title',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                item.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            preview ?? item.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(id, baseColor, theme),
                    const SizedBox(width: 4),
                    ReorderableDragStartListener(
                      index: index,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        child: Icon(
                          CupertinoIcons.bars,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String id, Color baseColor, ThemeData theme) {
    final style = IconButton.styleFrom(
      backgroundColor: baseColor.withValues(alpha: 0.1),
      highlightColor: baseColor.withValues(alpha: 0.2),
      padding: const EdgeInsets.all(8),
      minimumSize: const Size(36, 36),
    );

    switch (id) {
      case 'clipboard':
        final clipItem = _getLatestClipboard();
        return IconButton(
          style: style,
          icon: Icon(CupertinoIcons.doc_on_doc, color: baseColor, size: 20),
          onPressed: clipItem != null
              ? () {
                  // Clean text before copying
                  final cleanText = _extractPlainText(clipItem.content);
                  Clipboard.setData(ClipboardData(text: cleanText));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: baseColor.withValues(alpha: 0.9),
                      content: Row(
                        children: [
                          const MascotCharacter(
                            size: 36,
                            state: MascotState.happy,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Copied to clipboard!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              : null,
        );
      case 'notes':
      case 'todos':
      case 'journal':
      case 'canvas':
      case 'expenses':
      case 'events':
        return IconButton(
          style: style,
          icon: Icon(CupertinoIcons.add, color: baseColor, size: 20),
          onPressed: () {
            switch (id) {
              case 'notes':
                context.push(AppRouter.noteEdit);
                break;
              case 'todos':
                context.push(AppRouter.todoEdit);
                break;
              case 'journal':
                context.push(AppRouter.journalEdit);
                break;
              case 'canvas':
                final rootFolders = CanvasDatabase().getRootFolders();
                final defaultFolderId = rootFolders.isEmpty
                    ? 'default'
                    : rootFolders.first.id;
                context.push(
                  AppRouter.canvasEdit,
                  extra: {'folderId': defaultFolderId},
                );
                break;
              case 'expenses':
                context.push(AppRouter.expenseEdit);
                break;
              case 'events':
                context.push(AppRouter.calendarEventEdit);
                break;
            }
          },
        );
      default:
        return const SizedBox(width: 40);
    }
  }

  // --- Grid Tile Builder ---
  Widget _buildGridTile(int index, ThemeData theme) {
    if (index >= _order.length) return const SizedBox.shrink();
    final String id = _order[index];
    final FeatureItem? item = _features[id];
    if (item == null) return const SizedBox.shrink();

    final Color baseColor = item.color;

    final String? preview = _previews[id];

    return _KeepAliveTile(
      key: ValueKey(id),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Dynamic sizing for grid content
          final isSmall = constraints.maxWidth < 150;

          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.08),
                width: AppConstants.borderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: baseColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
                // Fix: Ensure scrolling works even when touching items
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(baseColor.withValues(alpha: 0.05)),
                onTap: () {
                  if (id == 'calendar') {
                    final isPremium = context
                        .read<PremiumBloc>()
                        .state
                        .isPremium;
                    _adService.showAd(() {
                      context.push(item.route);
                    }, isPremium: isPremium);
                  } else {
                    context.push(item.route);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: '${id}_icon',
                        child: Container(
                          width: isSmall ? 40 : 52,
                          height: isSmall ? 40 : 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                baseColor.withValues(alpha: 0.8),
                                baseColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.cornerRadius * 0.75,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: baseColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            item.icon,
                            color: Colors.white,
                            size: isSmall ? 20 : 26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: '${id}_title',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                item.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmall ? 13 : 15,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          // Premium Tag for Calendar
                          if (id == 'calendar') ...[
                            SizedBox(width: 4),
                            BlocBuilder<PremiumBloc, PremiumState>(
                              builder: (context, state) {
                                if (!state.isPremium) {
                                  return Icon(
                                    CupertinoIcons.star_fill,
                                    color: Colors.amber,
                                    size: 14,
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ],
                        ],
                      ),
                      if (!isSmall && preview != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_showOnboarding) {
      return _buildOnboardingScreen();
    }

    return GlassScaffold(
      leading: Padding(
        padding: EdgeInsets.only(left: 16),
        child: Image.asset('assets/logo/copyclip_logo.png'),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dashboard",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.overview,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isGridView
                ? CupertinoIcons.list_bullet
                : CupertinoIcons.square_grid_2x2,
            color: theme.colorScheme.primary,
          ),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
            _saveViewPreference(_isGridView);
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            highlightColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
          icon: Icon(CupertinoIcons.search, color: theme.colorScheme.primary),
          onPressed: () => context.push(AppRouter.globalSearch),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Hero(
            tag: 'settings_icon',
            child: RotationTransition(
              turns: _settingsAnimationController,
              child: Icon(
                CupertinoIcons.settings,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          onPressed: () {
            _settingsAnimationController.forward(from: 0.0);
            context.push(AppRouter.settings);
          },
        ),
        const SizedBox(width: 16),
      ],
      body: DynamicBackground(
        child: !_boxesOpened
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildGamificationHeader(theme),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive Logic:
                        // If width > 600 (Tablet/Desktop), enforce Grid behavior regardless of toggle?
                        // USER REQUEST: "automatic adjustable according to device ... grid automatically in real time"
                        // So, if width is large, show Grid. If small, use Toggle preference.

                        final bool forceGrid = constraints.maxWidth > 600;
                        final bool showGrid = forceGrid || _isGridView;

                        if (showGrid) {
                          // Grid View
                          final int crossAxisCount =
                              (constraints.maxWidth / 160).floor().clamp(2, 6);

                          return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.0, // Square tiles
                                ),
                            itemCount: _order.length,
                            itemBuilder: (context, index) =>
                                _buildGridTile(index, theme),
                          );
                        } else {
                          // List View (Reorderable)
                          return ReorderableListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                            itemCount: _order.length,
                            proxyDecorator: (child, index, animation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (BuildContext context, Widget? child) {
                                  final double animValue = Curves.easeInOut
                                      .transform(animation.value);
                                  final double scale = lerpDouble(
                                    1,
                                    1.05,
                                    animValue,
                                  )!;
                                  return Transform.scale(
                                    scale: scale,
                                    child: Material(
                                      elevation: 12,
                                      color: Colors.transparent,
                                      shadowColor: Colors.black26,
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.cornerRadius,
                                      ),
                                      child: child,
                                    ),
                                  );
                                },
                                child: child,
                              );
                            },
                            onReorder: (oldIndex, newIndex) {
                              if (newIndex > oldIndex) newIndex -= 1;
                              setState(() {
                                final item = _order.removeAt(oldIndex);
                                _order.insert(newIndex, item);
                                _saveOrder();
                              });
                              HapticFeedback.lightImpact();
                            },
                            itemBuilder: (context, index) =>
                                _buildListTile(index, theme),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildOnboardingScreen() {
    final theme = Theme.of(context);
    final currentData = _onboardingData[_onboardingStep];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  currentData.color.withValues(alpha: 0.15),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _onboardingController,
                    onPageChanged: (index) =>
                        setState(() => _onboardingStep = index),
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingPageItem(
                        theme,
                        _onboardingData[index],
                        index == _onboardingStep,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _onboardingStep == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _onboardingStep == index
                                  ? currentData.color
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.1,
                                    ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_onboardingStep > 0)
                            TextButton(
                              onPressed: () {
                                _onboardingController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.onSurface,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            )
                          else
                            const SizedBox(width: 80),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_onboardingStep <
                                    _onboardingData.length - 1) {
                                  _onboardingController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  _completeOnboarding();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentData.color,
                                foregroundColor: Colors.white,
                                elevation: 8,
                                shadowColor: currentData.color.withValues(
                                  alpha: 0.4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _onboardingStep ==
                                            _onboardingData.length - 1
                                        ? 'Get Started'
                                        : 'Next',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_onboardingStep !=
                                      _onboardingData.length - 1) ...[
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPageItem(
    ThemeData theme,
    OnboardingContent content,
    bool isActive,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: content.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: content.color.withValues(alpha: 0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: content.color.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(content.icon, size: 80, color: content.color),
                ),
              );
            },
          ),
          const SizedBox(height: 50),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 20.0, end: isActive ? 0.0 : 20.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(
                  opacity: (1 - (value / 20)).clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Text(
              content.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 20.0, end: isActive ? 0.0 : 20.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(
                  opacity: (1 - (value / 20)).clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Text(
              content.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamificationHeader(ThemeData theme) {
    return Consumer<GamificationService>(
      builder: (context, service, _) {
        final model = service.model;
        final medal = GamificationService.getMedalTier(model.level);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: RepaintBoundary(
            child: Row(
              children: [
                Hero(
                  tag: 'mascot_hero',
                  child: MascotCharacter(
                    size: 80,
                    state: MascotState.values[Hive.box('settings').get(
                        'mascot_state',
                        defaultValue: MascotState.happy.index)],
                    color: Color(Hive.box('settings').get(
                        'mascot_aura_color',
                        defaultValue: theme.colorScheme.primary.value)),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                          child: const AuraPickerSheet(),
                        ),
                      ).then((_) {
                        if (mounted) setState(() {});
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.push(AppRouter.xpDetail),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            MedalWidget(level: model.level, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              'Level ${model.level} ($medal)',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontSize: 18,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: model.progressToNextLevel,
                            minHeight: 6,
                            backgroundColor:
                                theme.colorScheme.primary.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${model.totalXp} / ${model.xpToNextLevel} XP to Level ${model.level + 1}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildStreakIndicator(model.streak, theme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreakIndicator(int streak, ThemeData theme) {
    return Column(
      children: [
        Icon(
              CupertinoIcons.flame_fill,
              color: streak > 0 ? Colors.orange : Colors.grey.withValues(alpha: 0.5),
              size: 32,
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 1.seconds,
            ),
        Text(
          '$streak',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: streak > 0 ? Colors.orange : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _KeepAliveTile extends StatefulWidget {
  final Widget child;
  const _KeepAliveTile({super.key, required this.child});

  @override
  State<_KeepAliveTile> createState() => _KeepAliveTileState();
}

class _KeepAliveTileState extends State<_KeepAliveTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
