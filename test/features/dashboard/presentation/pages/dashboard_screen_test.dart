import 'dart:io';

import 'package:copyclip/src/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:copyclip/src/features/canvas/data/canvas_adapter.dart';
import 'package:copyclip/src/features/canvas/data/canvas_model.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

void main() {
  late Box settingsBox;
  late Box<CanvasFolder> folderBox;
  late Box<CanvasNote> noteBox;

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(10))
      Hive.registerAdapter(DrawingStrokeAdapter());
    if (!Hive.isAdapterRegistered(11))
      Hive.registerAdapter(CanvasTextAdapter());
    if (!Hive.isAdapterRegistered(12))
      Hive.registerAdapter(CanvasFolderAdapter());
    if (!Hive.isAdapterRegistered(14))
      Hive.registerAdapter(CanvasPageAdapter());
    if (!Hive.isAdapterRegistered(15))
      Hive.registerAdapter(CanvasNoteAdapter());
  });

  setUp(() async {
    settingsBox = await Hive.openBox('settings');
    folderBox = await Hive.openBox<CanvasFolder>('canvas_folders');
    noteBox = await Hive.openBox<CanvasNote>('canvas_notes');

    // Ensure CanvasDatabase singleton is initialized implicitly by opening boxes?
    // The code calls CanvasDatabase() which is a singleton.
    // We should probably init it manually to be safe.
    await CanvasDatabase().init();
  });

  tearDown(() async {
    await settingsBox.clear();
    await folderBox.clear();
    await noteBox.clear();

    await settingsBox.close();
    await folderBox.close();
    await noteBox.close();
  });

  testWidgets('DashboardScreen renders features', (WidgetTester tester) async {
    // Set onboarding seen
    await settingsBox.put('has_seen_onboarding', true);

    await tester.pumpWidget(MaterialApp(home: DashboardScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('To-Dos'), findsOneWidget);
  });

  testWidgets('DashboardScreen navigates to feature', (
    WidgetTester tester,
  ) async {
    await settingsBox.put('has_seen_onboarding', true);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => DashboardScreen()),
        GoRoute(
          name: AppRouter.notes,
          path: '/notes',
          builder: (context, state) => Scaffold(body: Text('Notes Screen')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    final notesTile = find.text('Notes');
    expect(notesTile, findsOneWidget);

    await tester.tap(notesTile);
    await tester.pumpAndSettle();

    expect(find.text('Notes Screen'), findsOneWidget);
  });

  testWidgets('DashboardScreen shows onboarding if not seen', (
    WidgetTester tester,
  ) async {
    await settingsBox.put('has_seen_onboarding', false);

    await tester.pumpWidget(MaterialApp(home: DashboardScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to CopyClip'), findsOneWidget);
    expect(find.text('Get Started'), findsNothing); // Need to scroll/next
  });
}
