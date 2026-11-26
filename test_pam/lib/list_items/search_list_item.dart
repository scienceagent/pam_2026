import 'package:test_pam/list_items/list_item.dart';

// Rândul cu câmpul de căutare și butonul de filtre.
class SearchListItem extends ListItem {
  final String hint;
  final bool hasActiveFilters;

  SearchListItem({required this.hint, required this.hasActiveFilters});
}
