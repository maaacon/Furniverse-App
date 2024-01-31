import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse/models/notif.dart';
import 'package:furniverse/screens/customer_dashboard/screens/favorite_screen.dart';
import 'package:furniverse/screens/customer_dashboard/screens/home_screen.dart';
import 'package:furniverse/screens/customer_dashboard/screens/notification_screen.dart';
import 'package:furniverse/screens/customer_dashboard/screens/profile_screen.dart';
import 'package:furniverse/services/cart_service.dart';
import 'package:furniverse/services/favorite_service.dart';
import 'package:furniverse/services/notification_service.dart';
import 'package:furniverse/services/order_service.dart';
import 'package:furniverse/services/product_service.dart';
import 'package:furniverse/services/refund_service.dart';
import 'package:furniverse/services/request_services.dart';
import 'package:furniverse/services/user_service.dart';
import 'package:provider/provider.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int currentIndex = 0;
  List screens = [
    const HomeScreen(),
    const FavoritePage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  void updateScreenIndex(int index) async {
    // await NotificationService().updateNotificationsToRead(userId);
    setState(() {
      currentIndex = index;
    });
  }

  Future<void> updateReadNotification(String userId) async {
    await NotificationService().updateNotificationsToRead(userId);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: UserService().streamUser(user?.uid), initialData: null),
        StreamProvider.value(
            value: FavoriteService().streamFavorites(user?.uid),
            initialData: null),
        StreamProvider.value(
            value: ProductService().streamProducts(), initialData: null),
        StreamProvider.value(
            value: OrderService().streamOrders(user?.uid), initialData: null),
        StreamProvider.value(
            value: NotificationService().streamNewNotifications(user?.uid),
            initialData: null),
        StreamProvider.value(
            value: RequestsService().streamRequest(user?.uid),
            initialData: null),
        StreamProvider.value(
            value: RefundService().streamRefunds(user?.uid), initialData: null),
        StreamProvider.value(
            value: CartService().streamCart(user?.uid), initialData: null),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: screens[currentIndex],
          bottomNavigationBar: Navigation(
            currentIndex: currentIndex,
            onTap: updateScreenIndex,
            readNotif: updateReadNotification,
          ),
        ),
      ),
    );
  }
}

class Navigation extends StatelessWidget {
  const Navigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.readNotif,
  });

  final int currentIndex;
  final Function onTap;
  final Function readNotif;

  @override
  Widget build(BuildContext context) {
    final newNotifications = Provider.of<List<NotificationModel>?>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (value) async {
        onTap(value);

        if (currentIndex == 2) {
          if (newNotifications?.isNotEmpty ?? false) {
            await readNotif(newNotifications?[0].userId);
          }
        }
      },
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      iconSize: 24,
      items: [
        const BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        const BottomNavigationBarItem(
            label: "Bookmark", icon: Icon(Icons.bookmark)),
        BottomNavigationBarItem(
          label: "Notifications",
          icon: Stack(
            children: [
              const Icon(Icons.notifications),
              if (newNotifications?.isNotEmpty ?? false)
                const Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.red,
                  ),
                )
            ],
          ),
        ),
        const BottomNavigationBarItem(
            label: "Account", icon: Icon(Icons.person)),
      ],
    );
  }
}
