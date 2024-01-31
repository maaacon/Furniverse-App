import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future updateUserData(String username, String email, Map shippingAddress,
      String id, String contact, String token) async {
    return await _db.collection('users').doc(id).set({
      'name': username,
      'email': email,
      'shippingAddress': shippingAddress,
      'contactNumber': contact,
      'token': token,
      // profile picture
    });
  }

  Future<String?> getUserName(String id) async {
    try {
      // String userName = "";
      var user = await _db.collection('users').doc(id).get();
      return (user.data()?['name']);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getUserAvatar(String id) async {
    try {
      // String userName = "";
      var user = await _db.collection('users').doc(id).get();
      return (user.data()?['avatar']);
    } on Exception catch (e) {
      print(e);
      return "";
    }
  }

  Stream<UserModel> streamUser(String? id) {
    return _db
        .collection('users')
        .doc(id)
        .snapshots()
        .map(((event) => UserModel.fromMap((event.data() ?? {}))));
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
}
