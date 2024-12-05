import 'package:application_front/CORE/services/ApiClient.dart';
import 'package:application_front/CORE/services/Authentication.dart';
import 'package:application_front/UI/menus/AuthenticationMenu.dart';
import 'package:application_front/UI/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Sirius Routing Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 25, 0, 255)),
        useMaterial3: true,
      ),
      routes: 
      {
        '/auth': (context) => AuthenticationMenu(),
        '/main': (context) => MainScreen()
      },
      initialRoute: '/auth',
    );
  }

  void testHttp() async {
  try {

    Authentication auth = Authentication();

    auth.Login("blabla", 'pass');

    final TestClient = await ApiClient(url: 'https://jsonplaceholder.typicode.com').Get('/posts/1');
    print('Статус ответа: ${TestClient.statusCode}');
    print('Тело ответа: ${TestClient.data}');
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    print('Статус ответа: ${response.statusCode}');
    print('Тело ответа: ${response.body}');
  } catch (e) {
    print('Ошибка при выполнении запроса: $e');
  }
}
}




