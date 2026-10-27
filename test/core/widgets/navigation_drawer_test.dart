import 'package:bloc_test/bloc_test.dart';
import 'package:copyclip/src/core/const/constant.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/theme/background_design.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/navigation_drawer.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late GoRouter router;
  late MockThemeBloc themeBloc;

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

    await tester.dragFrom(const Offset(1, 200), const Offset(260, 0));
    await tester.pumpAndSettle();

    expect(find.text('Route: /notes'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Notes')).style?.color,
      FeatureColors.notes,
    );
    await tester.tap(find.text('To-Dos'));
    await tester.pumpAndSettle();
    expect(find.text('Route: /todos'), findsOneWidget);

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

  testWidgets('drawer can switch from system to dark mode', (tester) async {
    await tester.pumpWidget(_testApp(router, themeBloc));
    await tester.pump();
    await tester.dragFrom(const Offset(1, 200), const Offset(260, 0));
    await tester.pumpAndSettle();
    await _scrollDrawerToTheme(tester);

    await tester.tap(find.byKey(const ValueKey('theme_mode_dark')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('theme_mode_tile')),
        matching: find.byIcon(CupertinoIcons.chevron_right),
      ),
      findsNothing,
    );
    verify(
      () => themeBloc.add(const ChangeThemeMode(ThemeMode.dark)),
    ).called(1);
  });

  testWidgets('drawer can switch from dark mode back to system mode', (
    tester,
  ) async {
    when(() => themeBloc.state).thenReturn(_themeState(ThemeMode.dark));
    await tester.pumpWidget(_testApp(router, themeBloc));
    await tester.pump();
    await tester.dragFrom(const Offset(1, 200), const Offset(260, 0));
    await tester.pumpAndSettle();
    await _scrollDrawerToTheme(tester);
    await tester.tap(find.byKey(const ValueKey('theme_mode_system')));
    await tester.pumpAndSettle();

    verify(
      () => themeBloc.add(const ChangeThemeMode(ThemeMode.system)),
    ).called(1);
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

Future<void> _scrollDrawerToTheme(WidgetTester tester) async {
  await tester.drag(find.byType(ListView).first, const Offset(0, -900));
  await tester.pumpAndSettle();
}

Widget _featureScreen(String path) {
  return GlassScaffold(
    showDrawer: true,
    drawer: const CopyClipDrawer(),
    body: Center(child: Text('Route: $path')),
  );
}
