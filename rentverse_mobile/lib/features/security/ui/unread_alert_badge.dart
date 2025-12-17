import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/auth/logic/auth_provider.dart';
//import '../logic/auth_provider.dart';
import '../data/security_alert_service.dart';
import 'anomaly_list_screen.dart';

class UnreadAlertBadge extends ConsumerStatefulWidget {
  const UnreadAlertBadge({super.key});

  @override
  ConsumerState<UnreadAlertBadge> createState() => _UnreadAlertBadgeState();
}

class _UnreadAlertBadgeState extends ConsumerState<UnreadAlertBadge> {
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    // Get JWT from AuthProvider
    final jwtToken = ref.read(authProvider).jwtToken;

    // Create service instance with JWT
    final service = SecurityAlertService(jwtToken);

    final alerts = await service.fetchAlerts();

    final count = alerts.where((a) => a['isRead'] != true).length;

    setState(() => unreadCount = count);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_active),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AnomalyListScreen(),
              ),
            );

            // Refresh count after returning
            _loadUnreadCount();
          },
        ),
        if (unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.red,
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
