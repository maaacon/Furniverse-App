import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse/models/order.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/models/user.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:furniverse/widgets/ordercancellationreason.dart';
import 'package:furniverse/widgets/refundrequest.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int selectedShippingMethod = 0;

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<List<Product>?>(context);
    final order = Provider.of<OrderModel?>(context);
    final user = Provider.of<UserModel?>(context);

    if (products == null || order == null || user == null) {
      return const Center(
        child: Loading(),
      );
    }

    DateTime dateTime = order.orderDate.toDate();
    String orderDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";

    List<Product> orderedProducts = [];

    for (int i = 0; i < order.products.length; i++) {
      for (int j = 0; j < products.length; j++) {
        if (products[j].id == order.products[i]['productId']) {
          orderedProducts.add(products[j]);
          break;
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: const Color(0xFFF0F0F0),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            title: const Text(
              'ORDER DETAILS',
              style: TextStyle(
                color: Color(0xFF303030),
                fontSize: 16,
                fontFamily: 'Avenir Next LT Pro',
                fontWeight: FontWeight.w700,
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      "Products",
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (order.products[0]['variationId'] != "")
                      for (int i = 0; i < orderedProducts.length; i++) ...[
                        OrderListTile(
                          product: orderedProducts[i],
                          variantId: order.products[i]['variationId'],
                          quantity: order.products[i]['quantity'],
                          priceEach: order.products[i]['priceEach'],
                          shippingStatus: order.shippingStatus,
                          userId: order.userId,
                          orderId: order.orderId,
                        ),
                      ],
                    if (order.products[0]['variationId'] == "")
                      OrderRequestTile(
                        product: orderedProducts[0],
                        quantity: order.products[0]['quantity'],
                        order: order,
                      ),
                    const Gap(10),
                    const Text(
                      "Shipping Address",
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Color(0xFF303030),
                              fontSize: 18,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          Text(
                            user.contactNumber,
                            style: const TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 14,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            order.shippingAddress.toString(),
                            style: const TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 14,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    const Text(
                      "Payment",
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/codicon.svg'),
                          ),
                        ),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Cash On Delivery (COD)",
                              style: TextStyle(
                                color: Color(0xFF303030),
                                fontSize: 14,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // const Text(
                    //   "Delivery Method",
                    //   style: TextStyle(
                    //     color: Color(0xFF909090),
                    //     fontSize: 16,
                    //     fontFamily: 'Nunito Sans',
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: order.shippingMethod == 'J&T'
                    //           ? Image.asset('assets/images/jandt.jpg')
                    //           : Image.asset('assets/images/ninjavan.jpg'),
                    //     ),
                    //     Center(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Text(
                    //           order.shippingMethod == 'J&T'
                    //               ? "Fast (5 - 7 days)"
                    //               : "NinjaVan (10 days)",
                    //           style: const TextStyle(
                    //             color: Color(0xFF303030),
                    //             fontSize: 14,
                    //             fontFamily: 'Nunito Sans',
                    //             fontWeight: FontWeight.w700,
                    //             height: 0,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Delivery Fee:",
                          style: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          "₱${order.shippingFee.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Color(0xFF303030),
                            fontSize: 18,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total:",
                          style: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          "₱${order.totalPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Color(0xFF303030),
                            fontSize: 18,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Order Date:",
                          style: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          orderDate,
                          style: const TextStyle(
                            color: Color(0xFF303030),
                            fontSize: 18,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Estimated Arrival:",
                          style: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        if ((order.requestDetails as Map).isEmpty)
                          ETA(
                            days: 7,
                          ),
                        if ((order.requestDetails as Map).isNotEmpty)
                          ETA(
                            days: 14,
                          )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Status:",
                            style: TextStyle(
                              color: Color(0xFF909090),
                              fontSize: 16,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                            )),
                        const Gap(10),
                        Text(
                          order.shippingStatus,
                          style: TextStyle(
                            color: order.shippingStatus.toUpperCase() ==
                                    'CANCELLED'
                                ? Colors.red[300]
                                : const Color(0xFF27AE60),
                            fontSize: 18,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (order.shippingStatus.toUpperCase() == 'CANCELLED') ...[
                      const Text("Reason:",
                          style: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          )),
                      const Gap(10),
                      Text(order.reason),
                    ]
                  ],
                ),
              ),
              if (order.shippingStatus.toUpperCase() == 'PENDING')
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            builder: (context) =>
                                OrderCancellationReason(orderID: order.orderId),
                            context: context,
                            barrierDismissible: false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        "CANCEL ORDER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ETA extends StatelessWidget {
  final days;
  const ETA({super.key, this.days});

  @override
  Widget build(BuildContext context) {
    // Get current date
    DateTime currentDate = DateTime.now();

    // Add days to the current date
    DateTime futureDate = currentDate.add(Duration(days: days));

    // Format dates
    String formattedFutureDate = DateFormat('dd/MM/yyyy').format(futureDate);

    return Text(
      formattedFutureDate,
      style: const TextStyle(
        color: Color(0xFF303030),
        fontSize: 18,
        fontFamily: 'Nunito Sans',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class OrderListTile extends StatefulWidget {
  const OrderListTile(
      {super.key,
      required this.product,
      required this.variantId,
      required this.quantity,
      required this.priceEach,
      required this.shippingStatus,
      required this.userId,
      required this.orderId});

  final Product product;
  final String variantId;
  final int quantity;
  final double priceEach;
  final String shippingStatus;
  final String userId;
  final String orderId;

  @override
  State<OrderListTile> createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  int selectedVariantIndex = 0;
  String title = "";
  String price = "";

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.product.variants.length; i++) {
      if (widget.product.variants[i]['id'] == widget.variantId) {
        selectedVariantIndex = i;
        break;
      }
    }
    title =
        "${widget.product.name} (${widget.product.variants[selectedVariantIndex]['variant_name']})";
    price = "₱${(widget.priceEach * widget.quantity).toStringAsFixed(0)}";
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                widget.product.variants[selectedVariantIndex]['image'] ??
                    "http://via.placeholder.com/350x150",
              ),
              fit: BoxFit.cover),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF303030),
          fontSize: 14,
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      ),
      subtitle: Text(
        "Quantity: ${widget.quantity}",
        style: const TextStyle(
          color: Color(0xFF808080),
          fontSize: 14,
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            price,
            style: TextStyle(
              color: const Color(0xFF303030),
              fontSize:
                  widget.shippingStatus.toUpperCase() == 'DELIVERED' ? 16 : 18,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.shippingStatus.toUpperCase() == 'DELIVERED')
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                showDialog(
                    builder: (context) => RefundRequest(
                          productId: widget.product.id,
                          productName: widget.product.name,
                          quantity: widget.quantity,
                          totalPrice: widget.priceEach * widget.quantity,
                          userId: widget.userId,
                          orderId: widget.orderId,
                          variantId: widget.variantId,
                        ),
                    context: context,
                    barrierDismissible: false);
              },
              child: const Text(
                "Request Refund",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class OrderRequestTile extends StatefulWidget {
  const OrderRequestTile({
    super.key,
    required this.product,
    required this.quantity,
    required this.order,
  });

  final Product product;
  final int quantity;
  final OrderModel order;

  @override
  State<OrderRequestTile> createState() => _OrderRequestTileState();
}

class _OrderRequestTileState extends State<OrderRequestTile> {
  String title = "";

  @override
  Widget build(BuildContext context) {
    title = widget.product.name;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      leading: Container(
        height: double.infinity,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                widget.product.images[0] ??
                    "http://via.placeholder.com/350x150",
              ),
              fit: BoxFit.cover),
        ),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                color: Color(0xFF303030),
                fontSize: 14,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            TextSpan(
              text: " x${widget.quantity}",
              style: const TextStyle(
                color: Color(0xFF303030),
                fontSize: 12,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      subtitle: Text(
        "color: ${widget.order.requestDetails['color']}; size: ${widget.order.requestDetails['size']}; material: ${widget.order.requestDetails['material']}; ${widget.order.requestDetails['others']}",
        style: const TextStyle(
          color: Color(0xFF808080),
          fontSize: 12,
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w400,
        ),
        maxLines: 3,
      ),
    );
  }
}
