import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/models/product_variants_model.dart';
import 'package:furniverse_admin/screens/admin_home/pages/material_selection_page.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/services/upload_image_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/addvariantwidget.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:furniverse_admin/widgets/editvariantwidget.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:readmore/readmore.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _productnameController = TextEditingController();
  final _materialController = TextEditingController();
  final _dimensionController = TextEditingController();
  final _priceController = TextEditingController();
  final _fileController = TextEditingController();
  final _stocksController = TextEditingController();
  final _colorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _laborController = TextEditingController();
  final _expensesController = TextEditingController();
  final _colorQuantityRequired = TextEditingController();
  final _materialQuantityRequired = TextEditingController();

  UploadTask? uploadTask;
  File? file;
  List<ProductVariants> list = [];
  List<Map<String, dynamic>> listItems = [];
  List<String> productImages = [];
  List<Materials> customizeMaterials = [];

  //image picker
  XFile? selectedImage;
  List<XFile> listSelectedImage = [];
  String? imageUrl;
  bool imageIsUploaded = false;
  final ImagePicker _picker = ImagePicker();
  bool isSaving = false;

  //dropdown
  final List<String> items = [
    'Living Room',
    'Bedroom',
    'Dining Room',
    'Office',
    'Outdoor',
    'Storage and Organization',
  ];
  final List<String> guides = [
    'Rounded',
    'Box',
    'Rectangle',
  ];
  String? selectedCategory;
  String? selectedGuide;

  final Map guideMap = {
    'Rounded': 'assets/images/rounded.png',
    'Box': 'assets/images/box.png',
    'Rectangle': 'assets/images/rectangle.png',
  };

  void setCustomizeMaterials(List<Materials> materials) {
    setState(() {
      customizeMaterials = materials;
    });
  }

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
      String? downloadUrl = await uploadImageToFirebase(listSelectedImage[i]);
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
                    height: 80,
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
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: foregroundColor),
                        height: 16,
                        width: 16,
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: backgroundColor,
                        ),
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
  void dispose() {
    _productnameController.dispose();
    _materialController.dispose();
    _dimensionController.dispose();
    _priceController.dispose();
    _stocksController.dispose();
    _fileController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _laborController.dispose();
    _expensesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fileName = file != null ? basename(file!.path) : "Upload 3D Model";
    _fileController.text = fileName;

    final provider = Provider.of<VariantsProvider>(context);
    final variants = provider.variant;

    return isSaving
        ? const Loading()
        : SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  "ADD PRODUCT",
                ),
                titleTextStyle: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 16,
                  fontFamily: 'Avenir Next LT Pro',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
                elevation: 0,
                backgroundColor: const Color(0xFFF0F0F0),
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _productnameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Enter Product Name',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty
                              ? 'Please input a product name.'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField2<String>(
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          hint: const Text(
                            'Select Product Category',
                            style: TextStyle(fontSize: 16),
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
                          //     value!.isEmpty ? 'Please select a category.' : null,
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

                        // DONT DELETE for backup
                        // const SizedBox(height: 20),
                        // TextFormField(
                        //   controller: _categoryController,
                        //   decoration: const InputDecoration(
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(8))),
                        //     labelText: 'Category',
                        //   ),
                        // ),
                        const Gap(20),
                        // TextFormField(
                        //   controller: _colorController,
                        //   decoration: const InputDecoration(
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(8))),
                        //     labelText: 'Color',
                        //   ),
                        // ),
                        // const SizedBox(height: 20),
                        // TextFormField(
                        //   controller: _materialController,
                        //   decoration: const InputDecoration(
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(8))),
                        //     labelText: 'Material',
                        //   ),
                        // ),
                        // const SizedBox(height: 20),
                        // TextFormField(
                        //   controller: _dimensionController,
                        //   decoration: const InputDecoration(
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(8))),
                        //     labelText: 'Dimension/Size',
                        //   ),
                        // ),
                        // const SizedBox(height: 20),
                        // TextFormField(
                        //   controller: _priceController,
                        //   decoration: const InputDecoration(
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(8))),
                        //     labelText: 'Price',
                        //   ),
                        //   keyboardType: const TextInputType.numberWithOptions(
                        //     signed: false,
                        //     decimal: true,
                        //   ),
                        //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        // ),
                        // const SizedBox(height: 20),
                        // TextFormField(
                        //   controller: _stocksController,
                        //   decoration: const InputDecoration(
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(8))),
                        //     labelText: 'Stocks',
                        //   ),
                        //   keyboardType: const TextInputType.numberWithOptions(
                        //     signed: false,
                        //     decimal: true,
                        //   ),
                        //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        // ),
                        // const SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 3,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: 'Enter Product Description',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty
                              ? 'Please input a product description.'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Upload Product Images:',
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
                                      const SizedBox(
                                    width: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return listItems[index]['widget'];
                                    // return null;
                                  },
                                  // children: [

                                  // ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // const Text(
                        //   'Product 3d Model',
                        //   style: TextStyle(
                        //     color: Color(0xFF43464B),
                        //     fontSize: 13,
                        //     fontFamily: 'Nunito Sans',
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // TextFormField(
                        //   controller: _fileController,
                        //   onTap: selectFile,
                        //   decoration: const InputDecoration(
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(8))),
                        //     labelText: 'Upload 3d Model',
                        //   ),
                        // ),
                        // const Gap(10),
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
                        //         if (file != null)
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
                        //                   file = null;
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
                        // const SizedBox(height: 20),\
                        const Text(
                          'Select Product Materials:',
                          style: TextStyle(
                            color: Color(0xFF43464B),
                            fontSize: 13,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MaterialSelectionPage(
                                      onTap: setCustomizeMaterials,
                                      materials: customizeMaterials,
                                    );
                                  },
                                ),
                              );
                            },
                            child: DottedBorder(
                              color: foregroundColor,
                              radius: const Radius.circular(8),
                              borderType: BorderType.RRect,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${customizeMaterials.length} Materials Selected",
                                      style: TextStyle(
                                        color: foregroundColor,
                                        fontSize: 16,
                                        fontFamily: 'Nunito Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Gap(20),

                        const Text(
                          'Add Product Variants:',
                          style: TextStyle(
                            color: Color(0xFF43464B),
                            fontSize: 13,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (variants.isNotEmpty)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                Container(height: 8),
                            itemCount: variants.length,
                            itemBuilder: (context, index) {
                              final variant = variants[index];

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          color: foregroundColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Image.file(
                                          File(variant.image.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const Gap(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            variant.variantName,
                                            style: const TextStyle(
                                              color: foregroundColor,
                                              fontSize: 16,
                                              fontFamily: 'Nunito Sans',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            "Price: ₱${variant.price.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: foregroundColor,
                                              fontSize: 12,
                                              fontFamily: 'Nunito Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "Stocks: ${variant.stocks}",
                                            style: const TextStyle(
                                              color: foregroundColor,
                                              fontSize: 12,
                                              fontFamily: 'Nunito Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "3D Model: ${basename(variant.model.path)}",
                                            style: const TextStyle(
                                              color: foregroundColor,
                                              fontSize: 12,
                                              fontFamily: 'Nunito Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: ReadMoreText(
                                              "LWH: ${variant.length} x ${variant.width} x ${variant.height} ${variant.metric}; Color: ${variant.color}; Material: ${variant.material}; ",
                                              style: const TextStyle(
                                                color: foregroundColor,
                                                fontSize: 12,
                                                fontFamily: 'Nunito Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              trimLines: 1,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: 'More',
                                              trimExpandedText: ' Less',
                                              moreStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              lessStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          showDialog(
                                              builder: (context) =>
                                                  EditVariantWidget(
                                                    productVariants: variant,
                                                    materials:
                                                        customizeMaterials,
                                                  ),
                                              context: context,
                                              barrierDismissible: false);
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: foregroundColor,
                                        ),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ConfirmationAlertDialog(
                                                      title:
                                                          "Are you sure you want to delete this variant?",
                                                      onTapNo: () {
                                                        Navigator.pop(context);
                                                      },
                                                      onTapYes: () async {
                                                        // final currentContext = context; // Capture the context outside the async block
                                                        final provider = Provider
                                                            .of<VariantsProvider>(
                                                                context,
                                                                listen: false);
                                                        provider.removeVariant(
                                                            variant);

                                                        Fluttertoast.showToast(
                                                          msg:
                                                              "Variant Deleted Successfully.",
                                                          backgroundColor:
                                                              Colors.grey,
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      tapNoString: "No",
                                                      tapYesString: "Yes"),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: foregroundColor,
                                          ))
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        Gap(10),

                        AddVariantButton(
                          materials: customizeMaterials,
                        ),
                        const Gap(20),

                        const Text(
                          'CUSTOMER CUSTOMIZATION FORM',
                          style: TextStyle(
                            color: Color(0xFF43464B),
                            fontSize: 13,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(10),
                        DropdownButtonFormField2<String>(
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          hint: const Text(
                            'Select Customization Guide',
                            style: TextStyle(fontSize: 16),
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
                          //     value!.isEmpty ? 'Please select a category.' : null,
                          items: guides
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Image.asset(guideMap[item]),
                                        ),
                                        Gap(10),
                                        Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          isExpanded: true,
                          value: selectedGuide,
                          onChanged: (String? value) {
                            setState(() {
                              selectedGuide = value;
                            });
                          },
                        ),
                        Gap(20),

                        TextFormField(
                          controller: _laborController,
                          decoration:
                              outlineInputBorder(label: 'Enter Labor Cost'),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty
                              ? 'Please input a Labor Cost.'
                              : null,
                        ),

                        const Gap(20),
                        TextFormField(
                          controller: _expensesController,
                          decoration:
                              outlineInputBorder(label: 'Enter Other Expenses'),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty
                              ? 'Please input a other expenses.'
                              : null,
                        ),
                        const Gap(20),
                        const Text(
                          'Required Quantity of Resources for Customization',
                          style: TextStyle(
                            color: Color(0xFF43464B),
                            fontSize: 13,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(10),
                        TextFormField(
                          controller: _materialQuantityRequired,
                          decoration: outlineInputBorder(
                              label:
                                  'Enter the Number of Material Stocks (pieces)'),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty
                              ? 'Please input a required quantity for material (pieces).'
                              : null,
                        ),
                        const Gap(10),
                        TextFormField(
                          controller: _colorQuantityRequired,
                          decoration: outlineInputBorder(
                              label:
                                  'Enter the Number of Color Stocks (liters)'),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty
                              ? 'Please input a required quantity for paint (liters).'
                              : null,
                        ),
                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 60,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       showDialog(
                        //           builder: (context) => const AddProductWidget(),
                        //           context: context,
                        //           barrierDismissible: false);
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.black,
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(8))),
                        //     child: const Text(
                        //       "Add Variant",
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 18,
                        //         fontFamily: 'Nunito Sans',
                        //         fontWeight: FontWeight.w600,
                        //         height: 0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const Gap(20),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              final isValid = _formKey.currentState!.validate();
                              if (!isValid ||
                                  listSelectedImage.isEmpty ||
                                  variants.isEmpty ||
                                  customizeMaterials.isEmpty ||
                                  selectedCategory == null ||
                                  selectedGuide == null) {
                                Fluttertoast.showToast(
                                  msg:
                                      "Please complete the information needed.",
                                  backgroundColor: Colors.grey,
                                );
                                print("Input values are invalid");
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmationAlertDialog(
                                    title:
                                        "Are you sure you want to add this product?",
                                    onTapNo: () {
                                      Navigator.pop(context);
                                    },
                                    onTapYes: () async {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }

                                      // setState(() {
                                      //   isSaving = true;
                                      // });
                                      Fluttertoast.showToast(
                                        msg: "Adding New Product...",
                                        backgroundColor: Colors.grey,
                                      );

                                      await saveproduct(context);
                                      // setState(() {
                                      //   isSaving =
                                      //       false; // Set the flag back to false when saving is complete
                                      // });
                                      Fluttertoast.showToast(
                                        msg: "Product Added Successfully",
                                        backgroundColor: Colors.grey,
                                      );

                                      // saveproduct(context).then((_) {

                                      //   // Show the "Upload Complete" snackbar
                                      //   // ScaffoldMessenger.of(context).showSnackBar(
                                      //   //   const SnackBar(
                                      //   //     content: Text('Product Saved'),
                                      //   //     duration: Duration(seconds: 2),
                                      //   //   ),
                                      //   // );

                                      // });
                                    },
                                    tapNoString: "No",
                                    tapYesString: "Yes"),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Save Product",
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
                ),
              ),
            ),
          );
  }

  //WRITE
  saveproduct(BuildContext context) async {
    ProductService productService = ProductService();
    // final product = FirebaseFirestore.instance.collection('products').doc();

    final provider = Provider.of<VariantsProvider>(context, listen: false);
    // provider.saveVariant(product.id);
    // provider.getMap();

    final images = await uploadSelectedImages();
    // final model = await uploadModelToFirebase(file);
    final productMaps = await provider.getMap();

    //get materialIds
    List<String> materialIds = [];
    for (Materials material in customizeMaterials) {
      materialIds.add(material.id);
    }

    Map<String, dynamic> productData = {
      'product_name': _productnameController.text,
      // 'material': _materialController.text,
      // 'dimension': _dimensionController.text,
      // 'price': _priceController.text,
      // 'product 3D model': model,
      'labor_cost': double.parse(_laborController.text),
      'expenses': double.parse(_expensesController.text),
      'product_images': images,
      'category': selectedCategory,
      'description': _descriptionController.text,
      'variants': productMaps,
      'noMaterialsReq': double.parse(_materialQuantityRequired.text),
      'noPaintReq': double.parse(_colorQuantityRequired.text),
      'materialIds': materialIds,
      'selectedGuide': selectedGuide,
    };

    // Add the product to Firestore
    await productService.addProduct(productData);
    // await productService.addProduct(productData, productMaps);

    provider.clearVariant();
    // for insurance
    provider.clearOldVariant();

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
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() => file = File(path));
  }
}

class AddVariantButton extends StatelessWidget {
  const AddVariantButton({
    super.key,
    required this.materials,
  });
  final List<Materials> materials;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          showDialog(
              builder: (context) => AddVariantWidget(
                    materials: materials,
                  ),
              context: context,
              barrierDismissible: false);
        },
        child: DottedBorder(
          color: foregroundColor,
          radius: const Radius.circular(8),
          borderType: BorderType.RRect,
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: foregroundColor),
                Text(
                  "Add Variant",
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
