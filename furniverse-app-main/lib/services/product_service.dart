import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse/models/product.dart';

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final productTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      productData['timestamp'] =
          productTimestamp; // Add the timestamp to your data
      await _productsCollection.add(productData);
    } catch (e) {
      print('Error adding a product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future<void> reducedQuantity(List<dynamic> products) async {
    try {
      if (products[0]['productId'] == "") return;
      for (var product in products) {
        DocumentSnapshot doc =
            await _productsCollection.doc(product['productId']).get();
        Map data = doc.data() as Map;
        var variants = data['variants'];
        List<Map> newVariants = [];
        for (var variant in variants) {
          if (variant['id'] == product['variationId']) {
            variant['stocks'] = variant['stocks'] - product['quantity'];
          }
          newVariants.add(variant);
        }
        await _productsCollection
            .doc(product['productId'])
            .update({'variants': newVariants});
      }
    } catch (e) {
      print('Error reducing product quantity: $e');
    }
  }

  Future<void> addQuantity(List<dynamic> products) async {
    try {
      if (products[0]['productId'] == "") return;
      for (var product in products) {
        DocumentSnapshot doc =
            await _productsCollection.doc(product['productId']).get();
        Map data = doc.data() as Map;
        var variants = data['variants'];
        List<Map> newVariants = [];
        for (var variant in variants) {
          if (variant['id'] == product['variationId']) {
            variant['stocks'] = variant['stocks'] + product['quantity'];
          }
          newVariants.add(variant);
        }
        await _productsCollection
            .doc(product['productId'])
            .update({'variants': newVariants});
      }
    } catch (e) {
      print('Error updating product quantity: $e');
    }
  }

  Future<double> getVariantPrice(String productId, String variantId) async {
    try {
      DocumentSnapshot snapshot =
          await _productsCollection.doc(productId).get();

      if (snapshot.exists) {
        Map<String, dynamic> productData =
            snapshot.data() as Map<String, dynamic>;

        for (Map<String, dynamic> variant in productData['variants']) {
          if (variant['id'] == variantId) {
            return variant['price'].toDouble();
          }
        }
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Stream<QuerySnapshot> getAllProducts() {
    return _productsCollection.snapshots();
  }

  Stream<QuerySnapshot> getProductVariations(String productId) {
    return _productsCollection
        .doc(productId)
        .collection('variations')
        .snapshots();
  }

  // Query a subcollection
  Stream<List<Product>> streamProducts() {
    return _productsCollection.orderBy('product_name').snapshots().map(
          (event) => event.docs
              .map(
                (e) => Product.fromFirestore(e),
              )
              .toList()
              .cast(),
        );
  }

  Stream<Product> streamProduct(String? productId) {
    return _db
        .collection('products')
        .doc(productId ?? "")
        .snapshots()
        .map((event) => Product.fromMap(event.data() ?? {}, productId ?? ""));
  }
}
