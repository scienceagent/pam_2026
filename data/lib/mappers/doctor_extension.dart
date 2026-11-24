import 'package:data/models/doctor_model.dart';
import 'package:domain/entities/doctor.dart';

// Mapper (stratul Data): Model (formatul serverului) -> Entitate (formatul aplicației).
extension DoctorExtension on DoctorModel {
  Doctor get toEntity =>
      Doctor(id: id, imageUrl: imageUrl, name: name, specialty: specialty, address: address, isFavorite: isFavorite);
}
