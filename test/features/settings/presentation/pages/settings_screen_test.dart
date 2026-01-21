import 'dart:io';

import 'package:copyclip/src/features/settings/presentation/pages/settings_screen.dart';
import 'package:copyclip/src/core/theme/theme_manager.dart';
import 'package:copyclip/src/features/premium/presentation/provider/premium_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:package_info_plus/package_info_plus.dart';

// Mock Provider to avoid Ad Loading
class MockPremiumProvider extends ChangeNotifier implements PremiumProvider {
  @override
  int get coins => 100;

  @override
  bool get isPremium => true;

  @override
  bool get isAdLoading => false;

  @override
  DateTime? get premiumExpiryDate => DateTime.now().add(Duration(days: 30));

  @override
  Future<void> addCoins(int amount) async {}

  @override
  Future<bool> buyPremium() async => true;

  @override
  Future<void> showRewardedAd({required Function(int) onReward}) async {}
}

void main() {
  late Box settingsBox;
  late Box themeBox;

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    PackageInfo.setMockInitialValues(
      appName: 'CopyClip',
      packageName: 'com.example.copyclip',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: 'test',
    );

    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
  });

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel('home_widget'), (
          MethodCall methodCall,
        ) async {
          return null; // Mock home_widget
        });

    // Ads platform channel mock (safe fallback)
    const MethodChannel(
      'plugins.flutter.io/google_mobile_ads',
    ).setMockMethodCallHandler((MethodCall call) async {
      return null;
    });

    settingsBox = await Hive.openBox('settings');
    themeBox = await Hive.openBox('theme_box');
  });

  tearDown(() async {
    if (settingsBox.isOpen) await settingsBox.clear();
    if (themeBox.isOpen) await themeBox.clear();
    await settingsBox.close();
    await themeBox.close();
  });

  testWidgets('SettingsScreen renders sections', (WidgetTester tester) async {
    final themeManager = ThemeManager();
    final premiumProvider = MockPremiumProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeManager>.value(value: themeManager),
          ChangeNotifierProvider<PremiumProvider>.value(value: premiumProvider),
        ],
        child: MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Premium'), findsOneWidget);
    expect(find.text('Home Screen Widgets'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Auto-save Clipboard'), findsOneWidget);
  });

  testWidgets('SettingsScreen toggles auto-save', (WidgetTester tester) async {
    final themeManager = ThemeManager();
    final premiumProvider = MockPremiumProvider(); // isPremium = true

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeManager>.value(value: themeManager),
          ChangeNotifierProvider<PremiumProvider>.value(value: premiumProvider),
        ],
        child: MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Find Switch for auto-save (first switch in list tile)
    final switchFinder = find.byType(Switch).first;
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(settingsBox.get('clipboardAutoSave'), true);
  });
}
