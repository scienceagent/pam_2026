import 'package:domain/entities/appointment_details.dart';
import 'package:domain/entities/doctor.dart';
import 'package:domain/use_cases/get_appointment_details_use_case.dart';
import 'package:get/get.dart';
import 'package:test_pam/base/base_get_x_controller.dart';

// Logica paginii de detalii (GetX): cere detaliile prin use case și ține selecția orei și a datei.
class AppointmentDetailsController extends BaseGetXController {
  AppointmentDetailsController({this.doctor});

  final Doctor? doctor;

  GetAppointmentDetailsUseCase get getAppointmentDetailsUseCase => getIt<GetAppointmentDetailsUseCase>();

  Rxn<AppointmentDetails> details = Rxn<AppointmentDetails>();

  @override
  void onInit() {
    super.onInit();
    load(); // pornit automat de GetX după Get.put
  }

  // UI -> Controller -> UseCase -> Repository -> DataSource -> GET /feed/details, și înapoi.
  Future<void> load() => runRequest(() => getAppointmentDetailsUseCase(doctor: doctor), (result) => details.value = result);

  // Schimbarea stării la tap pe chip: copie nouă cu alt index selectat.
  void selectHour(int index) => _update((d) => d.copyWith(workingHours: d.workingHours.select(index)));

  void selectDate(int index) => _update((d) => d.copyWith(dates: d.dates.select(index)));

  void _update(AppointmentDetails Function(AppointmentDetails) change) {
    final current = details.value;
    if (current != null) details.value = change(current);
  }
}
