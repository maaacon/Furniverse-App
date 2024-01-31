import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/models/delivery_model.dart';
import 'package:furniverse_admin/services/delivery_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';

class EditCityWidget extends StatefulWidget {
  const EditCityWidget({super.key, this.id, required this.delivery});

  final id;
  final Delivery? delivery;
  @override
  State<EditCityWidget> createState() => _EditCityWidgetState();
}

class _EditCityWidgetState extends State<EditCityWidget> {
  final _formKey = GlobalKey<FormState>();
  // final _nameController = TextEditingController();
  // final _materialController = TextEditingController();
  // final _colorController = TextEditingController();
  // final _dimensionController = TextEditingController();
  // final _stocksController = TextEditingController();
  final _cityController = TextEditingController();
  final _priceController = TextEditingController();

  // String? image;
  // String? model;
  // XFile? selectedImage;
  // File? selectedModel;
  // final ImagePicker _picker = ImagePicker();
  // String error = '';
  // final List<String> items = [
  //   'inch',
  //   'cm',
  //   'ft',
  //   'm',
  // ];
  // String? selectedCategory;
  // Future<void> pickImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       selectedImage = image;
  //     });
  //   }
  // }
  // Future selectFile() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.any,
  //     // for GLB files only
  //     // type: FileType.custom,
  //     // allowedExtensions: ['glb'],
  //   );
  //   if (result == null) return;
  //   final path = result.files.single.path!;
  //   setState(() => selectedModel = File(path));
  // }

  @override
  void initState() {
    _cityController.text = widget.delivery!.city;
    _priceController.text = widget.delivery!.price.toStringAsFixed(2);
    // _stocksController.text = widget.colorModel!.stocks.toString();

    super.initState();
  }

  @override
  void dispose() {
    // _nameController.dispose();
    // _materialController.dispose();
    // _colorController.dispose();
    // _dimensionController.dispose();
    // _stocksController.dispose();
    _cityController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var fileName = selectedModel != null
    //     ? basename(selectedModel!.path)
    //     : "Upload 3D Model";
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
                const Text("Edit City"),
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
            const Gap(20),
            SizedBox(
              height: 230,
              width: double.maxFinite,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // selectedImage == null
                  //     ? Center(
                  //         child: GestureDetector(
                  //           onTap: () async {
                  //             await pickImage();
                  //             setState(() {});
                  //           },
                  //           child: Container(
                  //             height: 80,
                  //             width: 80,
                  //             decoration: BoxDecoration(
                  //               border: Border.all(
                  //                   width: 2, color: const Color(0xFFA9ADB2)),
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //             child: const Icon(
                  //               Icons.add_a_photo_rounded,
                  //               color: foregroundColor,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : Center(
                  //         child: Stack(
                  //         children: [
                  //           Container(
                  //             width: 80,
                  //             clipBehavior: Clip.hardEdge,
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //             child: Image.file(
                  //               File(selectedImage!.path),
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //           Positioned(
                  //             top: 5,
                  //             right: 5,
                  //             child: GestureDetector(
                  //               onTap: () {
                  //                 setState(() {
                  //                   selectedImage = null;
                  //                 });
                  //               },
                  //               child: const Icon(
                  //                 Icons.close_rounded,
                  //                 size: 18,
                  //                 color: backgroundColor,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       )),
                  // const Gap(20),

                  TextFormField(
                      controller: _cityController,
                      decoration: outlineInputBorder(label: 'City'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        print(value);
                        return value!.isEmpty ? 'Please input a city.' : null;
                      }),
                  const Gap(20),

                  TextFormField(
                    controller: _priceController,
                    decoration: outlineInputBorder(label: 'Price'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value!.isEmpty ? 'Please input a price.' : null,
                  ),

                  const Gap(20),

                  ...[
                    // const Gap(20),
                    // TextFormField(
                    //   controller: _stocksController,
                    //   decoration: outlineInputBorder(label: 'Stocks'),
                    //   keyboardType: const TextInputType.numberWithOptions(
                    //     signed: false,
                    //     decimal: false,
                    //   ),
                    //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   validator: (value) =>
                    //     value!.isEmpty
                    //       ? 'Please input a stock/s.'
                    //       : null,
                    // ),
                    // const Gap(20),
                    // TextFormField(
                    //   controller: _colorController,
                    //   decoration: outlineInputBorder(label: 'Color'),
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   validator: (value) =>
                    //     value!.isEmpty
                    //       ? 'Please input a color.'
                    //       : null,
                    // ),
                    // const Gap(20),

                    // TextFormField(
                    //   controller: _materialController,
                    //   decoration: outlineInputBorder(label: 'Material'),
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   validator: (value) =>
                    //     value!.isEmpty
                    //       ? 'Please input a material.'
                    //       : null,
                    // ),
                    // const Gap(20),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Flexible(child: TextFormField(
                    //       controller: _dimensionController,
                    //       decoration: outlineInputBorder(label: 'Dimension/Size'),
                    //       autovalidateMode: AutovalidateMode.onUserInteraction,
                    //       validator: (value) =>
                    //         value!.isEmpty
                    //           ? 'Please input a dimension.'
                    //           : null,
                    //     ),),

                    //     Flexible(child: DropdownButtonFormField2<String>(
                    //       buttonStyleData: const ButtonStyleData(
                    //         height: 26,
                    //         padding: EdgeInsets.only(right: 8),
                    //       ),
                    //       hint: const Text(
                    //         'Select Metric Length',
                    //         style: TextStyle(fontSize: 16),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //       iconStyleData: const IconStyleData(
                    //         icon: Icon(
                    //           Icons.arrow_drop_down,
                    //         ),
                    //         iconSize: 24,
                    //       ),
                    //       dropdownStyleData: DropdownStyleData(
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //       ),
                    //       menuItemStyleData: const MenuItemStyleData(
                    //         padding: EdgeInsets.symmetric(horizontal: 16),
                    //       ),
                    //       decoration: InputDecoration(
                    //         contentPadding:
                    //             const EdgeInsets.symmetric(vertical: 16),
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //       ),
                    //       // autovalidateMode: AutovalidateMode.onUserInteraction,
                    //       // validator: (value) =>
                    //       //     value!.isEmpty ? 'Please select a metric length.' : null,
                    //       items: items
                    //           .map((String item) => DropdownMenuItem<String>(
                    //                 value: item,
                    //                 child: Text(
                    //                   item,
                    //                   style: const TextStyle(
                    //                     fontSize: 16,
                    //                     // fontWeight: FontWeight.bold,
                    //                     // color: Colors.],
                    //                   ),
                    //                   overflow: TextOverflow.ellipsis,
                    //                 ),
                    //               ))
                    //           .toList(),
                    //       isExpanded: true,
                    //       value: selectedCategory,
                    //       onChanged: (String? value) {
                    //         setState(() {
                    //           selectedCategory = value;
                    //         });
                    //       },
                    //     ),)
                    //   ],
                    // ),

                    // const Gap(20),

                    // GestureDetector(
                    //   onTap: selectFile,
                    //   child: Container(
                    //     height: 60,
                    //     width: double.infinity,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(8),
                    //         border: Border.all(width: 2, color: borderColor)),
                    //     child: Stack(
                    //       children: [
                    //         Center(
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               SvgPicture.asset('assets/icons/model.svg'),
                    //               const Gap(8),
                    //               Text(
                    //                 fileName,
                    //                 textAlign: TextAlign.center,
                    //                 style: const TextStyle(
                    //                   color: foregroundColor,
                    //                   fontSize: 16,
                    //                   fontFamily: 'Nunito Sans',
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         if (selectedModel != null)
                    //           Positioned(
                    //             top: 5,
                    //             right: 5,
                    //             child: IconButton(
                    //               padding: EdgeInsets.zero,
                    //               iconSize: 18,
                    //               constraints: const BoxConstraints(),
                    //               color: foregroundColor,
                    //               onPressed: () {
                    //                 setState(() {
                    //                   selectedModel = null;
                    //                 });
                    //               },
                    //               icon: const Icon(
                    //                 Icons.close,
                    //               ),
                    //             ),
                    //           ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const Gap(20),
                  ],

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) return;
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationAlertDialog(
                              title:
                                  "Are you sure you want to save this changes?",
                              onTapNo: () {
                                Navigator.pop(context);
                              },
                              onTapYes: () async {
                                // final currentContext = context; // Capture the context outside the async block
                                // addVariant(context);
                                saveproduct(context);
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
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveproduct(BuildContext context) async {
    DeliveryService deliveryService = DeliveryService();
    // final product = FirebaseFirestore.instance.collection('products').doc();

    // final provider = Provider.of<VariantsProvider>(context, listen: false);
    // provider.saveVariant(product.id);
    // provider.getMap();

    // final images = await uploadSelectedImages();
    // // final model = await uploadModelToFirebase(file);
    // final productMaps = await provider.getMap();

    Map<String, dynamic> cityData = {
      'city': _cityController.text,
      // 'material': _materialController.text,
      // 'dimension': _dimensionController.text,
      // 'price': _priceController.text,
      // 'product 3D model': model,
      'price': double.parse(_priceController.text),
      // 'stocks': int.parse(_stocksController.text),
    };

    // Add the product to Firestore
    await deliveryService.updateDelivery(cityData, widget.id);
    // await productService.addProduct(productData, productMaps);

    // provider.clearVariant();
    // // for insurance
    // provider.clearOldVariant();

    // if (file == null) return;
    // if (file != null) {
    //   final fileName = basename(file!.path);
    //   final objectmodel =
    //       FirebaseStorage.instance.ref('threedifiles/$fileName');
    //   uploadTask = objectmodel.putFile(file!);
    //   final snapshot = await uploadTask!.whenComplete(() {});
    //   final urlDownload = await snapshot.ref.getDownloadURL();
    //   print(product.path);

    //   final json = {
    //     'productname': _productnameController.text,
    //     'material': _materialController.text,
    //     'dimension': _dimensionController.text,
    //     'price': _priceController.text,
    //     'objectmodel': urlDownload,
    //   };
    // }

    Fluttertoast.showToast(
      msg: "City Edited Successfully.",
      backgroundColor: Colors.grey,
    );
  }
}
