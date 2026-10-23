import 'package:flutter/material.dart';
import 'package:test_pam/health_home_page.dart';
import 'package:test_pam/resources/app_colors.dart';

// Widget-ul rădăcină al aplicației (pornit din main.dart cu runApp).
class TestPamWidget extends StatelessWidget {
  const TestPamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // MaterialApp: configurează aplicația (temă, navigare, primul ecran)
      debugShowCheckedModeBanner: false, // ascunde banda "DEBUG" din colț
      home: Scaffold( // Scaffold: scheletul ecranului
        backgroundColor: AppColors.whiteColor,
        body: const SafeArea(bottom: false, child: HealthHomePage()), // SafeArea: evită notch-ul; jos lăsat liber
      ),
    );
  }
}
