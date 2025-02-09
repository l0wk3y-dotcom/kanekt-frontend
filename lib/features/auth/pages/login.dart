import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_snackbar.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/home/pages/homepage.dart';
import 'package:frontend/features/auth/pages/signup.dart';
import 'package:frontend/features/auth/pages/widgets/auth_button.dart';
import 'package:frontend/features/auth/pages/widgets/authinout.dart';
import 'package:frontend/features/auth/pages/widgets/widget_const.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) {
        return const Login();
      });
  const Login({super.key});

  @override
  State<Login> createState() => _SignupState();
}

class _SignupState extends State<Login> {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final appbar = UIConstants.authAppbar();

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authprov = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: appbar,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Authinput(hint: "username", customController: usernamecontroller),
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
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: AuthButton(
                    onTap: () async {
                      final username = usernamecontroller.text.trim();
                      final password = passwordcontroller.text.trim();
                      try {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Center(
                                child: Container(
                                  height: 100,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                  child: Scaffold(
                                    body: Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Logging in",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 20,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          SizedBox(
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
                        bool isLoggedin =
                            await authprov.login(username, password);
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        isLoggedin
                            ? Navigator.pushReplacement(
                                context, HomeNavigation.route())
                            : ScaffoldMessenger.of(context)
                                .showSnackBar(customSnackbar("Login Failed"));
                      } on Exception {
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(customSnackbar("Login Failed"));
                      }
                    },
                    label: "Login",
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    fontcolor: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 10),
              RichText(
                  text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                      children: [
                    TextSpan(
                        text: "Sign up",
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(Signup.route());
                          })
                  ]))
            ],
          ),
        ));
  }
}
