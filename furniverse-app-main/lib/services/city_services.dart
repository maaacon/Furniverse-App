import 'package:cloud_firestore/cloud_firestore.dart';

class CityServices {
  final CollectionReference _cityCollection =
      FirebaseFirestore.instance.collection('delivery');
  Future<List<String>> getCities() async {
    List<String> cityList = [];

    final data = await _cityCollection.orderBy('city').get();
    for (var city in data.docs) {
      cityList.add(city['city']);
    }

    return cityList;
  }
}
