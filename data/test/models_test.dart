import 'dart:convert';
import 'dart:io';

import 'package:data/mappers/appointment_details_extension.dart';
import 'package:data/mappers/home_extension.dart';
import 'package:data/models/appointment_details_model.dart';
import 'package:data/models/doctor_model.dart';
import 'package:data/models/health_service_model.dart';
import 'package:data/models/home_feed_model.dart';
import 'package:test/test.dart';

// Răspunsurile reale ale serverului (aceleași ca în test/fixtures al aplicației).
Map<String, dynamic> _read(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync()) as Map<String, dynamic>;

void main() {
  final feed = _read('feed.json');
  final details = _read('feed_details.json');

  test('GET /feed: JSON -> HomeFeedModel -> entity', () {
    final home = HomeFeedModel.fromJson(feed).toEntity;
    expect(home.greeting, 'Hi, Jonathan');
    expect(home.services.map((s) => s.title), ['Tooth', 'Eye', 'Lungs', 'Ear']);
    expect(home.doctors.first.address, '3167 Durgan Shores - 500M from you');
    expect(home.appointment.doctor.name, 'Dr. Richar Kandowen');
  });

  test('GET /feed/details: JSON -> AppointmentDetailsModel -> entity', () {
    final entity = AppointmentDetailsModel.fromJson(details).toEntity;
    expect(entity.doctor.specialty, 'Denteeth'); // "clinic" citit prin @JsonKey(readValue)
    expect(entity.payment, r'$120.00');
    expect(entity.workingHours.labels[entity.workingHours.selectedIndex], '11.00 AM');
    expect(entity.dates.labels[entity.dates.selectedIndex], 'Sun 4');
  });

  // Serializare dus-întors: obiect -> toJson/jsonEncode -> text -> jsonDecode/fromJson -> același obiect.
  test('automatic (json_serializable): DoctorModel round-trip', () {
    final json = (feed['nearbyDoctors'] as List).first as Map<String, dynamic>;
    final doctor = DoctorModel.fromJson(json);
    final again = DoctorModel.fromJson(jsonDecode(jsonEncode(doctor)) as Map<String, dynamic>);
    expect(again.name, doctor.name);
    expect(doctor.toJson()['avatarUrl'], json['avatarUrl']);
  });

  test('manual: HealthServiceModel and whole feed round-trip', () {
    final service = HealthServiceModel.fromJson((feed['healthServices'] as List).first as Map<String, dynamic>);
    expect(HealthServiceModel.fromJson(service.toJson()).name, 'Tooth');

    final model = HomeFeedModel.fromJson(feed);
    final again = HomeFeedModel.fromJson(jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>);
    expect(again.nearbyDoctors.length, 2);
    expect(again.toJson(), model.toJson());

    final detailsModel = AppointmentDetailsModel.fromJson(details);
    expect(AppointmentDetailsModel.fromJson(detailsModel.toJson()).toEntity.bookLabel, 'Book an Appointment');
  });
}
