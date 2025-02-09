import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/user_profile/controller/profile_controller.dart';
import 'package:frontend/models/userdetailmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileEditView extends StatefulWidget {
  static route(Userdetailmodel user) {
    return MaterialPageRoute(
        builder: (context) => UserProfileEditView(user: user));
  }

  final Userdetailmodel user;
  const UserProfileEditView({super.key, required this.user});

  @override
  State<UserProfileEditView> createState() => _UserProfileEditViewState();
}

class _UserProfileEditViewState extends State<UserProfileEditView> {
  File? profilePicture;
  File? bannerPicture;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<File?> pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }

  Future<void> pickProfilePicture() async {
    final pic = await pickImage();
    if (pic != null) {
      setState(() {
        profilePicture = pic;
      });
    } else {
      profilePicture = null;
    }
  }

  Future<void> pickBannerPicture() async {
    final pic = await pickImage();
    if (pic != null) {
      setState(() {
        bannerPicture = pic;
      });
    } else {
      bannerPicture = null;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                ProfileController().updateProfile(
                    usernameController.text == ""
                        ? widget.user.username
                        : usernameController.text,
                    bioController.text == ""
                        ? widget.user.bio
                        : bioController.text,
                    nameController.text == ""
                        ? widget.user.username
                        : nameController.text,
                    widget.user.id,
                    authprovider.accesstoken!,
                    context,
                    profilePicture: profilePicture,
                    bannerPicture: bannerPicture);
              },
              style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.blue)),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.blue),
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  height: 170,
                  child: bannerPicture != null
                      ? Image.file(bannerPicture!)
                      : Image.network(
                          widget.user.banner,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  left: 30,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: profilePicture != null
                        ? FileImage(profilePicture!)
                        : NetworkImage(widget.user.picture),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 90,
                  child: GestureDetector(
                    onTap: pickProfilePicture,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.edit,
                        size: 15,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 30,
                  child: GestureDetector(
                    onTap: pickBannerPicture,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.edit,
                        size: 15,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  decoration: InputDecoration(
                    hintText: widget.user.name,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(borderSide: BorderSide()),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: usernameController,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  decoration: InputDecoration(
                    hintText: "@" + widget.user.username,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(borderSide: BorderSide()),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: bioController,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: widget.user.bio,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(borderSide: BorderSide()),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
