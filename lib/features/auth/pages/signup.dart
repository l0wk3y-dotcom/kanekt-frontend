import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_snackbar.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/auth/pages/login.dart';
import 'package:frontend/features/auth/pages/widgets/auth_button.dart';
import 'package:frontend/features/auth/pages/widgets/authinout.dart';
import 'package:frontend/features/auth/pages/widgets/widget_const.dart';
import 'package:frontend/features/home/pages/homepage.dart';
import 'package:frontend/models/userdetailmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) {
        return const Signup();
      });
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String bannerImageUrl =
      "https://l0wk3ycracks.pythonanywhere.com/media/banners/default.jpeg";
  String profileImageUrl =
      "https://l0wk3ycracks.pythonanywhere.com/media/pp/default.jpg";
  File? profilePicture;
  File? bannerPicture;
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final appbar = UIConstants.authAppbar();

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

  int _currentstep = 0;
  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  late UserRegisterModel user;
  bool _verifyUsernamePassword() {
    if (usernamecontroller.text == "" || passwordcontroller.text == "") {
      return false;
    } else {
      return true;
    }
  }

  bool _verifyFirstNamePassword() {
    if (nameController.text == "" || bioController.text == "") {
      return false;
    } else {
      return true;
    }
  }

  void _nextStep() {
    if (_currentstep == 0 && !_verifyUsernamePassword()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackbar("Username or Password is invalid"));
    } else if (_currentstep == 1 && !_verifyFirstNamePassword()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackbar("Name or Bio cannot be empty"));
    } else {
      user = UserRegisterModel(
        password: passwordcontroller.text,
        username_create: usernamecontroller.text,
      );
      if (_currentstep == 1) {
        user.fname = nameController.text;
        user.bio = bioController.text;
      }
      if (_currentstep <= 1) {
        setState(() {
          _currentstep += 1;
        });
      }
    }
  }

  void _backStep() {
    if (_currentstep <= 0) {
    } else {
      setState(() {
        _currentstep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> register() async {
      if (bannerPicture != null || profilePicture != null) {
        profilePicture != null
            ? user.picture = profilePicture!
            : user.banner = bannerPicture!;
      }
      final authprovider = Provider.of<AuthProvider>(context, listen: false);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                height: 100,
                width: 200,
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.surface),
                child: Scaffold(
                  body: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Logging in",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 17,
                              decoration: TextDecoration.none),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        const CircularProgressIndicator()
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
      final res = await authprovider.signUp(user);
      if (res == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            customSnackbar("Registration error please verify the data"));
      } else {
        Navigator.pop(context);
        Navigator.pushReplacement(context, HomeNavigation.route());
      }
    }

    return Scaffold(
      appBar: appbar,
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              currentStep: _currentstep,
              onStepContinue: _currentstep == 2 ? register : _nextStep,
              onStepCancel: _backStep,
              steps: [
                Step(
                    title: const Text("1"),
                    state: _currentstep == 0
                        ? StepState.editing
                        : StepState.complete,
                    isActive: _currentstep >= 0,
                    content: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Authinput(
                              hint: "username",
                              customController: usernamecontroller),
                          const SizedBox(
                            height: 20,
                          ),
                          Authinput(
                            hint: "password",
                            customController: passwordcontroller,
                            isPassword: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )),
                Step(
                    title: const Text("2"),
                    state: _currentstep == 1
                        ? StepState.editing
                        : StepState.complete,
                    isActive: _currentstep >= 1,
                    content: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Authinput(
                              hint: "Name e.g, new user",
                              customController: nameController),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: bioController,
                            maxLines: 3,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            decoration: InputDecoration(
                              hintText:
                                  "bio e.g., A web developer, App developer, application and network security analyst",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )),
                Step(
                    title: const Text("3"),
                    state: _currentstep == 2
                        ? StepState.editing
                        : StepState.complete,
                    isActive: _currentstep >= 2,
                    content: SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            Container(
                                height: 150,
                                width: double.infinity,
                                child: bannerPicture != null
                                    ? Image.file(
                                        bannerPicture!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        bannerImageUrl,
                                        fit: BoxFit.cover,
                                      )),
                            Positioned(
                              bottom: 15,
                              left: 10,
                              child: CircleAvatar(
                                backgroundImage: profilePicture == null
                                    ? NetworkImage(profileImageUrl)
                                    : FileImage(profilePicture!),
                                radius: 30,
                              ),
                            ),
                            Positioned(
                                right: 20,
                                bottom: 30,
                                child: GestureDetector(
                                  onTap: pickBannerPicture,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 20,
                                    child: Icon(
                                      Icons.edit,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                )),
                            Positioned(
                                left: 55,
                                bottom: 20,
                                child: GestureDetector(
                                  onTap: pickProfilePicture,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 10,
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ))
                          ],
                        )))
              ],
              type: StepperType.horizontal,
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(side: const BorderSide()),
                      child: Text(_currentstep >= 2 ? "Submit" : "Continue"),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      style: ElevatedButton.styleFrom(side: const BorderSide()),
                      child: Text(
                        "Back",
                        style: TextStyle(
                            color: _currentstep <= 0
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          RichText(
              text: TextSpan(
                  text: "Already have an account? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  children: [
                TextSpan(
                    text: "Login",
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(Login.route());
                      })
              ]))
        ],
      ),
    );
  }
}
