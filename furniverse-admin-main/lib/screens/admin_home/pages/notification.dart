import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppNotification extends StatefulWidget {
  const AppNotification({super.key});

  @override
  State<AppNotification> createState() => _AppNotificationState();
}

class _AppNotificationState extends State<AppNotification> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: (){sendPushMessage();}, child: const Text("sample"))],
      ),
    );
  }

  void sendPushMessage() async {
    try {
      http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type' : 'application/json',
          'Authorization' : 'key=AAAA7Fr8y94:APA91bGT9J0N4ItLzBNd529w2kdUe7KdVt5hUw6USxIvEGUtKDL_wK1FidLwd51SE_xmdwr8HyS4O_DrajSuUgojtdSZ5ciwWAnvJRkVLHykMQ-XJSd2tsO4rizmVAbyVRtqRd-aVNQP'
        },

        body: jsonEncode(
          <String, dynamic> {
            'priority' : 'high',
            'data' : <String, dynamic> {
              'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
              'status' : 'done',
              'body' : "sample",
              'title' :"sample",
            },

            "notification" : <String, dynamic>{
              "title": "hahaha",
              "body" : "hehehe"
            },

            "to" : "d_DK1BGdSmGhcJ4lmcrU7M:APA91bGms1-yMf1Wfhg7TfWGhDU6CXmMErZ02-Vf-G8B00zsa9-38N47tnxcY7vR6RqfSN0c1vf--5GUvnZXmzWb6HyKDViGFv5PHQgezwkf9rq9gL8RzT5ii-yE33g28iG66yEJfrVV"
          }
        )
      );
    } catch (e) {
      
    }
  }
}