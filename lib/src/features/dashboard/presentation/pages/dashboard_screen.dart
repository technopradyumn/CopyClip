import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:home_widget/home_widget.dart';
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

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  bool _boxesOpened = false;
  List<String> _order = [];
  String? _draggedId;
  Offset? _dragPosition;
  final GlobalKey _gridKey = GlobalKey();
  late AnimationController _settingsAnimationController;

  final Map<String, FeatureItem> _features = {
    'notes': FeatureItem('notes', 'Notes', Icons.note_alt_outlined, Colors.amberAccent, AppRouter.notes, 'Create and manage your notes'),
    'todos': FeatureItem('todos', 'To-Dos', Icons.check_circle_outline, Colors.greenAccent, AppRouter.todos, 'Keep track of your tasks'),
    'expenses': FeatureItem('expenses', 'Finance', Icons.attach_money, Colors.redAccent, AppRouter.expenses, 'Monitor your expenses'),
    'journal': FeatureItem('journal', 'Journal', Icons.book_outlined, Colors.blueAccent, AppRouter.journal, 'Write down your thoughts'),
    'calendar': FeatureItem('calendar', 'Calendar', Icons.calendar_today_outlined, Colors.orangeAccent, AppRouter.calendar, 'Organize your schedule'),
    'clipboard': FeatureItem('clipboard', 'Clipboard', Icons.paste, Colors.purpleAccent, AppRouter.clipboard, 'Access your clipboard history'),
  };

  final Map<String, Color> featureColors = {
    'notes': Color(0xFFFF9A85),
    'todos': Color(0xFF82CFFD),
    'expenses': Color(0xFFFFB77B),
    'journal': Color(0xFF9B7DFF),
    'calendar': Color(0xFF7DE3A0),
    'clipboard': Color(0xFFFF92D0),
  };

  @override
  void initState() {
    super.initState();
    _settingsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _initHive();
  }

  @override
  void dispose() {
    _settingsAnimationController.dispose();
    super.dispose();
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

  void _onDragStart(String id, LongPressStartDetails details) {
    setState(() {
      _draggedId = id;
      _dragPosition = details.globalPosition;
    });
    HapticFeedback.mediumImpact();
  }

  void _onDragUpdate(LongPressMoveUpdateDetails details, double itemWidth, double itemHeight) {
    setState(() => _dragPosition = details.globalPosition);

    final RenderBox? box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset localPos = box.globalToLocal(details.globalPosition);
    int col = (localPos.dx / (itemWidth + 16)).floor().clamp(0, 1);
    int row = (localPos.dy / (itemHeight + 16)).floor().clamp(0, 2);

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

  void _onDragEnd() {
    setState(() {
      _draggedId = null;
      _dragPosition = null;
    });
    _saveOrder();
  }

  Future<void> _pinFeatureToHome(FeatureItem feature) async {
    final uri = Uri.parse('copyclip://${feature.id}');
    await HomeWidget.saveWidgetData<String>('title', feature.title);
    await HomeWidget.saveWidgetData<String>('description', feature.description);
    await HomeWidget.saveWidgetData<String>('deeplink', uri.toString());
    await HomeWidget.saveWidgetData<int>('color', feature.color.value);
    await HomeWidget.updateWidget(name: 'HomeWidgetProvider', androidName: 'HomeWidgetProvider');
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
        final double itemWidth = (constraints.maxWidth - 64) / 2;
        final double itemHeight = itemWidth * 1.1;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            key: _gridKey,
            height: (itemHeight + 16) * 3 + 100,
            child: Stack(
              children: [
                for (int i = 0; i < _order.length; i++)
                  _buildAnimatedItem(i, _order[i], itemWidth, itemHeight, theme),

                if (_draggedId != null && _dragPosition != null)
                  Positioned(
                    left: _dragPosition!.dx - 24 - (itemWidth / 2),
                    top: _dragPosition!.dy - 180 - (itemHeight / 2),
                    child: IgnorePointer(
                      child: SizedBox(
                        width: itemWidth,
                        height: itemHeight,
                        child: _buildFeatureCard(theme, _features[_draggedId]!, isDragging: true),
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
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutQuart,
      left: col * (width + 16),
      top: row * (height + 16),
      child: GestureDetector(
        onLongPressStart: (d) => _onDragStart(id, d),
        onLongPressMoveUpdate: (d) => _onDragUpdate(d, width, height),
        onLongPressEnd: (_) => _onDragEnd(),
        onTap: () => context.push(_features[id]!.route),
        child: SizedBox(
          width: width,
          height: height,
          child: isDragging
              ? Opacity(opacity: 0.0, child: _buildFeatureCard(theme, _features[id]!))
              : _buildFeatureCard(theme, _features[id]!),
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