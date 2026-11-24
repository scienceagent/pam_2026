import 'package:domain/entities/doctor.dart';

enum DoctorSort {
  recommended('Recommended'),
  nameAsc('Name A-Z'),
  nameDesc('Name Z-A'),
  distance('Nearest');

  const DoctorSort(this.label);
  final String label;
}

// Use case (Domain): regula de business pentru lista "Nearby Doctor" - căutare -> specialitate/favorite -> sortare.
// Nu știe nimic de HTTP sau de UI, deci se testează direct.
class FilterDoctorsUseCase {
  const FilterDoctorsUseCase();

  List<Doctor> call(
    List<Doctor> doctors, {
    String query = '',
    String? specialty,
    bool favoritesOnly = false,
    DoctorSort sort = DoctorSort.recommended,
  }) {
    final text = query.trim().toLowerCase();
    final result = doctors.where((d) {
      final matchesQuery = text.isEmpty || '${d.name} ${d.specialty} ${d.address}'.toLowerCase().contains(text);
      return matchesQuery && (specialty == null || d.specialty == specialty) && (!favoritesOnly || d.isFavorite);
    }).toList();
    switch (sort) {
      case DoctorSort.recommended:
        break; // ordinea de pe server
      case DoctorSort.nameAsc:
        result.sort((a, b) => _sortName(a).compareTo(_sortName(b)));
      case DoctorSort.nameDesc:
        result.sort((a, b) => _sortName(b).compareTo(_sortName(a)));
      case DoctorSort.distance:
        result.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    }
    return result;
  }

  // Sortează după nume, nu după titlul "Dr.".
  static String _sortName(Doctor d) => d.name.replaceFirst(RegExp(r'^Dr\.?\s*'), '').toLowerCase();
}
