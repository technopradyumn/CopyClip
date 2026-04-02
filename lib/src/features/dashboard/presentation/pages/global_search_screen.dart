import 'package:copyclip/src/core/theme/custom_selection_controls.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:copyclip/src/core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:copyclip/src/core/widgets/empty_state_widget.dart'; // Added

// Models
import '../../../../core/app_content_palette.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';

// Cards
import '../../../clipboard/presentation/widgets/clipboard_card.dart';
import '../../../expenses/presentation/widgets/expense_card.dart';
import '../../../journal/presentation/widgets/journal_list_card.dart';
import '../../../notes/presentation/widgets/note_card.dart';
import '../../../todos/presentation/widgets/todo_card.dart';
import '../../../calendar/presentation/widgets/event_card.dart';
import '../../../social_post/presentation/widgets/social_post_card.dart';
import '../../../calendar/data/calendar_event_model.dart';
import '../../../social_post/data/social_post_model.dart';

import 'dashboard_screen.dart';

class SearchResult extends GlobalSearchResult {
  final DateTime dateTime;
  final int? colorValue;

  SearchResult({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.type,
    required super.route,
    required this.dateTime,
    this.colorValue,
    super.argument,
  });
}

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // ✅ PERFORMANCE: Debounce timer to prevent freezing on rapid typing
  Timer? _debounce;

  // ✅ STATE MANAGEMENT
  final ValueNotifier<List<SearchResult>> _filteredListNotifier = ValueNotifier(
    [],
  );
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(
    true,
  ); // Start loading
  String? _errorMessage;

  // Data Store
  List<SearchResult> _allData = [];

  // Filter State
  String _query = "";
  String _selectedType = "All";
  String _sortBy = "Newest";
  String _dateRange = "All Time";
  int? _filterColor;

  final List<String> _filterTypes = [
    "All",
    "Event",
    "Note",
    "Todo",
    "Expense",
    "Journal",
    "Clipboard",
    "Social",
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Async initialization to not block the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _filteredListNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }

  // ✅ OPTIMIZED: Debounced Search Listener
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _query = _searchController.text;
      _applyFilters();
    });
  }

  // --- DATA LOADING (ASYNC & SAFE) ---
  Future<void> _loadAllData() async {
    _setLoading(true);
    _errorMessage = null;
    List<SearchResult> results = [];

    try {
      // ✅ Helper to safely add data with error isolation
      Future<void> safeAdd<T>(
        String boxName,
        SearchResult Function(T) mapper,
      ) async {
        try {
          // Ensure box is loaded
          final box = await LazyBoxLoader.getBox<T>(boxName);

          // Yield to UI thread to prevent freezing if box is huge
          if (box.length > 500) await Future.delayed(Duration.zero);

          final items = box.values
              .where((e) {
                try {
                  // ✅ Deep Safe Check for corrupted objects
                  if (e == null) return false;
                  return (e as dynamic).isDeleted == false;
                } catch (_) {
                  return true;
                }
              })
              .map((e) {
                try {
                  return mapper(e);
                } catch (e) {
                  return null;
                }
              })
              .whereType<SearchResult>()
              .toList();

          results.addAll(items);
        } catch (e) {
          debugPrint("⚠️ Partial Load Error in $boxName: $e");
        }
      }

      // Load all sources
      await safeAdd<Note>(
        'notes_box',
        (e) => SearchResult(
          id: e.id,
          title: e.title,
          subtitle: e.content,
          type: 'Note',
          route: AppRouter.noteEdit,
          argument: e,
          dateTime: e.updatedAt,
          colorValue: e.colorValue,
        ),
      );

      await safeAdd<JournalEntry>(
        'journal_box',
        (e) => SearchResult(
          id: e.id,
          title: e.title,
          subtitle: e.content,
          type: 'Journal',
          route: AppRouter.journalEdit,
          argument: e,
          dateTime: e.date,
          colorValue: e.colorValue,
        ),
      );

      await safeAdd<ClipboardItem>(
        'clipboard_box',
        (e) => SearchResult(
          id: e.id,
          title: e.content,
          subtitle: "Clipboard",
          type: 'Clipboard',
          route: AppRouter.clipboardEdit,
          argument: e,
          dateTime: e.createdAt,
          colorValue: e.colorValue,
        ),
      );

      await safeAdd<Todo>(
        'todos_box',
        (e) => SearchResult(
          id: e.id,
          title: e.task,
          subtitle: e.isDone ? "Completed" : "Pending",
          type: 'Todo',
          route: AppRouter.todoEdit,
          argument: e,
          dateTime: e.dueDate ?? DateTime.now(),
        ),
      );

      await safeAdd<Expense>(
        'expenses_box',
        (e) => SearchResult(
          id: e.id,
          title: e.title,
          subtitle: "${e.currency}${e.amount}",
          type: 'Expense',
          route: AppRouter.expenseEdit,
          argument: e,
          dateTime: e.date,
        ),
      );

      await safeAdd<CalendarEvent>(
        'calendar_events_box',
        (e) => SearchResult(
          id: e.id,
          title: e.title,
          subtitle: e.description.isNotEmpty ? e.description : "Event",
          type: 'Event',
          route: AppRouter.calendarEventEdit,
          argument: e,
          dateTime: e.startDate,
        ),
      );

      await safeAdd<SocialPost>(
        'social_posts_box',
        (e) => SearchResult(
          id: e.id,
          title: e.content,
          subtitle: "Social Post",
          type: 'Social',
          route: AppRouter.socialPostEdit,
          argument: e,
          dateTime: e.createdAt,
        ),
      );

      _allData = results;
      _applyFilters();
    } catch (e) {
      debugPrint("❌ Critical Global Search Error: $e");
      setState(
        () => _errorMessage =
            "Unable to load data. Please try restarting the app.",
      );
    } finally {
      if (mounted) _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (mounted) _isLoadingNotifier.value = loading;
  }

  // --- FILTERING ENGINE ---
  Future<void> _applyFilters() async {
    _setLoading(true);

    try {
      final queryLower = _query.toLowerCase().trim();
      final filterParams = {
        'allData': _allData,
        'queryLower': queryLower,
        'selectedType': _selectedType,
        'filterColor': _filterColor,
        'dateRange': _dateRange,
        'sortBy': _sortBy,
      };

      // ✅ Runs on main thread to avoid HiveObject isolation issues
      final filtered = _performFiltering(filterParams);

      if (mounted) _filteredListNotifier.value = filtered;
    } catch (e) {
      debugPrint("❌ Filtering Isolate Error: $e");
    } finally {
      if (mounted) _setLoading(false);
    }
  }

  static List<SearchResult> _performFiltering(Map<String, dynamic> params) {
    final List<SearchResult> allData = params['allData'];
    final String queryLower = params['queryLower'];
    final String selectedType = params['selectedType'];
    final int? filterColor = params['filterColor'];
    final String dateRange = params['dateRange'];
    final String sortBy = params['sortBy'];

    List<SearchResult> filtered = List.from(allData);

    // 1. Text Search
    if (queryLower.isNotEmpty) {
      filtered = filtered.where((item) {
        final t = item.title.toLowerCase();
        final s = item.subtitle.toLowerCase();
        return t.contains(queryLower) || s.contains(queryLower);
      }).toList();
    }

    // 2. Type Filter
    if (selectedType != "All") {
      filtered = filtered.where((item) => item.type == selectedType).toList();
    }

    // 3. Color Filter
    if (filterColor != null) {
      filtered = filtered
          .where((item) => item.colorValue == filterColor)
          .toList();
    }

    // 4. Date Filter
    if (dateRange != "All Time") {
      final now = DateTime.now();
      filtered = filtered.where((item) {
        if (dateRange == "Today") {
          return item.dateTime.year == now.year &&
              item.dateTime.month == now.month &&
              item.dateTime.day == now.day;
        } else if (dateRange == "This Week") {
          final lastWeek = now.subtract(const Duration(days: 7));
          return item.dateTime.isAfter(lastWeek);
        }
        return true;
      }).toList();
    }

    // 5. Sorting
    if (sortBy == "Newest") {
      filtered.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (sortBy == "Oldest") {
      filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (sortBy == "A-Z") {
      filtered.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    }

    return filtered;
  }

  // --- UI BUILDERS ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassScaffold(
      showBackArrow: false,
      title: null,
      body: DynamicBackground(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildIntegratedSearchBar(theme),
            const SizedBox(height: 12),
            _buildHorizontalFilterChips(theme),
            const SizedBox(height: 8),

            // ✅ LIST SECTION WITH LOADING STATE
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isLoadingNotifier,
                builder: (context, isLoading, _) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: theme.hintColor),
                          ),
                          TextButton(
                            onPressed: _loadAllData,
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }

                  return ValueListenableBuilder<List<SearchResult>>(
                    valueListenable: _filteredListNotifier,
                    builder: (context, filteredItems, _) {
                      if (filteredItems.isEmpty) {
                        return Center(
                          child: EmptyStateWidget(
                            message: "No results found",
                            subMessage: "Try adjusting your search or filters.",
                            assetPath: "assets/images/search_empty.svg",
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        physics: const BouncingScrollPhysics(),
                        // ✅ PERFORMANCE: Reasonable cache extent
                        cacheExtent: 500,
                        itemCount: filteredItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return RepaintBoundary(
                            child: _buildResultCard(filteredItems[index]),
                          );
                        },
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

  Widget _buildIntegratedSearchBar(ThemeData theme) {
    bool hasActiveFilters =
        _filterColor != null || _dateRange != "All Time" || _sortBy != "Newest";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
              child: TextField(
                selectionControls: CustomSelectionControls(),
                controller: _searchController,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: "${AppLocalizations.of(context)!.search}...",
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.tune_rounded,
              color: hasActiveFilters ? theme.colorScheme.primary : null,
            ),
            onPressed: _showSortFilterSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalFilterChips(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filterTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = _filterTypes[index];
          final isSelected = _selectedType == type;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedType = type);
              _applyFilters();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                type == "Todo"
                    ? "To-Dos"
                    : type == "Expense"
                    ? "Finance"
                    : type,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ IMPROVED VISIBILITY: Dialog for Sort & Filter
  void _showSortFilterSheet() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sort & Filter"),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _sortBy = "Newest";
                      _dateRange = "All Time";
                      _filterColor = null;
                    });
                    _applyFilters();
                    setSheetState(() {});
                    // Don't close, just reset
                  },
                  child: const Text("Reset"),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sheetSectionTitle("Sort Order"),
                  Wrap(
                    spacing: 8,
                    children: ["Newest", "Oldest", "A-Z"]
                        .map(
                          (s) => ChoiceChip(
                            label: Text(s),
                            selected: _sortBy == s,
                            onSelected: (v) {
                              setSheetState(() => _sortBy = s);
                              setState(() => _sortBy = s);
                              _applyFilters();
                            },
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 16),
                  _sheetSectionTitle("Timeframe"),
                  Wrap(
                    spacing: 8,
                    children: ["All Time", "Today", "This Week"]
                        .map(
                          (d) => ChoiceChip(
                            label: Text(d),
                            selected: _dateRange == d,
                            onSelected: (v) {
                              setSheetState(() => _dateRange = d);
                              setState(() => _dateRange = d);
                              _applyFilters();
                            },
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 16),
                  _sheetSectionTitle("Color Tag"),
                  _buildColorFilterRow(setSheetState),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sheetSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
  );

  Widget _buildColorFilterRow(Function setSheetState) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final List<Color> myPalette = AppContentPalette.palette;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: myPalette.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                setSheetState(() => _filterColor = null);
                setState(() => _filterColor = null);
                _applyFilters();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: onSurface.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: _filterColor == null
                        ? primaryColor
                        : onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            );
          }

          final color = myPalette[index - 1];
          final isSelected = _filterColor == color.toARGB32();
          final contrastColor = AppContentPalette.getContrastColor(color);

          return GestureDetector(
            onTap: () {
              setSheetState(() => _filterColor = color.toARGB32());
              setState(() => _filterColor = color.toARGB32());
              _applyFilters();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : onSurface.withValues(alpha: 0.2),
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 18, color: contrastColor)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultCard(SearchResult res) {
    final theme = Theme.of(context);
    switch (res.type) {
      case 'Event':
        return _wrapWithCategory(
          Hero(
            tag: 'event_${res.id}',
            child: Material(
              type: MaterialType.transparency,
              child: EventCard(
                event: res.argument,
                onTap: () async {
                  await context.push('/calendar/detail/${res.id}', extra: res.argument);
                  _loadAllData();
                },
                onDelete: () {
                  try {
                    final event = res.argument as CalendarEvent;
                    event.isDeleted = true;
                    event.save();
                  } catch (_) {}
                  _loadAllData();
                },
              ),
            ),
          ),
          res.type,
          theme,
        );
      case 'Note':
        return _wrapWithCategory(
          NoteCard(
            note: res.argument,
            isSelected: false,
            onTap: () async {
              await context.push(res.route, extra: res.argument);
              _loadAllData();
            },
            onCopy: () => _copy(res),
            onShare: () => _share(res),
            onDelete: () => _delete(res),
            onColorChanged: (c) {
              (res.argument as Note).colorValue = c.toARGB32();
              (res.argument as Note).save();
              setState(() {});
            },
          ),
          res.type,
          theme,
        );
      case 'Todo':
        return _wrapWithCategory(
          TodoCard(
            todo: res.argument,
            isSelected: false,
            onTap: () async {
              await context.push(res.route, extra: res.argument);
              _loadAllData();
            },
            onToggleDone: () {
              (res.argument as Todo).isDone = !(res.argument as Todo).isDone;
              (res.argument as Todo).save();
              _loadAllData();
            },
          ),
          res.type,
          theme,
        );
      case 'Expense':
        return _wrapWithCategory(
          ExpenseCard(
            expense: res.argument,
            isSelected: false,
            onTap: () async {
              await context.push(res.route, extra: res.argument);
              _loadAllData();
            },
          ),
          res.type,
          theme,
        );
      case 'Journal':
        return _wrapWithCategory(
          JournalListCard(
            entry: res.argument,
            isSelected: false,
            onTap: () async {
              await context.push(res.route, extra: res.argument);
              _loadAllData();
            },
            onDelete: () => _delete(res),
            onDesignChanged: (id) {
              (res.argument as JournalEntry).designId = id;
              (res.argument as JournalEntry).save();
              setState(() {});
            },
            onCopy: () => _copy(res),
            onShare: () => _share(res),
          ),
          res.type,
          theme,
        );
      case 'Clipboard':
        return _wrapWithCategory(
          ClipboardCard(
            item: res.argument,
            isSelected: false,
            onTap: () async {
              await context.push(res.route, extra: res.argument);
              _loadAllData();
            },
            onDelete: () => _delete(res),
            onColorChanged: (c) {
              (res.argument as ClipboardItem).colorValue = c.toARGB32();
              (res.argument as ClipboardItem).save();
              setState(() {});
            },
            onCopy: () => _copy(res),
            onShare: () => _share(res),
          ),
          res.type,
          theme,
        );
      case 'Social':
        return _wrapWithCategory(
          SocialPostCard(
            post: res.argument,
            onTap: () async {
              await context.push(res.route, extra: res.argument);
              _loadAllData();
            },
          ),
          res.type,
          theme,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _wrapWithCategory(Widget card, String type, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              type.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        card,
      ],
    );
  }

  void _copy(SearchResult res) {
    Clipboard.setData(ClipboardData(text: res.title));
  }

  void _share(SearchResult res) {
    Share.share(res.title);
  }

  void _delete(SearchResult res) {
    try {
      final item = res.argument;
      item.isDeleted = true;
      item.deletedAt = DateTime.now();
      item.save();
    } catch (_) {}
    _loadAllData();
  }
}
