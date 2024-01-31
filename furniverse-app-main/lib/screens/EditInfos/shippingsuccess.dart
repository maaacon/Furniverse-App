import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse/screens/customer_dashboard/screens/wrapper_orders_screen.dart';

class ShippingSuccess extends StatefulWidget {
  const ShippingSuccess({super.key});

  @override
  State<ShippingSuccess> createState() => _ShippingSuccessState();
}

class _ShippingSuccessState extends State<ShippingSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 76),
              Center(child: SvgPicture.asset('assets/icons/PrimaryIcon.svg')),
              const SizedBox(height: 40),
              const Text(
                "SUCCESS!",
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 30,
                  fontFamily: 'Avenir Next LT Pro',
                  fontWeight: FontWeight.w700,
                  height: 0.04,
                  letterSpacing: 1.50,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/successimage.jpg',
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Your order will be delivered soon.",
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 14,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Thank you for choosing our app!",
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 14,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => const LogIn(),
                    //   ),
                    // );
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WrapperOrdersScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    "TRACK YOUR ORDERS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => const LogIn(),
                    //   ),
                    // );
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    "BACK TO HOME",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
