import 'package:test_pam/list_items/list_item.dart';

// Rândul cu titlul unei secțiuni și acțiunea "See All".
class SectionListItem extends ListItem {
  final String title;
  final String? rightActionTitle;

  SectionListItem({required this.title, required this.rightActionTitle});
}
