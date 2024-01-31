import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse/screens/LoginAndRegistration/accountcreated.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 76),
                Center(child: SvgPicture.asset('assets/icons/PrimaryIcon.svg')),
                const SizedBox(height: 40),
                const Text(
                  "VERIFICATION",
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
                const Center(
                  child: Column(
                    children: [
                      Text(
                        "Please enter your mobile number",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "to verify your account.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Phone Number',
                    prefixIcon: Container(
                      width: 50,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Color(0xFF272727),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '+63',
                          style: TextStyle(
                            color: Color(0xFF545454),
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'OTP',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Didn't receive it yet?"),
                    TextButton(
                        onPressed: () {
                          //Navigator.of(context).pushNamedAndRemoveUntil('/screen4', (Route<dynamic> route) => false);
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (context) => const LogIn(),
                          //   ),
                          // );
                        },
                        child: const Text(
                          "Resend Code",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                    child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AccountCreated(),
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
                          //Navigator.of(context).pushNamedAndRemoveUntil('/screen4', (Route<dynamic> route) => false);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
