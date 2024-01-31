import 'package:cloud_firestore/cloud_firestore.dart';

class ColorModel {
  final String id;
  String color;
  String hexValue;
  double price;
  double stocks;
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
      stocks: data['stocks'].toDouble() ?? 0.0,
      price: data['price'] ?? '',
      hexValue: data['hexValue'] ?? '',
      sales: data['sales'] ?? 0,
    );
  }
}
