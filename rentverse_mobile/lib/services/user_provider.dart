// lib/services/user_provider.dart

import 'package:flutter/foundation.dart';
import '../enums/user_role.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User get currentUser => _currentUser!;
  bool get isAuthenticated => _currentUser != null;
  UserRole get currentRole => _currentUser?.role ?? UserRole.Guest;

  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}