import 'package:security_app/Data/Models/security_staff_model.dart';

import 'active_shift_model.dart';

class GuardShiftGateModelGateModel {
  final int id;
  final String name;
  final String code;
  final int buildingId;
  final String buildingName;
  final String buildingCode;
  final List<SecurityStaffModel> securityStaff;
  final List<ActiveShiftModel> activeShifts;

  GuardShiftGateModelGateModel({
    required this.id,
    required this.name,
    required this.code,
    required this.buildingId,
    required this.buildingName,
    required this.buildingCode,
    required this.securityStaff,
    required this.activeShifts,
  });

  factory GuardShiftGateModelGateModel.fromJson(Map<String, dynamic> json) {
    return GuardShiftGateModelGateModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      buildingId: json['building_id'] ?? 0,
      buildingName: json['building_name'] ?? '',
      buildingCode: json['building_code'] ?? '',
      securityStaff: json['security_staff'] != null
          ? (json['security_staff'] as List)
          .map((e) => SecurityStaffModel.fromJson(e))
          .toList()
          : [],
      activeShifts: json['active_shifts'] != null
          ? (json['active_shifts'] as List)
          .map((e) => ActiveShiftModel.fromJson(e))
          .toList()
          : [],
    );
  }
}