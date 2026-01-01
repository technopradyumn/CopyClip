import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';

import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';

class FeatureItem {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final String description;

  FeatureItem(this.id, this.title, this.icon, this.color, this.route, this.description);
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

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  bool _boxesOpened = false;
  List<String> _order = [];

  // Drag & Drop State
  String? _draggedId;
  Offset? _dragPosition; // Local coordinates relative to the scrollable content
  Offset? _lastGlobalPosition; // Global screen coordinates for auto-scroll check
  final GlobalKey _gridKey = GlobalKey();

  // Scrolling State
  late ScrollController _scrollController;
  Timer? _autoScrollTimer;

  late AnimationController _settingsAnimationController;
  late AnimationController _entryAnimationController;

  final Map<String, FeatureItem> _features = {
    'notes': FeatureItem('notes', 'Notes', Icons.note_alt_outlined, Colors.amberAccent, AppRouter.notes, 'Create and manage your notes'),
    'todos': FeatureItem('todos', 'To-Dos', Icons.check_circle_outline, Colors.greenAccent, AppRouter.todos, 'Keep track of your tasks'),
    'expenses': FeatureItem('expenses', 'Finance', Icons.attach_money, Colors.redAccent, AppRouter.expenses, 'Monitor your expenses'),
    'journal': FeatureItem('journal', 'Journal', Icons.book_outlined, Colors.blueAccent, AppRouter.journal, 'Write down your thoughts'),
    'calendar': FeatureItem('calendar', 'Calendar', Icons.calendar_today_outlined, Colors.orangeAccent, AppRouter.calendar, 'Organize your schedule'),
    'clipboard': FeatureItem('clipboard', 'Clipboard', Icons.paste, Colors.purpleAccent, AppRouter.clipboard, 'Access your clipboard history'),
    'canvas': FeatureItem('canvas', 'Canvas', Icons.gesture, Colors.tealAccent, AppRouter.canvas, 'Draw and sketch freely'),
  };

  final Map<String, Color> featureColors = {
    'notes': const Color(0xFFFF9A85),
    'todos': const Color(0xFF82CFFD),
    'expenses': const Color(0xFFFFB77B),
    'journal': const Color(0xFF9B7DFF),
    'calendar': const Color(0xFF7DE3A0),
    'clipboard': const Color(0xFFFF92D0),
    'canvas': const Color(0xFF4DB6AC),
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _settingsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _entryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _entryAnimationController.forward();
    _initHive();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _autoScrollTimer?.cancel();
    _settingsAnimationController.dispose();
    _entryAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initHive() async {
    if (!Hive.isBoxOpen('settings')) await Hive.openBox('settings');
    // Ensure other boxes are open as needed...
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
          _order = List<String>.from(savedOrder);
          for (var key in _features.keys) {
            if (!_order.contains(key)) _order.add(key);
          }
        } else {
          _order = _features.keys.toList();
        }
        _boxesOpened = true;
      });
    }
  }

  void _saveOrder() {
    Hive.box('settings').put('dashboard_order', _order);
  }

  // --- Drag & Drop Logic ---

  void _onDragStart(String id, LongPressStartDetails details) {
    final RenderBox? box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final Offset localPos = box.globalToLocal(details.globalPosition);
      setState(() {
        _draggedId = id;
        _dragPosition = localPos;
        _lastGlobalPosition = details.globalPosition;
      });
      HapticFeedback.mediumImpact();

      // Start auto-scroll check loop
      _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 16), _checkForAutoScroll);
    }
  }

  void _onDragUpdate(LongPressMoveUpdateDetails details) {
    final RenderBox? box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset localPos = box.globalToLocal(details.globalPosition);
    setState(() {
      _dragPosition = localPos;
      _lastGlobalPosition = details.globalPosition;
    });

    _handleReorder(localPos);
  }

  void _onDragEnd() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    setState(() {
      _draggedId = null;
      _dragPosition = null;
      _lastGlobalPosition = null;
    });
    _saveOrder();
  }

  // --- Auto-Scroll & Reorder Logic ---

  void _checkForAutoScroll(Timer timer) {
    if (_lastGlobalPosition == null || _draggedId == null) return;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double topThreshold = 150.0; // Distance from top to trigger scroll
    final double bottomThreshold = screenHeight - 150.0; // Distance from bottom
    final double scrollSpeed = 10.0; // Pixels per frame

    double scrollDelta = 0;

    if (_lastGlobalPosition!.dy < topThreshold) {
      // Scroll Up
      scrollDelta = -scrollSpeed;
    } else if (_lastGlobalPosition!.dy > bottomThreshold) {
      // Scroll Down
      scrollDelta = scrollSpeed;
    }

    if (scrollDelta != 0) {
      final double newOffset = (_scrollController.offset + scrollDelta)
          .clamp(0.0, _scrollController.position.maxScrollExtent);

      if (newOffset != _scrollController.offset) {
        _scrollController.jumpTo(newOffset);

        // Update local drag position because the content moved
        final RenderBox? box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          final Offset localPos = box.globalToLocal(_lastGlobalPosition!);
          setState(() {
            _dragPosition = localPos;
          });
          _handleReorder(localPos);
        }
      }
    }
  }

  void _handleReorder(Offset localPos) {
    // Calculate Grid Metrics dynamically
    final double gridWidth = MediaQuery.of(context).size.width - 48; // Padding 24 * 2
    final double itemWidth = (gridWidth - 16) / 2; // Spacing 16
    final double itemHeight = itemWidth * 1.1;

    final int maxRows = (_order.length / 2).ceil();

    int col = (localPos.dx / (itemWidth + 16)).floor().clamp(0, 1);
    int row = (localPos.dy / (itemHeight + 16)).floor().clamp(0, maxRows - 1);

    int newIndex = (row * 2 + col).clamp(0, _order.length - 1);
    int oldIndex = _order.indexOf(_draggedId!);

    if (newIndex != oldIndex) {
      setState(() {
        final item = _order.removeAt(oldIndex);
        _order.insert(newIndex, item);
      });
      HapticFeedback.lightImpact();
    }
  }

  // --- UI Components ---

  Future<void> _pinFeatureToHome(FeatureItem feature) async {
    final uri = Uri.parse('copyclip://${feature.id}');
    await HomeWidget.saveWidgetData<String>('title', feature.title);
    await HomeWidget.saveWidgetData<String>('description', feature.description);
    await HomeWidget.saveWidgetData<String>('deeplink', uri.toString());
    await HomeWidget.saveWidgetData<int>('color', feature.color.value);
    await HomeWidget.updateWidget(name: 'HomeWidgetProvider', androidName: 'HomeWidgetProvider');
  }

  Widget _buildBouncingItemWrapper(int index, Widget child) {
    return AnimatedBuilder(
      animation: _entryAnimationController,
      builder: (context, child) {
        final double start = (index * 0.1).clamp(0.0, 0.8);
        final double end = (start + 0.5).clamp(0.0, 1.0);

        final animation = CurvedAnimation(
          parent: _entryAnimationController,
          curve: Interval(start, end, curve: Curves.elasticOut),
        );

        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildFeatureCard(ThemeData theme, FeatureItem item, {bool isDragging = false}) {
    final Color baseColor = featureColors[item.id] ?? item.color;

    return GlassContainer(
      color: baseColor.withOpacity(0.15),
      opacity: isDragging ? 0.3 : 0.15,
      blur: 20,
      borderRadius: 32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: '${item.id}_icon',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    baseColor.withOpacity(0.6),
                    baseColor.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                item.icon,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Hero(
            tag: '${item.id}_title',
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                item.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Dashboard", style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text("Manage your day", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5))),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: primaryColor.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)
                    ],
                  ),
                  child: Icon(Icons.search_rounded, color: primaryColor),
                ),
                onPressed: () => context.push(AppRouter.globalSearch),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Hero(
                  tag: 'settings_icon',
                  child: RotationTransition(
                    turns: _settingsAnimationController,
                    child: Icon(
                      Icons.settings_outlined,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                onPressed: () {
                  _settingsAnimationController.forward(from: 0.0);
                  context.push(AppRouter.settings);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReorderableGrid(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - 64) / 2; // 64 = 24 padding left + 24 right + 16 spacing
        final double itemHeight = itemWidth * 1.1;

        final int rowCount = (_order.length / 2).ceil();
        final double totalHeight = (itemHeight + 16) * rowCount + 100; // Extra bottom padding

        return SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            key: _gridKey,
            height: totalHeight,
            child: Stack(
              children: [
                // Render items in order
                for (int i = 0; i < _order.length; i++)
                  _buildAnimatedItem(i, _order[i], itemWidth, itemHeight, theme),

                // Render the dragged item overlay
                if (_draggedId != null && _dragPosition != null)
                  Positioned(
                    left: _dragPosition!.dx - (itemWidth / 2),
                    top: _dragPosition!.dy - (itemHeight / 2),
                    child: IgnorePointer(
                      child: SizedBox(
                        width: itemWidth,
                        height: itemHeight,
                        child: Transform.scale(
                          scale: 1.1,
                          child: _buildFeatureCard(theme, _features[_draggedId]!, isDragging: true),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedItem(int index, String id, double width, double height, ThemeData theme) {
    final isDragging = id == _draggedId;
    final int col = index % 2;
    final int row = index ~/ 2;

    return AnimatedPositioned(
      // Animation when items switch places
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      left: col * (width + 16),
      top: row * (height + 16),
      child: GestureDetector(
        onLongPressStart: (d) => _onDragStart(id, d),
        onLongPressMoveUpdate: (d) => _onDragUpdate(d),
        onLongPressEnd: (_) => _onDragEnd(),
        onTap: () {
          final route = _features[id]?.route;
          if (route != null) {
            context.push(route);
          }
        },
        child: _buildBouncingItemWrapper(
          index,
          SizedBox(
            width: width,
            height: height,
            child: isDragging
                ? Opacity(opacity: 0.0, child: _buildFeatureCard(theme, _features[id]!))
                : _buildFeatureCard(theme, _features[id]!),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!_boxesOpened) return const GlassScaffold(body: Center(child: CircularProgressIndicator()));

    return GlassScaffold(
      body: Column(
        children: [
          _buildTopHeader(theme),
          Expanded(child: _buildReorderableGrid(theme)),
        ],
      ),
    );
  }
}