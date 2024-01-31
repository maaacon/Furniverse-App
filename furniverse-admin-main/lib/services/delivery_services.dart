import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/delivery_model.dart';

class DeliveryService {
  final CollectionReference _deliveryCollection =
      FirebaseFirestore.instance.collection('delivery');

  Future<void> addDelivery(Map<String, dynamic> deliveryData) async {
    try {
      final colorTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      deliveryData['timestamp'] =
          colorTimestamp; // Add the timestamp to your data
      DocumentReference productDocRef =
          await _deliveryCollection.add(deliveryData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> deleteDelivery(String deliveryId) async {
    try {
      // delete file in firestorage

      await _deliveryCollection.doc(deliveryId).delete();
    } catch (e) {
      print('Error deleting material: $e');
    }
  }

  Stream<DocumentSnapshot<Object?>> editDelivery(String deliveryId) {
    // delete file in firestorage
    return _deliveryCollection.doc(deliveryId).snapshots();
  }

  Future<void> updateDelivery(
      Map<String, dynamic> deliveryData, String deliveryId) async {
    try {
      final materialTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      deliveryData['timestamp'] =
          materialTimestamp; // Add the timestamp to your data

      await _deliveryCollection.doc(deliveryId).set(deliveryData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> reducedQuantity(List<dynamic> color) async {
    try {
      // await _materialsCollection
      //     .doc(materialId)
      //     .update({'quantity': FieldValue.increment(-quantity)});
      // print(materials);
      if (color[0]['deliverylId'] == "") return;
      for (var material in color) {
        DocumentSnapshot doc =
            await _deliveryCollection.doc(material['deliveryId']).get();
        Map data = doc.data() as Map;
        var variants = data['variants'];
        List<Map> newVariants = [];
        for (var variant in variants) {
          if (variant['id'] == material['variationId']) {
            variant['stocks'] = variant['stocks'] - material['quantity'];
          }
          newVariants.add(variant);
        }
        await _deliveryCollection
            .doc(material['deliveryId'])
            .update({'variants': newVariants});
        // .update({'quantity': FieldValue.increment(-quantity)});
      }
    } catch (e) {
      print('Error updating material quantity: $e');
    }
  }

  Future<void> addQuantity(List<dynamic> color) async {
    try {
      // await _materialsCollection
      //     .doc(materialId)
      //     .update({'quantity': FieldValue.increment(-quantity)});
      // print(materials);
      if (color[0]['materialId'] == "") return;
      for (var material in color) {
        DocumentSnapshot doc =
            await _deliveryCollection.doc(material['materialId']).get();
        Map data = doc.data() as Map;
        var variants = data['variants'];
        List<Map> newVariants = [];
        for (var variant in variants) {
          if (variant['id'] == material['variationId']) {
            variant['stocks'] = variant['stocks'] + material['quantity'];
          }
          newVariants.add(variant);
        }
        await _deliveryCollection
            .doc(material['materialId'])
            .update({'variants': newVariants});
        // .update({'quantity': FieldValue.increment(-quantity)});
      }
    } catch (e) {
      print('Error updating material quantity: $e');
    }
  }

  // Stream<QuerySnapshot> getProductVariations(String productId) {
  //   return _materialsCollection
  //       .doc(productId)
  //       .collection('variations')
  //       .snapshots();
  // }

  // Query a subcollection
  Stream<List<Delivery>> streamDelivery() {
    return _deliveryCollection.orderBy('city').snapshots().map(
          (event) => event.docs
              .map(
                (e) => Delivery.fromFirestore(e),
              )
              .toList()
              .cast(),
        );
  }

  // Future<String?> getProductImage(String productId) async {
  //   try {
  //     DocumentSnapshot productDoc =
  //         await _materialsCollection.doc(productId).get();

  //     if (productDoc.exists) {
  //       // Check if the product document exists
  //       Map<String, dynamic> productData =
  //           productDoc.data() as Map<String, dynamic>;

  //       // Retrieve the image URL from the product data
  //       String imageUrl = productData['product_images'][0];

  //       return imageUrl;
  //     } else {
  //       // Handle the case where the product doesn't exist
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error getting product image: $e');
  //     return null;
  //   }
  // }

  // Future<String?> getProductName(String productId) async {
  //   try {
  //     DocumentSnapshot productDoc =
  //         await _materialsCollection.doc(productId).get();

  //     if (productDoc.exists) {
  //       // Check if the product document exists
  //       Map<String, dynamic> productData =
  //           productDoc.data() as Map<String, dynamic>;

  //       // Retrieve the image URL from the product data
  //       String productName = productData['product_name'];

  //       return productName;
  //     } else {
  //       // Handle the case where the product doesn't exist
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error getting product image: $e');
  //     return null;
  //   }
  // }
}