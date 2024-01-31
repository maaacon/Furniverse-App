import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse/models/user.dart';
import 'package:furniverse/services/city_services.dart';
import 'package:furniverse/services/user_service.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:furniverse/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress(
      {super.key, required this.userModel, required this.cityList});
  final UserModel? userModel;
  final List<String> cityList;

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _streetController = TextEditingController();
  final _baranggayController = TextEditingController();
  // final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _zipCodeController = TextEditingController();

  String? selectedCategory;
  List<String> items = [];

  @override
  void initState() {
    String userCity = widget.userModel!.shippingAddress['city'];
    // await FirebaseFirestore.instance
    //     .collection('delivery')
    //     .orderBy('city')
    //     .get()
    //     .then((value) {
    //   final cities = value.docs.toList();
    //   for (var citi in cities) {
    //     print(citi);
    //     items.add(citi['city']);
    //   }
    // });
    items = widget.cityList;

    _nameController.text = widget.userModel!.name;
    _contactController.text = widget.userModel!.contactNumber;
    _streetController.text = widget.userModel!.shippingAddress['street'];
    _baranggayController.text = widget.userModel!.shippingAddress['baranggay'];
    // _cityController.text = user.shippingAddress['city'];
    _provinceController.text = widget.userModel!.shippingAddress['province'];
    _zipCodeController.text = widget.userModel!.shippingAddress['zipCode'];
    selectedCategory = userCity == "" ? selectedCategory : userCity;
    super.initState();
    // _nameController.text = user?.name ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _streetController.dispose();
    _baranggayController.dispose();
    // _cityController.dispose();
    _provinceController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void saveShippingAddress(String username, String email, Map shippingAddress,
      String id, String contact, double shippingFee) async {
    await UserService().updateUserData(
        username, email, shippingAddress, id, contact, shippingFee);
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userModel;
    // final user = Provider.of<UserModel?>(context);

    if (user != null) {
      // _nameController.text = user.name;
      // _contactController.text = user.contactNumber;
      // _streetController.text = user.shippingAddress['street'];
      // _baranggayController.text = user.shippingAddress['baranggay'];
      // // _cityController.text = user.shippingAddress['city'];
      // _provinceController.text = user.shippingAddress['province'];
      // _zipCodeController.text = user.shippingAddress['zipCode'];

      // // if (items.contains(user.shippingAddress['city'])) {
      // //   selectedCategory = user.shippingAddress['city'];
      // // }

      double shippingFee = 0.0;

      return SafeArea(
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
                'SHIPPING ADDRESS',
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 16,
                  fontFamily: 'Avenir Next LT Pro',
                  fontWeight: FontWeight.w700,
                ),
              )),
          body: SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Name',
                          hintText: "Ex: Bruno Pham"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                        controller: _contactController,
                        decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Contact Number',
                            hintText: "Ex: 09999999999"),
                        inputFormatters: [
                          // FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(13),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }

                          if (!RegExp(r'^(09|\+639)\d{9}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }

                          return null;
                        }),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _streetController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Street Address',
                          hintText: "Ex: Kahit Saan Street"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isEmpty
                          ? 'Please input a street address.'
                          : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _baranggayController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Baranggay',
                          hintText: "Ex: Brgy. Di Makita"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value!.isEmpty ? 'Please input a baranggay.' : null,
                    ),
                    //TODO: To remove
                    // const SizedBox(height: 15),
                    // TextFormField(
                    //   controller: _cityController,
                    //   decoration: const InputDecoration(
                    //       floatingLabelBehavior: FloatingLabelBehavior.always,
                    //       border: OutlineInputBorder(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(8))),
                    //       labelText: 'City/Municipality',
                    //       hintText: "Ex: Di Mahanap City"),
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   validator: (value) => value!.isEmpty
                    //       ? 'Please input a city/municipality.'
                    //       : null,
                    // ),
                    Gap(15),
                    //TODO: add actual selection from database
                    ...[
                      // StreamBuilder<QuerySnapshot>(
                      // stream: FirebaseFirestore.instance.collection('delivery').orderBy('city').snapshots(),
                      // builder: (context, snapshot){
                      //   final List<DropdownMenuItem> items = [];
                      //   if (!snapshot.hasData) {
                      //     const Loading();
                      //   } else {
                      //     final cities = snapshot.data?.docs.toList();
                      //       for (var citi in cities!) {
                      //         // items.add(citi['city']);
                      //         // if (selectedCategory == citi['city']) {
                      //         //   print(citi['price']);
                      //         // }
                      //         items.add(DropdownMenuItem(
                      //           value: citi['city'],
                      //           child: Text(citi['city'])));
                      //       }

                      //   } return
                      DropdownButtonFormField2<String>(
                        buttonStyleData: const ButtonStyleData(
                          height: 26,
                          padding: EdgeInsets.only(right: 8),
                        ),
                        hint: const Text(
                          'Select City/Municipality',
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                          ),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (value) =>
                        //     value!.isEmpty ? 'Please select a metric length.' : null,
                        items: items
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                      // color: Colors.],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        isExpanded: true,
                        value: selectedCategory,
                        onChanged: (String? value) {
                          setState(() {
                            selectedCategory = value;
                            // FirebaseFirestore.instance.collection('delivery').orderBy('city').get()
                            //             .then((value) { final cities = value.docs.toList();
                            //             for (var citi in cities) {
                            //                 if (selectedCategory == citi['city']) {
                            //                   setState(() {
                            //                     shippingFee = citi['price'];
                            //                   });
                            //                   // print(shippingFee);
                            //                 }
                            //               }
                            //             });
                          });
                        },
                      )

                      // })
                    ],

                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _provinceController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Province',
                          hintText: "Ex: Nawawala"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value!.isEmpty ? 'Please input a province.' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _zipCodeController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Zip Code (Postal Code)',
                          hintText: "Ex: 0000"),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isEmpty
                          ? 'Please input a Zip Code (Postal Code).'
                          : null,
                    ),
                    const Gap(20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final isValid = _formKey.currentState!.validate();
                          if (!isValid || selectedCategory == null) {
                            Fluttertoast.showToast(
                              msg: "Please complete the information needed.",
                              backgroundColor: Colors.grey,
                            );
                            print("Input values are invalid");
                            return;
                          }

                          showDialog(
                            context: context,
                            builder: (context) => ConfirmationAlertDialog(
                                title: "Are you sure you want to save",
                                onTapNo: () {
                                  Navigator.pop(context);
                                },
                                onTapYes: () {
                                  final userId =
                                      Provider.of<User?>(context, listen: false)
                                          ?.uid;
                                  if (userId != null) {
                                    Map<String, dynamic> shippingAddress = {
                                      'street': _streetController.text,
                                      'baranggay': _baranggayController.text,
                                      'city': selectedCategory,
                                      'province': _provinceController.text,
                                      'zipCode': _zipCodeController.text,
                                    };
                                    print(shippingAddress);

                                    FirebaseFirestore.instance
                                        .collection('delivery')
                                        .orderBy('city')
                                        .get()
                                        .then((value) {
                                      final cities = value.docs.toList();
                                      for (var citi in cities) {
                                        if (selectedCategory == citi['city']) {
                                          saveShippingAddress(
                                              _nameController.text,
                                              user.email,
                                              shippingAddress,
                                              userId,
                                              _contactController.text,
                                              citi['price']);
                                        }
                                      }
                                    });
                                  }
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                tapNoString: "No",
                                tapYesString: "Yes"),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          "SAVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
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
            ),
          ),
        ),
      );
    } else {
      return const Center(
        child: Loading(),
      );
    }
  }
}
