import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String id;

  Favorite({required this.id});

  factory Favorite.fromFirestore(DocumentSnapshot doc) {
    // Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Favorite(id: doc.id);
  }
}
