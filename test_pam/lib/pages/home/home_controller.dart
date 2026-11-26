import 'package:domain/entities/doctor.dart';
import 'package:domain/entities/home_data.dart';
import 'package:domain/use_cases/filter_doctors_use_case.dart';
import 'package:domain/use_cases/get_home_feed_use_case.dart';
import 'package:get/get.dart';
import 'package:test_pam/base/base_get_x_controller.dart';
import 'package:test_pam/list_items/appointment_list_item.dart';
import 'package:test_pam/list_items/doctor_list_item.dart';
import 'package:test_pam/list_items/empty_list_item.dart';
import 'package:test_pam/list_items/header_list_item.dart';
import 'package:test_pam/list_items/health_services_list_item.dart';
import 'package:test_pam/list_items/list_item.dart';
import 'package:test_pam/list_items/search_list_item.dart';
import 'package:test_pam/list_items/section_list_item.dart';
import 'package:test_pam/resources/app_strings.dart';

// Logica ecranului principal (GetX): cere datele de la serviciul Web prin use case, ține starea în observabile,
// iar căutarea / filtrarea / sortarea le face use case-ul FilterDoctorsUseCase din Domain.
class HomeController extends BaseGetXController {
  // Use case-urile vin din get_it (înregistrate în di/); controller-ul nu știe de Dio sau de JSON.
  GetHomeFeedUseCase get getHomeFeedUseCase => getIt<GetHomeFeedUseCase>();
  FilterDoctorsUseCase get filterDoctorsUseCase => getIt<FilterDoctorsUseCase>();

  // Starea GetX (observabile): la schimbarea .value, Obx din pagină se redesenează singur.
  // isLoading și errorMessage vin din BaseGetXController.
  RxList<ListItem> items = RxList();

  // Datele primite de la server și filtrele curente; lista afișată se recalculează mereu din ele.
  HomeData? _data;
  String query = '';
  String? specialty;
  bool favoritesOnly = false;
  DoctorSort sort = DoctorSort.recommended;

  List<String> get specialties => (_data?.doctors ?? []).map((d) => d.specialty).toSet().toList()..sort();
  bool get hasActiveFilters => query.isNotEmpty || specialty != null || favoritesOnly;

  // GetX apelează onInit automat după Get.put: aici pornește încărcarea.
  @override
  void onInit() {
    super.onInit();
    load();
  }

  // Încărcare asincronă: UI -> Controller -> UseCase -> Repository -> DataSource -> GET /feed, și înapoi.
  // Loading cât așteaptă, apoi Success/Empty (lista) sau Error (mesaj + Retry).
  Future<void> load() => runRequest(getHomeFeedUseCase.call, (HomeData data) {
    _data = data;
    _buildItems();
  });

  // Acțiunile utilizatorului: schimbă filtrele sau datele, apoi reconstruiesc lista.
  void search(String text) {
    query = text.trim();
    _buildItems();
  }

  void applyFilters({required String? specialty, required bool favoritesOnly, required DoctorSort sort}) {
    this.specialty = specialty;
    this.favoritesOnly = favoritesOnly;
    this.sort = sort;
    _buildItems();
  }

  void resetFilters() {
    query = '';
    specialty = null;
    favoritesOnly = false;
    sort = DoctorSort.recommended;
    _buildItems();
  }

  void toggleFavorite(String doctorId) {
    final data = _data;
    if (data == null) return;
    // Datele sunt imuabile: copyWith creează un medic nou cu isFavorite inversat.
    _data = data.copyWith(
      doctors: [for (final d in data.doctors) d.id == doctorId ? d.copyWith(isFavorite: !d.isFavorite) : d],
    );
    _buildItems();
  }

  // Medicii vizibili: regula de business e în Domain (FilterDoctorsUseCase).
  List<Doctor> _visibleDoctors(HomeData data) => filterDoctorsUseCase(
    data.doctors,
    query: query,
    specialty: specialty,
    favoritesOnly: favoritesOnly,
    sort: sort,
  );

  void _buildItems() {
    final data = _data;
    if (data == null) return;
    final doctors = _visibleDoctors(data);
    // Schimbarea stării: noile rânduri ajung în items -> Obx redesenează ecranul.
    items.value = [
      HeaderListItem(
        greeting: data.greeting,
        subtitle: data.subtitle,
        avatarUrl: data.avatarUrl,
        hasNotifications: data.hasUnreadNotifications,
      ),
      SearchListItem(hint: data.searchHint, hasActiveFilters: specialty != null || favoritesOnly),
      AppointmentListItem(appointment: data.appointment),
      SectionListItem(title: AppStrings.healthServices, rightActionTitle: AppStrings.seeAll),
      HealthServicesListItem(services: data.services),
      SectionListItem(title: AppStrings.nearbyDoctor, rightActionTitle: AppStrings.seeAll),
      if (doctors.isEmpty) EmptyListItem(hasActiveFilters: hasActiveFilters), // starea Empty
      for (final doctor in doctors) DoctorListItem(doctor: doctor),
    ];
  }

}
