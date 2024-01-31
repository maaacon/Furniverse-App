import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse/screens/customer_dashboard/screens/my_orders_screen.dart';
import 'package:furniverse/services/order_service.dart';
import 'package:provider/provider.dart';

class WrapperOrdersScreen extends StatelessWidget {
  const WrapperOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    // if (user == null) {
    //   return const Center(
    //     child: Loading(),
    //   );
    // }

    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: OrderService().streamOrders(user?.uid), initialData: null)
      ],
      child: const MyOrdersScreen(),
    );
  }
}
