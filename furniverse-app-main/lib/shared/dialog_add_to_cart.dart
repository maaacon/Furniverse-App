import 'package:flutter/material.dart';
import 'package:furniverse/screens/customer_dashboard/screens/cart_screen.dart';

void showAddedToCartDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Added To Cart!",
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 20,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w800,
                )),
            const SizedBox(height: 20),
            Container(
              height: 0.50,
              decoration: const BoxDecoration(color: Color(0xFF3C3C43)),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const CartPage(),
                //   ),
                // );
              },
              child: const Text(
                'Got It!',
                style: TextStyle(
                  color: Color(0xFF007AFF),
                  fontSize: 17,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
