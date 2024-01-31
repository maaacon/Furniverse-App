import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceExpenseModel {
  String? resourceSalesId;
  String resourceId;
  String resourceName;
  double expense;
  int stocks;
  bool isColor;
  bool isMaterial;

  ResourceExpenseModel({
    this.resourceSalesId,
    required this.resourceId,
    required this.resourceName,
    required this.expense,
    required this.stocks,
    required this.isColor,
    required this.isMaterial,
  });

  factory ResourceExpenseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ResourceExpenseModel(
      resourceSalesId: doc.id,
      resourceId: data['resourceId'] ?? '',
      stocks: data['stocks'] ?? 0,
      resourceName: data['resourceName'] ?? '',
      expense: data['expense'].toDouble() ?? 0,
      isColor: data['isColor'] ?? false,
      isMaterial: data['isMaterial'] ?? false,
    );
  }
  Map<String, dynamic> getMap() {
    return {
      'resourceId': resourceId,
      'stocks': stocks,
      'resourceName': resourceName,
      'expense': expense,
      'isColor': isColor,
      'isMaterial': isMaterial,
    };
  }
}
