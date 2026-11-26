import 'package:test_pam/list_items/list_item.dart';
import 'package:domain/entities/appointment_details.dart';

// Rândul cu profilul medicului din pagina de detalii.
class DoctorProfileListItem extends ListItem {
  final AppointmentDetails details;

  DoctorProfileListItem({required this.details});
}
