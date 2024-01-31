import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/screens/customer_dashboard/variations_modal.dart';
import 'package:furniverse/services/cart_service.dart';
import 'package:furniverse/services/color_services.dart';
import 'package:furniverse/services/materials_services.dart';
import 'package:furniverse/shared/dialog_add_to_cart.dart';
import 'package:furniverse/shared/loading.dart' as load;
import 'package:furniverse/widgets/back_button.dart';
import 'package:furniverse/screens/augmented_reality_view/widgets/customize_dialog.dart';
import 'package:gap/gap.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARView extends StatefulWidget {
  // final Product product;
  final Product? product;

  const ARView({super.key, required this.product});

  @override
  State<ARView> createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  String alt = 'A 3D model';
  String src = '';
  // String src =
  //     "https://firebasestorage.googleapis.com/v0/b/furniverse-5f170.appspot.com/o/threedifiles%2FAstronaut.glb%2Fdata%2Fuser%2F0%2Fcom.example.furniverse_admin%2Fcache%2Ffile_picker%2FAstronaut.glb?alt=media&token=21afbfe5-b636-4e7b-b9d6-48827c6a0435";
  String variationName = '';
  String price = '';
  String variationID = '';
  int selectedVariant = 0;

  void selectVariant(int index) {
    setState(() {
      selectedVariant = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product == null) {
      return const Scaffold(
        body: Center(
          child: load.Loading(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF111111),
                  Color(0xFF424245),
                  Color(0xFF111111)
                ],
              ),
            ),
            child: ModelViewer(
              key: UniqueKey(),
              backgroundColor: Colors.transparent,
              alt: alt,
              ar: true,
              autoRotate: true,
              arPlacement: ArPlacement.floor,
              arScale: ArScale.fixed,
              loading: Loading.lazy,
              src: widget.product?.variants[selectedVariant]['model'],
              poster: widget.product?.variants[selectedVariant]['image'],
              innerModelViewerHtml:
                  '<button slot="ar-button" style="position: absolute;bottom: 60px;left: 50%;transform: translateX(-50%);border-radius:15px; height:46px; background: rgba(57, 57, 57, 0.70); width: 164px; border:none; color: white;text-align: center;font-family: SF UI Display;font-size: 14px;font-style: normal;font-weight: 400;line-height: normal;letter-spacing: 0.56px;">Activate AR</button>',
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Row(children: [
              const BackBtn(),
              const SizedBox(
                width: 10,
              ),
              InfoCard(
                product: widget.product,
                selectedVariant: selectedVariant,
              )
            ]),
          ),
          Positioned(
            bottom: 120,
            top: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomizeButton(
                product: widget.product,
                selectVariant: selectVariant,
                selectedVariant: selectedVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomizeButton extends StatefulWidget {
  // final Product product;
  final Product? product;
  final Function selectVariant;
  final int selectedVariant;
  const CustomizeButton({
    super.key,
    required this.product,
    required this.selectVariant,
    required this.selectedVariant,
  });

  @override
  State<CustomizeButton> createState() => _CustomizeButtonState();
}

class _CustomizeButtonState extends State<CustomizeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomizeDialog(
                product: widget.product,
                selectVariant: widget.selectVariant,
                selectedVariant: widget.selectedVariant,
              );
            });
      },
      child: Container(
        width: 164,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: const Text(
          'Variations',
          style: TextStyle(
            color: Color(0xFF303030),
            fontSize: 15,
            fontFamily: 'Gelasio',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    // required this.name,
    // required this.price,
    required this.product,
    required this.selectedVariant,
  });

  // final Product product;
  final Product? product;
  final int selectedVariant;

  @override
  Widget build(BuildContext context) {
    final String name =
        "${product?.name} (${product?.variants[selectedVariant]['variant_name']})";
    final double price =
        product?.variants[selectedVariant]['price'].toDouble() ?? 0.0;
    return Expanded(
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 18,
                        fontFamily: 'Gelasio',
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '₱${price}0',
                    style: const TextStyle(
                      color: Color(0xFF303030),
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
            Gap(10),
            GestureDetector(
                onTap: () async {
                  final allColors = await ColorService().getColors();
                  final specificMaterials = await MaterialsServices()
                      .getSpecificMaterialsById(
                          [...(product?.materialIds ?? [])]);

                  showModalVariation(
                    context: context,
                    product: product,
                    quantity: 1,
                    allColors: allColors,
                    specificMaterials: specificMaterials,
                  );
                },
                // onTap: () {
                //   // print('add to cart $name');
                //   // CartProvider.of(context, listen: false)
                //   //     .toggleProduct(product, 1);
                //   // _showDialog(context);

                //   if (product != null) {
                //     final user = FirebaseAuth.instance.currentUser!;
                //     CartService().addToCart(
                //         userId: user.uid,
                //         productID: product!.id,
                //         quantity: 1,
                //         variantID: product!.variants[selectedVariant]['id']);
                //   }
                //   showAddedToCartDialog(context);
                // },
                child: SvgPicture.asset('assets/icons/shopping_bag_black.svg')),
          ],
        ),
      ),
    );
  }

  // void _showDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20.0),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text("Added To Cart!",
  //                 style: TextStyle(
  //                   color: Color(0xFF222222),
  //                   fontSize: 20,
  //                   fontFamily: 'Nunito Sans',
  //                   fontWeight: FontWeight.w800,
  //                 )),
  //             const SizedBox(height: 20),
  //             Container(
  //               height: 0.50,
  //               decoration: const BoxDecoration(color: Color(0xFF3C3C43)),
  //             ),
  //             const SizedBox(height: 10),
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.of(context).pop();
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const CartPage(),
  //                   ),
  //                 );
  //               },
  //               child: const Text(
  //                 'Got It!',
  //                 style: TextStyle(
  //                   color: Color(0xFF007AFF),
  //                   fontSize: 17,
  //                   fontFamily: 'Nunito Sans',
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
