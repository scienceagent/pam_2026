import 'package:flutter/material.dart';
import 'package:test_pam/list_items/header_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_images.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Header-ul: avatar + "Hi, Jonathan" în stânga, clopoțel de notificări în dreapta.
class HeaderListWidget extends StatelessWidget {
  const HeaderListWidget({super.key, required this.item, required this.onTapNotifications});

  final HeaderListItem item;
  final VoidCallback onTapNotifications;

  @override
  Widget build(BuildContext context) {
    return Row( // Row: copii pe orizontală
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // spațiul liber pus între copii -> unul stânga, altul dreapta
      children: [
        Row(
          children: [
            ClipOval( // ClipOval: decupează avatarul în cerc
              child: Container( // Container: cutie cu dimensiune + culoare de fundal (aici alb 44x44)
                width: 44,
                height: 44,
                color: AppColors.whiteColor,
                child: Stack( // Stack: pune copiii unul PESTE altul (straturi)
                  fit: StackFit.expand, // copiii ocupă toată suprafața Stack-ului
                  children: [
                    Image.asset(AppImages.avatarBackground, fit: BoxFit.cover), // stratul de jos: fundalul
                    Image.asset(AppImages.avatar, fit: BoxFit.cover), // stratul de sus: persoana
                  ],
                ),
              ),
            ),
            SizedBox(width: 8), // SizedBox: spațiu fix de 8px între avatar și text
            Column( // Column: copii pe verticală
              crossAxisAlignment: CrossAxisAlignment.start, // aliniere la stânga
              children: [
                Text('${AppStrings.hi}, ${item.firstName}', style: AppTextStyles.semiBold14), // interpolare de string în Dart
                Text(AppStrings.healthyWish, style: AppTextStyles.regular10),
              ],
            ),
          ],
        ),
        InkWell( // InkWell: zonă clicabilă cu efect ripple
          onTap: onTapNotifications,
          borderRadius: BorderRadius.circular(30), // ripple-ul are colțuri rotunde
          child: SizedBox( // SizedBox cu copil: îi impune copilului dimensiunea 44x44
            width: 44,
            height: 44,
            child: Stack(
              children: [
                Positioned(left: 11, top: 11, child: AppIcons.notificationIcon), // Positioned: poziție exactă în Stack
                if (item.hasNotifications) Positioned(left: 23, top: 13, child: AppIcons.notificationDot), // collection-if: punctul apare doar dacă sunt notificări
              ],
            ),
          ),
        ),
      ],
    );
  }
}
