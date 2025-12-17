import 'dart:convert';
import 'package:http/http.dart' as http;

/// =====================
/// AUTH API
/// =====================
class AuthApi {
  final String baseUrl = 'https://api/rentverse.com'; 

  /// Login API call
  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  /// Send OTP API call
  Future<bool> sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Send OTP failed: ${response.body}');
    }
  }

  /// Verify OTP API call
  Future<VerifyOtpResponse> verifyOtp(String tempToken, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tempToken',
      },
      body: jsonEncode({'otp': otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return VerifyOtpResponse.fromJson(data);
    } else {
      throw Exception('Verify OTP failed: ${response.body}');
    }
  }
}

/// =====================
/// LOGIN RESPONSE
/// =====================
class LoginResponse {
  final bool mfaRequired;
  final String tempToken;

  LoginResponse({required this.mfaRequired, required this.tempToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      mfaRequired: json['mfa_required'] ?? false,
      tempToken: json['temp_token'] ?? '',
    );
  }
}

/// =====================
/// VERIFY OTP RESPONSE
/// =====================
class VerifyOtpResponse {
  final String accessToken;
  final String refreshToken;
  final String role;

  VerifyOtpResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      role: json['role'],
    );
  }
}
