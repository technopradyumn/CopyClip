import 'dart:io';

import 'package:copyclip/src/features/canvas/presentation/pages/canvs_screen.dart';
import 'package:copyclip/src/features/canvas/data/canvas_adapter.dart';
import 'package:copyclip/src/features/canvas/data/canvas_model.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:go_router/go_router.dart';

void main() {
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
    folderBox = await Hive.openBox<CanvasFolder>('canvas_folders');
    noteBox = await Hive.openBox<CanvasNote>('canvas_notes');

    // Ensure default folder exists as the screen expects it or database init creates it
    if (folderBox.isEmpty) {
      await folderBox.put(
        'default',
        CanvasFolder(id: 'default', name: 'My Sketches'),
      );
    }

    // Initialize singleton to avoid LateInitializationError
    await CanvasDatabase().init();
  });

  tearDown(() async {
    await folderBox.clear();
    await noteBox.clear();
    await folderBox.close();
    await noteBox.close();
  });

  testWidgets('CanvasScreen renders default structure', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: CanvasScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Canvas'), findsOneWidget);
    expect(find.text('My Sketches'), findsOneWidget); // Default folder
    expect(find.textContaining('sketches'), findsOneWidget); // Stats
  });

  testWidgets('CanvasScreen renders a sketch card', (
    WidgetTester tester,
  ) async {
    final note = CanvasNote(
      id: '1',
      title: 'Amazing Drawing',
      folderId: 'default',
      pages: [],
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      backgroundColor: Colors.white,
    );
    await noteBox.put('1', note);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => CanvasScreen()),
        GoRoute(
          name: AppRouter.canvasEdit,
          path: '/edit',
          builder: (context, state) => Scaffold(body: Text('Edit Canvas')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Amazing Drawing'), findsOneWidget);

    // Tap it
    await tester.tap(find.text('Amazing Drawing'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Canvas'), findsOneWidget);
  });
}
