import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/color_model.dart';
import 'package:furniverse_admin/models/resource_expense_model.dart';

class ExpenseService {
  final CollectionReference _expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  Future<void> addExpense(ResourceExpenseModel expenses) async {
    try {
      final expenseMap = expenses.getMap();
      expenseMap['timestamp'] = FieldValue.serverTimestamp();

      await _expenseCollection.add(expenseMap);
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<double> getMaterialExpenseByRange(
      DateTime fromDate, DateTime toDate) async {
    double expense = 0;
    final expenses = await _expenseCollection
        .where('timestamp', isGreaterThanOrEqualTo: fromDate)
        .where('timestamp', isLessThan: toDate)
        .where('isMaterial', isEqualTo: true)
        .get();

    for (var exp in expenses.docs) {
      expense += (exp.data() as Map)['expense'];
    }
    return expense;
  }

  Future<double> getColorExpenseByRange(
      DateTime fromDate, DateTime toDate) async {
    double expense = 0;
    final expenses = await _expenseCollection
        .where('timestamp', isGreaterThanOrEqualTo: fromDate)
        .where('timestamp', isLessThan: toDate)
        .where('isColor', isEqualTo: true)
        .get();

    for (var exp in expenses.docs) {
      expense += (exp.data() as Map)['expense'];
    }
    return expense;
  }

  //TODO: delete
  Future<void> deleteColor(String colorId) async {
    try {
      // delete file in firestorage

      await _expenseCollection.doc(colorId).delete();
    } catch (e) {
      print('Error deleting material: $e');
    }
  }

  Stream<DocumentSnapshot<Object?>> editColor(String colorId) {
    // delete file in firestorage
    return _expenseCollection.doc(colorId).snapshots();
  }

  Future<void> updateColor(
      Map<String, dynamic> colorData, String colorId) async {
    try {
      final materialTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      colorData['timestamp'] =
          materialTimestamp; // Add the timestamp to your data

      await _expenseCollection.doc(colorId).update(colorData);
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> addStocks(String colorId, int stocks, double price) async {
    try {
      await _expenseCollection
          .doc(colorId)
          .update({'stocks': FieldValue.increment(stocks)});

      // Reference to the expense subcollection
      CollectionReference expenseSubcollection =
          _expenseCollection.doc(colorId).collection('expenses');

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

  Future<double> getTotalExpense(int year) async {
    double totalExpense = 0;
    // Get documents in the main collection
    QuerySnapshot mainCollectionSnapshot = await _expenseCollection.get();

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

  Future<void> reducedQuantity(String colorId, double quantity) async {
    try {
      final colors = await _expenseCollection.doc(colorId).get();
      if (colors.exists) {
        double currentStocks = (colors.data() as Map)['stocks'].toDouble() ?? 0;

        if (currentStocks >= quantity.ceil()) {
          await _expenseCollection
              .doc(colorId)
              .update({'stocks': FieldValue.increment(-quantity)});
          // .update({'stocks': FieldValue.increment(-quantity.ceil())});
        } else {
          // Handle the case where there are not enough stocks
          print('Not enough stocks available for ColorId: $colorId.');
        }

        await _expenseCollection
            .doc(colorId)
            .update({'sales': FieldValue.increment(1)});
      } else {
        print("Color Id: $colorId does not exist.");
      }
    } catch (e) {
      print('Error updating color quantity: $e');
    }
  }

  Future<void> addQuantity(String colorId, double quantity) async {
    try {
      final colors = await _expenseCollection.doc(colorId).get();
      if (colors.exists) {
        await _expenseCollection
            .doc(colorId)
            .update({'stocks': FieldValue.increment(quantity)});
        // .update({'stocks': FieldValue.increment(quantity.ceil())});

        int sales = (colors.data() as Map)['sales'] ?? 0;
        if (sales > 0) {
          await _expenseCollection
              .doc(colorId)
              .update({'sales': FieldValue.increment(-1)});
        }
      } else {
        print("Color Id: $colorId does not exist.");
      }
    } catch (e) {
      print('Error updating color quantity: $e');
    }
  }

  // Query a subcollection
  Stream<List<ColorModel>> streamColor() {
    return _expenseCollection.orderBy('color').snapshots().map(
          (event) => event.docs
              .map(
                (e) => ColorModel.fromFirestore(e),
              )
              .toList()
              .cast(),
        );
  }

  Future<List<ColorModel>> getTopColors() async {
    List<ColorModel> listColors = [];
    try {
      final colors =
          await _expenseCollection.orderBy("sales", descending: true).get();
      for (var color in colors.docs) {
        final col = ColorModel.fromFirestore(color);
        if (col.sales > 0) listColors.add(col);
      }
    } catch (e) {
      print("Error getting top colors:$e");
    }

    return listColors;
  }

  Future<List<ColorModel>> getAllColors() async {
    List<ColorModel> listColors = [];
    try {
      final colors =
          await _expenseCollection.orderBy("sales", descending: true).get();
      for (var color in colors.docs) {
        final col = ColorModel.fromFirestore(color);
        listColors.add(col);
      }
    } catch (e) {
      print("Error getting all colors:$e");
    }

    return listColors;
  }
}
