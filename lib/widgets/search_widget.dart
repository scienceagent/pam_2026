import 'package:flutter/material.dart';
import 'package:test_pam/list_items/search_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Desenează câmpul de căutare și butonul de filtre (cu punct când sunt filtre active).
class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.item,
    required this.controller,
    required this.onSearch,
    required this.onTapFilter,
  });

  final SearchListItem item;
  final TextEditingController controller;
  final Function(String text) onSearch;
  final VoidCallback onTapFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        height: 52,
        padding: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: AppColors.lightGrey03,
          border: Border.all(color: AppColors.lightGrey02),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            AppIcons.searchIcon,
            SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: controller,
                style: AppTextStyles.regular14.copyWith(color: AppColors.black01),
                cursorColor: AppColors.coralGreen01,
                decoration: InputDecoration(
                  hintText: item.hint,
                  hintStyle: AppTextStyles.regular14,
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                onChanged: onSearch,
              ),
            ),
            InkWell(
              onTap: onTapFilter,
              child: Badge(isLabelVisible: item.hasActiveFilters, backgroundColor: AppColors.coralGreen01, child: AppIcons.settingIcon),
            ),
          ],
        ),
      ),
    );
  }
}
