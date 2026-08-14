import 'profile_model.dart';
import 'unit_model.dart';
import 'building_model.dart';
import 'gate_model.dart';

class UserModel {
  final int id;
  final String name;
  final String login;
  final String email;
  final String phone;
  final String mobile;
  final String role;
  final String timezone;
  final List<String>? allowedApps;
  final List<UnitModel>? units;
  final List<ProfileModel> residentProfiles;
  final List<GateModel> assignedGates;
  final List<dynamic> maintenanceTeams;
  final List<BuildingModel> buildings;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.login,
    required this.email,
    required this.phone,
    required this.mobile,
    required this.role,
    required this.timezone,
    required this.allowedApps,
    required this.units,
    required this.residentProfiles,
    required this.assignedGates,
    required this.maintenanceTeams,
    required this.buildings,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      login: json['login'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      mobile: json['mobile'] ?? '',
      role: json['role'] ?? 'user',
      timezone: json['timezone'] ?? '',

      allowedApps: json['allowed_apps'] != null
          ? List<String>.from(json['allowed_apps'])
          : [],

      units: json['units'] != null
          ? (json['units'] as List).map((i) => UnitModel.fromJson(i)).toList()
          : [],

      residentProfiles: json['resident_profiles'] != null
          ? (json['resident_profiles'] as List)
          .map((i) => ProfileModel.fromJson(i))
          .toList()
          : [],

      assignedGates: json['assigned_gates'] != null
          ? (json['assigned_gates'] as List)
          .map((i) => GateModel.fromJson(i))
          .toList()
          : [],

      maintenanceTeams: json['maintenance_teams'] != null
          ? List<dynamic>.from(json['maintenance_teams'])
          : [],

      buildings: json['buildings'] != null
          ? (json['buildings'] as List)
          .map((i) => BuildingModel.fromJson(i))
          .toList()
          : [],

      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'login': login,
      'email': email,
      'phone': phone,
      'mobile': mobile,
      'role': role,
      'timezone': timezone,
      'allowed_apps': allowedApps,
      'units': units != null ? units!.map((unit) => unit.toJson()).toList() : [],
      'resident_profiles': residentProfiles
          .map((profile) => profile.toJson())
          .toList(),
      'assigned_gates': assignedGates.map((gate) => gate.toJson()).toList(),
      'maintenance_teams': maintenanceTeams,
      'buildings': buildings.map((building) => building.toJson()).toList(),
      'token': token,
    };
  }
}