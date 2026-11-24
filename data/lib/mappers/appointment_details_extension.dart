import 'package:data/mappers/doctor_extension.dart';
import 'package:data/mappers/slot_group_extension.dart';
import 'package:data/models/appointment_details_model.dart';
import 'package:domain/entities/appointment_details.dart';

// Mapper (stratul Data): Model (formatul serverului) -> Entitate (formatul aplicației).
extension AppointmentDetailsExtension on AppointmentDetailsModel {
  AppointmentDetails get toEntity => AppointmentDetails(
    title: title,
    doctor: doctor.toEntity,
    canMessage: doctorActions.message,
    canCall: doctorActions.call,
    canVideoCall: doctorActions.videoCall,
    paymentLabel: payment.label,
    payment: payment.formatted,
    detailsTitle: details.title,
    description: details.description,
    workingHours: workingHours.toEntity,
    dates: date.toEntity,
    bookLabel: bookAppointment.label,
    bookEnabled: bookAppointment.enabled,
  );
}
