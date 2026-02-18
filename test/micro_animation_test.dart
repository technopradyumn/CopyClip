import 'package:copyclip/src/core/common_widgets/micro_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MicroAnimation runs when animate is true', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MicroAnimation(animate: true, child: Text('Animate Me')),
      ),
    );

    // Allow animation to complete
    await tester.pumpAndSettle();

    // Initial state: widget should be in tree
    expect(find.text('Animate Me'), findsOneWidget);
    // You might checking for specific transform/opacity properties here if needed,
    // but simply ensuring no crash and presence is a good start.
  });

  testWidgets('MicroAnimation skips animation when animate is false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MicroAnimation(animate: false, child: Text('No Animation')),
      ),
    );

    expect(find.text('No Animation'), findsOneWidget);
    // Since animate is false, it returns child directly.
    // We can verify this implicitly by ensuring the widget renders immediately without needing pumpAndSettle for animation frames.
  });
}
