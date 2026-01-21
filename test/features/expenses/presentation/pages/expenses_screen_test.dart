import 'dart:io';

import 'package:copyclip/src/features/expenses/data/expense_adapter.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:copyclip/src/features/expenses/presentation/pages/expenses_screen.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

void main() {
  late Box<Expense> expenseBox;

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ExpenseAdapter());
    }
  });

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel('home_widget'), (
          MethodCall methodCall,
        ) async {
          return null;
        });

    expenseBox = await Hive.openBox<Expense>('expenses_box');
  });

  tearDown(() async {
    await expenseBox.clear();
    await expenseBox.close();
  });

  testWidgets('ExpenseScreen renders empty state', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ExpensesScreen()));
    await tester.pumpAndSettle();

    // Verify empty state text or button
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
    // Is there a "No expenses" text? Code usually has one.
    // Let's assume there's one or just check FAB.
  });

  testWidgets('ExpenseScreen renders list of expenses', (
    WidgetTester tester,
  ) async {
    final expense = Expense(
      id: '1',
      title: 'Coffee',
      amount: 5.50,
      currency: '\$',
      date: DateTime.now(),
      category: 'Food',
      isIncome: false,
    );
    await expenseBox.put(expense.id, expense);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => ExpensesScreen()),
        GoRoute(
          name: AppRouter.expenseEdit,
          path: '/edit',
          builder: (context, state) => Scaffold(body: Text('Edit')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Coffee'), findsOneWidget);
    // Amount formatting might differ, e.g. "$5.50"
    expect(find.textContaining('5.50'), findsOneWidget);
  });
}
