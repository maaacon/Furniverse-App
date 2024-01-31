import 'package:flutter/material.dart';
import 'package:furniverse/models/cart.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/screens/customer_dashboard/screens/product_screen.dart';
import 'package:furniverse/services/analytics.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:furniverse/widgets/cart_button.dart';
import 'package:furniverse/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final List<String> categories = [
    'All',
    'Living Room',
    'Bedroom',
    'Dining Room',
    'Office',
    'Outdoor',
    // 'Kids\' Furniture',
    'Storage and Organization',
    // 'Accent Furniture',
  ];
  @override
  Widget build(BuildContext context) {
    var cartProduct = Provider.of<List<CartProduct>?>(context);

    if (cartProduct == null) {
      return const Center(
        child: Loading(),
      );
    }

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
        title: const Column(
          children: [
            Text(
              'MAKE HOME',
              style: TextStyle(
                color: Color(0xFF909090),
                fontSize: 16,
                fontFamily: 'Avenir Next LT Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'BEAUTIFUL',
              style: TextStyle(
                color: Color.fromARGB(255, 19, 19, 19),
                fontSize: 20,
                fontFamily: 'Avenir Next LT Pro',
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CartButton(cartProduct: cartProduct),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(children: [
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _createProductCategory(
                    index: 0,
                    text: "All Products",
                    icon: Icons.local_mall_rounded),
                const SizedBox(width: 10),
                _createProductCategory(
                    index: 1, text: "Living Room", icon: Icons.chair_rounded),
                const SizedBox(width: 10),
                _createProductCategory(
                    index: 2, text: "Bedroom", icon: Icons.king_bed_rounded),
                const SizedBox(width: 10),
                _createProductCategory(
                    index: 3,
                    text: "Dining Room",
                    icon: Icons.restaurant_rounded),
                const SizedBox(width: 10),
                _createProductCategory(
                    index: 4, text: "Office", icon: Icons.work_rounded),
                const Gap(10),
                _createProductCategory(
                    index: 5, text: "Outdoor", icon: Icons.deck_rounded),
                // const Gap(10),
                // _createProductCategory(
                //     index: 6,
                //     text: "Kids' Furniture",
                //     icon: Icons.toys_rounded),
                const Gap(10),
                _createProductCategory(
                    index: 6,
                    text: "Storage and Organization",
                    icon: Icons.shelves),
                // const Gap(10),
                // _createProductCategory(
                //     index: 8,
                //     text: "Accent Furniture",
                //     icon: Icons.brush_rounded),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ProductsListing(
            category: categories[selectedIndex],
          ))
        ]),
      ),
    );
  }

  _createProductCategory(
          {required int index, required String text, required IconData icon}) =>
      GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: SizedBox(
          width: 60,
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: ShapeDecoration(
                  color: selectedIndex == index
                      ? const Color(0xFF303030)
                      : const Color(0xffF0F0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Icon(
                  icon,
                  color: selectedIndex == index
                      ? const Color(0xFFF0F0F0)
                      : const Color(0xFF303030),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: "Nunito Sans",
                    fontSize: 12,
                    fontWeight: selectedIndex == index
                        ? FontWeight.w400
                        : FontWeight.w400,
                    color: selectedIndex == index
                        ? const Color(0xFF303030)
                        : const Color(0xFF808080),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      );
}

class ProductsListing extends StatefulWidget {
  final String category;

  const ProductsListing({
    super.key,
    required this.category,
  });

  @override
  State<ProductsListing> createState() => _ProductsListingState();
}

class _ProductsListingState extends State<ProductsListing> {
  @override
  Widget build(BuildContext context) {
    var products = Provider.of<List<Product>?>(context);

    if (products != null) {
      List<Product> filteredProducts =
          products.where((product) => product.hasStock()).toList();

      if (widget.category != "All") {
        filteredProducts = filteredProducts
            .where((product) => product.category == widget.category)
            .toList();
      }

      return FutureBuilder<Map<String, dynamic>>(
          future: AnalyticsServices().getTopProductsById(DateTime.now().year),
          builder: (context, snapshot) {
            // Get the first three entries from the map
            Map<String, dynamic> topThreeProductsById = {};

            if (snapshot.data != null) {
              var data = snapshot.data;

              // Sort the list based on values
              var sortedByValueMap = Map.fromEntries(data!.entries.toList()
                ..sort((e1, e2) => e2.value.compareTo(e1.value)));
              topThreeProductsById = Map.fromEntries(
                sortedByValueMap.entries.take(3),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (100 / 150),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemCount: filteredProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = filteredProducts[index];
                  int rank = 1;
                  bool found = false;
                  for (var key in topThreeProductsById.keys) {
                    if (key == product.id) {
                      found = true;
                    }

                    if (!found) {
                      rank++;
                    }
                  }
                  if (rank > topThreeProductsById.length) {
                    rank = 0;
                  }
                  return GestureDetector(
                    child: ProductCard(
                      product: product,
                      ranking: rank,
                      sales: topThreeProductsById[product.id] ?? 0,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          product: product,
                          ranking: rank,
                          sales: topThreeProductsById[product.id] ?? 0,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Loading(),
              );
            }
          });
    } else {
      return const Center(child: Loading());
    }
  }
}
