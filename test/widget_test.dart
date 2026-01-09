// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:copyclip/main.dart';
import 'package:copyclip/src/core/theme/theme_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Hive.initFlutter();
    await Hive.openBox('settings');
    await Hive.openBox('theme_box');
  });

  testWidgets('App launches without crashing', (WidgetTester tester) async {
    final autoSaveService = ClipboardAutoSaveService();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeManager(),
        child: CopyClipApp(autoSaveService: autoSaveService),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

