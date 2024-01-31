import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:furniverse_admin/firebasefiles/firebase_user_notification.dart';

class MessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _userCollection = FirebaseFirestore.instance.collection('users');

  Future<String?> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    return fCMToken;
  }

  Future<void> notifyUser(
      {required String userId, required String message}) async {
    final user = await _userCollection.doc(userId).get();
    final tokens = user.data()?['token'];

    if (tokens.runtimeType == String) {
      FirebaseUserNotification().sendPushMessage(message, tokens);
    } else if (tokens.runtimeType == List<dynamic>) {
      for (int i = 0; i < tokens.length; i++) {
        print(tokens[i]);
        FirebaseUserNotification().sendPushMessage(message, tokens[i]);
      }
    }
  }
}
