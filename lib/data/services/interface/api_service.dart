import 'dart:io';

abstract class IApiService {
  Future<Map<String, dynamic>> post(String endpoint, dynamic data, {Map<String, String>? headers}); // Modification ici
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers});
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers});
  Future<Map<String, dynamic>> postWithFile(
      String endpoint, Map<String, dynamic> data, File file, String fileFieldName);
}

