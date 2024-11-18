
import 'dart:io';

import 'package:dio/dio.dart';

import 'interface/api_service.dart';
class DioApiService implements IApiService {
  final String baseUrl;
  final Dio _dio = Dio();

  DioApiService(this.baseUrl);

  @override
  Future<Map<String, dynamic>> post(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    final response = await _dio.post('$baseUrl/$endpoint', data: data);
    return _handleResponse(response);
  }

  

  @override
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await _dio.get('$baseUrl/$endpoint');
    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
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

    @override
  Future<Map<String, dynamic>> postWithFile(
      String endpoint, Map<String, dynamic> data, File file, String fileFieldName) async {
    final formData = FormData.fromMap({
      ...data,
      fileFieldName: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final response = await _dio.post('$baseUrl/$endpoint', data: formData);
    return _handleResponse(response);
  }

}

