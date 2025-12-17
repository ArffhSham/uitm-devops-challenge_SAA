class ApiConfig {
  static const String baseUrl = "http://192.168.0.121:3000"; // Your main backend
  static const String login = "$baseUrl/api/auth/login";
  static const String verifyOtp = "$baseUrl/api/auth/verifyotp";
  static const String refreshToken = "$baseUrl/api/auth/refresh";
  static const String logout = "$baseUrl/api/auth/logout";

  // Add this for Twilio OTP backend
  static const String sendOtp = "http://192.168.0.121:5000/send-otp"; // Python app.py server
}
