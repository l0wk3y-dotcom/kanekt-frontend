import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/userdetailmodel.dart';
import 'package:http/http.dart' as http;

class SearchControllerQuery {
  Future<List<Userdetailmodel>> searchUser(String query) async {
    final res = await http.get(Uri.parse(
        "https://l0wk3ycracks.pythonanywhere.com/auth/search/$query"));
    final List Users = jsonDecode(res.body);
    debugPrint(Users.toString());
    return Users.map((e) {
      return Userdetailmodel.fromJson(e);
    }).toList();
  }
}
