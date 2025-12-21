import 'dart:convert';
import 'dart:ui';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/router/app_router.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../clipboard/presentation/widgets/clipboard_card.dart';
import '../../../expenses/presentation/widgets/expense_card.dart';
import '../../../journal/presentation/widgets/journal_card.dart';
import '../../../notes/presentation/widgets/note_card.dart';
import '../../../todos/presentation/widgets/todo_card.dart';

class FeatureItem {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  FeatureItem(this.id, this.title, this.icon, this.color, this.route);
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<GlobalSearchResult> _searchResults = [];
  bool _boxesOpened = false;

  // --- REORDERING STATE ---
  List<String> _order = [];
  String? _draggedId;
  Offset? _dragPosition;
  final GlobalKey _gridKey = GlobalKey();

  final Map<String, FeatureItem> _features = {
    'notes': FeatureItem('notes', 'Notes', Icons.note_alt_outlined, Colors.amberAccent, AppRouter.notes),
    'todos': FeatureItem('todos', 'To-Dos', Icons.check_circle_outline, Colors.greenAccent, AppRouter.todos),
    'expenses': FeatureItem('expenses', 'Finance', Icons.attach_money, Colors.redAccent, AppRouter.expenses),
    'journal': FeatureItem('journal', 'Journal', Icons.book_outlined, Colors.blueAccent, AppRouter.journal),
    'calendar': FeatureItem('calendar', 'Calendar', Icons.calendar_today_outlined, Colors.orangeAccent, AppRouter.calendar),
    'clipboard': FeatureItem('clipboard', 'Clipboard', Icons.paste, Colors.purpleAccent, AppRouter.clipboard),
  };

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    if (!Hive.isBoxOpen('settings')) await Hive.openBox('settings');
    if (!Hive.isBoxOpen('notes_box')) await Hive.openBox<Note>('notes_box');
    if (!Hive.isBoxOpen('todos_box')) await Hive.openBox<Todo>('todos_box');
    if (!Hive.isBoxOpen('expenses_box')) await Hive.openBox<Expense>('expenses_box');
    if (!Hive.isBoxOpen('journal_box')) await Hive.openBox<JournalEntry>('journal_box');
    if (!Hive.isBoxOpen('clipboard_box')) await Hive.openBox<ClipboardItem>('clipboard_box');

    final settingsBox = Hive.box('settings');
    final savedOrder = settingsBox.get('dashboard_order', defaultValue: null);

    if (mounted) {
      setState(() {
        if (savedOrder != null) {
          List<String> loadedOrder = List<String>.from(savedOrder);
          for (var key in _features.keys) {
            if (!loadedOrder.contains(key)) loadedOrder.add(key);
          }
          _order = loadedOrder;
        } else {
          _order = _features.keys.toList();
        }
        _boxesOpened = true;
      });
    }
  }

  void _saveOrder() {
    if (Hive.isBoxOpen('settings')) {
      Hive.box('settings').put('dashboard_order', _order);
    }
  }

  // --- DRAG LOGIC ---
  void _onDragStart(String id, LongPressStartDetails details) {
    setState(() {
      _draggedId = id;
      _dragPosition = details.globalPosition;
    });
    HapticFeedback.selectionClick();
  }

  void _onDragUpdate(LongPressMoveUpdateDetails details, double itemWidth, double itemHeight) {
    setState(() {
      _dragPosition = details.globalPosition;
    });

    final RenderBox? box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset localPos = box.globalToLocal(details.globalPosition);
    const int crossAxisCount = 2;
    const double spacing = 16.0;

    final double pointerX = localPos.dx;
    final double pointerY = localPos.dy;

    int col = (pointerX / (itemWidth + spacing)).floor();
    int row = (pointerY / (itemHeight + spacing)).floor();

    if (col < 0) col = 0;
    if (col >= crossAxisCount) col = crossAxisCount - 1;
    if (row < 0) row = 0;

    int newIndex = (row * crossAxisCount) + col;
    if (newIndex >= _order.length) newIndex = _order.length - 1;

    final int oldIndex = _order.indexOf(_draggedId!);

    if (newIndex != oldIndex) {
      setState(() {
        final item = _order.removeAt(oldIndex);
        _order.insert(newIndex, item);
      });
      HapticFeedback.selectionClick();
    }
  }

  void _onDragEnd() {
    setState(() {
      _draggedId = null;
      _dragPosition = null;
    });
    _saveOrder();
  }

  // --- SEARCH LOGIC ---
  void _startSearch() => setState(() => _isSearching = true);
  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchResults = [];
    });
    FocusScope.of(context).unfocus();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    if (!_boxesOpened) return;

    List<GlobalSearchResult> results = [];
    final q = query.toLowerCase();

    // Notes
    final notes = Hive.box<Note>('notes_box').values.where((n) => !n.isDeleted);
    for (var note in notes) {
      if (note.title.toLowerCase().contains(q) || note.content.toLowerCase().contains(q)) {
        results.add(GlobalSearchResult(
          id: note.id,
          title: note.title,
          subtitle: note.content,
          type: 'Note',
          route: AppRouter.noteEdit,
          argument: note,
        ));
      }
    }

    // Todos
    final todos = Hive.box<Todo>('todos_box').values.where((t) => !t.isDeleted);
    for (var todo in todos) {
      if (todo.task.toLowerCase().contains(q)) {
        results.add(GlobalSearchResult(
          id: todo.id,
          title: todo.task,
          subtitle: todo.isDone ? "Completed" : "Pending",
          type: 'Todo',
          route: AppRouter.todoEdit,
          argument: todo,
          isCompleted: todo.isDone,
        ));
      }
    }

    // Expenses
    final expenses = Hive.box<Expense>('expenses_box').values.where((e) => !e.isDeleted);
    for (var expense in expenses) {
      if (expense.title.toLowerCase().contains(q)) {
        results.add(GlobalSearchResult(
          id: expense.id,
          title: expense.title,
          subtitle: "${expense.isIncome ? '+' : '-'} ${expense.currency}${expense.amount}",
          type: 'Expense',
          route: AppRouter.expenseEdit,
          argument: expense,
        ));
      }
    }

    // Journal
    final journals = Hive.box<JournalEntry>('journal_box').values.where((j) => !j.isDeleted);
    for (var entry in journals) {
      if (entry.title.toLowerCase().contains(q) || entry.content.toLowerCase().contains(q)) {
        results.add(GlobalSearchResult(
          id: entry.id,
          title: entry.title,
          subtitle: DateFormat('MMM dd, yyyy').format(entry.date),
          type: 'Journal',
          route: AppRouter.journalEdit,
          argument: entry,
        ));
      }
    }

    // Clipboard
    final clips = Hive.box<ClipboardItem>('clipboard_box').values.where((c) => !c.isDeleted);
    for (var clip in clips) {
      if (clip.content.toLowerCase().contains(q)) {
        results.add(GlobalSearchResult(
          id: clip.id,
          title: clip.content,
          subtitle: "Copied on ${DateFormat('MMM dd, h:mm a').format(clip.createdAt)}",
          type: 'Clipboard',
          route: AppRouter.clipboardEdit,
          argument: clip,
        ));
      }
    }

    setState(() => _searchResults = results);
  }

  // --- ACTIONS FOR CARDS ---
  void _copyContent(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  void _shareContent(String text) => Share.share(text);

  void _deleteItem(GlobalSearchResult res) {
    final dynamic item = res.argument;
    final now = DateTime.now();

    if (item is Note) {
      item.isDeleted = true;
      item.deletedAt = now;
      item.save();
    } else if (item is Todo) {
      item.isDeleted = true;
      item.deletedAt = now;
      item.save();
    } else if (item is Expense) {
      item.isDeleted = true;
      item.deletedAt = now;
      item.save();
    } else if (item is JournalEntry) {
      item.isDeleted = true;
      item.deletedAt = now;
      item.save();
    } else if (item is ClipboardItem) {
      item.isDeleted = true;
      item.deletedAt = now;
      item.save();
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Moved to Recycle Bin")));
    // Remove from UI
    setState(() {
      _searchResults.removeWhere((i) => i.id == res.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final textTheme = Theme.of(context).textTheme;

    if (!_boxesOpened) {
      return GlassScaffold(body: Center(child: Text("Loading...", style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor))));
    }

    return WillPopScope(
      onWillPop: () async {
        // 1. Close Keyboard if open (Do not go back)
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
          return false;
        }
        // 2. Close Search mode if active
        if (_isSearching) {
          _stopSearch();
          return false;
        }
        // 3. Allow app exit
        return true;
      },
      child: GlassScaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
              child: _isSearching ? _buildSearchBar() : _buildWelcomeHeader(),
            ),
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : _buildAnimatedGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const int crossAxisCount = 2;
        const double spacing = 16.0;
        final double totalWidth = constraints.maxWidth - 40;
        final double itemWidth = (totalWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        final double itemHeight = itemWidth / 1.05;

        final int rows = (_order.length / crossAxisCount).ceil();
        final double stackHeight = (rows * itemHeight) + ((rows + 1) * spacing);
        const double topOffsetAdjustment = 140.0;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            key: _gridKey,
            height: stackHeight + 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (int i = 0; i < _order.length; i++) ...[
                    _buildAnimatedItem(
                      index: i,
                      id: _order[i],
                      itemWidth: itemWidth,
                      itemHeight: itemHeight,
                      spacing: spacing,
                    ),
                  ],
                  if (_draggedId != null && _dragPosition != null)
                    Positioned(
                      left: _dragPosition!.dx - 20 - (itemWidth / 2),
                      top: _dragPosition!.dy - topOffsetAdjustment - (itemHeight / 2),
                      child: IgnorePointer(
                        child: SizedBox(
                          width: itemWidth,
                          height: itemHeight,
                          child: _buildFeatureCard(_features[_draggedId]!, isDragging: true),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedItem({
    required int index,
    required String id,
    required double itemWidth,
    required double itemHeight,
    required double spacing,
  }) {
    final int col = index % 2;
    final int row = index ~/ 2;

    final double left = (col * (itemWidth + spacing));
    final double top = (row * (itemHeight + spacing));

    final bool isBeingDragged = id == _draggedId;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      left: left,
      top: top,
      child: GestureDetector(
        onLongPressStart: (details) => _onDragStart(id, details),
        onLongPressMoveUpdate: (details) => _onDragUpdate(details, itemWidth, itemHeight),
        onLongPressEnd: (_) => _onDragEnd(),
        onTap: () => context.push(_features[id]!.route),
        child: SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: isBeingDragged
              ? const SizedBox()
              : _buildFeatureCard(_features[id]!),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(FeatureItem item, {bool isDragging = false}) {
    final glassTint = Color.alphaBlend(
        item.color.withOpacity(0.15),
        Theme.of(context).colorScheme.surface.withOpacity(0.05)
    );

    return GlassContainer(
      color: glassTint,
      opacity: 0.6,
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.2),
              shape: BoxShape.circle,
              boxShadow: isDragging ? [
                BoxShadow(color: item.color.withOpacity(0.5), blurRadius: 20, spreadRadius: 2)
              ] : null,
            ),
            child: isDragging
                ? Icon(item.icon, size: 32, color: item.color)
                : Hero(tag: '${item.id}_icon', child: Icon(item.icon, size: 32, color: item.color)),
          ),
          const SizedBox(height: 16),
          isDragging
              ? Material(type: MaterialType.transparency, child: Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)))
              : Hero(tag: '${item.id}_title', child: Material(type: MaterialType.transparency, child: Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)))),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Dashboard", style: textTheme.headlineLarge?.copyWith(color: onSurfaceColor, fontWeight: FontWeight.w600, fontSize: 32)),
              Text("Your workspace", style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor.withOpacity(0.5))),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(icon: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: onSurfaceColor.withOpacity(0.08), shape: BoxShape.circle), child: Icon(Icons.search, color: onSurfaceColor, size: 24)), onPressed: _startSearch),
            const SizedBox(width: 8),
            IconButton(icon: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: onSurfaceColor.withOpacity(0.08), shape: BoxShape.circle), child: Icon(Icons.settings_outlined, color: onSurfaceColor, size: 24)), onPressed: () => context.push(AppRouter.settings)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        IconButton(icon: Icon(Icons.arrow_back, color: onSurfaceColor), onPressed: _stopSearch),
        Expanded(
          child: Hero(
            tag: 'search_bar',
            child: Material(
              type: MaterialType.transparency,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: textTheme.bodyLarge?.copyWith(color: onSurfaceColor.withOpacity(0.54)),
                  filled: true,
                  fillColor: surfaceColor.withOpacity(0.16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onChanged: _performSearch,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- UPDATED SEARCH RESULTS BUILDER ---
  Widget _buildSearchResults() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final textTheme = Theme.of(context).textTheme;

    if (_searchResults.isEmpty) return Center(child: Text("No results found.", style: textTheme.bodyMedium?.copyWith(color: onSurfaceColor.withOpacity(0.38))));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(), // Bubbly scroller
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final res = _searchResults[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSearchItem(res),
        );
      },
    );
  }

  String _getCleanText(String content) {
    if (!content.startsWith('[')) return content;
    try {
      final List<dynamic> delta = jsonDecode(content);
      String plainText = "";
      for (var op in delta) {
        if (op.containsKey('insert') && op['insert'] is String) {
          plainText += op['insert'];
        }
      }
      return plainText.trim();
    } catch (_) {
      return content;
    }
  }

  Widget _buildSearchItem(GlobalSearchResult res) {
    switch (res.type) {
      case 'Note':
        final note = res.argument as Note;
        return NoteCard(
          note: note,
          isSelected: false,
          // Hero tag: note_background_${note.id}
          onTap: () async {
            await context.push(res.route, extra: note);
            if (mounted) setState(() {}); // Refresh if color/content changed
          },
          onCopy: () => _copyContent(_getCleanText(note.content)),
          onShare: () => _shareContent(_getCleanText(note.content)),
          onDelete: () => _deleteItem(res),
          onColorChanged: (newColor) {
            setState(() => note.colorValue = newColor.value);
            note.save();
          },
        );

      case 'Journal':
        final entry = res.argument as JournalEntry;
        return JournalCard(
          entry: entry,
          isSelected: false,
          // Hero tag: journal_bg_${entry.id}
          onTap: () async {
            await context.push(res.route, extra: entry);
            if (mounted) setState(() {});
          },
          onCopy: () => _copyContent(_getCleanText(entry.content)),
          onShare: () => _shareContent(_getCleanText(entry.content)),
          onDelete: () => _deleteItem(res),
          onColorChanged: (newColor) {
            setState(() => entry.colorValue = newColor.value);
            entry.save();
          },
        );

      case 'Clipboard':
        final item = res.argument as ClipboardItem;
        return ClipboardCard(
          item: item,
          isSelected: false,
          // Hero tag: clip_bg_${item.id}
          onTap: () async {
            await context.push(res.route, extra: item);
            if (mounted) setState(() {});
          },
          onCopy: () => _copyContent(_getCleanText(item.content)),
          onShare: () => _shareContent(_getCleanText(item.content)),
          onDelete: () => _deleteItem(res),
          onColorChanged: (newColor) {
            setState(() => item.colorValue = newColor.value);
            item.save();
          },
        );

      case 'Todo':
        final todo = res.argument as Todo;
        return TodoCard(
          todo: todo,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: todo);
            if (mounted) setState(() {});
          },
          onToggleDone: () {
            setState(() {
              todo.isDone = !todo.isDone;
              todo.save();
            });
          },
        );

      case 'Expense':
        final expense = res.argument as Expense;
        return ExpenseCard(
          expense: expense,
          isSelected: false,
          onTap: () async {
            await context.push(res.route, extra: expense);
            if (mounted) setState(() {});
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
