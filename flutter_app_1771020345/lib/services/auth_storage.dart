import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _keyToken = 'jwt_token';
  static const _keyRole = 'user_role';
  static const _keyUserId = 'user_id';
  static const _keyEmail = 'user_email';
  static const _keyFullName = 'user_fullname';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> saveUserInfo({
    required String role,
    required int userId,
    required String email,
    required String fullName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyFullName, fullName);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFullName);
  }

  static Future<bool> isAdmin() async {
    final role = await getRole();
    return role?.toLowerCase() == 'admin';
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyFullName);
  }
}
