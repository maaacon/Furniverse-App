import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/services/materials_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/add_material_stock_widget.dart';
import 'package:furniverse_admin/widgets/addmaterialwidget.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:furniverse_admin/widgets/editmaterialwidget.dart';
import 'package:provider/provider.dart';

class MaterialsList extends StatefulWidget {
  const MaterialsList({super.key});

  @override
  State<MaterialsList> createState() => _MaterialsListState();
}

class _MaterialsListState extends State<MaterialsList> {
  String? selectedAction;
  final List<String> actions = [
    'Delete',
  ];

  int currentPage = 0;
  int itemsPerPage = 10;

  List<Materials> highlightedMaterials = [];

  void highlightMaterial(Materials materials) {
    setState(() {
      highlightedMaterials.add(materials);
    });
  }

  void removeHighlight(Materials materials) {
    setState(() {
      highlightedMaterials.remove(materials);
    });
  }

  @override
  Widget build(BuildContext context) {
    var material = Provider.of<List<Materials>?>(context);
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
                          "All Materials",
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
                                  "Are you sure you want to delete this material?",
                              onTapNo: () {
                                Navigator.pop(context);
                              },
                              onTapYes: () async {
                                print(material);
                                // final currentContext = context; // Capture the context outside the async block

                                // DELETE MULTIPLE
                                int i = highlightedMaterials.length - 1;
                                while (highlightedMaterials.isNotEmpty) {
                                  await MaterialsServices().deleteMaterial(
                                      highlightedMaterials[i].id);
                                  highlightedMaterials.removeAt(i);
                                  i--;
                                }

                                Fluttertoast.showToast(
                                  msg: "Material Deleted Successfully.",
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
                            builder: (context) => const AddMaterialWidget(),
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
            material == null
                ? const Loading()
                : Expanded(child: _createMaterialList(material)),

            // Expanded(child: _createProductList(products))
          ],
        ),
      ),
    );
  }

  _createMaterialList(List<Materials> material) {
    var finalList = [];

    // filter
    // if (selectedCategory == 'All Products') {
    finalList = material;
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
      return const Center(child: Text("No Materials"));
    } else {
      return ListView.builder(
        itemCount: end - start + 1,
        itemBuilder: (context, index) {
          if (index == end - start) {
            return _createPageNavigation(end, start, finalList);
          } else {
            return MaterialDetailCard(
              materials: finalList[start + index],
              highlight: highlightMaterial,
              removeHighlight: removeHighlight,
              highlightedMat: highlightedMaterials,
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

class MaterialDetailCard extends StatefulWidget {
  final Materials materials;
  final Function highlight;
  final Function removeHighlight;
  final List<Materials> highlightedMat;

  const MaterialDetailCard({
    super.key,
    required this.materials,
    required this.highlight,
    required this.removeHighlight,
    required this.highlightedMat,
  });

  @override
  State<MaterialDetailCard> createState() => _MaterialDetailCardState();
}

class _MaterialDetailCardState extends State<MaterialDetailCard> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    isChecked = widget.highlightedMat.contains(widget.materials);
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
                      widget.highlight(widget.materials);
                    } else {
                      widget.removeHighlight(widget.materials);
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
                            // Container(
                            //   height: 36,
                            //   width: 36,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(6),
                            //       image: DecorationImage(
                            //           image: CachedNetworkImageProvider(
                            //             widget.product.images[0] ??
                            //                 "http://via.placeholder.com/350x150",
                            //           ),
                            //           fit: BoxFit.cover)),
                            // ),
                            // const SizedBox(
                            //   width: 6,
                            // ),
                            Text(
                              widget.materials.material,
                              style: const TextStyle(
                                color: Color(0xFF171625),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // Text(
                        //   "₱${widget.materials.price}",
                        //   style: const TextStyle(
                        //     color: Color(0xFF171625),
                        //     fontSize: 14,
                        //     fontFamily: 'Inter',
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //       Row(
                        //         children: [
                        //           const Text(
                        //             "ID",
                        //             style: TextStyle(
                        //               color: Color(0xFF686873),
                        //               fontSize: 12,
                        //               fontFamily: 'Inter',
                        //               fontWeight: FontWeight.w600,
                        //               height: 0,
                        //             ),
                        //           ),
                        //           const SizedBox(width: 6),
                        //           SizedBox(
                        //             width: 100,
                        //             child: Text(
                        //               "widget.product.id",
                        //               style: const TextStyle(
                        //                 color: Color(0xFF44444F),
                        //                 fontSize: 14,
                        //                 fontFamily: 'Inter',
                        //                 fontWeight: FontWeight.w400,
                        //                 height: 0,
                        //                 letterSpacing: 0.20,
                        //               ),
                        //               maxLines: 1,
                        //               overflow: TextOverflow.ellipsis,
                        //             ),
                        //           )
                        //         ],
                        //       ),
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
                              widget.materials.stocks.toString(),
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
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "₱${widget.materials.price.toStringAsFixed(2)}",
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
                      title: "Are you sure you want to delete this material?",
                      onTapNo: () {
                        Navigator.pop(context);
                      },
                      onTapYes: () async {
                        // final currentContext = context; // Capture the context outside the async block
                        MaterialsServices().deleteMaterial(widget.materials.id);
                        Fluttertoast.showToast(
                          msg: "Material Deleted Successfully.",
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
                    builder: (context) => EditMaterialWidget(
                        id: widget.materials.id.toString(),
                        materials: widget.materials),
                    context: context,
                    barrierDismissible: false);
              }
              if (value == 3) {
                showDialog(
                    builder: (context) => AddMaterialStockWidget(
                        id: widget.materials.id.toString(),
                        materials: widget.materials),
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
