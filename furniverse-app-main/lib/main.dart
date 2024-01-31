import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:furniverse/services/firebase_auth_service.dart';
import 'package:furniverse/services/product_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/home/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    StreamProvider<User?>.value(value: AuthService().user, initialData: null),
    StreamProvider.value(
        value: ProductService().streamProducts(), initialData: null),
  ], child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = {
    '/': 'Home Page',
    '/page1': 'Page 1',
    '/dashboard': 'Customer Dashboard',
    '/login': 'Log In',
    '/emailforgetpass': "Email Forget Password",
    '/otp': "OTP",
    '/registration': "Registration",
    '/resetpassword': "Reset Password",
    '/verification': "Verification",
    '/checkout': "Checkout",
    '/boarding1': "Boarding 1",
    '/success': "success",
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      // initialRoute: '/',
      title: 'Furniverse',
      home: const MainButtons(),
      // routes: {
      //   // '/': (context) => MainButtons(routes),
      //   // '/dashboard': (context) => const CustomerDashboard(),
      //   // '/login': (context) => const LogIn(),
      //   // '/emailforgetpass': (context) => const EmailForgetPass(),
      //   // '/otp': (context) => const Otp(),
      //   // '/registration': (context) => const Registration(),
      //   // '/resetpassword': (context) => const ResetPassword(),
      //   // '/verification': (context) => const Verification(),
      //   // '/checkout': (context) => const CheckOut(),
      //   '/boarding1': (context) => const Boarding1(),
      //   // '/success': (context) => const ShippingSuccess(),
      // },
    );
  }
}
