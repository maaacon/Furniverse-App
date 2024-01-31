import 'package:cloud_firestore/cloud_firestore.dart';

class Refund {
  final String? refundId;
  final String userId;
  final String productId;
  final String contactNumber;
  final String eWalletNumber;
  final String reason;
  final int quantity;
  final double totalPrice;
  final String orderId;
  final List<dynamic> images;
  final String? requestStatus;
  final String? variantId;
  final Timestamp? timestamp;

  Refund({
    this.timestamp,
    this.refundId,
    this.requestStatus,
    required this.userId,
    required this.contactNumber,
    required this.eWalletNumber,
    required this.reason,
    required this.images,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.totalPrice,
    required this.orderId,
  });

  factory Refund.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Refund(
      refundId: doc.id,
      contactNumber: data['contactNumber'] ?? "",
      eWalletNumber: data['eWalletNumber'] ?? "",
      userId: data['userId'] ?? "",
      reason: data['reason'] ?? "",
      images: data['images'] ?? [],
      productId: data['productId'] ?? "",
      variantId: data['variantId'] ?? "",
      quantity: data['quantity'] ?? 0,
      totalPrice: data['totalPrice'] ?? 0.0,
      orderId: data['orderId'] ?? "",
      requestStatus: data['requestStatus'] ?? "",
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> getMap() {
    return {
      'productId': productId,
      'contactNumber': contactNumber,
      'eWalletNumber': eWalletNumber,
      'userId': userId,
      'reason': reason,
      'images': images,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'orderId': orderId,
      'variantId': variantId,
    };
  }
}
