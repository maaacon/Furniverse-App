import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse/models/favorite.dart';

class FavoriteService {
  // get collection of note
  final CollectionReference _favorites =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> addToFavorites(String userId, String productId) async {
    try {
      await _favorites.doc(userId).collection('products').doc(productId).set({
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding product to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      await _favorites
          .doc(userId)
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      print('Error removing product from favorites: $e');
    }
  }

  Stream<List<Favorite>> streamFavorites(String? userId) {
    return _favorites
        .doc(userId)
        .collection('products')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Favorite.fromFirestore(e),
              )
              .toList(),
        );
  }
}
