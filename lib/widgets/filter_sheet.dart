import 'package:domain/use_cases/filter_doctors_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/resources/app_text_styles.dart';
import 'package:test_pam/pages/home/home_controller.dart';

// Fereastra de jos cu filtre (sortare, specialitate, doar favorite) pentru HomeController.
Future<void> showFilterSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.whiteColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _FilterSheet(controller: Get.find<HomeController>()),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.controller});

  final HomeController controller;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  // Selecție locală (setState) până la Apply; abia atunci ajunge în HomeController.
  late DoctorSort _sort = widget.controller.sort;
  late String? _specialty = widget.controller.specialty;
  late bool _favoritesOnly = widget.controller.favoritesOnly;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.sortBy, style: AppTextStyles.semiBold16),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final sort in DoctorSort.values)
                  _Chip(label: sort.label, selected: _sort == sort, onTap: () => setState(() => _sort = sort)),
              ],
            ),
            SizedBox(height: 20),
            Text(AppStrings.specialty, style: AppTextStyles.semiBold16),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Chip(label: AppStrings.all, selected: _specialty == null, onTap: () => setState(() => _specialty = null)),
                for (final s in widget.controller.specialties)
                  _Chip(label: s, selected: _specialty == s, onTap: () => setState(() => _specialty = s)),
              ],
            ),
            SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.coralGreen01,
              title: Text(AppStrings.favoritesOnly, style: AppTextStyles.semiBold16),
              value: _favoritesOnly,
              onChanged: (value) => setState(() => _favoritesOnly = value),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: AppColors.coralGreen01,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    widget.controller.applyFilters(specialty: _specialty, favoritesOnly: _favoritesOnly, sort: _sort);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      AppStrings.apply,
                      style: AppTextStyles.semiBold16.copyWith(color: AppColors.whiteColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.coralGreen01 : AppColors.lightGrey02,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: AppTextStyles.medium14.copyWith(color: selected ? AppColors.whiteColor : AppColors.black01),
        ),
      ),
    );
  }
}
