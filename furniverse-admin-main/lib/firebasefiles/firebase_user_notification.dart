import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FirebaseUserNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    final fCMToken = await _firebaseMessaging.getToken();

    print("Token : $fCMToken");
  }

  void sendPushMessage(String? status, String? token) async {
    if (status == "Processing") {
      try {
        http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAA7Fr8y94:APA91bGT9J0N4ItLzBNd529w2kdUe7KdVt5hUw6USxIvEGUtKDL_wK1FidLwd51SE_xmdwr8HyS4O_DrajSuUgojtdSZ5ciwWAnvJRkVLHykMQ-XJSd2tsO4rizmVAbyVRtqRd-aVNQP'
            },
            body: jsonEncode(<String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
              },
              "notification": <String, dynamic>{
                "title": "Your order has been confirmed",
                "body":
                    "Seller has confirmed your order! Please expect your item to be shipped within 5-7 days."
              },
              "to": token
            }));
      } catch (e) {}
    } else if (status == "On Delivery") {
      try {
        http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAA7Fr8y94:APA91bGT9J0N4ItLzBNd529w2kdUe7KdVt5hUw6USxIvEGUtKDL_wK1FidLwd51SE_xmdwr8HyS4O_DrajSuUgojtdSZ5ciwWAnvJRkVLHykMQ-XJSd2tsO4rizmVAbyVRtqRd-aVNQP'
            },
            body: jsonEncode(<String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
              },
              "notification": <String, dynamic>{
                "title": "Your order is now being shipped",
                "body":
                    "Please expect your item to be delivered in the next few day/s."
              },
              "to": token
            }));
      } catch (e) {}
    } else if (status == "Delivered") {
      try {
        http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAA7Fr8y94:APA91bGT9J0N4ItLzBNd529w2kdUe7KdVt5hUw6USxIvEGUtKDL_wK1FidLwd51SE_xmdwr8HyS4O_DrajSuUgojtdSZ5ciwWAnvJRkVLHykMQ-XJSd2tsO4rizmVAbyVRtqRd-aVNQP'
            },
            body: jsonEncode(<String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
              },
              "notification": <String, dynamic>{
                "title": "Your order has been shipped successfully.",
                "body": "Thank you for purchasing."
              },
              "to": token
            }));
      } catch (e) {}
    } else if (status?.toUpperCase() == "Cancelled".toUpperCase()) {
      try {
        http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAA7Fr8y94:APA91bGT9J0N4ItLzBNd529w2kdUe7KdVt5hUw6USxIvEGUtKDL_wK1FidLwd51SE_xmdwr8HyS4O_DrajSuUgojtdSZ5ciwWAnvJRkVLHykMQ-XJSd2tsO4rizmVAbyVRtqRd-aVNQP'
            },
            body: jsonEncode(<String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
              },
              "notification": <String, dynamic>{
                "title": "Your order # has been cancelled by the seller",
                "body":
                    "Your order # has been canceled by the seller. Please click here for more details."
              },
              "to": token
            }));
      } catch (e) {}
    }
  }
}
