import 'package:domain/repositories/health_repository.dart';
import 'package:domain/use_cases/filter_doctors_use_case.dart';
import 'package:domain/use_cases/get_appointment_details_use_case.dart';
import 'package:domain/use_cases/get_home_feed_use_case.dart';
import 'package:get_it/get_it.dart';

// Stratul Domain: use case-urile, care primesc repository-ul prin contractul abstract.
void injectDomain() {
  var getIt = GetIt.instance;
  getIt.registerSingleton<GetHomeFeedUseCase>(GetHomeFeedUseCase(healthRepository: getIt.get<HealthRepository>()));
  getIt.registerSingleton<GetAppointmentDetailsUseCase>(
    GetAppointmentDetailsUseCase(healthRepository: getIt.get<HealthRepository>()),
  );
  getIt.registerSingleton<FilterDoctorsUseCase>(const FilterDoctorsUseCase());
}
