import 'package:flutter/material.dart';
import 'package:test_pam/list_items/header_list_item.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_text_styles.dart';
import 'package:test_pam/widgets/app_network_image.dart';

// Desenează antetul: avatar, salut, subtitlu și clopoțelul de notificări.
class HeaderListWidget extends StatelessWidget {
  const HeaderListWidget({super.key, required this.item, required this.onTapNotifications});

  final HeaderListItem item;
  final VoidCallback onTapNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            AppNetworkImage(url: item.avatarUrl, size: 44, circle: true),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.greeting, style: AppTextStyles.semiBold14),
                Text(item.subtitle, style: AppTextStyles.regular10),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: onTapNotifications,
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              children: [
                Positioned(left: 11, top: 11, child: AppIcons.notificationIcon),
                if (item.hasNotifications) Positioned(left: 23, top: 13, child: AppIcons.notificationDot),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
