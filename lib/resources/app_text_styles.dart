import 'package:flutter/material.dart';
import 'package:test_pam/resources/app_colors.dart';

// Stilurile de text (font, mărime, grosime, culoare) folosite în aplicație.
class FontsFamily {
  static String outfitRegular = 'OutfitRegular';
  static String outfitMedium = 'OutfitMedium';
  static String outfitSemiBold = 'OutfitSemiBold';
  static String openSansRegular = 'OpenSansRegular';
  static String openSansSemiBold = 'OpenSansSemiBold';
  static String openSansBold = 'OpenSansBold';
}

class AppTextStyles {
  static TextStyle semiBold14 = _style(FontsFamily.outfitSemiBold, 14, 1.3, AppColors.black01);
  static TextStyle semiBold16 = _style(FontsFamily.outfitSemiBold, 16, 1.3, AppColors.black01);
  static TextStyle semiBold18 = _style(FontsFamily.outfitSemiBold, 18, 1.3, AppColors.black01);
  static TextStyle medium12 = _style(FontsFamily.outfitMedium, 12, 1.3, AppColors.black03);
  static TextStyle medium14 = _style(FontsFamily.outfitMedium, 14, 1.3, AppColors.black03);
  static TextStyle regular10 = _style(FontsFamily.outfitRegular, 10, 1.8, AppColors.black03);
  static TextStyle regular12 = _style(FontsFamily.outfitRegular, 12, 1.8, AppColors.black03);
  static TextStyle regular14 = _style(FontsFamily.outfitRegular, 14, 1.8, AppColors.grey01);

  static TextStyle titleBold26 = _style(FontsFamily.openSansBold, 26, 1, AppColors.primaryTeal, -0.52);
  static TextStyle bold22 = _style(FontsFamily.openSansBold, 22, 1, AppColors.blackColor);
  static TextStyle buttonBold22 = _style(FontsFamily.openSansBold, 22, 1, AppColors.whiteColor, -0.44);
  static TextStyle priceBold20 = _style(FontsFamily.openSansBold, 20, null, AppColors.mintColor);
  static TextStyle sectionSemiBold22 = _style(FontsFamily.openSansSemiBold, 22, 1, AppColors.blackColor, -0.44);
  static TextStyle semiBold20 = _style(FontsFamily.openSansSemiBold, 20, 1, AppColors.blackColor);
  static TextStyle specialtySemiBold16 = _style(FontsFamily.openSansSemiBold, 16, 1, AppColors.mintColor);
  static TextStyle chipRegular20 = _style(FontsFamily.openSansRegular, 20, 1, AppColors.blackColor, -0.4);
  static TextStyle actionRegular16 = _style(FontsFamily.openSansRegular, 16, 1, AppColors.blackColor, -0.32);
  static TextStyle descriptionRegular13 = _style(FontsFamily.openSansRegular, 13, 1.32, AppColors.descriptionGrey);

  static TextStyle _style(String family, double size, double? height, Color color, [double letterSpacing = 0]) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        height: height,
        letterSpacing: letterSpacing,
        leadingDistribution: TextLeadingDistribution.even,
        color: color,
      );
}
