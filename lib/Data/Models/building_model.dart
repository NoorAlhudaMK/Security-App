class BuildingModel {
  final int id;
  final String name;
  final String code;
  final String address;
  final double latitude;
  final double longitude;

  BuildingModel({required this.id, required this.name, required this.code, required this.address, required this.latitude, required this.longitude});

  factory BuildingModel.fromJson(Map<String, dynamic> json) => BuildingModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    code: json['code'] ?? '',
    address: json['address'] ?? '',
    latitude: (json['latitude'] ?? 0.0).toDouble(),
    longitude: (json['longitude'] ?? 0.0).toDouble(),
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'code': code, 'address': address, 'latitude': latitude, 'longitude': longitude};
}