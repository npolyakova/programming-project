import '../repositories/DataApplication.dart';
import 'ApiClient.dart';
import '../repositories/LoginRequest.dart';
import '../repositories/User.dart';


class Authentication
{
  final ApiClient _client = ApiClient(url: DataApplication.urlService);

  static UserInfo? _currentUser;

  static UserInfo? get CurrentUser => _currentUser;

  static bool debug = true;

  Future<void> Login(LoginRequest login, [Function? OnComplited = null]) async
  {
    if(CurrentUser != null)
      throw Exception('Вы уже вошли');

    await Future.delayed(Duration(seconds: 3));

    _currentUser = await _Login(login);

    OnComplited?.call();
  }

  Future<UserInfo> _Login(LoginRequest request) async {
    try {
      final response = await _client.PostAuth(
        data: request.toJson(),
      );
      UserInfo user = UserInfo();

      user.SetToken(response.data);

      final response2 = await _client.Get('/protected', user);
      user.SetUserInfo(response2.data);
      return user;
    } catch (e) {
      throw Exception('Ошибка аутентификации: ${e.toString()}');
    }
  }

  void Logout() async
  {
    _currentUser?.Delete();
    _currentUser = null;
  }

  

}