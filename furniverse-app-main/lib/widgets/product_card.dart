import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse/models/favorite.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/services/favorite_service.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Product? product;
  final int? ranking;
  final int? sales;

  // const ProductCard({super.key, required this.product});
  const ProductCard(
      {super.key,
      required this.product,
      required this.ranking,
      required this.sales});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final user = FirebaseAuth.instance.currentUser!;
  final FavoriteService favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    var favorites = Provider.of<List<Favorite>?>(context);

    final leastPrice = widget.product?.getLeastPrice().toStringAsFixed(0);
    final highPrice = widget.product?.getHighestPrice().toStringAsFixed(0);
    bool isPriceEqual = leastPrice == highPrice;
    String price = isPriceEqual ? "₱$leastPrice" : "₱$leastPrice - ₱$highPrice";

    bool isProductInFavorites = false;

    favorites?.forEach((favorite) {
      if (favorite.id == widget.product?.id) {
        isProductInFavorites = true;
        return; // Exit the forEach loop early since we found a match
      }
    });

    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.product?.images[0] ??
                        "http://via.placeholder.com/350x150",
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () async {
                isProductInFavorites
                    ? await favoriteService.removeFromFavorites(
                        user.uid, widget.product?.id ?? "")
                    : await favoriteService.addToFavorites(
                        user.uid, widget.product?.id ?? "");
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: ShapeDecoration(
                  color: const Color(0xFF5F5F5F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Icon(
                  // provider.isExist(widget.product)
                  isProductInFavorites ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ]),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.product?.name ?? "",
                style: const TextStyle(
                  color: Color(0xFF5F5F5F),
                  fontSize: 14,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Gap(5),
            Row(
              children: [
                if (widget.ranking != 0 && (widget.sales ?? 0) > 0)
                  SizedBox(
                    height: 20,
                    width: 20,
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
                    fontSize: 12,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w100,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          price,
          style: const TextStyle(
            color: Color(0xFF303030),
            fontSize: 14,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        )
      ]),
    );
  }
}
