import 'dart:typed_data';
import 'package:furniverse_admin/models/color_model.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/models/order.dart';
import 'package:furniverse_admin/models/refund.dart';
import 'package:furniverse_admin/services/analytics_services.dart';
import 'package:furniverse_admin/services/color_services.dart';
import 'package:furniverse_admin/services/expense_services.dart';
import 'package:furniverse_admin/services/materials_services.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/services/refund_services.dart';
import 'package:furniverse_admin/shared/company_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> makeSalesPDF(
    int year, DateTime fromDate, DateTime toDate) async {
  final pdf = Document();

  List<Widget> widgets = [];
  List<Materials> listMaterials = [];
  // List<ColorModel> listColors = [];

  List<OrderModel> listOrders =
      await OrderService().getOrdersByRange(fromDate, toDate);
  List<Refund> listRefund =
      await RefundService().getRefundByRange(fromDate, toDate);

  List<String> refundOrderIds = [];
  for (var refund in listRefund) {
    if (refund.requestStatus!.toLowerCase() == "accepted")
      refundOrderIds.add(refund.orderId);
  }

  final List<OrderModel> fullOrders = [];
  for (var order in listOrders) {
    if (order.shippingStatus.toUpperCase() != 'CANCELLED') {
      fullOrders.add(order);
    }
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

  // total revenue
  double sales = 0.0;
  List<double> amountPerTransaction = [];
  for (int i = 0; i < fullOrders.length; i++) {
    sales += fullOrders[i].totalPrice;
    amountPerTransaction.add(fullOrders[i].totalPrice);
  }

  // total revenue
  double deduction = 0.0;
  for (var refund in listRefund) {
    deduction += refund.totalPrice;
  }
  sales -= deduction;

  // final ordersPerCity = await AnalyticsServices().getOrdersPerCity(year);
  Map<String, dynamic> ordersPerCity = {};
  Map<String, dynamic> refundPerId = {};
  for (var refund in listRefund) {
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

  int totalQuantity = 0;
  Map<String, dynamic> ordersPerProduct = {};
  Map<String, dynamic> refundPerProductId = {};
  for (var refund in listRefund) {
    refundPerProductId.putIfAbsent(refund.productId, () => 0);
    refundPerProductId[refund.productId] =
        refundPerProductId[refund.productId] + refund.quantity;
  }

  for (var order in fullOrders) {
    if (order.products.isNotEmpty) {
      // Calculate shipping cost per product
      final shippingCostPerProduct = order.shippingFee / order.products.length;
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

  int originalTotalQuantity = totalQuantity;
  for (var refund in listRefund) {
    // reduce quantity
    ordersPerProduct[refund.productId]['quantity'] =
        ordersPerProduct[refund.productId]['quantity'] - refund.quantity;

    // reduce total quantity
    totalQuantity = totalQuantity - refund.quantity;

    // reduce total
    ordersPerProduct[refund.productId]['total'] =
        ordersPerProduct[refund.productId]['total'] - refund.totalPrice;

    // reduce product quantity
    products[refund.productId] = products[refund.productId]! - refund.quantity;
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

  // final ordersPerProduct = await AnalyticsServices().getOrdersPerProduct(year);
  // final totalQuantity = await AnalyticsServices().getTotalQuantity(year);
  final totalRevenue = sales;
  final totalRefund = originalTotalQuantity - totalQuantity;
  final materialExpenses =
      await ExpenseService().getMaterialExpenseByRange(fromDate, toDate);
  final colorExpenses =
      await ExpenseService().getColorExpenseByRange(fromDate, toDate);

  Map<String, dynamic> ordersWithName = ordersPerProduct;

  await Future.forEach(ordersWithName.keys, (key) async {
    ordersWithName[key]['productName'] =
        await ProductService().getProductName(key);
  });

  List<ColorModel> allColors = [];
  try {
    allColors = await ColorService().getAllColors();
  } catch (e) {
    print("Error in getting all colors from db: $e");
  }

  Map allColorsPriceById = {};
  allColors.forEach((color) => allColorsPriceById[color.id] = color.price);

  Map allMaterialsPriceById = {};

  try {
    listMaterials = await MaterialsServices().getAllMaterials();
  } on Exception catch (e) {
    print("Error in getting all materials from db: $e");
  }
  listMaterials.forEach(
      (material) => allMaterialsPriceById[material.id] = material.price);

  Map colorSales = {};
  Map materialSales = {};
  int totalResourceSales = 0;
  double totalColorRevenue = 0.0;
  double totalMaterialRevenue = 0.0;
  for (var order in fullOrders) {
    if (!refundOrderIds.contains(order.orderId) &&
        order.requestDetails.isNotEmpty) {
      totalResourceSales++;
      final colorId = order.requestDetails['colorId'];
      final colorName = order.requestDetails['color'];

      final materialId = order.requestDetails['materialId'];
      final materialName = order.requestDetails['material'];
      colorSales.putIfAbsent(
          colorId, () => {'name': colorName, 'sales': 0, 'revenue': 0});
      materialSales.putIfAbsent(
          materialId, () => {'name': materialName, 'sales': 0, 'revenue': 0});

      colorSales[colorId]['sales'] = colorSales[colorId]['sales'] + 1;
      materialSales[materialId]['sales'] =
          materialSales[materialId]['sales'] + 1;

      colorSales[colorId]['revenue'] = colorSales[colorId]['revenue'] +
          (allColorsPriceById[colorId] * order.requestDetails['colorQuantity']);
      totalColorRevenue += colorSales[colorId]['revenue'];

      materialSales[materialId]['revenue'] = materialSales[materialId]
              ['revenue'] +
          (allMaterialsPriceById[materialId] *
              order.requestDetails['materialQuantity']);
      totalMaterialRevenue += materialSales[materialId]['revenue'];
    }
  }

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
            ],
          ),

          // total
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
                  "Material Sales Report",
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

  final materialIds = materialSales.keys.toList();

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
          _buildHeader(title: "Sales"),
          _buildHeader(title: "Revenue"),
        ],
      ),

      _buildTotalResourceRow(
        title: "Total",
        totalSales: totalResourceSales.toDouble(),
        totalRevenue: totalMaterialRevenue,
      ),

      for (var id in materialIds) ...[
        _buildResourceRow(
            id: id,
            name: materialSales[id]['name'],
            sales: materialSales[id]['sales'],
            revenue: materialSales[id]['revenue'])
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
                  "Color Sales Report",
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

  final colorIds = colorSales.keys.toList();
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
          _buildHeader(title: "Sales"),
          _buildHeader(title: "Revenue"),
        ],
      ),

      _buildTotalResourceRow(
        title: "Total",
        totalSales: totalResourceSales.toDouble(),
        totalRevenue: totalColorRevenue,
      ),

      for (var id in colorIds) ...[
        _buildResourceRow(
            id: id,
            name: colorSales[id]['name'],
            sales: colorSales[id]['sales'],
            revenue: colorSales[id]['revenue'])
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
                "Resource Sales Report",
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
                "Resource",
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
                  "Sales",
                  style: const TextStyle(
                    color: PdfColor.fromInt(0xFFFFFFFF),
                    fontSize: 12,
                  ),
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
                  "Revenue",
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
              "Material",
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: PdfColors.black,
                fontSize: 12,
              ),
            ),
          ),
          _buildNextCell(value: totalResourceSales),
          _buildNextCell(value: totalMaterialRevenue)
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
                  "Color",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              _buildNextCell(value: totalResourceSales),
              _buildNextCell(value: totalColorRevenue),
            ]),
        TableRow(children: [
          Container(
            width: 90,
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Grand Total",
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: PdfColors.black,
                fontSize: 12,
              ),
            ),
          ),
          _buildNextCell(value: totalResourceSales + totalResourceSales),
          _buildNextCell(value: totalColorRevenue + totalMaterialRevenue),
        ]),
      ],
    ),
  ));

  widgets.add(SizedBox(height: 20));

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
              "Revenue",
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
  required int sales,
  required double revenue,
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
        _buildNextCell(value: sales),
        _buildNextCell(value: revenue),
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
      ]);
}

TableRow _buildTotalResourceRow({
  required String title,
  required double totalSales,
  required double totalRevenue,
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
        _buildNextCell(value: totalSales),
        _buildNextCell(value: totalRevenue),
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
