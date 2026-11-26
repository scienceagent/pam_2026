import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:test_pam/pages/appointment_details/appointment_details_controller.dart';
import 'package:test_pam/test_pam_widget.dart';

import 'helpers/fake_server.dart';

void main() {
  // În teste nu există internet: imaginile primesc un răspuns gol, pe care flutter_svg îl raportează ca eroare.
  // De aceea iconițele SVG primesc un URL non-SVG și afișează în liniște fundalul gri.
  setUp(() => startFakeServer(feed: feedJson.replaceAll('.svg?', '.png?')));

  // Get.put păstrează un controller deja înregistrat, deci după fiecare test golim GetX cu Get.reset.
  tearDown(Get.reset);

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const TestPamWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget); // isLoading == true -> spinner
    await tester.pumpAndSettle();
  }

  testWidgets('No internet shows the Error state and Retry loads the data', (tester) async {
    await startFakeServer(fail: DioExceptionType.connectionError);
    await pumpApp(tester);
    expect(find.text('No internet connection.'), findsOneWidget);

    await startFakeServer(feed: feedJson.replaceAll('.svg?', '.png?')); // internetul „revine”
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Jonathan'), findsOneWidget);
  });

  testWidgets('Homescreen shows the data loaded from the server', (tester) async {
    await pumpApp(tester);

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Dr. Richar Kandowen'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);
    expect(find.text('See All'), findsNWidgets(2));
  });

  testWidgets('Search with no result shows the Empty state and reset brings doctors back', (tester) async {
    // Ecran înalt, ca toată lista să fie vizibilă fără derulare.
    tester.view.physicalSize = const Size(430, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();
    expect(find.text('No doctors match your search'), findsOneWidget);
    expect(find.text('Dr. Sonja Litel'), findsNothing);

    await tester.tap(find.text('Reset filters'));
    await tester.pump();
    expect(find.text('Dr. Sonja Litel'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
  });

  testWidgets('Appointment card opens details and chips are selectable', (tester) async {
    await pumpApp(tester);
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

    // Get.back închide pagina și îi șterge controller-ul; un medic din listă deschide pagina cu un controller nou.
    Get.back();
    await tester.pumpAndSettle();
    expect(Get.isRegistered<AppointmentDetailsController>(), isFalse);
    await tester.tap(find.text('Dr. Emmly Lestiryno'));
    await tester.pumpAndSettle();
    expect(find.text('Dr. Emmly Lestiryno'), findsOneWidget);
    expect(find.text('Dr.Upul'), findsNothing);
  });
}
