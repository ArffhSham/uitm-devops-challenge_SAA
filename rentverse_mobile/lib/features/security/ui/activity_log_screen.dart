import 'package:flutter/material.dart';
import '../models/activity_log.dart';
import '../services/activity_log_service.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  late Future<List<ActivityLog>> _futureLogs;

  @override
  void initState() {
    super.initState();

    // 🔐 TEMP: use admin token (later from secure storage)
    const adminToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkY2M4YmM5Ny02MmI0LTQ3Y2ItOWNhNy01OTMwM2I4OTZiOTIiLCJlbWFpbCI6ImFkbWluQHJlbnR2ZXJzZS5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NjU3NjE4MzksImV4cCI6MTc2NjM2NjYzOX0.jzna0cYaXX0PRdu4Qj3D7XYFT3QZwasArbzU3DrTNjc';

    _futureLogs = ActivityLogService.fetchLogs(adminToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Logs')),
      body: FutureBuilder<List<ActivityLog>>(
        future: _futureLogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final logs = snapshot.data!;

          if (logs.isEmpty) {
            return const Center(child: Text('No activity logs found'));
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              final isFailed = log.status == 'FAILED';

              return Card(
                child: ListTile(
                  leading: Icon(
                    isFailed ? Icons.warning : Icons.check_circle,
                    color: isFailed ? Colors.red : Colors.green,
                  ),
                  title: Text(log.action),
                  subtitle: Text(log.createdAt.toLocal().toString()),
                  trailing: Text(
                    log.status,
                    style: TextStyle(
                      color: isFailed ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}