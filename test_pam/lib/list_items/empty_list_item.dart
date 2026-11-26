import 'package:test_pam/list_items/list_item.dart';

// Rândul afișat în locul medicilor când lista e goală (starea Empty).
class EmptyListItem extends ListItem {
  final bool hasActiveFilters;

  EmptyListItem({required this.hasActiveFilters});
}
