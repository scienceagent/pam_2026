import 'package:data/models/doctor_model.dart';
import 'package:data/models/health_service_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_feed_model.g.dart';

// Modele (stratul Data) pentru răspunsul GET /lab2026/v2/feed.
@JsonSerializable(explicitToJson: true) // serializare automată; explicitToJson -> și medicul din interior folosește toJson
class AppointmentModel {
  final String title;
  final String date;
  final String time;
  final DoctorModel doctor;

  const AppointmentModel({required this.title, required this.date, required this.time, required this.doctor});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}

@JsonSerializable()
class UserModel {
  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  const UserModel({required this.name, required this.greeting, required this.subtitle, required this.avatarUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

// Serializare manuală: JSON-ul are obiecte imbricate (notifications, search) pe care le aplatizăm.
class HomeFeedModel {
  final UserModel user;
  final bool hasUnread;
  final String searchHint;
  final AppointmentModel appointment;
  final List<HealthServiceModel> healthServices;
  final List<DoctorModel> nearbyDoctors;

  const HomeFeedModel({
    required this.user,
    required this.hasUnread,
    required this.searchHint,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) => HomeFeedModel(
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    hasUnread: (json['notifications'] as Map<String, dynamic>)['hasUnread'] as bool,
    searchHint: (json['search'] as Map<String, dynamic>)['hint'] as String,
    appointment: AppointmentModel.fromJson(json['appointment'] as Map<String, dynamic>),
    healthServices: [for (final s in json['healthServices'] as List) HealthServiceModel.fromJson(s as Map<String, dynamic>)],
    nearbyDoctors: [for (final d in json['nearbyDoctors'] as List) DoctorModel.fromJson(d as Map<String, dynamic>)],
  );

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'notifications': {'hasUnread': hasUnread},
    'search': {'hint': searchHint},
    'appointment': appointment.toJson(),
    'healthServices': [for (final s in healthServices) s.toJson()],
    'nearbyDoctors': [for (final d in nearbyDoctors) d.toJson()],
  };
}
