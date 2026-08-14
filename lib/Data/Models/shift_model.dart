import 'guard_shift_gate_model.dart';

class ShiftModel {
  final int id;
  final String name;
  final GuardShiftGateModelGateModel? gate;
  final String date;
  final String startDatetime;
  final String endDatetime;
  final String state;
  final String note;

  ShiftModel({
    required this.id,
    required this.name,
    this.gate,
    required this.date,
    required this.startDatetime,
    required this.endDatetime,
    required this.state,
    required this.note,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      gate: json['gate'] != null ? GuardShiftGateModelGateModel.fromJson(json['gate']) : null,
      date: json['date'] ?? '',
      startDatetime: json['start_datetime'] ?? '',
      endDatetime: json['end_datetime'] ?? '',
      state: json['state'] ?? '',
      note: json['note'] ?? '',
    );
  }
}