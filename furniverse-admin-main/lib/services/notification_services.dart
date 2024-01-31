import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/notification.dart';

class NotificationService {
  final CollectionReference _notificationCollection =
      FirebaseFirestore.instance.collection('notifications');

  Future<void> addNotification(NotificationModel notification) async {
    try {
      Map<String, dynamic> notifMap = notification.getMap();
      notifMap['timeStamp'] = FieldValue.serverTimestamp();

      await _notificationCollection
          .doc(notification.userId)
          .collection('notifications')
          .add(notifMap);
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }
}
