// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  id: json['id'] as String? ?? '',
  imageUrl: json['avatarUrl'] as String,
  name: json['name'] as String,
  specialty: DoctorModel._readSpecialty(json, 'specialty') as String,
  address: json['distance'] as String? ?? '',
  isFavorite: json['isFavorite'] as bool? ?? false,
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'avatarUrl': instance.imageUrl,
      'name': instance.name,
      'specialty': instance.specialty,
      'distance': instance.address,
      'isFavorite': instance.isFavorite,
    };
