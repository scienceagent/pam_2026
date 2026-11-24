import 'package:flutter/material.dart';
import 'package:test_pam/list_items/chips_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Desenează un grup de chip-uri selectabile; chip-ul ales e colorat.
class ChipsSectionWidget extends StatelessWidget {
  const ChipsSectionWidget({
    super.key,
    required this.item,
    required this.topSpacing,
    required this.chipWidths,
    required this.chipLeftPaddings,
    required this.onSelect,
    required this.onTapAction,
  });

  final ChipsListItem item;
  final double topSpacing;
  final List<double> chipWidths;
  final List<double> chipLeftPaddings;
  final Function(int index) onSelect;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topSpacing),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 26.7, right: 23.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.title, style: AppTextStyles.sectionSemiBold22),
                if (item.rightActionTitle != null)
                  InkWell(
                    onTap: onTapAction,
                    child: Text(item.rightActionTitle!, style: AppTextStyles.actionRegular16),
                  ),
              ],
            ),
          ),
          SizedBox(height: 26),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 26.7),
              itemCount: item.chips.length,
              separatorBuilder: (context, index) => SizedBox(width: 15),
              itemBuilder: (context, index) {
                final isSelected = index == item.selectedIndex;
                return InkWell(
                  onTap: () => onSelect(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: chipWidths.elementAtOrNull(index),
                    padding: EdgeInsets.symmetric(horizontal: chipLeftPaddings.elementAtOrNull(index) ?? 24)
                        .copyWith(right: index < chipWidths.length ? 0 : null),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryTeal : AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.chips[index],
                      style: AppTextStyles.chipRegular20.copyWith(
                        color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
