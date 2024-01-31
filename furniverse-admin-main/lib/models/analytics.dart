class AnalyticsModel {
  final int year;
  final int totalQuantity;
  final int totalRefunds;
  final double totalRevenue;
  final double averageOrderValue;
  final Map<String, int> topProducts;
  final Map<String, dynamic> monthlySales;
  final Map<String, dynamic> ordersPerCity;
  final Map<String, dynamic> ordersPerProduct;

  AnalyticsModel({
    required this.year,
    required this.totalRevenue,
    required this.averageOrderValue,
    required this.topProducts,
    required this.monthlySales,
    required this.ordersPerCity,
    required this.ordersPerProduct,
    required this.totalQuantity,
    required this.totalRefunds,
  });

  Map<String, dynamic> getMap() {
    return {
      'year': year,
      'totalRevenue': totalRevenue,
      'averageOrderValue': averageOrderValue,
      'topProducts': topProducts,
      'monthlySales': monthlySales,
      'ordersPerCity': ordersPerCity,
      'ordersPerProduct': ordersPerProduct,
      'totalQuantity': totalQuantity,
      'totalRefunds': totalRefunds,
    };
  }
}
