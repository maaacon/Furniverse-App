import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/color_model.dart';
import 'package:furniverse_admin/models/edit_product_variants_model.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class EditOldVariantWidget extends StatefulWidget {
  final EditProductVariants productVariants;
  final List<Materials> materials;

  const EditOldVariantWidget(
      {super.key, required this.productVariants, required this.materials});

  @override
  State<EditOldVariantWidget> createState() => _EditOldVariantWidgetState();
}

class _EditOldVariantWidgetState extends State<EditOldVariantWidget> {
  String name = "";
  String material = "";
  String color = "";
  double lengths = 0.0;
  double widths = 0.0;
  double heights = 0.0;
  String id = "";
  double price = 0.0;
  int stocks = 0;
  dynamic selectedImage;
  dynamic selectedModel;
  XFile? selectedNewImage;
  File? selectedNewModel;

  final List<String> items = [
    'inch',
    'cm',
    'ft',
    'm',
  ];
  String? selectedCategory;
  String? selectedMaterial;
  String? selectedColor;

  @override
  void initState() {
    var variant = widget.productVariants;

    name = variant.variantName;
    material = variant.material;
    color = variant.color;
    lengths = variant.length;
    widths = variant.width;
    heights = variant.height;
    price = variant.price;
    stocks = variant.stocks;
    selectedImage = variant.image;
    selectedModel = variant.model;
    // selectedCategory = variant.metric;
    id = variant.id;
    selectedNewImage = variant.selectedNewImage;
    selectedNewModel = variant.selectedNewModel;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  // final _materialController = TextEditingController();
  // final _colorController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _priceController = TextEditingController();
  final _stocksController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String error = '';

  @override
  void dispose() {
    _nameController.dispose();
    // _materialController.dispose();
    // _colorController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _priceController.dispose();
    _stocksController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedNewImage = image;
      });
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,

      // for GLB files only
      // type: FileType.any,
      // allowedExtensions: ['glb'],
    );
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() => selectedNewModel = File(path));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<List<ColorModel>?>(context);

    _nameController.text = name;
    // _materialController.text = material;
    // _colorController.text = color;
    _lengthController.text = lengths.toStringAsFixed(2);
    _widthController.text = widths.toStringAsFixed(2);
    _heightController.text = heights.toStringAsFixed(2);
    _priceController.text = price.toStringAsFixed(2);
    _stocksController.text = stocks.toString();
    // var fileName = selectedModel != null
    //     ? basename(selectedModel!.path)
    //     : "Upload 3D Model";
    var fileName = selectedNewModel == null
        ? "$name's 3D Model"
        : basename(selectedNewModel!.path);
    String hintTextColor = "#000000";

    for (var col in colors ?? []) {
      if (color == col.color) {
        hintTextColor = col.hexValue;
      }
    }

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
                const Text("Edit Variant"),
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
              height: 400,
              width: double.maxFinite,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Center(
                      child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: selectedNewImage == null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    selectedImage ?? imagePlaceholder,
                                  ),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        child: selectedNewImage != null
                            ? Image.file(
                                File(selectedNewImage!.path),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () async {
                            if (selectedNewImage == null) {
                              await pickImage();
                            } else {
                              setState(() {
                                selectedNewImage = null;
                              });
                            }
                          },
                          child: Icon(
                            selectedNewImage == null
                                ? Icons.add_photo_alternate_rounded
                                : Icons.undo_rounded,
                            size: 18,
                            color: foregroundColor,
                          ),
                        ),
                      ),
                    ],
                  )),
                  const Gap(20),
                  TextFormField(
                    controller: _nameController,
                    decoration: outlineInputBorder(label: 'Variant Name'),
                  ),
                  const Gap(20),
                  // TextFormField(
                  //   controller: _colorController,
                  //   decoration: outlineInputBorder(label: 'Color'),
                  // ),
                  DropdownButtonFormField2<String>(
                    buttonStyleData: const ButtonStyleData(
                      height: 26,
                      padding: EdgeInsets.only(right: 8),
                    ),
                    hint: Row(
                      children: [
                        Icon(
                          Icons.brightness_1,
                          color: hexToColor(hintTextColor),
                        ),
                        Gap(10),
                        Text(
                          color,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: [
                      for (var color in colors ?? [])
                        DropdownMenuItem<String>(
                          value: color.color,
                          child: Row(
                            children: [
                              Icon(
                                Icons.brightness_1,
                                color: hexToColor(color.hexValue),
                              ),
                              Gap(10),
                              Text(
                                color.color,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],
                    isExpanded: true,
                    value: selectedColor,
                    onChanged: (String? value) {
                      setState(() {
                        selectedColor = value;
                      });
                    },
                  ),
                  const Gap(20),
                  // TextFormField(
                  //   controller: _materialController,
                  //   decoration: outlineInputBorder(label: 'Material'),
                  // ),
                  DropdownButtonFormField2<String>(
                    buttonStyleData: const ButtonStyleData(
                      height: 26,
                      padding: EdgeInsets.only(right: 8),
                    ),
                    hint: Text(
                      material,
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: [
                      for (var material in widget.materials)
                        DropdownMenuItem<String>(
                          value: material.material,
                          child: Text(
                            material.material,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    isExpanded: true,
                    value: selectedMaterial,
                    onChanged: (String? value) {
                      setState(() {
                        selectedMaterial = value;
                      });
                    },
                  ),
                  const Gap(20),
                  DropdownButtonFormField2<String>(
                    buttonStyleData: const ButtonStyleData(
                      height: 26,
                      padding: EdgeInsets.only(right: 8),
                    ),
                    hint: Text(
                      widget.productVariants.metric,
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          )),
                    ],
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: _priceController,
                    decoration: outlineInputBorder(label: 'Price'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: _stocksController,
                    decoration: outlineInputBorder(label: 'Stocks'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const Gap(20),
                  GestureDetector(
                    // onTap: selectFile,
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 2, color: borderColor)),
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/model.svg'),
                                const Gap(8),
                                Text(
                                  fileName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: foregroundColor,
                                    fontSize: 16,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedModel != null)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 18,
                                constraints: const BoxConstraints(),
                                color: foregroundColor,
                                onPressed: () {
                                  if (selectedNewModel == null) {
                                    selectFile();
                                  } else {
                                    setState(() {
                                      selectedNewModel = null;
                                    });
                                  }
                                },
                                icon: selectedNewModel == null
                                    ? const Icon(
                                        Icons.upload_file_rounded,
                                      )
                                    : const Icon(Icons.undo_rounded),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationAlertDialog(
                              title:
                                  "Are you sure you want to save the changes in this variant?",
                              onTapNo: () {
                                Navigator.pop(context);
                              },
                              onTapYes: () async {
                                // final currentContext = context; // Capture the context outside the async block
                                editVariant(context);

                                Fluttertoast.showToast(
                                  msg: "Variant Changed Successfully.",
                                  backgroundColor: Colors.grey,
                                );
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
                        "Save Changes",
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

  editVariant(BuildContext context) {
    final isValid = _formKey.currentState?.validate();

    if (isValid! && selectedImage == null && selectedModel == null) {
      setState(() {
        error = "Input values are invalid";
      });
      print("Input values are invalid");
      return;
    } else {
      setState(() {
        error = "";
      });
      final newVariant = EditProductVariants(
        id: widget.productVariants.id,
        variantName: _nameController.text,
        material: selectedMaterial ?? material,
        color: selectedColor ?? color,
        image: selectedImage ?? "",
        length: double.parse(_lengthController.text),
        width: double.parse(_widthController.text),
        height: double.parse(_heightController.text),
        model: selectedModel ?? "",
        metric: selectedCategory ?? widget.productVariants.metric,
        price: double.parse(_priceController.text),
        stocks: int.parse(_stocksController.text),
        selectedNewImage: selectedNewImage,
        selectedNewModel: selectedNewModel,
      );

      final provider = Provider.of<VariantsProvider>(context, listen: false);
      provider.updateOldVariants(widget.productVariants, newVariant);

      Navigator.of(context).pop();
    }
  }

  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }
}
