import 'package:shared_preferences/shared_preferences.dart';
import '../services/interface/token_storage.dart';
class SharedPreferencesTokenStorage implements TokenStorage {
  final String _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
