import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse/models/order.dart';
import 'package:furniverse/services/color_services.dart';
import 'package:furniverse/services/materials_services.dart';
import 'package:furniverse/services/product_service.dart';

class OrderService {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> placeOrder(Map<String, dynamic> orderData) async {
    try {
      await _ordersCollection.add(orderData);

      if (!orderData['requestDetails'].isEmpty) {
        try {
          var requestDetails = orderData['requestDetails'];

          await ColorService().reducedQuantity(
              requestDetails['colorId'], requestDetails['colorQuantity']);
          await MaterialsServices().reducedQuantity(
            requestDetails['materialId'],
            requestDetails['materialQuantity'],
          );
        } catch (e) {
          print('Error reducing resource (material/color) stocks: $e');
        }
      } else {
        try {
          await ProductService().reducedQuantity(orderData['products']);
        } catch (e) {
          print('Error reducing furniture stocks: $e');
        }
      }
    } catch (e) {
      print('Error placing an order: $e');
    }
  }

  Future<void> updateStatus(
      String orderId, String newStatus, String reason) async {
    try {
      await _ordersCollection
          .doc(orderId)
          .update({'shippingStatus': newStatus, 'reason': reason});
      try {
        final result = await _ordersCollection.doc(orderId).get();
        if (result['requestDetails'].isEmpty) {
          try {
            ProductService().addQuantity(result['products']);
          } catch (e) {
            print('Error adding product stocks to database: $e');
          }
        } else {
          final requestDetails = result['requestDetails'];
          try {
            ColorService().addQuantity(
                requestDetails['colorId'], requestDetails['colorQuantity']);
            MaterialsServices().addQuantity(
              requestDetails['materialId'],
              requestDetails['materialQuantity'],
            );
          } catch (e) {
            print('Error adding resource stocks to database: $e');
          }
        }
      } catch (e) {
        print('Error getting order from database: $e');
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _ordersCollection.where('userId', isEqualTo: userId).snapshots();
  }

  Stream<List<OrderModel>> streamOrders(String? userId) {
    return _ordersCollection
        .orderBy('orderDate', descending: true)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) {
                return OrderModel.fromFirestore(e);
              },
            )
            .toList()
            .cast());
  }

  Stream<OrderModel> streamOrder(String orderId) {
    return _db
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((event) => OrderModel.fromMap(event.data() ?? {}, orderId));
  }
}
