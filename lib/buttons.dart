import 'package:flutter/material.dart';

class calcButtons extends StatelessWidget {
  final String buttonText;
  final textColor;
  final buttonColor;
  final userInput;

  calcButtons({this.textColor, required this.buttonText, this.buttonColor, this.userInput});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: userInput,
      child: Padding(
        padding: const EdgeInsets.all(5.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: buttonColor,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                  color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
