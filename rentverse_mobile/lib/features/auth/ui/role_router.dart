import 'package:flutter/material.dart';

// Example separate dashboard pages
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: const Center(child: Text('Welcome, Admin!')),
    );
  }
}

class LandlordDashboard extends StatelessWidget {
  const LandlordDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Landlord Dashboard')),
      body: const Center(child: Text('Welcome, Landlord!')),
    );
  }
}

class TenantDashboard extends StatelessWidget {
  const TenantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tenant Dashboard')),
      body: const Center(child: Text('Welcome, Tenant!')),
    );
  }
}

// Role router
class RoleRouter extends StatelessWidget {
  final String role;

  const RoleRouter({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // Navigate to the correct dashboard after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (role == 'admin') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()));
      } else if (role == 'landlord') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LandlordDashboard()));
      } else if (role == 'tenant') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TenantDashboard()));
      } else {
        // Unknown role
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unknown role!')));
      }
    });

    // Show a temporary loading screen while navigation happens
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
