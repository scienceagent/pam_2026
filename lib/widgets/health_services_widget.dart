import 'package:flutter/material.dart';
import 'package:test_pam/list_items/health_services_list_item.dart';
import 'package:test_pam/models/health_service.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Rândul cu cele 4 servicii (Tooth, Eye, Lungs, Ear).
class HealthServicesWidget extends StatelessWidget {
  const HealthServicesWidget({super.key, required this.item, required this.onTapService});

  final HealthServicesListItem item;
  final Function(HealthService service) onTapService; // callback care primește serviciul apăsat

  @override
  Widget build(BuildContext context) {
    return Row( // Row: serviciile pe orizontală
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // spațiu egal între ele
      children: [
        for (final service in item.services) // collection-for: câte un widget pentru fiecare serviciu
          InkWell( // InkWell: fiecare serviciu e clicabil
            onTap: () => onTapService(service),
            borderRadius: BorderRadius.circular(10),
            child: Column( // Column: pătratul cu imagine deasupra, textul dedesubt
              children: [
                Container( // Container: pătrat 64x64 cu fundal gri și colțuri rotunde
                  width: 64,
                  height: 64,
                  alignment: Alignment.center, // centrează imaginea în pătrat
                  decoration: BoxDecoration(color: AppColors.lightGrey02, borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(service.imagePath, width: 32, height: 32, fit: BoxFit.cover),
                ),
                SizedBox(height: 8), // SizedBox: spațiu de 8px între pătrat și text
                Text(service.title, style: AppTextStyles.medium14),
              ],
            ),
          ),
      ],
    );
  }
}
