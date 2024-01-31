import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/refund.dart';

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
  Future<void> acceptRefund(String refundId) async {
    try {
      await _refundsCollection.doc(refundId).update({
        'requestStatus': 'Accepted',
      });
    } catch (e) {
      print('Error updating product quantity in cart: $e');
    }
  }

  Future<void> rejectRefund(String refundId) async {
    try {
      await _refundsCollection.doc(refundId).update({
        'requestStatus': 'Rejected',
      });
    } catch (e) {
      print('Error updating product quantity in cart: $e');
    }
  }

  Stream<List<Refund>> streamRefunds() {
    return _refundsCollection
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

  Stream<List<Refund>> streamRefundsPerYear(int year) {
    DateTime startOfYear = DateTime(year, 1, 1);
    DateTime endOfYear = DateTime(year + 1, 1, 1);
    return _refundsCollection
        .where('timestamp', isGreaterThanOrEqualTo: startOfYear)
        .where('timestamp', isLessThan: endOfYear)
        .where('requestStatus', isEqualTo: 'Accepted')
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

  Future<List<Refund>> getRefundByRange(
      DateTime fromDate, DateTime toDate) async {
    List<Refund> listOrders = [];
    final orders = await _refundsCollection
        .where('timestamp', isGreaterThanOrEqualTo: fromDate)
        .where('timestamp', isLessThan: toDate)
        .orderBy('timestamp', descending: true)
        .get();

    for (var order in orders.docs) {
      listOrders.add(Refund.fromFirestore(order));
    }
    return listOrders;
  }
}
