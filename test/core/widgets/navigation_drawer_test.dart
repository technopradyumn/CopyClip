import 'dart:async';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/services/navigation_preference_service.dart';
import 'package:copyclip/src/core/theme/background_design.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/navigation_drawer.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_adapter.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';
import 'package:copyclip/src/features/journal/data/journal_adapter.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/notes/data/note_adapter.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/features/settings/recycle_bin_screen.dart';
import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late GoRouter router;
  late MockThemeBloc themeBloc;

  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp(
      'copyclip_navigation_test_',
    );
    Hive.init(tempDir.path);
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(ClipboardItemAdapter());
    await Hive.openBox('settings');
    await Hive.openBox<Note>('notes_box');
    await Hive.openBox<Todo>('todos_box');
    await Hive.openBox<JournalEntry>('journal_box');
    await Hive.openBox<ClipboardItem>('clipboard_box');
  });

  setUp(() {
    themeBloc = MockThemeBloc();
    when(() => themeBloc.state).thenReturn(_themeState(ThemeMode.system));
    router = GoRouter(
      initialLocation: AppRouter.notes,
      routes: [
        GoRoute(
          path: AppRouter.notes,
          builder: (context, state) => _featureScreen(state.uri.path),
        ),
        GoRoute(
          path: AppRouter.todos,
          builder: (context, state) => _featureScreen(state.uri.path),
        ),
        GoRoute(
          path: AppRouter.recycleBin,
          builder: (context, state) => _featureScreen(state.uri.path),
        ),
        GoRoute(
          path: AppRouter.globalSearch,
          builder: (context, state) => Scaffold(
            body: Text('Search query: ${state.uri.queryParameters['q'] ?? ''}'),
          ),
        ),
      ],
    );
  });

  tearDown(() {
    router.dispose();
  });

  testWidgets('drawer switches sections and follows the selected route', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(router, themeBloc));
    await tester.pump();

    expect(
      tester
          .widget<Scaffold>(find.byType(Scaffold).first)
          .drawerEnableOpenDragGesture,
      isTrue,
    );
    await tester.dragFrom(const Offset(1, 200), const Offset(260, 0));
    await tester.pumpAndSettle();

    expect(find.text('Privacy Policy'), findsNothing);
    expect(find.text('Send Feedback'), findsNothing);
    expect(find.text('Theme Mode'), findsNothing);
    expect(find.text('Route: /notes'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Notes')).style?.color,
      FeatureColors.notes,
    );
    await tester.tap(find.text('To-Dos'));
    await tester.pumpAndSettle();
    expect(find.text('Route: /todos'), findsOneWidget);
    expect(NavigationPreferenceService.getLastDrawerRoute(), AppRouter.todos);

    await tester.dragFrom(const Offset(1, 200), const Offset(260, 0));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text('To-Dos')).style?.color,
      FeatureColors.todos,
    );

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    expect(find.text('Route: /notes'), findsOneWidget);
  });

  testWidgets('system back from Recycle Bin opens Settings', (tester) async {
    final recycleRouter = GoRouter(
      initialLocation: AppRouter.recycleBin,
      routes: [
        GoRoute(
          path: AppRouter.recycleBin,
          builder: (context, state) => const RecycleBinScreen(),
        ),
        GoRoute(
          path: AppRouter.settings,
          builder: (context, state) =>
              const Scaffold(body: Text('Settings destination')),
        ),
      ],
    );

    await tester.pumpWidget(_recycleTestApp(recycleRouter));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Settings destination'), findsOneWidget);
    expect(
      recycleRouter.routeInformationProvider.value.uri.path,
      AppRouter.settings,
    );
    recycleRouter.dispose();
  });

  test('only overview items are eligible for startup restoration', () {
    unawaited(NavigationPreferenceService.saveLastDrawerRoute(AppRouter.todos));
    expect(AppRouter.lastDrawerRoute, AppRouter.todos);

    unawaited(
      NavigationPreferenceService.saveLastDrawerRoute(AppRouter.settings),
    );
    expect(AppRouter.lastDrawerRoute, AppRouter.notes);
  });

  testWidgets('drawer search passes entered query to search route', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(router, themeBloc));
    await tester.pump();
    await tester.dragFrom(const Offset(1, 200), const Offset(260, 0));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'meeting notes');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Search query: meeting notes'), findsOneWidget);
  });
}

class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {}

ThemeState _themeState(ThemeMode mode) {
  return ThemeState(
    themeMode: mode,
    primaryColor: Colors.blue,
    backgroundDesign: BackgroundDesign.classicBubbles,
    themeData: ThemeData(),
  );
}

Widget _testApp(GoRouter router, ThemeBloc themeBloc) {
  return MultiBlocProvider(
    providers: [
      BlocProvider.value(value: themeBloc),
      BlocProvider(create: (_) => PremiumBloc()),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

Widget _recycleTestApp(GoRouter router) {
  return MultiBlocProvider(
    providers: [BlocProvider(create: (_) => PremiumBloc())],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    ),
  );
}

Widget _featureScreen(String path) {
  return GlassScaffold(
    showDrawer: true,
    drawer: const CopyClipDrawer(),
    body: Center(child: Text('Route: $path')),
  );
}
