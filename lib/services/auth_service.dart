class AuthService {
  static const _validEmail = 'user@gmail.com';
  static const _validPassword = 'admin@123';

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return email == _validEmail && password == _validPassword;
  }

  Future<void> logout() async {
    // No‑op for the dev stub
  }
}
