import 'package:flutter/material.dart';
import 'package:test_pam/list_items/doctor_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// StatelessWidget: nu are stare proprie, se desenează doar din datele primite (item).
class DoctorListWidget extends StatelessWidget {
  const DoctorListWidget({super.key, required this.item, required this.onFavorite});

  final DoctorListItem item;
  final VoidCallback onFavorite; // VoidCallback = funcție fără parametri, apelată la tap pe inimă

  @override
  Widget build(BuildContext context) {
    final doctor = item.doctor;

    return Padding( // Padding: adaugă spațiu în jurul copilului (aici 16 jos, între medici)
      padding: const EdgeInsets.only(bottom: 16),
      child: Row( // Row: așază copiii pe orizontală
        crossAxisAlignment: CrossAxisAlignment.start, // aliniere pe axa verticală (secundară) - sus
        children: [
          // ClipOval: decupează copilul în formă de cerc/oval -> poza rotundă a medicului
          ClipOval(child: Image.asset(doctor.imagePath, width: 46, height: 46, fit: BoxFit.cover)), // BoxFit.cover: umple tot, taie surplusul
          SizedBox(width: 12), // SizedBox: cutie goală de dimensiune fixă -> spațiu de 12px între poză și text
          Expanded( // Expanded: ocupă tot spațiul rămas din Row (împinge inima la dreapta)
            child: Column( // Column: așază copiii pe verticală
              crossAxisAlignment: CrossAxisAlignment.start, // texte aliniate la stânga
              children: [
                Text(doctor.name, style: AppTextStyles.semiBold14), // Text: afișează un șir cu stilul dat
                Text(doctor.specialty, style: AppTextStyles.regular12),
                SizedBox(height: 6), // spațiu vertical de 6px
                Row(
                  children: [
                    AppIcons.locationIcon, // iconiță SVG (flutter_svg)
                    SizedBox(width: 4), // spațiu orizontal de 4px
                    Text(doctor.address, style: AppTextStyles.regular12.copyWith(color: AppColors.black01)), // copyWith: copie a stilului, schimbă doar culoarea
                  ],
                ),
              ],
            ),
          ),
          InkWell(onTap: onFavorite, child: AppIcons.heartIcon), // InkWell: face copilul clicabil + efect ripple
        ],
      ),
    );
  }
}
