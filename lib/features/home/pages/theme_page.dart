import 'package:flutter/material.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (context) => const ThemePage());
  }

  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Theme",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            secondary: Icon(
              Icons.sunny,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            value: authprovider.isDarkmode,
            onChanged: (value) {
              setState(() {
                authprovider.toggleTheme();
              });
            },
            title: Text(
              "Toggle theme",
              style: TextStyle(
                  fontSize: 25, color: Theme.of(context).colorScheme.primary),
            ),
          )
        ],
      ),
    );
  }
}
