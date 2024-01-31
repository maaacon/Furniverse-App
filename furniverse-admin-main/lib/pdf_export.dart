import 'dart:typed_data';
import 'package:furniverse_admin/models/color_model.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/services/analytics_services.dart';
import 'package:furniverse_admin/services/color_services.dart';
import 'package:furniverse_admin/services/materials_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/shared/company_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> makePDF(Map<String, dynamic> ordersPerCity,
    Map<String, dynamic> ordersPerProduct, int year) async {
  final pdf = Document();

  List<Widget> widgets = [];
  List<Materials> listMaterials = [];
  List<ColorModel> listColors = [];

  final totalQuantity = await AnalyticsServices().getTotalQuantity(year);
  final totalRevenue = await AnalyticsServices().getTotalRevenue(year);
  final totalRefund = await AnalyticsServices().getTotalRefund(year);
  final materialExpenses = await MaterialsServices().getTotalExpense(year);
  final colorExpenses = await ColorService().getTotalExpense(year);

  Map<String, dynamic> ordersWithName = ordersPerProduct;

  await Future.forEach(ordersWithName.keys, (key) async {
    ordersWithName[key]['productName'] =
        await ProductService().getProductName(key);
  });

  listColors = await ColorService().getAllColors();
  listMaterials = await MaterialsServices().getAllMaterials();

  // company name
  var companyInfo = Container(
    decoration: const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Text(
          companyName,
          style: const TextStyle(
            color: PdfColor.fromInt(0xFFFFFFFF),
            fontSize: 24,
          ),
        ),
        Text(
          companyAddress,
          style: const TextStyle(
            color: PdfColor.fromInt(0xFFFFFFFF),
            fontSize: 18,
          ),
        ),
        Text(
          companyLink,
          style: const TextStyle(
            color: PdfColor.fromInt(0xFFFFFFFF),
            fontSize: 16,
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    ),
  );
  widgets.add(companyInfo);

  // sized box
  widgets.add(SizedBox(height: 20));

  // location table
  widgets.add(_buildCityTable(ordersPerCity));

  // sized box
  widgets.add(SizedBox(height: 20));

  // product table title
  widgets.add(
    Table(
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: TableBorder(
              bottom: BorderSide(color: PdfColors.white),
            ),
          ),
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.all(10),
                decoration:
                    const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
                child: Text(
                  "Furniture Retail Sales Analysis",
                  style: const TextStyle(
                    color: PdfColor.fromInt(0xFFFFFFFF),
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );

  // product table
  widgets.add(Builder(
    builder: (context) {
      final productIds = ordersWithName.keys.toList();

      return Table(
        children: [
          // Headers
          TableRow(
            children: [
              _buildIdHeader(title: "Product ID"),

              Expanded(
                child: _buildHeader(title: "Furniture"),
              ),

              _buildHeader(title: "Sales"),
              _buildHeader(title: "Refunds"),
              _buildHeader(title: "Total Revenue"),
              // _buildHeader(title: "Surplus/Leakage"),
              // _buildHeader(title: "Trade Area Capture"),
              // _buildHeader(title: "Pull Factor"),
            ],
          ),

          // total
          // _buildCityRow("Total"),
          _buildTotalRow(
            title: "Total",
            totalQuantity: totalQuantity,
            totalRevenue: totalRevenue,
            totalRefund: totalRefund,
          ),

          for (var productId in productIds) ...[
            _buildProductRow(
                productId: productId,
                productName: ordersWithName[productId]['productName'] ?? "",
                quantity: ordersWithName[productId]['quantity'] ?? 0,
                refunds: ordersWithName[productId]['refunds'] ?? 0,
                revenue: ordersWithName[productId]['total'] ?? 0.0),
          ]

          // loop
          // for (int i = 0; i < 20; i++) _buildCityRow("Coffee Table")
        ],
      );
    },
  ));

  // sized box
  widgets.add(SizedBox(height: 20));

  // product table title
  widgets.add(
    Table(
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: TableBorder(
              bottom: BorderSide(color: PdfColors.white),
            ),
          ),
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.all(10),
                decoration:
                    const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
                child: Text(
                  "Material Inventory Report",
                  style: const TextStyle(
                    color: PdfColor.fromInt(0xFFFFFFFF),
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );

  // material table
  widgets.add(Table(
    children: [
      // Headers
      TableRow(
        children: [
          _buildIdHeader(title: "Material ID"),
          Expanded(
            child: _buildHeader(title: "Name"),
          ),
          _buildHeader(title: "Stocks"),
          _buildHeader(title: "Sales"),
        ],
      ),

      for (var material in listMaterials) ...[
        _buildResourceRow(
            id: material.id,
            name: material.material,
            stocks: material.stocks,
            sales: material.sales)
      ]
    ],
  ));

  // sized box
  widgets.add(SizedBox(height: 20));

  // product table title
  widgets.add(
    Table(
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: TableBorder(
              bottom: BorderSide(color: PdfColors.white),
            ),
          ),
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.all(10),
                decoration:
                    const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
                child: Text(
                  "Color Inventory Report",
                  style: const TextStyle(
                    color: PdfColor.fromInt(0xFFFFFFFF),
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );
  // material table
  widgets.add(Table(
    children: [
      // Headers
      TableRow(
        children: [
          _buildIdHeader(title: "Color ID"),
          Expanded(
            child: _buildHeader(title: "Name"),
          ),
          _buildHeader(title: "Stocks"),
          _buildHeader(title: "Sales"),
        ],
      ),

      for (var color in listColors) ...[
        _buildResourceRow(
            id: color.id,
            name: color.color,
            stocks: color.stocks.toInt(),
            sales: color.sales)
      ]
    ],
  ));

  // sized box
  widgets.add(SizedBox(height: 20));

  // product table title
  widgets.add(Container(
    width: 300,
    child: Table(
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: TableBorder(
              bottom: BorderSide(color: PdfColors.white),
            ),
          ),
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              padding: const EdgeInsets.all(10),
              decoration:
                  const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
              child: Text(
                "Financial Statement",
                style: const TextStyle(
                  color: PdfColor.fromInt(0xFFFFFFFF),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ));
  // product table title
  widgets.add(Container(
    width: 300,
    child: Table(
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: TableBorder(
              bottom: BorderSide(color: PdfColors.white),
            ),
          ),
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              padding: const EdgeInsets.all(10),
              decoration:
                  const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
              child: Text(
                "Particulars",
                style: const TextStyle(
                  color: PdfColor.fromInt(0xFFFFFFFF),
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              padding: const EdgeInsets.all(10),
              decoration:
                  const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Value",
                  style: const TextStyle(
                    color: PdfColor.fromInt(0xFFFFFFFF),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(children: [
          Container(
            width: 90,
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Total Revenue",
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: PdfColors.black,
                fontSize: 12,
              ),
            ),
          ),
          _buildNextCell(value: totalRevenue)
        ]),
        TableRow(children: [
          Container(
            width: 90,
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Material Expenses",
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: PdfColors.black,
                fontSize: 12,
              ),
            ),
          ),
          _buildNextCell(value: materialExpenses)
        ]),
        TableRow(
            decoration: const BoxDecoration(
              border: TableBorder(
                bottom: BorderSide(color: PdfColors.black),
              ),
            ),
            children: [
              Container(
                width: 90,
                height: 25,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  "Color Expenses",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              _buildNextCell(value: colorExpenses)
            ]),
        TableRow(children: [
          Container(
            width: 90,
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Profit",
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: PdfColors.black,
                fontSize: 12,
              ),
            ),
          ),
          _buildNextCell(
              value: totalRevenue - (colorExpenses + materialExpenses))
        ]),
      ],
    ),
  ));

  pdf.addPage(MultiPage(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      build: (context) => widgets));

  return pdf.save();
}

Table _buildCityTable(Map<String, dynamic> ordersPerCity) {
  final provinces = ordersPerCity.keys.toList();

  return Table(children: [
    TableRow(children: [
      Expanded(
        child: Text(""),
      ),
      _buildHeader(title: "No. of Customers"),
      _buildHeader(title: "No. of Orders"),
      _buildHeader(title: "Total Revenue"),
    ]),
    for (var province in provinces) ...[
      _buildCityRow(
          title: province,
          noOfUsers: ordersPerCity[province]['users'].length,
          quantity: ordersPerCity[province]['quantity'],
          totalRevenue: ordersPerCity[province]['total'])
    ],
  ]);
}

TableRow _buildCityRow(
    {required String title,
    required int noOfUsers,
    required int quantity,
    required double totalRevenue}) {
  return TableRow(
      decoration: const BoxDecoration(
        border: TableBorder(
          bottom: BorderSide(color: PdfColors.black),
        ),
      ),
      children: [
        Expanded(
          child: Container(
              height: 25,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                  ),
                ),
              )),
        ),
        _buildNextCell(value: noOfUsers),
        _buildNextCell(value: quantity),
        _buildNextCell(value: totalRevenue),
        // _buildNextCell(value: 2000000),
        // _buildNextCell(value: 2000000),
      ]);
}

TableRow _buildResourceRow({
  required String id,
  required String name,
  required int stocks,
  required int sales,
}) {
  return TableRow(
      decoration: const BoxDecoration(
        border: TableBorder(
          bottom: BorderSide(color: PdfColors.black),
        ),
      ),
      children: [
        // _buildNextCell(value: productId),
        Container(
          height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              id,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: PdfColors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),

        Expanded(
          child: Container(
            height: 25,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                name,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: PdfColors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        _buildNextCell(value: stocks),
        _buildNextCell(value: sales),
      ]);
}

TableRow _buildProductRow(
    {required String productId,
    required String productName,
    required int quantity,
    required int refunds,
    required double revenue}) {
  return TableRow(
      decoration: const BoxDecoration(
        border: TableBorder(
          bottom: BorderSide(color: PdfColors.black),
        ),
      ),
      children: [
        // _buildNextCell(value: productId),
        Container(
          height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              child: Text(
                productId,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: PdfColors.black,
                  fontSize: 12,
                ),
                softWrap: false,
              ),
            ),
          ),
        ),

        Expanded(
          child: Container(
            height: 25,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                productName,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: PdfColors.black,
                  fontSize: 12,
                ),
                softWrap: false,
              ),
            ),
          ),
        ),
        _buildNextCell(value: quantity),
        _buildNextCell(value: refunds),
        _buildNextCell(value: revenue),
        // _buildNextCell(value: 2000000),
        // _buildNextCell(value: 2000000),
      ]);
}

TableRow _buildTotalRow({
  required String title,
  required double totalRevenue,
  required int totalQuantity,
  required int totalRefund,
}) {
  return TableRow(
      decoration: const BoxDecoration(
        border: TableBorder(
          bottom: BorderSide(color: PdfColors.black),
        ),
      ),
      children: [
        Container(
          height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: PdfColors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
        _buildNextCell(value: ""),
        _buildNextCell(value: totalQuantity),
        _buildNextCell(value: totalRefund),
        _buildNextCell(value: totalRevenue),
        // _buildNextCell(value: quantity),
        // _buildNextCell(value: totalRevenue),
        // _buildNextCell(value: 2000000),
        // _buildNextCell(value: 2000000),
      ]);
}

Container _buildHeader({required String title}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 1),
    width: 90,
    height: 50,
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
    child: Align(
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: PdfColor.fromInt(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
    ),
  );
}

Container _buildIdHeader({required String title}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 1),
    width: 170,
    height: 50,
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: PdfColor.fromInt(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
    ),
  );
}

Container _buildNextCell({required dynamic value}) {
  String text = "";
  if (value.runtimeType == double) {
    text = (value as double).toStringAsFixed(0);
  } else {
    text = value.toString();
  }
  return Container(
    width: 90,
    height: 25,
    padding: const EdgeInsets.all(5),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: PdfColors.black,
        fontSize: 12,
      ),
    ),
  );
}
