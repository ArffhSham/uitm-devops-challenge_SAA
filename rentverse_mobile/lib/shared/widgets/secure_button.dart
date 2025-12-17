// lib/shared/widgets/secure_button.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/user_role.dart';
import '../../services/user_provider.dart';

class SecureButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final List<UserRole> requiredRoles;
  final bool isEnabled;

  const SecureButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.requiredRoles,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserProvider>(context).currentRole;
    final hasPermission = requiredRoles.contains(userRole);
    final buttonEnabled = hasPermission && isEnabled;

    return ElevatedButton(
      onPressed: buttonEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: hasPermission ? Colors.blue : Colors.grey,
        minimumSize: const Size.fromHeight(50),
      ),
      child: Text(
        hasPermission
            ? label
            : 'Action Reserved for ${requiredRoles.map((r) => r.name).join(' or ')}',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}