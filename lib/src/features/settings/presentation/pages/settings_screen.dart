import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import '../../../../core/services/backup_service.dart';
import '../../../../core/theme/theme_manager.dart';

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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkServiceStatus();
    }
  }

  Future<void> _checkServiceStatus() async {
    try {
      final bool status = await platform.invokeMethod('isServiceEnabled');
      setState(() => _isServiceEnabled = status);
    } catch (e) {
      debugPrint("Status check failed: $e");
    }
  }

  // --- GLASS SNACKBAR ---
  void _showGlassSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    final theme = Theme.of(context);
    final color = isError ? theme.colorScheme.error : Colors.greenAccent;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.5), width: 1),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, spreadRadius: 5),
                ],
              ),
              child: Row(
                children: [
                  Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- DIALOG LOGIC ---

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Backup Data",
        content: "Save a JSON file containing all your data?",
        confirmText: "Export Now",
        isDestructive: false,
        onConfirm: () async {
          Navigator.pop(ctx);
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) return;

          try {
            await BackupService.createBackup(context);
          } catch (e) {
            _showGlassSnackBar("Export failed: ${e.toString().split(':').last}", isError: true);
          }
        },
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Import Data",
        content: "Select a backup file to merge with your current data. Existing items will not be overwritten.",
        confirmText: "Select File",
        isDestructive: false, // Changed to false since we are appending
        onConfirm: () async {
          Navigator.pop(ctx);
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) return;

          try {
            final int addedCount = await BackupService.restoreBackup(context);
            _showGlassSnackBar("Success! $addedCount new items added.");
          } catch (e) {
            if (!e.toString().contains("cancelled")) {
              _showGlassSnackBar("Import failed: ${e.toString().split(':').last}", isError: true);
            }
          }
        },
      ),
    );
  }

  // --- BUILD UI ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;
    final dividerColor = theme.dividerColor;
    final textTheme = theme.textTheme;
    final themeManager = Provider.of<ThemeManager>(context);

    final glassTint = primaryColor.withOpacity(0.08);

    return GlassScaffold(
      title: "Settings",
      showBackArrow: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          physics: const BouncingScrollPhysics(),
          children: [

            // --- APPEARANCE ---
            Text("Appearance", style: textTheme.titleMedium?.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GlassContainer(
              color: glassTint,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.brightness_6, color: primaryColor),
                    title: Text("Theme Mode", style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor)),
                    subtitle: Text(
                      _getThemeModeName(themeManager.themeMode),
                      style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.54)),
                    ),
                    trailing: _buildThemeDropdown(context, themeManager),
                  ),
                  Divider(color: dividerColor, height: 1),
                  ListTile(
                    leading: Icon(Icons.palette, color: primaryColor),
                    title: Text("Accent Color", style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor)),
                    subtitle: Text("Customize app identity", style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.54))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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

            // --- GENERAL ---
            Text("General", style: textTheme.titleMedium?.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GlassContainer(
              color: glassTint,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: Icon(
                  _isServiceEnabled ? Icons.bolt : Icons.bolt_outlined,
                  color: _isServiceEnabled ? Colors.greenAccent : onSurfaceColor.withOpacity(0.54),
                ),
                title: Text("Auto Clipboard Capture", style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor)),
                subtitle: Text(
                  _isServiceEnabled ? "Service is active" : "Requires Accessibility Permission",
                  style: TextStyle(
                      color: _isServiceEnabled ? Colors.greenAccent : onSurfaceColor.withOpacity(0.54),
                      fontSize: 12
                  ),
                ),
                trailing: Switch(
                  value: _isServiceEnabled,
                  activeColor: primaryColor,
                  onChanged: (val) async {
                    await platform.invokeMethod('openAccessibilitySettings');
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- DATA & BACKUP ---
            Text("Data & Backup", style: textTheme.titleMedium?.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GlassContainer(
              color: glassTint,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.upload_file, color: primaryColor),
                    title: Text("Export Data", style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor)),
                    subtitle: Text("Save backup file", style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.54))),
                    onTap: () => _showExportDialog(context),
                  ),
                  Divider(color: dividerColor, height: 1),
                  ListTile(
                    leading: Icon(Icons.download, color: primaryColor),
                    title: Text("Import Data", style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor)),
                    subtitle: Text("Merge backup with current data", style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.54))),
                    onTap: () => _showImportDialog(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- ABOUT ---
            Text("About", style: textTheme.titleMedium?.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GlassContainer(
              color: glassTint,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: ListTile(
                title: Text("Version", style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor)),
                trailing: Text("1.0.0", style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor.withOpacity(0.38))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system: return "System Default";
      case ThemeMode.light: return "Light Mode";
      case ThemeMode.dark: return "Dark Mode";
    }
  }

  Widget _buildThemeDropdown(BuildContext context, ThemeManager manager) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ThemeMode>(
          value: manager.themeMode,
          dropdownColor: theme.cardColor,
          icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
          style: theme.textTheme.bodyMedium,
          items: const [
            DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
            DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
            DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
          ],
          onChanged: (ThemeMode? newMode) {
            if (newMode != null) manager.setThemeMode(newMode);
          },
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color, ThemeManager manager) {
    final bool isSelected = manager.primaryColor.value == color.value;
    return GestureDetector(
      onTap: () => manager.setPrimaryColor(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 2.5) : null,
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: isSelected ? 8 : 4,
                spreadRadius: isSelected ? 2 : 1
            )
          ],
        ),
        child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.black) : null,
      ),
    );
  }
}