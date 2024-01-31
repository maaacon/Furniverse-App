import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse/screens/customer_dashboard/screens/order_detail_screen.dart';
import 'package:furniverse/services/order_service.dart';
import 'package:furniverse/services/user_service.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:provider/provider.dart';

class WrapperOrderDetailScreen extends StatelessWidget {
  const WrapperOrderDetailScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const Center(
        child: Loading(),
      );
    }

    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: OrderService().streamOrder(orderId), initialData: null),
        StreamProvider.value(
            value: UserService().streamUser(user.uid), initialData: null),
      ],
      child: const OrderDetailPage(),
    );
  }
}
