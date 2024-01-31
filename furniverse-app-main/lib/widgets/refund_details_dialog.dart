import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:furniverse/models/refund.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class RefundDetails extends StatefulWidget {
  final Refund refund;
  final String productName;
  const RefundDetails({
    super.key,
    required this.refund,
    required this.productName,
  });

  @override
  State<RefundDetails> createState() => _RefundDetailsState();
}

class _RefundDetailsState extends State<RefundDetails> {
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
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    _reasonController.text = widget.refund.reason;
    _phoneController.text = widget.refund.eWalletNumber;

    listItems.add({
      // "imageID": 1,
      "widget": GestureDetector(
        onTap: () async {
          final id = const Uuid().v4();
          // final loadingID = const Uuid().v4();

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
                    readOnly: true,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        labelText: 'E-Wallet Number',
                        hintText: "Ex: 09999999999"),
                    readOnly: true,
                  ),
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
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.refund.images.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              return Container(
                                width: 80,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    // border:
                                    //     Border.all(width: 2, color: const Color(0xFFA9ADB2)),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          widget.refund.images[index] ??
                                              "http://via.placeholder.com/350x150",
                                        ),
                                        fit: BoxFit.cover)),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
