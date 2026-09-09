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

  Future<RegisterResult> sendOtp({
    required String email,
    String purpose = 'CUSTOMER_REGISTRATION',
    String? otpFor,
    String? mobile,
  }) async {
    return await _service.sendOtp(
      email: email,
      purpose: purpose,
      otpFor: otpFor,
      mobile: mobile,
    );
  }

  Future<RegisterResult> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _service.verifyOtp(email: email, otp: otp);
  }

  Future<RegisterResult> registerCustomer({
    required String fullName,
    required String email,
    required String password,
    String? emailOtp,
    String? phone,
  }) async {
    final result = await _service.registerCustomer(
      fullName: fullName,
      email: email,
      password: password,
      emailOtp: emailOtp,
      phone: phone,
    );
    if (result.success) {
      _loggedIn = true;
      this.email = email;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, true);
      notifyListeners();
    }
    return result;
  }

  Future<RegisterResult> forgotPassword({required String email}) async {
    return await _service.forgotPassword(email: email);
  }

  Future<RegisterResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return await _service.resetPassword(token: token, newPassword: newPassword);
  }

  Future<void> logout() async {
    _loggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    await _service.logout();
    notifyListeners();
  }
}
