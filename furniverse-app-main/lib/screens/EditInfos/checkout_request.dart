import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse/models/request.dart';
import 'package:furniverse/models/user.dart';
import 'package:furniverse/screens/EditInfos/shippingaddress.dart';
import 'package:furniverse/screens/EditInfos/shippingsuccess.dart';
import 'package:furniverse/services/city_services.dart';
import 'package:furniverse/services/order_service.dart';
import 'package:furniverse/services/user_service.dart';
import 'package:furniverse/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CheckoutRequest extends StatefulWidget {
  final double total;
  final CustomerRequests request;
  final double colorCost;
  final double materialCost;
  final double laborCost;
  final double otherExpenses;
  const CheckoutRequest({
    super.key,
    required this.total,
    required this.request,
    required this.colorCost,
    required this.materialCost,
    required this.laborCost,
    required this.otherExpenses,
  });

  @override
  State<CheckoutRequest> createState() => _CheckoutRequestState();
}

class _CheckoutRequestState extends State<CheckoutRequest> {
  List<String> shippingMethod = ['J&T', "NinjaVan"];
  int selectedShippingMethod = 0;

  //tariff calculation API
  double deliveryFee = 200.0;

  void selectShippingMethod(int index) {
    setState(() {
      selectedShippingMethod = index;
    });
  }

  Future<void> submitOrder(
      String userId,
      String shippingAddress,
      String shippingProvince,
      String shippingCity,
      String shippingZipCode,
      String shippingStreet,
      double shippingFee) async {
    final products = [
      {
        'productId': widget.request.productId,
        'quantity': widget.request.reqquantity,
        'variationId': "",
        'priceEach': widget.total / widget.request.reqquantity,
        'totalPrice': widget.total,
      }
    ];

    final requestDetails = {
      'color': widget.request.color,
      'size': widget.request.size,
      'colorId': widget.request.colorId,
      'material': widget.request.material,
      'materialId': widget.request.materialId,
      'others': widget.request.others,
      'colorQuantity': widget.request.colorQuantity,
      'materialQuantity': widget.request.materialQuantity,
    };

    final orderData = {
      'userId': userId,
      'orderDate': FieldValue.serverTimestamp(),
      'products': products,
      'totalPrice': widget.total + shippingFee,
      'shippingAddress': shippingAddress,
      'shippingCity': shippingCity,
      'shippingZipCode': shippingZipCode,
      'shippingStreet': shippingStreet,
      'shippingMethod': shippingMethod[selectedShippingMethod],
      'shippingStatus': "Pending",
      'completedDate': null,
      'requestDetails': requestDetails,
      'shippingProvince': shippingProvince,
      'reason': "",
      'shippingFee': shippingFee,
    };

    await OrderService().placeOrder(orderData);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: UserService().streamUser(user?.uid), initialData: null),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F0F0),
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: const Color(0xFFF0F0F0),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              title: const Text(
                'CHECK-OUT',
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 16,
                  fontFamily: 'Avenir Next LT Pro',
                  fontWeight: FontWeight.w700,
                ),
              )),
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Shipping Address",
                        style: TextStyle(
                          color: Color(0xFF909090),
                          fontSize: 18,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      Builder(builder: (context) {
                        final user = Provider.of<UserModel?>(context);
                        return GestureDetector(
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
                          },
                          child: SvgPicture.asset('assets/icons/edit.svg'),
                        );
                      })
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextName(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextContactNumber(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextAddress(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Payment",
                    style: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 18,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/codicon.svg'),
                          ),
                        ),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Cash On Delivery (COD)",
                              style: TextStyle(
                                color: Color(0xFF303030),
                                fontSize: 14,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Text(
                  //       "Delivery Method",
                  //       style: TextStyle(
                  //         color: Color(0xFF909090),
                  //         fontSize: 18,
                  //         fontFamily: 'Nunito Sans',
                  //         fontWeight: FontWeight.w600,
                  //         height: 0,
                  //       ),
                  //     ),
                  //     GestureDetector(
                  //         onTap: () {
                  //           Navigator.of(context).push(
                  //             MaterialPageRoute(
                  //               builder: (context) =>
                  //                   DeliveryMethod(onTap: selectShippingMethod),
                  //             ),
                  //           );
                  //         },
                  //         child: SvgPicture.asset('assets/icons/edit.svg'))
                  //   ],
                  // ),
                  // const SizedBox(height: 10),
                  // Container(
                  //   width: double.infinity,
                  //   height: 50,
                  //   decoration: const BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.all(Radius.circular(5))),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: selectedShippingMethod == 0
                  //             ? Image.asset('assets/images/jandt.jpg')
                  //             : Image.asset('assets/images/ninjavan.jpg'),
                  //       ),
                  //       Center(
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Text(
                  //             selectedShippingMethod == 0
                  //                 ? "Fast (5 - 7 days)"
                  //                 : "NinjaVan (10 days)",
                  //             style: const TextStyle(
                  //               color: Color(0xFF303030),
                  //               fontSize: 14,
                  //               fontFamily: 'Nunito Sans',
                  //               fontWeight: FontWeight.w700,
                  //               height: 0,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 50),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Material Cost:",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "₱${widget.materialCost.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Color(0xFF303030),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Color Cost:",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "₱${widget.colorCost.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Color(0xFF303030),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Labor Cost:",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "₱${widget.laborCost.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Color(0xFF303030),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Other Expenses:",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "₱${widget.otherExpenses.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Color(0xFF303030),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Quantity:",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${widget.request.reqquantity}",
                                style: const TextStyle(
                                  color: Color(0xFF303030),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Delivery:",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextShippingFee()
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextTotalAmount(total: widget.total)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Estimated Arrival:",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              ETA()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                      child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: SubmitButton(
                      submitOrder: submitOrder,
                      userId: user?.uid ?? "",
                      requestId: widget.request.id,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatefulWidget {
  final Function submitOrder;
  final String userId;
  final String requestId;

  const SubmitButton({
    super.key,
    required this.submitOrder,
    required this.userId,
    required this.requestId,
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isOrderPlacing = false;
  bool address = false;
  bool contactNumber = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user != null) {
      address = user.getStringAddress().isEmpty;
      contactNumber = user.contactNumber.isEmpty;
      user.shippingAddress['city'] ?? "";
    }

    return ElevatedButton(
      onPressed: address || contactNumber
          ? () {
              showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Stack(
                            children: [
                              Center(
                                child: Stack(
                                  children: [
                                    ListView(
                                      shrinkWrap: true,
                                      children: [
                                        const SizedBox(height: 12),
                                        Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            border: Border.all(
                                              color: const Color(0xffa7a6a5),
                                            ),
                                          ),
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 48),
                                              Text(
                                                address
                                                    ? "Input an address for delivery"
                                                    : "Input a contact number for delivery",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(height: 48),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                          )),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .black),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                          "OK",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        )),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      right: 0.0,
                                      left: 0.0,
                                      top: 0.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Align(
                                          alignment: Alignment.topCenter,
                                          child: CircleAvatar(
                                            radius: 32.0,
                                            backgroundColor: Colors.black,
                                            child: Icon(
                                              Icons.priority_high_rounded,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )));
            }
          : !isOrderPlacing
              ? () async {
                  showDialog(
                      context: context,
                      builder: (context) => ConfirmationAlertDialog(
                          title: 'Are you sure you want to checkout?',
                          onTapNo: () {
                            Navigator.pop(context);
                          },
                          onTapYes: () async {
                            if (user == null) return;

                            setState(() {
                              isOrderPlacing = true;
                            });
                            await widget.submitOrder(
                                widget.userId,
                                user.getStringAddress(),
                                user.shippingAddress['province'] ?? "",
                                user.shippingAddress['city'] ?? "",
                                user.shippingAddress['zipCode'] ?? "",
                                user.shippingAddress['street'] ?? "",
                                user.shippingFee);
                            // await RequestsService().removeFromRequest(
                            //     widget.userId, widget.requestId);
                            setState(() {
                              isOrderPlacing = false;
                            });
                            if (context.mounted) {
                              Navigator.pop(context);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const ShippingSuccess(),
                                ),
                              );
                            }
                          },
                          tapNoString: "No",
                          tapYesString: "Yes"));
                }
              : null,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: const Text(
        "SUBMIT ORDER",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
    );
  }
}

class TextName extends StatelessWidget {
  const TextName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    return Text(
      user?.name ?? "",
      style: const TextStyle(
        color: Color(0xFF303030),
        fontSize: 18,
        fontFamily: 'Nunito Sans',
        fontWeight: FontWeight.w700,
        height: 0,
      ),
    );
  }
}

class TextShippingFee extends StatelessWidget {
  const TextShippingFee({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    // const String sampleAddress =
    //     "187 Mabuhay Lane, New Zaniga, Barangay Poblacion, Tondo, Manila";

    double shippingFee = 0.0;

    if (user != null) {
      shippingFee = user.shippingFee;
    }

    return Text(
      "₱${shippingFee.toStringAsFixed(0)}",
      style: const TextStyle(
        color: Color(0xFF303030),
        fontSize: 18,
        fontFamily: 'Nunito Sans',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class ETA extends StatelessWidget {
  const ETA({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current date
    DateTime currentDate = DateTime.now();

    // Add 14 days to the current date
    DateTime futureDate = currentDate.add(Duration(days: 14));

    // Format dates
    String formattedFutureDate = DateFormat('dd/MM/yyyy').format(futureDate);

    return Text(
      formattedFutureDate,
      style: const TextStyle(
        color: Color(0xFF303030),
        fontSize: 18,
        fontFamily: 'Nunito Sans',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class TextTotalAmount extends StatelessWidget {
  final double total;
  const TextTotalAmount({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    // const String sampleAddress =
    //     "187 Mabuhay Lane, New Zaniga, Barangay Poblacion, Tondo, Manila";

    double totalamount = 0.0;

    if (user != null) {
      totalamount = user.shippingFee + total;
    }

    return Text(
      "₱${totalamount.toStringAsFixed(0)}",
      style: const TextStyle(
        color: Color(0xFF303030),
        fontSize: 18,
        fontFamily: 'Nunito Sans',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class TextAddress extends StatelessWidget {
  const TextAddress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    // const String sampleAddress =
    //     "187 Mabuhay Lane, New Zaniga, Barangay Poblacion, Tondo, Manila";

    String address = "";

    if (user != null) {
      address = user.getStringAddress().isEmpty
          ? "No Address"
          : user.getStringAddress();
    }

    return Text(
      address,
      style: const TextStyle(
        color: Color(0xFF808080),
        fontSize: 14,
        fontFamily: 'Nunito Sans',
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class TextContactNumber extends StatelessWidget {
  const TextContactNumber({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    // const String sampleAddress =
    //     "187 Mabuhay Lane, New Zaniga, Barangay Poblacion, Tondo, Manila";

    String contact = "";

    if (user != null) {
      contact =
          user.contactNumber.isEmpty ? "No Contact Number" : user.contactNumber;
    }

    return Text(
      contact,
      style: const TextStyle(
        color: Color(0xFF808080),
        fontSize: 14,
        fontFamily: 'Nunito Sans',
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
