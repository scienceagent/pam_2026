import 'package:domain/entities/appointment_details.dart';
import 'package:domain/entities/doctor.dart';
import 'package:domain/repositories/health_repository.dart';

// Use case: "ia detaliile programării". Regula de business: dacă utilizatorul a ales un medic din listă,
// detaliile se afișează pentru acel medic, nu pentru cel trimis de server.
class GetAppointmentDetailsUseCase {
  GetAppointmentDetailsUseCase({required this.healthRepository});

  final HealthRepository healthRepository;

  Future<AppointmentDetails> call({Doctor? doctor}) async {
    final details = await healthRepository.getAppointmentDetails();
    return doctor == null ? details : details.copyWith(doctor: doctor);
  }
}
