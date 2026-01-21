import 'dart:io';

import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:copyclip/src/features/expenses/data/expense_adapter.dart';
import 'package:copyclip/src/features/expenses/services/expense_notification_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'expense_notification_handler_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NotificationService>()])
void main() {
  late ExpenseNotificationHandler notificationHandler;
  late MockNotificationService mockNotificationService;
  late Box<Expense> expenseBox;

  setUpAll(() async {
    tz.initializeTimeZones();
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ExpenseAdapter());
    }
  });

  setUp(() async {
    mockNotificationService = MockNotificationService();
    notificationHandler = ExpenseNotificationHandler();
    notificationHandler.notificationService = mockNotificationService;

    expenseBox = await Hive.openBox<Expense>('expenses_box');
  });

  tearDown(() async {
    try {
      if (expenseBox.isOpen) await expenseBox.clear();
      await expenseBox.close();
      await Hive.deleteBoxFromDisk('expenses_box');
    } catch (_) {}
  });

  test('Notify if no expense logged today', () async {
    await notificationHandler.checkAndNotify(
      now: DateTime(2023, 10, 10, 10, 0),
    );

    verify(
      mockNotificationService.showInstantNotification(
        id: 9901,
        title: anyNamed('title'),
        body: anyNamed('body'),
        channelId: 'expenses',
        payload: 'expenses',
      ),
    ).called(1);
  });

  test('Do not notify if expense logged today', () async {
    final fixedNow = DateTime(2023, 10, 10, 10, 0);
    final expense = Expense(
      id: '1',
      title: 'Coffee',
      amount: 5.0,
      currency: '\$',
      date: fixedNow,
      category: 'Food',
      isIncome: false,
    );
    await expenseBox.put(expense.id, expense);

    await notificationHandler.checkAndNotify(now: fixedNow);

    verifyNever(
      mockNotificationService.showInstantNotification(
        id: any,
        title: any,
        body: any,
        channelId: any,
        payload: any,
      ),
    );
  });
}
