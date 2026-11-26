import 'package:test_pam/list_items/list_item.dart';
import 'package:domain/entities/doctor.dart';

// Rândul cu un medic din lista "Nearby Doctor".
class DoctorListItem extends ListItem {
  final Doctor doctor;

  DoctorListItem({required this.doctor});
}
