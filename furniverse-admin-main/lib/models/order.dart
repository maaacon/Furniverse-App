import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final Timestamp orderDate;
  final List<dynamic> products;
  final double totalPrice;
  final String shippingAddress;
  final String shippingProvince;
  final String shippingMethod;
  final String shippingStatus;
  final Timestamp completedDate;
  final Map requestDetails;
  final String shippingCity;
  final String shippingStreet;
  final String shippingZipCode;
  final String reason;
  final double shippingFee;

  OrderModel({
    required this.userId,
    required this.orderDate,
    required this.products,
    required this.totalPrice,
    required this.shippingAddress,
    required this.shippingMethod,
    required this.completedDate,
    required this.shippingStatus,
    required this.orderId,
    required this.requestDetails,
    required this.shippingProvince,
    required this.shippingCity,
    required this.shippingStreet,
    required this.shippingZipCode,
    required this.reason,
    required this.shippingFee,
  });

  factory OrderModel.fromMap(Map data, String orderId) {
    return OrderModel(
      orderId: orderId,
      userId: data['userId'] ?? "",
      completedDate: data['completedDate'] ?? Timestamp.now(),
      orderDate: data['orderDate'] ?? Timestamp.now(),
      shippingAddress: data['shippingAddress'] ?? "",
      shippingMethod: data['shippingMethod'] ?? "",
      shippingStatus: data['shippingStatus'] ?? "",
      totalPrice: data['totalPrice'] ?? 0.0,
      products: data['products'] ?? [],
      requestDetails: data['requestDetails'] ?? {},
      shippingProvince: data['shippingProvince'] ?? "",
      shippingCity: data['shippingCity'] ?? '',
      shippingStreet: data['shippingStreet'] ?? '',
      shippingZipCode: data['shippingZipCode'] ?? '',
      reason: data['reason'] ?? "",
      shippingFee: data['shippingFee'] ?? 0,
    );
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      orderId: doc.id,
      userId: data['userId'] ?? "",
      completedDate: data['completedDate'] ?? Timestamp.now(),
      orderDate: data['orderDate'] ?? Timestamp.now(),
      shippingAddress: data['shippingAddress'] ?? "",
      shippingMethod: data['shippingMethod'] ?? "",
      shippingStatus: data['shippingStatus'] ?? "",
      totalPrice: data['totalPrice'] ?? 0.0,
      products: data['products'] ?? [],
      requestDetails: data['requestDetails'] ?? {},
      shippingProvince: data['shippingProvince'] ?? "",
      shippingCity: data['shippingCity'] ?? '',
      shippingStreet: data['shippingStreet'] ?? '',
      shippingZipCode: data['shippingZipCode'] ?? '',
      reason: data['reason'] ?? "",
      shippingFee: data['shipingFee'] ?? 0,
    );
  }
}
