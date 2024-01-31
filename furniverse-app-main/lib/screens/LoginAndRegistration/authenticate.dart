
import 'package:flutter/material.dart';
import 'package:furniverse/screens/LoginAndRegistration/login.dart';
import 'package:furniverse/screens/LoginAndRegistration/registration.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LogIn(toggleView: toggleView);
    } else {
      return Registration(toggleView: toggleView);
    }
  }
}
