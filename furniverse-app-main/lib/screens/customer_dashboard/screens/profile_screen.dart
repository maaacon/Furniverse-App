import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse/models/order.dart';
import 'package:furniverse/models/refund.dart';
import 'package:furniverse/models/request.dart';
import 'package:furniverse/models/user.dart';
import 'package:furniverse/screens/EditInfos/shippingaddress.dart';
import 'package:furniverse/screens/EditInfos/unit_measurement_setting.dart';
import 'package:furniverse/screens/EditInfos/settings_screen.dart';
import 'package:furniverse/screens/EditInfos/wrapper_shipping_address.dart';
import 'package:furniverse/screens/customer_dashboard/screens/refund_screen.dart';
import 'package:furniverse/screens/customer_dashboard/screens/request_screen.dart';
import 'package:furniverse/screens/customer_dashboard/screens/wrapper_orders_screen.dart';
import 'package:furniverse/services/city_services.dart';
import 'package:furniverse/services/firebase_auth_service.dart';
import 'package:furniverse/services/user_service.dart';
import 'package:furniverse/shared/constants.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:furniverse/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  File? _image;

  Future<void> _pickImage(String userId) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Call the function to upload the image
      await UserService().uploadImage(_image!, userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final orders = Provider.of<List<OrderModel>?>(context);
    final request = Provider.of<List<CustomerRequests>?>(context);
    final refunds = Provider.of<List<Refund>?>(context);

    if (user == null || orders == null || request == null || refunds == null) {
      return const Center(
        child: Loading(),
      );
    }

    // get number of orders
    int numOrders = 0;
    for (int i = 0; i < orders.length; i++) {
      if (orders[i].shippingStatus != "cancelled" &&
          orders[i].shippingStatus != "completed") {
        numOrders++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ConfirmationAlertDialog(
                    title: "Are you sure you want to log out?",
                    onTapNo: () {
                      Navigator.pop(context);
                    },
                    onTapYes: () async {
                      await _auth.signOut();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      Fluttertoast.showToast(
                        msg: "Logged Out Successfully.",
                        backgroundColor: Colors.grey,
                      );
                    },
                    tapNoString: "No",
                    tapYesString: "Yes"),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: SizedBox(
                height: 24,
                width: 24,
                child: Icon(
                  Icons.logout_rounded,
                  color: Color.fromARGB(255, 94, 94, 94),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PROFILE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF303030),
            fontSize: 16,
            fontFamily: 'Avenir Next LT Pro',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: user.avatar == ""
                          ? CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              child: Text(
                                user.getInitials().toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF303030),
                                  fontSize: 16,
                                  fontFamily: 'Avenir Next LT Pro',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(user.avatar),
                            ),
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          final user = FirebaseAuth.instance.currentUser!;

                          _pickImage(user.uid);
                        },
                        child: const Icon(
                          Icons.add_a_photo_rounded,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 20,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      user.email,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 14,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 28),
            ProfileNavigation(
                title: 'My Orders',
                subtitle:
                    'You have $numOrders order${numOrders > 1 ? "s" : ""}',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WrapperOrdersScreen()));
                }),
            const Gap(15),
            // ProfileNavigation(
            //     title: 'My Requests',
            //     subtitle:
            //         'You have ${request.length} request${request.length > 1 ? "s" : ""}',
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const RequestPage(),
            //         ),
            //       );
            //     }),
            // const SizedBox(height: 15),
            ProfileNavigation(
                title: 'My Refunds',
                subtitle:
                    'You have ${refunds.length} refund${refunds.length > 1 ? "s" : ""}',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RefundPage(),
                    ),
                  );
                }),
            const SizedBox(height: 15),
            ProfileNavigation(
                title: 'Shipping Address',
                subtitle: user.getStringAddress() == ""
                    ? "No shipping address"
                    : user.getStringAddress(),
                onTap: () async {
                  final cityList = await CityServices().getCities();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => WrapperShippingAddress(
                        //   userModel: user,
                        // ),
                        builder: (context) => ShippingAddress(
                            userModel: user, cityList: cityList),
                      ));
                }),
            const SizedBox(height: 15),
            // ProfileNavigation(
            //     title: 'Payment Method',
            //     subtitle: 'You have ${2} cards',
            //     onTap: () {}),
            // const SizedBox(height: 15),
            ProfileNavigation(
                title: 'Unit of Measurement',
                subtitle: user.unitMeasure == 'm'
                    ? 'Meters (m)'
                    : user.unitMeasure == 'in'
                        ? 'Inches (in)'
                        : 'Feet (ft)',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UnitMeasurementSettingPage(
                                userId: userId,
                                unitMeasure: user.unitMeasure,
                              )));
                }),
            const SizedBox(height: 15),
            ProfileNavigation(
                title: 'Settings',
                subtitle: 'Password, Account Deletion',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                }),
            Gap(15),
          ],
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     // Text(user.email!),

        //     ElevatedButton(
        //         onPressed: () => FirebaseAuth.instance.signOut(),
        //         child: const Text("Sign Out"))
        //   ],
        // ),
      ),
    );
  }
}

class ProfileNavigation extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() onTap;

  const ProfileNavigation({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x338A959E),
            blurRadius: 40,
            offset: Offset(0, 7),
            spreadRadius: 0,
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF303030),
            fontSize: 18,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          textAlign: TextAlign.justify,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF808080),
            fontSize: 12,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          size: 24,
        ),
      ),
    );
  }
}
