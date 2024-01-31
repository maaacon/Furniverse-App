import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse/models/product.dart';

class CustomizeDialog extends StatefulWidget {
  final Product? product;
  final Function selectVariant;
  final int selectedVariant;

  const CustomizeDialog(
      {super.key,
      required this.product,
      required this.selectVariant,
      required this.selectedVariant});

  @override
  State<CustomizeDialog> createState() => _CustomizeDialogState();
}

class _CustomizeDialogState extends State<CustomizeDialog> {
  int selectedVariantIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedVariantIndex = widget.selectedVariant;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Variations",
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 14,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset('assets/icons/x.svg'),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        Container(
          height: 0.50,
          decoration: const BoxDecoration(color: Color(0xFF3C3C43)),
        ),
        const SizedBox(
          height: 14,
        ),
        Container(
          height: 150,
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildVariationList(widget.product),
          // child: selectedCategoryIndex == 0
          //     ? _buildSizeList(prod)
          //     : selectedCategoryIndex == 1
          //         ? _buildColorList(prod)
          //         : _buildMaterialList(prod),
        )
      ]),
    );
  }

  _selectVariantIndex({required int index}) {
    setState(() {
      selectedVariantIndex = index;
      widget.selectVariant(index);
    });
  }

  // _selectColorIndex({required int index}) {
  //   setState(() {
  //     selectedColorIndex = index;
  //   });
  // }

  // _selectMaterialIndex({required int index}) {
  //   setState(() {
  //     selectedMaterialIndex = index;
  //   });
  // }

  // _createCustomizeCategory(
  //         {required int index, required String text, required String icon}) =>
  //     GestureDetector(
  //       onTap: () {
  //         setState(() {
  //           selectedCategoryIndex = index;
  //         });
  //       },
  //       child: Column(
  //         children: [
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               SvgPicture.asset(icon),
  //               Text(
  //                 text,
  //                 style: const TextStyle(
  //                   color: Color(0xFF303030),
  //                   fontSize: 12,
  //                   fontFamily: 'Nunito Sans',
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(
  //             height: 4,
  //           ),
  //           (index == selectedCategoryIndex)
  //               ? SvgPicture.asset('assets/icons/selector.svg')
  //               : SvgPicture.asset(
  //                   'assets/icons/selector.svg',
  //                   colorFilter:
  //                       const ColorFilter.mode(Colors.white, BlendMode.srcIn),
  //                 ),
  //         ],
  //       ),
  //     );

  _buildVariationList(Product? product) => ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: ((context, index) {
        return VariationCard(
          // prod: product,
          product: widget.product,
          index: index,
          onTap: () => _selectVariantIndex(index: index),
          isSelected: selectedVariantIndex == index,
        );
      }),
      separatorBuilder: ((context, index) {
        return const SizedBox(
          width: 42,
        );
      }),
      // should be product.variation.length
      itemCount: product!.variants.length);

  // _buildSizeList(TempProductsDetails product) => ListView.separated(
  //     physics: const BouncingScrollPhysics(),
  //     scrollDirection: Axis.horizontal,
  //     itemBuilder: ((context, index) {
  //       return SizeCard(
  //         prod: product,
  //         product: widget.product,
  //         index: index,
  //         onTap: () => _selectSizeIndex(index: index),
  //         isSelected: selectedSizeIndex == index,
  //       );
  //     }),
  //     separatorBuilder: ((context, index) {
  //       return const SizedBox(
  //         width: 42,
  //       );
  //     }),
  //     itemCount: product.size.length);

  // _buildColorList(TempProductsDetails product) => ListView.separated(
  //     physics: const BouncingScrollPhysics(),
  //     scrollDirection: Axis.horizontal,
  //     itemBuilder: ((context, index) {
  //       return ColorCard(
  //         prod: product,
  //         product: widget.product,
  //         index: index,
  //         onTap: () => _selectColorIndex(index: index),
  //         isSelected: selectedColorIndex == index,
  //       );
  //     }),
  //     separatorBuilder: ((context, index) {
  //       return const SizedBox(
  //         width: 42,
  //       );
  //     }),
  //     itemCount: product.color.length);

  // _buildMaterialList(TempProductsDetails product) => ListView.separated(
  //     physics: const BouncingScrollPhysics(),
  //     scrollDirection: Axis.horizontal,
  //     itemBuilder: ((context, index) {
  //       return MaterialCard(
  //         prod: product,
  //         product: widget.product,
  //         index: index,
  //         onTap: () => _selectMaterialIndex(index: index),
  //         isSelected: selectedColorIndex == index,
  //       );
  //     }),
  //     separatorBuilder: ((context, index) {
  //       return const SizedBox(
  //         width: 42,
  //       );
  //     }),
  //     itemCount: product.material.length);
}

class VariationCard extends StatelessWidget {
  const VariationCard(
      {super.key,
      // required this.prod,
      required this.index,
      required this.isSelected,
      required this.onTap,
      required this.product});

  // final TempProductsDetails prod;
  final Product? product;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: ShapeDecoration(
              image: DecorationImage(
                // image: AssetImage(widget.product.image),
                image: CachedNetworkImageProvider(
                  product?.variants[index]['image'] ??
                      "http://via.placeholder.com/350x150",
                ),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Text(
            product?.variants[index]['variant_name'],
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Color: ${product?.variants[index]['color']}",
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 12,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "Size: ${product?.variants[index]['size']}",
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 12,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "Material: ${product?.variants[index]['material']}",
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 12,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          isSelected
              ? SvgPicture.asset('assets/icons/selector.svg')
              : SvgPicture.asset(
                  'assets/icons/selector.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
        ],
      ),
    );
  }
}
