import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerRequests {
  final String id;
  final String userId;
  final String size;
  final String material;
  final String color;
  final String others;
  final int reqquantity;
  final String productId;
  final double? price;
  final String reqStatus;

  CustomerRequests({
    required this.id,
    required this.size,
    required this.material,
    required this.color,
    required this.others,
    required this.reqquantity,
    required this.productId,
    required this.price,
    required this.userId,
    required this.reqStatus,
  });

  factory CustomerRequests.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CustomerRequests(
      id: doc.id,
      size: data['size'] ?? "",
      material: data['material'] ?? "",
      color: data['color'] ?? "",
      others: data['others'] ?? "",
      reqquantity: data['quantity'] ?? 1,
      productId: data['productId'] ?? "",
      price: data['price']?.toDouble(),
      userId: data['userId'] ?? "",
      reqStatus: data['reqStatus'] ?? "",
    );
  }

  Map<String, dynamic> getMap() {
    return {
      'productId': id,
      'size': size,
      'material': material,
      'color': color,
      'others': others,
      'quantity': reqquantity,
      'price': price,
      'userId': userId,
      'reqStatus': reqStatus,
    };
  }

  // from map, single query
  factory CustomerRequests.fromMap(Map data, String requestId) {
    return CustomerRequests(
      id: requestId,
      size: data['size'] ?? "",
      material: data['material'] ?? "",
      color: data['color'] ?? "",
      others: data['others'] ?? "",
      reqquantity: data['quantity'] ?? 1,
      productId: data['productId'] ?? "",
      price: data['price']?.toDouble(),
      userId: data['userId'] ?? "",
      reqStatus: data['reqStatus'] ?? "",
    );
  }
}
