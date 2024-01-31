import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/models/analytics.dart';
import 'package:furniverse_admin/models/color_model.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/models/order.dart';
import 'package:furniverse_admin/models/products.dart';
import 'package:furniverse_admin/models/refund.dart';
import 'package:furniverse_admin/screens/report_modal.dart';
import 'package:furniverse_admin/services/analytics_services.dart';
import 'package:furniverse_admin/services/color_services.dart';
import 'package:furniverse_admin/services/materials_services.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/services/refund_services.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/line_chart_widget.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<int> years = [];
  List<Product> products = [];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<OrderModel>?>(context);
    final refunds = Provider.of<List<Refund>?>(context);

    if (orders == null || refunds == null) {
      return const Center(
        child: Loading(),
      );
    }

    for (int i = 0; i < orders.length; i++) {
      int year = orders[i].orderDate.toDate().year;

      if (!years.contains(year)) {
        years.add(year);
      }
    }
    if (years.isEmpty) {
      AnalyticsServices().clearAnalytics();
    }

    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Show year: ",
                      style: TextStyle(
                        color: Color(0xFF92929D),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (years.isNotEmpty)
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          // alignment: Alignment.centerRight,
                          isExpanded: true,
                          hint: Text(
                            selectedValue ?? years[0].toString(),
                            style: const TextStyle(
                              color: Color(0xFF44444F),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          items: years
                              .map(
                                (int item) => DropdownMenuItem<String>(
                                  value: item.toString(),
                                  child: Text(
                                    item.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          value: selectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            width: 60,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 30,
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    showModalReport(context: context);
                  },
                  child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xffF6BE2C)),
                      child: const Icon(
                        Icons.download,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ],
        ),
        years.isNotEmpty
            ? MultiProvider(
                providers: [
                    StreamProvider.value(
                        value: OrderService().streamOrdersByYear(
                            int.parse(selectedValue ?? years[0].toString())),
                        initialData: null),
                    StreamProvider.value(
                        value: RefundService().streamRefundsPerYear(
                            int.parse(selectedValue ?? years[0].toString())),
                        initialData: null)
                  ],
                child: Analytics(
                    years: years,
                    year: int.parse(selectedValue ?? years[0].toString())))
            : const Center(child: Text("No data for analytics")),
      ],
    );
  }
}

class Analytics extends StatefulWidget {
  const Analytics({
    super.key,
    required this.year,
    required this.years,
  });
  final int year;
  final List<int> years;

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  // int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<OrderModel>?>(context);
    final refunds = Provider.of<List<Refund>?>(context);

    if (orders == null || refunds == null) {
      return const Center(
        child: Loading(),
      );
    }

    // not cancelled orders
    final List<OrderModel> fullOrders = [];
    for (var order in orders) {
      if (order.shippingStatus.toUpperCase() != 'CANCELLED') {
        fullOrders.add(order);
      }
    }

    if (fullOrders.isEmpty) {
      AnalyticsServices().deleteAnalytics(widget.year);
      return const Center(child: Text("No data for analysis"));
    }

    // total revenue
    double sales = 0.0;
    List<double> amountPerTransaction = [];
    for (int i = 0; i < fullOrders.length; i++) {
      sales += fullOrders[i].totalPrice;
      amountPerTransaction.add(fullOrders[i].totalPrice);
    }

    // total revenue
    double deduction = 0.0;
    for (var refund in refunds) {
      deduction += refund.totalPrice;
    }
    sales -= deduction;

    // monthly sales
    Map<String, dynamic> monthlySales = {};
    for (var order in fullOrders) {
      // final month = DateFormat('MMMM')
      //     .format(DateTime(0, order?.orderDate.toDate().month ?? 0));
      final month = order.orderDate.toDate().month.toString();
      monthlySales.putIfAbsent(month, () => 0);
      monthlySales[month] = monthlySales[month]! + order.totalPrice;
    }

    // monthly deductions
    for (var refund in refunds) {
      final month = refund.timestamp?.toDate().month.toString();
      monthlySales[month!] = monthlySales[month]! - refund.totalPrice;
    }

    // all products
    Map<String, int> products = {};
    for (int i = 0; i < fullOrders.length; i++) {
      for (int j = 0; j < fullOrders[i].products.length; j++) {
        products.putIfAbsent(fullOrders[i].products[j]['productId'], () => 0);
        products[fullOrders[i].products[j]['productId']] =
            (products[fullOrders[i].products[j]['productId']]! +
                fullOrders[i].products[j]['quantity'] as int);
      }
    }

    Map<String, dynamic> ordersPerCity = {};
    Map<String, dynamic> refundPerId = {};
    for (var refund in refunds) {
      refundPerId.putIfAbsent(
          refund.orderId, () => {'totalDeduction': 0.0, 'quantity': 0});
      refundPerId[refund.orderId]['totalDeduction'] =
          refundPerId[refund.orderId]['totalDeduction'] + refund.totalPrice;

      //add quantity
      refundPerId[refund.orderId]['quantity'] =
          refundPerId[refund.orderId]['quantity'] + refund.quantity;
    }
    for (var order in fullOrders) {
      final province = order.shippingCity == "" ? 'Others' : order.shippingCity;
      ordersPerCity.putIfAbsent(
          province,
          () => {
                "users": [],
                "quantity": 0,
                "total": (refundPerId.containsKey(order.orderId)
                    ? 0 - refundPerId[order.orderId]['totalDeduction']
                    : 0),
              });

      // add users
      if (!ordersPerCity[province]['users'].contains(order.userId)) {
        ordersPerCity[province]['users'].add(order.userId);
      }

      // increment quantity
      ordersPerCity[province]['quantity'] =
          ordersPerCity[province]['quantity'] + 1;

      // add total
      ordersPerCity[province]['total'] =
          ordersPerCity[province]['total'] + order.totalPrice;
    }

    // NOTE: SHIPPING PRICE IS STATIC HERE
    // double shippingPrice = 200;
    // products
    int totalQuantity = 0;
    Map<String, dynamic> ordersPerProduct = {};
    Map<String, dynamic> refundPerProductId = {};
    for (var refund in refunds) {
      refundPerProductId.putIfAbsent(refund.productId, () => 0);
      refundPerProductId[refund.productId] =
          refundPerProductId[refund.productId] + refund.quantity;
    }

    for (var order in fullOrders) {
      if (order.products.isNotEmpty) {
        // Calculate shipping cost per product
        final shippingCostPerProduct =
            order.shippingFee / order.products.length;
        for (var product in order.products) {
          final productId = product['productId'];
          ordersPerProduct.putIfAbsent(
              productId,
              () => {
                    "quantity": 0,
                    "total": 0.0,
                    "refunds": (refundPerProductId.containsKey(productId))
                        ? refundPerProductId[productId]
                        : 0
                  });

          // add quantity
          ordersPerProduct[productId]['quantity'] =
              ordersPerProduct[productId]['quantity'] + product['quantity'];

          // add total quantity
          totalQuantity = totalQuantity + product['quantity'] as int;

          // add total
          ordersPerProduct[productId]['total'] = ordersPerProduct[productId]
                  ['total'] +
              product['totalPrice'] +
              shippingCostPerProduct;
        }
      }
    }

    // products deductions
    int originalTotalQuantity = totalQuantity;
    for (var refund in refunds) {
      // reduce quantity
      ordersPerProduct[refund.productId]['quantity'] =
          ordersPerProduct[refund.productId]['quantity'] - refund.quantity;

      // reduce total quantity
      totalQuantity = totalQuantity - refund.quantity;

      // reduce total
      ordersPerProduct[refund.productId]['total'] =
          ordersPerProduct[refund.productId]['total'] - refund.totalPrice;

      // reduce product quantity
      products[refund.productId] =
          products[refund.productId]! - refund.quantity;
    }

    //sorting top products
    if (products.isNotEmpty) {
      // Convert the map to a list of entries
      List<MapEntry<String, int>> sortedEntries = products.entries.toList();

      // Sort the list based on the values
      sortedEntries.sort((a, b) => b.value.compareTo(a.value));

      // Create a new map using the sorted entries
      products = Map.fromEntries(sortedEntries);
    }

    //get expenses

    AnalyticsServices().updateAnalytics(
      widget.year,
      AnalyticsModel(
        totalQuantity: totalQuantity,
        year: widget.year,
        totalRevenue: sales,
        averageOrderValue: amountPerTransaction.average,
        topProducts: products,
        monthlySales: monthlySales,
        ordersPerCity: ordersPerCity,
        ordersPerProduct: ordersPerProduct,
        totalRefunds: originalTotalQuantity - totalQuantity,
      ),
    );

    return Column(
      children: [
        SizedBox(
          // height: 250,
          height: widget.years.contains(widget.year - 1) ? 125 : 80,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: (1 / .7),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            children: [
              Report(
                title: 'Total Revenue',
                previous: 21340,
                percent: 2.5,
                price: sales,
                hasPrevious: widget.years.contains(widget.year - 1),
                year: widget.year,
              ),
              AOVReport(
                title: 'Average Order Value',
                previous: 21340,
                percent: 2.5,
                price: amountPerTransaction.average,
                hasPrevious: widget.years.contains(widget.year - 1),
                year: widget.year,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales Figures',
                style: TextStyle(
                  color: Color(0xFF171625),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              LineChartWidget(
                monthlySales: monthlySales,
                year: widget.year,
                hasPrevious: widget.years.contains(widget.year - 1),
              ),
            ],
          ),
        ),
        TopSellingList(products: products),
      ],
    );
  }
}

class TopSellingList extends StatefulWidget {
  const TopSellingList({
    super.key,
    required this.products,
  });

  final Map<String, int> products;

  @override
  State<TopSellingList> createState() => _TopSellingListState();
}

class _TopSellingListState extends State<TopSellingList> {
  int selectedIndex = 0;
  Map<String, int> topProducts = {};

  @override
  void initState() {
    for (int i = 0; i < widget.products.length; i++) {
      if (widget.products.values.elementAt(i) > 0) {
        topProducts[widget.products.keys.elementAt(i)] =
            widget.products.values.elementAt(i);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Top Selling',
          style: TextStyle(
            color: Color(0xFF171625),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              child: Container(
                width: 94,
                height: 28,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: selectedIndex == 0
                      ? const Color(0xFFF6BE2C)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Products',
                  style: TextStyle(
                    color: selectedIndex == 0 ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: Container(
                width: 94,
                height: 28,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: selectedIndex == 1
                      ? const Color(0xFFF6BE2C)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Materials',
                  style: TextStyle(
                    color: selectedIndex == 1 ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
              child: Container(
                width: 94,
                height: 28,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: selectedIndex == 2
                      ? const Color(0xFFF6BE2C)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Colors',
                  style: TextStyle(
                    color: selectedIndex == 2 ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: selectedIndex == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < topProducts.length; i++) ...[
                      TopProducts(
                          productId: topProducts.keys.elementAt(i),
                          quantity: topProducts.values.elementAt(i),
                          index: i)
                    ],
                  ],
                )
              : selectedIndex == 1
                  ? FutureBuilder<List<Materials>>(
                      future: MaterialsServices().getTopMaterials(),
                      builder: (context, snapshot) {
                        if ((snapshot.data ?? []).isEmpty &&
                            snapshot.data != null) {
                          return Center(
                            child: Column(
                              children: [
                                Gap(10),
                                Text("No Sales."),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0;
                                  i < (snapshot.data ?? []).length;
                                  i++) ...[
                                TopMaterials(
                                    index: i, materials: snapshot.data![i])
                              ],
                            ],
                          );
                        }
                      })
                  : FutureBuilder<List<ColorModel>>(
                      future: ColorService().getTopColors(),
                      builder: (context, snapshot) {
                        if ((snapshot.data ?? []).isEmpty &&
                            snapshot.data != null) {
                          return Center(
                            child: Column(
                              children: [
                                Gap(10),
                                Text("No Sales."),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0;
                                  i < (snapshot.data ?? []).length;
                                  i++) ...[
                                TopColors(index: i, colors: snapshot.data![i])
                              ],
                            ],
                          );
                        }
                      }),
        )
      ],
    );
  }
}

class TopProducts extends StatelessWidget {
  const TopProducts({
    super.key,
    required this.productId,
    required this.quantity,
    required this.index,
  });

  final String productId;
  final int quantity;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: FutureBuilder<String?>(
          future: ProductService().getProductImage(productId),
          builder: (context, snapshot) {
            return CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                snapshot.data ?? "http://via.placeholder.com/350x150",
              ),
            );
          }),
      title: FutureBuilder<String?>(
          future: ProductService().getProductName(productId),
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? "",
              style: const TextStyle(
                color: Color(0xFF171625),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
                letterSpacing: 0.10,
              ),
            );
          }),
      subtitle: Text(
        'Sales: $quantity',
        style: const TextStyle(
          color: Color(0xFF92929D),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: index == 0
          ? SizedBox(
              height: 30,
              width: 30,
              child: Image.asset('assets/images/top1.png'),
            )
          : index == 1
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/images/top2.png'),
                )
              : index == 2
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/images/top3.png'),
                    )
                  : const SizedBox(),
    );
  }
}

Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
  return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
}

class TopColors extends StatelessWidget {
  const TopColors({
    super.key,
    required this.index,
    required this.colors,
  });

  final int index;
  final ColorModel colors;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: CircleAvatar(
        backgroundColor: hexToColor(colors.hexValue),
      ),
      title: Text(
        colors.color,
        style: const TextStyle(
          color: Color(0xFF171625),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
      subtitle: Text(
        'Sales: ${colors.sales}',
        style: const TextStyle(
          color: Color(0xFF92929D),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: (colors.sales != 0)
          ? index == 0
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/images/top1.png'),
                )
              : index == 1
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/images/top2.png'),
                    )
                  : index == 2
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/top3.png'),
                        )
                      : const SizedBox()
          : null,
    );
  }
}

class TopMaterials extends StatelessWidget {
  const TopMaterials({
    super.key,
    required this.index,
    required this.materials,
  });

  final int index;
  final Materials materials;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        materials.material,
        style: const TextStyle(
          color: Color(0xFF171625),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
      subtitle: Text(
        'Sales: ${materials.sales}',
        style: const TextStyle(
          color: Color(0xFF92929D),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: (materials.sales != 0)
          ? index == 0
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/images/top1.png'),
                )
              : index == 1
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/images/top2.png'),
                    )
                  : index == 2
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/top3.png'),
                        )
                      : const SizedBox()
          : null,
    );
  }
}

class Report extends StatelessWidget {
  final String title;
  final double price;
  final int previous;
  final double percent;
  final bool hasPrevious;
  final int year;

  const Report({
    super.key,
    required this.title,
    required this.price,
    required this.previous,
    required this.percent,
    required this.hasPrevious,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 123,
      padding: const EdgeInsets.all(14.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF171725),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              // Text(
              //   '+$percent%',
              //   style: const TextStyle(
              //     color: Color(0xFF3DD598),
              //     fontSize: 12,
              //     fontFamily: 'Inter',
              //     fontWeight: FontWeight.w600,
              //     height: 0,
              //   ),
              // ),
              // const Icon(
              //   Icons.arrow_upward_rounded,
              //   size: 12,
              //   color: Color(0xFF3DD598),
              // ),
            ],
          ),
          Text(
            '₱${price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Color(0xFF171725),
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          hasPrevious
              ? FutureBuilder<double>(
                  future: AnalyticsServices().getTotalRevenue(year - 1),
                  builder: (context, snapshot) {
                    return Text(
                      'Compared to \n(₱${snapshot.data?.toStringAsFixed(2) ?? 0.0} last year)',
                      style: const TextStyle(
                        color: Color(0xFF92929D),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  })
              : const Gap(10),
        ],
      ),
    );
  }
}

class AOVReport extends StatelessWidget {
  final String title;
  final double price;
  final int previous;
  final double percent;
  final bool hasPrevious;
  final int year;

  const AOVReport({
    super.key,
    required this.title,
    required this.price,
    required this.previous,
    required this.percent,
    required this.hasPrevious,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 123,
      padding: const EdgeInsets.all(14.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF171725),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
          Text(
            '₱${price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Color(0xFF171725),
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          hasPrevious
              ? FutureBuilder<double>(
                  future: AnalyticsServices().getAOV(year - 1),
                  builder: (context, snapshot) {
                    return Text(
                      'Compared to \n(₱${snapshot.data?.toStringAsFixed(2) ?? 0.0} last year)',
                      style: const TextStyle(
                        color: Color(0xFF92929D),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  })
              : const Gap(10),
        ],
      ),
    );
  }
}
