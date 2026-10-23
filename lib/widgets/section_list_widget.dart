import 'package:flutter/material.dart';
import 'package:test_pam/list_items/section_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Titlu de secțiune ("Health Services", "Nearby Doctor") + acțiunea "See All" în dreapta.
class SectionListWidget extends StatelessWidget {
  const SectionListWidget({super.key, required this.item, required this.onTapAction});

  final SectionListItem item;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Padding( // Padding: 24 sus, 16 jos
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Row( // Row: copii pe orizontală
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // titlul stânga, "See All" dreapta
        children: [
          Text(item.title, style: AppTextStyles.semiBold18),
          if (item.rightActionTitle != null) // collection-if: afișat doar dacă există acțiune
            InkWell( // InkWell: textul "See All" devine clicabil
              onTap: onTapAction,
              child: Text(
                item.rightActionTitle!, // "!" = suntem siguri că nu e null (verificat mai sus)
                style: AppTextStyles.regular12.copyWith(color: AppColors.coralGreen01),
              ),
            ),
        ],
      ),
    );
  }
}
