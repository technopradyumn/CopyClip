import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ Added for .env
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // ✅ Added for Ads
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/services/backup_service.dart';
import '../../../../core/services/home_widget_service.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';
import 'recycle_bin_screen.dart';

enum SettingsSectionType {
  clipboard,
  widgets,
  appearance,
  notifications,
  recycleBin,
  dataBackup,
  feedback,
  credits,
  privacy,
  about,
  footer,
}

class SettingsSection {
  const SettingsSection({
    required this.type,
    this.title,
    required this.builder,
  });

  final SettingsSectionType type;
  final String? title;
  final Widget Function(BuildContext, _SettingsScreenState) builder;
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late ScrollController _scrollController;

  String _version = "1.0.0";
  String _buildNumber = "1";

  final ValueNotifier<bool> _clipboardAutoSaveNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _notificationEnabledNotifier = ValueNotifier(false);

  late final List<SettingsSection> _sections;

  // ✅ AD VARIABLES
  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;

  // ✅ AD UNIT ID GETTER
  String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_INTERSTITIAL_AD_UNIT_ID'] ??
          'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return dotenv.env['IOS_INTERSTITIAL_AD_UNIT_ID'] ??
          'ca-app-pub-3940256099942544/4411468910';
    }
    return 'ca-app-pub-3940256099942544/1033173712';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _sections = _createSections();

    _runAutoCleanup();
    _initPackageInfo();
    _loadAutoSaveSettings();
    _checkNotificationPermission();

    // ✅ Load Ad on Init
    _loadInterstitialAd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNotificationPermission();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scrollController.dispose();
    _clipboardAutoSaveNotifier.dispose();
    _notificationEnabledNotifier.dispose();
    _interstitialAd?.dispose(); // ✅ Dispose Ad
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // --- AD LOGIC ---

  void _loadInterstitialAd() {
    if (_isAdLoading) return;
    _isAdLoading = true;

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Settings Interstitial Ad Loaded');
          _interstitialAd = ad;
          _isAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Settings Interstitial Ad Failed: $error');
          _interstitialAd = null;
          _isAdLoading = false;
        },
      ),
    );
  }

  /// Shows the ad and executes the [onComplete] callback when the ad is closed.
  void _showInterstitialAd(VoidCallback onComplete) {
    if (_interstitialAd == null) {
      debugPrint('⚠️ Ad not ready, proceeding with action...');
      onComplete(); // Proceed if ad failed to load
      _loadInterstitialAd(); // Try loading for next time
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('👋 Ad Dismissed - Executing Action');
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd(); // Preload next one
        onComplete(); // ✅ Execute Import/Export logic HERE
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('❌ Ad Failed to Show - Executing Action');
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
        onComplete(); // Ensure action happens even if ad fails
      },
    );

    // ✅ IMMERSIVE MODE: Helps prevent accidental back press, though standard interstitials
    // are strictly controlled by Google SDK and usually allow closing.
    _interstitialAd!.setImmersiveMode(true);
    _interstitialAd!.show();
  }

  // --- EXISTING LOGIC ---

  List<SettingsSection> _createSections() {
    return const [
      SettingsSection(
        type: SettingsSectionType.widgets,
        title: "Home Screen Widgets",
        builder: _buildWidgetsSection,
      ),
      SettingsSection(
        type: SettingsSectionType.clipboard,
        title: "Clipboard",
        builder: _buildClipboardSection,
      ),
      SettingsSection(
        type: SettingsSectionType.appearance,
        title: "Appearance",
        builder: _buildAppearanceSection,
      ),
      SettingsSection(
        type: SettingsSectionType.notifications,
        title: "Notifications",
        builder: _buildNotificationSection,
      ),
      SettingsSection(
        type: SettingsSectionType.recycleBin,
        title: "Recycle Bin",
        builder: _buildRecycleBinSection,
      ),
      SettingsSection(
        type: SettingsSectionType.dataBackup,
        title: "Data & Backup",
        builder: _buildDataBackupSection,
      ),
      SettingsSection(
        type: SettingsSectionType.feedback,
        title: "Feedback & Support",
        builder: _buildFeedbackSection,
      ),
      SettingsSection(
        type: SettingsSectionType.credits,
        title: "Credits",
        builder: _buildCreditsSection,
      ),
      SettingsSection(
        type: SettingsSectionType.privacy,
        title: "Privacy & Maintenance",
        builder: _buildPrivacySection,
      ),
      SettingsSection(
        type: SettingsSectionType.about,
        title: "About",
        builder: _buildAboutSection,
      ),
      SettingsSection(type: SettingsSectionType.footer, builder: _buildFooter),
    ];
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted)
      setState(() {
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
  }

  Future<void> _loadAutoSaveSettings() async {
    final settingsBox = Hive.box('settings');
    _clipboardAutoSaveNotifier.value =
        settingsBox.get('clipboardAutoSave', defaultValue: false) as bool;
  }

  Future<void> _toggleAutoSave(bool value) async {
    final settingsBox = Hive.box('settings');
    await settingsBox.put('clipboardAutoSave', value);
    _clipboardAutoSaveNotifier.value = value;
    _showSnackBar(value ? "Auto-save enabled." : "Auto-save disabled.");
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    _notificationEnabledNotifier.value = status.isGranted;
  }

  Future<void> _toggleNotification(bool value) async {
    if (value) {
      final status = await Permission.notification.request();
      _notificationEnabledNotifier.value = status.isGranted;
      if (status.isPermanentlyDenied) {
        _showSnackBar(
          "Permission permanently denied. Please enable in Settings.",
          isError: true,
        );
        await openAppSettings();
      } else if (!status.isGranted) {
        _showSnackBar("Notification permission denied.", isError: true);
      } else {
        _showSnackBar("Notifications enabled!");
      }
    } else {
      _showSnackBar("Redirecting to settings to disable notifications...");
      await openAppSettings();
    }
  }

  Future<void> _runAutoCleanup() async {
    const boxes = [
      'notes_box',
      'todos_box',
      'expenses_box',
      'journal_box',
      'clipboard_box',
    ];
    final now = DateTime.now();
    for (final boxName in boxes) {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        final toDelete = box.values.where((item) {
          try {
            final dynamic dItem = item;
            if (dItem.isDeleted == true && dItem.deletedAt != null) {
              return now.difference(dItem.deletedAt!).inDays >= 30;
            }
          } catch (e) {}
          return false;
        }).toList();
        for (final item in toDelete) await (item as HiveObject).delete();
      }
    }
  }

  int _getTrashCount() {
    int total = 0;
    int countDeleted(Box box) => box.values.where((item) {
      try {
        return (item as dynamic).isDeleted == true;
      } catch (_) {
        return false;
      }
    }).length;
    if (Hive.isBoxOpen('notes_box'))
      total += countDeleted(Hive.box<Note>('notes_box'));
    if (Hive.isBoxOpen('todos_box'))
      total += countDeleted(Hive.box<Todo>('todos_box'));
    if (Hive.isBoxOpen('expenses_box'))
      total += countDeleted(Hive.box<Expense>('expenses_box'));
    if (Hive.isBoxOpen('journal_box'))
      total += countDeleted(Hive.box<JournalEntry>('journal_box'));
    if (Hive.isBoxOpen('clipboard_box'))
      total += countDeleted(Hive.box<ClipboardItem>('clipboard_box'));
    return total;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    final theme = Theme.of(context);
    final color = isError ? theme.colorScheme.error : Colors.greenAccent;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ MODIFIED: Shows Ad before Export
  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Backup Data",
        content: "Save a JSON file containing all your data?",
        confirmText: "Export Now",
        onConfirm: () {
          Navigator.pop(ctx);
          // ✅ TRIGGER AD HERE
          _showInterstitialAd(() async {
            try {
              await BackupService.createBackup(context);
              _showSnackBar("Backup saved successfully!");
            } catch (e) {
              _showSnackBar("Export failed", isError: true);
            }
          });
        },
      ),
    );
  }

  // ✅ MODIFIED: Shows Ad before Import
  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: "Import Data",
        content: "Merge a backup file with your current items?",
        confirmText: "Select File",
        onConfirm: () {
          Navigator.pop(ctx);
          // ✅ TRIGGER AD HERE
          _showInterstitialAd(() async {
            try {
              final count = await BackupService.restoreBackup(context);
              _showSnackBar("Imported $count new items.");
              setState(() {});
            } catch (e) {
              _showSnackBar("Import failed", isError: true);
            }
          });
        },
      ),
    );
  }

  // --- WIDGET LOGIC ---
  void _handleWidgetAdd(String id, String title) {
    _showInterstitialAd(() async {
      try {
        final success = await HomeWidgetService.pinWidget(id);
        if (mounted) {
          if (success) {
            _showSnackBar("$title widget added to Home Screen!");
          } else {
            // Some devices don't support auto-pinning or user cancelled
            _showSnackBar(
              "Widget request sent (check home screen)",
              isError: false,
            );
          }
        }
      } catch (e) {
        debugPrint('Widget Add Error: $e');
        _showSnackBar("Failed to add widget", isError: true);
      }
    });
  }

  // --- SECTION BUILDERS (UNCHANGED) ---

  static Widget _buildWidgetsSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);

    final widgets = [
      {
        'id': 'notes',
        'title': 'Notes',
        'icon': Icons.note_alt_outlined,
        'color': Colors.amberAccent,
      },
      {
        'id': 'todos',
        'title': 'To-Dos',
        'icon': Icons.check_circle_outline,
        'color': Colors.greenAccent,
      },
      {
        'id': 'expenses',
        'title': 'Expense',
        'icon': Icons.attach_money,
        'color': Colors.redAccent,
      },
      {
        'id': 'journal',
        'title': 'Journal',
        'icon': Icons.book_outlined,
        'color': Colors.blueAccent,
      },
      {
        'id': 'calendar',
        'title': 'Calendar',
        'icon': Icons.calendar_today_outlined,
        'color': Colors.orangeAccent,
      },
      {
        'id': 'clipboard',
        'title': 'Clipboard',
        'icon': Icons.paste,
        'color': Colors.purpleAccent,
      },
      {
        'id': 'canvas',
        'title': 'Canvas',
        'icon': Icons.gesture,
        'color': Colors.tealAccent,
      },
    ];

    return _SectionCard(
      color: theme.colorScheme.primary,
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: widgets.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = widgets[index];
            final color = item['color'] as Color;
            return GestureDetector(
              onTap: () => state._handleWidgetAdd(
                item['id'] as String,
                item['title'] as String,
              ),
              child: Container(
                width: 70,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData, color: color, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _buildClipboardSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return _SectionCard(
      color: primaryColor,
      child: ListTile(
        leading: Icon(Icons.content_paste, color: primaryColor),
        title: Text("Auto-save Clipboard", style: theme.textTheme.bodyLarge),
        subtitle: Text(
          "Automatically save copied items",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        trailing: ValueListenableBuilder<bool>(
          valueListenable: state._clipboardAutoSaveNotifier,
          builder: (context, value, child) => Switch(
            value: value,
            onChanged: state._toggleAutoSave,
            activeColor: primaryColor,
          ),
        ),
      ),
    );
  }

  static Widget _buildAppearanceSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final themeManager = Provider.of<ThemeManager>(context);
    return _SectionCard(
      color: primaryColor,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.brightness_6, color: primaryColor),
            title: Text("Theme Mode", style: theme.textTheme.bodyLarge),
            trailing: _ThemeDropdown(manager: themeManager),
          ),
          const Divider(indent: 50),
          ListTile(
            leading: Icon(Icons.palette, color: primaryColor),
            title: Text("Accent Color", style: theme.textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _ColorPicker(manager: themeManager),
          ),
        ],
      ),
    );
  }

  static Widget _buildNotificationSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return _SectionCard(
      color: primaryColor,
      child: ValueListenableBuilder<bool>(
        valueListenable: state._notificationEnabledNotifier,
        builder: (context, isEnabled, _) => ListTile(
          leading: Icon(
            isEnabled ? Icons.notifications_active : Icons.notifications_off,
            color: primaryColor,
          ),
          title: Text("Push Notifications", style: theme.textTheme.bodyLarge),
          subtitle: Text(
            isEnabled ? "Enabled" : "Disabled",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          trailing: Switch(
            value: isEnabled,
            onChanged: state._toggleNotification,
            activeColor: primaryColor,
          ),
        ),
      ),
    );
  }

  static Widget _buildRecycleBinSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return _SectionCard(
      color: primaryColor,
      child: ListTile(
        leading: Icon(Icons.delete_sweep_outlined, color: primaryColor),
        title: Text("Recycle Bin", style: theme.textTheme.bodyLarge),
        subtitle: Text(
          "${state._getTrashCount()} items • Auto-deletes in 30 days",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecycleBinScreen()),
          );
          state.setState(() {});
        },
      ),
    );
  }

  static Widget _buildDataBackupSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return _SectionCard(
      color: primaryColor,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.upload_file, color: primaryColor),
            title: Text("Export Data", style: theme.textTheme.bodyLarge),
            onTap: state._showExportDialog,
          ),
          const Divider(indent: 50),
          ListTile(
            leading: Icon(Icons.download, color: primaryColor),
            title: Text("Import Data", style: theme.textTheme.bodyLarge),
            onTap: state._showImportDialog,
          ),
        ],
      ),
    );
  }

  static Widget _buildFeedbackSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return _SectionCard(
      color: primaryColor,
      child: ListTile(
        leading: Icon(Icons.feedback_outlined, color: primaryColor),
        title: Text("Send Feedback", style: theme.textTheme.bodyLarge),
        subtitle: Text(
          "Help us improve",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () => context.push(AppRouter.feedback),
      ),
    );
  }

  static Widget _buildCreditsSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    return _SectionCard(
      color: Theme.of(context).colorScheme.primary,
      child: const _CreditsContent(),
    );
  }

  static Widget _buildPrivacySection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return _SectionCard(
      color: primaryColor,
      child: ListTile(
        leading: Icon(Icons.privacy_tip_outlined, color: primaryColor),
        title: Text("Privacy Policy", style: theme.textTheme.bodyLarge),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () => context.push(AppRouter.privacyPolicy),
      ),
    );
  }

  static Widget _buildAboutSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return _SectionCard(
      color: primaryColor,
      child: Column(
        children: [
          ListTile(
            title: Text("Version", style: theme.textTheme.bodyLarge),
            trailing: Text(
              state._version,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
          ListTile(
            title: Text("Build Number", style: theme.textTheme.bodyLarge),
            trailing: Text(
              state._buildNumber,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Open Source Licenses",
              style: theme.textTheme.bodyLarge,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: "CopyClip",
                applicationVersion: state._version,
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildFooter(BuildContext context, _SettingsScreenState state) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: onSurfaceColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: onSurfaceColor.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 12,
              color: primaryColor.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              "CRAFTED WITH EXCELLENCE",
              style: theme.textTheme.labelSmall?.copyWith(
                color: onSurfaceColor.withOpacity(0.5),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return GlassScaffold(
      title: null,
      showBackArrow: false,
      body: Column(
        children: [
          _TopBar(
            rotationController: _rotationController,
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              cacheExtent: 2000,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final section = _sections[index];
                      return RepaintBoundary(
                        key: ValueKey(section.type),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (section.title != null)
                              _SectionHeader(
                                title: section.title!,
                                color: primaryColor,
                              ),
                            section.builder(context, this),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    }, childCount: _sections.length),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Extracted Widgets ---

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.rotationController,
    required this.onBackPressed,
  });
  final AnimationController rotationController;
  final VoidCallback onBackPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
            onPressed: onBackPressed,
          ),
          const SizedBox(width: 8),
          Hero(
            tag: 'settings_icon',
            child: Icon(Icons.settings_outlined, size: 32, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Text(
            "Settings",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.color});
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.color, required this.child});
  final Color color;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }
}

class _ThemeDropdown extends StatelessWidget {
  const _ThemeDropdown({required this.manager});
  final ThemeManager manager;
  @override
  Widget build(BuildContext context) {
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
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({required this.manager});
  final ThemeManager manager;
  static const _colors = [
    Colors.lightBlue,
    Colors.blueAccent,
    Colors.teal,
    Colors.purpleAccent,
    Colors.redAccent,
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _colors
          .map((color) => _ColorDot(color: color, manager: manager))
          .toList(),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, required this.manager});
  final Color color;
  final ThemeManager manager;
  @override
  Widget build(BuildContext context) {
    final isSelected = manager.primaryColor.value == color.value;
    return GestureDetector(
      onTap: () => manager.setPrimaryColor(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.white, width: 2.5)
              : null,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10)]
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 18, color: Colors.black)
            : null,
      ),
    );
  }
}

class _CreditsContent extends StatelessWidget {
  const _CreditsContent();
  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    return Padding(
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
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Mobile App Developer",
            style: theme.textTheme.bodySmall?.copyWith(
              color: onSurfaceColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 6),
          const Divider(indent: 40, endIndent: 40),
          const SizedBox(height: 3),
          Text(
            "Brangunandan",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "UI/UX Designer",
            style: theme.textTheme.bodySmall?.copyWith(
              color: onSurfaceColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: _SocialButton(
                  icon: Icons.work_outline,
                  label: "LinkedIn",
                  color: const Color(0xFF0077B5),
                  onTap: () => _launchURL(
                    context,
                    "https://www.linkedin.com/in/technopradyumn",
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: _SocialButton(
                  icon: Icons.camera_alt_outlined,
                  label: "Instagram",
                  color: const Color(0xFFE4405F),
                  onTap: () => _launchURL(
                    context,
                    "https://www.instagram.com/pradyumnx",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
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
