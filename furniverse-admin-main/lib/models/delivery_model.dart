import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery {
  final String id;
  String city;
  double price;

  Delivery({
    required this.id,
    required this.city,
    required this.price,
  });

  factory Delivery.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Delivery(
      id: doc.id,
      city: data['city'] ?? '',
      price: data['price'] ?? '',
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