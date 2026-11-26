import 'package:dio/dio.dart';
import 'package:domain/entities/doctor.dart';
import 'package:domain/use_cases/filter_doctors_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_pam/pages/appointment_details/appointment_details_controller.dart';
import 'package:test_pam/pages/home/home_controller.dart';
import 'package:test_pam/list_items/doctor_list_item.dart';
import 'package:test_pam/list_items/empty_list_item.dart';

import 'helpers/fake_server.dart';

// Controllerele testate cu tot lanțul Clean Architecture; doar serverul e înlocuit (helpers/fake_server.dart).
List<String> _names(HomeController c) => [for (final d in c.items.whereType<DoctorListItem>()) d.doctor.name];
bool _isEmpty(HomeController c) => c.items.whereType<EmptyListItem>().isNotEmpty;

void main() {
  group('HomeController', () {
    late HomeController controller;

    setUp(() async {
      await startFakeServer();
      controller = HomeController();
      await controller.load();
    });

    test('loads GET /feed into items', () {
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isNull);
      expect(_names(controller), ['Dr. Emmly Lestiryno', 'Dr. Sonja Litel']);
    });

    test('search matches name, specialty and address; no match gives Empty', () {
      controller.search('dental');
      expect(_names(controller), ['Dr. Sonja Litel']);
      controller.search('durgan');
      expect(_names(controller), ['Dr. Emmly Lestiryno']);
      controller.search('zzz');
      expect(_isEmpty(controller), isTrue);
    });

    test('favorites toggle and favorites-only filter', () {
      controller.toggleFavorite('doctor-002');
      controller.applyFilters(specialty: null, favoritesOnly: true, sort: DoctorSort.recommended);
      expect(_names(controller), ['Dr. Sonja Litel']);
      controller.toggleFavorite('doctor-002');
      expect(_isEmpty(controller), isTrue);
    });

    test('specialty filter, sorting and reset', () {
      controller.applyFilters(specialty: 'General Practitioner', favoritesOnly: false, sort: DoctorSort.recommended);
      expect(_names(controller), ['Dr. Emmly Lestiryno']);
      controller.applyFilters(specialty: null, favoritesOnly: false, sort: DoctorSort.nameDesc);
      expect(_names(controller), ['Dr. Sonja Litel', 'Dr. Emmly Lestiryno']);
      controller.applyFilters(specialty: null, favoritesOnly: false, sort: DoctorSort.distance);
      expect(_names(controller), ['Dr. Emmly Lestiryno', 'Dr. Sonja Litel']); // 500M < 753M
      controller.search('zzz');
      controller.resetFilters();
      expect(_names(controller), hasLength(2));
      expect(controller.hasActiveFilters, isFalse);
    });

    test('server without doctors gives Empty with no active filters', () async {
      await startFakeServer(feed: feedJson.replaceAll(RegExp(r'"nearbyDoctors":\[[\s\S]*\]'), '"nearbyDoctors":[]'));
      final empty = HomeController();
      await empty.load();
      expect(_isEmpty(empty), isTrue);
      expect(empty.hasActiveFilters, isFalse);
    });
  });

  group('Error states', () {
    Future<HomeController> loadWith({DioExceptionType? fail, int status = 200, String? feed}) async {
      await startFakeServer(fail: fail, status: status, feed: feed);
      final controller = HomeController();
      await controller.load();
      return controller;
    }

    test('no internet', () async {
      final c = await loadWith(fail: DioExceptionType.connectionError);
      expect(c.errorMessage.value, 'No internet connection.');
      expect(c.isLoading.value, isFalse);
    });

    test('timeout', () async {
      final c = await loadWith(fail: DioExceptionType.receiveTimeout);
      expect(c.errorMessage.value, contains('taking too long'));
    });

    test('HTTP 500', () async {
      final c = await loadWith(status: 500);
      expect(c.errorMessage.value, 'Server error (500).');
    });

    test('JSON in the wrong shape', () async {
      final c = await loadWith(feed: '{"user": 1}');
      expect(c.errorMessage.value, 'The server sent unexpected data.');
    });

    test('retry after an error loads the data', () async {
      final c = await loadWith(fail: DioExceptionType.connectionError);
      await startFakeServer(); // internetul „revine”
      await c.load();
      expect(c.errorMessage.value, isNull);
      expect(_names(c), hasLength(2));
    });
  });

  group('AppointmentDetailsController', () {
    test('loads GET /feed/details, keeps the tapped doctor and changes selection', () async {
      await startFakeServer();
      final doctor = Doctor(id: 'x', imageUrl: 'u', name: 'Dr. Test', specialty: 'Eye');
      final controller = AppointmentDetailsController(doctor: doctor);
      await controller.load();
      final details = controller.details.value!;
      expect(details.doctor.name, 'Dr. Test');
      expect(details.workingHours.selectedIndex, 1); // "11.00 AM" e selectat pe server
      expect(details.payment, r'$120.00');

      controller.selectHour(0);
      controller.selectDate(2);
      final updated = controller.details.value!;
      expect(updated.workingHours.selectedIndex, 0);
      expect(updated.dates.labels[updated.dates.selectedIndex], 'Tue 6');
    });

    test('without a tapped doctor shows the doctor from the server', () async {
      await startFakeServer();
      final controller = AppointmentDetailsController();
      await controller.load();
      expect(controller.details.value!.doctor.name, 'Dr.Upul');
      expect(controller.details.value!.doctor.specialty, 'Denteeth'); // din cheia "clinic"
    });
  });
}
