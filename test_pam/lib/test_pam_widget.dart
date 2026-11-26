import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/pages/home/health_home_page.dart';

// Widget-ul rădăcină: GetMaterialApp (necesar pentru GetX) cu ecranul principal.
class TestPamWidget extends StatelessWidget {
  const TestPamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // MaterialApp + GetX: permite Get.to / Get.back și gestionarea controllerelor
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: const SafeArea(bottom: false, child: HealthHomePage()),
      ),
    );
  }
}
