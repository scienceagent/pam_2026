import 'package:data/mappers/doctor_extension.dart';
import 'package:data/models/home_feed_model.dart';
import 'package:domain/entities/home_data.dart';

// Mapper (stratul Data): Model (formatul serverului) -> Entitate (formatul aplicației).
extension AppointmentExtension on AppointmentModel {
  Appointment get toEntity => Appointment(title: title, date: date, time: time, doctor: doctor.toEntity);
}
