import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  /// ✅ ULTIMATE FIX: Get box without type parameters
  /// This uses Hive's internal box access which bypasses type checking
  static Box? _getBoxSafely(String boxName) {
    try {
      // Check if box is open first
      if (!Hive.isBoxOpen(boxName)) {
        debugPrint('⚠️ Box $boxName is not open');
        return null;
      }

      // Access the box directly without type parameter
      // This works because we're accessing an already-open box
      return Hive.box(boxName);
    } catch (e) {
      debugPrint('❌ Error accessing box $boxName: $e');
      return null;
    }
  }

  /// Update Notes Widget
  static Future<bool> updateNotesWidget() async {
    try {
      // ✅ Get box without type - works with already open Box<Note>
      final notesBox = _getBoxSafely('notes_box');

      if (notesBox == null) {
        debugPrint('⚠️ Notes box not available, using default data');
        return await updateWidget(
          widgetType: 'notes',
          title: 'Recent Notes',
          data: {'notes': [], 'count': 0},
        );
      }

      final recentNotes = <Map<String, String>>[];

      // Safely iterate through values
      for (var note in notesBox.values.take(3)) {
        try {
          recentNotes.add({
            'title': note.title?.toString() ?? 'Untitled',
            'preview': (note.content?.toString() ?? '').substring(
              0,
              (note.content?.toString() ?? '').length > 50
                  ? 50
                  : (note.content?.toString() ?? '').length,
            ),
          });
        } catch (e) {
          debugPrint('Error processing note: $e');
          recentNotes.add({
            'title': 'Note',
            'preview': 'Unable to load preview',
          });
        }
      }

      return await updateWidget(
        widgetType: 'notes',
        title: 'Recent Notes',
        data: {'notes': recentNotes, 'count': notesBox.length},
      );
    } catch (e) {
      debugPrint('❌ Error updating notes widget: $e');
      // Fallback to default data
      return await updateWidget(
        widgetType: 'notes',
        title: 'Recent Notes',
        data: {'notes': [], 'count': 0},
      );
    }
  }

  /// Update Todos Widget
  static Future<bool> updateTodosWidget() async {
    try {
      final todosBox = _getBoxSafely('todos_box');

      if (todosBox == null) {
        return await updateWidget(
          widgetType: 'todos',
          title: 'To-Do List',
          data: {'todos': [], 'completed': 0, 'total': 0},
        );
      }

      final pendingTodos = <Map<String, String>>[];
      int completedCount = 0;

      for (var todo in todosBox.values) {
        try {
          final isCompleted = todo.isCompleted ?? false;

          if (isCompleted) {
            completedCount++;
          } else if (pendingTodos.length < 5) {
            pendingTodos.add({
              'title': todo.title?.toString() ?? 'Task',
              'priority': todo.priority?.toString() ?? 'normal',
            });
          }
        } catch (e) {
          debugPrint('Error processing todo: $e');
        }
      }

      return await updateWidget(
        widgetType: 'todos',
        title: 'To-Do List',
        data: {
          'todos': pendingTodos,
          'completed': completedCount,
          'total': todosBox.length,
        },
      );
    } catch (e) {
      debugPrint('❌ Error updating todos widget: $e');
      return await updateWidget(
        widgetType: 'todos',
        title: 'To-Do List',
        data: {'todos': [], 'completed': 0, 'total': 0},
      );
    }
  }

  /// Update Expenses Widget
  static Future<bool> updateExpensesWidget() async {
    try {
      final expensesBox = _getBoxSafely('expenses_box');

      if (expensesBox == null) {
        return await updateWidget(
          widgetType: 'expenses',
          title: 'Finance Overview',
          data: {'expenses': 0.0, 'income': 0.0, 'balance': 0.0},
        );
      }

      double totalExpenses = 0;
      double totalIncome = 0;

      for (var expense in expensesBox.values) {
        try {
          final type = expense.type?.toString() ?? 'expense';
          final amount = (expense.amount ?? 0).toDouble();

          if (type == 'expense') {
            totalExpenses += amount;
          } else {
            totalIncome += amount;
          }
        } catch (e) {
          debugPrint('Error processing expense: $e');
        }
      }

      return await updateWidget(
        widgetType: 'expenses',
        title: 'Finance Overview',
        data: {
          'expenses': totalExpenses,
          'income': totalIncome,
          'balance': totalIncome - totalExpenses,
        },
      );
    } catch (e) {
      debugPrint('❌ Error updating expenses widget: $e');
      return await updateWidget(
        widgetType: 'expenses',
        title: 'Finance Overview',
        data: {'expenses': 0.0, 'income': 0.0, 'balance': 0.0},
      );
    }
  }

  /// Update Journal Widget
  static Future<bool> updateJournalWidget() async {
    try {
      final journalBox = _getBoxSafely('journal_box');

      if (journalBox == null) {
        return await updateWidget(
          widgetType: 'journal',
          title: 'Journal',
          data: {'lastEntry': '', 'totalEntries': 0, 'streak': 0},
        );
      }

      String lastEntry = '';
      if (journalBox.isNotEmpty) {
        try {
          final lastJournal = journalBox.values.last;
          lastEntry = lastJournal.date?.toIso8601String() ?? '';
        } catch (e) {
          debugPrint('Error getting last entry: $e');
        }
      }

      return await updateWidget(
        widgetType: 'journal',
        title: 'Journal',
        data: {
          'lastEntry': lastEntry,
          'totalEntries': journalBox.length,
          'streak': _calculateJournalStreak(journalBox),
        },
      );
    } catch (e) {
      debugPrint('❌ Error updating journal widget: $e');
      return await updateWidget(
        widgetType: 'journal',
        title: 'Journal',
        data: {'lastEntry': '', 'totalEntries': 0, 'streak': 0},
      );
    }
  }

  /// Update Clipboard Widget
  static Future<bool> updateClipboardWidget() async {
    try {
      // ✅ Use untyped access for already-open Box<ClipboardItem>
      final clipboardBox = _getBoxSafely('clipboard_box');

      if (clipboardBox == null) {
        debugPrint('⚠️ Clipboard box not available, using default data');
        return await updateWidget(
          widgetType: 'clipboard',
          title: 'Recent Clips',
          data: {'clips': [], 'count': 0},
        );
      }

      final recentClips = <Map<String, String>>[];

      // Safely iterate through clipboard items
      for (var clip in clipboardBox.values.take(3)) {
        try {
          final text = clip.text?.toString() ?? 'Clipboard item';
          recentClips.add({
            'text': text.substring(0, text.length > 30 ? 30 : text.length),
            'type': clip.type?.toString() ?? 'text',
          });
        } catch (e) {
          debugPrint('Error processing clip: $e');
          recentClips.add({
            'text': 'Clipboard item',
            'type': 'text',
          });
        }
      }

      return await updateWidget(
        widgetType: 'clipboard',
        title: 'Recent Clips',
        data: {'clips': recentClips, 'count': clipboardBox.length},
      );
    } catch (e) {
      debugPrint('❌ Error updating clipboard widget: $e');
      // Always return true with fallback data
      return await updateWidget(
        widgetType: 'clipboard',
        title: 'Recent Clips',
        data: {'clips': [], 'count': 0},
      );
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
        case 'expenses':
          updateSuccess = await updateExpensesWidget();
          break;
        case 'journal':
          updateSuccess = await updateJournalWidget();
          break;
        case 'clipboard':
          updateSuccess = await updateClipboardWidget();
          break;
        case 'calendar':
          updateSuccess = await updateWidget(
            widgetType: 'calendar',
            title: 'Calendar',
            data: {'message': 'View your calendar'},
          );
          break;
        case 'canvas':
          updateSuccess = await updateWidget(
            widgetType: 'canvas',
            title: 'Canvas',
            data: {'message': 'Open your canvas'},
          );
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
          debugPrint('ℹ️ Widget pin request not supported or cancelled. User can add manually.');
        }
      }

      // If pin request fails or is not supported, user can still add widget manually
      debugPrint('✅ Widget data updated. User can now add widget from launcher.');
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
              color: theme.colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.featureColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.featureColor.withOpacity(0.3),
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
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.featureColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.featureColor.withOpacity(0.2),
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
                _buildInstruction('2', Platform.isAndroid ? 'Tap "Widgets"' : 'Tap the + button'),
                const SizedBox(height: 8),
                _buildInstruction('3', 'Find "CopyClip" in the list'),
                const SizedBox(height: 8),
                _buildInstruction('4', 'Drag ${widget.featureTitle} widget to home screen'),
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
            color: widget.featureColor.withOpacity(0.2),
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
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ),
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
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => HomeWidgetBottomSheet(
      featureId: featureId,
      featureTitle: featureTitle,
      featureIcon: featureIcon,
      featureColor: featureColor,
    ),
  );
}