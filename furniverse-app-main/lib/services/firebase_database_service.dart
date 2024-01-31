import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(
      String username, String email, Map shippingAddress, String token) async {
    return await userCollection.doc(uid).set({
      'name': username,
      'email': email,
      'shippingAddress': shippingAddress,
      'contactNumber': "",
      'token': token,
      "avatar": "",
      'role': "user"
      // profile picture
    });
  }
}
