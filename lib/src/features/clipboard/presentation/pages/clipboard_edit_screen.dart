import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_rich_text_editor.dart';
import '../../data/clipboard_model.dart';
import '../../../../core/app_content_palette.dart';

class ClipboardEditScreen extends StatefulWidget {
  final ClipboardItem? item;
  const ClipboardEditScreen({super.key, this.item});

  @override
  State<ClipboardEditScreen> createState() => _ClipboardEditScreenState();
}

class _ClipboardEditScreenState extends State<ClipboardEditScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  late QuillController _quillController;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  DateTime _selectedDate = DateTime.now();
  late DateTime _initialDate;
  late Box<ClipboardItem> _clipboardBox;

  Color _scaffoldColor = AppContentPalette.palette.first;
  late Color _initialColor;
  String _initialContentJson = "";

  @override
  void initState() {
    super.initState();
    _clipboardBox = Hive.box<ClipboardItem>('clipboard_box');

    if (widget.item != null) {
      _selectedDate = widget.item!.createdAt;
      _scaffoldColor = widget.item!.colorValue != null
          ? Color(widget.item!.colorValue!)
          : AppContentPalette.palette.first;
    }

    _initialDate = _selectedDate;
    _initialColor = _scaffoldColor;
    _initQuill();
  }

  void _pickDateTime() {
    _focusNode.unfocus();
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Done',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
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
                          fontSize: 20
                      ),
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

  void _initQuill() {
    Document doc;
    try {
      if (widget.item != null && widget.item!.content.isNotEmpty) {
        doc = Document.fromJson(jsonDecode(widget.item!.content));
      } else {
        doc = Document();
      }
    } catch (e) {
      doc = Document()..insert(0, widget.item?.content ?? "");
    }
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    _initialContentJson = jsonEncode(_quillController.document.toDelta().toJson());
  }

  void _showColorPicker() {
    final List<Color> palette = AppContentPalette.palette;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => GlassDialog(
          title: "Clip Theme",
          confirmText: "Save",
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 12, runSpacing: 12,
                  children: palette.map((color) {
                    final isSelected = _scaffoldColor.value == color.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _scaffoldColor = color);
                        setDialogState(() {});
                      },
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle,
                          border: Border.all(
                              color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                              width: isSelected ? 3 : 1.5
                          ),
                        ),
                        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ColorPicker(
                      pickerColor: _scaffoldColor,
                      onColorChanged: (color) {
                        setState(() => _scaffoldColor = color);
                        setDialogState(() {});
                      },
                      pickerAreaHeightPercent: 0.4,
                      enableAlpha: false,
                      labelTypes: const [],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onConfirm: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _save() {
    final contentJson = jsonEncode(_quillController.document.toDelta().toJson());
    if (_quillController.document.toPlainText().trim().isEmpty) return;

    final id = widget.item?.id ?? const Uuid().v4();

    final newItem = ClipboardItem(
      id: id,
      content: contentJson,
      createdAt: _selectedDate,
      type: 'rich_text',
      sortIndex: widget.item?.sortIndex ?? 0,
      colorValue: _scaffoldColor.value,
    );

    _clipboardBox.put(id, newItem);
    _initialContentJson = contentJson;
    _initialDate = _selectedDate;
    _initialColor = _scaffoldColor;
  }

  Future<void> _exportToImage() async {
    try {
      RenderRepaintBoundary? boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/clip_${DateTime.now().millisecond}.png');
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Dynamic Contrast Calculation
    final isColorDark = ThemeData.estimateBrightnessForColor(_scaffoldColor) == Brightness.dark;
    final contrastColor = isColorDark ? Colors.white : Colors.black87;

    final String heroTag = widget.item != null
        ? 'clip_bg_${widget.item!.id}'
        : 'new_clip_hero';

    return WillPopScope(
      onWillPop: () async {
        final currentJson = jsonEncode(_quillController.document.toDelta().toJson());
        bool hasChanges = currentJson != _initialContentJson ||
            _selectedDate != _initialDate ||
            _scaffoldColor.value != _initialColor.value;

        if (!hasChanges) return true;

        final result = await showDialog<String>(
          context: context,
          builder: (ctx) => GlassDialog(
            title: "Unsaved Changes",
            content: "Save your clip before leaving?",
            confirmText: "Save",
            cancelText: "Discard",
            onConfirm: () => Navigator.pop(ctx, 'save'),
            onCancel: () => Navigator.pop(ctx, 'discard'),
          ),
        );
        if (result == 'save') { _save(); return true; }
        return result == 'discard';
      },
      child: GlassScaffold(
        showBackArrow: true,
        backgroundColor: _scaffoldColor,
        title: widget.item == null ? 'New Clip' : 'Edit Clip',
        actions: [
          // Color Picker Swatch
          GestureDetector(
            onTap: _showColorPicker,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: _scaffoldColor, shape: BoxShape.circle,
                // Border reacts to background luminance
                border: Border.all(color: contrastColor.withOpacity(0.4), width: 1.5),
              ),
              child: Icon(Icons.palette_outlined, size: 14, color: contrastColor.withOpacity(0.6)),
            ),
          ),
          // Copy Button
          IconButton(
            icon: Icon(Icons.copy, size: 18, color: contrastColor),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _quillController.document.toPlainText()));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Copied plain text"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: contrastColor,
                ),
              );
            },
          ),
          // Share Menu
          PopupMenuButton<String>(
            icon: Icon(Icons.ios_share, size: 20, color: contrastColor),
            onSelected: (val) { if (val == 'image') _exportToImage(); },
            itemBuilder: (ctx) => [const PopupMenuItem(value: 'image', child: Text("Export as Image"))],
          ),
          // Check/Save Button
          IconButton(
            icon: Icon(Icons.check, color: contrastColor),
            onPressed: () { _save(); context.pop(); },
          ),
        ],
        body: Hero(
          tag: heroTag,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                // 2. Adaptive Canvas Grid
                Positioned.fill(
                  child: CustomPaint(
                    painter: CanvasGridPainter(color: contrastColor.withOpacity(0.08)),
                  ),
                ),
                RepaintBoundary(
                  key: _boundaryKey,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const SizedBox(height: 90),
                        // 3. Adaptive Date/Time Badge
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: _pickDateTime,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: contrastColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: contrastColor.withOpacity(0.7)),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('MMM dd, yyyy  •  hh:mm a').format(_selectedDate),
                                      style: TextStyle(
                                        color: contrastColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 4. Editor with passed contrast color
                        Expanded(
                          child: GlassRichTextEditor(
                            controller: _quillController,
                            focusNode: _focusNode,
                            scrollController: _scrollController,
                            hintText: "Paste or type content here...",
                            editorBackgroundColor: _scaffoldColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CanvasGridPainter extends CustomPainter {
  final Color color;
  CanvasGridPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 0.5;
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}