import 'auth_api.dart';

class AuthRepository {
  final AuthApi _api = AuthApi();

  Future<String> login(String email, String password) async {
    final response = await _api.login(email, password);
    return response.tempToken;
  }

  Future<void> sendOtp(String phone) async {
    await _api.sendOtp(phone);
  }

  Future<String> verifyOtp(String tempToken, String otp) async {
    final response = await _api.verifyOtp(tempToken, otp);
    return response.role;
  }

  Future<void> logout() async {
    // nothing to do yet
  }
}
