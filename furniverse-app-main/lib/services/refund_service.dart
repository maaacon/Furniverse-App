import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse/models/refund.dart';

class RefundService {
  final CollectionReference _refundsCollection =
      FirebaseFirestore.instance.collection('refunds');

  Future<void> addToRefunds(Refund refundRequest) async {
    try {
      Map<String, dynamic> refund = refundRequest.getMap();

      refund['timestamp'] = FieldValue.serverTimestamp();
      refund['requestStatus'] = 'Pending';

      await _refundsCollection.doc().set(refund);
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  // Future<void> removeFromRequest(String userId, String requestId) async {
  //   try {
  //     await _requestsCollection.doc(requestId).delete();
  //   } catch (e) {
  //     print('Error removing product from cart: $e');
  //   }
  // }

  // Future<void> updateQuantity(
  //     String userId, String requestId, int newQuantity) async {
  //   try {
  //     await _requestsCollection.doc(requestId).update({
  //       'quantity': newQuantity,
  //     });
  //   } catch (e) {
  //     print('Error updating product quantity in cart: $e');
  //   }
  // }

  Stream<List<Refund>> streamRefunds(String? userId) {
    return _refundsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Refund.fromFirestore(e),
              )
              .toList(),
        );
  }
}
