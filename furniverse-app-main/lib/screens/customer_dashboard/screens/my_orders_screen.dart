import 'package:flutter/material.dart';
import 'package:furniverse/models/order.dart';
import 'package:furniverse/screens/customer_dashboard/screens/wrapper_order_detail_screen.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:provider/provider.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<OrderModel>?>(context);

    if (orders == null) {
      return const Center(
        child: Loading(),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'MY ORDERS',
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              if (orders.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return OrdersCard(
                        order: orders[index],
                      );
                    },
                  ),
                ),
              if (orders.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text("You have no orders."),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersCard extends StatelessWidget {
  final OrderModel order;

  const OrdersCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = order.orderDate.toDate();
    String orderDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    int quantity = 0;

    // get quantity
    for (int i = 0; i < order.products.length; i++) {
      quantity += order.products[i]['quantity'] as int;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2.5,
                child: Text(
                  'Order #${order.orderId.toUpperCase()}',
                  style: const TextStyle(
                    color: Color(0xFF303030),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                orderDate,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF909090),
                  fontSize: 14,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 2,
          decoration: ShapeDecoration(
            color: const Color(0xFFF0F0F0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Quantity: ',
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: quantity.toString(),
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Total: ',
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: '₱${order.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.right,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return WrapperOrderDetailScreen(
                        orderId: order.orderId,
                      );
                    },
                  ));
                },
                child: Container(
                  width: 100,
                  height: 36,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF303030),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Text(
                  order.shippingStatus,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: order.shippingStatus.toUpperCase() == 'CANCELLED'
                        ? Colors.red[300]
                        : const Color(0xFF27AE60),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class MyOrdersTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  const MyOrdersTab({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 103,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF303030)
                  : const Color(0xFF909090),
              fontSize: 18,
              fontFamily: 'Nunito Sans',
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 40,
            height: 4,
            decoration: ShapeDecoration(
              color: isSelected ? const Color(0xFF303030) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          )
        ],
      ),
    );
  }
}
