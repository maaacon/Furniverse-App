import 'package:flutter/material.dart';
import 'package:furniverse_admin/main.dart';

class ChangeEmailNotice extends StatefulWidget {
  const ChangeEmailNotice({super.key});

  @override
  State<ChangeEmailNotice> createState() => _ChangeEmailNoticeState();
}

class _ChangeEmailNoticeState extends State<ChangeEmailNotice> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: const Text("Change Email")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text("To save your new email, a verification email was sent to the email you provided.",
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