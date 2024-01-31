import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/models/tmpproduct.dart';
import 'package:furniverse/providers/cart_provider.dart';
import 'package:furniverse/services/cart_service.dart';

class CartProductCard extends StatefulWidget {
  // final Product product;
  final Product? product;
  final int quantity;
  final String variantID;
  final Function() removeItem;

  const CartProductCard(
      {super.key,
      required this.product,
      required this.removeItem,
      required this.quantity,
      required this.variantID});

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  int selectedVariantIndex = 0;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    final CartService cartService = CartService();

    // final provider = CartProvider.of(context);
    // final product = provider.cart[widget.index];

    for (int i = 0; i < widget.product!.variants.length; i++) {
      if (widget.variantID == widget.product!.variants[i]['id']) {
        selectedVariantIndex = i;
        break;
      }
    }

    quantity = widget.quantity;
    if (quantity > widget.product?.variants[selectedVariantIndex]['stocks']) {
      quantity = widget.product?.variants[selectedVariantIndex]['stocks'];
    }

    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        widget.product?.variants[selectedVariantIndex]
                                ['image'] ??
                            "http://via.placeholder.com/350x150",
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // "${widget.product?.name} (${widget.product?.variants[selectedVariantIndex]['variant_name']})",
                    "${widget.product?.name}",
                    style: const TextStyle(
                      color: Color(0xFF5F5F5F),
                      fontSize: 14,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  Text(
                    "(${widget.product?.variants[selectedVariantIndex]['variant_name']})",
                    style: const TextStyle(
                      color: Color(0xFF5F5F5F),
                      fontSize: 14,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              cartService.updateQuantity(
                                  user.uid,
                                  widget.product?.id ?? "",
                                  quantity > 1 ? quantity - 1 : quantity);
                            },
                            child: const Icon(Icons.remove,
                                color: Color(0xff909090)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            quantity < 10
                                ? '0${quantity}'
                                : quantity.toString(),
                            style: const TextStyle(
                              color: Color(0xFF303030),
                              fontSize: 16,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: 0.90,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              cartService.updateQuantity(
                                  user.uid,
                                  widget.product?.id ?? "",
                                  quantity <
                                          widget.product?.variants[
                                              selectedVariantIndex]['stocks']
                                      ? quantity + 1
                                      : quantity);
                            },
                            child:
                                const Icon(Icons.add, color: Color(0xff909090)),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                      Text(
                        '₱${((widget.product?.variants[selectedVariantIndex]['price'] * quantity) as double).toStringAsFixed(0)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF303030),
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  cartService.removeFromCart(
                      user.uid, widget.product?.id ?? "");

                  // widget.removeItem.call();
                },
                child: SvgPicture.asset('assets/icons/remove.svg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
