import 'package:domain/entities/appointment_details.dart';
import 'package:domain/entities/home_data.dart';

// Contractul repository-ului: Domain spune CE date îi trebuie, stratul Data decide DE UNDE (aici: serviciul Web).
// Ambele metode aruncă AppException când datele nu pot fi obținute.
abstract class HealthRepository {
  Future<HomeData> getHomeFeed();

  Future<AppointmentDetails> getAppointmentDetails();
}
