import 'package:cloud_firestore/cloud_firestore.dart';

class ColorModel {
  final String id;
  String color;
  double price;
  double stocks;
  String hexValue;
  int sales;

  ColorModel({
    required this.id,
    required this.color,
    required this.price,
    required this.stocks,
    required this.hexValue,
    required this.sales,
  });

  factory ColorModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ColorModel(
      id: doc.id,
      color: data['color'] ?? '',
      stocks: data['stocks'].toDouble() ?? 0,
      price: data['price'] ?? 0.0,
      hexValue: data['hexValue'] ?? '',
      sales: data['sales'] ?? 0,
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
