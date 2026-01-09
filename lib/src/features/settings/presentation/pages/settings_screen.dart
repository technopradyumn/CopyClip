import 'dart:ui';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
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

class _SettingsScreenState extends State<SettingsScreen> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  String _version = "1.0.0";
  String _buildNumber = "1";
  bool _clipboardAutoSave = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _runAutoCleanup();
    _initPackageInfo();
    _loadAutoSaveSettings();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  Future<void> _loadAutoSaveSettings() async {
    final settingsBox = Hive.box('settings');
    setState(() {
      _clipboardAutoSave = settingsBox.get('clipboardAutoSave', defaultValue: false) as bool;
    });
  }

  Future<void> _toggleAutoSave(bool value) async {
    final settingsBox = Hive.box('settings');
    await settingsBox.put('clipboardAutoSave', value);

    setState(() {
      _clipboardAutoSave = value;
    });

    // Show confirmation message
    _showGlassSnackBar(
      value
          ? "Auto-save enabled. Clipboard items will be saved automatically."
          : "Auto-save disabled.",
    );

    debugPrint("Auto-save toggled to: $value");
  }

  @override
  void dispose() {
    _rotationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // --- RECYCLE BIN LOGIC ---

  Future<void> _runAutoCleanup() async {
    final boxes = ['notes_box', 'todos_box', 'expenses_box', 'journal_box', 'clipboard_box'];
    final now = DateTime.now();
    int cleanedCount = 0;

    for (var boxName in boxes) {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        final toDelete = box.values.where((item) {
          try {
            if (item.isDeleted == true && item.deletedAt != null) {
              return now.difference(item.deletedAt!).inDays >= 30;
            }
          } catch (e) {
            debugPrint("Cleanup check skipped for an item in $boxName");
          }
          return false;
        }).toList();

        for (var item in toDelete) {
          await item.delete();
          cleanedCount++;
        }
      }
    }
    if (cleanedCount > 0) debugPrint("Auto-Cleanup: Removed $cleanedCount expired items.");
  }

  int _getTrashCount() {
    int total = 0;

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

  // --- URL LAUNCHER ---
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showGlassSnackBar("Could not open link", isError: true);
    }
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
      title: null,
      showBackArrow: false,
      body: Column(
        children: [
          // Custom Top Bar with Hero Animation
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 8),
                Hero(
                  tag: 'settings_icon',
                  child: RotationTransition(
                    turns: _rotationController,
                    child: Icon(
                      Icons.settings_outlined,
                      size: 32,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Settings",
                  style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Settings Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              physics: const BouncingScrollPhysics(),
              children: [
                // --- CLIPBOARD SETTINGS ---
                _buildSectionHeader("Clipboard", primaryColor),
                GlassContainer(
                  color: glassTint,
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.content_paste, color: primaryColor),
                        title: Text("Auto-save Clipboard", style: textTheme.bodyLarge),
                        subtitle: Text(
                          "Automatically save copied items",
                          style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.5)),
                        ),
                        trailing: Switch(
                          value: _clipboardAutoSave,
                          onChanged: _toggleAutoSave,
                          activeColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

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
                            _buildColorDot(Colors.lightBlue, themeManager),
                            _buildColorDot(Colors.blueAccent, themeManager),
                            _buildColorDot(Colors.teal, themeManager),
                            _buildColorDot(Colors.purpleAccent, themeManager),
                            _buildColorDot(Colors.redAccent, themeManager),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _buildSectionHeader("Recycle Bin", primaryColor),
                GlassContainer(
                  color: glassTint,
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      ListTile(
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
                    ],
                  ),
                ),

                const SizedBox(height: 24),

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

                // --- FEEDBACK & SUPPORT ---
                _buildSectionHeader("Feedback & Support", primaryColor),
                GlassContainer(
                  color: glassTint,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.feedback_outlined, color: primaryColor),
                        title: Text("Send Feedback", style: textTheme.bodyLarge),
                        subtitle: Text("Help us improve", style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.5))),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () => context.push(AppRouter.feedback),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- DEVELOPER INFO ---
                _buildSectionHeader("Credits", primaryColor),
                GlassContainer(
                  color: glassTint,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: primaryColor.withOpacity(0.2),
                        child: Icon(Icons.person, size: 40, color: primaryColor),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Pradyumn",
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Mobile App Developer",
                        style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 6),
                      const Divider(indent: 40, endIndent: 40),
                      const SizedBox(height: 3),
                      Text(
                        "Brangunandan",
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "UI/UX Designer",
                        style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: _buildSocialButton(
                              icon: Icons.work_outline,
                              label: "LinkedIn",
                              color: const Color(0xFF0077B5),
                              onTap: () => _launchURL("https://www.linkedin.com/in/technopradyumn"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: _buildSocialButton(
                              icon: Icons.camera_alt_outlined,
                              label: "Instagram",
                              color: const Color(0xFFE4405F),
                              onTap: () => _launchURL("https://www.instagram.com/pradyumnx"),
                            ),
                          ),
                        ],
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
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.privacy_tip_outlined, color: primaryColor),
                        title: Text("Privacy Policy", style: textTheme.bodyLarge),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () => context.push(AppRouter.privacyPolicy),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- ABOUT ---
                _buildSectionHeader("About", primaryColor),
                GlassContainer(
                  color: glassTint,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Version", style: textTheme.bodyLarge),
                        trailing: Text(_version, style: TextStyle(color: onSurfaceColor.withOpacity(0.4))),
                      ),
                      ListTile(
                        title: Text("Build Number", style: textTheme.bodyLarge),
                        trailing: Text(_buildNumber, style: TextStyle(color: onSurfaceColor.withOpacity(0.4))),
                      ),
                      ListTile(
                        title: Text("Open Source Licenses", style: textTheme.bodyLarge),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          showLicensePage(
                            context: context,
                            applicationName: "CopyClip",
                            applicationVersion: _version,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: onSurfaceColor.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: onSurfaceColor.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 12, color: primaryColor.withOpacity(0.6)),
                      const SizedBox(width: 8),
                      Text(
                        "CRAFTED WITH EXCELLENCE",
                        style: textTheme.labelSmall?.copyWith(
                          color: onSurfaceColor.withOpacity(0.5),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
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

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}