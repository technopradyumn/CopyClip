import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:copyclip/src/l10n/app_localizations.dart';

void main() {
  testWidgets('Localization loads English by default and switches to Spanish', (
    WidgetTester tester,
  ) async {
    // 1. Pump with English
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context)!.settings);
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    // 2. Pump with Spanish
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'),
        home: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context)!.settings);
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Ajustes'), findsOneWidget);
  });
}
