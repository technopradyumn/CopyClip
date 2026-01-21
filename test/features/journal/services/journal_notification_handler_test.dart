import 'dart:io';

import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/features/journal/data/journal_adapter.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/journal/services/journal_notification_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'journal_notification_handler_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NotificationService>()])
void main() {
  late JournalNotificationHandler notificationHandler;
  late MockNotificationService mockNotificationService;
  late Box<JournalEntry> journalBox;

  setUpAll(() async {
    tz.initializeTimeZones();

    // Hive Global Setup
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(JournalEntryAdapter());
    }
  });

  setUp(() async {
    mockNotificationService = MockNotificationService();
    notificationHandler = JournalNotificationHandler();
    notificationHandler.notificationService = mockNotificationService;

    // Open box for each test
    // Assuming box is not already open or was closed in tearDown
    journalBox = await Hive.openBox<JournalEntry>('journal_box');
  });

  tearDown(() async {
    try {
      if (journalBox.isOpen) await journalBox.clear();
      await journalBox.close();
      await Hive.deleteBoxFromDisk('journal_box');
    } catch (_) {}
  });

  test('Notify if no entry today', () async {
    // Box is empty
    await notificationHandler.checkAndNotify(
      now: DateTime(2023, 10, 10, 10, 0),
    );

    verify(
      mockNotificationService.showInstantNotification(
        id: 9902,
        title: anyNamed('title'),
        body: anyNamed('body'),
        channelId: 'journal',
        payload: 'journal',
      ),
    ).called(1);
  });

  test('Do not notify if entry exists today', () async {
    final fixedNow = DateTime(2023, 10, 10, 10, 0);
    final entry = JournalEntry(
      id: '1',
      title: 'Today Journal',
      content: 'Good day',
      date: fixedNow,
    );
    await journalBox.put(entry.id, entry);

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

  test('Notify if entry exists ONLY yesterday', () async {
    final fixedNow = DateTime(2023, 10, 10, 10, 0);
    final entry = JournalEntry(
      id: '1',
      title: 'Yesterday',
      content: 'Old',
      date: fixedNow.subtract(const Duration(days: 1)),
    );
    await journalBox.put(entry.id, entry);

    await notificationHandler.checkAndNotify(now: fixedNow);

    verify(
      mockNotificationService.showInstantNotification(
        id: 9902,
        title: anyNamed('title'),
        body: anyNamed('body'),
        channelId: 'journal',
        payload: 'journal',
      ),
    ).called(1);
  });
}
