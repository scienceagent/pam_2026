import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_pam/list_items/doctor_profile_list_item.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Profilul medicului pe pagina de detalii: poză, nume, butoane mesaj/apel/video, specialitate, preț.
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
    // shortcut: the 379px design row is scaled down on screens narrower than 430px, use a reflowing layout if it must not shrink.
    return FittedBox( // FittedBox: scalează copilul ca să încapă în spațiul disponibil
      fit: BoxFit.scaleDown, // doar micșorează, nu mărește
      alignment: Alignment.centerLeft,
      child: SizedBox( // SizedBox: lățimea fixă de 379px din Figma
        width: 379,
        child: Row( // Row: poza în stânga, informațiile în dreapta
          children: [
            ClipRRect( // ClipRRect: poza cu colțuri rotunjite (raza 10)
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(item.doctor.imagePath, width: 132, height: 132, fit: BoxFit.cover),
            ),
            SizedBox(width: 21), // SizedBox: spațiu de 21px între poză și text
            Expanded( // Expanded: coloana de informații ia restul lățimii
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible( // Flexible: numele se poate micșora, nu împinge butoanele afară
                        child: Text(item.doctor.name, style: AppTextStyles.bold22, overflow: TextOverflow.ellipsis), // ellipsis: "..." dacă nu încape
                      ),
                      SizedBox(width: 17), // spațiu între butoane
                      _CircleButton(icon: AppIcons.messageIcon, onTap: onTapMessage),
                      SizedBox(width: 17),
                      _CircleButton(icon: AppIcons.phoneIcon, onTap: onTapCall),
                      SizedBox(width: 17),
                      _CircleButton(icon: AppIcons.videoIcon, onTap: onTapVideo),
                    ],
                  ),
                  SizedBox(height: 10), // spațiu vertical
                  Text(item.doctor.specialty, style: AppTextStyles.specialtySemiBold16),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // "Payment" stânga, prețul dreapta
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(AppStrings.payment, style: AppTextStyles.semiBold20, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox( // SizedBox cu copil: cutie de lățime fixă în care prețul e centrat
                        width: 77.93,
                        child: Text(item.payment, style: AppTextStyles.priceBold20, textAlign: TextAlign.center),
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

// Clasă privată (începe cu "_"): vizibilă doar în acest fișier.
class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final SvgPicture icon; // SvgPicture: imagine vectorială SVG (pachetul flutter_svg)
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The SVG already contains the 30px mint circle (drawn over the icon, as in Figma).
    return InkWell(onTap: onTap, customBorder: CircleBorder(), child: icon); // InkWell cu ripple rotund
  }
}
