// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/interface/token_storage.dart';
// class SharedPreferencesTokenStorage implements TokenStorage {
//   final String _tokenKey = 'auth_token';

//   @override
//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenKey, token);
//   }

//   @override
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenKey);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';
import '../services/interface/token_storage.dart';

class SharedPreferencesTokenStorage implements TokenStorage {
  final String _tokenKey = 'token';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    // Nettoyer le token avant de le sauvegarder
    final cleanToken = token.replaceAll('Bearer ', '').trim();
    await prefs.setString(_tokenKey, cleanToken);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null) return null;
    
    // Nettoyage du token
    final cleanToken = token.trim(); // Enlever les espaces
    return cleanToken;
  }

  void main() async {
  final tokenStorage = SharedPreferencesTokenStorage();

  // Sauvegarder un token
  await tokenStorage.saveToken("mon_token_securise");

  // Récupérer le token après enregistrement
  final token = await tokenStorage.getToken();
  // print("Token utilisé dans l'application : $token");
}

}
