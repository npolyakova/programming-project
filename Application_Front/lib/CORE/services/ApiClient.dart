import 'package:dio/dio.dart';

class ApiClient 
{
  final String url;

  late final Dio _dio;

  ApiClient({required this.url})
  {
    _dio = Dio(
      BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds:  5),
        receiveTimeout: const Duration(seconds:  3),
      )
    );
  }
  Future<Response> Get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw _HandleError(e);
    }
  }

  Future<Response> Post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      throw _HandleError(e);
    }
  }
  Exception _HandleError(dynamic error) {
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
        default:
          return Exception('Произошла ошибка при запросе');
      }
    }
    return Exception('Неизвестная ошибка');
  }
}