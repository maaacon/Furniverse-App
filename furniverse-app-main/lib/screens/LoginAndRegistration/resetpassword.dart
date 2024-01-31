import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse/screens/LoginAndRegistration/verification.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isObscure = true;

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
              mainAxisAlignment: MainAxisAlignment.start,
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
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'New Password',
                    suffixIcon: togglePassword(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Confirm New Password',
                    suffixIcon: togglePassword(),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                    child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Verification(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text(
                      "RESET PASSWORD",
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
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (context) => const LogIn(),
                          //   ),
                          // );
                        },
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isObscure = !_isObscure;
        });
      },
      icon: _isObscure
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}
