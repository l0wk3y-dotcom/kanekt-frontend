import 'package:flutter/material.dart';
import 'package:frontend/features/user_profile/widgets/user_profile.dart';
import 'package:frontend/models/userdetailmodel.dart';

class UserProfileView extends StatefulWidget {
  static route(Userdetailmodel user) =>
      MaterialPageRoute(builder: (context) => UserProfileView(user: user));
  final Userdetailmodel user;
  const UserProfileView({super.key, required this.user});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfile(user: widget.user),
    );
  }
}
