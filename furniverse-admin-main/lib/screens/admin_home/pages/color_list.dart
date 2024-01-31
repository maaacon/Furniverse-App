import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/models/color_model.dart';
import 'package:furniverse_admin/services/color_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/add_color_stock_widget.dart';
import 'package:furniverse_admin/widgets/addcolorwidget.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:furniverse_admin/widgets/editcolorwidget.dart';
import 'package:provider/provider.dart';

class ColorList extends StatefulWidget {
  const ColorList({super.key});

  @override
  State<ColorList> createState() => _ColorListState();
}

class _ColorListState extends State<ColorList> {
  String? selectedAction;
  final List<String> actions = [
    'Delete',
  ];

  int currentPage = 0;
  int itemsPerPage = 10;

  List<ColorModel> highlightedColors = [];

  void highlightMaterial(ColorModel colorModel) {
    setState(() {
      highlightedColors.add(colorModel);
    });
  }

  void removeHighlight(ColorModel colorModel) {
    setState(() {
      highlightedColors.remove(colorModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorss = Provider.of<List<ColorModel>?>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "All Colors",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Action',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: actions
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                              ),
                            ))
                        .toList(),
                    value: selectedAction,
                    onChanged: (String? value) async {
                      if (value == 'Delete') {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationAlertDialog(
                              title:
                                  "Are you sure you want to delete this color?",
                              onTapNo: () {
                                Navigator.pop(context);
                              },
                              onTapYes: () async {
                                // final currentContext = context; // Capture the context outside the async block

                                // DELETE MULTIPLE
                                int i = highlightedColors.length - 1;
                                while (highlightedColors.isNotEmpty) {
                                  await ColorService()
                                      .deleteColor(highlightedColors[i].id);
                                  highlightedColors.removeAt(i);
                                  i--;
                                }

                                Fluttertoast.showToast(
                                  msg: "Color Deleted Successfully.",
                                  backgroundColor: Colors.grey,
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              tapNoString: "No",
                              tapYesString: "Yes"),
                        );
                      }
                      setState(() {
                        selectedAction = null;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 110,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // const Icon(Icons.filter_alt),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        // final provider = Provider.of<VariantsProvider>(context,
                        //     listen: false);
                        // provider.clearOldVariant();
                        // provider.clearVariant();
                        showDialog(
                            builder: (context) => const AddColorWidget(),
                            context: context,
                            barrierDismissible: false);
                      },
                      child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xffF6BE2C)),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ],
            ),
            // const SizedBox(height: 10),
            // Column(
            //   children: [
            //     Row(
            //       children: [
            //         // Expanded(
            //         //   child: TextField(
            //         //     decoration: InputDecoration(
            //         //       contentPadding: const EdgeInsets.symmetric(
            //         //           vertical: 8, horizontal: 14),
            //         //       border: OutlineInputBorder(
            //         //         borderRadius: BorderRadius.circular(8),
            //         //         borderSide: const BorderSide(
            //         //             color: Color(0xffD0D5DD), width: 1),
            //         //       ),
            //         //       hintText: "Search",
            //         //       hintStyle: const TextStyle(
            //         //         color: Color(0xFF667084),
            //         //         fontSize: 16,
            //         //         fontFamily: 'Inter',
            //         //         fontWeight: FontWeight.w400,
            //         //       ),
            //         //       prefixIcon: const Icon(Icons.search),
            //         //     ),
            //         //   ),
            //         // ),

            //       ],
            //     ),
            //   ],
            // ),
            const SizedBox(height: 10),
            colorss == null
                ? const Loading()
                : Expanded(child: _createMaterialList(colorss)),

            // Expanded(child: _createProductList(products))
          ],
        ),
      ),
    );
  }

  _createMaterialList(List<ColorModel> colorss) {
    var finalList = [];

    // filter
    // if (selectedCategory == 'All Products') {
    finalList = colorss;
    print(finalList);
    // } else {
    // for (int i = 0; i < material.length; i++) {
    //   // if (products[i].category == selectedCategory) {
    //     finalList.add(material[i]);
    //   // }
    // }
    // }

    // pagination
    int start = currentPage * itemsPerPage;
    int end = (currentPage + 1) * itemsPerPage;

    if (end > finalList.length) {
      end = finalList.length;
    }

    if (finalList.isEmpty) {
      return const Center(child: Text("No Colors"));
    } else {
      return ListView.builder(
        itemCount: end - start + 1,
        itemBuilder: (context, index) {
          if (index == end - start) {
            return _createPageNavigation(end, start, finalList);
          } else {
            return ColorDetailCard(
              colorModel: finalList[start + index],
              highlight: highlightMaterial,
              removeHighlight: removeHighlight,
              highlightedMat: highlightedColors,
            );
          }
        },
      );
    }
  }

  Padding _createPageNavigation(int end, int start, List<dynamic> finalList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${start + 1} - ${end - start} of ${finalList.length} items',
                  style: const TextStyle(
                    color: Color(0xFF44444F),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // if (currentPage > 0) {
                  //   setState(() {
                  //     currentPage--;
                  //   });
                  // }
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 1, color: const Color(0xFFE2E2EA))),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    size: 24,
                    color: Color(0xff92929D),
                  ),
                ),
              ),
              const SizedBox(
                width: 22,
              ),
              GestureDetector(
                onTap: () {
                  if (end < finalList.length) {
                    setState(() {
                      // currentPage++;
                    });
                  }
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 1, color: const Color(0xFFE2E2EA))),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: Color(0xff92929D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ColorDetailCard extends StatefulWidget {
  final ColorModel colorModel;
  final Function highlight;
  final Function removeHighlight;
  final List<ColorModel> highlightedMat;

  const ColorDetailCard({
    super.key,
    required this.colorModel,
    required this.highlight,
    required this.removeHighlight,
    required this.highlightedMat,
  });

  @override
  State<ColorDetailCard> createState() => _ColorDetailCardState();
}

class _ColorDetailCardState extends State<ColorDetailCard> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    isChecked = widget.highlightedMat.contains(widget.colorModel);
    // final leastPrice = widget.product.getLeastPrice().toStringAsFixed(0);
    // final highPrice = widget.product.getHighestPrice().toStringAsFixed(0);
    // bool isPriceEqual = leastPrice == highPrice;
    // String price = isPriceEqual ? "₱$leastPrice" : "₱$leastPrice - ₱$highPrice";

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: isChecked ?? false ? const Color(0xff3DD598) : Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20),
              height: 16,
              width: 16,
              child: Checkbox(
                activeColor: const Color(0xff3DD598),
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value;
                    if (isChecked == true) {
                      widget.highlight(widget.colorModel);
                    } else {
                      widget.removeHighlight(widget.colorModel);
                    }
                  });
                },
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.colorModel.color,
                              style: const TextStyle(
                                color: Color(0xFF171625),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "STOCK",
                              style: TextStyle(
                                color: Color(0xFF686873),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.colorModel.stocks.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Color(0xFF44444F),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                                letterSpacing: 0.20,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "₱${widget.colorModel.price.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Color(0xFF171625),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationAlertDialog(
                      title: "Are you sure you want to delete this color?",
                      onTapNo: () {
                        Navigator.pop(context);
                      },
                      onTapYes: () async {
                        // final currentContext = context; // Capture the context outside the async block
                        ColorService().deleteColor(widget.colorModel.id);
                        Fluttertoast.showToast(
                          msg: "Color Deleted Successfully.",
                          backgroundColor: Colors.grey,
                        );
                        Navigator.pop(context);
                      },
                      tapNoString: "No",
                      tapYesString: "Yes"),
                );
              }
              if (value == 2) {
                showDialog(
                    builder: (context) => EditColorWidget(
                        id: widget.colorModel.id.toString(),
                        colorModel: widget.colorModel),
                    context: context,
                    barrierDismissible: false);
              }
              if (value == 3) {
                showDialog(
                    builder: (context) => AddColorStocksWidget(
                        id: widget.colorModel.id.toString(),
                        color: widget.colorModel),
                    context: context,
                    barrierDismissible: false);
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            itemBuilder: (context) => [
              // popupmenu item 1
              const PopupMenuItem(
                value: 1,
                // row has two child icon and text.
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: foregroundColor,
                    ),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(color: foregroundColor),
                    )
                  ],
                ),
              ),
              // popupmenu item 2
              const PopupMenuItem(
                value: 2,
                // row has two child icon and text
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: foregroundColor,
                    ),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text("Edit", style: TextStyle(color: foregroundColor))
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 3,
                // row has two child icon and text
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory_2_rounded,
                      color: foregroundColor,
                    ),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text("Add Stocks", style: TextStyle(color: foregroundColor))
                  ],
                ),
              ),
            ],
            offset: const Offset(0, 50),
            color: backgroundColor,
            elevation: 3,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.more_horiz,
                color: foregroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
