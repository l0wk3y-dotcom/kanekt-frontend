import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api/authentication_repo.dart';
import 'package:frontend/api/fcm_token.dart';
import 'package:frontend/common/custom_snackbar.dart';
import 'package:frontend/features/auth/logic/background_creds.dart';
import 'package:frontend/features/auth/pages/login.dart';
import 'package:frontend/models/userdetailmodel.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final AuthenticationModel _authenticationModel;
  String? accesstoken;
  String? refreshtoken;
  Uri profilepicture =
      Uri.parse("https://l0wk3ycracks.pythonanywhere.com/media/pp/default.jpg");
  String username = "Not Logged in";
  AuthProvider(this._authenticationModel);
  Userdetailmodel? self;
  bool get isAuthenticated => accesstoken != null;
  bool isDarkmode = false;
  BackgroundCreds storage = BackgroundCreds();

  void toggleTheme() {
    isDarkmode = !isDarkmode;
    notifyListeners();
  }

  void chechAuthentication(BuildContext context) {
    if (accesstoken == null) {
      Navigator.pushReplacement(context, Login.route());
    }
  }

  Future<bool> signUp(UserRegisterModel user) async {
    final url =
        Uri.parse("https://l0wk3ycracks.pythonanywhere.com/auth/profile/");
    var req = http.MultipartRequest("POST", url);
    req.headers["Accept"] = "application/json";

    req.fields["username_create"] = user.username_create;
    req.fields["password"] = user.password;
    req.fields["bio"] = user.bio!;
    req.fields["Fame"] = user.fname!;
    req.fields["Lname"] = "a";
    req.fields["user"] = "1";

    if (user.banner != null) {
      req.files
          .add(await http.MultipartFile.fromPath("banner", user.banner!.path));
    }
    if (user.picture != null) {
      req.files.add(
          await http.MultipartFile.fromPath("picture", user.picture!.path));
    }

    try {
      final res = await req.send();

      // Read and print the response body
      final resBody = await res.stream.bytesToString();

      if (res.statusCode == 200) {
        debugPrint("Response: $resBody");
        await login(user.username_create, user.password);
        return true;
      } else {
        // Log errors
        debugPrint("Error: Status code ${res.statusCode}");
        debugPrint("Response: $resBody");
        return false;
      }
    } catch (e) {
      debugPrint("An error occurred: $e");
      return false;
    }
  }

  Future<void> toggleFollow(String username) async {
    final res = await http.post(
        Uri.parse(
            "https://l0wk3ycracks.pythonanywhere.com/auth/follow/$username"),
        headers: {"Authorization": "Bearer $accesstoken"});
    debugPrint(res.body);
  }

  Future<bool> login(String username, String password) async {
    try {
      final authdetails = await _authenticationModel.login(username, password);
      if (authdetails != null) {
        accesstoken = authdetails.accessToken;
        refreshtoken = authdetails.refreshToken;
        storage.saveCreds(username, password);
        notifyListeners();
        await getUserDetails();
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getFollow(String username) async {
    final res = await http.get(
        Uri.parse(
            "https://l0wk3ycracks.pythonanywhere.com/auth/follow/$username"),
        headers: {"Authorization": "Bearer $accesstoken"});
    final data = jsonDecode(res.body);
    debugPrint("getting status : $data");
    if (res.statusCode == 200) {
      return data["status"];
    }
    return "Follow";
  }

  Future<void> getUserDetails() async {
    final url =
        Uri.parse("https://l0wk3ycracks.pythonanywhere.com/auth/profile");
    final res =
        await http.get(url, headers: {"Authorization": "Bearer $accesstoken"});
    final data = jsonDecode(res.body);
    username = data["username"];
    self = Userdetailmodel.fromJson(data);
    profilepicture =
        Uri.parse('https://l0wk3ycracks.pythonanywhere.com${data["picture"]}');
  }

  Future<void> likeTweet(String tweetid, bool isLiked) async {
    final url = Uri.parse(
        "https://l0wk3ycracks.pythonanywhere.com/tweets/$tweetid/like");
    final res =
        await http.post(url, headers: {"Authorization": "Bearer $accesstoken"});
    final data = jsonDecode(res.body);
    debugPrint(data);
  }

  Future<void> retweet(String tweetid, BuildContext context) async {
    final url = Uri.parse(
        "https://l0wk3ycracks.pythonanywhere.com/tweets/$tweetid/retweet");
    final res =
        await http.post(url, headers: {"Authorization": "Bearer $accesstoken"});
    final data = jsonDecode(res.body);
    debugPrint(data);
    data["message"] == "retweet created"
        ? null
        : ScaffoldMessenger.of(context)
            .showSnackBar(customSnackbar("Retweet failed"));
  }

  Future<void> logout(BuildContext context) async {
    await storage.removeCreds();
    accesstoken = null;
    refreshtoken = null;
    Navigator.pushReplacement(context, Login.route());
  }

  Future<void> registerToken() async {
    final token = await FcmToken().initializeMessaging();
    print("This is what we are sending $token");
    if (token != null) {
      final res = await http.post(
          Uri.parse("https://l0wk3ycracks.pythonanywhere.com/auth/fcm/"),
          headers: {"Authorization": "Bearer $accesstoken"},
          body: {"fcmToken": token});

      print(jsonDecode(res.body));
    }
  }
}
