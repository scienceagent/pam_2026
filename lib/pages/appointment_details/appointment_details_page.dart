import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_pam/list_items/chips_list_item.dart';
import 'package:test_pam/list_items/details_list_item.dart';
import 'package:test_pam/list_items/doctor_profile_list_item.dart';
import 'package:test_pam/list_items/list_item.dart';
import 'package:domain/entities/appointment_details.dart';
import 'package:domain/entities/doctor.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/resources/app_text_styles.dart';
import 'package:test_pam/pages/appointment_details/appointment_details_controller.dart';
import 'package:test_pam/widgets/chips_section_widget.dart';
import 'package:test_pam/widgets/details_widget.dart';
import 'package:test_pam/widgets/doctor_profile_widget.dart';
import 'package:test_pam/widgets/state_views.dart';

// Pagina de detalii: deschisă cu Get.to, afișează cu Obx medicul, plata, orele și datele programării.
class AppointmentDetailsPage extends StatefulWidget {
  const AppointmentDetailsPage({super.key, this.doctor});

  final Doctor? doctor;

  // Navigare GetX: deschide pagina pentru medicul apăsat (null -> medicul din JSON).
  static Future<void>? open({Doctor? doctor}) => Get.to(() => AppointmentDetailsPage(doctor: doctor));

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  @override
  void initState() {
    super.initState();
    Get.put(AppointmentDetailsController(doctor: widget.doctor)); // GetX: controller nou -> onInit() -> load()
  }

  @override
  void dispose() {
    Get.delete<AppointmentDetailsController>(); // la închidere, controller-ul e șters (următoarea deschidere are alt medic)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentDetailsController>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        // Tratarea stărilor: Loading -> spinner, Error -> mesaj + Retry, altfel conținutul.
        child: Obx(() {
          if (controller.isLoading.value) return const LoadingView();
          final error = controller.errorMessage.value;
          if (error != null) return ErrorView(message: error, onRetry: controller.load);
          return _Content(details: controller.details.value!);
        }),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.details});

  final AppointmentDetails details;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentDetailsController>();
    final workingHours = ChipsListItem(
      title: details.workingHours.title,
      rightActionTitle: details.workingHours.showAll ? AppStrings.seeAll : null,
      chips: details.workingHours.labels,
      selectedIndex: details.workingHours.selectedIndex,
    );
    final dates = ChipsListItem(
      title: details.dates.title,
      rightActionTitle: details.dates.showAll ? AppStrings.seeAll : null,
      chips: details.dates.labels,
      selectedIndex: details.dates.selectedIndex,
    );
    final List<ListItem> items = [
      DoctorProfileListItem(details: details),
      DetailsListItem(title: details.detailsTitle, description: details.description),
      workingHours,
      dates,
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: SizedBox(
            height: 40,
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
                  child: Text(details.title, style: AppTextStyles.titleBold26, textAlign: TextAlign.center),
                ),
                Positioned(
                  left: 26.7,
                  child: InkWell(
                    onTap: () => Get.back(), // navigare GetX: înapoi la ecranul principal
                    customBorder: CircleBorder(),
                    child: AppIcons.arrowBackIcon,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
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
                final isHours = item == workingHours;
                return ChipsSectionWidget(
                  item: item,
                  topSpacing: isHours ? 61.4 : 29, // spațieri și lățimi măsurate în Figma
                  chipWidths: isHours ? [133, 129, 132] : [127, 118, 122],
                  chipLeftPaddings: isHours ? [24, 22, 24] : [38, 30, 36],
                  onSelect: isHours ? controller.selectHour : controller.selectDate, // schimbarea stării -> Obx colorează chip-ul ales
                  onTapAction: () {},
                );
              }
              return Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                height: 100,
                child: Center(child: Text('Widget Not found')),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(26.7, 0, 26.7, 5),
          child: Material(
            color: details.bookEnabled ? AppColors.primaryTeal : AppColors.grey01,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: details.bookEnabled ? () => _book(context) : null,
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: Center(child: Text(details.bookLabel, style: AppTextStyles.buttonBold22)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _book(BuildContext context) {
    final hours = details.workingHours;
    final dates = details.dates;
    if (hours.selectedIndex < 0 || dates.selectedIndex < 0) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.bookedAt(dates.labels[dates.selectedIndex], hours.labels[hours.selectedIndex]))),
    );
  }
}
