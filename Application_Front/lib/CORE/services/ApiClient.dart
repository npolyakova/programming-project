import 'package:application_front/CORE/repositories/User.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final String url;
  late final Dio _dio;

  ApiClient({required this.url}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        contentType: Headers.formUrlEncodedContentType, // Важное изменение!
      ),
    );
    _dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));
  }

  Map<String, dynamic> _GetHeaders(String? _authToken) {
    final headers = <String, dynamic>{};
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }

  Future<Response> Get(String path, UserResponse user, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: _GetHeaders(user.token)),
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> Post(String path, {dynamic data}) async {
    try {
       if (path == '/auth') {
      path += '?login=${data['login']}';  
      }

      final response = await _dio.post(
        path,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Exception('Превышено время ожидания соединения');
        case DioExceptionType.receiveTimeout:
          return Exception('Превышено время ожидания ответа');
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 401) {
            return Exception('Неавторизован');
          }
          return Exception('Ошибка сервера: ${error.response?.statusCode}');
        case DioExceptionType.cancel:
          return Exception('Запрос был отменен');
        case DioExceptionType.badCertificate:
          return Exception('Ошибка сертификата');
        default:
          return Exception('Произошла ошибка при запросе: ${error.message}');
      }
    }
    return Exception('Неизвестная ошибка');
  }
}