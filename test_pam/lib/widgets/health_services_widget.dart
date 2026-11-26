import 'package:flutter/material.dart';
import 'package:test_pam/list_items/health_services_list_item.dart';
import 'package:domain/entities/health_service.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_text_styles.dart';
import 'package:test_pam/widgets/app_network_image.dart';

// Desenează rândul de servicii medicale cu iconițe.
class HealthServicesWidget extends StatelessWidget {
  const HealthServicesWidget({super.key, required this.item, required this.onTapService});

  final HealthServicesListItem item;
  final Function(HealthService service) onTapService;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final service in item.services)
          InkWell(
            onTap: () => onTapService(service),
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.lightGrey02, borderRadius: BorderRadius.circular(10)),
                  child: AppNetworkImage(url: service.imageUrl, size: 32),
                ),
                SizedBox(height: 8),
                Text(service.title, style: AppTextStyles.medium14),
              ],
            ),
          ),
      ],
    );
  }
}
