
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse/screens/LoginAndRegistration/authenticate.dart';
import 'package:furniverse/screens/LoginAndRegistration/boarding1.dart';
import 'package:furniverse/screens/LoginAndRegistration/emailverification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainButtons extends StatefulWidget {
  const MainButtons( {super.key});

  @override
  State<MainButtons> createState() => _MainButtonsState();
}

class _MainButtonsState extends State<MainButtons> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      const Authenticate();
    } else {
      await prefs.setBool('seen', true);
      Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Boarding1(),
            ),
          );
    }
  }

   @override
  Widget build(BuildContext context) {

checkFirstSeen();    
    // FirebaseAuth.instance.currentUser?.reload();

    final user = Provider.of<User?>(context);
    // String? samplee;
    // String id;

     
    
    
    

    // return either Home or Authenticate widget

    if (user == null) {
      return const Authenticate();
    }
    else {
      // id = user.toString();
      // print(id);
      // FirebaseFirestore.instance
      //   .collection('users')
      //   .doc(id)
      //   .get()
      //   .then((ds) {
      //      samplee = "${ds["role"]}";
           
      //   });
      // if (samplee != "user") {
      //       Fluttertoast.showToast(
      //         msg: "Invalid Account",
      //         backgroundColor: Colors.grey,
      //       );
      //       // _auth.signOut();
      //       return const EmailVerification();
             
            
      //       // SystemChannels.platform.invokeMethod('SystemNavigator.pop'); 
      //      }
      // else{
        return const EmailVerification();
      // }
        
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
