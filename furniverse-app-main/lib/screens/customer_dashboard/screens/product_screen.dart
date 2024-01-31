import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniverse/models/favorite.dart';
import 'package:furniverse/screens/augmented_reality_view/ar_view.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/screens/customer_dashboard/variations_modal.dart';
import 'package:furniverse/services/color_services.dart';
import 'package:furniverse/services/favorite_service.dart';
import 'package:furniverse/services/materials_services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ProductPage extends StatefulWidget {
  final Product? product;
  final int? ranking;
  final int? sales;
  const ProductPage(
      {super.key, required this.product, this.ranking, this.sales});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final user = FirebaseAuth.instance.currentUser!;
  int quantity = 1;
  String desc = "";

  // temporary bookmark value
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    // final provider = FavoriteProvider.of(context);
    // final cartProvider = CartProvider.of(context);

    // var favorites = Provider.of<List<Favorite>?>(context);
    // print(favorites);

    // var favorites = Provider.of<List<Favorite>?>(context);
    // bool isProductInFavorites = false;

    // favorites?.forEach((favorite) {
    //   // print(favorite.id);
    //   if (favorite.id == widget.product?.id) {
    //     isProductInFavorites = true;
    //     return; // Exit the forEach loop early since we found a match
    //   }
    // });
    if (widget.product?.description == null) {
      desc = "";
    } else {
      desc = "*7 days warranty.\n\n${widget.product?.description}";
    }

    final leastPrice = widget.product?.getLeastPrice().toStringAsFixed(0);
    final highPrice = widget.product?.getHighestPrice().toStringAsFixed(0);
    bool isPriceEqual = leastPrice == highPrice;
    String price = isPriceEqual ? "₱$leastPrice" : "₱$leastPrice - ₱$highPrice";

    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: FavoriteService().streamFavorites(user.uid),
            initialData: null),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 382,
                child: Stack(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.product?.images.length,
                      physics: const PageScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * .12),
                          child: Container(
                            height: 382,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                  // image: AssetImage(widget.product.image),
                                  image: CachedNetworkImageProvider(
                                    widget.product?.images[index] ??
                                        "http://via.placeholder.com/350x150",
                                  ),
                                  fit: BoxFit.cover),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 22,
                      left: 0,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset('assets/icons/left.svg')),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.product?.name ?? "",
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 24,
                        fontFamily: 'Gelasio',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    Row(
                      children: [
                        if (widget.ranking != 0 && (widget.sales ?? 0) > 0)
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: widget.ranking == 1
                                ? Image.asset('assets/images/top1.png')
                                : widget.ranking == 2
                                    ? Image.asset('assets/images/top2.png')
                                    : Image.asset('assets/images/top3.png'),
                          ),
                        Text(
                          "${widget.sales?.toString() ?? "0"} sold",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 121, 121, 121),
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w100,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Container(
                    //       width: 30,
                    //       height: 4,
                    //       decoration: ShapeDecoration(
                    //         color: const Color(0xFF303030),
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(4)),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     Container(
                    //       width: 15,
                    //       height: 4,
                    //       decoration: ShapeDecoration(
                    //         color: const Color(0xFFF0F0F0),
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(4)),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     Container(
                    //       width: 15,
                    //       height: 4,
                    //       decoration: ShapeDecoration(
                    //         color: const Color(0xFFF0F0F0),
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(4)),
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 20,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ARView(
                              product: widget.product,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        // width: 165,
                        height: 44,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 2, color: Color(0xFF303030)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/ar.svg'),
                            const Gap(10),
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'View in ',
                                    style: TextStyle(
                                      color: Color(0xFF303030),
                                      fontSize: 18,
                                      fontFamily: 'Nunito Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'AR',
                                    style: TextStyle(
                                      color: Color(0xFF303030),
                                      fontSize: 18,
                                      fontFamily: 'Nunito Sans',
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    )
                    // Row(
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           if (quantity > 1) {
                    //             quantity--;
                    //           }
                    //         });
                    //       },
                    //       child: const Icon(Icons.remove,
                    //           color: Color(0xff909090)),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     Text(
                    //       quantity < 10 ? '0$quantity' : quantity.toString(),
                    //       style: const TextStyle(
                    //         color: Color(0xFF303030),
                    //         fontSize: 18,
                    //         fontFamily: 'Nunito Sans',
                    //         fontWeight: FontWeight.w600,
                    //         height: 0,
                    //         letterSpacing: 0.90,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           quantity++;
                    //         });
                    //       },
                    //       child:
                    //           const Icon(Icons.add, color: Color(0xff909090)),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   children: [
                    //     SvgPicture.asset(
                    //       'assets/icons/star.svg',
                    //       colorFilter: const ColorFilter.mode(
                    //           Color(0xffF2C94C), BlendMode.srcIn),
                    //     ),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     const Text(
                    //       // widget.product.rating.toString(),
                    //       "4.5",
                    //       style: TextStyle(
                    //         color: Color(0xFF303030),
                    //         fontSize: 18,
                    //         fontFamily: 'Nunito Sans',
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => const RatingReviewPage(),
                    //           ),
                    //         );
                    //       },
                    //       child: const Text(
                    //         '(${50} reviews)',
                    //         // '(${widget.product.numReviews} reviews)',
                    //         style: TextStyle(
                    //           color: Color(0xFF808080),
                    //           fontSize: 14,
                    //           fontFamily: 'Nunito Sans',
                    //           fontWeight: FontWeight.w600,
                    //           height: 0,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ReadMoreText(
                    desc,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Color(0xFF5F5F5F),
                      fontSize: 14,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                    trimLines: 5,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: ' Show less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ),
        bottomSheet: BottomAppBar(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FavoriteButton(
                  product: widget.product,
                ),
                GestureDetector(
                  onTap: () async {
                    final allColors = await ColorService().getColors();
                    final specificMaterials = await MaterialsServices()
                        .getSpecificMaterialsById(
                            [...(widget.product?.materialIds ?? [])]);

                    showModalVariation(
                      context: context,
                      product: widget.product,
                      quantity: quantity,
                      allColors: allColors,
                      specificMaterials: specificMaterials,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 16),
                    width: MediaQuery.of(context).size.width * .75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xff303030)),
                    child: const Text(
                      'ADD TO CART',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final FavoriteService favoriteService = FavoriteService();
    var favorites = Provider.of<List<Favorite>?>(context);
    bool isProductInFavorites = false;
    final user = FirebaseAuth.instance.currentUser!;

    favorites?.forEach((favorite) {
      // print(favorite.id);
      if (favorite.id == product?.id) {
        isProductInFavorites = true;
        return; // Exit the forEach loop early since we found a match
      }
    });
    return GestureDetector(
      onTap: () async {
        // provider.toggleFavorite(widget.product);
        // print(isProductInFavorites);
        isProductInFavorites
            ? await favoriteService.removeFromFavorites(
                user.uid, product?.id ?? "")
            : await favoriteService.addToFavorites(user.uid, product?.id ?? "");
      },
      child: Icon(
        isProductInFavorites ? Icons.bookmark : Icons.bookmark_border,
        color: const Color(0xff303030),
        size: 40,
      ),
    );
  }
}

class VariationCard extends StatelessWidget {
  const VariationCard({
    super.key,
    required this.widget,
    required this.isSelected,
    required this.onTap,
  });

  final ProductPage widget;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            // color: isSelected ? const Color(0xFF303030) : Colors.white,
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
                  // image: AssetImage(widget.product.image),
                  image: CachedNetworkImageProvider(
                    widget.product?.images[0] ??
                        "http://via.placeholder.com/350x150",
                  ),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Variation Name',
              style: TextStyle(
                color: Color(0xFF303030),
                // color: isSelected ? Colors.white : const Color(0xFF303030),
                fontSize: 12,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
