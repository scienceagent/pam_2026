import 'package:flutter/material.dart';
import 'package:test_pam/list_items/doctor_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_text_styles.dart';
import 'package:test_pam/widgets/app_network_image.dart';

// Desenează un rând de medic: poză, nume, specialitate, adresă și inima de favorit.
class DoctorListWidget extends StatelessWidget {
  const DoctorListWidget({super.key, required this.item, required this.onTap, required this.onFavorite});

  final DoctorListItem item;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final doctor = item.doctor;

    return InkWell(
      onTap: onTap,
      child: Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(url: doctor.imageUrl, size: 46, circle: true),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.name, style: AppTextStyles.semiBold14),
                Text(doctor.specialty, style: AppTextStyles.regular12),
                SizedBox(height: 6),
                Row(
                  children: [
                    AppIcons.locationIcon,
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        doctor.address,
                        style: AppTextStyles.regular12.copyWith(color: AppColors.black01),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onFavorite,
            child: doctor.isFavorite
                ? Icon(Icons.favorite, size: 20, color: AppColors.coralGreen01, semanticLabel: 'Remove from favorites')
                : Semantics(label: 'Add to favorites', child: AppIcons.heartIcon),
          ),
        ],
      ),
      ),
    );
  }
}
