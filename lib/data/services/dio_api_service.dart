
import 'package:dio/dio.dart';

import 'interface/api_service.dart';
class DioApiService implements IApiService {
  final String baseUrl;
  final Dio _dio = Dio();

  DioApiService(this.baseUrl);

  @override
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await _dio.post('$baseUrl/$endpoint', data: data);
    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _dio.get('$baseUrl/$endpoint');
    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final response = await _dio.put('$baseUrl/$endpoint', data: data);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(response.data['message'] ?? 'Une erreur est survenue');
    }
  }
}

