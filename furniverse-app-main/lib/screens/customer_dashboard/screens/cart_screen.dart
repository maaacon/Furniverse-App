import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse/models/cart.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/screens/EditInfos/checkout.dart';
import 'package:furniverse/services/cart_service.dart';
import 'package:furniverse/widgets/cart_product_card.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final user = FirebaseAuth.instance.currentUser!;
  double? totalCartPrice;

  void updateTotalCartPrice(double total) {
    setState(() {
      totalCartPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: CartService().streamCart(user.uid), initialData: null),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'MY CART',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF303030),
                fontSize: 16,
                fontFamily: 'Avenir Next LT Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                const Expanded(
                  child: Products(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 20,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TotalPrice(totalCartPrice: totalCartPrice)
                        ],
                      ),
                      const SizedBox(height: 20),
                      const CheckoutButton()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox newMethod() {
    return const SizedBox(
      width: 10,
    );
  }
}

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() async {
        var cart = Provider.of<List<CartProduct>?>(context, listen: false);
        var products = Provider.of<List<Product>?>(context, listen: false);

        double total = 0.0;

        // calculate for total value
        if (cart != null && products != null) {
          for (var i = 0; i < cart.length; i++) {
            for (var j = 0; j < products.length; j++) {
              if (cart[i].id == products[j].id) {
                for (var k = 0; k < products[j].variants.length; k++) {
                  if (cart[i].variationID == products[j].variants[k]['id']) {
                    total +=
                        cart[i].quantity * products[j].variants[k]['price'];
                    break;
                  }
                }
                break;
              }
            }
          }
        }

        if (cart != null) {
          if (cart.isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CheckOut(
                  total: total,
                  cart: cart,
                );
              },
            ));
          }
        } else {
          Fluttertoast.showToast(
            msg: "No Items to Check",
            backgroundColor: Colors.grey,
          );
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff303030)),
        child: const Text(
          'CHECK OUT',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
      ),
    );
  }
}

class TotalPrice extends StatelessWidget {
  const TotalPrice({
    super.key,
    required this.totalCartPrice,
  });

  final double? totalCartPrice;

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<List<CartProduct>?>(context);
    var products = Provider.of<List<Product>?>(context);

    double total = 0.0;

    // calculate for total value
    if (cart != null && products != null) {
      for (var i = 0; i < cart.length; i++) {
        for (var j = 0; j < products.length; j++) {
          if (cart[i].id == products[j].id) {
            for (var k = 0; k < products[j].variants.length; k++) {
              if (cart[i].variationID == products[j].variants[k]['id']) {
                total += cart[i].quantity * products[j].variants[k]['price'];
                break;
              }
            }
            break;
          }
        }
      }
    }

    return Text(
      '₱${total.toStringAsFixed(0)}',
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: Color(0xFF303030),
        fontSize: 20,
        fontFamily: 'Nunito Sans',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class Products extends StatelessWidget {
  const Products({
    super.key,
    // required this.finalList,
  });

  // final List<Product> finalList;

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<List<CartProduct>?>(context);
    var products = Provider.of<List<Product>?>(context);

    Set<String> cartProductIds = <String>{};
    List<String> cartProductVariantIds = [];
    List<Product> cartProducts = [];

    // print(cart);
    // print(products);

    // Extract product IDs from the favorites
    if (cart != null && products != null) {
      for (var prod in cart) {
        // print(prod.id);
        cartProductIds.add(prod.id);
        cartProductVariantIds.add(prod.variationID);
      }

      for (var i = 0; i < cartProductIds.length; i++) {
        for (var j = 0; j < products.length; j++) {
          if (cartProductIds.elementAt(i) == products[j].id) {
            cartProducts.add(products[j]);
          }
        }
      }
    }

    // // print(products);

    final finalList = cartProducts;
    // print(finalList);

    if (finalList.isEmpty) {
      return const Center(
          child: Text("You have no orders listed as of the moment."));
    } else {
      return ListView.separated(
        // scrollDirection: Axis.vertical,
        itemCount: finalList.length,
        separatorBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 12),
              Container(
                height: 1,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF0F0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
        itemBuilder: (context, index) {
          final product = finalList[index];
          final variantID = cartProductVariantIds[index];

          return CartProductCard(
            product: product,
            removeItem: () {
              // finalList.removeAt(index);
              // setState(() {});
            },
            variantID: variantID,
            quantity: cart?[index].quantity ?? 1,
          );
        },
      );
    }
  }
}
