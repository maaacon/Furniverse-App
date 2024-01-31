import 'package:cloud_firestore/cloud_firestore.dart';

class Materials {
  final String id;
  String material;
  double price;
  int stocks;
  int sales;

  Materials({
    required this.id,
    required this.material,
    required this.price,
    required this.stocks,
    required this.sales,
  });

  factory Materials.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Materials(
      id: doc.id,
      material: data['material'] ?? '',
      stocks: data['stocks'] ?? '',
      price: data['price'] ?? '',
      sales: data['sales'] ?? 0,
    );
  }
}
