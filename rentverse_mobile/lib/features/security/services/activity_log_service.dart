import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_log.dart';

class ActivityLogService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/logs';
  // ⬆ Android emulator uses 10.0.2.2 instead of localhost

  static Future<List<ActivityLog>> fetchLogs(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List logs = body['data'];

      return logs.map((e) => ActivityLog.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load activity logs');
    }
  }
}