import 'dart:math';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/expense_card.dart';

// --- Enums ---
enum ExpenseSort { custom, amountHigh, amountLow, newest, oldest }
// NEW: Used to filter data by time chunks
enum AnalysisPeriod { daily, weekly, monthly, yearly }

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> with TickerProviderStateMixin {
  // --- UI Constants ---
  final double _kPadding = 16.0;

  // --- State ---
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Selection & Search
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};
  bool _isSearching = false;
  String _searchQuery = "";

  // Filters & Settings
  ExpenseSort _currentSort = ExpenseSort.custom;
  String _selectedCurrency = '\$';
  List<String> _availableCurrencies = ['\$'];

  // Category & Type Filters
  String _categoryFilter = 'All';
  String _typeFilter = 'All';

  // Calendar & Period State
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now(); // Default to today
  AnalysisPeriod _currentPeriod = AnalysisPeriod.daily; // Default view

  // Analytics Interaction
  int _touchedIndexPie = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSettings();
  }

  void _loadSettings() {
    if (Hive.isBoxOpen('settings')) {
      final box = Hive.box('settings');
      if (mounted) setState(() => _selectedCurrency = box.get('last_currency', defaultValue: '\$'));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // --- Logic Helpers ---

  void _updateAvailableCurrencies(Box<Expense> box) {
    final currencies = box.values.where((e) => !e.isDeleted).map((e) => e.currency).toSet().toList();
    if (currencies.isEmpty) {
      _availableCurrencies = ['\$'];
    } else {
      _availableCurrencies = currencies..sort();
    }
    if (!_availableCurrencies.contains(_selectedCurrency)) {
      _selectedCurrency = _availableCurrencies.isNotEmpty ? _availableCurrencies.first : '\$';
    }
  }

  // --- CORE FILTER LOGIC ---
  bool _isDateInPeriod(DateTime date, DateTime target, AnalysisPeriod period) {
    switch (period) {
      case AnalysisPeriod.daily:
        return isSameDay(date, target);
      case AnalysisPeriod.weekly:
      // Calculate start and end of the week (Monday start)
        final startOfWeek = target.subtract(Duration(days: target.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        // Normalize dates to remove time
        final d = DateTime(date.year, date.month, date.day);
        final s = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
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
        final start = _selectedDay.subtract(Duration(days: _selectedDay.weekday - 1));
        final end = start.add(const Duration(days: 6));
        return "${DateFormat.MMMd().format(start)} - ${DateFormat.MMMd().format(end)}";
      case AnalysisPeriod.monthly:
        return DateFormat.yMMMM().format(_selectedDay);
      case AnalysisPeriod.yearly:
        return DateFormat.y().format(_selectedDay);
    }
  }

  List<Expense> _getFilteredExpenses(Box<Expense> box) {
    _updateAvailableCurrencies(box);

    // 1. Base Filter (Deleted & Currency)
    var expenses = box.values.where((e) => !e.isDeleted && e.currency == _selectedCurrency).toList();

    // 2. Period Filter (Core Logic)
    expenses = expenses.where((e) => _isDateInPeriod(e.date, _selectedDay, _currentPeriod)).toList();

    // 3. Search Filter
    if (_searchQuery.isNotEmpty) {
      expenses = expenses.where((e) => e.title.toLowerCase().contains(_searchQuery)).toList();
    }

    // 4. Type & Category Filter
    if (_typeFilter != 'All') {
      bool isIncome = _typeFilter == 'Income';
      expenses = expenses.where((e) => e.isIncome == isIncome).toList();
    }
    if (_categoryFilter != 'All') {
      expenses = expenses.where((e) => e.category == _categoryFilter).toList();
    }

    // 5. Sort
    switch (_currentSort) {
      case ExpenseSort.amountHigh: expenses.sort((a, b) => b.amount.compareTo(a.amount)); break;
      case ExpenseSort.amountLow: expenses.sort((a, b) => a.amount.compareTo(b.amount)); break;
      case ExpenseSort.newest: expenses.sort((a, b) => b.date.compareTo(a.date)); break;
      case ExpenseSort.oldest: expenses.sort((a, b) => a.date.compareTo(b.date)); break;
      case ExpenseSort.custom: expenses.sort((a, b) => a.sortIndex.compareTo(b.sortIndex)); break;
    }
    return expenses;
  }

  Color _getColorForCategory(String category) {
    final int hash = category.codeUnits.fold(0, (p, c) => p + c);
    final Random rng = Random(hash);
    return HSLColor.fromAHSL(1.0, rng.nextDouble() * 360, 0.65, 0.60).toColor();
  }

  void _showFilterMenu() {
    final theme = Theme.of(context);
    final box = Hive.box<Expense>('expenses_box');
    final categories = box.values.where((e) => !e.isDeleted).map((e) => e.category).toSet().toList()..sort();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassContainer(
          borderRadius: 24,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Filter Options", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface)),
                const SizedBox(height: 20),
                Text("Type", style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurface)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: ['All', 'Income', 'Expense'].map((t) => _buildFilterChip(t, _typeFilter == t, (v) {
                    setState(() => _typeFilter = t);
                    Navigator.pop(context);
                  })).toList(),
                ),
                const SizedBox(height: 20),
                Text("Category", style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurface)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ['All', ...categories].map((c) => _buildFilterChip(c, _categoryFilter == c, (v) {
                    setState(() => _categoryFilter = c);
                    Navigator.pop(context);
                  })).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Function(bool) onSelected) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
          color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
      ),
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
    );
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) _selectedIds.remove(id); else _selectedIds.add(id);
      if (_selectedIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _deleteSelected() {
    final box = Hive.box<Expense>('expenses_box');
    final now = DateTime.now();
    for (var id in _selectedIds) {
      final e = box.values.firstWhere((element) => element.id == id);
      e.isDeleted = true; e.deletedAt = now; e.save();
    }
    setState(() { _selectedIds.clear(); _isSelectionMode = false; });
  }

  // --- UI Builders ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassScaffold(
      title: null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.expenseEdit),
        backgroundColor: theme.colorScheme.primary,
        elevation: 8,
        icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        label: Text("New $_selectedCurrency", style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Expense>('expenses_box').listenable(),
        builder: (context, Box<Expense> box, _) {
          final filteredList = _getFilteredExpenses(box);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: _buildTopBar()),
              SliverToBoxAdapter(child: _buildCurrencySelector()),
              SliverToBoxAdapter(child: _buildCalendar(box)),
              SliverToBoxAdapter(child: const SizedBox(height: 10)),
              // NEW: Period Selector
              SliverToBoxAdapter(child: _buildPeriodSelector()),
              SliverToBoxAdapter(child: const SizedBox(height: 10)),
              SliverToBoxAdapter(child: _buildStyledTabBar()),
              SliverToBoxAdapter(child: const SizedBox(height: 10)),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildListTab(filteredList),
                _buildAnalyticsTab(filteredList),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    final theme = Theme.of(context);

    if (_isSearching) {
      return SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _kPadding, vertical: 8),
          child: GlassContainer(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                    onPressed: () => setState(() { _isSearching = false; _searchQuery = ""; _searchController.clear(); })
                ),
                hintText: "Search in $_selectedCurrency...",
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                border: InputBorder.none,
              ),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _kPadding, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // NEW: Back Button
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface),
                  onPressed: () => context.pop(),
                ),
                // Hero Icon
                Hero(
                  tag: 'expenses_icon',
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.attach_money, color: Colors.redAccent, size: 24),
                  ),
                ),
                const SizedBox(width: 8),
                // Title & Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'expenses_title',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          "Finance",
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                        ),
                      ),
                    ),
                    // Dynamic subtitle based on selection
                    Text(
                        _getPeriodTitle(),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(icon: Icon(Icons.search, color: theme.colorScheme.onSurface), onPressed: () => setState(() => _isSearching = true)),


                if (_isSelectionMode)
                  IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: _deleteSelected)
                else
                  IconButton(icon: Icon(Icons.filter_list, color: theme.colorScheme.onSurface), onPressed: _showFilterMenu),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
              onTap: () => setState(() => _selectedCurrency = curr),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                ),
                child: Center(
                  child: Text(
                    curr,
                    style: TextStyle(
                      color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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

  // --- NEW: Period Selector Widget ---
  Widget _buildPeriodSelector() {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _kPadding),
      child: GlassContainer(
        padding: const EdgeInsets.all(4),
        borderRadius: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: AnalysisPeriod.values.map((period) {
            final isSelected = _currentPeriod == period;
            String label = period.name.substring(0, 1).toUpperCase() + period.name.substring(1);

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _currentPeriod = period),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
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

  Widget _buildCalendar(Box<Expense> box) {
    // Only show events if they match current currency (optional refinement)
    final events = box.values.where((e) => !e.isDeleted && e.currency == _selectedCurrency).toList();
    final theme = Theme.of(context);

    return GlassContainer(
      margin: EdgeInsets.symmetric(horizontal: _kPadding),
      borderRadius: 16,
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
              // If user selects a specific date, switch to daily view for clarity
              // _currentPeriod = AnalysisPeriod.daily;
            });
          }
        },
        onFormatChanged: (format) { if (_calendarFormat != format) setState(() => _calendarFormat = format); },
        onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        eventLoader: (day) => events.where((e) => isSameDay(e.date, day)).toList(),

        calendarStyle: CalendarStyle(
          markerDecoration: const BoxDecoration(color: Colors.pinkAccent, shape: BoxShape.circle),
          todayDecoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
          selectedDecoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
          defaultTextStyle: TextStyle(color: theme.colorScheme.onSurface),
          weekendTextStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
          outsideTextStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.3)),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          titleTextStyle: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
          formatButtonTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
          formatButtonDecoration: const BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.all(Radius.circular(12))),
          leftChevronIcon: Icon(Icons.chevron_left, color: theme.colorScheme.onSurface),
          rightChevronIcon: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface),
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
          color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05))
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.primary,
            boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))]
        ),
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurface,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: "Transactions"),
          Tab(text: "Insights"),
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
            Icon(Icons.money_off, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text("No transactions for $_selectedCurrency", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
            if (_currentPeriod != AnalysisPeriod.daily)
              Text("in this ${_currentPeriod.name}", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 12)),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.push(AppRouter.expenseEdit),
              child: const Text("Add Transaction"),
            )
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(_kPadding, 0, _kPadding, 100),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ExpenseCard(
            expense: expense,
            isSelected: _selectedIds.contains(expense.id),
            onTap: () => _isSelectionMode ? _toggleSelection(expense.id) : context.push(AppRouter.expenseEdit, extra: expense),
            onLongPress: () => setState(() { _isSelectionMode = true; _selectedIds.add(expense.id); }),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab(List<Expense> expenses) {
    if (expenses.isEmpty) return Center(child: Text("No data for this period"));

    double totalIncome = 0;
    double totalExpense = 0;
    int txCount = expenses.length;
    double maxTx = 0;
    Map<String, double> categoryTotals = {};
    Map<int, double> dayOfWeekTotals = {};

    for (var e in expenses) {
      if (e.isIncome) {
        totalIncome += e.amount;
      } else {
        totalExpense += e.amount;
        if (e.amount > maxTx) maxTx = e.amount;
        categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
        dayOfWeekTotals[e.date.weekday] = (dayOfWeekTotals[e.date.weekday] ?? 0) + e.amount;
      }
    }

    double netBalance = totalIncome - totalExpense;
    double savingsRate = totalIncome > 0 ? ((totalIncome - totalExpense) / totalIncome) * 100 : 0;
    double avgSpend = txCount > 0 ? totalExpense / txCount : 0;

    double healthScore = 50 + (savingsRate / 2);
    if (totalExpense > totalIncome) healthScore = 20;
    if (healthScore > 100) healthScore = 100;

    int topDayIndex = 1;
    double topDayAmount = 0;
    dayOfWeekTotals.forEach((day, amount) {
      if (amount > topDayAmount) {
        topDayAmount = amount;
        topDayIndex = day;
      }
    });
    String topDayName = DateFormat('EEEE').format(DateTime(2024, 1, topDayIndex));

    // Dynamic budget title based on period
    String budgetTitle = "${_currentPeriod.name[0].toUpperCase()}${_currentPeriod.name.substring(1)} Budget";
    double budgetLimit = totalIncome > 0 ? totalIncome * 0.8 : 5000;
    double budgetProgress = (totalExpense / budgetLimit).clamp(0.0, 1.0);

    var sortedCategories = categoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(_kPadding, 10, _kPadding, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("$budgetTitle ($_selectedCurrency)"),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Spent: $_selectedCurrency${totalExpense.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                    Text("Limit: $_selectedCurrency${budgetLimit.toStringAsFixed(0)}", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: budgetProgress,
                    minHeight: 12,
                    backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                    color: budgetProgress > 0.9 ? Colors.red : (budgetProgress > 0.7 ? Colors.orange : Colors.green),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  budgetProgress > 1.0 ? "Over Budget!" : "${((1-budgetProgress)*100).toStringAsFixed(0)}% remaining",
                  style: TextStyle(color: budgetProgress > 1.0 ? Colors.red : Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard("Net Balance", netBalance, Icons.account_balance_wallet, Colors.blue),
              _buildStatCard("Savings Rate", savingsRate, Icons.savings, savingsRate > 0 ? Colors.green : Colors.orange, isPercent: true),
              _buildStatCard("Health Score", healthScore, Icons.health_and_safety, healthScore > 70 ? Colors.green : Colors.amber, isPercent: false, suffix: "/100"),
              _buildStatCard("Top Day", 0, Icons.calendar_today, Colors.orangeAccent, isPercent: false, suffix: "", customValue: topDayName),
            ],
          ),

          const SizedBox(height: 20),

          _buildSectionHeader("Deep Insights"),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildInsightCard("Avg Tx Value", "$_selectedCurrency${avgSpend.toStringAsFixed(0)}", Icons.show_chart, Colors.tealAccent),
                const SizedBox(width: 10),
                _buildInsightCard("Max Transaction", "$_selectedCurrency${maxTx.toStringAsFixed(0)}", Icons.priority_high, Colors.redAccent),
                const SizedBox(width: 10),
                _buildInsightCard("Transactions", "$txCount", Icons.receipt_long, Colors.blueAccent),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader("Category Breakdown"),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: sortedCategories.map((e) {
                        final isTouched = sortedCategories.indexOf(e) == _touchedIndexPie;
                        return PieChartSectionData(
                          color: _getColorForCategory(e.key),
                          value: e.value,
                          title: "${((e.value/totalExpense)*100).toStringAsFixed(0)}%",
                          radius: isTouched ? 60 : 50,
                          titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black45, blurRadius: 2, offset: Offset(1,1))]
                          ),
                        );
                      }).toList(),
                      pieTouchData: PieTouchData(touchCallback: (e, r) {
                        setState(() {
                          if (r != null && r.touchedSection != null) {
                            _touchedIndexPie = r.touchedSection!.touchedSectionIndex;
                          } else {
                            _touchedIndexPie = -1;
                          }
                        });
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ...sortedCategories.map((e) {
                  double pct = totalExpense > 0 ? e.value / totalExpense : 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: _getColorForCategory(e.key).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.category, color: _getColorForCategory(e.key), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.key, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                                  Text("$_selectedCurrency${e.value.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
                                  color: _getColorForCategory(e.key),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
    );
  }

  Widget _buildStatCard(String title, double value, IconData icon, Color color, {bool isPercent = false, String suffix = "", String? customValue}) {
    final theme = Theme.of(context);
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const Spacer(),
          Text(title, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.7))),
          const SizedBox(height: 4),
          Text(
            customValue ?? (isPercent ? "${value.toStringAsFixed(1)}%" : "$_selectedCurrency${value.toStringAsFixed(0)}$suffix"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return GlassContainer(
      width: 140,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }
}