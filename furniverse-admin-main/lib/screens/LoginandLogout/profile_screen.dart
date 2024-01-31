import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // @override
  // void initState() {
  //   FirebaseAuth.instance.currentUser!.reload();
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Text(user.email!),

          ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(), child: const Text("Sign Out"))
        ],
      )
    );
  }
}
