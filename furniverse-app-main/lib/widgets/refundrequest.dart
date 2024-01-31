import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse/models/refund.dart';
import 'package:furniverse/services/refund_service.dart';
import 'package:furniverse/services/upload_image_services.dart';
import 'package:furniverse/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class RefundRequest extends StatefulWidget {
  final String productId;
  final String productName;
  final double totalPrice;
  final int quantity;
  final String userId;
  final String orderId;
  final String variantId;
  const RefundRequest(
      {super.key,
      required this.productId,
      required this.productName,
      required this.totalPrice,
      required this.quantity,
      required this.userId,
      required this.orderId,
      required this.variantId});

  @override
  State<RefundRequest> createState() => _RefundRequestState();
}

class _RefundRequestState extends State<RefundRequest> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _phoneController = TextEditingController();

  UploadTask? uploadTask;
  File? file;
  // List<ProductVariants> list = [];
  List<Map<String, dynamic>> listItems = [];
  List<String> productImages = [];

  //image picker
  XFile? selectedImage;
  List<XFile> listSelectedImage = [];
  String? imageUrl;
  bool imageIsUploaded = false;
  final ImagePicker _picker = ImagePicker();
  bool isSaving = false;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
        listSelectedImage.add(image);
      });
    }
  }

  Future<List<String>> uploadSelectedImages() async {
    List<String> images = [];
    for (int i = 0; i < listSelectedImage.length; i++) {
      String? downloadUrl =
          await uploadRefundImageToFirebase(listSelectedImage[i]);
      imageUrl = downloadUrl;
      images.add(downloadUrl!);
    }
    return images;
  }

  @override
  void initState() {
    super.initState();

    listItems.add({
      // "imageID": 1,
      "widget": GestureDetector(
        onTap: () async {
          final id = const Uuid().v4();
          // final loadingID = const Uuid().v4();
          await pickImage();

          setState(() {
            listItems.insert(0, {
              'id': id,
              'widget': Stack(
                children: [
                  Container(
                    width: 80,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      // border:
                      //     Border.all(width: 2, color: const Color(0xFFA9ADB2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.file(
                      File(selectedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          listItems.removeWhere((element) {
                            return element['id'] == id;
                          });
                          listSelectedImage.remove(selectedImage);
                        });
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFFF0F0F0),
                      ),
                    ),
                  ),
                ],
              )
            });
          });
        },
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: const Color(0xFFA9ADB2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.add,
          ),
        ),
      )
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Request Refund for ${widget.productName}"),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const Gap(10),
            SizedBox(
              height: 220,
              width: double.maxFinite,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const Gap(10),
                  TextFormField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      labelText: "Reason of the Request for Refund",
                    ),
                    maxLines: 5,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value!.isEmpty
                        ? 'Please input a reason of request.'
                        : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Contact Number',
                          hintText: "Ex: 09999999999"),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }

                        if (!RegExp(r'^09[0-9]{9}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }

                        return null;
                      }),
                  const SizedBox(height: 15),
                  const Text(
                    'Product Images',
                    style: TextStyle(
                      color: Color(0xFF43464B),
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: listItems.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              return listItems[index]['widget'];
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) return;
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationAlertDialog(
                              title:
                                  "Are you sure you want to request a refund for this order?",
                              onTapNo: () {
                                Navigator.pop(context);
                              },
                              onTapYes: () async {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                                Fluttertoast.showToast(
                                  msg: "Refund Requested.",
                                  backgroundColor: Colors.grey,
                                );

                                List<String> images =
                                    await uploadSelectedImages();

                                await RefundService().addToRefunds(
                                  Refund(
                                    contactNumber: _phoneController.text,
                                    eWalletNumber: _phoneController.text,
                                    images: images,
                                    productId: widget.productId,
                                    quantity: widget.quantity,
                                    reason: _reasonController.text,
                                    totalPrice: widget.totalPrice,
                                    userId: widget.userId,
                                    orderId: widget.orderId,
                                    variantId: widget.variantId,
                                  ),
                                );
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
                        "SUBMIT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
