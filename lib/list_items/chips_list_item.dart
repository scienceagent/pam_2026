import 'package:test_pam/list_items/list_item.dart';

class ChipsListItem extends ListItem {
  final String title;
  final String? rightActionTitle;
  final List<String> chips;
  int selectedIndex;

  ChipsListItem({required this.title, required this.rightActionTitle, required this.chips, this.selectedIndex = 0});
}
