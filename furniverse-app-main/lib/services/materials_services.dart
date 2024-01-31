import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse/models/materials_model.dart';

class MaterialsServices {
  final CollectionReference _materialsCollection =
      FirebaseFirestore.instance.collection('materials');

  Future<void> addMaterials(Map<String, dynamic> materialsData) async {
    try {
      final materialsTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      materialsData['timestamp'] =
          materialsTimestamp; // Add the timestamp to your data
      DocumentReference productDocRef =
          await _materialsCollection.add(materialsData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> deleteMaterial(String materialId) async {
    try {
      // delete file in firestorage

      await _materialsCollection.doc(materialId).delete();
    } catch (e) {
      print('Error deleting material: $e');
    }
  }

  Stream<DocumentSnapshot<Object?>> editMaterial(String materialId) {
    // delete file in firestorage
    return _materialsCollection.doc(materialId).snapshots();
  }

  Future<void> updateMaterial(
      Map<String, dynamic> materialData, String materialId) async {
    try {
      final materialTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      materialData['timestamp'] =
          materialTimestamp; // Add the timestamp to your data

      await _materialsCollection.doc(materialId).set(materialData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> reducedQuantity(String materialId, double quantity) async {
    try {
      final materials = await _materialsCollection.doc(materialId).get();
      if (materials.exists) {
        double currentStocks =
            (materials.data() as Map)['stocks'].toDouble() ?? 0;

        if (currentStocks >= quantity.ceil()) {
          await _materialsCollection
              .doc(materialId)
              .update({'stocks': FieldValue.increment(-quantity.ceil())});
        } else {
          // Handle the case where there are not enough stocks
          print('Not enough stocks available for Material Id: $materialId.');
        }

        await _materialsCollection
            .doc(materialId)
            .update({'sales': FieldValue.increment(1)});
      } else {
        print("Material Id: $materialId does not exist.");
      }
    } catch (e) {
      print('Error updating color quantity: $e');
    }
  }

  Future<void> addQuantity(String materialId, double quantity) async {
    try {
      final materials = await _materialsCollection.doc(materialId).get();
      if (materials.exists) {
        await _materialsCollection
            .doc(materialId)
            .update({'stocks': FieldValue.increment(quantity.ceil())});

        int sales = (materials.data() as Map)['sales'] ?? 0;
        if (sales > 0) {
          await _materialsCollection
              .doc(materialId)
              .update({'sales': FieldValue.increment(-1)});
        }
      } else {
        print("Material Id: $materialId does not exist.");
      }
    } catch (e) {
      print('Error updating color quantity: $e');
    }
  }

  Stream<QuerySnapshot> getAllmaterials() {
    return _materialsCollection.snapshots();
  }

  // Stream<QuerySnapshot> getProductVariations(String productId) {
  //   return _materialsCollection
  //       .doc(productId)
  //       .collection('variations')
  //       .snapshots();
  // }

  // Query a subcollection
  Stream<List<Materials>> streamMaterials() {
    return _materialsCollection.orderBy('material').snapshots().map(
          (event) => event.docs
              .map(
                (e) => Materials.fromFirestore(e),
              )
              .toList()
              .cast(),
        );
  }

  Future<List<Materials>> getSpecificMaterialsById(
      List<String> materialIds) async {
    final docRef =
        await _materialsCollection.orderBy('sales', descending: true).get();

    List<Materials> specificMaterials = [];

    for (var docSnapshot in docRef.docs) {
      final material = Materials.fromFirestore(docSnapshot);
      if (materialIds.contains(material.id) && material.stocks > 0) {
        specificMaterials.add(material);
      }
    }

    return specificMaterials;
  }
}
