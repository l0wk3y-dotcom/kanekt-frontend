import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 68, 68, 68)),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      colorScheme: ColorScheme.light(
        primary: const Color.fromARGB(255, 0, 0, 0),
        secondary: Colors.grey.shade200,
        surface: Colors.grey.shade100,
        onPrimary: Colors.black,
        onSecondary: const Color.fromARGB(255, 85, 85, 85),
        onSurface: const Color.fromARGB(255, 40, 79, 255),
      ),
    );
  }
}
