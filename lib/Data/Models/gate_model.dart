import 'package:security_app/Data/Models/active_shift_model.dart';

class GateModel {
  final int id;
  final String name;
  final String code;
  final List<ActiveShiftModel> activeShifts;

  GateModel({required this.id, required this.name, required this.code, required this.activeShifts});

  factory GateModel.fromJson(Map<String, dynamic> json) => GateModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    code: json['code'] ?? '',
    activeShifts: (json['active_shifts'] as List? ?? []).map((i) => ActiveShiftModel.fromJson(i)).toList(),
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'code': code, 'active_shifts': activeShifts.map((e) => e.toJson()).toList()};
}