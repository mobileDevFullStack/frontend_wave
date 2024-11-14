import 'dart:convert';
import 'package:http/http.dart' as http;
import 'interface/api_service.dart';


class HttpApiService implements IApiService {
  final String baseUrl;

  HttpApiService(this.baseUrl);

  @override
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url, headers: {'Accept': 'application/json'});
    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Une erreur est survenue');
    }
  }
}
