import 'auth_api.dart';
import 'auth_models.dart';
import '../../../core/security/token_storage.dart';

class AuthRepository {
  final AuthApi api = AuthApi();

  /// Login returns tempToken for OTP
  Future<String> login(String email, String password) async {
    final LoginResponse response = await api.login(email, password);
    return response.tempToken;
  }

  /// Send OTP
  Future<bool> sendOtp(String phone) async {
    return await api.sendOtp(phone);
  }

  /// Verify OTP
  /// Saves JWT locally and returns user role
  Future<String> verifyOtp(String tempToken, String otp) async {
    final VerifyOtpResponse response = await api.verifyOtp(tempToken, otp);

    // Save JWT here
    await TokenStorage.saveAccessToken(response.accessToken);
    await TokenStorage.saveRefreshToken(response.refreshToken);

    // Role is inside JWT payload or returned by backend
    return response.role;
  }

  /// Logout
  Future<void> logout() async {
    await TokenStorage.clearTokens();
  }
}
