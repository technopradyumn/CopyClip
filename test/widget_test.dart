import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:copyclip/main.dart';
import 'package:copyclip/src/core/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const pathChannel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, (_) async => '.');

    const adsChannel = MethodChannel('plugins.flutter.io/google_mobile_ads');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(adsChannel, (_) async => null);

    await Hive.initFlutter();
    await Hive.openBox('settings');
    await Hive.openBox('theme_box');
  });

  testWidgets('App launches without crashing', (tester) async {
    final autoSaveService = ClipboardAutoSaveService();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeManager(),
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) {
            return CopyClipApp(autoSaveService: autoSaveService);
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
