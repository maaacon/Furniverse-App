
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AccountCreated extends StatefulWidget {
  const AccountCreated({super.key});

  @override
  State<AccountCreated> createState() => _AccountCreatedState();
}

class _AccountCreatedState extends State<AccountCreated> {
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
              const Column(
                children: [
                  Text(
                    "YOU'RE",
                    style: TextStyle(
                      color: Color(0xFF303030),
                      fontSize: 30,
                      fontFamily: 'Avenir Next LT Pro',
                      fontWeight: FontWeight.w700,
                      height: 0.04,
                      letterSpacing: 1.50,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "ALL SET",
                    style: TextStyle(
                      color: Color(0xFF303030),
                      fontSize: 30,
                      fontFamily: 'Avenir Next LT Pro',
                      fontWeight: FontWeight.w700,
                      height: 0.04,
                      letterSpacing: 1.50,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/congratulation.jpg',
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    Text(
                      "The system has now created your account.",
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 14,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "You can now browse AI-inspired furnitures!",
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
              const SizedBox(height: 40),
              Center(
                  child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => const LogIn(),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    "Finish",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
