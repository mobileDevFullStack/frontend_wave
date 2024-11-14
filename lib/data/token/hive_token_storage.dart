import 'package:hive/hive.dart';
import '../services/interface/token_storage.dart';


class HiveTokenStorage implements TokenStorage {
  final String _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    var box = await Hive.openBox('authBox');
    await box.put(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    var box = await Hive.openBox('authBox');
    return box.get(_tokenKey);
  }
}
