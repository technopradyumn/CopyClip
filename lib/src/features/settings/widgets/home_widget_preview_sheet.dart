import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/services/home_widget_service.dart';
import 'package:copyclip/src/core/theme/app_colors.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/core/widgets/background_painters.dart';
import 'package:copyclip/src/l10n/app_localizations.dart';

class HomeWidgetPreviewSheet extends StatefulWidget {
  final String widgetId;
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onAdd;

  const HomeWidgetPreviewSheet({
    super.key,
    required this.widgetId,
    required this.title,
    required this.icon,
    required this.color,
    this.onAdd,
  });

  static void show(
    BuildContext context, {
    required String widgetId,
    required String title,
    required IconData icon,
    required Color color,
    VoidCallback? onAdd,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HomeWidgetPreviewSheet(
        widgetId: widgetId,
        title: title,
        icon: icon,
        color: color,
        onAdd: onAdd,
      ),
    );
  }

  @override
  State<HomeWidgetPreviewSheet> createState() => _HomeWidgetPreviewSheetState();
}

class _HomeWidgetPreviewSheetState extends State<HomeWidgetPreviewSheet> {
  bool _isAdding = false;

  Future<void> _onAdd() async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final widgetTitle = widget.title;
    final widgetColor = widget.color;
    final widgetId = widget.widgetId;

    Navigator.pop(context);
    if (widget.onAdd != null) {
      widget.onAdd!();
      return;
    }

    try {
      final success = await HomeWidgetService.pinWidget(widgetId);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.widgetAdded(widgetTitle)
                : l10n.widgetRequestSent,
          ),
          backgroundColor: widgetColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4.5,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.title} Home Widget',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'Live Home Screen Preview',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.sparkles, size: 12, color: widget.color),
                    const SizedBox(width: 4),
                    Text(
                      '2x2 / 4x2',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Widget Preview Container (mimicking the actual Android home widget)
          _buildWidgetMockup(context, isDark),

          const SizedBox(height: 14),

          // Widget Background Switch
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.00)
                      : Colors.black.withValues(alpha: 0.00),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.photo,
                      size: 18,
                      color: widget.color,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Apply Selected Background',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Use app wallpaper on home widgets',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: state.applyBackgroundToWidgets,
                      activeColor: widget.color,
                      onChanged: (val) {
                        context
                            .read<ThemeBloc>()
                            .add(ToggleApplyBackgroundToWidgets(val));
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isAdding ? null : _onAdd,
              icon: _isAdding
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(CupertinoIcons.plus_circle_fill, size: 20),
              label: Text(
                _isAdding ? 'Adding Widget...' : 'Add to Home Screen',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Manual helper tip
          Text(
            Platform.isAndroid
                ? 'Tip: You can also long-press your Home Screen → Widgets → CopyClip'
                : 'Tip: Long-press your Home Screen → tap + → Search CopyClip',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetMockup(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final scaffoldBg = state.applyBackgroundToWidgets
            ? theme.scaffoldBackgroundColor
            : (isDark ? const Color(0xFF1C1C1E) : Colors.white);
        final cardBg = isDark
            ? (state.applyBackgroundToWidgets
                ? const Color(0xFF1F2937)
                : const Color(0xFF2C2C2E))
            : Colors.white;
        final borderColor = isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.08);

        final painter = getBackgroundPainter(
          design: state.backgroundDesign,
          animationValue: 0.5,
          primaryColor: state.primaryColor,
          isDark: isDark,
        );

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: scaffoldBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                if (state.applyBackgroundToWidgets && painter != null)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: painter,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Widget Header Row
                      Row(
                        children: [
                          Icon(widget.icon, size: 18, color: widget.color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getHeaderTitle(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            _getHeaderSubtitle(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Divider(height: 1, color: borderColor),
                      const SizedBox(height: 10),

                      // Feature Specific Content Cards
                      if (widget.widgetId == 'todos') _buildTodosMockup(isDark, cardBg),
                      if (widget.widgetId == 'notes') _buildNotesMockup(isDark, cardBg),
                      if (widget.widgetId == 'journal') _buildJournalMockup(isDark, cardBg),
                      if (widget.widgetId == 'clipboard') _buildClipboardMockup(isDark, cardBg),
                      if (widget.widgetId == 'copyclip' ||
                          (widget.widgetId != 'todos' &&
                              widget.widgetId != 'notes' &&
                              widget.widgetId != 'journal' &&
                              widget.widgetId != 'clipboard'))
                        _buildCopyClipMockup(isDark, cardBg),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getHeaderTitle() {
    switch (widget.widgetId) {
      case 'copyclip':
        return 'CopyClip';
      case 'todos':
        return 'To-Do List';
      case 'notes':
        return 'Recent Notes';
      case 'journal':
        return 'My Journal';
      case 'clipboard':
        return 'Clipboard';
      default:
        return widget.title;
    }
  }

  String _getHeaderSubtitle() {
    switch (widget.widgetId) {
      case 'copyclip':
        return 'App Widget';
      case 'todos':
        return '1/3 Done';
      case 'notes':
        return '4 Notes';
      case 'journal':
        return 'Today';
      case 'clipboard':
        return 'Latest';
      default:
        return 'Active';
    }
  }

  // --- Mockups for each feature matching the XML and Kotlin widgets ---

  Widget _buildCopyClipMockup(bool isDark, Color cardBg) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white60 : Colors.black54;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.paperclip,
              color: widget.color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'CopyClip Hub',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Quick access to Clipboard, Notes, Todos & Journal',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: subColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _chipAction('Clipboard', CupertinoIcons.doc_on_clipboard, FeatureColors.clipboard),
              _chipAction('Notes', CupertinoIcons.doc_text, FeatureColors.notes),
              _chipAction('Todos', CupertinoIcons.checkmark_circle, FeatureColors.todos),
              _chipAction('Journal', CupertinoIcons.book, FeatureColors.journal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipAction(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodosMockup(bool isDark, Color cardBg) {
    return Column(
      children: [
        // 1. Overdue Item
        _mockupCard(
          isDark: isDark,
          bgColor: const Color(0x1FFF3B30),
          borderColor: const Color(0x33FF3B30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFF3B30), width: 2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Review design mockups',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF3B30),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 4),
                child: Row(
                  children: const [
                    Icon(CupertinoIcons.calendar, size: 11, color: Color(0xFFFF3B30)),
                    SizedBox(width: 4),
                    Text(
                      'Yesterday • 5:00 PM',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF3B30),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // 2. Due Today Item
        _mockupCard(
          isDark: isDark,
          bgColor: const Color(0x1FFF9500),
          borderColor: const Color(0x33FF9500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFF9500), width: 2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Submit sprint report',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFFF9500),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 4),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 11,
                      color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFFF9500),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Today • 4:00 PM',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFFF9500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.bell_fill,
                      size: 11,
                      color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFFF9500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // 3. Completed Item
        _mockupCard(
          isDark: isDark,
          bgColor: const Color(0x14808080),
          borderColor: const Color(0x18808080),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF34C759),
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Morning team standup',
                  style: TextStyle(
                    fontSize: 13,
                    decoration: TextDecoration.lineThrough,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesMockup(bool isDark, Color cardBg) {
    return Column(
      children: [
        _mockupCard(
          isDark: isDark,
          bgColor: cardBg,
          borderColor: isDark ? Colors.white10 : Colors.black12,
          child: Row(
            children: [
              Container(
                width: 3.5,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A65),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Project Architecture',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Today • 10:30 AM',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Outlined Hive schemas and widget sync patterns...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _mockupCard(
          isDark: isDark,
          bgColor: cardBg,
          borderColor: isDark ? Colors.white10 : Colors.black12,
          child: Row(
            children: [
              Container(
                width: 3.5,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Weekend Reading List',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Oct 28 • 6:15 PM',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Designing Data-Intensive Applications, Clean Code...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJournalMockup(bool isDark, Color cardBg) {
    return Column(
      children: [
        _mockupCard(
          isDark: isDark,
          bgColor: cardBg,
          borderColor: isDark ? Colors.white10 : Colors.black12,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x1FCE93D8),
                  border: Border.all(color: const Color(0x33CE93D8)),
                ),
                alignment: Alignment.center,
                child: const Text('😊', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Productive Morning',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Today • 9:00 AM',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Finished refactoring home widgets and enjoyed a coffee...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _mockupCard(
          isDark: isDark,
          bgColor: cardBg,
          borderColor: isDark ? Colors.white10 : Colors.black12,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x1FCE93D8),
                  border: Border.all(color: const Color(0x33CE93D8)),
                ),
                alignment: Alignment.center,
                child: const Text('🤩', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Cabin Getaway Trip',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Yesterday • 8:45 PM',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Booked the cottage by the mountain trail for holiday...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClipboardMockup(bool isDark, Color cardBg) {
    return Column(
      children: [
        _mockupCard(
          isDark: isDark,
          bgColor: cardBg,
          borderColor: isDark ? Colors.white10 : Colors.black12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0x1F90CAF9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'LINK',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64B5F6),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Just now • 11:20 AM',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'https://github.com/technopradyumn/CopyClip',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _mockupCard(
          isDark: isDark,
          bgColor: cardBg,
          borderColor: isDark ? Colors.white10 : Colors.black12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0x1F90CAF9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'TEXT',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64B5F6),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '15m ago • 11:05 AM',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Interactive Android home widgets with instant sync',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mockupCard({
    required bool isDark,
    required Color bgColor,
    required Color borderColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: child,
    );
  }
}
