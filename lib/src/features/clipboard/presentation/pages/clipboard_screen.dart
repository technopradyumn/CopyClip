import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../data/clipboard_model.dart';
import '../widgets/clipboard_card.dart';

enum ClipSortOption { custom, dateNewest, dateOldest, contentAZ, contentZA }

class ClipboardScreen extends StatefulWidget {
  const ClipboardScreen({super.key});

  @override
  State<ClipboardScreen> createState() => _ClipboardScreenState();
}

class _ClipboardScreenState extends State<ClipboardScreen> with WidgetsBindingObserver {
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  ClipSortOption _currentSort = ClipSortOption.custom;
  List<ClipboardItem> _items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSystemClipboard();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchSystemClipboard();
    }
  }

  Future<void> _fetchSystemClipboard() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    String? content = data?.text;

    if (content != null && content.trim().isNotEmpty) {
      final box = Hive.box<ClipboardItem>('clipboard_box');
      bool exists = box.values.any((item) => item.content.trim() == content.trim());

      if (!exists) {
        final allItems = box.values.toList();
        final Map<String, ClipboardItem> updates = {};

        // Push everything down
        for (var item in allItems) {
          item.sortIndex += 1;
          updates[item.id] = item;
        }

        final newItem = ClipboardItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content.trim(),
          createdAt: DateTime.now(),
          type: _detectType(content),
          sortIndex: 0,
        );
        updates[newItem.id] = newItem;

        // Batch write for performance and reliability
        await box.putAll(updates);
        if (mounted) setState(() {});
      }
    }
  }

  String _detectType(String text) {
    if (text.startsWith('http')) return 'link';
    if (RegExp(r'^\+?[0-9]{7,15}$').hasMatch(text)) return 'phone';
    return 'text';
  }

  // --- REORDER LOGIC: BATCH UPDATE ---
  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;

    setState(() {
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });

    final box = Hive.box<ClipboardItem>('clipboard_box');
    final Map<String, ClipboardItem> updates = {};

    for (int i = 0; i < _items.length; i++) {
      _items[i].sortIndex = i;
      updates[_items[i].id] = _items[i];
    }

    await box.putAll(updates);
  }

  void _copyItem(ClipboardItem item) {
    Clipboard.setData(ClipboardData(text: item.content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Copied to clipboard",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _selectAll(List<ClipboardItem> items) {
    setState(() {
      final ids = items.map((e) => e.id).toSet();
      if (_selectedIds.containsAll(ids)) {
        _selectedIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedIds.addAll(ids);
      }
    });
  }

  // --- DELETE LOGIC START ---

  // Single Item Delete (Triggered from Card)
  void _deleteItem(ClipboardItem item) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete Clip?",
        content: "This action cannot be undone.",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () {
          Hive.box<ClipboardItem>('clipboard_box').delete(item.id);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  // Bulk Delete (Triggered from Top Bar)
  void _deleteSelected() {
    if (_selectedIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Delete ${_selectedIds.length} Clips?",
        content: "This action cannot be undone.",
        confirmText: "Delete",
        isDestructive: true,
        onConfirm: () {
          final box = Hive.box<ClipboardItem>('clipboard_box');
          for (var id in _selectedIds) {
            box.delete(id);
          }
          setState(() {
            _selectedIds.clear();
            _isSelectionMode = false;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  // Delete All (Triggered from Top Bar)
  void _deleteAll() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Clear History?",
        content: "This will delete all clipboard items forever.",
        confirmText: "Delete All",
        isDestructive: true,
        onConfirm: () {
          Hive.box<ClipboardItem>('clipboard_box').clear();
          Navigator.pop(ctx);
        },
      ),
    );
  }
  // --- DELETE LOGIC END ---

  void _showFilterMenu() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Use theme titleLarge
            Text("Sort By", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildSortOption(ClipSortOption.custom, "Custom Order (Drag)"),
            _buildSortOption(ClipSortOption.dateNewest, "Newest First"),
            _buildSortOption(ClipSortOption.dateOldest, "Oldest First"),
            _buildSortOption(ClipSortOption.contentAZ, "Content: A-Z"),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(ClipSortOption option, String label) {
    final selected = _currentSort == option;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? primaryColor : onSurfaceColor.withOpacity(0.54),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: selected ? onSurfaceColor : onSurfaceColor.withOpacity(0.7),
        ),
      ),
      onTap: () {
        setState(() => _currentSort = option);
        Navigator.pop(context);
      },
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24 && date.day == now.day) return '${diff.inHours}h ago';
    return DateFormat('MMM dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final errorColor = Theme.of(context).colorScheme.error;

    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          setState(() { _isSelectionMode = false; _selectedIds.clear(); });
          return false;
        }
        return true;
      },
      child: GlassScaffold(
        title: null,
        floatingActionButton: _isSelectionMode ? null : FloatingActionButton(
          onPressed: () async {
            await context.push(AppRouter.clipboardEdit, extra: null);
            if (mounted) setState(() {});
          },
          // Use theme primary/onPrimary
          backgroundColor: primaryColor,
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        ),
        body: Column(
          children: [
            _buildTopBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                  // Use theme text style
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search clips...',
                    // Use theme text style for hint
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: onSurfaceColor.withOpacity(0.54),
                    ),
                    // Use theme icon color
                    prefixIcon: Icon(Icons.search, color: onSurfaceColor.withOpacity(0.54), size: 20),
                    filled: true,
                    // Use onSurface with opacity for fill color
                    fillColor: onSurfaceColor.withOpacity(0.08),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<ClipboardItem>('clipboard_box').listenable(),
                builder: (context, Box<ClipboardItem> box, _) {
                  _items = box.values.toList().cast<ClipboardItem>();

                  if (_currentSort == ClipSortOption.custom) {
                    _items.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
                  } else if (_currentSort == ClipSortOption.dateNewest) {
                    _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  } else if (_currentSort == ClipSortOption.dateOldest) {
                    _items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  } else if (_currentSort == ClipSortOption.contentAZ) {
                    _items.sort((a, b) => a.content.toLowerCase().compareTo(b.content.toLowerCase()));
                  }

                  if (_searchQuery.isNotEmpty) {
                    _items = _items.where((i) => i.content.toLowerCase().contains(_searchQuery)).toList();
                  }

                  if (_items.isEmpty) return Center(child: Text(
                      "History empty",
                      // Use theme bodySmall for fallback text
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: onSurfaceColor.withOpacity(0.24)
                      )
                  ));

                  final canReorder = _currentSort == ClipSortOption.custom && _searchQuery.isEmpty;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return ReorderableListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _items.length,
                        onReorder: canReorder ? _onReorder : (a, b) {},
                        buildDefaultDragHandles: canReorder,
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        proxyDecorator: (child, index, animation) => AnimatedBuilder(animation: animation, builder: (_, __) => Transform.scale(scale: 1.05, child: Material(color: Colors.transparent, child: child))),

                        itemBuilder: (context, index) {
                          final item = _items[index];
                          final selected = _selectedIds.contains(item.id);

                          // --- REPLACED INLINE UI WITH ClipboardCard ---
                          return Container(
                            key: ValueKey(item.id),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ClipboardCard(
                              item: item,
                              isSelected: selected,
                              onTap: () async {
                                if (_isSelectionMode) {
                                  setState(() => _selectedIds.contains(item.id) ? _selectedIds.remove(item.id) : _selectedIds.add(item.id));
                                  if (_selectedIds.isEmpty) _isSelectionMode = false;
                                } else {
                                  await context.push(AppRouter.clipboardEdit, extra: item);
                                  if (mounted) setState(() {});
                                }
                              },
                              onLongPress: !canReorder
                                  ? () => setState(() { _isSelectionMode = true; _selectedIds.add(item.id); })
                                  : null,
                              onCopy: () => _copyItem(item),
                              onShare: () => Share.share(item.content),
                              onDelete: () => _deleteItem(item), // Hook up single delete here
                            ),
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

  Widget _buildTopBar() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final errorColor = Theme.of(context).colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            // Relying on default IconTheme
              icon: Icon(_isSelectionMode ? Icons.close : Icons.arrow_back_ios_new, color: Theme.of(context).iconTheme.color),
              onPressed: () => _isSelectionMode ? setState(() { _isSelectionMode = false; _selectedIds.clear(); }) : context.pop()),
          Expanded(
            child: _isSelectionMode
                ? Center(
              // Use theme titleLarge style
                child: Text(
                    '${_selectedIds.length} Selected',
                    style: Theme.of(context).textTheme.titleLarge
                ))
                : Row(
              children: [
                // Use theme primary color for main icon
                Hero(tag: 'clipboard_icon', child: Icon(Icons.paste, color: primaryColor, size: 24)),
                const SizedBox(width: 10),
                Hero(
                  tag: 'clipboard_title',
                  child: Material(
                      type: MaterialType.transparency,
                      // Use theme titleLarge style
                      child: Text("Clipboard", style: Theme.of(context).textTheme.titleLarge)
                  ),
                ),
              ],
            ),
          ),
          if (_isSelectionMode) ...[
            IconButton(icon: Icon(Icons.select_all, color: onSurfaceColor), onPressed: () => _selectAll(_items)),
            IconButton(icon: Icon(Icons.delete, color: errorColor), onPressed: _deleteSelected),
          ] else ...[
            IconButton(icon: Icon(Icons.check_circle_outline, color: onSurfaceColor.withOpacity(0.54)), onPressed: () => setState(() => _isSelectionMode = true)),
            IconButton(icon: Icon(Icons.filter_list, color: onSurfaceColor), onPressed: _showFilterMenu),
            IconButton(icon: Icon(Icons.delete_sweep_outlined, color: errorColor), onPressed: _deleteAll),
          ]
        ],
      ),
    );
  }

  Widget _getTypeIcon(String type) {
    IconData icon;
    switch (type) {
      case 'link': icon = Icons.link; break;
      case 'phone': icon = Icons.phone; break;
      default: icon = Icons.notes;
    }
    // Use theme primary color with opacity
    return Icon(icon, color: Theme.of(context).colorScheme.primary.withOpacity(0.5), size: 20);
  }
}