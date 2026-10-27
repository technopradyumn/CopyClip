import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:copyclip/main.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/core/providers/locale_provider.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/features/notes/data/note_adapter.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/journal/data/journal_adapter.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_adapter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final tempDir = await Directory.systemTemp.createTemp(
      'copyclip_widget_test_',
    );
    Hive.init(tempDir.path);
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(ClipboardItemAdapter());
    await Hive.openBox('settings');
    await Hive.openBox('theme_box');
    await Hive.openBox<Note>('notes_box');
  });

  setUp(() {
    isIntegrationTesting = true;
  });

  tearDown(() {
    isIntegrationTesting = false;
  });

  testWidgets('App launches without crashing', (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(create: (_) => PremiumBloc()),
        ],
        child: MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => LocaleProvider())],
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, __) {
              return const MainApp(); // MainApp uses ThemeBloc, PremiumBloc, LocaleProvider
            },
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
