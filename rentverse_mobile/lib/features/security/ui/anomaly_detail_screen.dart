import 'package:flutter/material.dart';

class AnomalyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> alert;

  const AnomalyDetailScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anomaly Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Type', alert['type']),
                _row('Severity', alert['severity']),
                _row('Message', alert['message']),
                _row(
                  'Created At',
                  DateTime.parse(alert['createdAt'])
                      .toLocal()
                      .toString(),
                ),
                const SizedBox(height: 12),

                if (alert['metadata'] != null)
                  _row('Metadata', alert['metadata'].toString()),

                if (alert['user'] != null) ...[
                  const Divider(),
                  const Text(
                    'User Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _row('User Email', alert['user']['email']),
                  _row('Role', alert['user']['role']),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value ?? '-'),
          ),
        ],
      ),
    );
  }
}