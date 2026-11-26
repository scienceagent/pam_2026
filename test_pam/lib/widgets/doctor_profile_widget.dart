import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_pam/list_items/doctor_profile_list_item.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_text_styles.dart';
import 'package:test_pam/widgets/app_network_image.dart';

// Desenează profilul medicului din pagina de detalii: poză, nume, butoane, plată.
class DoctorProfileWidget extends StatelessWidget {
  const DoctorProfileWidget({
    super.key,
    required this.item,
    required this.onTapMessage,
    required this.onTapCall,
    required this.onTapVideo,
  });

  final DoctorProfileListItem item;
  final VoidCallback onTapMessage;
  final VoidCallback onTapCall;
  final VoidCallback onTapVideo;

  @override
  Widget build(BuildContext context) {
    final details = item.details;
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 379,
        child: Row(
          children: [
            AppNetworkImage(url: details.doctor.imageUrl, size: 132, radius: 10),
            SizedBox(width: 21),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 17,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(details.doctor.name, style: AppTextStyles.bold22, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (details.canMessage) _CircleButton(icon: AppIcons.messageIcon, onTap: onTapMessage),
                          if (details.canCall) ...[SizedBox(width: 17), _CircleButton(icon: AppIcons.phoneIcon, onTap: onTapCall)],
                          if (details.canVideoCall) ...[SizedBox(width: 17), _CircleButton(icon: AppIcons.videoIcon, onTap: onTapVideo)],
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(details.doctor.specialty, style: AppTextStyles.specialtySemiBold16),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(details.paymentLabel, style: AppTextStyles.semiBold20, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox(
                        width: 77.93,
                        child: Text(details.payment, style: AppTextStyles.priceBold20, textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final SvgPicture icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, customBorder: CircleBorder(), child: icon);
  }
}
