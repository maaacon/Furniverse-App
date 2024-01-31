import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String userId;
  final String? orderId;
  final String notifTitle;
  final String notifSubtitle;
  final String? notifImage;
  final bool isViewed;

  NotificationModel(
      {required this.userId,
      this.orderId,
      required this.notifTitle,
      required this.notifSubtitle,
      this.notifImage,
      required this.isViewed});

  Map<String, dynamic> getMap() {
    return {
      'userId': userId,
      'orderId': orderId,
      'notifTitle': notifTitle,
      'notifSubtitle': notifSubtitle,
      'notifImage': notifImage,
      'isViewed': isViewed,
    };
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      userId: data['userId'] ?? "",
      orderId: data['orderId'] ?? "",
      notifTitle: data['notifTitle'] ?? "",
      notifSubtitle: data['notifSubtitle'] ?? "",
      notifImage: data['notifImage'],
      isViewed: data['isViewed'] ?? "",
    );
  }
}
