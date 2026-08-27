class VisitorModel {
  final String id;
  final String? name;
  final String visitorName;
  final String visitorPhone;
  final String? visitorCount;
  final String visitType;
  final String? reason;
  final String residentId;
  final String? residentName;
  final String? unitId;
  final String? unitName;
  final String? buildingId;
  final String? buildingName;
  final String? gateId;
  final String? gateName;
  final String validFrom;
  final String validTo;
  final String? visitDatetime;
  final bool hasCar;
  final String? carPlate;
  final String qrToken;
  final String status;
  final String? checkedInAt;
  final String? checkedOutAt;

  VisitorModel({
    required this.id,
    this.name,
    required this.visitorName,
    required this.visitorPhone,
    this.visitorCount,
    required this.visitType,
    this.reason,
    required this.residentId,
    this.residentName,
    this.unitId,
    this.unitName,
    this.buildingId,
    this.buildingName,
    this.gateId,
    this.gateName,
    required this.validFrom,
    required this.validTo,
    this.visitDatetime,
    required this.hasCar,
    this.carPlate,
    required this.qrToken,
    required this.status,
    this.checkedInAt,
    this.checkedOutAt,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'].toString(),
      name: json['name']?.toString(),
      visitorName: json['visitor_name'].toString(),
      visitorPhone: json['visitor_phone'].toString(),
      visitorCount: json['visitor_count']?.toString(),
      visitType: json['visit_type'].toString(),
      reason: json['reason']?.toString(),
      residentId: json['resident_id'].toString(),
      residentName: json['resident_name']?.toString(),
      unitId: json['unit_id']?.toString(),
      unitName: json['unit_name']?.toString(),
      buildingId: json['building_id']?.toString(),
      buildingName: json['building_name']?.toString(),
      gateId: json['gate_id']?.toString(),
      gateName: json['gate_name']?.toString(),
      validFrom: json['valid_from'].toString(),
      validTo: json['valid_to'].toString(),
      visitDatetime: json['visit_datetime']?.toString(),
      hasCar: json['has_car'] ?? false,
      carPlate: json['car_plate']?.toString(),
      qrToken: json['qr_token'].toString(),
      status: json['status'].toString(),
      checkedInAt: json['checked_in_at']?.toString(),
      checkedOutAt: json['checked_out_at']?.toString(),
    );
  }
}