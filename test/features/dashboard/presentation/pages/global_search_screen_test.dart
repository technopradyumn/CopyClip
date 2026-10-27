import 'dart:io';

import 'package:copyclip/src/core/providers/locale_provider.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_adapter.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';
import 'package:copyclip/src/features/dashboard/presentation/pages/global_search_screen.dart';
import 'package:copyclip/src/features/journal/data/journal_adapter.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/notes/data/note_adapter.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() {
  late GoRouter router;

  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp(
      'copyclip_search_screen_test_',
    );
    Hive.init(tempDir.path);
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(ClipboardItemAdapter());
  });

  setUp(() async {
    await Hive.openBox<Note>('notes_box');
    await Hive.openBox<Todo>('todos_box');
    await Hive.openBox<JournalEntry>('journal_box');
    await Hive.openBox<ClipboardItem>('clipboard_box');

    router = GoRouter(
      initialLocation: '/search',
      routes: [
        GoRoute(
          path: '/search',
          builder: (context, state) => const GlobalSearchScreen(),
        ),
        GoRoute(
          path: '/todos',
          builder: (context, state) =>
              const Scaffold(body: Text('Todos route')),
        ),
      ],
    );
  });

  tearDown(() async {
    router.dispose();
    await Hive.close();
    for (final boxName in [
      'notes_box',
      'todos_box',
      'journal_box',
      'clipboard_box',
    ]) {
      await Hive.deleteBoxFromDisk(boxName);
    }
  });

  testWidgets('search app bar opens drawer from its leading menu button', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(create: (_) => PremiumBloc()),
        ],
        child: ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.leading, isA<Builder>());
    expect(
      find.descendant(
        of: find.byWidget(appBar.leading!),
        matching: find.byKey(const ValueKey('global_search_menu')),
      ),
      findsOneWidget,
    );
    expect(appBar.actions, isNull);
    expect(find.byKey(const ValueKey('global_search_back')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('global_search_menu')));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(Drawer), findsOneWidget);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold).first).isDrawerOpen,
      isTrue,
    );

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
