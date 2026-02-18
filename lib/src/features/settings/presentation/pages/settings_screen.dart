import 'dart:async';
import 'dart:io';

import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/widgets/premium_badge.dart';
import 'package:copyclip/src/core/theme/background_design.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copyclip/src/core/widgets/background_painters.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/const/languages.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/services/backup_service.dart';
import '../../../../core/services/home_widget_service.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';
import 'recycle_bin_screen.dart';
import '../../../../features/premium/presentation/widgets/premium_lock_dialog.dart';
import '../../../../features/premium/presentation/bloc/premium_bloc.dart';

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
  premium,
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

  // ✅ Remove late final - will be computed lazily

  // ✅ AD VARIABLES
  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;

  // ✅ AD UNIT ID GETTER
  String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_INTERSTITIAL_AD_UNIT_ID'] ?? '';
    }
    // else if (Platform.isIOS) {
    //   return dotenv.env['IOS_INTERSTITIAL_AD_UNIT_ID'] ??
    //       '';
    // }
    return '';
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

    // ✅ Remove _sections initialization - compute lazily in build

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
    // Check premium status via context
    final isPremium = context.read<PremiumBloc>().state.isPremium;
    if (isPremium) return;

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
    final isPremium = context.read<PremiumBloc>().state.isPremium;
    if (isPremium) {
      onComplete();
      return;
    }

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

  List<SettingsSection> _createSections(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      SettingsSection(
        type: SettingsSectionType.premium,
        title: l10n.premium,
        builder: _buildPremiumSection,
      ),
      SettingsSection(
        type: SettingsSectionType.widgets,
        title: l10n.homeScreenWidgets,
        builder: _buildWidgetsSection,
      ),
      SettingsSection(
        type: SettingsSectionType.clipboard,
        title: l10n.clipboardTitle,
        builder: _buildClipboardSection,
      ),
      SettingsSection(
        type: SettingsSectionType.appearance,
        title: l10n.appearanceTitle,
        builder: _buildAppearanceSection,
      ),
      SettingsSection(
        type: SettingsSectionType.notifications,
        title: l10n.notificationsTitle,
        builder: _buildNotificationSection,
      ),
      SettingsSection(
        type: SettingsSectionType.recycleBin,
        title: l10n.recycleBin,
        builder: _buildRecycleBinSection,
      ),
      SettingsSection(
        type: SettingsSectionType.dataBackup,
        title: l10n.dataBackup,
        builder: _buildDataBackupSection,
      ),
      SettingsSection(
        type: SettingsSectionType.feedback,
        title: l10n.feedbackSupport,
        builder: _buildFeedbackSection,
      ),
      SettingsSection(
        type: SettingsSectionType.credits,
        title: l10n.creditsTitle,
        builder: _buildCreditsSection,
      ),
      SettingsSection(
        type: SettingsSectionType.privacy,
        title: l10n.privacyMaintenance,
        builder: _buildPrivacySection,
      ),
      SettingsSection(
        type: SettingsSectionType.about,
        title: l10n.aboutTitle,
        builder: _buildAboutSection,
      ),
      SettingsSection(type: SettingsSectionType.footer, builder: _buildFooter),
    ];
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
    }
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
    final l10n = AppLocalizations.of(context)!;
    _showSnackBar(value ? l10n.autoSaveEnabled : l10n.autoSaveDisabled);
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
        final l10n = AppLocalizations.of(context)!;
        _showSnackBar(l10n.permissionDeniedSettings, isError: true);
        await openAppSettings();
      } else if (!status.isGranted) {
        final l10n = AppLocalizations.of(context)!;
        _showSnackBar(l10n.notificationPermissionDenied, isError: true);
      } else {
        final l10n = AppLocalizations.of(context)!;
        _showSnackBar(l10n.notificationsEnabled);
      }
    } else {
      final l10n = AppLocalizations.of(context)!;
      _showSnackBar(l10n.redirectingToSettings);
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
        for (final item in toDelete) {
          await (item as HiveObject).delete();
        }
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
    if (Hive.isBoxOpen('notes_box')) {
      total += countDeleted(Hive.box<Note>('notes_box'));
    }
    if (Hive.isBoxOpen('todos_box')) {
      total += countDeleted(Hive.box<Todo>('todos_box'));
    }
    if (Hive.isBoxOpen('expenses_box')) {
      total += countDeleted(Hive.box<Expense>('expenses_box'));
    }
    if (Hive.isBoxOpen('journal_box')) {
      total += countDeleted(Hive.box<JournalEntry>('journal_box'));
    }
    if (Hive.isBoxOpen('clipboard_box')) {
      total += countDeleted(Hive.box<ClipboardItem>('clipboard_box'));
    }
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
            color: theme.colorScheme.surface.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.1),
              width: AppConstants.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isError
                    ? CupertinoIcons.exclamationmark_circle
                    : CupertinoIcons.checkmark_circle,
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: l10n.backupData,
        content: l10n.backupDataDesc,
        confirmText: l10n.exportNow,
        onConfirm: () {
          Navigator.pop(ctx);
          // ✅ TRIGGER AD HERE
          _showInterstitialAd(() async {
            try {
              await BackupService.createBackup(context);
              _showSnackBar(AppLocalizations.of(context)!.backupSaved);
            } catch (e) {
              _showSnackBar(
                AppLocalizations.of(context)!.exportFailed,
                isError: true,
              );
            }
          });
        },
      ),
    );
  }

  // ✅ MODIFIED: Shows Ad before Import
  void _showImportDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => GlassDialog(
        title: l10n.importData,
        content: l10n.importDataDesc,
        confirmText: l10n.selectFile,
        onConfirm: () {
          Navigator.pop(ctx);
          // ✅ TRIGGER AD HERE
          _showInterstitialAd(() async {
            try {
              final count = await BackupService.restoreBackup(context);
              _showSnackBar(AppLocalizations.of(context)!.importSuccess(count));
              setState(() {});
            } catch (e) {
              _showSnackBar(
                AppLocalizations.of(context)!.importFailed,
                isError: true,
              );
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
            _showSnackBar(AppLocalizations.of(context)!.widgetAdded(title));
          } else {
            // Some devices don't support auto-pinning or user cancelled
            _showSnackBar(
              AppLocalizations.of(context)!.widgetRequestSent,
              isError: false,
            );
          }
        }
      } catch (e) {
        debugPrint('Widget Add Error: $e');
        _showSnackBar(
          AppLocalizations.of(context)!.widgetAddFailed,
          isError: true,
        );
      }
    });
  }

  // --- LANGUAGE SELECTOR ---
  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height for many languages
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<LocaleProvider>(
              builder: (context, provider, _) {
                final current = provider.locale;
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.language,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.systemDefault,
                            ),
                            leading: const Icon(Icons.settings_system_daydream),
                            trailing: current == null
                                ? const Icon(Icons.check, color: Colors.blue)
                                : null,
                            onTap: () {
                              provider.clearLocale();
                              Navigator.pop(ctx);
                            },
                          ),
                          ...LanguageConstants.supportedLanguages.entries.map((
                            entry,
                          ) {
                            final code = entry.key;
                            final name = entry.value['name']!;
                            final flag = entry.value['flag']!;
                            final isSelected = current?.languageCode == code;

                            return ListTile(
                              title: Text(name),
                              leading: Text(
                                flag,
                                style: const TextStyle(fontSize: 24),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: Colors.blue)
                                  : null,
                              onTap: () {
                                provider.setLocale(Locale(code));
                                Navigator.pop(ctx);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
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
        'icon': CupertinoIcons.doc_text,
        'color': FeatureColors.notes,
      },
      {
        'id': 'todos',
        'title': 'To-Dos',
        'icon': CupertinoIcons.checkmark_circle,
        'color': FeatureColors.todos,
      },
      {
        'id': 'expenses',
        'title': 'Expense',
        'icon': CupertinoIcons.money_dollar,
        'color': FeatureColors.expenses,
      },
      {
        'id': 'journal',
        'title': 'Journal',
        'icon': CupertinoIcons.book,
        'color': FeatureColors.journal,
      },
      {
        'id': 'calendar',
        'title': 'Calendar',
        'icon': CupertinoIcons.calendar,
        'color': FeatureColors.calendar,
      },
      {
        'id': 'clipboard',
        'title': 'Clipboard',
        'icon': CupertinoIcons.doc_on_clipboard,
        'color': FeatureColors.clipboard,
      },
      {
        'id': 'canvas',
        'title': 'Canvas',
        'icon': CupertinoIcons.hand_draw,
        'color': FeatureColors.canvas,
      },
    ];

    return PremiumBadge(
      child: _SectionCard(
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
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(
                      AppConstants.cornerRadius * 0.5,
                    ),
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: AppConstants.borderWidth,
                    ),
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
      ),
    );
  }

  static Widget _buildPremiumSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    return _SectionCard(
      color: Colors.amber,
      child: ListTile(
        leading: const Icon(CupertinoIcons.star_fill, color: Colors.amber),
        title: Text(AppLocalizations.of(context)!.premiumFeatures),
        subtitle: Text(AppLocalizations.of(context)!.manageCoinsAdsPremium),
        trailing: const Icon(CupertinoIcons.chevron_forward, size: 14),
        onTap: () => context.push(AppRouter.premium),
      ),
    );
  }

  static Widget _buildClipboardSection(
    BuildContext context,
    _SettingsScreenState state,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Builder(
      builder: (context) {
        final isPremium = context.select(
          (PremiumBloc bloc) => bloc.state.isPremium,
        );
        return PremiumBadge(
          child: _SectionCard(
            color: primaryColor,
            child: ListTile(
              leading: Icon(
                CupertinoIcons.doc_on_clipboard,
                color: primaryColor,
              ),
              title: Text(
                "Auto-save Clipboard",
                style: theme.textTheme.bodyLarge,
              ),
              subtitle: Text(
                "Automatically save copied items",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              trailing: ValueListenableBuilder<bool>(
                valueListenable: state._clipboardAutoSaveNotifier,
                builder: (context, value, child) => Switch(
                  value: value,
                  onChanged: (newValue) {
                    if (isPremium) {
                      state._toggleAutoSave(newValue);
                    } else {
                      if (newValue) {
                        // Trying to enable
                        PremiumLockDialog.show(
                          context,
                          featureName: 'Auto-save Clipboard',
                          onUnlockOnce: () => state._toggleAutoSave(true),
                        );
                      } else {
                        // Allowing disable without ad? Yes, usually safe.
                        state._toggleAutoSave(false);
                      }
                    }
                  },
                  activeColor: primaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildAppearanceSection(
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
            leading: Icon(CupertinoIcons.globe, color: primaryColor),
            title: Text(
              AppLocalizations.of(context)!.language,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Consumer<LocaleProvider>(
              builder: (context, provider, _) {
                final locale = provider.locale;
                if (locale == null) {
                  return Text(
                    AppLocalizations.of(context)!.systemDefault,
                    style: theme.textTheme.bodySmall,
                  );
                }
                final code = locale.languageCode;
                final name =
                    LanguageConstants.supportedLanguages[code]?['name'] ??
                    code.toUpperCase();
                return Text(name, style: theme.textTheme.bodySmall);
              },
            ),
            trailing: const Icon(CupertinoIcons.chevron_forward, size: 14),
            onTap: () => state._showLanguageSelector(context),
          ),
          const Divider(indent: 50),
          ListTile(
            leading: Icon(CupertinoIcons.sun_max, color: primaryColor),
            title: Text(
              AppLocalizations.of(context)!.themeMode,
              style: theme.textTheme.bodyLarge,
            ),
            trailing: const _ThemeDropdown(),
          ),
          const Divider(indent: 50),
          ListTile(
            leading: Icon(CupertinoIcons.paintbrush, color: primaryColor),
            title: Text("Background Design", style: theme.textTheme.bodyLarge),
            subtitle: Text(
              "Choose from 10+ dynamic wallpapers",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            trailing: const Icon(CupertinoIcons.chevron_forward, size: 14),
            onTap: () => context.push(AppRouter.backgroundPicker),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: () => context.push(AppRouter.backgroundPicker),
              child: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: state.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: state.primaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return CustomPaint(
                                  painter:
                                      state.backgroundDesign ==
                                          BackgroundDesign.none
                                      ? null
                                      : _getPainter(
                                          state.backgroundDesign,
                                          0.5,
                                          state.primaryColor,
                                          theme.brightness == Brightness.dark,
                                        ),
                                );
                              },
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface.withValues(
                                  alpha: 0.8,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getDesignName(state.backgroundDesign),
                                style: TextStyle(
                                  color: state.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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
            isEnabled
                ? CupertinoIcons.bell_fill
                : CupertinoIcons.bell_slash_fill,
            color: primaryColor,
          ),
          title: Text(
            AppLocalizations.of(context)!.pushNotifications,
            style: theme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            isEnabled ? "Enabled" : "Disabled",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
        leading: Icon(CupertinoIcons.trash, color: primaryColor),
        title: Text("Recycle Bin", style: theme.textTheme.bodyLarge),
        subtitle: Text(
          "${state._getTrashCount()} items • Auto-deletes in 30 days",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        trailing: const Icon(CupertinoIcons.chevron_forward, size: 14),
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
    return PremiumBadge(
      child: _SectionCard(
        color: primaryColor,
        child: Column(
          children: [
            ListTile(
              leading: Icon(CupertinoIcons.cloud_upload, color: primaryColor),
              title: Text("Export Data", style: theme.textTheme.bodyLarge),
              onTap: state._showExportDialog,
            ),
            const Divider(indent: 50),
            ListTile(
              leading: Icon(CupertinoIcons.cloud_download, color: primaryColor),
              title: Text("Import Data", style: theme.textTheme.bodyLarge),
              onTap: state._showImportDialog,
            ),
          ],
        ),
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
      child: Column(
        children: [
          ListTile(
            leading: Icon(CupertinoIcons.star, color: primaryColor),
            title: Text("Rate App", style: theme.textTheme.bodyLarge),
            subtitle: Text(
              "Rate us on Play Store",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            trailing: const Icon(CupertinoIcons.chevron_forward, size: 14),
            onTap: () async {
              final url = Uri.parse(
                "https://play.google.com/store/apps/details?id=com.technopradyumn.copyclip",
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const Divider(indent: 50),
          ListTile(
            leading: Icon(CupertinoIcons.chat_bubble_2, color: primaryColor),
            title: Text("Send Feedback", style: theme.textTheme.bodyLarge),
            subtitle: Text(
              "Help us improve",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            trailing: const Icon(CupertinoIcons.chevron_forward, size: 14),
            onTap: () => context.push(AppRouter.feedback),
          ),
        ],
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
        leading: Icon(CupertinoIcons.lock_shield, color: primaryColor),
        title: Text("Privacy Policy", style: theme.textTheme.bodyLarge),
        trailing: const Icon(CupertinoIcons.chevron_forward, size: 14),
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
            title: Text(
              AppLocalizations.of(context)!.version,
              style: theme.textTheme.bodyLarge,
            ),
            trailing: Text(
              state._version,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.buildNumber,
              style: theme.textTheme.bodyLarge,
            ),
            trailing: Text(
              state._buildNumber,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Open Source Licenses",
              style: theme.textTheme.bodyLarge,
            ),
            trailing: const Icon(CupertinoIcons.chevron_forward, size: 14),
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
          color: onSurfaceColor.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: onSurfaceColor.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.sparkles,
              size: 12,
              color: primaryColor.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Text(
              "CRAFTED WITH EXCELLENCE",
              style: theme.textTheme.labelSmall?.copyWith(
                color: onSurfaceColor.withValues(alpha: 0.5),
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
      body: DynamicBackground(
        child: Column(
          children: [
            SeamlessHeader(
              title: AppLocalizations.of(context)!.settings,
              subtitle: AppLocalizations.of(context)!.settingsSubtitle,
              icon: CupertinoIcons.settings,
              iconColor: theme.colorScheme.primary,
              heroTagPrefix: 'settings',
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
                        final sections = _createSections(context);
                        final section = sections[index];
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
                      }, childCount: _createSections(context).length),
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
}

// --- Extracted Widgets ---

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
        border: Border.all(
          // ✅ FIX: Use dynamic border color based on theme/color
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : color.withValues(alpha: 0.3),
          width: AppConstants.borderWidth,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }
}

class _ThemeDropdown extends StatelessWidget {
  const _ThemeDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return DropdownButtonHideUnderline(
          child: DropdownButton<ThemeMode>(
            value: state.themeMode,
            icon: const Icon(CupertinoIcons.chevron_down),
            onChanged: (mode) {
              if (mode != null) {
                context.read<ThemeBloc>().add(ChangeThemeMode(mode));
              }
            },
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(AppLocalizations.of(context)!.system),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(AppLocalizations.of(context)!.light),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(AppLocalizations.of(context)!.dark),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker();

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
      children: _colors.map((color) => _ColorDot(color: color)).toList(),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) =>
          previous.primaryColor != current.primaryColor,
      builder: (context, state) {
        final isSelected = state.primaryColor.toARGB32() == color.toARGB32();
        return GestureDetector(
          onTap: () => context.read<ThemeBloc>().add(ChangePrimaryColor(color)),
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
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(
                    CupertinoIcons.checkmark,
                    size: 18,
                    color: Colors.black,
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _CreditsContent extends StatelessWidget {
  const _CreditsContent();
  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
            backgroundColor: primaryColor.withValues(alpha: 0.2),
            child: Icon(
              CupertinoIcons.person_fill,
              size: 40,
              color: primaryColor,
            ),
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
              color: onSurfaceColor.withValues(alpha: 0.6),
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
              color: onSurfaceColor.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: _SocialButton(
                  icon: CupertinoIcons.briefcase,
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
                  icon: CupertinoIcons.camera,
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
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
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

String _getDesignName(BackgroundDesign design) {
  switch (design) {
    case BackgroundDesign.classicBubbles:
      return "Bubbles";
    case BackgroundDesign.floatingStars:
      return "Stars";
    case BackgroundDesign.meshGradient:
      return "Mesh";
    case BackgroundDesign.nebulaCloud:
      return "Nebula";
    case BackgroundDesign.particleFlow:
      return "Particles";
    case BackgroundDesign.geometricFloat:
      return "Geometry";
    case BackgroundDesign.snowfall:
      return "Snow";
    case BackgroundDesign.matrixRain:
      return "Matrix";
    case BackgroundDesign.waveMotion:
      return "Waves";
    case BackgroundDesign.bokehBlur:
      return "Bokeh";
    case BackgroundDesign.aurora:
      return "Aurora";
    case BackgroundDesign.magicalSpells:
      return "Magic";
    case BackgroundDesign.deepForest:
      return "Forest";
    case BackgroundDesign.none:
      return "None";
  }
}

CustomPainter _getPainter(
  BackgroundDesign design,
  double value,
  Color color,
  bool isDark,
) {
  switch (design) {
    case BackgroundDesign.classicBubbles:
      return BubblesPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.floatingStars:
      return StarsPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.meshGradient:
      return MeshPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.nebulaCloud:
      return NebulaPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.particleFlow:
      return ParticlePainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.geometricFloat:
      return GeometricPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.snowfall:
      return SnowPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.matrixRain:
      return MatrixPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.waveMotion:
      return WavePainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.bokehBlur:
      return BokehPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.aurora:
      return AuroraPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.magicalSpells:
      return MagicalPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.deepForest:
      return ForestPainter(
        animationValue: value,
        primaryColor: color,
        isDark: isDark,
      );
    case BackgroundDesign.none:
      return BubblesPainter(
        animationValue: value,
        primaryColor: Colors.transparent,
        isDark: isDark,
      );
  }
}
