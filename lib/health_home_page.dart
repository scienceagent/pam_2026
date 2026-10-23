import 'package:flutter/material.dart';
import 'package:test_pam/appointment_details_page.dart';
import 'package:test_pam/list_items/appointment_list_item.dart';
import 'package:test_pam/list_items/doctor_list_item.dart';
import 'package:test_pam/list_items/header_list_item.dart';
import 'package:test_pam/list_items/health_services_list_item.dart';
import 'package:test_pam/list_items/list_item.dart';
import 'package:test_pam/list_items/search_list_item.dart';
import 'package:test_pam/list_items/section_list_item.dart';
import 'package:test_pam/models/appointment.dart';
import 'package:test_pam/models/doctor.dart';
import 'package:test_pam/models/health_service.dart';
import 'package:test_pam/resources/app_images.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/widgets/appointment_widget.dart';
import 'package:test_pam/widgets/doctor_list_widget.dart';
import 'package:test_pam/widgets/header_list_widget.dart';
import 'package:test_pam/widgets/health_services_widget.dart';
import 'package:test_pam/widgets/search_widget.dart';
import 'package:test_pam/widgets/section_list_widget.dart';

// StatefulWidget: are un obiect State separat care păstrează datele între rebuild-uri.
class HealthHomePage extends StatefulWidget {
  const HealthHomePage({super.key});

  @override
  State<HealthHomePage> createState() => _HealthHomePageState(); // creează obiectul de stare
}

class _HealthHomePageState extends State<HealthHomePage> {
  // Lista de date a ecranului: fiecare element e un tip de rând (polimorfism prin ListItem).
  List<ListItem> items = [
    HeaderListItem(firstName: 'Jonathan', hasNotifications: true),
    SearchListItem(),
    SectionListItem(
      title: AppStrings.healthServices,
      rightActionTitle: AppStrings.seeAll,
    ),
    HealthServicesListItem(
      services: [
        HealthService(imagePath: AppImages.tooth, title: 'Tooth'),
        HealthService(imagePath: AppImages.eye, title: 'Eye'),
        HealthService(imagePath: AppImages.lungs, title: 'Lungs'),
        HealthService(imagePath: AppImages.ear, title: 'Ear'),
      ],
    ),
    AppointmentListItem(
      appointment: Appointment(
        date: '22 October, 2023',
        time: '08:00 AM - 10.30 AM',
        doctor: Doctor(
          imagePath: AppImages.doctorRichar,
          name: 'Dr. Richar Kandowen',
          specialty: 'Child Specialist',
        ),
      ),
    ),

    SectionListItem(
      title: AppStrings.nearbyDoctor,
      rightActionTitle: AppStrings.seeAll,
    ),
    DoctorListItem(
      doctor: Doctor(
        imagePath: AppImages.doctorEmmly,
        name: 'Dr. Emmly Lestiryno',
        specialty: 'General Practitioner',
        address: '3167 Durgan Shores - 500M from you',
      ),
    ),
    DoctorListItem(
      doctor: Doctor(
        imagePath: AppImages.doctorSonja,
        name: 'Dr. Sonja Littel',
        specialty: 'Dental Specialist',
        address: '950 Sigrid Port - 753M from you',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // ListView.builder: listă derulabilă, construiește lazy doar rândurile vizibile
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        26,
      ), // fromLTRB: stânga, sus, dreapta, jos
      itemCount: items.length,
      itemBuilder: (context, index) {
        // apelat pentru fiecare rând care trebuie afișat
        final item = items[index];
        if (item is HeaderListItem) {
          // "is": verificare de tip; după ea Dart face smart cast
          return HeaderListWidget(item: item, onTapNotifications: () {});
        }
        if (item is SearchListItem) {
          return SearchWidget(onSearch: (String? text) {}, onTapFilter: () {});
        }
        if (item is AppointmentListItem) {
          return AppointmentWidget(
            item: item,
            // Navigator.push: pune un ecran nou peste cel curent (stivă de ecrane)
            onTapDetails: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AppointmentDetailsPage(),
              ),
            ),
            onTapEdit: () {},
            onTapMessage: () {},
          );
        }
        if (item is SectionListItem) {
          return SectionListWidget(item: item, onTapAction: () {});
        }
        if (item is HealthServicesListItem) {
          return HealthServicesWidget(
            item: item,
            onTapService: (service) => debugPrint('Ontap ${service.title}'),
          ); // debugPrint: scrie în consolă
        }
        if (item is DoctorListItem) {
          return DoctorListWidget(item: item, onFavorite: () {});
        }
        return Container(
          // fallback: chenar roșu dacă un tip de item nu are widget
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          height: 100,
          child: Center(
            child: Text('Widget Not found'),
          ), // Center: centrează copilul
        );
      },
    );
  }
}
