class ActiveShiftModel {
  final int id;
  final int guardId;
  final String guardName;
  final String startDatetime;
  final String endDatetime;

  ActiveShiftModel({
    required this.id,
    required this.guardId,
    required this.guardName,
    required this.startDatetime,
    required this.endDatetime,
  });

  factory ActiveShiftModel.fromJson(Map<String, dynamic> json) {
    return ActiveShiftModel(
      id: json['id'] ?? 0,
      guardId: json['guard_id'] ?? 0,
      guardName: json['guard_name'] ?? '',
      startDatetime: json['start_datetime'] ?? '',
      endDatetime: json['end_datetime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'guard_id': guardId,
    'guard_name': guardName,
    'start_datetime': startDatetime,
    'end_datetime': endDatetime,
  };
}