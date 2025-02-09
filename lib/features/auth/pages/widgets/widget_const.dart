import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/assets.dart';

class UIConstants {
  static AppBar authAppbar() {
    return AppBar(
      title: const Icon(
        Icons.connecting_airports_outlined,
        size: 30,
        color: Colors.blue,
      ),
      centerTitle: true,
    );
  }
}
