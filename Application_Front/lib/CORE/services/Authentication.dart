import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'DataApplication.dart';
import 'ApiClient.dart';
import 'LoginRequest.dart';
import 'User.dart';


class Authentication
{
  final ApiClient _client = ApiClient(url: DataApplication.urlService);

  void Login(String login, String password) async
  {
    LoginRequest request = LoginRequest(login: login, password: GetSha256(password));
    await _Login(request);
  }

  Future<UserResponse> _Login(LoginRequest request) async {
    try {
      final response = await _client.Post(
        '/auth',
        data: request.toJson(),
      );

      print('Дебажу json');

      print(response.data);
      
      return UserResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Ошибка аутентификации: ${e.toString()}');
    }
  }

  static String GetSha256(String password)
  {
    List<int> data = utf8.encode(password);
    return sha256.convert(data).toString();
  }

}