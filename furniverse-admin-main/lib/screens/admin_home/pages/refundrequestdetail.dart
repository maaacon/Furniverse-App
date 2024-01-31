import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/models/refund.dart';
import 'package:furniverse_admin/models/user.dart';
import 'package:furniverse_admin/services/refund_services.dart';
import 'package:furniverse_admin/services/user_services.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RefundRequestDetail extends StatefulWidget {
  final Refund refund;
  final String productName;
  final String variantName;
  const RefundRequestDetail(
      {super.key,
      required this.refund,
      required this.productName,
      required this.variantName});

  @override
  State<RefundRequestDetail> createState() => _RefundRequestDetailState();
}

class _RefundRequestDetailState extends State<RefundRequestDetail> {
  String phone = "09876543212";
  String customerName = "";

  @override
  void initState() {
    super.initState();
    // phone = widget.contactNumber;
    // customerName = widget.userName;
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: UserService().streamUser(widget.refund.userId),
        initialData: null,
        child: SafeArea(
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
                  'Customer Refund Request',
                  style: TextStyle(
                    color: Color(0xFF303030),
                    fontSize: 16,
                    fontFamily: 'Avenir Next LT Pro',
                    fontWeight: FontWeight.w700,
                  ),
                )),
            body: Body(
              refund: widget.refund,
              variantName: widget.variantName,
              productName: widget.productName,
              // requestId: widget.request.id,
              // productName: widget.productName,
            ),
          ),
        ));
    // );
  }
}

class Body extends StatelessWidget {
  Body({
    super.key,
    required this.refund,
    required this.variantName,
    required this.productName,
    // required this.requestId,
    // required this.productName,
  });
  final _reasonController = TextEditingController();
  final _priceController = TextEditingController();
  final Refund refund;
  final String variantName;
  final String productName;
  // final String requestId;
  // final String productName;

  @override
  Widget build(BuildContext context) {
    // final request = Provider.of<CustomerRequests?>(context);
    final user = Provider.of<UserModel?>(context);

    // if (request == null) {
    //   return const Center(
    //     child: Loading(),
    //   );
    // }

    _reasonController.text = refund.reason;
    _priceController.text = refund.totalPrice.toStringAsFixed(0);

    // _sizeController.text = request.size;
    // _colorController.text = request.color;
    // _quantityController.text = request.reqquantity.toString();
    // _materialController.text = request.material;
    // _othersController.text = request.others;

    // if (request.price != null) {
    //   _priceController.text = request.price?.toStringAsFixed(2) ?? "";
    // }

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Request ID: ${refund.refundId}",
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            refund.requestStatus ?? "",
            style: const TextStyle(
              // color: request.reqStatus.toUpperCase() == 'REJECTED'
              //     ? Colors.redAccent
              //     : const Color(0xFF303030),
              fontSize: 18,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(20),
          Text(
            "Product ID: ${refund.productId}",
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          Text(
            productName,
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 18,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          const Gap(20),
          Text(
            "Variant ID: ${refund.variantId}",
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          Text(
            variantName,
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 18,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Customer ID: ${refund.userId}",
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          Text(
            user?.name ?? "",
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 18,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "E-Wallet Number:",
            style: TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          SelectableText(
            refund.eWalletNumber,
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 18,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Contact Number:",
            style: TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user?.contactNumber ?? "",
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 18,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              SizedBox(
                width: 60,
                height: 25,
                child: ElevatedButton(
                  onPressed: () async {
                    final Uri url =
                        Uri(scheme: 'tel', path: user?.contactNumber ?? "");

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Invalid number.",
                        backgroundColor: Colors.grey,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  child: const Text(
                    "Call",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            readOnly: true,
            controller: _reasonController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              labelText: 'Reason',
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          TextFormField(
            // readOnly: (!(request.reqStatus.toUpperCase() == 'PENDING')),
            controller: _priceController,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              labelText: 'Price',
              hintText: "0.00",
            ),
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                value!.isEmpty ? 'Please input a price.' : null,
          ),
          const SizedBox(height: 20),
          const Text(
            "Images:",
            style: TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.sizeOf(context).width / 2,
            child: Row(
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: refund.images.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.sizeOf(context).width / 2,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            // border:
                            //     Border.all(width: 2, color: const Color(0xFFA9ADB2)),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  refund.images[index] ??
                                      "http://via.placeholder.com/350x150",
                                ),
                                fit: BoxFit.cover)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          if (refund.requestStatus?.toUpperCase() == 'PENDING')
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationAlertDialog(
                              title:
                                  "Are you sure you want to reject ${user?.name ?? ""}'s request?",
                              onTapNo: () {
                                Navigator.pop(context);
                              },
                              onTapYes: () async {
                                await RefundService()
                                    .rejectRefund(refund.refundId ?? "");
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              tapNoString: "No",
                              tapYesString: "Yes"),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        "REJECT",
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
                const Gap(10),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_priceController.text != "" ||
                            int.parse(_priceController.text) != 0) {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmationAlertDialog(
                                title:
                                    "Are you sure you want to accept the request with amount of ₱${_priceController.text}?",
                                onTapNo: () {
                                  Navigator.pop(context);
                                },
                                onTapYes: () async {
                                  await RefundService()
                                      .acceptRefund(refund.refundId ?? "");
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                },
                                tapNoString: "No",
                                tapYesString: "Yes"),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        "ACCEPT",
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
            )
        ],
      ),
    ));
  }
}
