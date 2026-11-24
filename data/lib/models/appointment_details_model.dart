import 'package:data/models/doctor_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment_details_model.g.dart';

// Modele (stratul Data) pentru răspunsul GET /lab2026/v2/feed/details.
// Fiecare obiect din JSON are modelul lui tipizat (serializare automată), iar AppointmentDetailsModel le adună manual.

@JsonSerializable()
class SlotModel {
  final String id;
  final String label;
  final bool selected;

  const SlotModel({required this.id, required this.label, required this.selected});

  factory SlotModel.fromJson(Map<String, dynamic> json) => _$SlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$SlotModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SlotGroupModel {
  final String title;
  @JsonKey(defaultValue: false)
  final bool showAll;
  final List<SlotModel> slots;

  const SlotGroupModel({required this.title, required this.showAll, required this.slots});

  factory SlotGroupModel.fromJson(Map<String, dynamic> json) => _$SlotGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$SlotGroupModelToJson(this);
}

@JsonSerializable()
class DoctorActionsModel {
  @JsonKey(defaultValue: false)
  final bool message;
  @JsonKey(defaultValue: false)
  final bool call;
  @JsonKey(defaultValue: false)
  final bool videoCall;

  const DoctorActionsModel({required this.message, required this.call, required this.videoCall});

  factory DoctorActionsModel.fromJson(Map<String, dynamic> json) => _$DoctorActionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorActionsModelToJson(this);
}

@JsonSerializable()
class PaymentModel {
  final String label;
  final double amount;
  final String currency;
  final String formatted;

  const PaymentModel({required this.label, required this.amount, required this.currency, required this.formatted});

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}

@JsonSerializable()
class DetailsModel {
  final String title;
  final String description;

  const DetailsModel({required this.title, required this.description});

  factory DetailsModel.fromJson(Map<String, dynamic> json) => _$DetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsModelToJson(this);
}

@JsonSerializable()
class BookActionModel {
  final String label;
  @JsonKey(defaultValue: true)
  final bool enabled;

  const BookActionModel({required this.label, required this.enabled});

  factory BookActionModel.fromJson(Map<String, dynamic> json) => _$BookActionModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookActionModelToJson(this);
}

// Serializare manuală: acțiunile medicului stau în interiorul obiectului "doctor",
// iar butonul de rezervare în "actions" -> "bookAppointment"; le scoatem la nivelul modelului.
class AppointmentDetailsModel {
  final String title;
  final DoctorModel doctor;
  final DoctorActionsModel doctorActions;
  final PaymentModel payment;
  final DetailsModel details;
  final SlotGroupModel workingHours;
  final SlotGroupModel date;
  final BookActionModel bookAppointment;

  const AppointmentDetailsModel({
    required this.title,
    required this.doctor,
    required this.doctorActions,
    required this.payment,
    required this.details,
    required this.workingHours,
    required this.date,
    required this.bookAppointment,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    final doctorJson = json['doctor'] as Map<String, dynamic>;
    return AppointmentDetailsModel(
      title: json['title'] as String,
      doctor: DoctorModel.fromJson(doctorJson),
      doctorActions: DoctorActionsModel.fromJson(doctorJson['actions'] as Map<String, dynamic>? ?? const {}),
      payment: PaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
      details: DetailsModel.fromJson(json['details'] as Map<String, dynamic>),
      workingHours: SlotGroupModel.fromJson(json['workingHours'] as Map<String, dynamic>),
      date: SlotGroupModel.fromJson(json['date'] as Map<String, dynamic>),
      bookAppointment: BookActionModel.fromJson(
        (json['actions'] as Map<String, dynamic>)['bookAppointment'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'doctor': {...doctor.toJson(), 'actions': doctorActions.toJson()},
    'payment': payment.toJson(),
    'details': details.toJson(),
    'workingHours': workingHours.toJson(),
    'date': date.toJson(),
    'actions': {'bookAppointment': bookAppointment.toJson()},
  };
}
