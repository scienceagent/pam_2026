import 'package:flutter/material.dart';
import 'package:test_pam/list_items/chips_list_item.dart';
import 'package:test_pam/list_items/details_list_item.dart';
import 'package:test_pam/list_items/doctor_profile_list_item.dart';
import 'package:test_pam/list_items/list_item.dart';
import 'package:test_pam/models/doctor.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_images.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/resources/app_text_styles.dart';
import 'package:test_pam/widgets/chips_section_widget.dart';
import 'package:test_pam/widgets/details_widget.dart';
import 'package:test_pam/widgets/doctor_profile_widget.dart';

// Al doilea ecran. StatefulWidget pentru că selecția chip-urilor se schimbă (setState).
class AppointmentDetailsPage extends StatefulWidget {
  const AppointmentDetailsPage({super.key});

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  final workingHours = ChipsListItem(
    title: AppStrings.workingHours,
    rightActionTitle: AppStrings.seeAll,
    chips: ['10.00 AM', '11.00 AM', '12.00 PM'],
    selectedIndex: 1,
  );
  final dates = ChipsListItem(
    title: AppStrings.date,
    rightActionTitle: AppStrings.seeAll,
    chips: ['Sun 4', 'Mon 5', 'Tue 6'],
  );

  // late: inițializare amânată, pentru că lista folosește câmpurile workingHours și dates de mai sus.
  late List<ListItem> items = [
    DoctorProfileListItem(
      doctor: Doctor(imagePath: AppImages.doctorUpul, name: 'Dr.Upul', specialty: 'Denteeth'),
      payment: '\$120.00', // "\$" = caracterul $ (altfel ar fi interpolare)
    ),
    DetailsListItem(
      title: AppStrings.details,
      description:
          'Worem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur tempus urna at turpis condimentum lobortis. Ut commodo efficitur neque. Ut diam quam, semper iaculis condimentum ac, vestibulum eu nisl.',
    ),
    workingHours,
    dates,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold: scheletul unui ecran Material (fundal, body, appBar etc.)
      backgroundColor: AppColors.whiteColor,
      body: SafeArea( // SafeArea: ține conținutul departe de notch / bara de status
        child: Column( // Column: titlu sus, lista la mijloc, butonul jos
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SizedBox( // SizedBox: înălțime fixă 40 pentru bara de titlu
                height: 40,
                child: Stack( // Stack: titlul centrat și săgeata înapoi suprapuse pe același rând
                  children: [
                    Positioned( // left: 0 + right: 0 -> titlul ocupă toată lățimea, deci e centrat
                      top: 5,
                      left: 0,
                      right: 0,
                      child: Text(AppStrings.appointment, style: AppTextStyles.titleBold26, textAlign: TextAlign.center),
                    ),
                    Positioned(
                      left: 26.7,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(), // Navigator.pop: închide ecranul, revine la cel anterior
                        customBorder: CircleBorder(),
                        child: AppIcons.arrowBackIcon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded( // Expanded: lista ia tot spațiul dintre titlu și buton
              child: ListView.builder( // listă derulabilă, construită lazy
                padding: EdgeInsets.only(top: 28.5, bottom: 24),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  if (item is DoctorProfileListItem) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 25, right: 26),
                      child: DoctorProfileWidget(item: item, onTapMessage: () {}, onTapCall: () {}, onTapVideo: () {}),
                    );
                  }
                  if (item is DetailsListItem) {
                    return DetailsWidget(item: item);
                  }
                  if (item is ChipsListItem) {
                    return ChipsSectionWidget(
                      item: item,
                      // Figma measures 44.4 from the 120px details text box; its 6 lines are ~103px tall.
                      topSpacing: item == workingHours ? 61.4 : 29,
                      // Chip widths exactly as drawn in Figma (its text boxes round widths up, Flutter's don't).
                      chipWidths: item == workingHours ? [133, 129, 132] : [127, 118, 122],
                      chipLeftPaddings: item == workingHours ? [24, 22, 24] : [38, 30, 36],
                      // setState: schimbă starea și cere un nou build() -> chip-ul ales devine teal
                      onSelect: (chipIndex) => setState(() => item.selectedIndex = chipIndex),
                      onTapAction: () {},
                    );
                  }
                  return Container( // fallback: chenar roșu dacă un tip de item nu are widget
                    decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                    height: 100,
                    child: Center(child: Text('Widget Not found')),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26.7, 0, 26.7, 5),
              child: Material( // Material: suprafața pe care InkWell desenează ripple-ul (culoare + colțuri)
                color: AppColors.primaryTeal,
                borderRadius: BorderRadius.circular(10),
                child: InkWell( // InkWell: butonul "Book an Appointment" clicabil
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox( // SizedBox: înălțime 60, lățime pe tot ecranul (double.infinity)
                    height: 60,
                    width: double.infinity,
                    child: Center(child: Text(AppStrings.bookAnAppointment, style: AppTextStyles.buttonBold22)), // Center: text centrat
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
