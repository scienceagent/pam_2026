import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

// Model (stratul Data): medicul în formatul JSON al serverului.
// Serializare AUTOMATĂ (json_serializable): fromJson/toJson sunt generate în doctor_model.g.dart.
@JsonSerializable()
class DoctorModel {
  @JsonKey(defaultValue: '') // @JsonKey: alt nume de cheie în JSON (name), valoare dacă lipsește (defaultValue)
  final String id;
  @JsonKey(name: 'avatarUrl')
  final String imageUrl;
  final String name;
  @JsonKey(readValue: _readSpecialty)
  final String specialty;
  @JsonKey(name: 'distance', defaultValue: '')
  final String address;
  @JsonKey(defaultValue: false)
  final bool isFavorite;

  const DoctorModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.specialty,
    required this.address,
    required this.isFavorite,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);

  // În /feed medicul are "specialty", în /feed/details are "clinic".
  static Object? _readSpecialty(Map json, String key) => json['specialty'] ?? json['clinic'];
}
