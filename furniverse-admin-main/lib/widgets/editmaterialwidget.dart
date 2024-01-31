import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/services/materials_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';

class EditMaterialWidget extends StatefulWidget {
  const EditMaterialWidget({super.key, this.id, required this.materials});

  final id;
  final Materials? materials;

  @override
  State<EditMaterialWidget> createState() => _EditMaterialWidgetState();
}

class _EditMaterialWidgetState extends State<EditMaterialWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _materialController = TextEditingController();
  final _colorController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _priceController = TextEditingController();
  final _stocksController = TextEditingController();

  // String? image;
  // String? model;
  // XFile? selectedImage;
  // File? selectedModel;
  // final ImagePicker _picker = ImagePicker();
  // String error = '';
  final List<String> items = [
    'inch',
    'cm',
    'ft',
    'm',
  ];
  String? selectedCategory;
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
    _materialController.text = widget.materials!.material;
    _priceController.text = widget.materials!.price.toStringAsFixed(2);
    _stocksController.text = widget.materials!.stocks.toString();
    _lengthController.text = widget.materials!.length.toStringAsFixed(2);
    _widthController.text = widget.materials!.width.toStringAsFixed(2);
    _heightController.text = widget.materials!.height.toStringAsFixed(2);
    selectedCategory = widget.materials!.metric;

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _materialController.dispose();
    _colorController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _priceController.dispose();
    _stocksController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var fileName = selectedModel != null
    //     ? basename(selectedModel!.path)
    //     : "Upload 3D Model";
    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(10),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Edit Material"),
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
              height: 310,
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
                      controller: _materialController,
                      decoration: outlineInputBorder(label: 'Material'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        print(value);
                        return value!.isEmpty
                            ? 'Please input a material.'
                            : null;
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
                  TextFormField(
                    controller: _stocksController,
                    decoration: outlineInputBorder(label: 'Stocks'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value!.isEmpty ? 'Please input a stock/s.' : null,
                  ),
                  const Gap(20),

                   Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 100,
                          child: TextFormField(
                            controller: _lengthController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: 'Length',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value!.isEmpty
                                ? 'Please input a length.'
                                : null,
                          )),

                      Padding(
                          padding: EdgeInsets.only(top: 25), child: Text("X")),

                      Container(
                          width: 100,
                          child: TextFormField(
                            controller: _widthController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: 'Width',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value!.isEmpty ? 'Please input a width.' : null,
                          )),

                      Padding(
                          padding: EdgeInsets.only(top: 25), child: Text("X")),

                      Container(
                          width: 100,
                          child: TextFormField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: 'Height',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value!.isEmpty
                                ? 'Please input a height.'
                                : null,
                          )
                        ),
                    ],
                  ),
                  const Gap(20),

                  DropdownButtonFormField2<String>(
                        buttonStyleData: const ButtonStyleData(
                          height: 26,
                          padding: EdgeInsets.only(right: 8),
                        ),
                        hint: const Text(
                          'Select Metric Length',
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
                          padding: EdgeInsets.symmetric(horizontal: 16),
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
                          });
                        },
                      ),
                    
                  const Gap(20),

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
    MaterialsServices materialService = MaterialsServices();
    // final product = FirebaseFirestore.instance.collection('products').doc();

    // final provider = Provider.of<VariantsProvider>(context, listen: false);
    // provider.saveVariant(product.id);
    // provider.getMap();

    // final images = await uploadSelectedImages();
    // // final model = await uploadModelToFirebase(file);
    // final productMaps = await provider.getMap();

    Map<String, dynamic> materialData = {
      'material': _materialController.text,
      // 'material': _materialController.text,
      // 'dimension': _dimensionController.text,
      // 'price': _priceController.text,
      // 'product 3D model': model,
      'price': double.parse(_priceController.text),
      'stocks': int.parse(_stocksController.text),
      'length': double.parse(_lengthController.text),
      'width': double.parse(_widthController.text),
      'height': double.parse(_heightController.text),
      'metric': selectedCategory
    };

    // Add the product to Firestore
    await materialService.updateMaterial(materialData, widget.id);
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
      msg: "Material Edited Successfully.",
      backgroundColor: Colors.grey,
    );
  }
}
