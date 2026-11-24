
// Model (stratul Data) cu serializare MANUALĂ: fromJson și toJson scrise de mână.
class HealthServiceModel {
  final String id;
  final String name;
  final String iconUrl;

  const HealthServiceModel({required this.id, required this.name, required this.iconUrl});

  // Map (decodat de Dio din răspunsul JSON) -> obiect.
  factory HealthServiceModel.fromJson(Map<String, dynamic> json) => HealthServiceModel(
    id: json['id'] as String,
    name: json['name'] as String,
    iconUrl: json['iconUrl'] as String,
  );

  // Obiect -> Map (jsonEncode îl face apoi text JSON).
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'iconUrl': iconUrl};
}
