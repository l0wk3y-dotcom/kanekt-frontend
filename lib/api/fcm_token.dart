import 'package:firebase_messaging/firebase_messaging.dart';

class FcmToken {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initializeMessaging() async {
    _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print("This is what i got $token");
    return token;
  }
}
