import 'dart:convert';
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

  List<ClipboardItem> _reorderingList = [];
  bool _isReordering = false;
  bool _isCheckingClipboard = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchSystemClipboard();
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
    if (_isCheckingClipboard) return;
    _isCheckingClipboard = true;

    try {
      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      String? content = data?.text;

      if (content != null && content.trim().isNotEmpty) {
        final box = Hive.box<ClipboardItem>('clipboard_box');
        bool exists = box.values.any((item) => !item.isDeleted && item.content.trim() == content.trim());

        if (!exists) {
          final newItem = ClipboardItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: content.trim(),
            createdAt: DateTime.now(),
            type: _detectType(content),
            sortIndex: -1,
          );
          await box.put(newItem.id, newItem);
          if (mounted) setState(() {});
        }
      }
    } finally {
      _isCheckingClipboard = false;
    }
  }

  String _detectType(String text) {
    if (text.startsWith('http')) return 'link';
    if (RegExp(r'^\+?[0-9]{7,15}$').hasMatch(text)) return 'phone';
    return 'text';
  }

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    setState(() {
      _isReordering = true;
      final item = _reorderingList.removeAt(oldIndex);
      _reorderingList.insert(newIndex, item);
    });

    for (int i = 0; i < _reorderingList.length; i++) {
      _reorderingList[i].sortIndex = i;
      _reorderingList[i].save();
    }

    if (mounted) setState(() => _isReordering = false);
  }

  void _confirmDelete(ClipboardItem item) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move to Recycle Bin?",
        content: "You can restore it later from settings.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          item.isDeleted = true;
          item.deletedAt = DateTime.now();
          item.save();
        },
      ),
    );
  }

  void _deleteSelected() {
    if (_selectedIds.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move ${_selectedIds.length} Items to Bin?",
        content: "You can restore them later from settings.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          final box = Hive.box<ClipboardItem>('clipboard_box');
          final now = DateTime.now();
          for (var id in _selectedIds) {
            final item = box.get(id);
            if (item != null) {
              item.isDeleted = true;
              item.deletedAt = now;
              item.save();
            }
          }
          setState(() {
            _selectedIds.clear();
            _isSelectionMode = false;
          });
        },
      ),
    );
  }

  void _deleteAll() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move All to Bin?",
        content: "This will move all active clips to the recycle bin.",
        confirmText: "Move All",
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(ctx);
          final box = Hive.box<ClipboardItem>('clipboard_box');
          final now = DateTime.now();
          final activeItems = box.values.where((e) => !e.isDeleted).toList();
          for (var item in activeItems) {
            item.isDeleted = true;
            item.deletedAt = now;
            item.save();
          }
        },
      ),
    );
  }

  String _getCleanText(String content) {
    if (!content.startsWith('[')) return content;
    try {
      final List<dynamic> delta = jsonDecode(content);
      String plainText = "";
      for (var op in delta) {
        if (op is Map && op.containsKey('insert') && op['insert'] is String) {
          plainText += op['insert'];
        }
      }
      return plainText.trim();
    } catch (_) { return content; }
  }

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

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
          onPressed: () => context.push(AppRouter.clipboardEdit),
          backgroundColor: primaryColor,
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        ),
        body: Column(
          children: [
            _buildTopBar(),
            _buildSearchBar(onSurfaceColor),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<ClipboardItem>('clipboard_box').listenable(),
                builder: (context, Box<ClipboardItem> box, _) {
                  List<ClipboardItem> items;
                  final activeItems = box.values.where((e) => !e.isDeleted).toList().cast<ClipboardItem>();

                  if (_isReordering) {
                    items = _reorderingList;
                  } else {
                    items = activeItems;
                    if (_searchQuery.isNotEmpty) {
                      items = items.where((i) => i.content.toLowerCase().contains(_searchQuery)).toList();
                    }

                    switch (_currentSort) {
                      case ClipSortOption.dateNewest:
                        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                        break;
                      case ClipSortOption.dateOldest:
                        items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                        break;
                      case ClipSortOption.contentAZ:
                        items.sort((a, b) => a.content.toLowerCase().compareTo(b.content.toLowerCase()));
                        break;
                      case ClipSortOption.custom:
                        items.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
                        break;
                      default: break;
                    }
                    _reorderingList = List.from(items);
                  }

                  if (items.isEmpty) return Center(child: Text("No items found.", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onSurfaceColor.withOpacity(0.3))));

                  final canReorder = _currentSort == ClipSortOption.custom && _searchQuery.isEmpty;

                  return ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    physics: const BouncingScrollPhysics(),
                    cacheExtent: 1000,
                    itemCount: items.length,
                    onReorder: canReorder ? _onReorder : (a, b) {},
                    buildDefaultDragHandles: false,
                    proxyDecorator: (child, index, animation) => AnimatedBuilder(
                        animation: animation,
                        builder: (_, __) => Transform.scale(scale: 1.02, child: Material(color: Colors.transparent, child: child))
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(item.id),
                        index: index,
                        enabled: canReorder,
                        child: ClipboardCard(
                          item: item,
                          isSelected: _selectedIds.contains(item.id),
                          onTap: () => _isSelectionMode
                              ? setState(() => _selectedIds.contains(item.id) ? _selectedIds.remove(item.id) : _selectedIds.add(item.id))
                              : context.push(AppRouter.clipboardEdit, extra: item),
                          onCopy: () {
                            Clipboard.setData(ClipboardData(text: _getCleanText(item.content)));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied!")));
                          },
                          onShare: () => Share.share(_getCleanText(item.content)),
                          onDelete: () => _confirmDelete(item),
                          onColorChanged: (newColor) {
                            setState(() => item.colorValue = newColor.value);
                            item.save();
                          },
                        ),
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

  Widget _buildSearchBar(Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 44,
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Search clips...',
            prefixIcon: Icon(Icons.search, color: onSurface.withOpacity(0.4), size: 20),
            filled: true,
            fillColor: onSurface.withOpacity(0.08),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final errorColor = Theme.of(context).colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isSelectionMode ? Icons.close : Icons.arrow_back_ios_new),
            onPressed: () {
              if (_isSelectionMode) {
                setState(() { _isSelectionMode = false; _selectedIds.clear(); });
              } else {
                context.pop();
              }
            },
          ),
          Expanded(
            child: _isSelectionMode
                ? Center(child: Text('${_selectedIds.length} Selected', style: Theme.of(context).textTheme.titleLarge))
                : Row(
              children: [
                Hero(tag: 'clipboard_icon', child: Icon(Icons.paste, color: primaryColor, size: 24)),
                const SizedBox(width: 10),
                Hero(tag: 'clipboard_title', child: Material(type: MaterialType.transparency, child: Text("Clipboard", style: Theme.of(context).textTheme.titleLarge))),
              ],
            ),
          ),
          if (_isSelectionMode) ...[
            IconButton(icon: const Icon(Icons.select_all), onPressed: () {
              final box = Hive.box<ClipboardItem>('clipboard_box');
              final activeIds = box.values.where((e) => !e.isDeleted).map((e) => e.id).toSet();
              setState(() => _selectedIds.addAll(activeIds));
            }),
            IconButton(icon: Icon(Icons.delete, color: errorColor), onPressed: _deleteSelected),
          ] else ...[
            IconButton(icon: Icon(Icons.check_circle_outline, color: onSurfaceColor.withOpacity(0.5)), onPressed: () => setState(() => _isSelectionMode = true)),
            IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterMenu),
            IconButton(icon: Icon(Icons.delete_sweep_outlined, color: errorColor), onPressed: _deleteAll),
          ]
        ],
      ),
    );
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
    return ListTile(
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: selected ? Theme.of(context).colorScheme.primary : null),
      title: Text(label),
      onTap: () {
        setState(() => _currentSort = option);
        Navigator.pop(context);
      },
    );
  }
}