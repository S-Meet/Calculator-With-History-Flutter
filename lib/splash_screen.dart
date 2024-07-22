import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:calculator/MyHomePage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.network('https://lottie.host/c738fed7-d0fa-4f75-8ab9-10f2d9e7ba4b/5pl7T8IWGa.json'),
      ),
      nextScreen: const MyHomePage(),
      splashIconSize: 225,
      duration: 3500,
      backgroundColor: Colors.black,
    );
  }
}
