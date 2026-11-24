import 'package:data/mappers/appointment_extension.dart';
import 'package:data/mappers/doctor_extension.dart';
import 'package:data/mappers/health_service_extension.dart';
import 'package:data/models/home_feed_model.dart';
import 'package:domain/entities/home_data.dart';

// Mapper (stratul Data): Model (formatul serverului) -> Entitate (formatul aplicației).
extension HomeExtension on HomeFeedModel {
  HomeData get toEntity => HomeData(
    greeting: user.greeting,
    subtitle: user.subtitle,
    avatarUrl: user.avatarUrl,
    hasUnreadNotifications: hasUnread,
    searchHint: searchHint,
    appointment: appointment.toEntity,
    services: [for (final s in healthServices) s.toEntity],
    doctors: [for (final d in nearbyDoctors) d.toEntity],
  );
}
