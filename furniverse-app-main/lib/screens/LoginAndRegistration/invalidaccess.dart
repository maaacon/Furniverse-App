import 'package:flutter/material.dart';
import 'package:furniverse/services/firebase_auth_service.dart';

class InvalidAccess extends StatefulWidget {
  const InvalidAccess({super.key});

  @override
  State<InvalidAccess> createState() => _InvalidAccessState();
}

class _InvalidAccessState extends State<InvalidAccess> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Invalid")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text("Invalid Account",
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
                      _auth.signOut();
                      // navigatorKey.currentState!.popUntil((route) => route.isFirst);
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