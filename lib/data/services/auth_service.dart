
// import '../../core/constants/api_constants.dart';
// import 'interface/api_service.dart';
// import 'api_factory.dart';
// import 'interface/token_storage.dart';
// import '../token/storage_factory.dart';

// class AuthService {
//   final IApiService _apiService = createApiService(BASE_API_URL);
//   final TokenStorage _tokenStorage = createTokenStorage();

//   Future<bool> login(String phone, String password) async {
//     try {
//       final data = {
//         'telephone': phone,
//         'password': password,
//       };
      
//       final response = await _apiService.post('auth/login', data);
//       print('Login response: $response');
      
//       if (response['success'] == true && response['token'] != null) {
//         await _tokenStorage.saveToken(response['token']);
//         await _saveRefreshToken(response['refresh_token']); 
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print('Login error: $e');
//       throw Exception('Échec de la connexion: ${e.toString()}');
//     }
//   }

//   Future<void> _saveRefreshToken(String refreshToken) async {
//     await _tokenStorage.saveToken(refreshToken);
//   }

//   Future<String?> getToken() async {
//     return await _tokenStorage.getToken();
//   }

//   Future<bool> verifySmsCode(String phoneNumber, String code) async {
//     try {
//       final response = await _apiService.post('auth/verify_sms', {
//         'phoneNumber': phoneNumber,
//         'code': code,
//       });
//       return response['success'] == true;
//     } catch (e) {
//       print('Erreur de vérification du code SMS : $e');
//       return false;
//     }
//   }
// }



import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import 'interface/api_service.dart';
import 'api_factory.dart';
import 'interface/token_storage.dart';
import '../token/storage_factory.dart';

class AuthService extends ChangeNotifier {
  final IApiService _apiService = createApiService(BASE_API_URL);
  final TokenStorage _tokenStorage = createTokenStorage();
  
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String phone, String password) async {
    try {
      final data = {
        'telephone': phone,
        'password': password,
      };

      final response = await _apiService.post('auth/login', data);
      print('Login response: $response');

      if (response['success'] == true && response['token'] != null) {
        await _tokenStorage.saveToken(response['token']);
        await _saveRefreshToken(response['refresh_token']); 
        _isAuthenticated = true;
        notifyListeners(); // Notifie les listeners d'un changement d'état
        return true;
      }
      _isAuthenticated = false;
      notifyListeners(); // Notifie également en cas d'échec
      return false;
    } catch (e) {
      print('Login error: $e');
      throw Exception('Échec de la connexion: ${e.toString()}');
    }
  }

  Future<void> _saveRefreshToken(String refreshToken) async {
    await _tokenStorage.saveToken(refreshToken);
  }

  Future<String?> getToken() async {
    return await _tokenStorage.getToken();
  }

  Future<bool> verifySmsCode(String phoneNumber, String code) async {
    try {
      final response = await _apiService.post('auth/verify_sms', {
        'phoneNumber': phoneNumber,
        'code': code,
      });
      return response['success'] == true;
    } catch (e) {
      print('Erreur de vérification du code SMS : $e');
      return false;
    }
  }

  // Future<void> logout() async {
  //   await _tokenStorage.deleteToken();
  //   _isAuthenticated = false;
  //   notifyListeners(); // Notifie les listeners en cas de déconnexion
  // }
}
