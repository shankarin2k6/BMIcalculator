// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
// ...

void main() {
  testWidgets('BMI Calculator smoke test', (WidgetTester tester) async {
    // Build our BMI Calculator app and trigger a frame.
    // NOTE: We replaced MyApp() with BMICalculator()
    await tester.pumpWidget(const BMICalculator());

    // Verify that the AppBar title is visible.
    expect(find.text('Advanced BMI Calculator'), findsOneWidget);

    // Verify that the Calculate Button is present.
    expect(find.text('Calculate BMI'), findsOneWidget);

    // Note: The original 'Counter increments smoke test' logic
    // is irrelevant to the BMI app, but the core fix is replacing MyApp().
  });
}
