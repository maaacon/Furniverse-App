import 'package:cloud_firestore/cloud_firestore.dart';

class Tmpproduct {
  final String id;
  final String name;
  final String category;
  final String image;
  final String description;
  final double price;

  Tmpproduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
  });

  factory Tmpproduct.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Tmpproduct(
        id: doc.id,
        name: data['name'] ?? '',
        category: data['category'] ?? '',
        price: data['price'].toDouble() ?? 0.0,
        description: data['description'] ?? '',
        image: data['image'] ?? '');
  }
}
