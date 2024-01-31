import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/models/products.dart';
import 'package:furniverse_admin/models/refund.dart';
import 'package:furniverse_admin/models/user.dart';
import 'package:furniverse_admin/screens/admin_home/pages/refundrequestdetail.dart';
import 'package:furniverse_admin/services/refund_services.dart';
import 'package:furniverse_admin/services/user_services.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:provider/provider.dart';

class RefundPage extends StatefulWidget {
  const RefundPage({super.key});

  @override
  State<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: RefundService().streamRefunds(), initialData: null),
      ],
      child: const Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Products(),
            ),
          ],
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
    var refunds = Provider.of<List<Refund>?>(context);
    var products = Provider.of<List<Product>?>(context);

    if (refunds == null || products == null) {
      return const Center(
        child: Loading(),
      );
    }

    //get refund products
    List<Product> refundProducts = [];

    for (int i = 0; i < refunds.length; i++) {
      for (int j = 0; j < products.length; j++) {
        if (products[j].id == refunds[i].productId) {
          refundProducts.add(products[j]);
          break;
        }
      }
    }

    if (refunds.isEmpty) {
      return const Center(child: Text("You have no refunds."));
    } else {
      return ListView.separated(
        itemCount: refunds.length,
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

          // return StreamProvider.value(
          //   value: ProductService().streamProduct(requests[index].productId),
          //   initialData: null,
          //   child: RequestCard(
          //     request: requests[index],
          //   ),
          // );
          final Refund refund = refunds[index];

          return OrderListTile(
            product: refundProducts[index],
            variantId: refund.variantId ?? "",
            quantity: refund.quantity,
            priceEach: refund.totalPrice / refund.quantity,
            refundStatus: refund.requestStatus ?? "",
            userId: refund.userId,
            orderId: refund.orderId,
            refund: refund,
          );
        },
      );
    }
  }
}

class OrderListTile extends StatefulWidget {
  const OrderListTile(
      {super.key,
      required this.product,
      required this.variantId,
      required this.quantity,
      required this.priceEach,
      required this.refundStatus,
      required this.userId,
      required this.orderId,
      required this.refund});

  final Product product;
  final String variantId;
  final int quantity;
  final double priceEach;
  final String refundStatus;
  final String userId;
  final String orderId;
  final Refund refund;

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
      contentPadding: EdgeInsets.zero,
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "quantity: ${widget.quantity}",
            style: const TextStyle(
              color: Color(0xFF808080),
              fontSize: 12,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "status: ${widget.refundStatus.toLowerCase()}",
            style: const TextStyle(
              color: Color(0xFF808080),
              fontSize: 12,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            price,
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 16,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return RefundRequestDetail(
                      refund: widget.refund,
                      productName: widget.product.name,
                      variantName: widget.product.variants[selectedVariantIndex]
                          ['variant_name'],
                    );
                  },
                ),
              );
              // showDialog(
              //     builder: (context) => RefundDetails(
              //           refund: widget.refund,
              //           productName: widget.product.name,
              //         ),
              //     context: context,
              //     barrierDismissible: false);
            },
            child: const Text(
              "details",
              style: TextStyle(
                color: Colors.black,
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
