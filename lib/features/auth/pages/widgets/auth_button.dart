import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color fontcolor;
  const AuthButton(
      {super.key,
      required this.label,
      required this.onTap,
      required this.backgroundColor,
      required this.fontcolor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        labelStyle: TextStyle(
          backgroundColor: backgroundColor,
          color: fontcolor,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      ),
    );
  }
}
