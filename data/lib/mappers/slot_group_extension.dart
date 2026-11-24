import 'package:data/models/appointment_details_model.dart';
import 'package:domain/entities/appointment_details.dart';

// Mapper (stratul Data): Model (formatul serverului) -> Entitate (formatul aplicației).
extension SlotGroupExtension on SlotGroupModel {
  // Din lista "slots" păstrează textele și indexul celui cu "selected": true.
  SlotGroup get toEntity => SlotGroup(
    title: title,
    showAll: showAll,
    labels: [for (final s in slots) s.label],
    selectedIndex: slots.indexWhere((s) => s.selected),
  );
}
