import 'dart:io';

import 'package:copyclip/src/features/notes/presentation/pages/notes_screen.dart';
import 'package:copyclip/src/features/notes/data/note_adapter.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

void main() {
  late Box<Note> noteBox;

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteAdapter());
    }
  });

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel('home_widget'), (
          MethodCall methodCall,
        ) async {
          return null;
        });

    noteBox = await Hive.openBox<Note>('notes_box');
  });

  tearDown(() async {
    if (noteBox.isOpen) await noteBox.clear();
    await noteBox.close();
    // Ensure box is deleted to clean up for next test if re-opened
    await Hive.deleteBoxFromDisk('notes_box');
  });

  testWidgets('NotesScreen renders empty state', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NotesScreen()));
    await tester.pumpAndSettle();

    expect(find.text('No notes found.'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('NotesScreen renders list of notes', (WidgetTester tester) async {
    final note = Note(
      id: '1',
      title: 'My First Note',
      content: 'Hello World',
      updatedAt: DateTime.now(),
    );
    await noteBox.put(note.id, note);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => NotesScreen()),
        GoRoute(
          name: AppRouter.noteEdit,
          path: '/edit',
          builder: (context, state) => Scaffold(body: Text('Edit Note')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('My First Note'), findsOneWidget);
    expect(find.text('Hello World'), findsOneWidget);

    // Test navigation
    await tester.tap(find.text('My First Note'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Note'), findsOneWidget);
  });

  testWidgets('NotesScreen filtering works', (WidgetTester tester) async {
    await noteBox.put(
      '1',
      Note(id: '1', title: 'Alpha', content: 'A', updatedAt: DateTime.now()),
    );
    await noteBox.put(
      '2',
      Note(id: '2', title: 'Beta', content: 'B', updatedAt: DateTime.now()),
    );

    await tester.pumpWidget(MaterialApp(home: NotesScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);

    // Enter search text
    await tester.enterText(find.byType(TextField), 'Alpha');
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsNothing);
  });
}
