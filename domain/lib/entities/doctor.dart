// Entitate (stratul Domain): medicul așa cum îl folosește aplicația. Dart pur, fără JSON și fără Flutter.
class Doctor {
  final String id;
  final String imageUrl;
  final String name;
  final String specialty;
  final String address;
  final bool isFavorite;

  const Doctor({
    this.id = '',
    required this.imageUrl,
    required this.name,
    required this.specialty,
    this.address = '',
    this.isFavorite = false,
  });

  // Distanța în metri extrasă din text ("... - 500M from you"), folosită la sortare.
  int get distanceMeters => int.tryParse(RegExp(r'(\d+)\s*M\b').firstMatch(address)?.group(1) ?? '') ?? 1 << 30;

  // Obiect imuabil: copyWith creează o copie nouă (folosit la favorite).
  Doctor copyWith({bool? isFavorite}) => Doctor(
    id: id,
    imageUrl: imageUrl,
    name: name,
    specialty: specialty,
    address: address,
    isFavorite: isFavorite ?? this.isFavorite,
  );
}
