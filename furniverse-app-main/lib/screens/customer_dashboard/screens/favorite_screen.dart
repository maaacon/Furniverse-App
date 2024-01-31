import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniverse/models/cart.dart';
import 'package:furniverse/models/favorite.dart';
import 'package:furniverse/screens/customer_dashboard/screens/cart_screen.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/screens/customer_dashboard/variations_modal.dart';
import 'package:furniverse/services/cart_service.dart';
import 'package:furniverse/services/color_services.dart';
import 'package:furniverse/services/favorite_service.dart';
import 'package:furniverse/services/materials_services.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:furniverse/widgets/cart_button.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoriteService favoriteService = FavoriteService();
  final CartService cartService = CartService();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var favorites = Provider.of<List<Favorite>?>(context);
    var products = Provider.of<List<Product>?>(context);
    var cartProduct = Provider.of<List<CartProduct>?>(context);

    if (favorites == null || products == null || cartProduct == null) {
      return const Center(
        child: Loading(),
      );
    }

    // print(favorites);

    // if (favorites != null && products != null) {
    // Create a set to store the unique product IDs from the favorites
    Set<String> favoriteProductIds = <String>{};

    // Extract product IDs from the favorites
    for (var favorite in favorites) {
      favoriteProductIds.add(favorite.id);
    }

    // print(products);

    List<Product> favoriteProducts = [];

    for (var i = 0; i < favoriteProductIds.length; i++) {
      for (var j = 0; j < products.length; j++) {
        if (favoriteProductIds.elementAt(i) == products[j].id) {
          favoriteProducts.add(products[j]);
        }
      }
    }

    // Find products that match the favoriteProductIds
    // List<Tmpproduct> favoriteProducts = products?.where((product) {
    //       for (var i = 0; i < favoriteProductIds.length; i++) {}

    //       return favoriteProductIds.contains(product.id);
    //     }).toList() ??
    //     [];

    // Now, favoriteProducts contains all products that are in the list of favorites
    // }

    // final provider = FavoriteProvider.of(context);

    final finalList = favoriteProducts;
    // final finalList = provider.favorites;
    // final cartProvider = CartProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        // leading: SvgPicture.asset(
        //   'assets/icons/search.svg',
        //   height: 24,
        //   width: 24,
        //   fit: BoxFit.scaleDown,
        // ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'FAVORITE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF303030),
            fontSize: 16,
            fontFamily: 'Avenir Next LT Pro',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CartButton(cartProduct: cartProduct),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (finalList.isEmpty) ...[
              const Center(
                  child: Text("You have no favorites listed as of the moment."))
            ] else ...[
              Expanded(
                child: ListView.separated(
                  itemCount: finalList.length,
                  separatorBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          height: 1,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF0F0F0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                  itemBuilder: (context, index) {
                    final product = finalList[index];
                    final leastPrice =
                        product.getLeastPrice().toStringAsFixed(0);
                    final highPrice =
                        product.getHighestPrice().toStringAsFixed(0);
                    bool isPriceEqual = leastPrice == highPrice;
                    String price = isPriceEqual
                        ? "₱$leastPrice"
                        : "₱$leastPrice - ₱$highPrice";

                    return SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        product.images[0],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      color: Color(0xFF5F5F5F),
                                      fontSize: 14,
                                      fontFamily: 'Nunito Sans',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      color: Color(0xFF303030),
                                      fontSize: 16,
                                      fontFamily: 'Nunito Sans',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await favoriteService.removeFromFavorites(
                                      user.uid, product.id);
                                  // finalList.removeAt(index);
                                  // setState(() {});
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SvgPicture.asset(
                                      'assets/icons/remove.svg'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final allColors =
                                      await ColorService().getColors();
                                  final specificMaterials =
                                      await MaterialsServices()
                                          .getSpecificMaterialsById(
                                              [...(product.materialIds)]);

                                  showModalVariation(
                                    context: context,
                                    product: product,
                                    quantity: 1,
                                    allColors: allColors,
                                    specificMaterials: specificMaterials,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          106, 224, 224, 224),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: SvgPicture.asset(
                                      'assets/icons/shopping_bag_black.svg'),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ]
          ],
        ),
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     for (Product product in finalList) {
      //       // cartProvider.toggleProduct(product, 1);
      //       // cartService.addToCart(user.uid, product.id, 1);
      //     }

      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const CartPage(),
      //       ),
      //     );
      //   },
      //   child: Container(
      //       height: 50,
      //       margin: const EdgeInsets.symmetric(horizontal: 20),
      //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      //       width: double.infinity,
      //       decoration: ShapeDecoration(
      //         color: const Color(0xFF303030),
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(8)),
      //         shadows: const [
      //           BoxShadow(
      //             color: Color(0x3F303030),
      //             blurRadius: 20,
      //             offset: Offset(0, 10),
      //           )
      //         ],
      //       ),
      //       child: const Align(
      //         alignment: Alignment.center,
      //         child: Text(
      //           'ADD ALL TO CART',
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 18,
      //             fontFamily: 'Nunito Sans',
      //             fontWeight: FontWeight.w600,
      //           ),
      //         ),
      //       )),
      // ),
    );
  }
}
