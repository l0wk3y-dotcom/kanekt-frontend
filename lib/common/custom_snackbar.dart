import 'package:flutter/material.dart';

SnackBar customSnackbar(String text) {
  return SnackBar(
    content: Text(text, style: const TextStyle(color: Colors.white)),
    backgroundColor: const Color.fromARGB(255, 46, 46, 46),
    action: SnackBarAction(
      textColor: Colors.blue,
      label: "Dismiss",
      onPressed: () {},
    ),
  );
}
