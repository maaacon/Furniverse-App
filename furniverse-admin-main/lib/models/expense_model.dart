import 'package:cloud_firestore/cloud_firestore.dart';

class ColorModel {
  final String id;
  String resourceId;
  String resourceName;
  double cost;
  int stocks;

  ColorModel({
    required this.id,
    required this.resourceId,
    required this.resourceName,
    required this.cost,
    required this.stocks,
  });

  factory ColorModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ColorModel(
      id: doc.id,
      stocks: data['stocks'] ?? 0,
      resourceId: data['resourceId'] ?? "",
      resourceName: data['resourceName'] ?? "",
      cost: data['cost'].toDouble() ?? 0.0,
    );
  }

  // int getNumStocks() {
  //   int numOfStocks = 0;
  //   for (int i = 0; i < variants.length; i++) {
  //     numOfStocks += variants[i]['stocks'] as int;
  //   }
  //   return numOfStocks;
  // }
}
