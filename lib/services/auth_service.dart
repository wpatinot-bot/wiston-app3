import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';

  // Credenciales por defecto
  static const String _defaultUser = 'admin';
  static const String _defaultPassword = 'admin123';

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Verificar si hay usuario registrado
    final savedUser = prefs.getString(_keyUsername) ?? _defaultUser;
    final savedPassword = prefs.getString(_keyPassword) ?? _defaultPassword;

    if (username == savedUser && password == savedPassword) {
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUsername, username);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  Future<void> saveProfile(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
  }
}
