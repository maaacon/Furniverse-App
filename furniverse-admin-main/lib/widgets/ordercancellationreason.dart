import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';

class OrderCancellationReason extends StatefulWidget {
  const OrderCancellationReason({super.key});

  @override
  State<OrderCancellationReason> createState() => _OrderCancellationReasonState();
}

class _OrderCancellationReasonState extends State<OrderCancellationReason> {

  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Cancellation Form"),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const Gap(20),
            SizedBox(
              height: 230,
              width: double.maxFinite,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  TextFormField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      labelText: "Reason of Cancellation",
                    ),
                    maxLines: 5,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                      value!.isEmpty
                        ? 'Please input a reason of cancellation.'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async{
                        final isValid =_formKey.currentState!.validate();
                          if (!isValid) return;
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationAlertDialog(
                            title: "Are you sure you want to cancel this order?",
                            onTapNo: () { Navigator.pop(context); },
                            onTapYes: () async {
                              // await OrderService()
                              //   .updateStatus(order.orderId, "Cancelled");
                              // setState(() {});
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                msg: "Order is cancelled.",
                                backgroundColor: Colors.grey,
                              );
                              Navigator.pop(context);
                            },
                            tapNoString: "No",
                            tapYesString: "Yes"
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        "SUBMIT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
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
    );
  }
}