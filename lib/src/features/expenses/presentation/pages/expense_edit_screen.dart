import 'dart:async';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:copyclip/src/core/widgets/animated_top_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/widget_sync_service.dart';
import '../../../../core/widgets/glass_dialog.dart';

class ExpenseFormState {
  final String title;
  final String amount;
  final String category;
  final String currency;
  final DateTime date;
  final bool isIncome;

  ExpenseFormState(
    this.title,
    this.amount,
    this.category,
    this.currency,
    this.date,
    this.isIncome,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseFormState &&
          title == other.title &&
          amount == other.amount &&
          category == other.category &&
          currency == other.currency &&
          date == other.date &&
          isIncome == other.isIncome;

  @override
  int get hashCode =>
      Object.hash(title, amount, category, currency, date, isIncome);
}

class ExpenseEditScreen extends StatefulWidget {
  final Expense? expense;
  const ExpenseEditScreen({super.key, this.expense});

  @override
  State<ExpenseEditScreen> createState() => _ExpenseEditScreenState();
}

class _ExpenseEditScreenState extends State<ExpenseEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  DateTime _selectedDate = DateTime.now();
  String _selectedCurrency = '\$';
  bool _isIncome = true;

  final List<ExpenseFormState> _undoStack = [];
  final List<ExpenseFormState> _redoStack = [];
  Timer? _debounceTimer;
  bool _isInitialized = false;

  late ExpenseFormState _initialState;

  final List<String> _currencies = [
    '\$',
    '€',
    '£',
    '₹',
    '¥',
    'A\$',
    'C\$',
    'kr',
    'R\$',
    'S\$',
  ];
  List<String> _categorySuggestions = [
    'General',
    'Food',
    'Transport',
    'Bills',
    'Shopping',
    'Entertainment',
    'Health',
    'Salary',
    'Freelance',
  ];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.expense?.title ?? '');
    _amountController = TextEditingController(
      text: widget.expense?.amount.toString().replaceAll('.0', '') ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.expense?.category ?? '',
    );

    if (widget.expense != null) {
      _selectedDate = widget.expense!.date;
      _isIncome = widget.expense!.isIncome;
      _selectedCurrency = widget.expense!.currency;
    }

    // Schedule initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _completeInitialization();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && widget.expense == null) {
      final l10n = AppLocalizations.of(context)!;
      _categoryController.text = l10n.general;
    }
    // Note: _completeInitialization will be called by post frame callback from initState
  }

  void _completeInitialization() {
    if (_isInitialized) return;
    _isInitialized = true;

    _loadSettings();
    _loadExistingCategories();

    _initialState = ExpenseFormState(
      _titleController.text,
      _amountController.text,
      _categoryController.text,
      _selectedCurrency,
      _selectedDate,
      _isIncome,
    );
    _undoStack.add(_initialState);

    _categoryFocusNode.addListener(() {
      if (_categoryFocusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });

    _titleController.addListener(_onTextChanged);
    _amountController.addListener(_onTextChanged);
    _categoryController.addListener(_onTextChanged);

    if (mounted) setState(() {});
  }

  void _loadSettings() {
    try {
      if (Hive.isBoxOpen('settings')) {
        final box = Hive.box('settings');
        final currency = box.get('last_currency', defaultValue: '\$');
        if (widget.expense == null) {
          if (mounted) setState(() => _selectedCurrency = currency);
        }
      }
    } catch (e) {
      debugPrint("Error loading settings: $e");
    }
  }

  void _loadExistingCategories() {
    try {
      if (Hive.isBoxOpen('expenses_box')) {
        final box = Hive.box<Expense>('expenses_box');
        final existing = box.values
            .where((e) => !e.isDeleted)
            .take(50)
            .map((e) => e.category)
            .toSet()
            .toList();

        if (existing.isNotEmpty) {
          setState(() {
            _categorySuggestions = {
              ..._categorySuggestions,
              ...existing,
            }.toList()..sort();
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading categories: $e");
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _removeOverlay();
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _titleFocusNode.dispose();
    _amountFocusNode.dispose();
    _categoryFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleClose() async {
    final currentState = ExpenseFormState(
      _titleController.text,
      _amountController.text,
      _categoryController.text,
      _selectedCurrency,
      _selectedDate,
      _isIncome,
    );

    if (currentState == _initialState) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => GlassDialog(
        title: l10n.unsavedChanges,
        content: l10n.saveTransactionQuestion,
        confirmText: l10n.save,
        cancelText: l10n.discard,
        onConfirm: () => Navigator.pop(ctx, 'save'),
        onCancel: () => Navigator.pop(ctx, 'discard'),
      ),
    );

    if (!mounted) return;

    if (result == 'save') {
      await _save();
    } else if (result == 'discard') {
      Navigator.of(context).pop();
    }
  }

  void _saveSnapshot({bool clearRedo = true}) {
    final state = ExpenseFormState(
      _titleController.text,
      _amountController.text,
      _categoryController.text,
      _selectedCurrency,
      _selectedDate,
      _isIncome,
    );

    if (_undoStack.isNotEmpty && _undoStack.last == state) return;

    _undoStack.add(state);
    if (clearRedo) _redoStack.clear();
    if (_undoStack.length > 20) _undoStack.removeAt(0);
  }

  void _undo() {
    _unfocusAll();
    if (_undoStack.length <= 1) return;
    final current = _undoStack.removeLast();
    _redoStack.add(current);
    _restoreState(_undoStack.last);
  }

  void _redo() {
    _unfocusAll();
    if (_redoStack.isEmpty) return;
    final next = _redoStack.removeLast();
    _undoStack.add(next);
    _restoreState(next);
  }

  void _restoreState(ExpenseFormState state) {
    setState(() {
      if (_titleController.text != state.title) {
        _titleController.value = TextEditingValue(
          text: state.title,
          selection: TextSelection.collapsed(offset: state.title.length),
        );
      }
      if (_amountController.text != state.amount) {
        _amountController.value = TextEditingValue(
          text: state.amount,
          selection: TextSelection.collapsed(offset: state.amount.length),
        );
      }
      if (_categoryController.text != state.category) {
        _categoryController.value = TextEditingValue(
          text: state.category,
          selection: TextSelection.collapsed(offset: state.category.length),
        );
      }
      _selectedCurrency = state.currency;
      _selectedDate = state.date;
      _isIncome = state.isIncome;
    });
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      _saveSnapshot();
    });
  }

  void _showOverlay() {
    if (_isDropdownOpen) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  void _removeOverlay() {
    if (!_isDropdownOpen) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 40,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 60.0),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: surfaceColor,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: surfaceColor,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _categorySuggestions.length,
                itemBuilder: (context, index) {
                  final option = _categorySuggestions[index];
                  return ListTile(
                    title: Text(
                      option,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: onSurfaceColor,
                      ),
                    ),
                    onTap: () {
                      _categoryController.text = option;
                      _saveSnapshot();
                      _categoryFocusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _unfocusAll() => FocusScope.of(context).unfocus();

  void _pickDateTime() {
    _unfocusAll();

    final surfaceColor = Theme.of(context).colorScheme.surface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 6.0),
          color: surfaceColor,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () {
                    _saveSnapshot();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.done,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: onSurfaceColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: _selectedDate,
                    onDateTimeChanged: (val) =>
                        setState(() => _selectedDate = val),
                    use24hFormat: false,
                    minuteInterval: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.fillTitleAmount)));
      return;
    }

    // Robust Double Parsing
    final cleanAmount = _amountController.text
        .replaceAll(',', '')
        .replaceAll(' ', '');
    final amount = double.tryParse(cleanAmount);
    if (amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.invalidAmount)));
      return;
    }

    try {
      if (!Hive.isBoxOpen('expenses_box')) {
        await Hive.openBox<Expense>('expenses_box');
      }
      final box = Hive.box<Expense>('expenses_box');

      // Use existing ID or create new one
      final id =
          widget.expense?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final expense = Expense(
        id: id,
        title: _titleController.text.trim(),
        amount: amount,
        currency: _selectedCurrency,
        date: _selectedDate,
        category: _categoryController.text.isEmpty
            ? l10n.general
            : _categoryController.text.trim(),
        isIncome: _isIncome,
        sortIndex: widget.expense?.sortIndex ?? 0,
      );

      debugPrint("Saving expense: $id - ${expense.title} - ${expense.amount}");
      await box.put(id, expense);
      WidgetSyncService.syncFinance();

      if (Hive.isBoxOpen('settings')) {
        await Hive.box('settings').put('last_currency', _selectedCurrency);
      }

      _initialState = ExpenseFormState(
        expense.title,
        expense.amount.toString(),
        expense.category,
        expense.currency,
        expense.date,
        expense.isIncome,
      );

      if (mounted) context.pop();
    } catch (e) {
      debugPrint("❌ Error saving expense: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    }
  }

  void _confirmDelete() {
    final l10n = AppLocalizations.of(context)!;
    if (widget.expense == null) return;

    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: l10n.moveTransactionToBinTitle,
        content: l10n.restoreTransactionLater,
        confirmText: l10n.move,
        isDestructive: true,
        onConfirm: () async {
          try {
            if (!Hive.isBoxOpen('expenses_box')) {
              await Hive.openBox<Expense>('expenses_box');
            }
            final expense = widget.expense!;
            expense.isDeleted = true;
            expense.deletedAt = DateTime.now();
            await expense.save(); // Using HiveObject save method
            Navigator.pop(ctx);
            if (context.mounted) {
              context.pop();
            }
          } catch (e) {
            debugPrint("Error deleting: $e");
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final heroId = widget.expense?.id ?? 'new';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final onSurfaceColor = colorScheme.onSurface;
    final primaryColor = colorScheme.primary;
    final dividerColor = theme.dividerColor;
    final expenseColor = Colors.redAccent;
    final incomeColor = Colors.greenAccent;
    final fillColor = onSurfaceColor.withValues(alpha: 0.12);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleClose();
      },
      child: GestureDetector(
        onTap: _unfocusAll,
        child: GlassScaffold(
          centerTitle: false,
          titleSpacing: 0,
          title: AnimatedTopBarTitle(
            title: widget.expense == null
                ? AppLocalizations.of(context)!.newTransaction
                : AppLocalizations.of(context)!.edit,
            icon: CupertinoIcons.money_dollar,
            iconHeroTag: 'expenses_icon',
            titleHeroTag: 'expenses_title',
            color: onSurfaceColor,
          ),
          actions: [
            IconButton(
              onPressed: _undoStack.length > 1 ? _undo : null,
              icon: Icon(
                Icons.undo,
                color: _undoStack.length > 1
                    ? onSurfaceColor
                    : onSurfaceColor.withValues(alpha: 0.24),
              ),
              tooltip: AppLocalizations.of(context)!.undo,
            ),
            IconButton(
              onPressed: _redoStack.isNotEmpty ? _redo : null,
              icon: Icon(
                Icons.redo,
                color: _redoStack.isNotEmpty
                    ? onSurfaceColor
                    : onSurfaceColor.withValues(alpha: 0.24),
              ),
              tooltip: AppLocalizations.of(context)!.redo,
            ),
            if (widget.expense != null)
              IconButton(
                icon: Icon(Icons.delete_outline, color: expenseColor),
                onPressed: _confirmDelete,
              ),
          ],
          body: Hero(
            tag: 'expense_bg_$heroId',
            child: Material(
              type: MaterialType.transparency,
              child: DynamicBackground(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Income/Expense Toggle
                      Center(
                        child: CupertinoSlidingSegmentedControl<bool>(
                          groupValue: _isIncome,
                          thumbColor: _isIncome ? incomeColor : expenseColor,
                          backgroundColor: onSurfaceColor.withValues(
                            alpha: 0.12,
                          ),
                          children: {
                            false: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.expense,
                                style: TextStyle(
                                  color: !_isIncome
                                      ? Colors.white
                                      : onSurfaceColor.withValues(alpha: 0.54),
                                ),
                              ),
                            ),
                            true: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.income,
                                style: TextStyle(
                                  color: _isIncome
                                      ? Colors.black
                                      : onSurfaceColor.withValues(alpha: 0.54),
                                ),
                              ),
                            ),
                          },
                          onValueChanged: (val) {
                            if (val != null) {
                              setState(() => _isIncome = val);
                              _saveSnapshot();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Amount Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: fillColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCurrency,
                                dropdownColor: theme.cardColor,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: onSurfaceColor.withValues(alpha: 0.6),
                                ),
                                items: _currencies.map((c) {
                                  return DropdownMenuItem(
                                    value: c,
                                    child: Text(
                                      c,
                                      style: textTheme.headlineSmall,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedCurrency = val);
                                    _saveSnapshot();
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Material(
                              type: MaterialType.transparency,
                              child: TextField(
                                controller: _amountController,
                                focusNode: _amountFocusNode,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                style: textTheme.headlineLarge?.copyWith(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: _isIncome ? incomeColor : expenseColor,
                                ),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: textTheme.headlineLarge?.copyWith(
                                    color: onSurfaceColor.withValues(
                                      alpha: 0.12,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: dividerColor),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        AppLocalizations.of(context)!.description,
                        style: textTheme.bodySmall?.copyWith(
                          color: onSurfaceColor.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Material(
                        type: MaterialType.transparency,
                        child: TextField(
                          controller: _titleController,
                          focusNode: _titleFocusNode,
                          style: textTheme.bodyLarge?.copyWith(
                            color: onSurfaceColor,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: fillColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            hintText: AppLocalizations.of(
                              context,
                            )!.whatIsThisFor,
                            hintStyle: textTheme.bodyLarge?.copyWith(
                              color: onSurfaceColor.withValues(alpha: 0.38),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Category
                      Text(
                        AppLocalizations.of(context)!.category,
                        style: textTheme.bodySmall?.copyWith(
                          color: onSurfaceColor.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: Material(
                          type: MaterialType.transparency,
                          child: TextField(
                            controller: _categoryController,
                            focusNode: _categoryFocusNode,
                            style: textTheme.bodyLarge?.copyWith(
                              color: onSurfaceColor,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fillColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isDropdownOpen
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: onSurfaceColor.withValues(alpha: 0.6),
                                ),
                                onPressed: _isDropdownOpen
                                    ? _unfocusAll
                                    : () => _categoryFocusNode.requestFocus(),
                              ),
                              hintText: 'Select or type...',
                              hintStyle: textTheme.bodyLarge?.copyWith(
                                color: onSurfaceColor.withValues(alpha: 0.38),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Category Chips
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: _categorySuggestions.map((cat) {
                            final isSelected = _categoryController.text == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(
                                  cat,
                                  style: TextStyle(
                                    color: isSelected
                                        ? colorScheme.onPrimary
                                        : onSurfaceColor.withValues(alpha: 0.8),
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: primaryColor,
                                backgroundColor: fillColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide.none,
                                ),
                                onSelected: (bool selected) {
                                  _categoryController.text = cat;
                                  _saveSnapshot();
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Date
                      Text(
                        "Date",
                        style: textTheme.bodySmall?.copyWith(
                          color: onSurfaceColor.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Material(
                        type: MaterialType.transparency,
                        child: GestureDetector(
                          onTap: _pickDateTime,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: fillColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: onSurfaceColor.withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  DateFormat(
                                    'MMM dd, yyyy • h:mm a',
                                  ).format(_selectedDate),
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: onSurfaceColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _save,
            backgroundColor: _isIncome ? incomeColor : expenseColor,
            label: Text(
              'Save',
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.check, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
