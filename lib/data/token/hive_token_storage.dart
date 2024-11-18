import 'package:hive/hive.dart';
import '../services/interface/token_storage.dart';


class HiveTokenStorage implements TokenStorage {
  final String _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
  var box = await Hive.openBox('myBox'); // Ouvre la boîte Hive
  await box.put('auth_token', token); // Sauvegarde le token avec la clé 'auth_token'
  // print("Token sauvegardé : $token"); // Affiche le token pour confirmation
}


  @override
  Future<String?> getToken() async {
  var box = await Hive.openBox('myBox'); // Ouvre la boîte Hive
  final token = box.get('auth_token'); // Récupère le token avec la clé 'auth_token'

  // if (token != null) {
  //   print("Token récupéré depuis Hive : $token");
  // } else {
  //   print("Aucun token trouvé dans la boîte Hive.");
  // }

  return token; // Retourne le token ou null
}

}
