import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  final String id;
  final String variationID;
  final int quantity;

  CartProduct({
    required this.id,
    required this.quantity,
    required this.variationID,
  });

  factory CartProduct.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CartProduct(
      id: doc.id,
      variationID: data['variant_id'] ?? "",
      quantity: data['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> getMap() {
    return {
      'productId': id,
      'variationId': variationID,
      'quantity': quantity,
    };
  }
}
