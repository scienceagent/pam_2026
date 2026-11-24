import 'package:domain/entities/doctor.dart';
import 'package:domain/use_cases/filter_doctors_use_case.dart';
import 'package:test/test.dart';

// Domain se testează fără server și fără Flutter: entități + use case = Dart pur.
void main() {
  const emmly = Doctor(id: '1', imageUrl: '', name: 'Dr. Emmly Lestiryno', specialty: 'General Practitioner', address: 'Durgan Shores - 500M from you');
  const sonja = Doctor(id: '2', imageUrl: '', name: 'Dr. Sonja Litel', specialty: 'Dental Specialist', address: 'Sigrid Port - 753M from you', isFavorite: true);
  const filter = FilterDoctorsUseCase();
  final doctors = [sonja, emmly];

  test('search, specialty and favorites', () {
    expect(filter(doctors, query: 'durgan'), [emmly]);
    expect(filter(doctors, specialty: 'Dental Specialist'), [sonja]);
    expect(filter(doctors, favoritesOnly: true), [sonja]);
    expect(filter(doctors, query: 'zzz'), isEmpty);
  });

  test('sorting ignores the "Dr." prefix and parses the distance', () {
    expect(filter(doctors, sort: DoctorSort.nameAsc), [emmly, sonja]);
    expect(filter(doctors, sort: DoctorSort.nameDesc), [sonja, emmly]);
    expect(filter(doctors, sort: DoctorSort.distance), [emmly, sonja]);
    expect(filter(doctors), [sonja, emmly]); // recommended = ordinea de pe server
  });
}
