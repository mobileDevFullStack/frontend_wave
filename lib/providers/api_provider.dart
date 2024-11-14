import 'package:flutter/material.dart';
import '../data/services/interface/api_service.dart';
import '../data/services/interface/token_storage.dart';

class ApiProvider extends ChangeNotifier {
  final IApiService _apiService;
  final TokenStorage _tokenStorage;
  
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  ApiProvider(this._apiService, this._tokenStorage) {
    _checkAuthentication();
    
    
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  Future<void> _checkAuthentication() async {
    final token = await _tokenStorage.getToken();
    _setAuthenticated(token != null);
  }

  // Méthodes génériques API
  Future<Map<String, dynamic>?> getData(String endpoint) async {
    try {
      _setLoading(true);
      _setError(null);
      final response = await _apiService.get(endpoint);
      return response;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _setError(null);
      final response = await _apiService.post(endpoint, data);
      return response;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> putData(String endpoint, Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _setError(null);
      final response = await _apiService.put(endpoint, data);
      return response;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Méthodes d'authentification
  Future<bool> login(String phone, String password) async {
    try {
      final data = {
        'telephone': phone,
        'password': password,
      };
      
      final response = await postData('auth/login', data);
      
      if (response != null && response['success'] == true && response['token'] != null) {
        await _tokenStorage.saveToken(response['token']);
        if (response['refresh_token'] != null) {
          await _saveRefreshToken(response['refresh_token']);
        }
        _setAuthenticated(true);
        return true;
      }
      
      _setError('Identifiants invalides');
      return false;
    } catch (e) {
      _setError('Échec de la connexion: ${e.toString()}');
      return false;
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
      final response = await postData('auth/verify_sms', {
        'phoneNumber': phoneNumber,
        'code': code,
      });
      
      return response != null && response['success'] == true;
    } catch (e) {
      _setError('Erreur de vérification du code SMS : ${e.toString()}');
      return false;
    }
  }



  // Future<void> logout() async {
  //   try {
  //     _setLoading(true);
  //     await _tokenStorage.deleteToken();
  //     _setAuthenticated(false);
  //   } catch (e) {
  //     _setError('Erreur lors de la déconnexion : ${e.toString()}');
  //   } finally {
  //     _setLoading(false);
  //   }
  // }
}
