import 'package:flutter/material.dart';
import 'package:furniverse/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];
  List<Product> get cart => _cart;

  // incrementQuantity(int index) {
  //   _cart[index].quantity++;
  //   notifyListeners();
  // }

  // decrementQuantity(int index) {
  //   if (_cart[index].quantity > 1) {
  //     _cart[index].quantity--;
  //     notifyListeners();
  //   }
  // }

  // getTotalPrice() {
  //   double total = 0.0;
  //   for (Product product in _cart) {
  //     total += product.price * product.quantity;
  //   }
  //   return total;
  // }

  // toggleProduct(Product product, int quantity) {
  //   if (_cart.contains(product)) {
  //     product.quantity += quantity;
  //   } else {
  //     product.quantity = quantity;
  //     _cart.add(product);
  //   }
  //   notifyListeners();
  // }

  // static CartProvider of(
  //   BuildContext context, {
  //   bool listen = true,
  // }) {
  //   return Provider.of<CartProvider>(
  //     context,
  //     listen: listen,
  //   );
  // }
}
