import 'dart:ui';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import '../../../../core/services/backup_service.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';
import 'recycle_bin_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with WidgetsBindingObserver {
  static const platform = MethodChannel('com.technopradyumn.copyclip/accessibility');
  bool _isServiceEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkServiceStatus();
    _runAutoCleanup(); // Runs the 30-day deletion logic on open
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // --- RECYCLE BIN LOGIC ---

  /// Permanently deletes items from all boxes that have been in the trash for > 30 days
  Future<void> _runAutoCleanup() async {
    final boxes = ['notes_box', 'todos_box', 'expenses_box', 'journal_box', 'clipboard_box'];
    final now = DateTime.now();
    int cleanedCount = 0;

    for (var boxName in boxes) {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        final toDelete = box.values.where((item) {
          try {
            // Check if item is marked deleted and if 30 days have passed
            if (item.isDeleted == true && item.deletedAt != null) {
              return now.difference(item.deletedAt!).inDays >= 30;
            }
          } catch (e) {
            debugPrint("Cleanup check skipped for an item in $boxName");
          }
          return false;
        }).toList();

        for (var item in toDelete) {
          await item.delete(); // Permanent removal from Hive
          cleanedCount++;
        }
      }
    }
    if (cleanedCount > 0) debugPrint("Auto-Cleanup: Removed $cleanedCount expired items.");
  }

  /// Calculates total items currently in the Recycle Bin across all features
  int _getTrashCount() {
    int total = 0;

    // You must specify the <Type> for each box to avoid the HiveError
    if (Hive.isBoxOpen('notes_box')) {
      total += Hive.box<Note>('notes_box').values.where((item) => item.isDeleted == true).length;
    }
    if (Hive.isBoxOpen('todos_box')) {
      total += Hive.box<Todo>('todos_box').values.where((item) => item.isDeleted == true).length;
    }
    if (Hive.isBoxOpen('expenses_box')) {
      total += Hive.box<Expense>('expenses_box').values.where((item) => item.isDeleted == true).length;
    }
    if (Hive.isBoxOpen('journal_box')) {
      total += Hive.box<JournalEntry>('journal_box').values.where((item) => item.isDeleted == true).length;
    }
    if (Hive.isBoxOpen('clipboard_box')) {
      total += Hive.box<ClipboardItem>('clipboard_box').values.where((item) => item.isDeleted == true).length;
    }

    return total;
  }
  // --- EXISTING UTILITIES ---

  Future<void> _checkServiceStatus() async {
    try {
      final bool status = await platform.invokeMethod('isServiceEnabled');
      setState(() => _isServiceEnabled = status);
    } catch (e) {
      debugPrint("Status check failed: $e");
    }
  }

  void _showGlassSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    final theme = Theme.of(context);
    final color = isError ? theme.colorScheme.error : Colors.greenAccent;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 16,
          color: theme.colorScheme.surface,
          opacity: 0.9,
          child: Row(
            children: [
              Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: color),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }

  // --- DIALOGS ---

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Backup Data",
        content: "Save a JSON file containing all your data?",
        confirmText: "Export Now",
        onConfirm: () async {
          Navigator.pop(ctx);
          try {
            await BackupService.createBackup(context);
            _showGlassSnackBar("Backup saved successfully!");
          } catch (e) {
            _showGlassSnackBar("Export failed", isError: true);
          }
        },
      ),
    );
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Import Data",
        content: "Merge a backup file with your current items?",
        confirmText: "Select File",
        onConfirm: () async {
          Navigator.pop(ctx);
          try {
            final count = await BackupService.restoreBackup(context);
            _showGlassSnackBar("Imported $count new items.");
            setState(() {});
          } catch (e) {
            _showGlassSnackBar("Import failed", isError: true);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;
    final textTheme = theme.textTheme;
    final themeManager = Provider.of<ThemeManager>(context);
    final glassTint = primaryColor.withOpacity(0.08);

    return GlassScaffold(
      title: "Settings",
      showBackArrow: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
        physics: const BouncingScrollPhysics(),
        children: [
          // --- APPEARANCE ---
          _buildSectionHeader("Appearance", primaryColor),
          GlassContainer(
            color: glassTint,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.brightness_6, color: primaryColor),
                  title: Text("Theme Mode", style: textTheme.bodyLarge),
                  trailing: _buildThemeDropdown(themeManager),
                ),
                const Divider(indent: 50),
                ListTile(
                  leading: Icon(Icons.palette, color: primaryColor),
                  title: Text("Accent Color", style: textTheme.bodyLarge),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildColorDot(Colors.amberAccent, themeManager),
                      _buildColorDot(Colors.blueAccent, themeManager),
                      _buildColorDot(Colors.greenAccent, themeManager),
                      _buildColorDot(Colors.purpleAccent, themeManager),
                      _buildColorDot(Colors.redAccent, themeManager),
                      _buildColorDot(Colors.cyanAccent, themeManager),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- PRIVACY & TRASH ---
          _buildSectionHeader("Privacy & Maintenance", primaryColor),
          GlassContainer(
            color: glassTint,
            padding: const EdgeInsets.all(4),
            child: ListTile(
              leading: Icon(Icons.delete_sweep_outlined, color: primaryColor),
              title: Text("Recycle Bin", style: textTheme.bodyLarge),
              subtitle: Text("${_getTrashCount()} items • Auto-deletes in 30 days",
                  style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.5))),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecycleBinScreen())
                );
                setState(() {});
              },
            ),
          ),

          const SizedBox(height: 24),

          // --- AUTOMATION ---
          _buildSectionHeader("General", primaryColor),
          GlassContainer(
            color: glassTint,
            child: ListTile(
              leading: Icon(_isServiceEnabled ? Icons.bolt : Icons.bolt_outlined,
                  color: _isServiceEnabled ? Colors.greenAccent : onSurfaceColor.withOpacity(0.5)),
              title: Text("Auto Clipboard Capture", style: textTheme.bodyLarge),
              subtitle: Text(_isServiceEnabled ? "Service is active" : "Requires Accessibility Permission",
                  style: TextStyle(fontSize: 12, color: _isServiceEnabled ? Colors.greenAccent : onSurfaceColor.withOpacity(0.5))),
              trailing: Switch(
                value: _isServiceEnabled,
                activeColor: primaryColor,
                onChanged: (_) async => await platform.invokeMethod('openAccessibilitySettings'),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // --- DATA ---
          _buildSectionHeader("Data & Backup", primaryColor),
          GlassContainer(
            color: glassTint,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.upload_file, color: primaryColor),
                  title: Text("Export Data", style: textTheme.bodyLarge),
                  onTap: _showExportDialog,
                ),
                const Divider(indent: 50),
                ListTile(
                  leading: Icon(Icons.download, color: primaryColor),
                  title: Text("Import Data", style: textTheme.bodyLarge),
                  onTap: _showImportDialog,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- ABOUT ---
          _buildSectionHeader("About", primaryColor),
          GlassContainer(
            color: glassTint,
            child: ListTile(
              title: Text("Version", style: textTheme.bodyLarge),
              trailing: Text("1.0.0", style: TextStyle(color: onSurfaceColor.withOpacity(0.4))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildThemeDropdown(ThemeManager manager) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<ThemeMode>(
        value: manager.themeMode,
        icon: const Icon(Icons.arrow_drop_down),
        onChanged: (mode) => mode != null ? manager.setThemeMode(mode) : null,
        items: const [
          DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
          DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
          DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color, ThemeManager manager) {
    final isSelected = manager.primaryColor.value == color.value;
    return GestureDetector(
      onTap: () => manager.setPrimaryColor(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 2.5) : null,
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10)] : null,
        ),
        child: isSelected ? const Icon(Icons.check, size: 18, color: Colors.black) : null,
      ),
    );
  }
}