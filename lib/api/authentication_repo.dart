import 'dart:convert';

import 'package:frontend/models/jwt_token.dart';
import 'package:http/http.dart' as http;

class AuthenticationModel {
  Future<JwtToken?> login(String username, String password) async {
    final res = await http.post(
        Uri.parse(
          "https://l0wk3ycracks.pythonanywhere.com/auth/login/",
        ),
        body: {"username": username, "password": password});
    print(jsonDecode(res.body));
    if (res.statusCode == 200) {
      return JwtToken.fromjson(jsonDecode(res.body));
    } else {
      return null;
    }
  }

  Future<JwtToken> signUp(String username, String password, String fname,
      String lname, String bio) async {
    final res = await http.post(
        Uri.parse("https://l0wk3ycracks.pythonanywhere.com/profile/"),
        body: {"username": username, "password": password});
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception(jsonDecode(res.body));
    }
  }
}
