import 'package:test_pam/list_items/list_item.dart';
import 'package:domain/entities/home_data.dart';

// Rândul cu cardul programării curente.
class AppointmentListItem extends ListItem {
  final Appointment appointment;

  AppointmentListItem({required this.appointment});
}
