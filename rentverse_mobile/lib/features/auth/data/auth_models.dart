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