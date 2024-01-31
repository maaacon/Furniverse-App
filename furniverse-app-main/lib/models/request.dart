import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerRequests {
  final String id;
  final String userId;
  final String size;
  final String material;
  final String materialId;
  final double materialQuantity;
  final String color;
  final String colorId;
  final double colorQuantity;
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
    required this.materialId,
    required this.colorId,
    required this.colorQuantity,
    required this.materialQuantity,
  });

  factory CustomerRequests.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CustomerRequests(
      id: doc.id,
      size: data['size'] ?? "",
      material: data['material'] ?? "",
      color: data['color'] ?? "",
      materialId: data['materialId'] ?? "",
      colorId: data['colorId'] ?? "",
      others: data['others'] ?? "",
      reqquantity: data['quantity'] ?? 1,
      productId: data['productId'] ?? "",
      price: data['price']?.toDouble(),
      userId: data['userId'] ?? "",
      reqStatus: data['reqStatus'] ?? "",
      colorQuantity: data['colorQuantity'] ?? 0,
      materialQuantity: data['materialQuantity'] ?? 0,
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
      'colorId': colorId,
      'materialId': materialId,
      'colorQuantity': colorQuantity,
      'materialQuantity': materialQuantity,
    };
  }
}
