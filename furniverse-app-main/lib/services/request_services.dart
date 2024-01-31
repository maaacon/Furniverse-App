import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse/models/request.dart';

class RequestsService {
  final CollectionReference _requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  Future<void> addToRequest(
      {required String userId,
      required String size,
      required String material,
      required String color,
      required String others,
      required int quantity,
      required String productId,
      required double price,
      required String materialId,
      required String colorId}) async {
    try {
      await _requestsCollection.doc().set({
        'size': size,
        'material': material,
        'color': color,
        'others': others,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
        'productId': productId,
        'price': price,
        'userId': userId,
        'reqStatus': 'Pending',
        'materialId': materialId,
        'colorId': colorId,
      });
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<void> removeFromRequest(String userId, String requestId) async {
    try {
      await _requestsCollection.doc(requestId).delete();
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }

  Future<void> updateQuantity(
      String userId, String requestId, int newQuantity) async {
    try {
      await _requestsCollection.doc(requestId).update({
        'quantity': newQuantity,
      });
    } catch (e) {
      print('Error updating product quantity in cart: $e');
    }
  }

  Stream<List<CustomerRequests>> streamRequest(String? userId) {
    return _requestsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => CustomerRequests.fromFirestore(e),
              )
              .toList(),
        );
  }
}
