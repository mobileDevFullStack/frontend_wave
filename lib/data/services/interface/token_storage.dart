abstract class TokenStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();
}
