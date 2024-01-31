import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse/models/user.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future updateUserData(String username, String email, Map shippingAddress,
      String id, String contact, double shippingFee) async {
    return await _db.collection('users').doc(id).update({
      'name': username,
      'email': email,
      'shippingAddress': shippingAddress,
      'contactNumber': contact,
      'shippingfee' : shippingFee,
      // profile picture
    });
  }

  Stream<UserModel> streamUser(String? id) {
    return _db
        .collection('users')
        .doc(id)
        .snapshots()
        .map(((event) => UserModel.fromMap((event.data() ?? {}))));
  }

  Future<void> updateUnitMeasure(
      {required String? userId, required int unitMeasureIndex}) async {
    int idx = unitMeasureIndex;
    try {
      //get initial tokens

      await _db.collection('users').doc(userId).update({
        'unitMeasure': idx == 0
            ? 'in'
            : idx == 1
                ? 'm'
                : 'ft',
      });
      print('Field updated successfully');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  Future<String> getUserPrefferedMeasure({required String? userId}) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return data['unitMeasure'] ?? "ft";
      }

      return "";
    } catch (e) {
      return "";
    }
  }

  Future<void> updateToken(
      {required String? userId, required String newToken}) async {
    List<dynamic> tokens = [];
    try {
      //get initial tokens
      await _db.collection('users').doc(userId).get().then((value) {
        if (value.data()?['token'].runtimeType == String) {
          tokens.add(value.data()?['token']);
        } else {
          tokens = value.data()?['token'] as List<dynamic>;
        }
      });

      // store new token
      if (!tokens.contains(newToken)) {
        tokens.add(newToken);
      }

      await _db.collection('users').doc(userId).update({
        'token': tokens,
      });
      print('Field updated successfully');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  Future<void> removeToken(
      {required String? userId, required String token}) async {
    List<dynamic> tokens = [];
    try {
      //get initial tokens
      await _db.collection('users').doc(userId).get().then((value) {
        if (value.data()?['token'].runtimeType == String) {
          tokens.add(value.data()?['token']);
        } else {
          tokens = value.data()?['token'] as List<dynamic>;
        }
      });

      // remove token
      tokens.remove(token);

      await _db.collection('users').doc(userId).update({
        'token': tokens,
      });
      print('Field updated successfully');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  Future<void> uploadImage(File imageFile, String userId) async {
    try {
      String fileName = basename(imageFile.path);
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('user_avatars/$userId-$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
      await uploadTask.whenComplete(() => print('Image uploaded'));
      String downloadURL = await firebaseStorageRef.getDownloadURL();
      // print(uploadTask);
      await _db.collection('users').doc(userId).update({
        'avatar': downloadURL,
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
