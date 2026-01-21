import 'dart:io';

import 'package:copyclip/src/features/journal/data/journal_adapter.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/journal/presentation/pages/journal_screen.dart';
import 'package:copyclip/src/core/router/app_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

void main() {
  late Box<JournalEntry> journalBox;

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;

    // Hive Global Setup
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(4))
      Hive.registerAdapter(JournalEntryAdapter());
  });

  setUp(() async {
    // Mock HomeWidget Channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel('home_widget'), (
          MethodCall methodCall,
        ) async {
          return null;
        });

    journalBox = await Hive.openBox<JournalEntry>('journal_box');
  });

  tearDown(() async {
    await journalBox.clear();
    await journalBox.close();
  });

  testWidgets('JournalScreen renders empty state', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: JournalScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Start writing your story.'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Journal'), findsOneWidget);
  });

  testWidgets('JournalScreen renders entries', (WidgetTester tester) async {
    final entry = JournalEntry(
      id: '1',
      title: 'My Day',
      content: 'It was great.',
      date: DateTime.now(),
      mood: 'Happy',
    );
    await journalBox.put(entry.id, entry);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => JournalScreen()),
        GoRoute(
          name: AppRouter.journalEdit,
          path: '/edit',
          builder: (context, state) => Scaffold(body: Text('Edit')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('My Day'), findsOneWidget);
    // Mood emoji for Happy is 😊
    expect(find.text('😊'), findsOneWidget);
  });
}
