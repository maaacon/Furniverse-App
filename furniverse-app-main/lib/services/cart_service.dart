import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse/models/cart.dart';

class CartService {
  final CollectionReference _cartsCollection =
      FirebaseFirestore.instance.collection('carts');

  final db = FirebaseFirestore.instance;

  Future<void> addToCart(
      {required String userId,
      required String productID,
      required int quantity,
      required String variantID}) async {
    try {
      // check if product is already in cart

      final docRef =
          _cartsCollection.doc(userId).collection("items").doc(productID);
      docRef.get().then(
        (DocumentSnapshot doc) {
          // ...

          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;

            _cartsCollection
                .doc(userId)
                .collection('items')
                .doc(productID)
                .set({
              'product_id': productID,
              'quantity': quantity + data['quantity'],
              'variant_id': variantID,
              'timestamp': FieldValue.serverTimestamp(),
            });
          } else {
            _cartsCollection
                .doc(userId)
                .collection('items')
                .doc(productID)
                .set({
              'product_id': productID,
              'quantity': quantity,
              'variant_id': variantID,
              'timestamp': FieldValue.serverTimestamp(),
            });
          }
        },
        onError: (e) => print("Error getting document: $e"),
      );

      // await _cartsCollection
      //     .doc(userId)
      //     .collection('items')
      //     .doc(productID)
      //     .set({
      //   'product_id': productID,
      //   'quantity': quantity,
      //   'variant_id': variantID,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      await _cartsCollection
          .doc(userId)
          .collection('items')
          .doc(productId)
          .delete();
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      // Get a reference to the "items" subcollection within the user's cart document
      final itemsCollection = _cartsCollection.doc(userId).collection('items');

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

  Future<void> updateQuantity(
      String userId, String productId, int newQuantity) async {
    try {
      await _cartsCollection
          .doc(userId)
          .collection('items')
          .doc(productId)
          .update({
        'quantity': newQuantity,
      });
    } catch (e) {
      print('Error updating product quantity in cart: $e');
    }
  }

  Stream<List<CartProduct>> streamCart(String? userId) {
    return _cartsCollection
        .doc(userId)
        .collection('items')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => CartProduct.fromFirestore(e),
              )
              .toList(),
        );
  }
}
