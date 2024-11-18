import 'package:flutter/material.dart';

import 'interface/api_service.dart';
import 'interface/token_storage.dart';

class TransfertService extends ChangeNotifier {
  final IApiService _apiService;
  final TokenStorage _tokenStorage;

  TransfertService(this._apiService, this._tokenStorage);

  Future<Map<String, dynamic>?> initiateMoneyTransfer({
    required int senderId,
    required String recipientPhone,
    required double amount,
  }) async {
    try {
      final token = await _getFormattedToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token d\'authentification manquant',
        };
      }

      final headers = _buildHeaders(token);

      final response = await _apiService.post(
        'transfers',
        {
          'sender_id': senderId,
          'recipient_phone': recipientPhone,
          'amount': amount,
        },
        headers: headers,
      );

      return response['data'] != null
          ? {
              'success': true,
              'data': response['transfer'],
              'message': response['message'],
            }
          : {'success': false, 'message': 'Échec du transfert'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors du transfert : ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>?> initiateTransferMultiple({
    required int senderId,
    required List<Map<String, dynamic>> recipients,
  }) async {
    try {
      final token = await _getFormattedToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token d\'authentification manquant',
        };
      }

      final headers = _buildHeaders(token);

      final response = await _apiService.post(
        'transfers/multiple',
        {
          'sender_id': senderId,
          'recipients': recipients,
        },
        headers: headers,
      );

      return response['data'] != null
          ? {
              'success': true,
              'data': response['data'],
              'message': response['message'],
            }
          : {'success': false, 'message': 'Échec du transfert multiple'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors du transfert multiple : ${e.toString()}',
      };
    }
  }

  Future<String?> _getFormattedToken() async {
    String? token = await _tokenStorage.getToken();
    if (token == null || token.isEmpty) return null;

    token = token.trim();
    if (!token.startsWith('Bearer ')) {
      token = 'Bearer $token';
    }
    return token;
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
  }


  Future<Map<String, dynamic>?> initiateTransferPlanifier({
    required int userId,
    required String recipientPhone,
    required double amount,
    required String frequency,
    required DateTime nextDate,
  }) async {
    try {
      final token = await _getFormattedToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token d\'authentification manquant',
        };
      }

      final headers = _buildHeaders(token);
      print('user: $userId, phone: $recipientPhone, amount: $amount, frequence: $frequency, date: $nextDate');
      final response = await _apiService.post(
        'scheduled',
        {
          'user_id': userId,
          'recipient_phone': recipientPhone,
          'amount': amount,
          'frequency': frequency,
          'next_date': nextDate.toIso8601String(),
        },
        headers: headers,
      );

      return response['data'] != null
          ? {
              'success': true,
              'data': response['data'],
              'message': response['message'],
            }
          : {'success': false, 'message': 'Échec du transfert ssss'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors du transfert : ${e.toString()}',
      };
    }
  }
}
