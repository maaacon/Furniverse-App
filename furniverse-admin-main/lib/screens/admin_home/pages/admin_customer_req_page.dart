import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/models/request.dart';
import 'package:furniverse_admin/models/user.dart';
import 'package:furniverse_admin/screens/admin_home/pages/request_detail_page.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/services/user_services.dart';
import 'package:furniverse_admin/shared/functions.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CustomerRequestsPage extends StatelessWidget {
  const CustomerRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<List<CustomerRequests>?>(context);

    if (requests == null) {
      return const Center(
        child: Loading(),
      );
    }

    return SingleChildScrollView(
      // controller: controller,
      child: Column(
        children: [
          // const Align(
          //   alignment: Alignment.topLeft,
          //   child: Text(
          //     'Customer Request',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 18,
          //       fontFamily: 'Inter',
          //       fontWeight: FontWeight.w600,
          //       height: 0,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 28),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer List',
                style: TextStyle(
                  color: Color(0xFF171625),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              // Icon(
              //   Icons.more_horiz_outlined,
              //   color: Color(0xffB5B5BE),
              //   size: 24,
              // )
            ],
          ),
          for (int i = 0; i < requests.length; i++) ...[
            StreamProvider.value(
              value: UserService().streamUser(requests[i].userId),
              initialData: null,
              child: CustomerCard(
                request: requests[i],
              ),
            ),
          ],
          // const SizedBox(height: 20),
          // TextButton(
          //   onPressed: () {},
          //   child: const Text(
          //     'VIEW MORE CUSTOMERS',
          //     style: TextStyle(
          //       color: Color(0xFFF6BE2C),
          //       fontSize: 12,
          //       fontFamily: 'Inter',
          //       fontWeight: FontWeight.w500,
          //       height: 0,
          //       letterSpacing: 0.80,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.request,
  });

  final CustomerRequests request;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) return const Gap(36);

    return ListTile(
      onTap: () async {
        final productName =
            await ProductService().getProductName(request.productId);

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return RequestDetailPage(
                  request: request,
                  userName: user.name,
                  contactNumber: user.contactNumber,
                  productName: productName ?? "",
                );
              },
            ),
          );
        }
      },
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        height: 36,
        width: 36,
        child: FutureBuilder<bool>(
            future: doesImageExist(user.avatar),
            builder: (context, snapshot) {
              return CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: snapshot.data != false && user.avatar != ""
                    ? CachedNetworkImageProvider(
                        user.avatar,
                      )
                    : null,
                child: snapshot.data == false || user.avatar == ""
                    ? Text(
                        user.getInitials(),
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
      ),
      minLeadingWidth: 10,
      title: Text(
        user.name,
        style: const TextStyle(
          color: Color(0xFF171625),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 0,
          letterSpacing: 0.10,
        ),
      ),
      subtitle: Text(
        'Customer ID:${request.userId}',
        style: const TextStyle(
          color: Color(0xFF92929D),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 24, maxWidth: 24),
        icon: request.reqStatus.toUpperCase() == 'PENDING'
            ? const Icon(Icons.mark_email_unread_outlined)
            : const Icon(Icons.mark_email_read_outlined),
        iconSize: 24,
        onPressed: () async {
          final productName =
              await ProductService().getProductName(request.productId);

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RequestDetailPage(
                    request: request,
                    userName: user.name,
                    contactNumber: user.contactNumber,
                    productName: productName ?? "",
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
