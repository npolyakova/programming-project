import 'package:application_front/CORE/repositories/SecureStorage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../repositories/DataApplication.dart';
import 'ApiClient.dart';
import '../repositories/LoginRequest.dart';
import '../repositories/User.dart';


class Authentication
{
  final ApiClient _client = ApiClient(url: DataApplication.urlService);

  static UserResponse? _currentUser;

  static UserResponse? get CurrentUser => _currentUser;

  static bool debug = true;

  Future<void> Login(String login, String password, [Function? OnComplited = null]) async
  {
    if(CurrentUser != null)
      throw Exception('Вы уже вошли');

    LoginRequest request = LoginRequest(login: login, password: GetSha256(password));

    await Future.delayed(Duration(seconds: 3));

    _currentUser = await _Login(request);

    await SecureStorage().saveToken(_currentUser!.token);

    OnComplited?.call();
  }

  Future<UserResponse> _Login(LoginRequest request) async {
    try {
      final response = await _client.Post(
        '/auth',
        data: 
        {
          'login': request.login,
         // 'password': 'your_password'
        },
      );
      UserResponse user = UserResponse.fromJson(response.data);

      final response2 = await _client.Get('/protected', user);
      ProtectedResponse resp = ProtectedResponse.fromJson(response2.data);
      print(response2.data);
      return user;
    } catch (e) {
      throw Exception('Ошибка аутентификации: ${e.toString()}');
    }
  }

  void Logout() async
  {
    if(_currentUser == null) 
    {
      return;
    }
    await SecureStorage().deleteToken();
    _currentUser = null;
  }

  static String GetSha256(String password)
  {
    List<int> data = utf8.encode(password);
    return sha256.convert(data).toString();
  }

}