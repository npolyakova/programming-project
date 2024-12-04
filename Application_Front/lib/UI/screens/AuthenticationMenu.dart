import 'package:application_front/UI/screens/LoginScreen.dart';
import 'package:application_front/UI/widgets/SimpleButton.dart';
import 'package:application_front/UI/widgets/SimpleTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationMenu extends StatefulWidget {
  AuthenticationMenu({super.key});

  @override
  State<AuthenticationMenu> createState() => _AuthenticationMenuState();
}

class _AuthenticationMenuState extends State<AuthenticationMenu> {
  static const double _verticalSpacing = 30.0;
  static const double _smallSpacing = 16.0;

  TextEditingController loginInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();

  @override
  void initState() 
  {
    super.initState();
    SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() 
  {
    loginInput.dispose();
    passwordInput.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    LoginScreen screen = LoginScreen();
    Color bcColor = LoginScreen.colorComponents;
    SimpleButton button = SimpleButton(backgroundColor: bcColor);
    SimpleTextField writeField = SimpleTextField(backgroundColor: Colors.white);

    Text title = Text(
    'Добрый день!',
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: bcColor));

    Text titleDescription = Text(
    'Введите логин и пароль для авторизации',
    style: Theme.of(context).textTheme.bodyMedium,);
    screen.AddWidgets(
      [
        title,titleDescription,
        const SizedBox(height: _verticalSpacing),
        writeField.GetInput('Введите логин', loginInput, Icon(Icons.person_outline) ,bcColor),
        const SizedBox(height: _smallSpacing),
        writeField.GetInput('Введите пароль', passwordInput, Icon(Icons.lock_outline) ,bcColor, true),
        const SizedBox(height: _verticalSpacing),
        button.GetButton('Войти', () => {}),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Нет аккаунта? '),
            TextButton(
              onPressed: () {},
              child: Text('Зарегистрируйтесь', style: TextStyle(color: bcColor, fontSize: 17)),
            ),
          ],
        ),
      ]);

    return screen;
  }
}
