// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:jawline_challenge_ui/main.dart';

void main() {
  testWidgets('Home screen renders challenge title',
      (WidgetTester tester) async {
    await tester.pumpWidget(const JawlineApp());

    expect(find.text('60 Days Jawline Challenge'), findsOneWidget);
    expect(find.text('Day 1'), findsOneWidget);
  });
}
