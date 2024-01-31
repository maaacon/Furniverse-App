import 'package:flutter/material.dart';
import 'package:furniverse/screens/home/main_page.dart';

class Boarding2 extends StatefulWidget {
  const Boarding2({super.key});

  @override
  State<Boarding2> createState() => _Boarding2State();
}

class _Boarding2State extends State<Boarding2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/boarding2.jpg'),
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
                const SizedBox(height: 30),
                const Text(
                  "DISCOVER",
                  style: TextStyle(
                    color: Color(0xFFFFFBFB),
                    fontSize: 30,
                    fontFamily: 'Avenir Next LT Pro',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.45,
                  ),
                ),
                const Text(
                  "THE POWER OF AR",
                  style: TextStyle(
                    color: Color(0xFFF6BD2C),
                    fontSize: 32,
                    fontFamily: 'Avenir Next LT Pro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(
                  width: 300,
                  child: Text(
                    'Experience the wonderful world of Augmented Reality at the comfort of your home.',
                    style: TextStyle(
                      color: Color(0xFFFFFBFB),
                      fontSize: 18,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 360),
                Center(
                  child: SizedBox(
                    height: 54,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MainButtons(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text("Get Started",
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
