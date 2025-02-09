import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/auth/logic/background_creds.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/themes/dark.dart';
import './api/authentication_repo.dart';
import 'package:frontend/themes/light.dart';
import 'package:provider/provider.dart';
import 'features/auth/pages/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final storage = BackgroundCreds();
  Map? creds = await storage.getCreds();
  final authProvider = AuthProvider(AuthenticationModel());
  bool isLoggedin = false;
  if (creds != null) {
    isLoggedin = await authProvider.login(creds["username"], creds["password"]);
  }

  runApp(ChangeNotifierProvider<AuthProvider>.value(
    value: authProvider,
    child: MyApp(isLoggedin: isLoggedin),
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedin;
  const MyApp({super.key, required this.isLoggedin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'kanekt',
        theme: authprovider.isDarkmode ? DarkTheme.theme : LightTheme.theme,
        home: Splashscreen(isLoggedin: isLoggedin));
  }
}
