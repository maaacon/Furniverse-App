import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/materials_model.dart';

class MaterialsServices {
  final CollectionReference _materialsCollection =
      FirebaseFirestore.instance.collection('materials');

  Future<void> addMaterials(Map<String, dynamic> materialsData) async {
    try {
      final materialsTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      materialsData['timestamp'] =
          materialsTimestamp; // Add the timestamp to your data
      materialsData['sales'] = 0;

      await _materialsCollection.add(materialsData);
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

      await _materialsCollection.doc(materialId).update(materialData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> addStocks(String materialId, int stocks, double price) async {
    try {
      await _materialsCollection
          .doc(materialId)
          .update({'stocks': FieldValue.increment(stocks)});

      // Reference to the expense subcollection
      CollectionReference expenseSubcollection =
          _materialsCollection.doc(materialId).collection('expenses');

      // Get the current year
      int currentYear = DateTime.now().year;

      // Create a document in the expense subcollection with the current year as the document ID
      DocumentReference expenseDocRef =
          expenseSubcollection.doc('$currentYear');

      // Add your expense data here
      await expenseDocRef.set({
        'expense': FieldValue.increment(price * stocks),
        'stocks': FieldValue.increment(stocks),
      }, SetOptions(merge: true));

      print('Expense subcollection created successfully.');
    } catch (e) {
      print('Error adding stocks: $e');
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

  Future<List<Materials>> getTopMaterials() async {
    List<Materials> listMaterials = [];
    try {
      final materials =
          await _materialsCollection.orderBy("sales", descending: true).get();
      for (var material in materials.docs) {
        final mat = Materials.fromFirestore(material);
        if (mat.sales > 0) listMaterials.add(mat);
      }
    } catch (e) {
      print("Error getting top materials");
    }
    return listMaterials;
  }

  Future<List<Materials>> getAllMaterials() async {
    List<Materials> listMaterials = [];
    try {
      final materials =
          await _materialsCollection.orderBy("sales", descending: true).get();
      for (var material in materials.docs) {
        final mat = Materials.fromFirestore(material);
        listMaterials.add(mat);
      }
    } catch (e) {
      print("Error getting all materials");
    }
    return listMaterials;
  }

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
      if (materialIds.contains(material.id)) {}
      if (materialIds.contains(material.id) && material.stocks > 0) {
        specificMaterials.add(material);
      }
    }

    return specificMaterials;
  }

  Future<double> getTotalExpense(int year) async {
    double totalExpense = 0;
    // Get documents in the main collection
    QuerySnapshot mainCollectionSnapshot = await _materialsCollection.get();

    // Iterate over documents in the main collection
    for (QueryDocumentSnapshot mainDocument in mainCollectionSnapshot.docs) {
      // print('Document ID: ${mainDocument.id}');

      // Reference to the subcollection within each document
      CollectionReference subcollection =
          mainDocument.reference.collection('expenses');

      // Get documents in the subcollection
      final subcollectionSnapshot =
          await subcollection.doc(year.toString()).get();

      if (subcollectionSnapshot.data() != null) {
        final Map? data = subcollectionSnapshot.data() as Map;

        // print('  Field 1: ${data?['expense']}');
        // print('  Field 2: ${data?['stocks']}');

        totalExpense += data?['expense'];
      }
    }
    // print(totalExpense);
    return totalExpense;
  }
}
