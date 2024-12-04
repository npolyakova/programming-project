import 'package:application_front/UI/screens/AuthenticationMenu.dart';
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
    testHttp();
    return MaterialApp(
      title: 'Sirius Routing Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 25, 0, 255)),
        useMaterial3: true,
      ),
      home: AuthenticationMenu(),
    );
  }
  void testHttp() async {
  try {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    print('Статус ответа: ${response.statusCode}');
    print('Тело ответа: ${response.body}');
  } catch (e) {
    print('Ошибка при выполнении запроса: $e');
  }
}
}




