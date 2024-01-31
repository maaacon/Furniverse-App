import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/screens/admin_home/pages/admin_business_perf_page.dart';
import 'package:furniverse_admin/screens/admin_home/pages/admin_customer_req_page.dart';
import 'package:furniverse_admin/screens/admin_home/pages/admin_home_page.dart';
import 'package:furniverse_admin/screens/admin_home/pages/admin_prod_list_dart.dart';
import 'package:furniverse_admin/screens/admin_home/pages/color_list.dart';
import 'package:furniverse_admin/screens/admin_home/pages/deliverycost_list.dart';
import 'package:furniverse_admin/screens/admin_home/pages/materials_list.dart';
import 'package:furniverse_admin/screens/admin_home/pages/order_status_page.dart';
import 'package:furniverse_admin/screens/admin_home/pages/refundrequest.dart';
import 'package:furniverse_admin/screens/admin_home/pages/updateemail.dart';
import 'package:furniverse_admin/services/auth_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/services/request_services.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  String userName = 'ADMIN';
  int selectedIdxPage = 0;
  final AuthService _auth = AuthService();
  String pageName = "HOME";

  List pages = <Widget>[
    const AdminHomePage(),
    const OrderStatus(),
    const AdminProdList(),
    const BusinessPerformancePage(),
    const CustomerRequestsPage(),
    const RefundPage(),
    const MaterialsList(),
    const ColorList(),
    const DeliveryCostList(),
    const UpdateEmail()
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: ProductService().streamProducts(), initialData: null),
        StreamProvider.value(
            value: RequestsService().streamRequests(), initialData: null),
      ],
      child: SafeArea(
        child: Scaffold(
          key: globalKey,
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: GestureDetector(
                onTap: () {
                  globalKey.currentState?.openDrawer();
                },
                child: const Icon(
                  Icons.menu,
                  size: 24,
                  color: Colors.black,
                ),
              ),
              title: Text(
                pageName,
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 16,
                  fontFamily: 'Avenir Next LT Pro',
                  fontWeight: FontWeight.w700,
                ),
              )),
          drawer: Drawer(
            backgroundColor: const Color(0xFF303030),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'FURNIVERSE\n',
                          style: TextStyle(
                              color: Color(0xFFF6BE2C),
                              fontSize: 22,
                              fontFamily: 'Avenir Next LT Pro',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.25),
                        ),
                        TextSpan(
                          text: 'ADMIN PANEL',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Avenir Next LT Pro',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.25),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      child: const Text(
                        "A",
                        style: TextStyle(
                          color: Color(0xFF303030),
                          fontSize: 16,
                          fontFamily: 'Avenir Next LT Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                ListTile(
                  onTap: () {
                    setState(() {
                      pageName = "HOME";
                      selectedIdxPage = 0;
                      Navigator.pop(context);
                    });
                  },
                  minLeadingWidth: 10,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      pageName = "ORDERS";
                      selectedIdxPage = 1;
                      Navigator.pop(context);
                    });
                  },
                  minLeadingWidth: 10,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.receipt_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  title: const Text(
                    'Orders',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      pageName = "PRODUCT LIST";
                      selectedIdxPage = 2;
                      Navigator.pop(context);
                    });
                  },
                  minLeadingWidth: 10,
                  contentPadding: EdgeInsets.zero,
                  leading:
                      const Icon(Icons.discount_outlined, color: Colors.white),
                  title: const Text(
                    'Product List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      pageName = "BUSINESS PERFORMANCE";
                      selectedIdxPage = 3;
                      Navigator.pop(context);
                    });
                  },
                  minLeadingWidth: 10,
                  contentPadding: EdgeInsets.zero,
                  leading:
                      const Icon(Icons.payments_outlined, color: Colors.white),
                  title: const Text(
                    'Business Performance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                // ListTile(
                //   onTap: () {
                //     setState(() {
                //       pageName = "CUSTOMER REQUEST";
                //       selectedIdxPage = 4;
                //       Navigator.pop(context);
                //     });
                //   },
                //   minLeadingWidth: 10,
                //   contentPadding: EdgeInsets.zero,
                //   leading:
                //       const Icon(Icons.verified_outlined, color: Colors.white),
                //   title: const Text(
                //     'Customer Requests',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 13,
                //       fontFamily: 'Nunito Sans',
                //       fontWeight: FontWeight.w700,
                //       height: 0,
                //     ),
                //   ),
                // ),
                ListTile(
                  onTap: () {
                    setState(() {
                      pageName = "REFUND REQUESTS";
                      selectedIdxPage = 5;
                      Navigator.pop(context);
                    });
                  },
                  minLeadingWidth: 10,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.request_page_outlined,
                      color: Colors.white),
                  title: const Text(
                    'Refund Requests',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      pageName = "MATERIALS";
                      selectedIdxPage = 6;
                      Navigator.pop(context);
                    });
                  },
                  minLeadingWidth: 10,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.construction_outlined,
                      color: Colors.white),
                  title: const Text(
                    'Materials',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      pageName = "COLORS";
                      selectedIdxPage = 7;
                      Navigator.pop(context);
                    });
                  },
                  minLeadingWidth: 10,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.color_lens_outlined,
                      color: Colors.white),
                  title: const Text(
                    'Colors',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      pageName = "DELIVERY COST";
                      selectedIdxPage = 8;
                      Navigator.pop(context);
                    });
                  },
                  minLeadingWidth: 10,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delivery_dining_outlined,
                      color: Colors.white),
                  title: const Text(
                    'Delivery Cost',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      pageName = "UPDATE EMAIL";
                      selectedIdxPage = 9;
                      Navigator.pop(context);
                    });
                  },
                  minLeadingWidth: 10,
                  contentPadding: EdgeInsets.zero,
                  leading:
                      const Icon(Icons.email_outlined, color: Colors.white),
                  title: const Text(
                    'Update Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
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
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color(0xffD38181),
                      ),
                    ),
                    child: const Text(
                      'LOGOUT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                // AdminHeader(globalKey: globalKey),
                // const SizedBox(height: 28),
                Expanded(
                  child: pages[selectedIdxPage],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminHeader extends StatelessWidget {
  const AdminHeader({
    super.key,
    required this.globalKey,
  });

  final GlobalKey<ScaffoldState> globalKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            globalKey.currentState?.openDrawer();
          },
          child: const Icon(
            Icons.menu,
            size: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        // Expanded(
        //   child: TextField(
        //     decoration: InputDecoration(
        //       contentPadding:
        //           const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(8),
        //         borderSide:
        //             const BorderSide(color: Color(0xffD0D5DD), width: 1),
        //       ),
        //       hintText: "Search",
        //       hintStyle: const TextStyle(
        //         color: Color(0xFF667084),
        //         fontSize: 16,
        //         fontFamily: 'Inter',
        //         fontWeight: FontWeight.w400,
        //       ),
        //       prefixIcon: const Icon(Icons.search),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   width: 16,
        // ),
        // const Icon(
        //   Icons.notifications_none_outlined,
        //   size: 24,
        // ),
      ],
    );
  }
}
