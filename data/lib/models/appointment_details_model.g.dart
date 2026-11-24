// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotModel _$SlotModelFromJson(Map<String, dynamic> json) => SlotModel(
  id: json['id'] as String,
  label: json['label'] as String,
  selected: json['selected'] as bool,
);

Map<String, dynamic> _$SlotModelToJson(SlotModel instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'selected': instance.selected,
};

SlotGroupModel _$SlotGroupModelFromJson(Map<String, dynamic> json) =>
    SlotGroupModel(
      title: json['title'] as String,
      showAll: json['showAll'] as bool? ?? false,
      slots: (json['slots'] as List<dynamic>)
          .map((e) => SlotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SlotGroupModelToJson(SlotGroupModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'showAll': instance.showAll,
      'slots': instance.slots.map((e) => e.toJson()).toList(),
    };

DoctorActionsModel _$DoctorActionsModelFromJson(Map<String, dynamic> json) =>
    DoctorActionsModel(
      message: json['message'] as bool? ?? false,
      call: json['call'] as bool? ?? false,
      videoCall: json['videoCall'] as bool? ?? false,
    );

Map<String, dynamic> _$DoctorActionsModelToJson(DoctorActionsModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'call': instance.call,
      'videoCall': instance.videoCall,
    };

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
  label: json['label'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  formatted: json['formatted'] as String,
);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amount': instance.amount,
      'currency': instance.currency,
      'formatted': instance.formatted,
    };

DetailsModel _$DetailsModelFromJson(Map<String, dynamic> json) => DetailsModel(
  title: json['title'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$DetailsModelToJson(DetailsModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };

BookActionModel _$BookActionModelFromJson(Map<String, dynamic> json) =>
    BookActionModel(
      label: json['label'] as String,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$BookActionModelToJson(BookActionModel instance) =>
    <String, dynamic>{'label': instance.label, 'enabled': instance.enabled};
