class ResidentModel {
  final int id;
  final String name;
  final String phone;
  final String unitName;
  final String unitID;
  final String carPlate;
  final String residentType;
  final List<dynamic> vehicles;
  final List<dynamic> familyMembers;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  ResidentModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.unitName,
    required this.unitID,
    required this.carPlate,
    required this.residentType,
    required this.vehicles,
    required this.familyMembers,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  factory ResidentModel.fromJson(Map<String, dynamic> json) {
    String unitName = 'شقة غير معرّفة';
    if (json['primary_unit'] != null && json['primary_unit']['name'] != null) {
      unitName = json['primary_unit']['name'];
    } else {
      final units = json['units'] as List<dynamic>?;
      if (units != null && units.isNotEmpty) {
        unitName = units.first['name'] ?? 'شقة غير معرّفة';
      }
    }

    String carInfo = 'لا توجد سيارة';
    final vehiclesList = json['vehicles'] as List<dynamic>?;
    if (vehiclesList != null && vehiclesList.isNotEmpty) {
      carInfo = vehiclesList.first['plate_number'] ?? 'لا توجد سيارة';
    }

    String unitID = "0";
    if (json['primary_unit'] != null && json['primary_unit']['id'] != null) {
      unitID = json['primary_unit']['id'].toString();
    } else {
      final units = json['units'] as List<dynamic>?;
      if (units != null && units.isNotEmpty) {
        unitID = (units.first['id'] ?? 0).toString();
      }
    }

    return ResidentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'بدون اسم',
      phone: json['phone'] ?? '',
      unitName: unitName,
      unitID: unitID,
      carPlate: carInfo,
      residentType: json['resident_type'] ?? 'resident',
      vehicles: json['vehicles'] ?? [],
      familyMembers: json['family_members'] ?? [],
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactPhone: json['emergency_contact_phone'],
    );
  }

  String get tag => (residentType == 'owner') ? 'مالك' : 'ساكن';
}