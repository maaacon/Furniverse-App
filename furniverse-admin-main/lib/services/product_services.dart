import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/products.dart';

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final productTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      productData['timestamp'] =
          productTimestamp; // Add the timestamp to your data
      DocumentReference productDocRef =
          await _productsCollection.add(productData);

      // for (int i = 0; i < productVariations.length; i++) {
      //   await productDocRef.collection('variants').add(productVariations[i]);
      // }
    } catch (e) {
      print('Error adding a product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      // delete file in firestorage

      await _productsCollection.doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Stream<DocumentSnapshot<Object?>> editProduct(String productId) {
    // delete file in firestorage
    return _productsCollection.doc(productId).snapshots();
  }

  Future<void> updateProduct(
      Map<String, dynamic> productData, String productId) async {
    try {
      final productTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      productData['timestamp'] =
          productTimestamp; // Add the timestamp to your data

      await _productsCollection.doc(productId).set(productData);
    } catch (e) {
      print('Error adding a product: $e');
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
      print('Error updating product quantity: $e');
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

  Future<List<Product>> getAllProducts() async {
    List<Product> listProducts = [];
    try {
      final products = await _productsCollection.get();
      for (var product in products.docs) {
        final prod = Product.fromFirestore(product);
        listProducts.add(prod);
      }
    } catch (e) {
      print("Error getting all products:$e");
    }

    return listProducts;
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

  Future<String?> getProductImage(String productId) async {
    try {
      DocumentSnapshot productDoc =
          await _productsCollection.doc(productId).get();

      if (productDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> productData =
            productDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        String imageUrl = productData['product_images'][0];

        return imageUrl;
      } else {
        // Handle the case where the product doesn't exist
        return null;
      }
    } catch (e) {
      print('Error getting product image: $e');
      return null;
    }
  }

  Future<String?> getProductName(String productId) async {
    try {
      DocumentSnapshot productDoc =
          await _productsCollection.doc(productId).get();

      if (productDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> productData =
            productDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        String productName = productData['product_name'];

        return productName;
      } else {
        // Handle the case where the product doesn't exist
        return null;
      }
    } catch (e) {
      print('Error getting product image: $e');
      return null;
    }
  }
}
