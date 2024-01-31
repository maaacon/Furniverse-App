import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/screens/LoginandLogout/login.dart';
import 'package:furniverse_admin/screens/admin_home/admin_main.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  // final Map<String, String> routes;

  // const MainButtons(this.routes, {super.key});

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.currentUser?.reload();

    final user = Provider.of<User?>(context);

    // return either Home or Authenticate widget

    if (user == null) {
      return const LogIn();
    } else {
      return const AdminMain();
    }

    // return const Scaffold(
    //   body: Authenticate(),
    //   body: StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(child: CircularProgressIndicator());
    //       } else if(snapshot.hasError){
    //         return const Center(child: Text("Something went wrong."),);
    //       } else if (snapshot.hasData) {
    //         return const EmailVerification();
    //       } else {
    //       return const LogIn();
    //       }
    //     }
    //   ),

    //   DEFAULT FOR BUTTONS
    //   backgroundColor: const Color(0xFFF0F0F0),
    //   appBar: AppBar(
    //     title: const Text('Home Page'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Text('Routes'),
    //         for (var route in routes.entries)
    //           ElevatedButton(
    //               onPressed: () {
    //                 Navigator.pushNamed(context, route.key);
    //               },
    //               child: Text('Go to ${route.value}'))
    //       ],
    //     ),
    //   ),
    // );
  }
}
