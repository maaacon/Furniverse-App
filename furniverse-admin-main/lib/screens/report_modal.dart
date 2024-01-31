import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/inventory_pdf_page.dart';
import 'package:furniverse_admin/sales_pdf_page.dart';
import 'package:furniverse_admin/screens/admin_home/pages/pdf_preview_page.dart';
import 'package:furniverse_admin/services/analytics_services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

Future<DateTime?> _showDatePicker({required BuildContext context}) async {
  DateTime? dateTime;
  await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime.now())
      .then((value) {
    if (value != null) {
      dateTime = value;
    }
  });
  return dateTime;
}

showModalReport({required BuildContext context}) {
  int selectedIndex = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String salesFilter = "Custom";

  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, StateSetter setModalState) {
          return Wrap(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0))),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf_rounded),
                            Gap(5),
                            Text(
                              "Generate PDF Reports",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (() {
                                  setModalState(
                                    () {
                                      selectedIndex = 0;
                                    },
                                  );
                                }),
                                child: CategorySelection(
                                  selectedIndex: selectedIndex,
                                  title: "Sales",
                                  index: 0,
                                ),
                              ),
                            ),
                            Gap(20),
                            Expanded(
                              child: GestureDetector(
                                onTap: (() {
                                  setModalState(
                                    () {
                                      selectedIndex = 1;
                                    },
                                  );
                                }),
                                child: CategorySelection(
                                  selectedIndex: selectedIndex,
                                  title: "Inventory",
                                  index: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(20),
                        if (selectedIndex == 0)
                          CustomRadioButton(
                            elevation: 0,
                            absoluteZeroSpacing: true,
                            unSelectedColor: Theme.of(context).canvasColor,
                            buttonLables: [
                              "Custom",
                              'Weekly',
                              'Monthly',
                              'Quarterly',
                              'Semi-annually',
                              'Annually',
                            ],
                            buttonValues: [
                              "Custom",
                              "Weekly",
                              "Monthly",
                              'Quarterly',
                              "Semi-annually",
                              "Annually",
                            ],
                            buttonTextStyle: ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: Colors.black,
                                textStyle: TextStyle(fontSize: 14)),
                            radioButtonValue: (value) {
                              setModalState(() {
                                salesFilter = value;
                                print(salesFilter);
                              });
                            },
                            selectedColor: Colors.blue,
                            enableShape: true,
                            defaultSelected: "Custom",
                          ),
                        if (salesFilter == "Custom" && selectedIndex == 0)
                          Gap(20),
                        if (salesFilter == "Custom" && selectedIndex == 0)
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                    onTap: () async {
                                      startDate = await _showDatePicker(
                                              context: context) ??
                                          DateTime.now();
                                      setModalState(
                                        () {},
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.date_range),
                                        Gap(5),
                                        Text(
                                          "From: ${formatter.format(startDate)}",
                                        ),
                                      ],
                                    )),
                              ),
                              Expanded(
                                child: GestureDetector(
                                    onTap: () async {
                                      endDate = await _showDatePicker(
                                              context: context) ??
                                          DateTime.now();
                                      setModalState(
                                        () {},
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.date_range),
                                        Gap(5),
                                        Text(
                                            "To: ${formatter.format(endDate)}"),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        if (selectedIndex == 0) Gap(20),
                        GeneratePDFButton(
                          selectedIndex: selectedIndex,
                          fromDate: startDate,
                          toDate: endDate,
                          salesFilter: salesFilter,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

class GeneratePDFButton extends StatelessWidget {
  const GeneratePDFButton({
    super.key,
    required this.selectedIndex,
    required this.fromDate,
    required this.toDate,
    required this.salesFilter,
  });
  final int selectedIndex;
  final DateTime fromDate;
  final DateTime toDate;
  final String salesFilter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (selectedIndex == 0) {
            DateTime newFromDate = fromDate;

            switch (salesFilter) {
              case "Weekly":

                // Subtract the difference to get the most recent Sunday.
                DateTime recentSunday =
                    fromDate.subtract(Duration(days: fromDate.weekday));

                newFromDate = recentSunday;
                break;
              case "Monthly":
                // Set the day of the month to 1 to get the first day of the month.
                DateTime firstDay = DateTime(fromDate.year, fromDate.month, 1);
                newFromDate = firstDay;
                break;
              case "Quarterly":
                // Determine the current quarter.
                int firstMonthOfQuarter = 1;
                if (fromDate.month > 4 && fromDate.month < 9) {
                  firstMonthOfQuarter = 5;
                } else if (fromDate.month > 8) {
                  firstMonthOfQuarter = 9;
                }

                // Create a new DateTime object for the first day of the current quarter.
                DateTime firstDayOfQuarter =
                    DateTime(fromDate.year, firstMonthOfQuarter, 1);

                newFromDate = firstDayOfQuarter;
                break;
              case "Semi-annually":
                // Determine the current semi-annual period.
                int currentSemiAnnual = (fromDate.month <= 6) ? 1 : 2;

                // Calculate the first month of the current semi-annual period.
                int firstMonthOfSemiAnnual = (currentSemiAnnual - 1) * 6 + 1;

                // Create a new DateTime object for the first day of the current semi-annual period.
                DateTime firstDayOfSemiAnnual =
                    DateTime(fromDate.year, firstMonthOfSemiAnnual, 1);

                newFromDate = firstDayOfSemiAnnual;
                break;
              case "Annually":
                // Set the month and day to 1 to get the first day of the year.
                DateTime firstDay = DateTime(fromDate.year, 1, 1);
                newFromDate = firstDay;
                break;
              default:
            }

            if (context.mounted) {
              print(newFromDate);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalesPDFPage(
                    year: DateTime.now().year,
                    fromDate: newFromDate,
                    toDate: toDate,
                  ),
                ),
              );
            }
          } else {
            print("Generate Inventory");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InventoryPDFPreviewPage(),
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_rounded,
              color: Colors.white,
            ),
            Gap(5),
            Text(
              "Generate",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class CategorySelection extends StatelessWidget {
  const CategorySelection({
    super.key,
    required this.selectedIndex,
    required this.title,
    required this.index,
  });

  final int selectedIndex;
  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: selectedIndex == index ? const Color(0xFFF6BE2C) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: selectedIndex == index ? Colors.white : Colors.black,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
