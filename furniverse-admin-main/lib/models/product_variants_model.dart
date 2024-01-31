class ProductVariants {
  String id;
  String variantName;
  String color;
  double length;
  double width;
  double height;
  String material;
  String metric;
  double price;
  int stocks;
  dynamic image;
  dynamic model;

  ProductVariants({
    required this.id,
    required this.variantName,
    required this.material,
    required this.color,
    required this.length,
    required this.width,
    required this.height,
    required this.metric,
    required this.price,
    required this.stocks,
    required this.image,
    required this.model,
  });
}
