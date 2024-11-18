import 'dart:convert';

class JwtDecoder {
  static Map<String, dynamic> decode(String token) {
    // Enlever 'Bearer ' si présent
    final jwt = token.replaceFirst('Bearer ', '');
    
    // Séparer le token en ses parties
    final parts = jwt.split('.');
    if (parts.length != 3) {
      throw Exception('Token JWT invalide');
    }

    // Decoder la partie payload (deuxième partie)
    String payload = parts[1];
    // Ajouter le padding si nécessaire
    while (payload.length % 4 != 0) {
      payload += '=';
    }
    
    // Décoder le payload
    final normalized = base64Url.normalize(payload);
    final resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);

    return payloadMap;
  }

  static int? getUserIdFromToken(String token) {
    try {
      final payload = decode(token);
      // Dans un token Passport Laravel, l'ID utilisateur est dans 'sub'
      return int.parse(payload['sub'].toString());
    } catch (e) {
      print('Erreur lors du décodage du token: $e');
      return null;
    }
  }
}