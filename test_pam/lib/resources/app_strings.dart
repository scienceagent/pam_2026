// Textele fixe care nu vin din JSON (butoane, mesaje de stare, filtre).
class AppStrings {
  static String healthServices = 'Health Services';
  static String nearbyDoctor = 'Nearby Doctor';
  static String seeAll = 'See All';
  static String retry = 'Retry';
  static String noDoctorsFound = 'No doctors match your search';
  static String noDoctorsAvailable = 'No doctors nearby yet';
  static String resetFilters = 'Reset filters';
  static String sortBy = 'Sort by';
  static String specialty = 'Specialty';
  static String all = 'All';
  static String favoritesOnly = 'Favorites only';
  static String apply = 'Apply';
  static String bookedAt(String date, String hour) => 'Appointment booked: $date, $hour';
}
