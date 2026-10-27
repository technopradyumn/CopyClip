import 'package:copyclip/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'edge swipe opens drawer and drawer navigation switches screens',
    (tester) async {
      app.isIntegrationTesting = true;
      await app.main();

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Notes'), findsWidgets);

      await tester.dragFrom(const Offset(1, 200), const Offset(280, 0));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(Drawer), findsOneWidget);

      await tester.tap(find.text('To-Dos').last);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('To-Dos'), findsOneWidget);

      await tester.dragFrom(const Offset(1, 200), const Offset(280, 0));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(Drawer), findsOneWidget);

      await tester.tap(find.text('Notes').last);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Notes'), findsOneWidget);
    },
  );
}
