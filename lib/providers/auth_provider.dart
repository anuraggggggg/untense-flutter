import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  static const _prefsKey = 'auth_logged_in';
  final AuthService _service = AuthService();
  bool _loggedIn = false;
  bool get isLoggedIn => _loggedIn;

  // Development credentials storage
  String email = '';
  String password = '';

  AuthProvider();

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.getBool(_prefsKey) ?? false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _service.login(email, password);
    if (success) {
      _loggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, true);
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    _loggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    await _service.logout();
    notifyListeners();
  }
}
