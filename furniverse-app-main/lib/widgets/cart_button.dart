import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse/models/cart.dart';
import 'package:furniverse/screens/customer_dashboard/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
    required this.cartProduct,
  });

  final List<CartProduct>? cartProduct;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartPage(),
              ),
            ),
        child: Center(
          child: Stack(
            children: [
              SvgPicture.asset('assets/icons/cart.svg'),
              Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.black,
                  child: Text(
                    cartProduct!.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Avenir Next LT Pro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
