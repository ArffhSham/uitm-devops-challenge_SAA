import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import 'auth_models.dart';

class AuthApi {
  
  /// Helper to extract server error message or provide a fallback
  String _extractErrorMessage(http.Response response, String defaultMessage) {
    try {
      final errorData = jsonDecode(response.body);
      // Attempt to find a 'message' or 'error' key from the backend
      return errorData['message'] ?? errorData['error'] ?? defaultMessage;
    } catch (_) {
      // If the body is not valid JSON, use the status code fallback
      return defaultMessage;
    }
  }

  /// Login
  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final message = _extractErrorMessage(response, 'Login failed: Status ${response.statusCode}');
      throw Exception(message);
    }
  }

  /// Send OTP
  Future<bool> sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse(ApiConfig.sendOtp),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final message = _extractErrorMessage(response, 'Sending OTP failed: Status ${response.statusCode}');
      throw Exception(message);
    }
  }

  /// Verify OTP using tempToken in Authorization header
  Future<VerifyOtpResponse> verifyOtp(String tempToken, String otp) async {
    final response = await http.post(
      Uri.parse(ApiConfig.verifyOtp),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tempToken',
      },
      body: jsonEncode({'otp': otp}),
    );

    if (response.statusCode == 200) {
      return VerifyOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      final message = _extractErrorMessage(response, 'OTP verification failed: Status ${response.statusCode}');
      throw Exception(message);
    }
  }
}