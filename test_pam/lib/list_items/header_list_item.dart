import 'package:test_pam/list_items/list_item.dart';

// Rândul de sus: avatar, salut și notificări.
class HeaderListItem extends ListItem {
  final String greeting;
  final String subtitle;
  final String avatarUrl;
  final bool hasNotifications;

  HeaderListItem({required this.greeting, required this.subtitle, required this.avatarUrl, required this.hasNotifications});
}
