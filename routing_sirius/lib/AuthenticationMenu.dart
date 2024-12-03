import 'package:flutter/material.dart';

class AuthenticationMenu extends StatelessWidget
{
  AuthenticationMenu({super.key});
  
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String test = 'qrfqwsfqwe';
  @override
  Widget build(BuildContext context) 
  {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Аунтификация'),
      ),
      body: Center(
        child: Column(children: 
        [
          Text('Ввод логина'),
          TextField(controller: _controller),
          Text('Ввод пароля'),
          TextField(controller: _controller2),
          IconButton(onPressed: () => { setState(() => test = "qqqqqqqqqqq") }, icon: Icon(Icons.access_time)),
          Text('$test'),
        ],),
      ),
    );
  }

}