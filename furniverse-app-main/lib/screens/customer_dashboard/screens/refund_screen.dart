import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse/models/product.dart';
import 'package:furniverse/models/refund.dart';
import 'package:furniverse/models/request.dart';
import 'package:furniverse/screens/EditInfos/checkout_request.dart';
import 'package:furniverse/services/product_service.dart';
import 'package:furniverse/services/refund_service.dart';
import 'package:furniverse/services/request_services.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:furniverse/widgets/refund_details_dialog.dart';
import 'package:gap/gap.dart';
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
            value: RefundService().streamRefunds(user.uid), initialData: null),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'MY REFUNDS',
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
            refundStatus: refund.requestStatus ?? "Pending",
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
            "status: ${widget.refundStatus}",
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
            style: TextStyle(
              color: const Color(0xFF303030),
              fontSize:
                  widget.refundStatus.toUpperCase() == 'PENDING' ? 16 : 18,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.refundStatus.toUpperCase() == 'PENDING')
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                showDialog(
                    builder: (context) => RefundDetails(
                          refund: widget.refund,
                          productName: widget.product.name,
                        ),
                    context: context,
                    barrierDismissible: false);
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
