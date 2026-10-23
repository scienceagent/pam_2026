import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_pam/test_pam_widget.dart';

void main() {
  testWidgets('Homescreen renders all sections', (WidgetTester tester) async {
    await tester.pumpWidget(const TestPamWidget());
    await tester.pumpAndSettle();

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Dr. Richar Kandowen'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);
    expect(find.text('See All'), findsNWidgets(2));
  });

  testWidgets('Appointment card opens details and chips are selectable', (WidgetTester tester) async {
    await tester.pumpWidget(const TestPamWidget());
    await tester.tap(find.text('Appointment'));
    await tester.pumpAndSettle();

    expect(find.text('Dr.Upul'), findsOneWidget);
    expect(find.text('Book an Appointment'), findsOneWidget);

    await tester.ensureVisible(find.text('10.00 AM'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10.00 AM'));
    await tester.pump();
    final chip = tester.widget<Text>(find.text('10.00 AM'));
    expect(chip.style!.color, const Color(0xffFFFFFF));
  });
}
