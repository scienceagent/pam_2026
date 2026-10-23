import 'package:test_pam/list_items/list_item.dart';
import 'package:test_pam/models/health_service.dart';

class HealthServicesListItem extends ListItem {
  final List<HealthService> services;

  HealthServicesListItem({required this.services});
}
