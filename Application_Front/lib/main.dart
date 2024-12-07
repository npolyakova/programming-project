import 'package:application_front/CORE/services/ApiClient.dart';
import 'package:application_front/CORE/services/Authentication.dart';
import 'package:application_front/UI/menus/AuthenticationMenu.dart';
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
      },
      initialRoute: '/auth',
    );
  }
}




