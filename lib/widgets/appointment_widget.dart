import 'package:flutter/material.dart';
import 'package:test_pam/list_items/appointment_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Cardul "Appointment": card verde (data, ora) + card alb cu medicul care iese peste marginea de jos.
class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget({
    super.key,
    required this.item,
    required this.onTapDetails,
    required this.onTapEdit,
    required this.onTapMessage,
  });

  final AppointmentListItem item;
  final VoidCallback onTapDetails; // deschide pagina de detalii (Navigator.push în HealthHomePage)
  final VoidCallback onTapEdit;
  final VoidCallback onTapMessage;

  @override
  Widget build(BuildContext context) {
    final appointment = item.appointment;
    final whiteText = AppTextStyles.medium14.copyWith(color: AppColors.whiteColor); // copyWith: același stil, culoare albă

    return Padding( // Padding: 24px deasupra cardului
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox( // SizedBox: fixează înălțimea zonei la 198 (Stack-ul are nevoie de dimensiune)
        height: 198,
        child: Stack( // Stack: straturi suprapuse -> cardul alb stă PESTE cardul verde
          children: [
            Positioned( // Positioned: fixează copilul la coordonate în Stack
              left: 0,
              right: 0,
              top: 0,
              height: 173,
              child: Container( // Container doar cu decorație: dreptunghiul verde cu colțuri rotunde
                decoration: BoxDecoration(color: AppColors.coralGreen01, borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              top: 23,
              child: Column( // Column: conținutul cardului verde, pe verticală
                children: [
                  InkWell( // InkWell: rândul "Appointment >" e clicabil
                    onTap: onTapDetails,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // text stânga, săgeată dreapta
                      children: [
                        Text(
                          AppStrings.appointment,
                          style: AppTextStyles.medium12.copyWith(color: AppColors.whiteColor),
                        ),
                        AppIcons.arrowRightIcon,
                      ],
                    ),
                  ),
                  SizedBox(height: 24), // SizedBox: spațiu vertical de 24px
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppIcons.calendarEditIcon,
                              SizedBox(width: 8), // spațiu între iconiță și dată
                              Text(appointment.date, style: whiteText),
                            ],
                          ),
                          SizedBox(height: 12), // spațiu între dată și oră
                          Row(
                            children: [
                              // SizedBox 20x20 + Center: iconița ceasului centrată într-o cutie fixă
                              SizedBox(width: 20, height: 20, child: Center(child: AppIcons.clockIcon)),
                              SizedBox(width: 8),
                              Text(appointment.time, style: whiteText),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: onTapEdit,
                        customBorder: CircleBorder(), // ripple în formă de cerc
                        child: Stack( // Stack: cercul și creionul suprapuse
                          alignment: Alignment.center, // ambele centrate unul peste altul
                          children: [AppIcons.editCircle, AppIcons.editIcon],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned( // cardul alb cu medicul, pus mai jos -> iese peste marginea cardului verde
              left: 22,
              right: 22,
              top: 131,
              child: Container( // Container: înălțime + padding + decorație (fundal alb, umbră)
                height: 67,
                padding: EdgeInsets.only(left: 13, right: 14),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 8), blurRadius: 80)], // BoxShadow: umbra cardului
                ),
                child: Row(
                  children: [
                    ClipRRect( // ClipRRect: decupează copilul cu colțuri rotunjite (Rounded Rect)
                      borderRadius: BorderRadius.circular(8),
                      child: Container( // Container gri 43x43 = fundal până se încarcă poza
                        width: 43,
                        height: 43,
                        color: AppColors.imagePlaceholder,
                        child: Image.asset(appointment.doctor.imagePath, fit: BoxFit.cover), // Image.asset: imagine din assets
                      ),
                    ),
                    SizedBox(width: 12), // spațiu între poză și text
                    Expanded( // Expanded: textul ia spațiul rămas, iconița de mesaj rămâne la dreapta
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Column ocupă doar cât îi trebuie pe verticală
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appointment.doctor.name, style: AppTextStyles.semiBold16),
                          SizedBox(height: 4),
                          Text(appointment.doctor.specialty, style: AppTextStyles.medium12),
                        ],
                      ),
                    ),
                    InkWell(onTap: onTapMessage, child: AppIcons.messageTextIcon), // iconiță clicabilă
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
