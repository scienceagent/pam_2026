import 'package:flutter/material.dart';
import 'package:test_pam/list_items/details_list_item.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Desenează secțiunea "Details" (titlu și descriere) din pagina de detalii.
class DetailsWidget extends StatelessWidget {
  const DetailsWidget({super.key, required this.item});

  final DetailsListItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, right: 21, top: 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: AppTextStyles.sectionSemiBold22),
          SizedBox(height: 17),
          Text(item.description, style: AppTextStyles.descriptionRegular13),
        ],
      ),
    );
  }
}
