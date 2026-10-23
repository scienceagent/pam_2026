import 'package:test_pam/list_items/list_item.dart';
import 'package:test_pam/models/doctor.dart';

class DoctorProfileListItem extends ListItem {
  final Doctor doctor;
  final String payment;

  DoctorProfileListItem({required this.doctor, required this.payment});
}
