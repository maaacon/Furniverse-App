import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/models/request.dart';
import 'package:furniverse/screens/EditInfos/checkout_request.dart';
import 'package:furniverse/services/product_service.dart';
import 'package:furniverse/services/request_services.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: RequestsService().streamRequest(user.uid),
            initialData: null),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'MY REQUESTS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF303030),
                fontSize: 16,
                fontFamily: 'Avenir Next LT Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: const Column(
              children: [
                Expanded(
                  child: Products(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Products extends StatelessWidget {
  const Products({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var requests = Provider.of<List<CustomerRequests>?>(context);
    var products = Provider.of<List<Product>?>(context);

    if (requests == null || products == null) {
      return const Center(
        child: Loading(),
      );
    }

    if (requests.isEmpty) {
      return const Center(
          child: Text("You have no pending request listed as of the moment."));
    } else {
      return ListView.separated(
        itemCount: requests.length,
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
          // final product = finalList[index];
          // final variantID = cartProductVariantIds[index];

          // return const Text("hi");

          return StreamProvider.value(
            value: ProductService().streamProduct(requests[index].productId),
            initialData: null,
            child: RequestCard(
              request: requests[index],
            ),
          );
        },
      );
    }
  }
}

class RequestCard extends StatefulWidget {
  // final Product product;
  // final Product? product;
  // final int quantity;
  // final String variantID;
  // final Function() removeItem;
  final CustomerRequests request;

  const RequestCard({
    super.key,
    required this.request,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  // int selectedVariantIndex = 0;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final Product? product = Provider.of<Product?>(context);

    int quantity = widget.request.reqquantity;

    if (product == null) return const Gap(100);

    // final CartService cartService = CartService();

    // final provider = CartProvider.of(context);
    // final product = provider.cart[widget.index];

    // for (int i = 0; i < widget.product!.variants.length; i++) {
    //   if (widget.variantID == widget.product!.variants[i]['id']) {
    //     selectedVariantIndex = i;
    //     break;
    //   }
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
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
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            product.images[0] ??
                                "http://via.placeholder.com/350x150",
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: Color(0xFF5F5F5F),
                            fontSize: 14,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Color: ${widget.request.material}",
                          style: const TextStyle(
                            color: Color(0xFF5F5F5F),
                            fontSize: 12,
                            fontFamily: 'Nunito Sans',
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Material: ${widget.request.color}",
                          style: const TextStyle(
                            color: Color(0xFF5F5F5F),
                            fontSize: 12,
                            fontFamily: 'Nunito Sans',
                          ),
                        ),
                        Text(
                          "LWH: ${widget.request.size}",
                          style: const TextStyle(
                            color: Color(0xFF5F5F5F),
                            fontSize: 12,
                            fontFamily: 'Nunito Sans',
                          ),
                        ),
                        Text(
                          "Others: ${widget.request.others}",
                          style: const TextStyle(
                            color: Color(0xFF5F5F5F),
                            fontSize: 12,
                            fontFamily: 'Nunito Sans',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      RequestsService()
                          .removeFromRequest(user.uid, widget.request.id);
                    },
                    child: SvgPicture.asset('assets/icons/remove.svg'),
                  ),
                  widget.request.reqStatus.toUpperCase() != 'PENDING'
                      ? Text(
                          "Qty. ${quantity < 10 ? '0$quantity' : quantity.toString()}",
                          style: const TextStyle(
                            color: Color(0xFF303030),
                            fontSize: 14,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ))
                      : Column(
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     RequestsService().updateQuantity(
                            //         user.uid, widget.request.id, quantity + 1);
                            //   },
                            //   child: const Icon(
                            //     Icons.arrow_drop_up_rounded,
                            //     color: Color(0xff909090),
                            //   ),
                            // ),
                            Text(
                              quantity < 10
                                  ? 'Qty. 0$quantity'
                                  : 'Qty. ${quantity.toString()}',
                              style: const TextStyle(
                                color: Color(0xFF303030),
                                fontSize: 14,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     if (quantity > 1) {
                            //       RequestsService().updateQuantity(user.uid,
                            //           widget.request.id, quantity - 1);
                            //     }
                            //   },
                            //   child: const Icon(Icons.arrow_drop_down_rounded,
                            //       color: Color(0xff909090)),
                            // ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
        const Gap(10),
        widget.request.reqStatus.toUpperCase() == 'PENDING'
            ? const Text(
                "Pending",
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 16,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                ),
              )
            : widget.request.reqStatus.toUpperCase() == 'REJECTED'
                ? const Text(
                    "Rejected",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "₱${widget.request.price?.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Color(0xFF303030),
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      const Gap(10),
                      SizedBox(
                        height: 40,
                        // width: MediaQuery.sizeOf(context).width / 3,
                        // padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return CheckoutRequest(
                            //           total: widget.request.price ?? 0.0,
                            //           request: widget.request);
                            //     },
                            //   ),
                            // );
                          },
                          child: const Text(
                            "CHECKOUT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
      ],
    );
  }
}
