import 'package:domain/entities/doctor.dart';

// Entități: datele paginii de detalii (răspunsul GET /feed/details).
// Un grup de opțiuni selectabile ("Working Hours" sau "Date").
class SlotGroup {
  final String title;
  final bool showAll;
  final List<String> labels;
  final int selectedIndex;

  const SlotGroup({required this.title, required this.showAll, required this.labels, required this.selectedIndex});

  SlotGroup select(int index) => SlotGroup(title: title, showAll: showAll, labels: labels, selectedIndex: index);
}

class AppointmentDetails {
  final String title;
  final Doctor doctor;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;
  final String paymentLabel;
  final String payment;
  final String detailsTitle;
  final String description;
  final SlotGroup workingHours;
  final SlotGroup dates;
  final String bookLabel;
  final bool bookEnabled;

  const AppointmentDetails({
    required this.title,
    required this.doctor,
    required this.canMessage,
    required this.canCall,
    required this.canVideoCall,
    required this.paymentLabel,
    required this.payment,
    required this.detailsTitle,
    required this.description,
    required this.workingHours,
    required this.dates,
    required this.bookLabel,
    required this.bookEnabled,
  });

  AppointmentDetails copyWith({Doctor? doctor, SlotGroup? workingHours, SlotGroup? dates}) => AppointmentDetails(
    title: title,
    doctor: doctor ?? this.doctor,
    canMessage: canMessage,
    canCall: canCall,
    canVideoCall: canVideoCall,
    paymentLabel: paymentLabel,
    payment: payment,
    detailsTitle: detailsTitle,
    description: description,
    workingHours: workingHours ?? this.workingHours,
    dates: dates ?? this.dates,
    bookLabel: bookLabel,
    bookEnabled: bookEnabled,
  );
}
