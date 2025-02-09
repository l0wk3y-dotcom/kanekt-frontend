import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      colorScheme: ColorScheme.dark(
        primary: const Color.fromARGB(255, 255, 255, 255),
        secondary: Colors.grey.shade800,
        surface: const Color.fromARGB(255, 0, 0, 0),
        onPrimary: Colors.white,
        onSecondary: const Color.fromARGB(255, 50, 62, 99),
        onSurface: const Color.fromARGB(255, 39, 78, 255),
      ),
    );
  }
}
