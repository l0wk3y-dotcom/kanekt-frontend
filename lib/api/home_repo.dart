import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeRepo {
  Future<String> getHome(String accessToken) async {
    try {
      final res = await http.get(
          Uri.parse("https://l0wk3ycracks.pythonanywhere.com/home"),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          });
      final Map data = jsonDecode(res.body);
      return data["message"];
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw Exception("Server Error");
    }
  }
}
