import 'dart:convert';
import 'package:http/http.dart' as http;
import 'interface/api_service.dart';
import 'dart:io';

class HttpApiService implements IApiService {
  final String baseUrl;

  HttpApiService(this.baseUrl);

  @override
  Future<Map<String, dynamic>> post(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    // Vérifier si `data` est une Map contenant des fichiers (multipart simulation)
    if (data is Map<String, dynamic> && data.containsKey('files')) {
      final request = http.MultipartRequest('POST', url);

      // Ajouter les champs non-fichiers
      data.forEach((key, value) {
        if (key != 'files') {
          request.fields[key] = value.toString();
        }
      });

      // Ajouter les fichiers
      final files = data['files'] as List<MapEntry<String, File>>;
      for (var fileEntry in files) {
        final fileFieldName = fileEntry.key;
        final file = fileEntry.value;
        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath(
            fileFieldName,
            file.path,
            filename: file.path.split('/').last,
          ));
        }
      }

      // Envoyer la requête et gérer la réponse
      print('requete envoyé au backend: ${await request.send}');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    }

    print('voici mon url: $url'); 
    // Si ce n'est pas une requête multipart, traiter comme JSON
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response =
        await http.get(url, headers: {'Accept': 'application/json'});
    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
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

  @override
  Future<Map<String, dynamic>> postWithFile(String endpoint,
      Map<String, dynamic> data, File file, String fileFieldName) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({'Accept': 'application/json'});

    // Ajouter les champs
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Ajouter le fichier
    request.files.add(
      await http.MultipartFile.fromPath(
        fileFieldName,
        file.path,
        filename: file.path.split('/').last,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }
}
