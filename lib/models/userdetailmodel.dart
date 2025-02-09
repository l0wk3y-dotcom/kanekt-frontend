import 'dart:io';

import 'package:flutter/foundation.dart';

class Userdetailmodel {
  int id;
  String fname;
  String lname;
  String picture;
  String bio;
  String username;
  String banner;
  String name;
  int following;
  int followers;
  Userdetailmodel(
      {required this.id,
      required this.fname,
      required this.following,
      required this.followers,
      required this.lname,
      required this.picture,
      required this.bio,
      required this.username,
      required this.name,
      required this.banner});

  factory Userdetailmodel.fromJson(Map<String, dynamic> data) {
    return Userdetailmodel(
        id: data["user"],
        fname: data["Fame"],
        lname: data["Lname"],
        picture: "https://l0wk3ycracks.pythonanywhere.com" + data["picture"],
        bio: data["bio"],
        username: data["username"],
        following: data["following"],
        followers: data["followers"],
        name: data["Fame"] + "   " + data["Lname"],
        banner: "https://l0wk3ycracks.pythonanywhere.com" + data["banner"]);
  }
}

class UserRegisterModel {
  String? fname;
  String? lname;
  File? picture;
  String? bio;
  String username_create;
  File? banner;
  String password;
  UserRegisterModel(
      {required this.password,
      required this.username_create,
      this.fname,
      this.lname,
      this.picture,
      this.bio,
      this.banner});

  factory UserRegisterModel.fromJson(Map<String, dynamic> data) {
    return UserRegisterModel(
        password: data["password"], username_create: data["username"]);
  }
}
