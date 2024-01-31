import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:furniverse_admin/main.dart';
import 'package:furniverse_admin/screens/LoginandLogout/forgetpassnotice.dart';

class EmailForgetPass extends StatefulWidget {
  const EmailForgetPass({super.key});

  @override
  State<EmailForgetPass> createState() => _EmailForgetPassState();
}

class _EmailForgetPassState extends State<EmailForgetPass> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 76),
                Center(child: SvgPicture.asset('assets/icons/PrimaryIcon.svg')),
                const SizedBox(height: 40),
                const Text(
                  "FORGOT",
                  style: TextStyle(
                    color: Color(0xFF303030),
                    fontSize: 30,
                    fontFamily: 'Avenir Next LT Pro',
                    fontWeight: FontWeight.w700,
                    height: 0.04,
                    letterSpacing: 1.50,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "PASSWORD",
                  style: TextStyle(
                    color: Color(0xFF303030),
                    fontSize: 30,
                    fontFamily: 'Avenir Next LT Pro',
                    fontWeight: FontWeight.w700,
                    height: 0.04,
                    letterSpacing: 1.50,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Email',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                      ? 'Enter valid email'
                      : null,
                ),
                const SizedBox(height: 40),
                Center(
                    child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      forgotPassword();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>const ForgetPassNotice(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text(
                      "SUBMIT",
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Remember now?"),
                    TextButton(
                      onPressed: () {
                        navigatorKey.currentState!.popUntil((route) => route.isFirst);
                      },
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future forgotPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
