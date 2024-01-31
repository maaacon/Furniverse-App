import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse/models/notif.dart';

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

  Stream<List<NotificationModel>> streamNotifications(String? userId) {
    return _notificationCollection
        .doc(userId)
        .collection('notifications')
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => NotificationModel.fromFirestore(e),
              )
              .toList(),
        );
  }

  Stream<List<NotificationModel>> streamNewNotifications(String? userId) {
    return _notificationCollection
        .doc(userId)
        .collection('notifications')
        .where('isViewed', isEqualTo: false)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => NotificationModel.fromFirestore(e),
              )
              .toList(),
        );
  }

  Future<void> updateNotificationsToRead(String? userId) async {
    final unreadNotifs = _notificationCollection
        .doc(userId)
        .collection('notifications')
        .where('isViewed', isEqualTo: false);

    // Get the documents that match the query
    final querySnapshot = await unreadNotifs.get();

    // Update each document's 'isViewed' field to true
    for (final doc in querySnapshot.docs) {
      await _notificationCollection
          .doc(userId)
          .collection('notifications')
          .doc(doc.id)
          .update({'isViewed': true});
    }
  }
}
