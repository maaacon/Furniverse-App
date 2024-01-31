import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/models/order.dart';
import 'package:furniverse_admin/models/user.dart';
import 'package:furniverse_admin/services/analytics_services.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/services/user_services.dart';
import 'package:furniverse_admin/shared/functions.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BusinessPerformancePage extends StatefulWidget {
  const BusinessPerformancePage({super.key});

  @override
  State<BusinessPerformancePage> createState() =>
      _BusinessPerformancePageState();
}

class _BusinessPerformancePageState extends State<BusinessPerformancePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: OrderService().streamOrders(),
        initialData: null,
        builder: (context, snapshot) {
          return ListView(
            children: [
              const Text(
                'Administration',
                style: TextStyle(
                  color: Color(0xFF171725),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        '1 year',
                        style: TextStyle(
                          color:
                              selectedIndex == 0 ? Colors.white : Colors.black,
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
                        '2 year',
                        style: TextStyle(
                          color:
                              selectedIndex == 1 ? Colors.white : Colors.black,
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
                        '5 year',
                        style: TextStyle(
                          color:
                              selectedIndex == 2 ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 125,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: (1 / .7),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  children: [
                    FutureBuilder<double>(
                        future: AnalyticsServices()
                            .getTotalRevenuePerPeriod(selectedIndex + 1),
                        builder: (context, snapshot) {
                          return Report(
                            title: 'Total Revenue',
                            previous: 21340,
                            percent: 2.5,
                            price: (snapshot.data ?? 0.0).toInt(),
                          );
                        }),
                    FutureBuilder<double>(
                        future: AnalyticsServices()
                            .getAOVPerPeriod(selectedIndex + 1),
                        builder: (context, snapshot) {
                          return Report(
                            title: 'Average Order Value',
                            previous: 21340,
                            percent: 2.5,
                            price: (snapshot.data ?? 0.0).toInt(),
                          );
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // const Text(
              //   'TRANSACTION HISTORY',
              //   style: TextStyle(
              //     color: Color(0xFF171625),
              //     fontSize: 16,
              //     fontFamily: 'Inter',
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // const TransactionCard(),
              // const TransactionCard(),
              // const TransactionCard(),
              // const SizedBox(
              //   height: 20,
              // ),
              const Text(
                'RECENT CUSTOMERS',
                style: TextStyle(
                  color: Color(0xFF171625),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Builder(builder: (context) {
                final orders = Provider.of<List<OrderModel>?>(context);
                if (orders == null) {
                  return const Gap(10);
                }
                List<String> userIds = [];
                List<OrderModel> recentCustomers = [];
                for (OrderModel order in orders) {
                  if (!userIds.contains(order.userId)) {
                    recentCustomers.add(order);
                  }
                }
                return Column(
                  children: [
                    for (OrderModel order in recentCustomers) ...[
                      CustomersTile(
                        order: order,
                      )
                    ]
                  ],
                );
              }),
            ],
          );
        });
  }
}

class CustomersTile extends StatelessWidget {
  const CustomersTile({
    super.key,
    required this.order,
  });
  final OrderModel order;

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: UserService().streamUser(order.userId),
        initialData: null,
        builder: (context, child) {
          return Builder(builder: (context) {
            final user = Provider.of<UserModel?>(context);
            return ListTile(
              leading: FutureBuilder<bool>(
                  future: doesImageExist(user?.avatar ?? ""),
                  builder: (context, snapshot) {
                    return CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          snapshot.data != false && user?.avatar != ""
                              ? CachedNetworkImageProvider(
                                  user?.avatar ??
                                      "http://via.placeholder.com/350x150",
                                )
                              : null,
                      child: snapshot.data == false || user?.avatar == ""
                          ? Text(
                              user?.getInitials() ?? "",
                              style: const TextStyle(
                                color: Color(0xFF171625),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : null,
                    );
                  }),
              title: Text(
                user?.name ?? "",
                style: const TextStyle(
                  color: Color(0xFF171625),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'ID #${order.userId.toUpperCase()}',
                style: const TextStyle(
                  color: Color(0xFF92929D),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: Text(
                order.shippingStatus,
                style: TextStyle(
                  color: order.shippingStatus.toUpperCase() == "CANCELLED"
                      ? Colors.redAccent
                      : const Color(0xFF3CD598),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          });
        });
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment from #10321',
                style: TextStyle(
                  color: Color(0xFF171625),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromARGB(52, 61, 213, 152),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    color: Color.fromRGBO(61, 213, 152, 1),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              )
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'August 20, 2023, 1:30pm',
                style: TextStyle(
                  color: Color(0xFF686873),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '+ ',
                      style: TextStyle(
                        color: Color(0xFF171625),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.20,
                      ),
                    ),
                    TextSpan(
                      text: '₱',
                      style: TextStyle(
                        color: Color(0xFF171625),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: 0.20,
                      ),
                    ),
                    TextSpan(
                      text: '250.00',
                      style: TextStyle(
                        color: Color(0xFF171625),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.right,
              )
            ],
          )
        ],
      ),
    );
  }
}

class Report extends StatelessWidget {
  final String title;
  final int price;
  final int previous;
  final double percent;

  const Report({
    super.key,
    required this.title,
    required this.price,
    required this.previous,
    required this.percent,
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
            ],
          ),
          Text(
            '₱$price',
            style: const TextStyle(
              color: Color(0xFF171725),
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '$title in this period',
            style: const TextStyle(
              color: Color(0xFF92929D),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
