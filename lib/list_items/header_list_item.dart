import 'package:test_pam/list_items/list_item.dart';

class HeaderListItem extends ListItem {
  final String firstName;
  final bool hasNotifications;

  HeaderListItem({required this.firstName, required this.hasNotifications});
}
