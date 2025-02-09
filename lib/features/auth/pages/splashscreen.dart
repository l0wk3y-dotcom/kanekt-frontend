import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/assets.dart';
import 'package:frontend/features/home/pages/homepage.dart';
import 'package:frontend/features/auth/pages/login.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatelessWidget {
  final bool isLoggedin;
  const Splashscreen({super.key, required this.isLoggedin});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset(splashAnimation),
      nextScreen: isLoggedin ? const HomeNavigation() : const Login(),
      duration: 8000,
      backgroundColor: Colors.white,
      splashIconSize: 150,
    );
  }
}
