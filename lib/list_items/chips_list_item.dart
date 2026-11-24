import 'package:test_pam/list_items/list_item.dart';

// Rândul cu un grup de chip-uri selectabile (ore sau date).
class ChipsListItem extends ListItem {
  final String title;
  final String? rightActionTitle;
  final List<String> chips;
  final int selectedIndex;

  ChipsListItem({required this.title, required this.rightActionTitle, required this.chips, required this.selectedIndex});
}
