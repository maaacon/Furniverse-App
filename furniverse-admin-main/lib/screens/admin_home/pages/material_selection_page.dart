import 'package:flutter/material.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:provider/provider.dart';

class MaterialSelectionPage extends StatefulWidget {
  final Function onTap;
  final List<Materials> materials;
  const MaterialSelectionPage({
    super.key,
    required this.onTap,
    required this.materials,
  });

  @override
  State<MaterialSelectionPage> createState() => _MaterialSelectionPageState();
}

class _MaterialSelectionPageState extends State<MaterialSelectionPage> {
  int currentPage = 0;
  int itemsPerPage = 10;

  List<Materials> highlightedMaterials = [];

  //TODO: temporary
  @override
  void initState() {
    super.initState();
    highlightedMaterials = widget.materials;
  }

  void highlightMaterial(Materials materials) {
    setState(() {
      highlightedMaterials.add(materials);
    });
  }

  void removeHighlight(Materials materials) {
    setState(() {
      highlightedMaterials.removeWhere((element) => element.id == materials.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var material = Provider.of<List<Materials>?>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.black,
            ),
          ),
          title: Text(
            "All Materials",
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 16,
              fontFamily: 'Avenir Next LT Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              material == null
                  ? const Loading()
                  : Expanded(child: _createMaterialList(material)),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onTap(highlightedMaterials);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Save ${highlightedMaterials.length} Materials",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _createMaterialList(List<Materials> material) {
    var finalList = [];

    // filter
    // if (selectedCategory == 'All Products') {
    finalList = material;
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
    isChecked = false;
    for (var mat in widget.highlightedMat) {
      if (mat.id == widget.materials.id) isChecked = true;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: isChecked ?? false ? const Color(0xff3DD598) : Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
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
                  Row(
                    children: [
                      Text(
                        widget.materials.material,
                        style: const TextStyle(
                          color: Color(0xFF171625),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
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
                  )
                ],
              ),
            ),
          ),
          Text(
            "₱${widget.materials.price.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Color(0xFF171625),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
