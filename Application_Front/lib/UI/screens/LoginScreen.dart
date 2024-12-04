import 'package:application_front/UI/widgets/WavePainter.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget 
{
  static const Color colorComponents = Color.fromARGB(255, 55, 32, 126);

  final List<Widget> widgets = 
  [
    Image.asset('Resources/Logo.png', height: 100),
    const SizedBox(height: 40),
  ];

  final Widget widget = CustomPaint(
    painter: WavePainter(colorWave: colorComponents),
    size: Size(double.infinity, 100));

  LoginScreen({super.key});

  void AddWidgets(List<Widget> newWidgets)
  {
    widgets.addAll(newWidgets);
  }
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      resizeToAvoidBottomInset: false,
      body: SafeArea
      (
        child: Padding
        (
          padding: EdgeInsets.all(40),
          child: Column(children: [...widgets, widget]),
        )
      )
    );
  }
}