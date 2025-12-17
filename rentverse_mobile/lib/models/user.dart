// lib/models/user.dart
import '../enums/user_role.dart';

class User {
  final String id;
  final String name;
  final UserRole role;

  User({required this.id, required this.name, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    // Assuming the API returns the role as a string (e.g., "Tenant", "Owner")
    UserRole role = UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == (json['role'] as String).toLowerCase(),
      orElse: () => UserRole.Guest,
    );
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      role: role,
    );
  }

  // Used for testing/simulating successful login before OTP verification
  static User mockTenant() {
    return User(id: 'T-001', name: 'Tenant Sarah', role: UserRole.Tenant);
  }

  static User mockOwner() {
    return User(id: 'O-001', name: 'Owner John', role: UserRole.Owner);
  }

  static User mockAdmin() {
    return User(id: 'A-001', name: 'Admin Jane', role: UserRole.Admin);
  }
}