import 'package:test_pam/models/doctor.dart';

class Appointment {
  final String date;
  final String time;
  final Doctor doctor;

  Appointment({required this.date, required this.time, required this.doctor});
}
