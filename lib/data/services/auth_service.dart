import 'dart:io';

import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import 'interface/api_service.dart';
import 'api_factory.dart';
import 'interface/token_storage.dart';
import '../token/storage_factory.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final IApiService _apiService = createApiService(BASE_API_URL);
  final TokenStorage _tokenStorage = createTokenStorage();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // Étape 1 : Vérification des identifiants
  Future<bool> login(String phone, String secretCode) async {
    try {
      final data = {
        'phone': phone,
        'secret_code': secretCode,
      };
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response =
          await _apiService.post('loginClient', data, headers: headers);

      if (response['success'] == true) {
        return true;
      } else {
        throw Exception(
            'Échec de la connexion. Veuillez vérifier vos identifiants.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion : $e');
    }
  }

  // Étape 2 : Vérification du code SMS
  Future<Map<String, dynamic>> verifySmsCode(
      String phone, String smsCode) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await _apiService.post(
          'verify-sms-code',
          {
            'phone': phone,
            'code': smsCode,
          },
          headers: headers);

      if (response.containsKey('access_token')) {
        // Sauvegarder le token
        await _tokenStorage.saveToken(response['access_token']);
        _isAuthenticated = true;
        notifyListeners();

        return {
          'success': true,
          'user': response['user'],
        };
      }

      return {'success': false};
    } catch (e) {
      throw Exception('Erreur lors de la vérification du code SMS : $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String firstname,
    required String lastname,
    required String role,
    required String phone,
    required String email,
    required String password,
    required String adresse,
    required String cni,
    required String secretCode,
    File? photo,
  }) async {
    try {
      final data = {
        'firstname': firstname,
        'lastname': lastname,
        'role': role,
        'phone': phone,
        'email': email,
        'password': password,
        'adresse': adresse,
        'cni': cni,
        'secret_code': secretCode,
      };

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (photo != null) {
        final formData = FormData.fromMap(data);
        formData.files.add(MapEntry(
          'photo',
          await MultipartFile.fromFile(photo.path,
              filename: photo.path.split('/').last),
        ));
        return await _apiService.postWithFile('register', data, photo, 'photo');
      } else {
        return await _apiService.post('register', data, headers: headers);
      }
    } catch (e) {
      throw Exception('Error registering: $e');
    }
  }

// authentification for distributeur
  Future<Map<String, dynamic>> loginDistributor(
      String email, String password) async {
    try {
      final data = {
        'email': email,
        'password': password,
      };
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response =
          await _apiService.post('loginDistributeur', data, headers: headers);

      // Ajouter une vérification pour savoir si les identifiants ont déjà été mis à jour
      bool hasUpdatedCredentials = response['has_updated_credentials'] ?? false;

      return {
        'success': true,
        'requires_update': response['requires_update'] ?? false,
        'has_updated_credentials': hasUpdatedCredentials,
      };
    } catch (e) {
      throw Exception('Erreur lors de la connexion : $e');
    }
  }


// update password distributeur for first authentication
  Future<bool> updateCredentials({
    required String email,
    required String password,  // ancien mot de passe
    required String newPassword,  // nouveau mot de passe
    required String secretCode,
  }) async {
    try {
      final data = {
        'email': email,
        'password': newPassword,  // On envoie le nouveau mot de passe
        'secret_code': secretCode,
      };
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      final response = await _apiService.post('updateDistributeur', data, headers: headers);
      return response['success'] ?? false;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour des informations : $e');
    }
  }

// Pour gérer le statut de mise à jour des identifiants
  Future<void> setCredentialsUpdated(bool updated) async {
    // Utilisez SharedPreferences pour stocker l'état
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('credentials_updated', updated);
  }

  Future<bool> getCredentialsUpdated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('credentials_updated') ?? false;
  }
}
