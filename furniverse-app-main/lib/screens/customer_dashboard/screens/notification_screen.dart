import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse/models/notif.dart';
import 'package:furniverse/services/notification_service.dart';
import 'package:furniverse/shared/loading.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // List<Notif> notifs = NotifList.notifs;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        // leading: SvgPicture.asset(
        //   'assets/icons/search.svg',
        //   height: 24,
        //   width: 24,
        //   fit: BoxFit.scaleDown,
        // ),
        centerTitle: true,
        title: const Text(
          'NOTIFICATION',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF303030),
            fontSize: 16,
            fontFamily: 'Avenir Next LT Pro',
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: MultiProvider(providers: [
        StreamProvider.value(
            value: NotificationService().streamNotifications(user?.uid),
            initialData: null),
      ], child: const Body()),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<List<NotificationModel>?>(context);

    if (notifications == null) {
      const Center(
        child: Loading(),
      );
    }

    return Column(
      children: [Expanded(child: _createNotifList(notifications))],
    );
  }

  _createNotifList(List<NotificationModel>? notifications) =>
      ListView.separated(
          itemBuilder: (context, index) {
            final notif = notifications?[index];

            bool isOrder = notif?.notifImage != null;

            return Stack(
              children: [
                Container(
                  height: 100,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: notif?.isViewed == false
                        ? const Color(0xffF0F0F0)
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isOrder)
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  notif?.notifImage ??
                                      "http://via.placeholder.com/350x150",
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      if (isOrder) const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                notif?.notifTitle ?? "",
                                style: TextStyle(
                                  color: const Color(0xFF303030),
                                  fontSize: isOrder ? 12 : 14,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Flexible(
                              child: Text(
                                notif?.notifSubtitle ?? "",
                                style: TextStyle(
                                  color: const Color(0xFF808080),
                                  fontSize: isOrder ? 10 : 12,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!(notif?.isViewed ?? false))
                  const Positioned(
                    right: 20,
                    bottom: 20,
                    child: Text(
                      'New',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF27AE60),
                        fontSize: 14,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                // if (notif.category != 'order')
                //   const Positioned(
                //       right: 20,
                //       bottom: 20,
                //       child: Text(
                //         'HOT!',
                //         textAlign: TextAlign.right,
                //         style: TextStyle(
                //           color: Color(0xFFEB5757),
                //           fontSize: 14,
                //           fontFamily: 'Nunito Sans',
                //           fontWeight: FontWeight.w800,
                //         ),
                //       )),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 5,
            );
          },
          itemCount: notifications?.length ?? 0);
}
