import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BackgroundCreds {
  final storage = const FlutterSecureStorage();
  Future<void> saveCreds(String username, String password) async {
    await storage.write(key: "username", value: username);
    await storage.write(key: "password", value: password);
  }

  Future<void> removeCreds() async {
    await storage.delete(key: "username");
    await storage.delete(key: "password");
  }

  Future<Map?> getCreds() async {
    final username = await storage.read(key: "username");
    final password = await storage.read(key: "password");
    if (username != null && password != null) {
      return {"username": username, "password": password};
    } else {
      return null;
    }
  }
}
