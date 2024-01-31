import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/models/notification.dart';
import 'package:furniverse_admin/models/order.dart';
import 'package:furniverse_admin/screens/admin_home/pages/order_detail_screen.dart';
import 'package:furniverse_admin/services/color_services.dart';
import 'package:furniverse_admin/services/materials_services.dart';
import 'package:furniverse_admin/services/messaging_services.dart';
import 'package:furniverse_admin/services/notification_services.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({super.key});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<OrderModel>?>(context);

    if (orders == null) {
      return const Center(
        child: Loading(),
      );
    }

    return Scaffold(
      body: Column(
        children: [
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
        ],
      ),
    );
  }
}

class OrdersCard extends StatefulWidget {
  const OrdersCard({super.key, required this.order});
  final OrderModel order;

  @override
  State<OrdersCard> createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {
  String? selectedValue, samplel;
  String? hintText;

  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  final messagingService = MessagingService();
  final orderService = OrderService();
  final notificationService = NotificationService();
  List<String> items = [
    'Pending',
    'Processing',
    'On Delivery',
    'Delivered',
    'Cancelled',
  ];

  void _updateDropdownItems() {
    setState(() {
      // Change the items list to update the dropdown options
      if (hintText?.toUpperCase() == 'Pending'.toUpperCase()) {
        items = ['Processing', 'Cancelled'];
      } else if (hintText?.toUpperCase() == 'Processing'.toUpperCase()) {
        items = [
          'On Delivery',
          'Cancelled',
        ];
      } else if (hintText?.toUpperCase() == 'On Delivery'.toUpperCase()) {
        items = [
          'Delivered',
          'Cancelled',
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    OrderModel order = widget.order;
    DateTime dateTime = order.orderDate.toDate();
    String orderDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    int quantity = 0;

    // get quantity
    for (int i = 0; i < order.products.length; i++) {
      quantity += order.products[i]['quantity'] as int;
    }
    hintText = order.shippingStatus;
    _updateDropdownItems();

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
                  'ID: ${order.orderId.toUpperCase()}',
                  style: const TextStyle(
                    color: Color(0xFF303030),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                    height: 0,
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
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '₱${order.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
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
                      return OrderDetailPage(
                        orderId: order.orderId,
                        userId: order.userId,
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
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: order.shippingStatus.toUpperCase() ==
                        'cancelled'.toUpperCase()
                    ? const Text(
                        "Cancelled",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : order.shippingStatus.toUpperCase() ==
                            'Delivered'.toUpperCase()
                        ? const Text(
                            "Delivered",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              alignment: Alignment.centerRight,
                              hint: Text(
                                hintText ?? "",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              items: items
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Nunito Sans',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (String? value) async {
                                if (value?.toUpperCase() == "CANCELLED") {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                          "Cancellation Form"),
                                                      IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                            Icons.close),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  SizedBox(
                                                    height: 230,
                                                    width: double.maxFinite,
                                                    child: ListView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              _reasonController,
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              8)),
                                                            ),
                                                            labelText:
                                                                "Reason of Cancellation",
                                                          ),
                                                          maxLines: 5,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          validator: (value) =>
                                                              value!.isEmpty
                                                                  ? 'Please input a reason of cancellation.'
                                                                  : null,
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          height: 50,
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              final isValid = _formKey
                                                                  .currentState!
                                                                  .validate();
                                                              if (!isValid) {
                                                                return;
                                                              }
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          ConfirmationAlertDialog(
                                                                            title:
                                                                                "Are you sure you want to cancel this order?",
                                                                            onTapNo:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            onTapYes:
                                                                                () async {
                                                                              setState(() {});

                                                                              String title = "";
                                                                              String subtitile = "";
                                                                              String? notifImage = await ProductService().getProductImage(order.products[0]['productId']);

                                                                              if (order.requestDetails.isEmpty) {
                                                                                await ProductService().addQuantity(order.products);
                                                                              } else {
                                                                                await ColorService().addQuantity(widget.order.requestDetails['colorId'], widget.order.requestDetails['colorQuantity']);
                                                                                await MaterialsServices().addQuantity(widget.order.requestDetails['materialId'], widget.order.requestDetails['materialQuantity']);
                                                                              }

                                                                              title = "Your order #${order.orderId.toUpperCase()} has been cancelled by the seller.";
                                                                              subtitile = "Your order #${order.orderId.toUpperCase()} has been canceled by the seller. Please click here for more details.";

                                                                              if (value != null) {
                                                                                notificationService.addNotification(NotificationModel(userId: order.userId, orderId: order.orderId, notifTitle: title, notifSubtitle: subtitile, notifImage: notifImage, isViewed: false));

                                                                                orderService.updateStatus(order.orderId, value, _reasonController.text);

                                                                                messagingService.notifyUser(userId: order.userId, message: value);
                                                                              }

                                                                              if (context.mounted) {
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              }

                                                                              Fluttertoast.showToast(
                                                                                msg: "Order is cancelled.",
                                                                                backgroundColor: Colors.grey,
                                                                              );
                                                                            },
                                                                            tapYesString:
                                                                                "Yes",
                                                                            tapNoString:
                                                                                "No",
                                                                          ));
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8))),
                                                            child: const Text(
                                                              "SUBMIT",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'Nunito Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ConfirmationAlertDialog(
                                            title: "",
                                            content: const Text(
                                              "Are you sure you want to update the status?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            onTapYes: () async {
                                              setState(() {});

                                              // initialize fields
                                              String title = "";
                                              String subtitile = "";
                                              String? notifImage =
                                                  await ProductService()
                                                      .getProductImage(
                                                          order.products[0]
                                                              ['productId']);

                                              switch (value?.toUpperCase()) {
                                                case "PROCESSING":
                                                  {
                                                    title =
                                                        "Your order #${order.orderId.toUpperCase()} has been confirmed.";
                                                    subtitile =
                                                        "Seller has confirmed your order! Please expect your item to be shipped within 5-7 days.";

                                                    break;
                                                  }
                                                case "ON DELIVERY":
                                                  {
                                                    title =
                                                        "Your order #${order.orderId.toUpperCase()} is now being shipped.";
                                                    subtitile =
                                                        "Please expect your item to be delivered in the next few day/s.";

                                                    break;
                                                  }
                                                case "DELIVERED":
                                                  {
                                                    title =
                                                        "Your order #${order.orderId.toUpperCase()} has been shipped successfully.";
                                                    subtitile =
                                                        "Thank you for purchasing.";
                                                    break;
                                                  }
                                              }

                                              if (value != null) {
                                                notificationService
                                                    .addNotification(
                                                        NotificationModel(
                                                            userId:
                                                                order.userId,
                                                            orderId:
                                                                order.orderId,
                                                            notifTitle: title,
                                                            notifSubtitle:
                                                                subtitile,
                                                            notifImage:
                                                                notifImage,
                                                            isViewed: false));

                                                orderService.updateStatus(
                                                    order.orderId, value, "");

                                                messagingService.notifyUser(
                                                    userId: order.userId,
                                                    message: value);
                                              }

                                              // notifyUser(value),
                                              // messagingService.notifyUser(
                                              //     userId: order.userId,
                                              //     message: value!);
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                            },
                                            onTapNo: () =>
                                                Navigator.pop(context),
                                            tapYesString: "Yes",
                                            tapNoString: "No",
                                          ));
                                }
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 40,
                                width: 110,
                              ),
                              menuItemStyleData:
                                  const MenuItemStyleData(height: 40),
                            ),
                          ),
              ),
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
