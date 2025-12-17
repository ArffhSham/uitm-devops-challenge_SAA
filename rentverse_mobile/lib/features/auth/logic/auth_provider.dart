import 'package:flutter_riverpod/legacy.dart';
import '../data/auth_repository.dart';

/// =====================
/// PROVIDER
/// =====================
final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// =====================
/// 🔴 DEV / PROTOTYPE FLAG
/// =====================
const bool isDevMode = true;

/// =====================
/// AUTH STATE
/// =====================
class AuthState {
  final bool isLoading;
  final String? role;
  final String? error;
  final String? phone;
  final String? tempToken;

  AuthState({
    this.isLoading = false,
    this.role,
    this.error,
    this.phone,
    this.tempToken,
  });

  AuthState copyWith({
    bool? isLoading,
    String? role,
    String? error,
    String? phone,
    String? tempToken,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      role: role ?? this.role,
      error: error,
      phone: phone ?? this.phone,
      tempToken: tempToken ?? this.tempToken,
    );
  }
}

/// =====================
/// AUTH NOTIFIER
/// =====================
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository = AuthRepository();

  AuthNotifier() : super(AuthState());

  /// =====================
  /// SET PHONE
  /// =====================
  void setPhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  /// =====================
  /// LOGIN
  /// =====================
  Future<void> login(String email, String password) async {
    if (isDevMode) {
      state = state.copyWith(isLoading: true, error: null);
      await Future.delayed(const Duration(seconds: 1));

      // Dev role simulation
      String role = 'tenant';
      if (email.toLowerCase().contains('admin')) role = 'admin';
      if (email.toLowerCase().contains('owner')) role = 'owner';

      state = state.copyWith(
        isLoading: false,
        role: role,
        tempToken: 'DEV_TEMP_TOKEN',
      );
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      final tempToken = await _repository.login(email, password);
      state = state.copyWith(isLoading: false, tempToken: tempToken);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// =====================
  /// REQUEST OTP
  /// =====================
  Future<void> requestOtp() async {
    if (state.phone == null) {
      state = state.copyWith(error: 'Phone number required');
      return;
    }

    if (isDevMode) {
      state = state.copyWith(isLoading: true, error: null);
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false);
      return;
    }

    if (state.tempToken == null) {
      state = state.copyWith(error: 'No login session');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.sendOtp(state.phone!);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// =====================
  /// VERIFY OTP
  /// JWT is saved inside repository only
  /// =====================
  Future<void> verifyOtp(String otp) async {
    if (isDevMode) {
      state = state.copyWith(isLoading: true, error: null);
      await Future.delayed(const Duration(seconds: 1));

      if (otp != '123456') {
        state = state.copyWith(isLoading: false, error: 'Invalid OTP (use 123456)');
        return;
      }

      // Role is already set from login
      state = state.copyWith(isLoading: false, tempToken: null);
      return;
    }

    if (state.tempToken == null) {
      state = state.copyWith(error: 'No valid session');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      // Repository handles JWT storage and returns role
      final role = await _repository.verifyOtp(state.tempToken!, otp);

      state = state.copyWith(isLoading: false, role: role, tempToken: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// =====================
  /// LOGOUT
  /// =====================
  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}
