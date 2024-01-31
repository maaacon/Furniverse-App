import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse/models/color_model.dart';
import 'package:furniverse/models/materials_model.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/models/request.dart';
import 'package:furniverse/screens/EditInfos/checkout_request.dart';
import 'package:furniverse/services/cart_service.dart';
import 'package:furniverse/services/request_services.dart';
import 'package:furniverse/services/user_service.dart';
import 'package:furniverse/shared/dialog_add_to_cart.dart';
import 'package:furniverse/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';

showModalVariation({
  required BuildContext context,
  required Product? product,
  required int quantity,
  required List<ColorModel> allColors,
  required List<Materials> specificMaterials,
}) async {
  if (product == null) {
    return;
  }
  bool isCustomize = false;
  int selectedVariationIndex = 0;
  int variationQuantity = quantity;
  int customizeQuantity = 1;

  double totalPrice = product.expenses + product.labor;

  // final sizeController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  // final colorController = TextEditingController();
  // final materialController = TextEditingController();
  final othersController = TextEditingController();
  // final quantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // final List<String> items = [
  //   'inch',
  //   'cm',
  //   'ft',
  //   'm',
  // ];
  // String? selectedCategory;
  String? selectedColor;
  String? selectedMaterial;
  ColorModel? colorModel;
  Materials? materialModel;
  double selectedColorCost = 0.0;
  double selectedMaterialCost = 0.0;
  bool isRounded =
      product.variants[0]['length'] == product.variants[0]['width'];

  String guideImage = 'assets/images/rectangle.png';

  switch (product.selectedGuide.toLowerCase()) {
    case 'rounded':
      guideImage = 'assets/images/rounded.png';
      break;
    case 'box':
      guideImage = 'assets/images/box.png';

      break;
  }

  // print(isRounded);

  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  //initialize colorNames
  final List<String> colorNames = [];
  for (var color in allColors) {
    colorNames.add(color.color);
  }

  final List<String> hexValues = [];
  for (var hexval in allColors) {
    hexValues.add(hexval.hexValue);
  }

  List<Map> data = [
    for (int i = 0; i < allColors.length; i++)
      {
        'color': allColors[i].color,
        'hexval': allColors[i].hexValue,
        'sales': allColors[i].sales,
        'index': i
      },
  ];

  //initialize specific material items
  final List<String> materialNames = [];
  for (var material in specificMaterials) {
    materialNames.add(material.material);
  }

  List<Map> materialMap = [
    for (int i = 0; i < specificMaterials.length; i++)
      {
        'name': specificMaterials[i].material,
        'sales': specificMaterials[i].sales,
        'index': i
      },
  ];

  colorModel = allColors[0];
  materialModel = specificMaterials[0];

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setModalState) {
            final user = FirebaseAuth.instance.currentUser!;

            //List of variations builder

            List<Widget> variationCards = [];

            for (int i = 0; i < product.variants.length; i++) {
              if (product.variants[i]['stocks'] > 0) {
                variationCards.add(
                  VariationCard(
                    onTap: () {
                      setModalState(() {
                        selectedVariationIndex = i;
                        variationQuantity = 1;
                      });
                    },
                    product: product,
                    isSelected: selectedVariationIndex == i,
                    index: i,
                  ),
                );
              }
            }
            return FutureBuilder<String>(
                future: UserService().getUserPrefferedMeasure(userId: user.uid),
                builder: (context, snapshot) {
                  double multiplier = 0;
                  double initialArea = 0;
                  double len = 0;
                  double w = 0;
                  double h = 0;

                  switch (snapshot.data) {
                    case 'in':
                      multiplier = 39.3701;
                      break;
                    case 'ft':
                      multiplier = 3.280841666667;
                      break;
                    default:
                      multiplier = 1;
                      break;
                  }
                  len = ((product.variants[0]['length'] ?? 0) * multiplier);
                  h = ((product.variants[0]['height'] ?? 0) * multiplier);
                  w = ((product.variants[0]['width'] ?? 0) * multiplier);
                  initialArea = len * w * h;
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * .6,
                      color: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          FutureBuilder<String>(
                              future: UserService()
                                  .getUserPrefferedMeasure(userId: user.uid),
                              builder: (context, snapshot) {
                                return Header(
                                  product: product,
                                  selectedIndex: selectedVariationIndex,
                                  prefferedMetric: snapshot.data ?? "ft",
                                  len: len,
                                  h: h,
                                  w: w,
                                );
                              }),
                          const SizedBox(height: 10),
                          Container(
                            height: .3,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 83, 83, 87),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () =>
                                    setModalState(() => isCustomize = false),
                                child: Text(
                                  'Variations',
                                  style: _categoryStyle(isCustomize),
                                ),
                              ),
                              if (allColors.isNotEmpty &&
                                  specificMaterials.isNotEmpty)
                                Builder(builder: (context) {
                                  return TextButton(
                                    onPressed: () =>
                                        setModalState(() => isCustomize = true),
                                    child: Text('Customize',
                                        style: _categoryStyle(!isCustomize)),
                                  );
                                }),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          !isCustomize
                              ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: GridView.count(
                                      physics: const BouncingScrollPhysics(),
                                      crossAxisCount: 2,
                                      childAspectRatio: 3.5 / 1,
                                      children: [...variationCards],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Form(
                                      key: formKey,
                                      child: ListView(
                                        physics: const BouncingScrollPhysics(),
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: AssetImage(guideImage),
                                              ),
                                            ),
                                          ),
                                          Gap(5),
                                          Text(
                                            "Furniture Dimensions Guide",
                                            textAlign: TextAlign.center,
                                          ),
                                          Gap(10),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: LengthTextFormField(
                                                  lengthController:
                                                      lengthController,
                                                  metric: snapshot.data ?? "",
                                                ),
                                              ),
                                              Gap(10),
                                              XSeperator(),
                                              Gap(10),
                                              Flexible(
                                                child: WidthTextFormField(
                                                  widthController:
                                                      widthController,
                                                  metric: snapshot.data ?? "",
                                                ),
                                              ),
                                              Gap(10),
                                              XSeperator(),
                                              Gap(10),
                                              Flexible(
                                                child: HeightTextFormField(
                                                  heightController:
                                                      heightController,
                                                  metric: snapshot.data ?? "",
                                                ),
                                              ),
                                            ],
                                          ),
                                          Gap(20),
                                          DropdownButtonFormField2<String>(
                                            buttonStyleData:
                                                const ButtonStyleData(
                                              height: 26,
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                            ),
                                            hint: const Text(
                                              'Select Color',
                                              style: TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                              ),
                                              iconSize: 24,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            items: [
                                              ...data
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item['color'],
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .brightness_1,
                                                                  color: hexToColor(
                                                                      item[
                                                                          'hexval']),
                                                                ),
                                                                Gap(10),
                                                                Text(
                                                                  item['color'],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                            (item['sales'] > 0)
                                                                ? item['index'] ==
                                                                        0
                                                                    ? Top1Image()
                                                                    : item['index'] ==
                                                                            1
                                                                        ? Top2Image()
                                                                        : item['index'] ==
                                                                                2
                                                                            ? Top3Image()
                                                                            : const SizedBox()
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            ],
                                            isExpanded: true,
                                            value: selectedColor,
                                            onChanged: (String? value) {
                                              setModalState(() {
                                                selectedColor = value;

                                                for (var color in allColors) {
                                                  if (color.color ==
                                                      selectedColor) {
                                                    selectedColorCost =
                                                        color.price *
                                                            product.noPaintReq;

                                                    colorModel = color;
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                          Gap(20),
                                          DropdownButtonFormField2<String>(
                                            buttonStyleData:
                                                const ButtonStyleData(
                                              height: 26,
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                            ),
                                            hint: const Text(
                                              'Select Material',
                                              style: TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                              ),
                                              iconSize: 24,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            items: [
                                              ...materialMap
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item['name'],
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              item['name'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            (item['sales'] > 0)
                                                                ? item['index'] ==
                                                                        0
                                                                    ? Top1Image()
                                                                    : item['index'] ==
                                                                            1
                                                                        ? Top2Image()
                                                                        : item['index'] ==
                                                                                2
                                                                            ? Top3Image()
                                                                            : const SizedBox()
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            ],
                                            isExpanded: true,
                                            value: selectedMaterial,
                                            onChanged: (String? value) {
                                              setModalState(() {
                                                selectedMaterial = value;

                                                for (var material
                                                    in specificMaterials) {
                                                  if (material.material ==
                                                      selectedMaterial) {
                                                    selectedMaterialCost =
                                                        material.price *
                                                            product
                                                                .noMaterialsReq;
                                                    materialModel = material;
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                          Gap(20),
                                          TextFormField(
                                            controller: othersController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              labelText: 'Customization Notes',
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setModalState(() {
                                                        if (customizeQuantity >
                                                            1) {
                                                          customizeQuantity--;
                                                        }
                                                      });
                                                    },
                                                    child: const Icon(
                                                        Icons.remove,
                                                        color:
                                                            Color(0xff909090)),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    customizeQuantity < 10
                                                        ? '0$customizeQuantity'
                                                        : customizeQuantity
                                                            .toString(),
                                                    style: const TextStyle(
                                                      color: Color(0xFF303030),
                                                      fontSize: 18,
                                                      fontFamily: 'Nunito Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setModalState(() {
                                                        //TODO: if check of resource before adding quantity
                                                        customizeQuantity++;
                                                      });
                                                    },
                                                    child: const Icon(Icons.add,
                                                        color:
                                                            Color(0xff909090)),
                                                  ),
                                                ],
                                              ),
                                              if (lengthController.text != "" &&
                                                  widthController.text != "" &&
                                                  heightController.text != "")
                                                Text(
                                                  "New Product Price: ₱${((totalPrice + newResourceCost(selectedColorCost, selectedMaterialCost, (double.parse(lengthController.text)) * (double.parse(widthController.text)) * (double.parse(heightController.text)), initialArea)) * customizeQuantity.toDouble()).toStringAsFixed(0)}",
                                                  style: const TextStyle(
                                                    color: Color(0xFF303030),
                                                    fontSize: 14,
                                                    fontFamily: 'Nunito Sans',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                )
                                              else
                                                Text(
                                                  "New Product Price: ₱${((totalPrice + selectedColorCost + selectedMaterialCost) * customizeQuantity.toDouble()).toStringAsFixed(0)}",
                                                  style: const TextStyle(
                                                    color: Color(0xFF303030),
                                                    fontSize: 14,
                                                    fontFamily: 'Nunito Sans',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                            ],
                                          ),
                                          Gap(10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          if (!isCustomize)
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      if (variationQuantity > 1) {
                                        variationQuantity--;
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.remove,
                                      color: Color(0xff909090)),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  variationQuantity < 10
                                      ? '0$variationQuantity'
                                      : variationQuantity.toString(),
                                  style: const TextStyle(
                                    color: Color(0xFF303030),
                                    fontSize: 18,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                    letterSpacing: 0.90,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      if (product.variants[
                                                  selectedVariationIndex]
                                              ['stocks'] >
                                          variationQuantity) {
                                        variationQuantity++;
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.add,
                                      color: Color(0xff909090)),
                                ),
                              ],
                            ),
                          const Gap(10),
                          !isCustomize
                              ? AddToCartButton(
                                  productVariationStock:
                                      product.variants[selectedVariationIndex]
                                          ['stocks'],
                                  product: product,
                                  quantity: variationQuantity,
                                  selectedIndex: selectedVariationIndex,
                                )
                              : AddToRequestsButton(
                                  requestCost: customizeQuantity.toDouble() *
                                      ((lengthController.text != "" &&
                                              widthController.text != "" &&
                                              heightController.text != "")
                                          ? (totalPrice +
                                              newResourceCost(
                                                  selectedColorCost,
                                                  selectedMaterialCost,
                                                  double.parse(lengthController
                                                          .text) *
                                                      double.parse(
                                                          widthController
                                                              .text) *
                                                      double.parse(
                                                          heightController
                                                              .text),
                                                  initialArea))
                                          : totalPrice +
                                              selectedMaterialCost +
                                              selectedColorCost),
                                  // size: "${lengthController.text} x ${widthController.text} x ${heightController.text} (${snapshot.data})",
                                  colorCost: (lengthController.text != "" &&
                                          widthController.text != "" &&
                                          heightController.text != "")
                                      ? ((double.parse(lengthController.text) *
                                              double.parse(
                                                  widthController.text) *
                                              double.parse(
                                                  heightController.text)) *
                                          selectedColorCost /
                                          initialArea)
                                      : selectedColorCost,
                                  materialCost: (lengthController.text != "" &&
                                          widthController.text != "" &&
                                          heightController.text != "")
                                      ? ((double.parse(lengthController.text) *
                                              double.parse(
                                                  widthController.text) *
                                              double.parse(
                                                  heightController.text)) *
                                          selectedMaterialCost /
                                          initialArea)
                                      : selectedMaterialCost,
                                  // selectedMaterialCost,
                                  colorQuantity: (lengthController.text != "" &&
                                          widthController.text != "" &&
                                          heightController.text != "")
                                      ? ((double.parse(lengthController.text) *
                                              double.parse(
                                                  widthController.text) *
                                              double.parse(
                                                  heightController.text)) *
                                          product.noPaintReq /
                                          initialArea)
                                      : product.noPaintReq,
                                  materialQuantity: (lengthController.text !=
                                              "" &&
                                          widthController.text != "" &&
                                          heightController.text != "")
                                      ? ((double.parse(lengthController.text) *
                                              double.parse(
                                                  widthController.text) *
                                              double.parse(
                                                  heightController.text)) *
                                          product.noMaterialsReq /
                                          initialArea)
                                      : product.noMaterialsReq,
                                  laborCost: product.labor,
                                  otherExpenses: product.expenses,
                                  height: heightController,
                                  length: lengthController,
                                  width: widthController,
                                  material: selectedMaterial ?? "",
                                  color: selectedColor ?? "",
                                  others: othersController,
                                  reqquantity: customizeQuantity,
                                  productId: product.id,
                                  // metric: selectedCategory.toString(),
                                  metric: snapshot.data ?? "",
                                  formKey: formKey,
                                  materialsModel: materialModel,
                                  colorModel: colorModel,
                                ),
                        ],
                      ),
                    ),
                  );
                });
          },
        );
      });
}

class Top3Image extends StatelessWidget {
  const Top3Image({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Image.asset('assets/images/top3.png'),
    );
  }
}

class Top2Image extends StatelessWidget {
  const Top2Image({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Image.asset('assets/images/top2.png'),
    );
  }
}

class Top1Image extends StatelessWidget {
  const Top1Image({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Image.asset('assets/images/top1.png'),
    );
  }
}

class LengthTextFormField extends StatelessWidget {
  const LengthTextFormField({
    super.key,
    required this.lengthController,
    required this.metric,
  });

  final TextEditingController lengthController;
  final String metric;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: lengthController,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        labelText: 'Length ($metric)',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value!.isEmpty ? 'Please input a length.' : null,
    );
  }
}

class WidthTextFormField extends StatelessWidget {
  const WidthTextFormField({
    super.key,
    required this.widthController,
    required this.metric,
  });

  final TextEditingController widthController;
  final String metric;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widthController,
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      ),
      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        labelText: 'Width ($metric)',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value!.isEmpty ? 'Please input a width.' : null,
    );
  }
}

class XSeperator extends StatelessWidget {
  const XSeperator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'x',
      style: TextStyle(fontSize: 18),
    );
  }
}

class HeightTextFormField extends StatelessWidget {
  const HeightTextFormField({
    super.key,
    required this.heightController,
    required this.metric,
  });

  final TextEditingController heightController;
  final String metric;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: heightController,
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      ),
      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        labelText: 'Height ($metric)',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value!.isEmpty ? 'Please input a height.' : null,
    );
  }
}

double newResourceCost(double selectedColorCost, double selectedMaterialCost,
    double newArea, double initialArea) {
  if (newArea != 0.0 && initialArea != 0.0)
    return (newArea * selectedColorCost / initialArea) +
        (newArea * selectedMaterialCost / initialArea);

  return selectedColorCost + selectedMaterialCost;
}

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.quantity,
    required this.product,
    required this.selectedIndex,
    required this.productVariationStock,
  });

  final int quantity;
  final Product? product;
  final int selectedIndex;
  final int productVariationStock;

  @override
  Widget build(BuildContext context) {
    final CartService cartService = CartService();
    final user = FirebaseAuth.instance.currentUser!;
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xff303030)),
        ),
        onPressed: () {
          cartService.addToCart(
            userId: user.uid,
            productID: product!.id,
            quantity: quantity,
            variantID: product!.variants[selectedIndex]['id'],
          );
          Navigator.pop(context);
          showAddedToCartDialog(context);
        },
        child: const Text(
          'ADD TO CART',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
      ),
    );
  }
}

class AddToRequestsButton extends StatelessWidget {
  const AddToRequestsButton({
    super.key,
    // required this.size,
    required this.length,
    required this.width,
    required this.height,
    required this.material,
    required this.color,
    required this.others,
    required this.reqquantity,
    required this.productId,
    required this.metric,
    required this.requestCost,
    required this.formKey,
    required this.colorModel,
    required this.materialsModel,
    required this.colorCost,
    required this.materialCost,
    required this.laborCost,
    required this.otherExpenses,
    required this.colorQuantity,
    required this.materialQuantity,
  });

  // final TextEditingController size;
  // final TextEditingController material;
  // final TextEditingController color;
  final TextEditingController length;
  final TextEditingController width;
  final TextEditingController height;
  final String material;
  final String color;
  final TextEditingController others;
  final int reqquantity;
  final GlobalKey<FormState> formKey;
  final String productId;
  final String metric;
  final double requestCost;
  final ColorModel? colorModel;
  final Materials? materialsModel;
  final double colorCost;
  final double materialCost;
  final double laborCost;
  final double otherExpenses;
  final double colorQuantity;
  final double materialQuantity;

  @override
  Widget build(BuildContext context) {
    final RequestsService requestsService = RequestsService();
    final user = FirebaseAuth.instance.currentUser!;
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xff303030)),
        ),
        onPressed: () {
          final isValid = formKey.currentState!.validate();
          if (!isValid) {
            Fluttertoast.showToast(
              msg: "Please complete the information needed.",
              backgroundColor: Colors.grey,
            );
            print("Input values are invalid");
            return;
          }
          if (color == "") {
            Fluttertoast.showToast(
              msg: "Please select color.",
              backgroundColor: Colors.grey,
            );
            print("Input values are invalid");
            return;
          }
          if (material == "") {
            Fluttertoast.showToast(
              msg: "Please select material.",
              backgroundColor: Colors.grey,
            );
            print("Input values are invalid");
            return;
          }

          // requestsService.addToRequest(
          //   userId: user.uid,
          //   size: "${size.text} $metric",
          //   material: material.text,
          //   color: color.text,
          //   others: others.text,
          //   quantity: int.parse(reqquantity.text),
          //   productId: productId,
          // );
          // Navigator.pop(context);
          // showRequestSubmittedDialog(context);

          showDialog(
            context: context,
            builder: (context) => ConfirmationAlertDialog(
                title: "Are you sure you want to request this item?",
                onTapNo: () {
                  Navigator.pop(context);
                },
                onTapYes: () async {
                  Navigator.pop(context);
                  // Navigator.pop(context);

                  if (colorModel != null && materialsModel != null) {
                    final request = CustomerRequests(
                        id: "",
                        size:
                            "${length.text} x ${width.text} x ${height.text} ($metric)",
                        material: materialsModel!.material,
                        color: colorModel!.color,
                        others: others.text,
                        reqquantity: reqquantity,
                        productId: productId,
                        price: requestCost,
                        userId: user.uid,
                        reqStatus: "",
                        materialId: materialsModel!.id,
                        colorId: colorModel!.id,
                        colorQuantity: colorQuantity,
                        materialQuantity: materialQuantity);

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CheckoutRequest(
                          total: requestCost,
                          request: request,
                          colorCost: colorCost,
                          materialCost: materialCost,
                          laborCost: laborCost,
                          otherExpenses: otherExpenses,
                        );
                      },
                    ));

                    // requestsService.addToRequest(
                    //     userId: user.uid,
                    //     size:
                    //         "${length.text} x ${width.text} x ${height.text} ($metric)",
                    //     material: material,
                    //     color: color,
                    //     others: others.text,
                    //     quantity: int.parse(reqquantity.text),
                    //     productId: productId,
                    //     price: requestCost,
                    //     colorId: colorModel!.id,
                    //     materialId: materialsModel!.id);
                  }

                  // Navigator.pop(context);
                  // Fluttertoast.showToast(
                  //   msg: "Request sent.",
                  //   backgroundColor: Colors.grey,
                  // );
                  // Navigator.pop(context);
                  // showRequestSubmittedDialog(context);
                },
                tapNoString: "No",
                tapYesString: "Yes"),
          );
        },
        child: const Text(
          'CHECKOUT',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
      ),
    );
  }
}

TextStyle _categoryStyle(bool isCustomize) {
  return TextStyle(
    color: !isCustomize
        ? const Color(0xFF303030)
        : const Color.fromARGB(69, 48, 48, 48),
    fontSize: 18,
    fontFamily: 'Nunito Sans',
    fontWeight: FontWeight.w700,
  );
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.product,
    required this.selectedIndex,
    required this.prefferedMetric,
    required this.len,
    required this.w,
    required this.h,
  });
  final Product? product;
  final int selectedIndex;
  final String prefferedMetric;
  final double len;
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    // double multiplier = 0;

    // switch (prefferedMetric) {
    //   case 'in':
    //     multiplier = 39.3701;
    //     break;
    //   case 'ft':
    //     multiplier = 3.280841666667;
    //     break;
    //   default:
    //     multiplier = 1;
    //     break;
    // }

    // double len = 360 * multiplier;
    // double w = 640 * multiplier;
    // double h = 8 * multiplier;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        product?.variants[selectedIndex]['image'] ??
                            "http://via.placeholder.com/350x150",
                      ),
                      fit: BoxFit.cover),
                  // image: AssetImage(product.image), fit: BoxFit.cover),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₱${product?.variants[selectedIndex]['price'].toDouble().toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 18,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Stock: ${product?.variants[selectedIndex]['stocks']}',
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 14,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Color: ${product?.variants[selectedIndex]['color']}",
                      maxLines: 2,
                      style: const TextStyle(
                        color: Color(0xFF5F5F5F),
                        fontSize: 12,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Material: ${product?.variants[selectedIndex]['material']}",
                      maxLines: 2,
                      style: const TextStyle(
                        color: Color(0xFF5F5F5F),
                        fontSize: 12,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      // "Length: ${product?.variants[selectedIndex]['size']} ",
                      "LWH: ${len.toStringAsFixed(2)} x ${w.toStringAsFixed(2)} x ${h.toStringAsFixed(2)} ($prefferedMetric)",
                      style: const TextStyle(
                        color: Color(0xFF5F5F5F),
                        fontSize: 12,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VariationCard extends StatelessWidget {
  const VariationCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  final Product? product;
  // final Product product;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isSelected ? const Color(0xFF303030) : Colors.white,
            )),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: ShapeDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      product?.variants[index]['image'] ??
                          "http://via.placeholder.com/350x150",
                    ),
                    fit: BoxFit.cover),
                // image: AssetImage(product.image), fit: BoxFit.cover),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                product?.variants[index]['variant_name'],
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 12,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
