import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse/main.dart';

class ForgetPassNotice extends StatefulWidget {
  const ForgetPassNotice({super.key});

  @override
  State<ForgetPassNotice> createState() => _ForgetPassNoticeState();
}

class _ForgetPassNoticeState extends State<ForgetPassNotice> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: const Text("Change Password")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text("If your account is registered, you will receive an email to change your password.",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      navigatorKey.currentState!.popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text(
                      "Back to Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                )
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      );
}

  }