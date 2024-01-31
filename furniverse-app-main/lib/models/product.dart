import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double labor;
  final double expenses;
  final double noMaterialsReq;
  final double noPaintReq;
  final List<dynamic> images;
  final String description;
  final List<dynamic> variants;
  final List<dynamic> materialIds;
  final String selectedGuide;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.labor,
    required this.expenses,
    required this.description,
    required this.images,
    required this.variants,
    required this.noMaterialsReq,
    required this.noPaintReq,
    required this.materialIds,
    required this.selectedGuide,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    final variants = data['variants'];

    double divisor = 1;

    for (int i = 0; i < variants.length; i++) {
      final String metric = variants[0]['metric'];
      //get multiplier based on metric

      switch (metric.toLowerCase()) {
        case 'inch':
          divisor = 39.37;
          break;
        case 'cm':
          divisor = 100;
          break;
        case 'ft':
          divisor = 3.281;
          break;
      }
      variants[0]['length'] = (variants[0]['length'] ?? 0) / divisor;
      variants[0]['width'] = (variants[0]['width'] ?? 0) / divisor;
      variants[0]['height'] = (variants[0]['height'] ?? 0) / divisor;
    }
    return Product(
      id: doc.id,
      name: data['product_name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      labor: (data['labor_cost'] ?? 0).toDouble(),
      expenses: (data['expenses'] ?? 0).toDouble(),
      images: data['product_images'],
      variants: variants,
      noMaterialsReq: (data['noMaterialsReq'] ?? 0.0).toDouble(),
      noPaintReq: (data['noPaintReq'] ?? 0.0).toDouble(),
      materialIds: data['materialIds'] ?? [],
      selectedGuide: data['selectedGuide'] ?? 'Rectangle',
    );
  }

  factory Product.fromMap(Map data, String productId) {
    return Product(
      id: productId,
      name: data['product_name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      labor: (data['labor_cost'] ?? 0).toDouble(),
      expenses: (data['expenses'] ?? 0).toDouble(),
      images: data['product_images'],
      variants: data['variants'],
      noMaterialsReq: (data['noMaterialsReq'] ?? 0.0).toDouble(),
      noPaintReq: (data['noPaintReq'] ?? 0.0).toDouble(),
      materialIds: data['materialIds'] ?? [],
      selectedGuide: data['selectedGuide'] ?? 'Rectangle',
    );
  }

  int getNumVariants() {
    return variants.length;
  }

  int getNumStocks() {
    int numOfStocks = 0;
    for (int i = 0; i < variants.length; i++) {
      numOfStocks += variants[i]['stocks'] as int;
    }
    return numOfStocks;
  }

  double getLeastPrice() {
    double leastPrice = variants[0]['price'].toDouble();
    if (variants.length == 1) {
      return leastPrice;
    }

    for (int i = 1; i < variants.length; i++) {
      if (leastPrice > variants[i]['price']) {
        leastPrice = variants[i]['price'].toDouble();
      }
    }
    return leastPrice;
  }

  double getHighestPrice() {
    double highPrice = variants[0]['price'].toDouble();
    if (variants.length == 1) {
      return highPrice;
    }

    for (int i = 1; i < variants.length; i++) {
      if (highPrice < variants[i]['price']) {
        highPrice = variants[i]['price'].toDouble();
      }
    }
    return highPrice;
  }

  bool hasStock() {
    for (var variant in variants) {
      if (variant['stocks'] > 0) return true;
    }
    return false;
  }
}
