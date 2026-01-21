import 'dart:io';

import 'package:copyclip/src/features/calendar/presentation/pages/calendar_screen.dart';
import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/features/journal/data/journal_adapter.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/expenses/data/expense_adapter.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:copyclip/src/features/notes/data/note_adapter.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_adapter.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';
import 'package:copyclip/src/core/router/app_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  late Box<Todo> todoBox;
  late Box<JournalEntry> journalBox;
  late Box<Expense> expenseBox;
  late Box<Note> noteBox;
  late Box<ClipboardItem> clipboardBox;

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting();

    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(NoteAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TodoAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(ExpenseAdapter());
    if (!Hive.isAdapterRegistered(4))
      Hive.registerAdapter(JournalEntryAdapter());
    if (!Hive.isAdapterRegistered(5))
      Hive.registerAdapter(ClipboardItemAdapter());
  });

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel('home_widget'), (
          MethodCall methodCall,
        ) async {
          return null;
        });

    todoBox = await Hive.openBox<Todo>('todos_box');
    journalBox = await Hive.openBox<JournalEntry>('journal_box');
    expenseBox = await Hive.openBox<Expense>('expenses_box');
    noteBox = await Hive.openBox<Note>('notes_box');
    clipboardBox = await Hive.openBox<ClipboardItem>('clipboard_box');
  });

  tearDown(() async {
    await todoBox.clear();
    await journalBox.clear();
    await expenseBox.clear();
    await noteBox.clear();
    await clipboardBox.clear();

    await todoBox.close();
    await journalBox.close();
    await expenseBox.close();
    await noteBox.close();
    await clipboardBox.close();
  });

  testWidgets('CalendarScreen renders and shows events', (
    WidgetTester tester,
  ) async {
    final today = DateTime.now();

    // Seed Data
    await todoBox.put(
      '1',
      Todo(
        id: '1',
        task: 'Task 1',
        category: 'General',
        isDone: false,
        dueDate: today,
      ),
    );
    await journalBox.put(
      '1',
      JournalEntry(id: '1', title: 'Start', content: 'C', date: today),
    );
    await expenseBox.put(
      '1',
      Expense(
        id: '1',
        title: 'Coffee',
        amount: 5,
        currency: '\$',
        date: today,
        category: 'Food',
        isIncome: false,
      ),
    );
    await noteBox.put(
      '1',
      Note(id: '1', title: 'Note 1', content: 'C', updatedAt: today),
    );
    await clipboardBox.put(
      '1',
      ClipboardItem(id: '1', content: 'Clip', createdAt: today, type: 'text'),
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => CalendarScreen()),
        GoRoute(
          name: AppRouter.dateDetail,
          path: '/detail',
          builder: (context, state) => Scaffold(body: Text('Details')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Calendar'), findsOneWidget);

    // Verify Stats
    // "Daily Activity" -> 5 items
    expect(find.text('5'), findsOneWidget);

    // "Expenses" -> $5
    expect(find.textContaining('\$5'), findsOneWidget);

    // Verify Calendar Widget exists
    // TableCalendar is complex, but we can look for "Calendar" text or similar.
    // Or we can tap a day.
  });
}
