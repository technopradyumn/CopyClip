import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/features/settings/widgets/home_widget_preview_sheet.dart';
import 'package:copyclip/src/core/utils/widget_sync_service.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';

// ============================================
// HOME WIDGET SERVICE
// ============================================

class HomeWidgetService {
  static const String widgetGroupId = 'group.com.technopradyumn.copyclip';

  // Widget Data Keys
  static const String keyWidgetType = 'widget_type';
  static const String keyWidgetTitle = 'widget_title';
  static const String keyWidgetData = 'widget_data';
  static const String keyLastUpdate = 'last_update';

  /// Initialize home widget functionality
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(widgetGroupId);
      debugPrint('✅ Home Widget initialized with group ID: $widgetGroupId');
    } catch (e) {
      debugPrint('❌ Error initializing home widget: $e');
    }
  }

  /// Update widget data for a specific feature
  static Future<bool> updateWidget({
    required String widgetType,
    required String title,
    required Map<String, dynamic> data,
  }) async {
    try {
      await HomeWidget.saveWidgetData(keyWidgetType, widgetType);
      await HomeWidget.saveWidgetData(keyWidgetTitle, title);
      await HomeWidget.saveWidgetData(keyWidgetData, data.toString());
      await HomeWidget.saveWidgetData(
        keyLastUpdate,
        DateTime.now().toIso8601String(),
      );

      // Update the widget UI
      final updated = await HomeWidget.updateWidget(
        name: 'CopyClipWidgetProvider', // Android
        iOSName: 'CopyClipWidget', // iOS
      );

      debugPrint('✅ Widget updated: $widgetType');
      return updated ?? false;
    } catch (e) {
      debugPrint('❌ Error updating widget: $e');
      return false;
    }
  }

  /// ✅ Safely get box with appropriate type parameters
  static Box? _getBoxSafely(String boxName) {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        debugPrint('⚠️ Box $boxName is not open');
        return null;
      }
      switch (boxName) {
        case 'notes_box':
          return Hive.box<Note>('notes_box');
        case 'todos_box':
          return Hive.box<Todo>('todos_box');
        case 'journal_box':
          return Hive.box<JournalEntry>('journal_box');
        case 'clipboard_box':
          return Hive.box<ClipboardItem>('clipboard_box');
        default:
          return Hive.box(boxName);
      }
    } catch (e) {
      debugPrint('❌ Error accessing box $boxName: $e');
      return null;
    }
  }

  /// Update Notes Widget
  static Future<bool> updateNotesWidget() async {
    try {
      await WidgetSyncService.syncNotes();
      return true;
    } catch (e) {
      debugPrint('❌ Error updating notes widget: $e');
      return false;
    }
  }

  /// Update Todos Widget
  static Future<bool> updateTodosWidget() async {
    try {
      await WidgetSyncService.syncTodos();
      return true;
    } catch (e) {
      debugPrint('❌ Error updating todos widget: $e');
      return false;
    }
  }

  /// Update Journal Widget
  static Future<bool> updateJournalWidget() async {
    try {
      await WidgetSyncService.syncJournal();
      return true;
    } catch (e) {
      debugPrint('❌ Error updating journal widget: $e');
      return false;
    }
  }

  /// Update Clipboard Widget
  static Future<bool> updateClipboardWidget() async {
    try {
      await WidgetSyncService.syncClipboard();
      return true;
    } catch (e) {
      debugPrint('❌ Error updating clipboard widget: $e');
      return false;
    }
  }

  /// Calculate journal writing streak
  static int _calculateJournalStreak(Box journalBox) {
    try {
      if (journalBox.isEmpty) return 0;

      int streak = 1;
      final lastEntry = journalBox.values.last;
      DateTime lastDate = lastEntry.date ?? DateTime.now();

      for (int i = journalBox.length - 2; i >= 0; i--) {
        try {
          final entry = journalBox.values.elementAt(i);
          final entryDate = entry.date ?? DateTime.now();
          final diff = lastDate.difference(entryDate).inDays;

          if (diff == 1) {
            streak++;
            lastDate = entryDate;
          } else {
            break;
          }
        } catch (e) {
          break;
        }
      }

      return streak;
    } catch (e) {
      debugPrint('Error calculating streak: $e');
      return 0;
    }
  }

  /// Pin a widget to home screen
  static Future<bool> pinWidget(String widgetType) async {
    try {
      debugPrint('📌 Attempting to add $widgetType widget...');

      // Update widget data first
      bool updateSuccess = false;

      switch (widgetType) {
        case 'notes':
          updateSuccess = await updateNotesWidget();
          break;
        case 'todos':
          updateSuccess = await updateTodosWidget();
          break;
        case 'journal':
          updateSuccess = await updateJournalWidget();
          break;
        case 'clipboard':
          updateSuccess = await updateClipboardWidget();
          break;
        default:
          debugPrint('⚠️ Unknown widget type: $widgetType');
          return false;
      }

      if (!updateSuccess) {
        debugPrint('⚠️ Widget update returned false, but continuing...');
        // Don't fail - widget might still work with default data
      }

      // Try to request widget pinning on Android 8.0+
      if (Platform.isAndroid) {
        final pinResult = await requestPinWidget(widgetType);
        if (pinResult) {
          debugPrint('✅ Widget pin request sent successfully');
          return true;
        } else {
          debugPrint(
            'ℹ️ Widget pin request not supported or cancelled. User can add manually.',
          );
        }
      }

      // If pin request fails or is not supported, user can still add widget manually
      debugPrint(
        '✅ Widget data updated. User can now add widget from launcher.',
      );
      return true;
    } catch (e) {
      debugPrint('❌ Error pinning widget: $e');
      // Still return true so user sees instructions
      return true;
    }
  }

  /// Request to add widget (Android 8.0+)
  static Future<bool> requestPinWidget(String widgetType) async {
    if (!Platform.isAndroid) {
      debugPrint('⚠️ Widget pinning only available on Android');
      return false;
    }

    try {
      const platform = MethodChannel('com.technopradyumn.copyclip/widget');
      final result = await platform.invokeMethod('requestPinWidget', {
        'widgetType': widgetType,
      });
      return result ?? false;
    } catch (e) {
      debugPrint('❌ Error requesting widget pin: $e');
      return false;
    }
  }
}

// ============================================
// HOME WIDGET BOTTOM SHEET UI (Same as before)
// ============================================

class HomeWidgetBottomSheet extends StatefulWidget {
  final String featureId;
  final String featureTitle;
  final IconData featureIcon;
  final Color featureColor;

  const HomeWidgetBottomSheet({
    super.key,
    required this.featureId,
    required this.featureTitle,
    required this.featureIcon,
    required this.featureColor,
  });

  @override
  State<HomeWidgetBottomSheet> createState() => _HomeWidgetBottomSheetState();
}

class _HomeWidgetBottomSheetState extends State<HomeWidgetBottomSheet> {
  bool _isLoading = false;

  Future<void> _addWidget() async {
    setState(() => _isLoading = true);

    final success = await HomeWidgetService.pinWidget(widget.featureId);

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.featureTitle} widget is ready!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  Platform.isAndroid
                      ? 'If the widget picker didn\'t appear:\nLong press home screen → Widgets → CopyClip → ${widget.featureTitle}'
                      : 'Long press home screen → + button → Search CopyClip',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: widget.featureColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to prepare widget. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.featureColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.featureColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              widget.featureIcon,
              size: 48,
              color: widget.featureColor,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Add ${widget.featureTitle} Widget',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Access your ${widget.featureTitle.toLowerCase()} directly from your home screen',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.featureColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.featureColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: widget.featureColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'How to add widget',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInstruction('1', 'Long press on your home screen'),
                const SizedBox(height: 8),
                _buildInstruction(
                  '2',
                  Platform.isAndroid ? 'Tap "Widgets"' : 'Tap the + button',
                ),
                const SizedBox(height: 8),
                _buildInstruction('3', 'Find "CopyClip" in the list'),
                const SizedBox(height: 8),
                _buildInstruction(
                  '4',
                  'Drag ${widget.featureTitle} widget to home screen',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addWidget,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.featureColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Prepare Widget'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInstruction(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: widget.featureColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: widget.featureColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}

void showWidgetBottomSheet(
  BuildContext context,
  String featureId,
  String featureTitle,
  IconData featureIcon,
  Color featureColor,
) {
  HomeWidgetPreviewSheet.show(
    context,
    widgetId: featureId,
    title: featureTitle,
    icon: featureIcon,
    color: featureColor,
  );
}
