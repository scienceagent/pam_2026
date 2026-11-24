import 'package:data/models/health_service_model.dart';
import 'package:domain/entities/health_service.dart';

// Mapper (stratul Data): Model (formatul serverului) -> Entitate (formatul aplicației).
extension HealthServiceExtension on HealthServiceModel {
  HealthService get toEntity => HealthService(id: id, imageUrl: iconUrl, title: name);
}
