import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse/models/user.dart';
import 'package:furniverse/screens/EditInfos/shippingaddress.dart';
import 'package:furniverse/services/user_service.dart';
import 'package:provider/provider.dart';

class WrapperShippingAddress extends StatelessWidget {
  final UserModel? userModel;
  final double sample;
  const WrapperShippingAddress(
      {super.key, this.userModel, required this.sample});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    // final userModel = Provider.of<UserModel?>(context);
    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: UserService().streamUser(user?.uid), initialData: null),
      ],
      // child: ShippingAddress(
      //   userModel: userModel,
      // ),
    );
  }
}
