import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/request.dart';

class RequestsService {
  final CollectionReference _requestsCollection =
      FirebaseFirestore.instance.collection('requests');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addToRequest(
      {required String userId,
      required String size,
      required String material,
      required String color,
      required String others,
      required int quantity,
      required String productId}) async {
    try {
      await _requestsCollection.doc(userId).collection('items').doc().set({
        'size': size,
        'material': material,
        'color': color,
        'others': others,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
        'productId': productId,
        'price': null,
      });
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<void> removeFromRequest(String userId, String requestId) async {
    try {
      await _requestsCollection
          .doc(userId)
          .collection('items')
          .doc(requestId)
          .delete();
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }

  Future<void> clearRequest(String userId) async {
    try {
      // Get a reference to the "items" subcollection within the user's cart document
      final itemsCollection =
          _requestsCollection.doc(userId).collection('items');

      // Get all documents in the "items" subcollection
      final itemsQuerySnapshot = await itemsCollection.get();

      // Iterate through the documents and delete each one
      for (final itemDoc in itemsQuerySnapshot.docs) {
        await itemDoc.reference.delete();
      }
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }

  // Future<void> updateQuantity(
  //     String userId, String requestId, int newQuantity) async {
  //   try {
  //     await _requestsCollection
  //         .doc(userId)
  //         .collection('items')
  //         .doc(requestId)
  //         .update({
  //       'quantity': newQuantity,
  //     });
  //   } catch (e) {
  //     print('Error updating product quantity in cart: $e');
  //   }
  // }

  Future<void> acceptRequest(String requestId, double newPrice) async {
    try {
      await _requestsCollection.doc(requestId).update({
        'price': newPrice,
        'reqStatus': 'Accepted',
      });
    } catch (e) {
      print('Error updating product quantity in cart: $e');
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      await _requestsCollection.doc(requestId).update({
        'reqStatus': 'Rejected',
      });
    } catch (e) {
      print('Error updating product quantity in cart: $e');
    }
  }

  Stream<List<CustomerRequests>> streamRequests() {
    return _requestsCollection
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

  Stream<CustomerRequests> streamRequest(String requestId) {
    return _db.collection('requests').doc(requestId).snapshots().map(
        (event) => CustomerRequests.fromMap(event.data() ?? {}, requestId));
  }
}
