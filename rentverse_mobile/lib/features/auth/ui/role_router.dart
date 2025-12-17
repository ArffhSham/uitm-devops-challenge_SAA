import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/auth_provider.dart';
import '../../security/ui/admin_dashboard.dart';
//import 'dashboards/landlord_dashboard.dart';
//import 'dashboards/tenant_dashboard.dart';

class RoleRouter extends ConsumerStatefulWidget {
  const RoleRouter({super.key});

  @override
  ConsumerState<RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends ConsumerState<RoleRouter> {
  String? role;

  @override
  void initState() {
    super.initState();
    _loadRoleFromProvider();
  }

  void _loadRoleFromProvider() {
    final authState = ref.read(authProvider);
    setState(() {
      role = authState.role; // role is set after OTP verification
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    switch (role) {
      case 'ADMIN':
        return const AdminDashboard();
      case 'OWNER':
        return const AdminDashboard();
      case 'TENANT':
        return const AdminDashboard();
      default:
        return const Scaffold(
          body: Center(child: Text('Unknown role!')),
        );
    }
  }
}
