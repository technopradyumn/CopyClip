import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:intl/intl.dart';

import '../../data/canvas_adapter.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Favorites', 'Sketches', 'Ideas', 'Wireframes'];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBouncingItem(int index, Widget child) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double start = (index * 0.1).clamp(0.0, 0.8);
        final double end = (start + 0.4).clamp(0.0, 1.0);

        final animation = CurvedAnimation(
          parent: _animationController,
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

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 8),
                Hero(
                  tag: 'canvas_icon',
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4DB6AC).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.gesture, color: Color(0xFF4DB6AC), size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'canvas_title',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "Canvas",
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: Hive.box<CanvasNote>(CanvasNote.boxName).listenable(),
                        builder: (context, Box<CanvasNote> notesBox, _) {
                          final totalNotes = CanvasDatabase().getTotalNotes();
                          final totalFolders = CanvasDatabase().getAllFolders().length;
                          return Text(
                            "$totalNotes sketches • $totalFolders folders",
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.create_new_folder_outlined),
                onPressed: () => _showCreateFolderDialog(),
              ),
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () => _showSearchDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          final color = isSelected ? const Color(0xFF4DB6AC) : theme.colorScheme.surface;
          final textColor = isSelected ? Colors.white : theme.colorScheme.onSurface;

          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.0 + (index * 0.1), 0.5 + (index * 0.1), curve: Curves.easeOutBack),
              ),
            ),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                ),
                child: Text(
                  category,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFolderGridItem(CanvasFolder folder, ThemeData theme) {
    return GestureDetector(
      onTap: () => context.push('/canvas/folder', extra: folder.id),
      onLongPress: () => _showFolderActions(folder, theme),
      child: GlassContainer(
        color: folder.color.withOpacity(0.15),
        borderRadius: 24,
        blur: 15,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: folder.color.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32)),
                ),
                child: Icon(Icons.folder_open_rounded, size: 22, color: folder.color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    folder.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${CanvasDatabase().getNoteCount(folder.id)} items",
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileGridItem(CanvasNote note, ThemeData theme) {
    return GestureDetector(
      onTap: () => context.push('/canvas/edit', extra: note.id),
      onLongPress: () => _showNoteActions(note, theme),
      child: GlassContainer(
        color: theme.colorScheme.surface.withOpacity(0.1),
        borderRadius: 24,
        blur: 10,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: note.backgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: CustomPaint(
                  painter: DrawingPreviewPainter(note.strokes),
                  size: Size.infinite,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM d').format(note.lastModified),
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4)),
                        ),
                        if (note.isFavorite)
                          const Icon(Icons.star_rounded, size: 14, color: Colors.amberAccent)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateFolderDialog() {
    final controller = TextEditingController();
    Color selectedColor = const Color(0xFF64B5F6);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Folder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Folder name...'),
            ),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) => Wrap(
                spacing: 12,
                children: [
                  const Color(0xFF64B5F6),
                  const Color(0xFF81C784),
                  const Color(0xFFFFD54F),
                  const Color(0xFFFF8A65),
                  const Color(0xFFBA68C8),
                ]
                    .map((color) => GestureDetector(
                  onTap: () => setState(() => selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color ? Border.all(width: 3, color: Colors.white) : null,
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final folder = CanvasFolder(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: controller.text,
                  color: selectedColor,
                );
                CanvasDatabase().saveFolder(folder);
                Navigator.pop(ctx);
                setState(() {});
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Search'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'Search sketches...'),
          onChanged: (value) {
            // Implement search functionality
          },
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  void _showFolderActions(CanvasFolder folder, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GlassContainer(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 20,
        opacity: 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(ctx);
                _showRenameFolderDialog(folder);
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Change Color'),
              onTap: () {
                Navigator.pop(ctx);
                _showChangeFolderColorDialog(folder);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                CanvasDatabase().deleteFolder(folder.id);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteActions(CanvasNote note, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GlassContainer(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 20,
        opacity: 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(note.isFavorite ? Icons.star : Icons.star_outline),
              title: Text(note.isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
              onTap: () {
                note.isFavorite = !note.isFavorite;
                CanvasDatabase().saveNote(note);
                Navigator.pop(ctx);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                CanvasDatabase().deleteNote(note.id);
                Navigator.pop(ctx);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameFolderDialog(CanvasFolder folder) {
    final controller = TextEditingController(text: folder.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Folder'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              folder.name = controller.text;
              CanvasDatabase().saveFolder(folder);
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangeFolderColorDialog(CanvasFolder folder) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GlassContainer(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        borderRadius: 20,
        opacity: 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose Color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                const Color(0xFF64B5F6),
                const Color(0xFF81C784),
                const Color(0xFFFFD54F),
                const Color(0xFFFF8A65),
                const Color(0xFFBA68C8),
                const Color(0xFF4DB6AC),
                const Color(0xFFFFB300),
                const Color(0xFFEF5350),
                const Color(0xFF9575CD),
                const Color(0xFF4FC3F7),
              ]
                  .map((color) => GestureDetector(
                onTap: () {
                  folder.color = color;
                  CanvasDatabase().saveFolder(folder);
                  Navigator.pop(ctx);
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: folder.color == color ? Border.all(width: 3, color: Colors.white) : null,
                  ),
                ),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassScaffold(
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Get default folder or create one
            final folders = CanvasDatabase().getRootFolders();
            if (folders.isNotEmpty) {
              context.push('/canvas/create', extra: folders.first.id);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create a folder first')),
              );
            }
          },
          label: const Text("New Sketch"),
          icon: const Icon(Icons.brush),
          backgroundColor: const Color(0xFF4DB6AC),
          foregroundColor: Colors.white,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(theme),
            _buildCategorySelector(theme),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<CanvasFolder>(CanvasFolder.boxName).listenable(),
                builder: (context, Box<CanvasFolder> foldersBox, _) {
                  final folders = CanvasDatabase().getAllFolders();
                  final allNotes = CanvasDatabase().getTotalNotes();

                  final items = <dynamic>[
                    ...folders,
                    if (_selectedCategory == 'All') ...(CanvasDatabase().getFavoriteNotes()),
                  ];

                  return GridView.builder(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100, top: 0),
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: items.isEmpty ? 1 : items.length,
                    itemBuilder: (context, index) {
                      if (items.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.2)),
                              const SizedBox(height: 12),
                              Text('No folders yet', style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        );
                      }

                      final item = items[index];
                      Widget child;

                      if (item is CanvasFolder) {
                        child = _buildFolderGridItem(item, theme);
                      } else if (item is CanvasNote) {
                        child = _buildFileGridItem(item, theme);
                      } else {
                        child = const SizedBox.shrink();
                      }

                      return _buildBouncingItem(index, child);
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
}

// Drawing preview painter
class DrawingPreviewPainter extends CustomPainter {
  final List<DrawingStroke> strokes;

  DrawingPreviewPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes.take(10)) {
      final paint = Paint()
        ..color = Color(stroke.color)
        ..strokeWidth = stroke.strokeWidth * 0.5
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < stroke.points.length - 2; i += 2) {
        canvas.drawLine(
          Offset(stroke.points[i], stroke.points[i + 1]),
          Offset(stroke.points[i + 2], stroke.points[i + 3]),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPreviewPainter oldDelegate) => oldDelegate.strokes != strokes;
}