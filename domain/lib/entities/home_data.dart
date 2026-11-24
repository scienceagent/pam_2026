import 'package:domain/entities/doctor.dart';
import 'package:domain/entities/health_service.dart';

// Entități: programarea curentă și toate datele ecranului principal (răspunsul GET /feed).
class Appointment {
  final String title;
  final String date;
  final String time;
  final Doctor doctor;

  const Appointment({required this.title, required this.date, required this.time, required this.doctor});
}

class HomeData {
  final String greeting;
  final String subtitle;
  final String avatarUrl;
  final bool hasUnreadNotifications;
  final String searchHint;
  final Appointment appointment;
  final List<HealthService> services;
  final List<Doctor> doctors;

  const HomeData({
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.services,
    required this.doctors,
  });

  HomeData copyWith({List<Doctor>? doctors}) => HomeData(
    greeting: greeting,
    subtitle: subtitle,
    avatarUrl: avatarUrl,
    hasUnreadNotifications: hasUnreadNotifications,
    searchHint: searchHint,
    appointment: appointment,
    services: services,
    doctors: doctors ?? this.doctors,
  );
}
