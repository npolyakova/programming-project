import 'package:flutter/material.dart';

class SimpleButton
{
  Color backgroundColor;

  SimpleButton({required this.backgroundColor});

  Widget GetButton(String text, Function()? onClick, [Color colorText = Colors.white])
  {
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onClick,
        child: Text(text, style: TextStyle(color: colorText, fontSize: 15),),
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
      ),
    );
  }
}

