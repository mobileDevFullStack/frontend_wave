import 'package:flutter/material.dart';
import '../data/services/interface/api_service.dart';
import '../data/services/interface/token_storage.dart';
import '../data/services/transfert_service.dart';


class ApiProvider extends ChangeNotifier {
  final IApiService _apiService;
  final TokenStorage _tokenStorage;
  late final TransfertService _transfertService;

  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  ApiProvider(this._apiService, this._tokenStorage) {
    _transfertService = TransfertService(_apiService, _tokenStorage);
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

  /// Nouvelle méthode pour exposer le token
  Future<String?> getToken() async {
    return await _tokenStorage.getToken();
  }

  Future<Map<String, dynamic>?> initiateMoneyTransfer({
    required int senderId,
    required String recipientPhone,
    required double amount,
  }) async {
    _setLoading(true);
    final result = await _transfertService.initiateMoneyTransfer(
      senderId: senderId,
      recipientPhone: recipientPhone,
      amount: amount,
    );
    _setLoading(false);
    return result;
  }

  Future<Map<String, dynamic>?> initiateTransferMultiple({
    required int senderId,
    required List<Map<String, dynamic>> recipients,
  }) async {
    _setLoading(true);
    final result = await _transfertService.initiateTransferMultiple(
      senderId: senderId,
      recipients: recipients,
    );
    _setLoading(false);
    return result;
  }

  Future<Map<String, dynamic>?> initiateTransferPlanifier({
    required int userId,
    required String recipientPhone,
    required double amount,
    required String frequency,
    required DateTime nextDate,
  }) async {
    _setLoading(true);
    final result = await _transfertService.initiateTransferPlanifier(
      userId: userId,
      recipientPhone: recipientPhone,
      amount: amount,
      frequency: frequency,
      nextDate: nextDate,
    );
    _setLoading(false);
    return result;
  }

}
