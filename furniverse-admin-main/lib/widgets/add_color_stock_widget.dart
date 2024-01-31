import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/models/color_model.dart';
import 'package:furniverse_admin/models/resource_expense_model.dart';
import 'package:furniverse_admin/services/color_services.dart';
import 'package:furniverse_admin/services/expense_services.dart';
import 'package:furniverse_admin/services/materials_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';

class AddColorStocksWidget extends StatefulWidget {
  const AddColorStocksWidget({super.key, this.id, required this.color});

  final id;
  final ColorModel? color;

  @override
  State<AddColorStocksWidget> createState() => _AddColorStocksWidgetState();
}

class _AddColorStocksWidgetState extends State<AddColorStocksWidget> {
  final _formKey = GlobalKey<FormState>();
  final _stocksController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stocksController.dispose();

    super.dispose();
  }

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
                Text("Add Stocks for ${widget.color!.color}"),
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
              height: 140,
              width: double.maxFinite,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Gap(5),
                  TextFormField(
                    controller: _stocksController,
                    decoration: outlineInputBorder(label: 'Stocks'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value!.isEmpty ? 'Please input a stock/s.' : null,
                  ),
                  const Gap(20),
                  ...[],
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) return;
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationAlertDialog(
                              title: "Are you sure you want to add stocks?",
                              onTapNo: () {
                                Navigator.pop(context);
                              },
                              onTapYes: () async {
                                // final currentContext = context; // Capture the context outside the async block
                                // addVariant(context);
                                saveproduct(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              tapNoString: "No",
                              tapYesString: "Yes"),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveproduct(BuildContext context) async {
    ColorService colorService = ColorService();

    await colorService.addStocks(widget.color!.id,
        int.parse(_stocksController.text), widget.color!.price);

    await ExpenseService().addExpense(ResourceExpenseModel(
        resourceId: widget.color!.id,
        resourceName: widget.color!.color,
        expense: double.parse(_stocksController.text) * widget.color!.price,
        stocks: int.parse(_stocksController.text),
        isColor: true,
        isMaterial: false));

    Fluttertoast.showToast(
      msg: "${int.parse(_stocksController.text)} Stocks Added Successfully.",
      backgroundColor: Colors.grey,
    );
  }
}
