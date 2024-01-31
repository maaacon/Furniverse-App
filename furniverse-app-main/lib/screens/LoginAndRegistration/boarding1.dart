import 'package:flutter/material.dart';
import 'package:furniverse/screens/LoginAndRegistration/boarding2.dart';

class Boarding1 extends StatefulWidget {
  const Boarding1({super.key});

  @override
  State<Boarding1> createState() => _Boarding1State();
}

class _Boarding1State extends State<Boarding1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/boarding1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 200),
                const Text(
                  "MAKE YOUR",
                  style: TextStyle(
                    color: Color(0xFF5F5F5F),
                    fontSize: 30,
                    fontFamily: 'Avenir Next LT Pro',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.45,
                  ),
                ),
                const Text(
                  "HOME BEAUTIFUL",
                  style: TextStyle(
                    color: Color(0xFF303030),
                    fontSize: 32,
                    fontFamily: 'Avenir Next LT Pro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 300,
                  child: Text(
                    'The best simple place where you discover most wonderful furnitures and make your home beautiful.',
                    style: TextStyle(
                      color: Color(0xFF808080),
                      fontSize: 18,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 140),
                Center(
                  child: SizedBox(
                    height: 54,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Boarding2(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text("Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
