import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/widgets/glass_dialog.dart';
import '../widgets/journal_card.dart';

enum JournalSortOption { custom, dateNewest, dateOldest, mood }

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // State
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  JournalSortOption _currentSort = JournalSortOption.custom;

  // Reordering
  List<JournalEntry> _reorderingList = [];
  bool _isReordering = false;

  // Daily Wisdom Quote
  final List<String> _quotes = [
    "The best way to predict the future is to create it.",
    "Wealth consists not in having great possessions, but in having few wants.",
    "Time is the ultimate currency.",
    "Success is not final, failure is not fatal.",
    "Focus on the solution, not the problem.",
    "Your network is your net worth."
  ];
  late String _dailyQuote;

  @override
  void initState() {
    super.initState();
    _dailyQuote = _quotes[Random().nextInt(_quotes.length)];
    if (!Hive.isBoxOpen('journal_box')) {
      Hive.openBox<JournalEntry>('journal_box');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Happy': return '😊';
      case 'Excited': return '🤩';
      case 'Neutral': return '😐';
      case 'Sad': return '😔';
      case 'Stressed': return '😫';
      default: return '😐';
    }
  }

  String _formatJournalForExport(JournalEntry entry) {
    // Extract clean text from JSON Delta
    String body = "";
    try {
      final List<dynamic> delta = jsonDecode(entry.content);
      for (var op in delta) {
        if (op is Map && op.containsKey('insert') && op['insert'] is String) {
          body += op['insert'];
        }
      }
    } catch (e) {
      body = entry.content; // Fallback
    }

    final dateStr = DateFormat('EEEE, MMM dd, yyyy').format(entry.date);
    final tagsStr = entry.tags.isNotEmpty ? "\nTags: #${entry.tags.join(' #')}" : "";

    // RETURN CLEAN FORMATTED TEXT
    return "📅 $dateStr\n"
        "Mood: ${_getMoodEmoji(entry.mood)} ${entry.mood}\n\n"
        "TITLE: ${entry.title}\n"
        "--------------------------\n"
        "${body.trim()}\n"
        "$tagsStr";
  }

  void _copyEntry(JournalEntry entry) {
    final text = _formatJournalForExport(entry);
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Journal entry copied (clean text)"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.surface,
        )
    );
  }

  void _shareEntry(JournalEntry entry) {
    final text = _formatJournalForExport(entry);
    Share.share(text);
  }

  // REFACTORED: Soft delete for single entry
  void _confirmDeleteEntry(JournalEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move Entry to Recycle Bin?",
        content: "You can restore this entry later from settings.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          entry.isDeleted = true;
          entry.deletedAt = DateTime.now();
          entry.save();
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _toggleSelection(String id) => setState(() => _selectedIds.contains(id) ? _selectedIds.remove(id) : _selectedIds.add(id));

  void _selectAllToggle(List<JournalEntry> entries) {
    setState(() {
      final allActiveIds = entries.where((e) => !e.isDeleted).map((e) => e.id).toSet();
      if (_selectedIds.length == allActiveIds.length) {
        _selectedIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedIds.addAll(allActiveIds);
        _isSelectionMode = true;
      }
    });
  }

  // REFACTORED: Soft delete for selected entries
  void _deleteSelected() {
    if (_selectedIds.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move ${_selectedIds.length} Entries to Bin?",
        content: "You can restore them later from settings.",
        confirmText: "Move",
        isDestructive: true,
        onConfirm: () {
          final box = Hive.box<JournalEntry>('journal_box');
          final now = DateTime.now();
          final entriesToSoftDelete = box.values
              .where((e) => !e.isDeleted && _selectedIds.contains(e.id))
              .toList();

          for (var entry in entriesToSoftDelete) {
            entry.isDeleted = true;
            entry.deletedAt = now;
            entry.save();
          }

          setState(() { _selectedIds.clear(); _isSelectionMode = false; });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  // REFACTORED: Soft delete for all entries
  void _deleteAll() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Move All Entries to Bin?",
        content: "This will move all active entries to the recycle bin.",
        confirmText: "Move All",
        isDestructive: true,
        onConfirm: () {
          final box = Hive.box<JournalEntry>('journal_box');
          final now = DateTime.now();
          final activeEntries = box.values.where((e) => !e.isDeleted).toList();

          for (var entry in activeEntries) {
            entry.isDeleted = true;
            entry.deletedAt = now;
            entry.save();
          }

          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _openEditor(JournalEntry? entry) {
    if (_isSelectionMode) {
      if (entry != null) _toggleSelection(entry.id);
      return;
    }
    context.push('/journal/edit', extra: entry);
  }

  // --- Logic: Reorder ---
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

    if (mounted) Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isReordering = false);
    });
  }

  void _showFilterMenu() {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
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
            Text("Sort By", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildSortOption(JournalSortOption.custom, "Custom Order (Drag & Drop)"),
            _buildSortOption(JournalSortOption.dateNewest, "Newest First"),
            _buildSortOption(JournalSortOption.dateOldest, "Oldest First"),
            _buildSortOption(JournalSortOption.mood, "Group by Mood"),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(JournalSortOption option, String label) {
    final selected = _currentSort == option;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: selected ? primaryColor : onSurfaceColor.withOpacity(0.54)),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selected ? onSurfaceColor : onSurfaceColor.withOpacity(0.7))),
      onTap: () {
        setState(() => _currentSort = option);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) { setState(() { _isSelectionMode = false; _selectedIds.clear(); }); return false; }
        return true;
      },
      child: GlassScaffold(
        title: null,
        floatingActionButton: _isSelectionMode ? null : FloatingActionButton(
          onPressed: () => _openEditor(null),
          backgroundColor: primaryColor, // Use theme primary
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        ),
        body: Column(
          children: [
            _buildTopBar(),
            if (!_isSelectionMode && _searchQuery.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  opacity: 0.1, // Adjusted opacity for consistency
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: Colors.amberAccent, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _dailyQuote,
                          style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.7), fontStyle: FontStyle.italic),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 8),
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  style: textTheme.bodyMedium?.copyWith(color: onSurfaceColor),
                  decoration: InputDecoration(
                    hintText: 'Search memories...',
                    hintStyle: textTheme.bodyMedium?.copyWith(color: onSurfaceColor.withOpacity(0.54)),
                    prefixIcon: Icon(Icons.search, color: onSurfaceColor.withOpacity(0.54), size: 20),
                    suffixIcon: _searchQuery.isNotEmpty ? GestureDetector(onTap: () { _searchController.clear(); setState(() => _searchQuery = ''); }, child: Icon(Icons.close, color: onSurfaceColor.withOpacity(0.54), size: 18)) : null,
                    filled: true,
                    fillColor: onSurfaceColor.withOpacity(0.08),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value.trim().toLowerCase()),
                ),
              ),
            ),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<JournalEntry>('journal_box').listenable(),
                builder: (_, Box<JournalEntry> box, __) {
                  List<JournalEntry> entries;
                  // ADDED FILTER: Filter out deleted items
                  final activeEntries = box.values.where((e) => !e.isDeleted).toList().cast<JournalEntry>();

                  if (_isReordering) {
                    entries = _reorderingList;
                  } else {
                    entries = activeEntries;
                    if (_searchQuery.isNotEmpty) {
                      entries = entries.where((e) =>
                      e.title.toLowerCase().contains(_searchQuery) ||
                          e.content.toLowerCase().contains(_searchQuery) ||
                          e.tags.any((tag) => tag.toLowerCase().contains(_searchQuery))
                      ).toList();
                    }

                    switch (_currentSort) {
                      case JournalSortOption.dateNewest: entries.sort((a, b) => b.date.compareTo(a.date)); break;
                      case JournalSortOption.dateOldest: entries.sort((a, b) => a.date.compareTo(b.date)); break;
                      case JournalSortOption.mood: entries.sort((a, b) => a.mood.compareTo(b.mood)); break;
                      case JournalSortOption.custom: entries.sort((a, b) => a.sortIndex.compareTo(b.sortIndex)); break;
                    }
                    _reorderingList = List.from(entries);
                  }

                  if (entries.isEmpty) return Center(child: Text("Start writing your story.", style: textTheme.bodyMedium?.copyWith(color: onSurfaceColor.withOpacity(0.38))));

                  final canReorder = _currentSort == JournalSortOption.custom && _searchQuery.isEmpty && !_isSelectionMode;

                  return ReorderableListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: entries.length,
                    onReorder: canReorder ? _onReorder : (a, b) {},
                    buildDefaultDragHandles: canReorder,

                    proxyDecorator: (child, index, animation) => AnimatedBuilder(animation: animation, builder: (_, __) => Transform.scale(scale: 1.05, child: Material(color: Colors.transparent, child: child))),

                    itemBuilder: (_, index) {
                      final entry = entries[index];
                      final selected = _selectedIds.contains(entry.id);

                      return Container(
                        key: ValueKey(entry.id),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: JournalCard(
                          entry: entry,
                          isSelected: selected,
                          onTap: () => _isSelectionMode ? _toggleSelection(entry.id) : _openEditor(entry),
                          onCopy: () => _copyEntry(entry),
                          onShare: () => _shareEntry(entry),
                          onDelete: () => _confirmDeleteEntry(entry),
                          // NEW COLOR PICKER LOGIC
                          onColorChanged: (newColor) {
                            setState(() {
                              entry.colorValue = newColor.value;
                            });
                            entry.save(); // Save immediately to Hive
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

  Widget _buildTopBar() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final errorColor = Theme.of(context).colorScheme.error;
    final iconTheme = Theme.of(context).iconTheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isSelectionMode ? Icons.close : Icons.arrow_back_ios_new, color: iconTheme.color),
            onPressed: () {
              if(_isSelectionMode) {
                setState(() { _isSelectionMode = false; _selectedIds.clear(); });
              } else {
                context.pop();
              }
            },
          ),
          Expanded(
            child: _isSelectionMode
                ? Center(child: Text('${_selectedIds.length} Selected', style: textTheme.titleLarge))
                : Row(
              children: [
                const Hero(tag: 'journal_icon', child: Icon(Icons.book_outlined, size: 32, color: Colors.blueAccent)), // Keeping accent color for Hero consistency, but theme color should be used elsewhere
                const SizedBox(width: 10),
                Hero(tag: 'journal_title', child: Material(type: MaterialType.transparency, child: Text("Journal", style: textTheme.titleLarge?.copyWith(fontSize: 28, color: primaryColor)))),
              ],
            ),
          ),
          if (_isSelectionMode) ...[
            IconButton(
                icon: Icon(Icons.select_all, color: onSurfaceColor),
                onPressed: () => _selectAllToggle(Hive.box<JournalEntry>('journal_box').values.toList())
            ),
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
}