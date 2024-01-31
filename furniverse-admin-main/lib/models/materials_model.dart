import 'package:cloud_firestore/cloud_firestore.dart';

class Materials {
  final String id;
  String material;
  double price;
  int stocks;
  int sales;
  double length;
  double width;
  double height;
  String metric;

  Materials({
    required this.id,
    required this.material,
    required this.price,
    required this.stocks,
    required this.sales,
    required this.length,
    required this.width,
    required this.height,
    required this.metric
  });

  factory Materials.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Materials(
      id: doc.id,
      material: data['material'] ?? '',
      stocks: data['stocks'] ?? '',
      price: data['price'] ?? '',
      sales: data['sales'] ?? 0,
      length: data['length'] ?? 0.00,
      width: data['width'] ?? 0.00,
      height: data['height'] ?? 0.00,
      metric: data['metric'] ?? '',
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
