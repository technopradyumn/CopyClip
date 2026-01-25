import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:copyclip/src/core/const/constant.dart';

// Core Widgets
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/services/interstitial_ad_service.dart';

// Data
import 'package:copyclip/src/features/expenses/data/expense_model.dart';

// Widgets
import '../widgets/expense_card.dart';

// --- Enums ---
enum ExpenseSort { custom, amountHigh, amountLow, newest, oldest }

enum AnalysisPeriod { daily, weekly, monthly, yearly }

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen>
    with TickerProviderStateMixin {
  // --- UI Constants ---
  final double _kPadding = 16.0;

  // --- State ---
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // ✅ CRITICAL FIX: Future variable to prevent reloading/flickering
  late Future<Box<Expense>> _boxFuture;

  // Selection
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  // Search
  bool _isSearching = false;
  String _searchQuery = "";

  // Filters
  ExpenseSort _currentSort = ExpenseSort.newest;
  String _selectedCurrency = '\$';
  List<String> _availableCurrencies = ['\$'];
  String _categoryFilter = 'All';
  String _typeFilter = 'All';

  // Calendar & Period
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  AnalysisPeriod _currentPeriod = AnalysisPeriod.daily;

  // Chart Interaction
  int _touchedIndexPie = -1;

  // Interstitial Ad Service
  final InterstitialAdService _adService = InterstitialAdService();
  bool _hasShownAdForAnalytics = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen for Analytics tab access
    _tabController.addListener(_onTabChanged);

    // ✅ Initialize the future ONCE here.
    // This prevents the "loading" flicker when scrolling or tapping.
    _boxFuture = _openBoxSafely();

    // Safely load settings
    if (Hive.isBoxOpen('settings')) {
      _loadSettings();
    } else {
      Hive.openBox('settings').then((_) {
        if (mounted) _loadSettings();
      });
    }

    // Listen to Search without setState on every char
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    // Load interstitial ad for analytics tab
    _adService.loadAd();
  }

  void _onTabChanged() {
    // When user switches to Analytics tab (index 1), show ad
    if (_tabController.index == 1 && !_hasShownAdForAnalytics) {
      // Immediately switch back to list tab
      _tabController.index = 0;

      // Show ad, then switch to analytics on completion
      _adService.showAd(() {
        if (mounted) {
          setState(() {
            _hasShownAdForAnalytics = true;
            _tabController.index = 1; // Switch to analytics tab
          });
        }
      });
    }
  }

  /// ✅ Robust Open Logic: Handles if main.dart failed or data is corrupted
  Future<Box<Expense>> _openBoxSafely() async {
    try {
      if (Hive.isBoxOpen('expenses_box')) {
        return Hive.box<Expense>('expenses_box');
      } else {
        return await Hive.openBox<Expense>('expenses_box');
      }
    } catch (e) {
      debugPrint("❌ Database Corruption Detected: $e");
      // If corrupted, delete and recreate
      await Hive.deleteBoxFromDisk('expenses_box');
      return await Hive.openBox<Expense>('expenses_box');
    }
  }

  void _loadSettings() {
    if (!Hive.isBoxOpen('settings')) return;
    final box = Hive.box('settings');
    if (mounted)
      setState(
        () => _selectedCurrency = box.get('last_currency', defaultValue: '\$'),
      );
  }

  // ============ INTERSTITIAL AD FOR ANALYTICS TAB ============
  // Using centralized InterstitialAdService

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    // Ad service is singleton, no need to dispose
    super.dispose();
  }

  // --- FILTER LOGIC ---
  List<Expense> _applyFilters(List<Expense> allExpenses) {
    // 1. Basic cleaning
    var expenses = allExpenses.where((e) => !e.isDeleted).toList();

    // 2. Update Currencies available
    final currencies = expenses.map((e) => e.currency).toSet().toList();
    if (currencies.isNotEmpty) {
      currencies.sort();

      if (!listEquals(_availableCurrencies, currencies)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !listEquals(_availableCurrencies, currencies)) {
            setState(() {
              _availableCurrencies = currencies;
              if (!currencies.contains(_selectedCurrency)) {
                _selectedCurrency = currencies.first;
              }
            });
          }
        });
      }
    }

    // 3. Filter by Currency
    expenses = expenses.where((e) => e.currency == _selectedCurrency).toList();

    // 4. Period Filter
    expenses = expenses
        .where((e) => _isDateInPeriod(e.date, _selectedDay, _currentPeriod))
        .toList();

    // 5. Search Filter
    if (_searchQuery.isNotEmpty) {
      expenses = expenses
          .where((e) => e.title.toLowerCase().contains(_searchQuery))
          .toList();
    }

    // 6. Type Filter
    if (_typeFilter != 'All') {
      bool isIncome = _typeFilter == 'Income';
      expenses = expenses.where((e) => e.isIncome == isIncome).toList();
    }

    // 7. Category Filter
    if (_categoryFilter != 'All') {
      expenses = expenses.where((e) => e.category == _categoryFilter).toList();
    }

    // 8. Sorting
    switch (_currentSort) {
      case ExpenseSort.amountHigh:
        expenses.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case ExpenseSort.amountLow:
        expenses.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case ExpenseSort.newest:
        expenses.sort((a, b) => b.date.compareTo(a.date));
        break;
      case ExpenseSort.oldest:
        expenses.sort((a, b) => a.date.compareTo(b.date));
        break;
      case ExpenseSort.custom:
        expenses.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
        break;
    }

    return expenses;
  }

  bool _isDateInPeriod(DateTime date, DateTime target, AnalysisPeriod period) {
    switch (period) {
      case AnalysisPeriod.daily:
        return isSameDay(date, target);
      case AnalysisPeriod.weekly:
        final startOfWeek = target.subtract(Duration(days: target.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        final d = DateTime(date.year, date.month, date.day);
        final s = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );
        final e = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);
        return d.compareTo(s) >= 0 && d.compareTo(e) <= 0;
      case AnalysisPeriod.monthly:
        return date.year == target.year && date.month == target.month;
      case AnalysisPeriod.yearly:
        return date.year == target.year;
    }
  }

  String _getPeriodTitle() {
    switch (_currentPeriod) {
      case AnalysisPeriod.daily:
        return DateFormat.yMMMMd().format(_selectedDay);
      case AnalysisPeriod.weekly:
        final start = _selectedDay.subtract(
          Duration(days: _selectedDay.weekday - 1),
        );
        final end = start.add(const Duration(days: 6));
        return "${DateFormat.MMMd().format(start)} - ${DateFormat.MMMd().format(end)}";
      case AnalysisPeriod.monthly:
        return DateFormat.yMMMM().format(_selectedDay);
      case AnalysisPeriod.yearly:
        return DateFormat.y().format(_selectedDay);
    }
  }

  Color _getColorForCategory(String category) {
    final int hash = category.codeUnits.fold(0, (p, c) => p + c);
    final Random rng = Random(hash);
    return HSLColor.fromAHSL(1.0, rng.nextDouble() * 360, 0.65, 0.60).toColor();
  }

  // --- SELECTION LOGIC ---
  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id))
        _selectedIds.remove(id);
      else
        _selectedIds.add(id);
      if (_selectedIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _deleteSelected() {
    // Only proceed if the box is actually open.
    // Since we are inside a FutureBuilder/ValueListenableBuilder, it likely is.
    if (!Hive.isBoxOpen('expenses_box')) return;

    final box = Hive.box<Expense>('expenses_box');
    final now = DateTime.now();
    for (var id in _selectedIds) {
      try {
        final e = box.values.firstWhere((element) => element.id == id);
        e.isDeleted = true;
        e.deletedAt = now;
        e.save();
      } catch (_) {}
    }
    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }

  // --- UI BUILDERS ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassScaffold(
      title: null,
      // ✅ STRUCTURAL FIX: Use a Column like NotesScreen
      // This keeps the Header static and allows Hero animation to play instantly.
      body: Column(
        children: [
          // 1. Static Header (Rendered immediately)
          _buildTopBar(),

          // 2. Scrollable Content (Loads asynchronously)
          Expanded(
            child: FutureBuilder<Box<Expense>>(
              future: _boxFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Error loading data.\n\n${snapshot.error}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ValueListenableBuilder<Box<Expense>>(
                  valueListenable: snapshot.data!.listenable(),
                  builder: (context, box, _) {
                    final allExpenses = box.values.toList();
                    final expenses = _applyFilters(allExpenses);

                    return NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        // ⚠️ NOTE: _buildTopBar removed from here
                        SliverToBoxAdapter(child: _buildCurrencySelector()),
                        SliverToBoxAdapter(
                          child: _buildTotalBalance(allExpenses),
                        ),
                        SliverToBoxAdapter(child: _buildCalendar(allExpenses)),
                        SliverToBoxAdapter(child: const SizedBox(height: 10)),
                        SliverToBoxAdapter(child: _buildPeriodSelector()),
                        SliverToBoxAdapter(child: const SizedBox(height: 10)),
                        SliverToBoxAdapter(child: _buildStyledTabBar()),
                        SliverToBoxAdapter(child: const SizedBox(height: 10)),
                      ],
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildListTab(expenses),
                          _buildAnalyticsTab(expenses),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.expenseEdit),
        backgroundColor: FeatureColors.expenses,
        elevation: 4,
        icon: Icon(CupertinoIcons.add, color: theme.colorScheme.onPrimary),
        label: Text(
          "New $_selectedCurrency",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ✅ UPDATED: No longer requires list argument
  Widget _buildTopBar() {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;

    if (_isSearching) {
      return SeamlessHeader(
        title: "",
        heroTagPrefix: 'expenses',
        showBackButton: true,
        onBackTap: () => setState(() {
          _isSearching = false;
          _searchQuery = "";
          _searchController.clear();
        }),
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: "Search in $_selectedCurrency...",
                  hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SeamlessHeader(
      title: "Expense",
      subtitle: _getPeriodTitle(),
      icon: CupertinoIcons.money_dollar,
      iconColor: Colors.redAccent,
      heroTagPrefix: 'expenses',
      actions: [
        IconButton(
          icon: Icon(CupertinoIcons.search, color: onSurfaceColor),
          onPressed: () => setState(() => _isSearching = true),
        ),
        if (_isSelectionMode)
          IconButton(
            icon: const Icon(CupertinoIcons.delete, color: Colors.redAccent),
            onPressed: _deleteSelected,
          )
        else
          PopupMenuButton<dynamic>(
            icon: Icon(
              CupertinoIcons.slider_horizontal_3,
              color: onSurfaceColor,
            ),
            tooltip: 'Sort & Filter',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (dynamic result) {
              if (result is ExpenseSort) {
                setState(() {
                  _currentSort = result;
                  // Auto-reset filters if sorting changes? No, keep filters.
                });
              } else if (result == 'filter') {
                // Open Filter Dialog
                if (Hive.isBoxOpen('expenses_box')) {
                  final list = Hive.box<Expense>(
                    'expenses_box',
                  ).values.toList();
                  _showFilterDialog(list);
                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
              // SORTING SECTION
              const PopupMenuItem<dynamic>(
                enabled: false,
                child: Text(
                  'SORT BY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              PopupMenuItem<dynamic>(
                value: ExpenseSort.newest,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.calendar_today,
                      size: 18,
                      color: _currentSort == ExpenseSort.newest
                          ? FeatureColors.expenses
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Newest First",
                      style: TextStyle(
                        color: _currentSort == ExpenseSort.newest
                            ? FeatureColors.expenses
                            : null,
                        fontWeight: _currentSort == ExpenseSort.newest
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<dynamic>(
                value: ExpenseSort.oldest,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.time,
                      size: 18,
                      color: _currentSort == ExpenseSort.oldest
                          ? FeatureColors.expenses
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Oldest First",
                      style: TextStyle(
                        color: _currentSort == ExpenseSort.oldest
                            ? FeatureColors.expenses
                            : null,
                        fontWeight: _currentSort == ExpenseSort.oldest
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<dynamic>(
                value: ExpenseSort.amountHigh,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.arrow_up,
                      size: 18,
                      color: _currentSort == ExpenseSort.amountHigh
                          ? FeatureColors.expenses
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Highest Amount",
                      style: TextStyle(
                        color: _currentSort == ExpenseSort.amountHigh
                            ? FeatureColors.expenses
                            : null,
                        fontWeight: _currentSort == ExpenseSort.amountHigh
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<dynamic>(
                value: ExpenseSort.amountLow,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.arrow_down,
                      size: 18,
                      color: _currentSort == ExpenseSort.amountLow
                          ? FeatureColors.expenses
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Lowest Amount",
                      style: TextStyle(
                        color: _currentSort == ExpenseSort.amountLow
                            ? FeatureColors.expenses
                            : null,
                        fontWeight: _currentSort == ExpenseSort.amountLow
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<dynamic>(
                value: 'filter',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.slider_horizontal_3, size: 18),
                    const SizedBox(width: 12),
                    Text("More Filters..."),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _showFilterDialog(List<Expense> expenses) {
    final theme = Theme.of(context);
    final categories =
        expenses
            .where((e) => !e.isDeleted)
            .map((e) => e.category)
            .toSet()
            .toList()
          ..sort();

    // Local state for the dialog
    String tempType = _typeFilter;
    String tempCategory = _categoryFilter;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Filter Expenses"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transaction Type",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: ['All', 'Income', 'Expense']
                          .map(
                            (t) => ChoiceChip(
                              label: Text(t),
                              selected: tempType == t,
                              onSelected: (selected) {
                                if (selected) {
                                  setDialogState(() => tempType = t);
                                }
                              },
                              selectedColor: theme.colorScheme.primary,
                              backgroundColor: theme
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withOpacity(0.5),
                              labelStyle: TextStyle(
                                color: tempType == t
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                                fontWeight: tempType == t
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.cornerRadius,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const Divider(height: 32),
                    Text(
                      "Categories",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['All', ...categories]
                          .map(
                            (c) => ChoiceChip(
                              label: Text(c),
                              selected: tempCategory == c,
                              onSelected: (selected) {
                                if (selected) {
                                  setDialogState(() => tempCategory = c);
                                }
                              },
                              selectedColor: theme.colorScheme.primary,
                              backgroundColor: theme
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withOpacity(0.5),
                              labelStyle: TextStyle(
                                color: tempCategory == c
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                                fontWeight: tempCategory == c
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.cornerRadius,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Reset Logic
                    setDialogState(() {
                      tempType = 'All';
                      tempCategory = 'All';
                    });
                  },
                  child: const Text("Reset"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    setState(() {
                      _typeFilter = tempType;
                      _categoryFilter = tempCategory;
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- Other Widgets ---

  Widget _buildCurrencySelector() {
    if (_availableCurrencies.length <= 1) return const SizedBox.shrink();
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: _kPadding),
        itemCount: _availableCurrencies.length,
        itemBuilder: (context, index) {
          final curr = _availableCurrencies[index];
          final isSelected = curr == _selectedCurrency;
          final theme = Theme.of(context);
          return Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCurrency = curr);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest.withOpacity(
                          0.5,
                        ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    curr,
                    style: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _kPadding),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: AnalysisPeriod.values.map((period) {
            final isSelected = _currentPeriod == period;
            String label =
                period.name.substring(0, 1).toUpperCase() +
                period.name.substring(1);
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _currentPeriod = period);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTotalBalance(List<Expense> allExpenses) {
    // Filter for Balance (All time, current currency, valid)
    final relevantExpenses = allExpenses.where(
      (e) => !e.isDeleted && e.currency == _selectedCurrency,
    );

    double totalIncome = 0;
    double totalExpense = 0;

    for (var e in relevantExpenses) {
      if (e.isIncome) {
        totalIncome += e.amount;
      } else {
        totalExpense += e.amount;
      }
    }

    final balance = totalIncome - totalExpense;
    final isNegative = balance < 0;
    final theme = Theme.of(context);

    // If no expenses, show 0.00
    // If balance is negative, show in red.

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _kPadding, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Text(
              "Balance",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "$_selectedCurrency${balance.toStringAsFixed(2)}",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isNegative ? Colors.red : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(List<Expense> allEvents) {
    final theme = Theme.of(context);
    final events = allEvents.where((e) => !e.isDeleted).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: _kPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5), // Fast transparency
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format)
            setState(() => _calendarFormat = format);
        },
        onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        eventLoader: (day) =>
            events.where((e) => isSameDay(e.date, day)).toList(),
        calendarStyle: CalendarStyle(
          markerDecoration: const BoxDecoration(
            color: Colors.pinkAccent,
            shape: BoxShape.circle,
          ),
          todayDecoration: const BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(color: theme.colorScheme.onSurface),
          weekendTextStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          outsideTextStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: theme.colorScheme.onSurface,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTabBar() {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _kPadding),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurface,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          const Tab(text: "Transactions"),
          const Tab(text: "Insights"),
        ],
      ),
    );
  }

  Widget _buildListTab(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.money_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "No transactions for $_selectedCurrency",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            if (_currentPeriod != AnalysisPeriod.daily)
              Text(
                "in this ${_currentPeriod.name}",
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(_kPadding, 0, _kPadding, 100),
      itemCount: expenses.length,
      // ✅ PERFORMANCE: Cache extent allows smooth scrolling
      cacheExtent: 1000,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          // ✅ PERFORMANCE: RepaintBoundary prevents lag
          child: RepaintBoundary(
            child: ExpenseCard(
              expense: expense,
              isSelected: _selectedIds.contains(expense.id),
              onTap: () => _isSelectionMode
                  ? _toggleSelection(expense.id)
                  : context.push(AppRouter.expenseEdit, extra: expense),
              onLongPress: () => setState(() {
                _isSelectionMode = true;
                _selectedIds.add(expense.id);
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab(List<Expense> expenses) {
    if (expenses.isEmpty)
      return const Center(child: Text("No data for this period"));

    double totalIncome = 0;
    double totalExpense = 0;
    int txCount = expenses.length;
    double maxTx = 0;
    Map<String, double> categoryTotals = {};

    for (var e in expenses) {
      if (e.isIncome) {
        totalIncome += e.amount;
      } else {
        totalExpense += e.amount;
        if (e.amount > maxTx) maxTx = e.amount;
        categoryTotals[e.category] =
            (categoryTotals[e.category] ?? 0) + e.amount;
      }
    }

    double netBalance = totalIncome - totalExpense;
    double savingsRate = totalIncome > 0
        ? ((totalIncome - totalExpense) / totalIncome) * 100
        : 0;
    double healthScore = (50 + (savingsRate / 2)).clamp(0, 100);
    if (totalExpense > totalIncome) healthScore = 20;

    String budgetTitle =
        "${_currentPeriod.name[0].toUpperCase()}${_currentPeriod.name.substring(1)} Budget";

    // ✅ DYNAMIC LIMIT: User requested actual total income as the limit
    double budgetLimit = totalIncome;

    double budgetProgress = budgetLimit > 0
        ? (totalExpense / budgetLimit).clamp(0.0, 1.0)
        : (totalExpense > 0 ? 1.0 : 0.0);

    var sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(_kPadding, 10, _kPadding, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StaggeredFadeIn(
            delay: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("$budgetTitle ($_selectedCurrency)"),

                // Budget Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Spent: $_selectedCurrency${totalExpense.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "Limit: $_selectedCurrency${budgetLimit.toStringAsFixed(0)}",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppConstants.cornerRadius,
                        ),
                        child: LinearProgressIndicator(
                          value: budgetProgress,
                          minHeight: 12,
                          backgroundColor: theme.colorScheme.onSurface
                              .withOpacity(0.1),
                          color: budgetProgress > 0.9
                              ? Colors.red
                              : (budgetProgress > 0.7
                                    ? Colors.orange
                                    : Colors.green),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        budgetProgress >= 1.0
                            ? "Over Budget!"
                            : "${((1 - budgetProgress) * 100).toStringAsFixed(0)}% remaining",
                        style: TextStyle(
                          color: budgetProgress >= 1.0
                              ? Colors.red
                              : Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _StaggeredFadeIn(
                  delay: 1,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        "Net Balance",
                        netBalance,
                        Icons.account_balance_wallet,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        "Savings Rate",
                        savingsRate,
                        Icons.savings,
                        savingsRate > 0 ? Colors.green : Colors.orange,
                        isPercent: true,
                      ),
                      _buildStatCard(
                        "Health Score",
                        healthScore,
                        Icons.health_and_safety,
                        healthScore > 70 ? Colors.green : Colors.amber,
                        isPercent: false,
                        suffix: "/100",
                        customValue: "${healthScore.toInt()}/100",
                        onInfoTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => GlassDialog(
                              title: "Health Score",
                              content:
                                  "This score is based on your Savings Rate.\n\n"
                                  "• > 50% saved = Excellent (100)\n"
                                  "• 0% saved = Average (50)\n"
                                  "• Spending > Income = Poor (<50)",
                              confirmText: "OK",
                              onConfirm: () => Navigator.pop(ctx),
                            ),
                          );
                        },
                      ),
                      _buildStatCard(
                        "Transactions",
                        txCount.toDouble(),
                        Icons.receipt_long,
                        Colors.purpleAccent,
                        customValue: "$txCount",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _StaggeredFadeIn(
                  delay: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Balance Trend"),
                      const SizedBox(height: 8),
                      _buildTrendChart(expenses),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Financial Activity (Bar Chart)
                _StaggeredFadeIn(
                  delay: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Financial Activity"),
                      const SizedBox(height: 8),
                      _buildBarChart(expenses),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _StaggeredFadeIn(
                  delay: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Category Breakdown"),
                      const SizedBox(height: 8),
                      // Pie Chart Container
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              // Replaced expensive RepaintBoundary with direct chart to ensure touch works smoothly
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 4,
                                  centerSpaceRadius: 40,
                                  sections: sortedCategories.map((e) {
                                    final isTouched =
                                        sortedCategories.indexOf(e) ==
                                        _touchedIndexPie;
                                    return PieChartSectionData(
                                      color: _getColorForCategory(e.key),
                                      value: e.value,
                                      title:
                                          "${((e.value / totalExpense) * 100).toStringAsFixed(0)}%",
                                      radius: isTouched ? 60 : 50,
                                      titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  }).toList(),
                                  pieTouchData: PieTouchData(
                                    touchCallback:
                                        (
                                          FlTouchEvent event,
                                          PieTouchResponse? response,
                                        ) {
                                          setState(() {
                                            if (response != null &&
                                                response.touchedSection !=
                                                    null) {
                                              _touchedIndexPie = response
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            } else {
                                              _touchedIndexPie = -1;
                                            }
                                          });
                                        },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ...sortedCategories.map((e) {
                              double pct = totalExpense > 0
                                  ? e.value / totalExpense
                                  : 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: _getColorForCategory(
                                          e.key,
                                        ).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(
                                          AppConstants.cornerRadius,
                                        ),
                                      ),
                                      child: Icon(
                                        CupertinoIcons.square_grid_2x2,
                                        color: _getColorForCategory(e.key),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                e.key,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                              Text(
                                                "$_selectedCurrency${e.value.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: LinearProgressIndicator(
                                              value: pct,
                                              backgroundColor: theme
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.05),
                                              color: _getColorForCategory(
                                                e.key,
                                              ),
                                              minHeight: 6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    double value,
    IconData icon,
    Color color, {
    bool isPercent = false,
    String suffix = "",
    String? customValue,
    VoidCallback? onInfoTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          if (onInfoTap != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onInfoTap,
                child: Icon(
                  CupertinoIcons.info,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                customValue ??
                    (isPercent
                        ? "${value.toStringAsFixed(1)}%"
                        : "$_selectedCurrency${value.toStringAsFixed(0)}$suffix"),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<Expense> expenses) {
    if (expenses.isEmpty) return const SizedBox.shrink();

    // 1. DATA AGGREGATION
    // Structure: Map<int, _BarData> where int is day/month index
    Map<int, _BarData> data = {};

    // Initialize based on period

    if (_currentPeriod == AnalysisPeriod.daily ||
        _currentPeriod == AnalysisPeriod.weekly) {
      // Mon-Sun
      // Default 0s
      for (int i = 1; i <= 7; i++) data[i] = _BarData(0, 0);
    } else if (_currentPeriod == AnalysisPeriod.monthly) {
      // We won't pre-fill 31 days to avoid clutter, only days with data or key intervals
    } else {
      // Jan-Dec
      for (int i = 1; i <= 12; i++) data[i] = _BarData(0, 0);
    }

    for (var e in expenses) {
      int key;
      if (_currentPeriod == AnalysisPeriod.yearly) {
        key = e.date.month;
      } else if (_currentPeriod == AnalysisPeriod.monthly) {
        key = e.date.day;
      } else {
        key = e.date.weekday; // 1=Mon, 7=Sun
      }

      final current = data[key] ?? _BarData(0, 0);
      if (e.isIncome) {
        data[key] = _BarData(current.income + e.amount, current.expense);
      } else {
        data[key] = _BarData(current.income, current.expense + e.amount);
      }
    }

    // Sort entries
    var sortedEntries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final theme = Theme.of(context);

    return Container(
      height: 220,
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _calculateMaxY(data.values),
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.transparent,
              tooltipPadding: const EdgeInsets.all(0),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                if (rod.toY == 0) return null;
                return BarTooltipItem(
                  rod.toY.toInt().toString(),
                  TextStyle(
                    color: rodIndex == 0
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                "Time Frame",
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final style = TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  );
                  String text = "";
                  int val = value.toInt();

                  if (_currentPeriod == AnalysisPeriod.yearly) {
                    const months = [
                      "",
                      "J",
                      "F",
                      "M",
                      "A",
                      "M",
                      "J",
                      "J",
                      "A",
                      "S",
                      "O",
                      "N",
                      "D",
                    ];
                    if (val >= 1 && val <= 12) text = months[val];
                  } else if (_currentPeriod == AnalysisPeriod.monthly) {
                    if (val % 5 == 0) text = "$val"; // Show 5, 10, 15...
                  } else {
                    const days = ["", "M", "T", "W", "T", "F", "S", "S"];
                    if (val >= 1 && val <= 7) text = days[val];
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(text, style: style),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                "Amount ($_selectedCurrency)",
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: _leftTitleWidgets,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(_calculateMaxY(data.values)),
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.onSurface.withOpacity(0.05),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: sortedEntries.map((e) {
            return BarChartGroupData(
              x: e.key,
              showingTooltipIndicators: [0, 1], // Show for both rods
              barRods: [
                BarChartRodData(
                  toY: e.value.income,
                  color: Colors.greenAccent.withOpacity(0.8),
                  width: 8,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
                BarChartRodData(
                  toY: e.value.expense,
                  color: Colors.redAccent.withOpacity(0.8),
                  width: 8,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    if (value == meta.min || value == meta.max) return const SizedBox.shrink();
    final style = TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      fontSize: 10,
    );
    String text;
    if (value >= 1000) {
      text = '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      text = value.toInt().toString();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  double _calculateMaxY(Iterable<_BarData> values) {
    if (values.isEmpty) return 100;
    double maxVal = 0;
    for (var v in values) {
      if (v.income > maxVal) maxVal = v.income;
      if (v.expense > maxVal) maxVal = v.expense;
    }
    return maxVal == 0 ? 100 : maxVal * 1.2; // Add padding
  }

  double _calculateInterval(double maxY) {
    if (maxY <= 100) return 20;
    if (maxY <= 1000) return 200;
    return maxY / 5;
  }

  // ✅ TREND CHART IMPLEMENTATION
  Widget _buildTrendChart(List<Expense> expenses) {
    if (expenses.isEmpty) return const SizedBox.shrink();

    // Aggregate Data for Line Chart (Balance Over Time)
    Map<int, double> data = {};

    if (_currentPeriod == AnalysisPeriod.daily ||
        _currentPeriod == AnalysisPeriod.weekly) {
      // Daily/Weekly
      // Daily/Weekly
      for (int i = 1; i <= 7; i++) data[i] = 0;
    } else if (_currentPeriod == AnalysisPeriod.monthly) {
      // Monthly

      // Sparse data for month
    } else {
      // Yearly
      // Yearly
      for (int i = 1; i <= 12; i++) data[i] = 0;
    }

    // Running Balance? Or Daily Net? Let's do Daily Net for simpler trend.
    for (var e in expenses) {
      int key;
      if (_currentPeriod == AnalysisPeriod.yearly)
        key = e.date.month;
      else if (_currentPeriod == AnalysisPeriod.monthly)
        key = e.date.day;
      else
        key = e.date.weekday;

      double val = data[key] ?? 0;
      if (e.isIncome)
        val += e.amount;
      else
        val -= e.amount;
      data[key] = val;
    }

    List<FlSpot> spots =
        data.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList()
          ..sort((a, b) => a.x.compareTo(b.x));

    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    // Define Bar Data to reference in Tooltips
    final lineChartBarData = LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.fromLTRB(16, 24, 24, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: LineChart(
        LineChartData(
          showingTooltipIndicators: spots.map((s) {
            return ShowingTooltipIndicators([
              LineBarSpot(lineChartBarData, 0, s),
            ]);
          }).toList(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(_calculateMaxYSpots(spots)),
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.onSurface.withOpacity(0.05),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                "Time",
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (val, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      val.toInt().toString(),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                "Balance ($_selectedCurrency)",
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: _leftTitleWidgets,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [lineChartBarData],
          lineTouchData: LineTouchData(
            enabled: false,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.transparent,
              tooltipPadding: const EdgeInsets.all(0),
              tooltipMargin: 8,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    spot.y.toInt().toString(),
                    TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  // Helper for Chart Ranges
  double _calculateMaxYSpots(List<FlSpot> spots) {
    if (spots.isEmpty) return 100;
    double maxVal = 0;
    for (var s in spots) {
      if (s.y.abs() > maxVal) maxVal = s.y.abs();
    }
    return maxVal == 0 ? 100 : maxVal * 1.2;
  }
}

class _BarData {
  final double income;
  final double expense;
  _BarData(this.income, this.expense);
}

// ✅ ANIMATION WIDGET
class _StaggeredFadeIn extends StatefulWidget {
  final Widget child;
  final int delay; // Multiplier
  const _StaggeredFadeIn({required this.child, required this.delay});

  @override
  State<_StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<_StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: 100 * widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
