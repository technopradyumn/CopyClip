import 'dart:io';

import 'package:copyclip/src/core/providers/locale_provider.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/features/notes/presentation/pages/notes_screen.dart';
import 'package:copyclip/src/features/notes/presentation/widgets/note_card.dart';
import 'package:copyclip/src/features/notes/data/note_adapter.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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
    await noteBox.close();
    // Ensure box is deleted to clean up for next test if re-opened
    await Hive.deleteBoxFromDisk('notes_box');
  });

  testWidgets('NotesScreen renders empty state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(create: (_) => PremiumBloc()),
        ],
        child: MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => LocaleProvider())],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: NotesScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('No notes found'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('NotesScreen renders list of notes', (WidgetTester tester) async {
    final note = Note(
      id: '1',
      title: 'My First Note',
      content: 'Hello World',
      updatedAt: DateTime.now(),
    );
    await tester.runAsync(() => noteBox.put(note.id, note));

    await tester.pumpWidget(
      _withAppProviders(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NotesScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('My First Note'), findsOneWidget);
    expect(find.text('Hello World'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('NotesScreen filtering works', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await noteBox.put(
        '1',
        Note(id: '1', title: 'Alpha', content: 'A', updatedAt: DateTime.now()),
      );
      await noteBox.put(
        '2',
        Note(id: '2', title: 'Beta', content: 'B', updatedAt: DateTime.now()),
      );
    });

    await tester.pumpWidget(
      _withAppProviders(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NotesScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(NoteCard), findsNWidgets(2));
    expect(find.text('Beta'), findsOneWidget);

    // Enter search text
    await tester.enterText(find.byType(TextField), 'Alpha');
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(NoteCard), findsOneWidget);
    expect(find.text('Beta'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Widget _withAppProviders(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeBloc()),
      BlocProvider(create: (_) => PremiumBloc()),
    ],
    child: MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LocaleProvider())],
      child: child,
    ),
  );
}
