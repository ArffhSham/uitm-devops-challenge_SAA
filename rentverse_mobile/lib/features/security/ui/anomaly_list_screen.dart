import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/auth/logic/auth_provider.dart';
//import '../logic/auth_provider.dart';
import '../data/security_alert_service.dart';
import 'anomaly_detail_screen.dart';

class AnomalyListScreen extends ConsumerStatefulWidget {
  const AnomalyListScreen({super.key});

  @override
  ConsumerState<AnomalyListScreen> createState() => _AnomalyListScreenState();
}

class _AnomalyListScreenState extends ConsumerState<AnomalyListScreen> {
  late Future<List<dynamic>> alerts;

  @override
  void initState() {
    super.initState();

    // Use ref.read in initState to get JWT from AuthProvider
    final jwtToken = ref.read(authProvider).jwtToken;
    final service = SecurityAlertService(jwtToken);

    alerts = service.fetchAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Alerts')),
      body: FutureBuilder(
        future: alerts,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text('No alerts found'));
          }

          final list = snapshot.data as List;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final a = list[i];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(a['message']),
                  subtitle: Text(
                    DateTime.parse(a['createdAt']).toLocal().toString(),
                  ),
                  trailing: Text(
                    a['severity'],
                    style: TextStyle(
                      color: a['severity'] == 'HIGH' ? Colors.red : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnomalyDetailScreen(alert: a),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
