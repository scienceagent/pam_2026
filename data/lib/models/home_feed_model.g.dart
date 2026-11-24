// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      title: json['title'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      doctor: DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'date': instance.date,
      'time': instance.time,
      'doctor': instance.doctor.toJson(),
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  name: json['name'] as String,
  greeting: json['greeting'] as String,
  subtitle: json['subtitle'] as String,
  avatarUrl: json['avatarUrl'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'name': instance.name,
  'greeting': instance.greeting,
  'subtitle': instance.subtitle,
  'avatarUrl': instance.avatarUrl,
};
