abstract class AddVisitorEvent {}

class NextStepEvent extends AddVisitorEvent {}

class PreviousStepEvent extends AddVisitorEvent {}

class CreateVisitor extends AddVisitorEvent {
  final String name;
  final String phone;
  final int unitId;
  final String validFrom;
  final String validTo;
  final bool hasCar;
  final String carPlate;
  final String nationalId;
  final String companionsCount;
  final String reason;

  CreateVisitor({
    required this.name,
    required this.phone,
    required this.unitId,
    required this.validFrom,
    required this.validTo,
    required this.hasCar,
    required this.carPlate,
    required this.nationalId,
    required this.companionsCount,
    required this.reason,
  });
}

class UpdateHasCar extends AddVisitorEvent {
  final bool value;
  UpdateHasCar(this.value);
}

class UpdateDate extends AddVisitorEvent {
  final DateTime date;
  UpdateDate(this.date);
}

class UpdateIsTimeSelected extends AddVisitorEvent {
  final bool isSelected;
  UpdateIsTimeSelected(this.isSelected);
}

class SearchResidentEvent extends AddVisitorEvent {
  final String query;
  final String token;
  SearchResidentEvent(this.query, this.token);
}

class SelectResidentEvent extends AddVisitorEvent {
  final int residentId;
  final String residentName;
  final int unitId;

  SelectResidentEvent({
    required this.residentId,
    required this.residentName,
    required this.unitId,
  });
}