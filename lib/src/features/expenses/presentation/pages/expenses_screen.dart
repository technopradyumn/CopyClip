import 'dart:ui';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../widgets/expense_card.dart';

enum ExpenseSort { custom, amountHigh, amountLow, newest, oldest }

abstract class ListItem {}
class DateHeaderItem extends ListItem {
  final DateTime date;
  final double total;
  DateHeaderItem(this.date, this.total);
}
class ExpenseItemWrapper extends ListItem {
  final Expense expense;
  ExpenseItemWrapper(this.expense);
}

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  // State
  bool _isSelectionMode = false;
  bool _isSearching = false;
  final Set<String> _selectedIds = {};
  String _searchQuery = "";
  ExpenseSort _currentSort = ExpenseSort.custom;

  // Filter State
  String _categoryFilter = 'All';
  String _typeFilter = 'All';

  // Reordering
  List<ListItem> _reorderingList = [];
  bool _isReordering = false;

  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Logic ---
  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) _selectedIds.remove(id);
      else _selectedIds.add(id);
      if (_selectedIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _selectAll(List<Expense> list) {
    setState(() {
      final ids = list.map((e) => e.id).toSet();
      if (_selectedIds.containsAll(ids)) {
        _selectedIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedIds.addAll(ids);
        _isSelectionMode = true;
      }
    });
  }

  // --- ADDED DIALOG HERE ---
  void _deleteSelected() {
    if (_selectedIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete ${_selectedIds.length} Transactions?",
        content: "This action cannot be undone.",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () {
          final box = Hive.box<Expense>('expenses_box');
          for (var id in _selectedIds) box.delete(id);
          setState(() {
            _selectedIds.clear();
            _isSelectionMode = false;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showFilterMenu() {
    final theme = Theme.of(context);
    final surfaceColor = theme.scaffoldBackgroundColor;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final box = Hive.box<Expense>('expenses_box');
        final categories = box.values.map((e) => e.category).toSet().toList()..sort();

        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Filter By", style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              Text("Type", style: theme.textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.7))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['All', 'Income', 'Expense'].map((type) {
                  final isSelected = _typeFilter == type;
                  return ChoiceChip(
                    label: Text(type, style: TextStyle(color: isSelected ? theme.colorScheme.onPrimary : onSurfaceColor.withOpacity(0.8))),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    backgroundColor: onSurfaceColor.withOpacity(0.08),
                    labelStyle: theme.textTheme.bodyMedium,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                    onSelected: (val) {
                      setState(() => _typeFilter = type);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text("Category", style: theme.textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.7))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['All', ...categories].map((cat) {
                  final isSelected = _categoryFilter == cat;
                  return ChoiceChip(
                    label: Text(cat, style: TextStyle(color: isSelected ? theme.colorScheme.onPrimary : onSurfaceColor.withOpacity(0.8))),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    backgroundColor: onSurfaceColor.withOpacity(0.08),
                    labelStyle: theme.textTheme.bodyMedium,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                    onSelected: (val) {
                      setState(() => _categoryFilter = cat);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- List Gen ---
  List<ListItem> _generateList(List<Expense> expenses) {
    Map<String, List<Expense>> grouped = {};
    for (var e in expenses) {
      String key = DateFormat('yyyy-MM-dd').format(e.date);
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(e);
    }

    var keys = grouped.keys.toList();
    if (_currentSort == ExpenseSort.oldest) {
      keys.sort((a, b) => a.compareTo(b));
    } else {
      keys.sort((a, b) => b.compareTo(a));
    }

    List<ListItem> list = [];
    for (var key in keys) {
      final group = grouped[key]!;
      if (_currentSort == ExpenseSort.custom) {
        group.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
      } else if (_currentSort == ExpenseSort.amountHigh) {
        group.sort((a, b) => b.amount.compareTo(a.amount));
      }

      double total = group.fold(0, (sum, item) => sum + (item.isIncome ? item.amount : -item.amount));
      list.add(DateHeaderItem(DateTime.parse(key), total));
      for (var e in group) list.add(ExpenseItemWrapper(e));
    }
    return list;
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final moved = _reorderingList[oldIndex];
    if (moved is DateHeaderItem) return;

    if (moved is ExpenseItemWrapper) {
      setState(() {
        _isReordering = true;
        _reorderingList.removeAt(oldIndex);
        _reorderingList.insert(newIndex, moved);
      });

      DateTime? newDate;
      for (int i = newIndex; i >= 0; i--) {
        if (_reorderingList[i] is DateHeaderItem) {
          newDate = (_reorderingList[i] as DateHeaderItem).date;
          break;
        }
      }

      int index = 0;
      for (var item in _reorderingList) {
        if (item is ExpenseItemWrapper) {
          final expense = item.expense;
          bool save = false;

          if (expense == moved.expense && newDate != null) {
            final updated = DateTime(newDate.year, newDate.month, newDate.day, expense.date.hour, expense.date.minute);
            if (expense.date != updated) {
              expense.date = updated;
              save = true;
            }
          }

          if (expense.sortIndex != index) {
            expense.sortIndex = index;
            save = true;
          }

          if (save) expense.save();
          index++;
        }
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        if(mounted) setState(() => _isReordering = false);
      });
    }
  }

  // --- Helpers ---
  IconData? _getCurrencyIcon(String symbol) {
    switch (symbol) {
      case '\$': return Icons.attach_money;
      case '€': return Icons.euro;
      case '£': return Icons.currency_pound;
      case '₹': return Icons.currency_rupee;
      case '¥': return Icons.currency_yen;
      case '₽': return Icons.currency_ruble;
      case '₺': return Icons.currency_lira;
      case '฿': return Icons.currency_bitcoin;
      default: return null;
    }
  }

  // --- Top Bar Logic ---
  Widget _buildTopBar() {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;
    final deleteColor = Colors.redAccent;

    if (_isSelectionMode) {
      return Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, color: onSurfaceColor),
              onPressed: () => setState(() { _isSelectionMode = false; _selectedIds.clear(); }),
            ),
            Expanded(
              child: Center(
                child: Text("${_selectedIds.length} Selected",
                    style: theme.textTheme.titleLarge
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.select_all, color: onSurfaceColor), onPressed: () => _selectAll(Hive.box<Expense>('expenses_box').values.toList())),
            IconButton(icon: Icon(Icons.delete, color: deleteColor), onPressed: _deleteSelected),
          ],
        ),
      );
    }

    if (_isSearching) {
      return Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: onSurfaceColor),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = "";
                  _searchController.clear();
                });
              },
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(color: onSurfaceColor.withOpacity(0.54)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                icon: Icon(Icons.close, color: onSurfaceColor.withOpacity(0.54)),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = "");
                },
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'expenses_icon',
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box('settings').listenable(keys: ['last_currency']),
                    builder: (context, box, _) {
                      final currency = box.get('last_currency', defaultValue: '\$');
                      final iconData = _getCurrencyIcon(currency);

                      if (iconData != null) {
                        return Icon(iconData, size: 32, color: primaryColor);
                      }

                      return Material(
                        type: MaterialType.transparency,
                        child: Text(
                            currency,
                            style: theme.textTheme.headlineSmall?.copyWith(color: primaryColor)
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Hero(tag: 'expenses_title', child: Material(type: MaterialType.transparency, child: Text("Finance", style: theme.textTheme.titleLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w600)))),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: theme.iconTheme.color),
            onPressed: () => setState(() => _isSearching = true),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.iconTheme.color),
            onPressed: _showFilterMenu,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    return WillPopScope(
      onWillPop: () async {
        if (_isSearching) {
          setState(() { _isSearching = false; _searchQuery = ""; _searchController.clear(); });
          return false;
        }
        if(_isSelectionMode) {
          setState(() { _isSelectionMode = false; _selectedIds.clear(); });
          return false;
        }
        return true;
      },
      child: GlassScaffold(
        title: null,
        floatingActionButton: (_isSelectionMode || _isSearching) ? null : FloatingActionButton(
          onPressed: () => context.push(AppRouter.expenseEdit),
          backgroundColor: primaryColor,
          child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        ),
        body: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Expense>('expenses_box').listenable(),
                builder: (_, Box<Expense> box, __) {
                  var expenses = box.values.toList();

                  // 1. Calculate Totals
                  Map<String, double> totals = {};
                  for (var e in expenses) {
                    double val = e.isIncome ? e.amount : -e.amount;
                    totals[e.currency] = (totals[e.currency] ?? 0) + val;
                  }
                  if (totals.isEmpty) totals['\$'] = 0.0;

                  // 2. Filter
                  if (_searchQuery.isNotEmpty) {
                    expenses = expenses.where((e) => e.title.toLowerCase().contains(_searchQuery)).toList();
                  }
                  if (_categoryFilter != 'All') {
                    expenses = expenses.where((e) => e.category == _categoryFilter).toList();
                  }
                  if (_typeFilter != 'All') {
                    bool isInc = _typeFilter == 'Income';
                    expenses = expenses.where((e) => e.isIncome == isInc).toList();
                  }

                  final flatList = _generateList(expenses);
                  if (!_isReordering) _reorderingList = List.from(flatList);

                  final canReorder = _currentSort == ExpenseSort.custom
                      && _searchQuery.isEmpty
                      && _categoryFilter == 'All'
                      && _typeFilter == 'All'
                      && !_isSelectionMode;

                  return Column(
                    children: [
                      // Summaries
                      if (!_isSearching && !_isSelectionMode)
                        SizedBox(
                          height: 120,
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: totals.length,
                            itemBuilder: (_, i) {
                              String curr = totals.keys.elementAt(i);
                              double val = totals[curr]!;

                              final isPositive = val >= 0;
                              final formattedVal = val.abs().toStringAsFixed(2);
                              final sign = isPositive ? "+" : "-";

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: GlassContainer(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Balance ($curr)", style: theme.textTheme.bodyMedium?.copyWith(color: onSurfaceColor.withOpacity(0.54))),
                                      const SizedBox(height: 4),
                                      Text(
                                          "$sign $curr$formattedVal",
                                          style: theme.textTheme.headlineMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isPositive ? Colors.greenAccent : Colors.redAccent
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      // List
                      Expanded(
                        child: ReorderableListView.builder(
                          padding: const EdgeInsets.all(16),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _isReordering ? _reorderingList.length : flatList.length,
                          buildDefaultDragHandles: false,
                          onReorder: canReorder ? _onReorder : (a, b) {},
                          proxyDecorator: (child, index, animation) => AnimatedBuilder(animation: animation, builder: (_, __) => Transform.scale(scale: 1.05, child: Material(color: Colors.transparent, child: child))),

                          itemBuilder: (_, index) {
                            final item = _isReordering ? _reorderingList[index] : flatList[index];

                            if (item is DateHeaderItem) {
                              return Container(
                                key: ValueKey('header_${item.date}'),
                                child: _buildHeader(item),
                              );
                            }

                            if (item is ExpenseItemWrapper) {
                              final selected = _selectedIds.contains(item.expense.id);

                              // --- CHANGED: Using ExpenseCard Widget ---
                              Widget card = Container(
                                key: ValueKey(item.expense.id),
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ExpenseCard(
                                  expense: item.expense,
                                  isSelected: selected,
                                  onTap: () => _isSelectionMode
                                      ? _toggleSelection(item.expense.id)
                                      : context.push(AppRouter.expenseEdit, extra: item.expense),
                                  onLongPress: () {
                                    if (!_isSelectionMode) {
                                      setState(() {
                                        _isSelectionMode = true;
                                        _selectedIds.add(item.expense.id);
                                      });
                                    }
                                  },
                                ),
                              );

                              if (canReorder) {
                                return ReorderableDelayedDragStartListener(
                                  key: ValueKey(item.expense.id),
                                  index: index,
                                  child: card,
                                );
                              } else {
                                return card;
                              }
                            }
                            return const SizedBox.shrink(key: ValueKey('empty'));
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DateHeaderItem item) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;

    final isPositive = item.total >= 0;
    final sign = isPositive ? "+" : "-";
    final formattedTotal = item.total.abs().toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              DateFormat('EEEE, MMM dd').format(item.date).toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurfaceColor.withOpacity(0.54),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$sign $formattedTotal",
            style: TextStyle(color: isPositive ? Colors.greenAccent.withOpacity(0.7) : Colors.redAccent.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }
}