class NotificationModel {
  final String userId;
  final String orderId;
  final String notifTitle;
  final String notifSubtitle;
  final String? notifImage;
  final bool isViewed;

  NotificationModel(
      {required this.userId,
      required this.orderId,
      required this.notifTitle,
      required this.notifSubtitle,
      required this.notifImage,
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
}
