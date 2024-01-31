import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/analytics.dart';

class AnalyticsServices {
  final _db = FirebaseFirestore.instance;

  Future<void> deleteAnalytics(int year) async {
    try {
      // delete file in firestorage

      await _db.collection('analytics').doc(year.toString()).delete();
    } catch (e) {
      print('Error deleting $year analytics: $e');
    }
  }

  Future<void> clearAnalytics() async {
    try {
      // delete file in firestorage
      print("clearing analytics");
      final CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('analytics');

      final QuerySnapshot querySnapshot = await collectionReference.get();
      final List<DocumentSnapshot> documents = querySnapshot.docs;

      for (var document in documents) {
        await document.reference.delete();
      }

      // await _db.collection('analytics').doc().delete();
    } catch (e) {
      print('Error deleting analytics: $e');
    }
  }

  Future<void> updateAnalytics(int year, AnalyticsModel analytics) async {
    try {
      Map<String, dynamic> analyticsMap = analytics.getMap();
      analyticsMap['dateUpdated'] = FieldValue.serverTimestamp();

      await _db.collection('analytics').doc(year.toString()).set(analyticsMap);
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<bool> hasPrevious(int year) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('analytics').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Access document data using documentSnapshot.data()
        if (documentSnapshot.id == (year - 1).toString()) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error adding product to cart: $e');
      return false;
    }
  }

  Future<double> getTotalRevenue(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        double totalRevenue = analyticsData['totalRevenue'];

        return totalRevenue;
      }

      return 0.0;
    } catch (e) {
      print('Error adding product to cart: $e');
      return 0.0;
    }
  }

  Future<double> getAOV(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        double totalRevenue = analyticsData['averageOrderValue'];

        return totalRevenue;
      }

      return 0.0;
    } catch (e) {
      print('Error adding product to cart: $e');
      return 0.0;
    }
  }

  Future<int> getTotalQuantity(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        int totalQuantity = analyticsData['totalQuantity'];

        return totalQuantity;
      }

      return 0;
    } catch (e) {
      print('Error adding product to cart: $e');
      return 0;
    }
  }

  Future<int> getTotalRefund(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        int totalRefund = analyticsData['totalRefunds'];

        return totalRefund;
      }

      return 0;
    } catch (e) {
      print('Error adding product to cart: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>> getMonthlySales(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        Map<String, dynamic> monthlyRevenue = analyticsData['monthlySales'];

        return monthlyRevenue;
      }

      return {};
    } catch (e) {
      print('Error adding product to cart: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getOrdersPerProvince(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        Map<String, dynamic> ordersPerProvince =
            analyticsData['ordersPerProvince'];

        return ordersPerProvince;
      }

      return {};
    } catch (e) {
      print('Error adding product to cart: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getOrdersPerCity(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        Map<String, dynamic> ordersPerCity = analyticsData['ordersPerCity'];

        return ordersPerCity;
      }

      return {};
    } catch (e) {
      print('Error adding product to cart: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getOrdersPerProduct(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        Map<String, dynamic> ordersPerProvince =
            analyticsData['ordersPerProduct'];

        return ordersPerProvince;
      }

      return {};
    } catch (e) {
      print('Error adding product to cart: $e');
      return {};
    }
  }

  Future<double> getTotalRevenuePerPeriod(int noOfYear) async {
    try {
      double totalRevenue = 0.0;
      final QuerySnapshot analyticsDoc = await _db
          .collection('analytics')
          .orderBy('year', descending: true)
          .get();

      int counter = 0;
      for (QueryDocumentSnapshot doc in analyticsDoc.docs) {
        final yearDetails = doc.data() as Map;
        totalRevenue = totalRevenue + yearDetails['totalRevenue'];
        counter++;
        if (counter == noOfYear || counter == analyticsDoc.docs.length) {
          return totalRevenue;
        }
      }

      return 0.0;
    } catch (e) {
      print('Error get Total Revenue Per Period: $e');
      return 0.0;
    }
  }

  Future<double> getAOVPerPeriod(int noOfYear) async {
    try {
      double averageOrderValue = 0.0;
      final QuerySnapshot analyticsDoc = await _db
          .collection('analytics')
          .orderBy('year', descending: true)
          .get();

      int counter = 0;
      for (QueryDocumentSnapshot doc in analyticsDoc.docs) {
        final yearDetails = doc.data() as Map;
        averageOrderValue =
            averageOrderValue + yearDetails['averageOrderValue'];
        counter++;
        if (counter == noOfYear || counter == analyticsDoc.docs.length) {
          return averageOrderValue / counter;
        }
      }

      return 0.0;
    } catch (e) {
      print('Error get Total Revenue Per Period: $e');
      return 0.0;
    }
  }
}
