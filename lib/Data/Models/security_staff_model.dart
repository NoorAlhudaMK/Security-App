class SecurityStaffModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool active;

  SecurityStaffModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.active,
  });

  factory SecurityStaffModel.fromJson(Map<String, dynamic> json) {
    return SecurityStaffModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
