import 'package:flutter/material.dart';
import 'package:test_pam/list_items/section_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Desenează titlul unei secțiuni cu acțiunea din dreapta.
class SectionListWidget extends StatelessWidget {
  const SectionListWidget({super.key, required this.item, required this.onTapAction});

  final SectionListItem item;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.title, style: AppTextStyles.semiBold18),
          if (item.rightActionTitle != null)
            InkWell(
              onTap: onTapAction,
              child: Text(
                item.rightActionTitle!,
                style: AppTextStyles.regular12.copyWith(color: AppColors.coralGreen01),
              ),
            ),
        ],
      ),
    );
  }
}
