import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/firebasefiles/firebase_user_notification.dart';
import 'package:furniverse_admin/services/auth_services.dart';
import 'package:furniverse_admin/services/color_services.dart';
import 'package:furniverse_admin/services/delivery_services.dart';
import 'package:furniverse_admin/services/materials_services.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/services/refund_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseUserNotification().initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VariantsProvider(),
        ),
        StreamProvider.value(
            value: OrderService().streamOrders(), initialData: null),
        StreamProvider.value(
            value: RefundService().streamRefunds(), initialData: null),
        StreamProvider.value(
            value: ProductService().streamProducts(), initialData: null),
        StreamProvider.value(
            value: MaterialsServices().streamMaterials(), initialData: null),
        StreamProvider.value(
            value: ColorService().streamColor(), initialData: null),
        StreamProvider.value(
            value: DeliveryService().streamDelivery(), initialData: null),
        StreamProvider<User?>.value(
            value: AuthService().user, initialData: null),
      ],
      child: MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final routes = {
    '/': 'Home Page',
  };

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final customTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.white,
      primaryIconTheme: const IconThemeData(color: Colors.black),
    );
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: 'Furniverse',
      theme: customTheme,
      home: const Wrapper(),
    );
  }
}
