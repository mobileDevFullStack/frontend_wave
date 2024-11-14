import 'interface/api_service.dart';
import 'http_api_service.dart';
import 'dio_api_service.dart';
import '../../core/constants/api_constants.dart';

IApiService createApiService(String baseUrl) {
  if (API_TYPE == 'http') {
    return HttpApiService(baseUrl);
  } else if (API_TYPE == 'dio') {
    return DioApiService(baseUrl);
  } else {
    throw Exception('API_TYPE non supporté');
  }
}
