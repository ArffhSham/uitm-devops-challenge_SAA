import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rentverse_mobile/features/auth/logic/auth_provider.dart';
//import '../logic/auth_provider.dart';

// Provider for SecurityAlertService (optional)
final securityAlertServiceProvider = Provider<SecurityAlertService>((ref) {
  final authState = ref.watch(authProvider);
  return SecurityAlertService(authState.jwtToken);
});

class SecurityAlertService {
  final String? jwtToken;

  SecurityAlertService(this.jwtToken);

  Future<List<dynamic>> fetchAlerts() async {
    if (jwtToken == null) {
      throw Exception('No valid JWT token');
    }

    final res = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/security-alerts'),
      headers: {
        'Authorization': 'Bearer $jwtToken', // Use dynamic JWT
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load alerts');
    }

    final body = jsonDecode(res.body);
    return body['data'] as List<dynamic>;
  }
}
