import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../data/auth_repository.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Secure storage for JWT token
final _secureStorage = FlutterSecureStorage();

class AuthState {
  final bool isLoading;
  final String? role;
  final String? error;
  final String? phone;
  final String? jwtToken;

  AuthState({
    this.isLoading = false,
    this.role,
    this.error,
    this.phone,
    this.jwtToken,
  });

  AuthState copyWith({
    bool? isLoading,
    String? role,
    String? error,
    String? phone,
    String? jwtToken,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      role: role ?? this.role,
      error: error ?? this.error,
      phone: phone ?? this.phone,
      jwtToken: jwtToken ?? this.jwtToken,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository = AuthRepository();

  AuthNotifier() : super(AuthState());

  void setPhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  // -------------------------
  // REQUEST OTP
  // -------------------------
  Future<void> requestOtp() async {
    if (state.phone == null) {
      state = state.copyWith(error: 'Phone number required');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.sendOtp(state.phone!);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // -------------------------
  // VERIFY OTP
  // -------------------------
  Future<void> verifyOtp(String otp) async {
    if (state.phone == null) {
      state = state.copyWith(error: 'Phone number required');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Backend verifies OTP and returns JWT
      final jwtToken = await _repository.verifyOtp(state.phone!, otp);

      // Decode JWT to get role
      final decoded = JwtDecoder.decode(jwtToken);
      final role = decoded['role'] as String?;

      // Store JWT securely
      await _secureStorage.write(key: 'jwt_token', value: jwtToken);

      state = state.copyWith(
        isLoading: false,
        role: role,
        jwtToken: jwtToken,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // -------------------------
  // LOGOUT
  // -------------------------
  Future<void> logout() async {
    await _repository.logout();
    await _secureStorage.delete(key: 'jwt_token');
    state = AuthState();
  }

  // -------------------------
  // GET JWT FROM STORAGE
  // -------------------------
  Future<void> loadJwt() async {
    final jwtToken = await _secureStorage.read(key: 'jwt_token');
    if (jwtToken != null) {
      final decoded = JwtDecoder.decode(jwtToken);
      final role = decoded['role'] as String?;
      state = state.copyWith(jwtToken: jwtToken, role: role);
    }
  }
}
