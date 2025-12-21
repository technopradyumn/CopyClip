import 'dart:async';
import 'dart:ui';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

// Import your Glass Dialog
import '../../../../core/widgets/glass_dialog.dart';

// --- Form State & History ---
class ExpenseFormState {
  final String title;
  final String amount;
  final String category;
  final String currency;
  final DateTime date;
  final bool isIncome;

  ExpenseFormState(this.title, this.amount, this.category, this.currency, this.date, this.isIncome);

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
  int get hashCode => Object.hash(title, amount, category, currency, date, isIncome);
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
  bool _isIncome = false;

  final List<ExpenseFormState> _undoStack = [];
  final List<ExpenseFormState> _redoStack = [];
  Timer? _debounceTimer;

  // Track initial state for "isDirty" check
  late ExpenseFormState _initialState;

  final List<String> _currencies = ['\$', '€', '£', '₹', '¥', 'A\$', 'C\$', 'kr', 'R\$', 'S\$'];

  List<String> _categorySuggestions = [
    'General', 'Food', 'Transport', 'Bills', 'Shopping',
    'Entertainment', 'Health', 'Salary', 'Freelance'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense?.title ?? '');
    _amountController = TextEditingController(text: widget.expense?.amount.toString().replaceAll('.0', '') ?? '');
    _categoryController = TextEditingController(text: widget.expense?.category ?? 'General');

    if (widget.expense != null) {
      _selectedDate = widget.expense!.date;
      _isIncome = widget.expense!.isIncome;
      _selectedCurrency = widget.expense!.currency;
    } else {
      _loadSettings();
    }

    _loadExistingCategories();

    // Capture initial state
    _initialState = ExpenseFormState(
        _titleController.text,
        _amountController.text,
        _categoryController.text,
        _selectedCurrency,
        _selectedDate,
        _isIncome
    );
    _undoStack.add(_initialState);

    _categoryFocusNode.addListener(() {
      if (_categoryFocusNode.hasFocus) _showOverlay();
      else _removeOverlay();
    });

    _titleController.addListener(_onTextChanged);
    _amountController.addListener(_onTextChanged);
    _categoryController.addListener(_onTextChanged);
  }

  void _loadSettings() {
    if (Hive.isBoxOpen('settings')) {
      final box = Hive.box('settings');
      setState(() => _selectedCurrency = box.get('last_currency', defaultValue: '\$'));
    }
  }

  void _loadExistingCategories() {
    if (Hive.isBoxOpen('expenses_box')) {
      final box = Hive.box<Expense>('expenses_box');
      // ADDED FILTER: Only load categories from active expenses
      final existing = box.values.where((e) => !e.isDeleted).map((e) => e.category).toSet().toList();
      if (existing.isNotEmpty) {
        setState(() => _categorySuggestions = {..._categorySuggestions, ...existing}.toList()..sort());
      }
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

  // --- Dirty Check for Back Press ---
  Future<bool> _onWillPop() async {
    final currentState = ExpenseFormState(
        _titleController.text,
        _amountController.text,
        _categoryController.text,
        _selectedCurrency,
        _selectedDate,
        _isIncome
    );

    if (currentState == _initialState) return true; // No changes

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Unsaved Changes",
        content: "Do you want to save this transaction?",
        confirmText: "Save",
        cancelText: "Discard",
        onConfirm: () => Navigator.pop(ctx, 'save'),
        onCancel: () => Navigator.pop(ctx, 'discard'),
      ),
    );

    if (result == 'save') {
      _save();
      return true;
    } else if (result == 'discard') {
      return true;
    }
    return false;
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
    if (mounted) setState(() {});
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
      if (_titleController.text != state.title)
        _titleController.value = TextEditingValue(text: state.title, selection: TextSelection.collapsed(offset: state.title.length));
      if (_amountController.text != state.amount)
        _amountController.value = TextEditingValue(text: state.amount, selection: TextSelection.collapsed(offset: state.amount.length));
      if (_categoryController.text != state.category)
        _categoryController.value = TextEditingValue(text: state.category, selection: TextSelection.collapsed(offset: state.category.length));
      _selectedCurrency = state.currency;
      _selectedDate = state.date;
      _isIncome = state.isIncome;
    });
  }

  void _onTextChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () => _saveSnapshot());
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
                    title: Text(option, style: theme.textTheme.bodyLarge?.copyWith(color: onSurfaceColor)),
                    onTap: () {
                      _saveSnapshot();
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
    _saveSnapshot();

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
                    'Done',
                    style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(color: onSurfaceColor, fontSize: 20),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: _selectedDate,
                    onDateTimeChanged: (val) => setState(() => _selectedDate = val),
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

  void _save() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;
    final amount = double.tryParse(_amountController.text.replaceAll(',', ''));
    if (amount == null) return;

    final box = Hive.box<Expense>('expenses_box');
    final id = widget.expense?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final expense = Expense(
      id: id,
      title: _titleController.text,
      amount: amount,
      currency: _selectedCurrency,
      date: _selectedDate,
      category: _categoryController.text,
      isIncome: _isIncome,
      sortIndex: widget.expense?.sortIndex ?? 0,
    );

    await box.put(id, expense);
    if (Hive.isBoxOpen('settings')) {
      Hive.box('settings').put('last_currency', _selectedCurrency);
    }

    // Update initial state so pop doesn't trigger dialog
    _initialState = ExpenseFormState(
        expense.title,
        expense.amount.toString(),
        expense.category,
        expense.currency,
        expense.date,
        expense.isIncome
    );

    if (mounted) context.pop();
  }

  // REFACTORED: Soft delete for single transaction
  void _confirmDelete() {
    if (widget.expense == null) return;

    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move Transaction to Recycle Bin?",
        content: "You can restore this transaction later from settings.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          final expense = widget.expense!;
          expense.isDeleted = true;
          expense.deletedAt = DateTime.now();
          expense.save();
          Navigator.pop(ctx); // Close dialog
          context.pop(); // Go back from edit screen
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
    final fillColor = onSurfaceColor.withOpacity(0.12);

    return WillPopScope( // Wrap Scaffold in WillPopScope
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: _unfocusAll,
        child: GlassScaffold(
          showBackArrow: false,
          title: widget.expense == null ? 'New Transaction' : 'Edit',
          actions: [
            IconButton(
              onPressed: _undoStack.length > 1 ? _undo : null,
              icon: Icon(Icons.undo, color: _undoStack.length > 1 ? onSurfaceColor : onSurfaceColor.withOpacity(0.24)),
              tooltip: 'Undo',
            ),
            IconButton(
              onPressed: _redoStack.isNotEmpty ? _redo : null,
              icon: Icon(Icons.redo, color: _redoStack.isNotEmpty ? onSurfaceColor : onSurfaceColor.withOpacity(0.24)),
              tooltip: 'Redo',
            ),
            if (widget.expense != null)
              IconButton(
                  icon: Icon(Icons.delete_outline, color: expenseColor),
                  onPressed: _confirmDelete // Call confirm dialog
              ),
          ],
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 90, left: 20, right: 20, bottom: 40),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CupertinoSlidingSegmentedControl<bool>(
                    groupValue: _isIncome,
                    thumbColor: _isIncome ? Colors.greenAccent : expenseColor,
                    backgroundColor: onSurfaceColor.withOpacity(0.12),
                    children: {
                      false: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Text("Expense", style: TextStyle(color: !_isIncome ? Colors.white : onSurfaceColor.withOpacity(0.54)))),
                      true: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Text("Income", style: TextStyle(color: _isIncome ? Colors.black : onSurfaceColor.withOpacity(0.54)))),
                    },
                    onValueChanged: (val) {
                      _saveSnapshot();
                      setState(() => _isIncome = val!);
                      _saveSnapshot();
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
                      decoration: BoxDecoration(color: fillColor, borderRadius: BorderRadius.circular(12)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCurrency,
                          dropdownColor: theme.cardColor,
                          icon: Icon(Icons.arrow_drop_down, color: onSurfaceColor.withOpacity(0.6)),
                          items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c, style: textTheme.headlineSmall))).toList(),
                          onChanged: (val) {
                            _saveSnapshot();
                            setState(() => _selectedCurrency = val!);
                            _saveSnapshot();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Hero(
                        tag: 'expense_amount_$heroId',
                        child: Material(
                          type: MaterialType.transparency,
                          child: TextField(
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: textTheme.headlineLarge?.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: _isIncome ? Colors.greenAccent : expenseColor
                            ),
                            decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: textTheme.headlineLarge?.copyWith(color: onSurfaceColor.withOpacity(0.12)),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: dividerColor),
                const SizedBox(height: 24),

                // Description
                Text("Description", style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.7))),
                const SizedBox(height: 8),
                Hero(
                  tag: 'expense_title_$heroId',
                  child: Material(
                    type: MaterialType.transparency,
                    child: TextField(
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fillColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        hintText: 'What is this for?',
                        hintStyle: textTheme.bodyLarge?.copyWith(color: onSurfaceColor.withOpacity(0.38)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Category Input & Chips
                Text("Category", style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.7))),
                const SizedBox(height: 8),
                CompositedTransformTarget(
                  link: _layerLink,
                  child: Hero(
                    tag: 'expense_category_$heroId',
                    child: Material(
                      type: MaterialType.transparency,
                      child: TextField(
                        controller: _categoryController,
                        focusNode: _categoryFocusNode,
                        style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: fillColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          suffixIcon: IconButton(
                            icon: Icon(_isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: onSurfaceColor.withOpacity(0.6)),
                            onPressed: _isDropdownOpen ? _unfocusAll : _categoryFocusNode.requestFocus,
                          ),
                          hintText: 'Select or type...',
                          hintStyle: textTheme.bodyLarge?.copyWith(color: onSurfaceColor.withOpacity(0.38)),
                        ),
                      ),
                    ),
                  ),
                ),

                // --- QUICK SELECT CHIPS ---
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
                          label: Text(cat, style: TextStyle(color: isSelected ? colorScheme.onPrimary : onSurfaceColor.withOpacity(0.8))),
                          selected: isSelected,
                          selectedColor: primaryColor,
                          backgroundColor: fillColor,
                          labelStyle: textTheme.bodyMedium,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide.none
                          ),
                          onSelected: (bool selected) {
                            _saveSnapshot();
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
                Text("Date", style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.7))),
                const SizedBox(height: 8),
                Hero(
                  tag: 'expense_date_$heroId',
                  child: Material(
                    type: MaterialType.transparency,
                    child: GestureDetector(
                      onTap: _pickDateTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: fillColor,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: onSurfaceColor.withOpacity(0.6)),
                            const SizedBox(width: 16),
                            Text(DateFormat('MMM dd, yyyy • h:mm a').format(_selectedDate), style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _save,
            backgroundColor: _isIncome ? Colors.greenAccent : expenseColor,
            label: Text('Save', style: textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            icon: Icon(Icons.check, color: Colors.white),
          ),
        ),
      ),
    );
  }
}