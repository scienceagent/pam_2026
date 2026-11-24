import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_pam/list_items/appointment_list_item.dart';
import 'package:test_pam/list_items/doctor_list_item.dart';
import 'package:test_pam/list_items/empty_list_item.dart';
import 'package:test_pam/list_items/header_list_item.dart';
import 'package:test_pam/list_items/health_services_list_item.dart';
import 'package:test_pam/list_items/search_list_item.dart';
import 'package:test_pam/list_items/section_list_item.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/pages/appointment_details/appointment_details_page.dart';
import 'package:test_pam/pages/home/home_controller.dart';
import 'package:test_pam/widgets/appointment_widget.dart';
import 'package:test_pam/widgets/doctor_list_widget.dart';
import 'package:test_pam/widgets/filter_sheet.dart';
import 'package:test_pam/widgets/header_list_widget.dart';
import 'package:test_pam/widgets/health_services_widget.dart';
import 'package:test_pam/widgets/search_widget.dart';
import 'package:test_pam/widgets/section_list_widget.dart';
import 'package:test_pam/widgets/state_views.dart';

// Ecranul principal: ia HomeController din GetX și afișează cu Obx încărcarea, eroarea sau lista.
class HealthHomePage extends StatefulWidget {
  const HealthHomePage({super.key});

  @override
  State<HealthHomePage> createState() => _HealthHomePageState();
}

class _HealthHomePageState extends State<HealthHomePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.put(HomeController()); // GetX: creează controller-ul -> onInit() -> load()
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters(HomeController controller) {
    _searchController.clear();
    controller.resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>(); // GetX: ia controller-ul creat cu Get.put
    // Tratarea stărilor: Obx ascultă observabilele și redesenează la fiecare schimbare.
    return Obx(() {
      if (controller.isLoading.value) return const LoadingView(); // Loading
      final error = controller.errorMessage.value;
      if (error != null) return ErrorView(message: error, onRetry: controller.load); // Error + Retry
      // Success / Empty: câte un widget pentru fiecare rând din controller.items.
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 26),
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          final item = controller.items[index];
          if (item is HeaderListItem) {
            return HeaderListWidget(item: item, onTapNotifications: () {});
          }
          if (item is SearchListItem) {
            return SearchWidget(
              item: item,
              controller: _searchController,
              onSearch: controller.search,
              onTapFilter: () => showFilterSheet(context),
            );
          }
          if (item is AppointmentListItem) {
            return AppointmentWidget(
              item: item,
              onTapDetails: () => AppointmentDetailsPage.open(),
              onTapEdit: () {},
              onTapMessage: () {},
            );
          }
          if (item is SectionListItem) {
            return SectionListWidget(item: item, onTapAction: () => _resetFilters(controller));
          }
          if (item is HealthServicesListItem) {
            return HealthServicesWidget(
              item: item,
              onTapService: (service) {},
            );
          }
          if (item is DoctorListItem) {
            return DoctorListWidget(
              item: item,
              onTap: () => AppointmentDetailsPage.open(doctor: item.doctor),
              onFavorite: () => controller.toggleFavorite(item.doctor.id),
            );
          }
          if (item is EmptyListItem) {
            return item.hasActiveFilters
                ? EmptyView(
                    message: AppStrings.noDoctorsFound,
                    actionLabel: AppStrings.resetFilters,
                    onAction: () => _resetFilters(controller),
                  )
                : EmptyView(message: AppStrings.noDoctorsAvailable);
          }
          return Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            height: 100,
            child: Center(child: Text('Widget Not found')),
          );
        },
      );
    });
  }
}
