import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/common/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class ProfileController {
  Future<void> updateProfile(String username, String bio, String name, int id,
      String accesstoken, BuildContext context,
      {File? profilePicture, File? bannerPicture}) async {
    final url =
        Uri.parse("https://l0wk3ycracks.pythonanywhere.com/auth/profile/");
    var request = http.MultipartRequest("PUT", url);
    request.headers['Authorization'] = "Bearer $accesstoken";
    request.headers["Accept"] = "application/json";

    request.fields["username"] = username;
    request.fields["bio"] = bio;
    request.fields["Fame"] = name;
    request.fields["Lname"] = "a";
    request.fields["user"] = id.toString();
    if (profilePicture != null) {
      request.files.add(
          await http.MultipartFile.fromPath("picture", profilePicture.path));
    }
    if (bannerPicture != null) {
      request.files
          .add(await http.MultipartFile.fromPath("banner", bannerPicture.path));
    }

    final res = await request.send();
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackbar("Profile updated"));
    } else {
      debugPrint(await res.stream.bytesToString());
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar("Profile updation failed. Error occured"));
    }
  }
}
