import 'package:flutter/material.dart';
import 'package:test_pam/list_items/appointment_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_text_styles.dart';
import 'package:test_pam/widgets/app_network_image.dart';

// Desenează cardul programării curente (dată, oră, medic).
class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget({
    super.key,
    required this.item,
    required this.onTapDetails,
    required this.onTapEdit,
    required this.onTapMessage,
  });

  final AppointmentListItem item;
  final VoidCallback onTapDetails;
  final VoidCallback onTapEdit;
  final VoidCallback onTapMessage;

  @override
  Widget build(BuildContext context) {
    final appointment = item.appointment;
    final whiteText = AppTextStyles.medium14.copyWith(color: AppColors.whiteColor);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        height: 198,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 173,
              child: Container(
                decoration: BoxDecoration(color: AppColors.coralGreen01, borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              top: 23,
              child: Column(
                children: [
                  InkWell(
                    onTap: onTapDetails,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appointment.title,
                          style: AppTextStyles.medium12.copyWith(color: AppColors.whiteColor),
                        ),
                        AppIcons.arrowRightIcon,
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppIcons.calendarEditIcon,
                              SizedBox(width: 8),
                              Text(appointment.date, style: whiteText),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              SizedBox(width: 20, height: 20, child: Center(child: AppIcons.clockIcon)),
                              SizedBox(width: 8),
                              Text(appointment.time, style: whiteText),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: onTapEdit,
                        customBorder: CircleBorder(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [AppIcons.editCircle, AppIcons.editIcon],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              top: 131,
              child: Container(
                height: 67,
                padding: EdgeInsets.only(left: 13, right: 14),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 8), blurRadius: 80)],
                ),
                child: Row(
                  children: [
                    AppNetworkImage(url: appointment.doctor.imageUrl, size: 43, radius: 8),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appointment.doctor.name, style: AppTextStyles.semiBold16),
                          SizedBox(height: 4),
                          Text(appointment.doctor.specialty, style: AppTextStyles.medium12),
                        ],
                      ),
                    ),
                    InkWell(onTap: onTapMessage, child: AppIcons.messageTextIcon),
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
