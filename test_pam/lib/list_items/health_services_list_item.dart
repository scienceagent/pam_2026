import 'package:test_pam/list_items/list_item.dart';
import 'package:domain/entities/health_service.dart';

// Rândul cu serviciile medicale (Tooth, Eye...).
class HealthServicesListItem extends ListItem {
  final List<HealthService> services;

  HealthServicesListItem({required this.services});
}
