import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';
import '../config/api_config.dart';

class SessionManager {
  static Future<bool> refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse(ApiConfig.refreshToken),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await TokenStorage.saveAccessToken(data['access_token']);
      return true;
    } else {
      await TokenStorage.clearTokens();
      return false;
    }
  }

  static Future<void> logout() async {
    await TokenStorage.clearTokens();
    // Optionally call backend logout
    await http.post(Uri.parse(ApiConfig.logout));
  }
}
