import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';

import '../../../../core/router/app_router.dart';
import '../../data/canvas_adapter.dart';

// Assume CanvasDatabase and CanvasNote are imported

class CanvasFolderScreen extends StatefulWidget {
  final String folderId;

  const CanvasFolderScreen({
    super.key,
    required this.folderId,
  });

  @override
  State<CanvasFolderScreen> createState() => _CanvasFolderScreenState();
}

class _CanvasFolderScreenState extends State<CanvasFolderScreen> with SingleTickerProviderStateMixin {
  late CanvasFolder _folder;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _folder = CanvasDatabase().getFolder(widget.folderId)!;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GlassScaffold(
      title: null,
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            context.push(
              AppRouter.canvasEdit,
              extra: {
                'noteId': null,
                'folderId': widget.folderId,
              },
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('New Sketch'),
          backgroundColor: _folder.color,
          foregroundColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          // Header
          _buildHeader(theme, colorScheme),

          // Notes Grid
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<CanvasNote>(CanvasNote.boxName).listenable(),
              builder: (context, Box<CanvasNote> notesBox, __) {
                final notes = CanvasDatabase().getNotesByFolder(widget.folderId);

                if (notes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 64,
                          color: colorScheme.onSurface.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No sketches yet',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return _buildBouncingItem(
                      index,
                      _buildNoteCard(note, theme, colorScheme),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          Hero(
            tag: 'folder_${widget.folderId}',
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _folder.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_rounded, color: _folder.color, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'folder_name_${widget.folderId}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      _folder.name,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text(
                  '${CanvasDatabase().getNoteCount(widget.folderId)} sketches',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Rename'),
                onTap: () => _showRenameDialog(theme),
              ),
              PopupMenuItem(
                child: const Text('Change Color'),
                onTap: () => _showColorPicker(theme),
              ),
              PopupMenuItem(
                child: const Text('Delete'),
                onTap: () => _showDeleteDialog(theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(CanvasNote note, ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        // Navigate to edit screen with noteId
        context.push(AppRouter.canvasEdit, extra: note.id);
      },
      onLongPress: () => _showNoteActions(note, theme),
      child: GlassContainer(
        color: theme.colorScheme.surface.withOpacity(0.1),
        borderRadius: 16,
        blur: 10,
        child: Column(
          children: [
            // Preview area
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: note.backgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: CustomPaint(
                  painter: DrawingPreviewPainter(note.strokes),
                  size: Size.infinite,
                ),
              ),
            ),
            // Info area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      note.title,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM d').format(note.lastModified),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                        if (note.isFavorite)
                          const Icon(Icons.star_rounded, size: 14, color: Colors.amberAccent),
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                CanvasDatabase().deleteNote(note.id);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(ThemeData theme) {
    final controller = TextEditingController(text: _folder.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Folder name...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _folder.name = controller.text;
              CanvasDatabase().saveFolder(_folder);
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(ThemeData theme) {
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
            Text('Choose Color', style: theme.textTheme.titleMedium),
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
                  setState(() => _folder.color = color);
                  CanvasDatabase().saveFolder(_folder);
                  Navigator.pop(ctx);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: _folder.color == color ? Border.all(width: 3, color: Colors.white) : null,
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

  void _showDeleteDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Folder?'),
        content: const Text('This will move all sketches in this folder to trash.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              CanvasDatabase().deleteFolder(widget.folderId);
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Simple preview painter
class DrawingPreviewPainter extends CustomPainter {
  final List<DrawingStroke> strokes;

  DrawingPreviewPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes.take(10)) {
      // Only paint first 10 strokes for preview
      final paint = Paint()
        ..color = Color(stroke.color)
        ..strokeWidth = stroke.strokeWidth * 0.5 // Smaller preview
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