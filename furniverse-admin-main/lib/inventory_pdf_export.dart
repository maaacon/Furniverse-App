import 'dart:typed_data';
import 'package:furniverse_admin/models/color_model.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/models/products.dart';
import 'package:furniverse_admin/services/color_services.dart';
import 'package:furniverse_admin/services/materials_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/shared/company_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> makeInventoryPDF() async {
  final pdf = Document();

  List<Widget> widgets = [];
  List<Materials> listMaterials = [];
  List<ColorModel> listColors = [];
  List<Product> listProducts = [];

  listColors = await ColorService().getAllColors();
  listMaterials = await MaterialsServices().getAllMaterials();
  listProducts = await ProductService().getAllProducts();

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
                  "Product Inventory Report",
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
  for (var product in listProducts) {
    print(product.variants);
    for (var variant in product.variants) {
      print(variant);
    }
  }

  // material table
  widgets.add(Table(
    children: [
      // Headers
      TableRow(
        children: [
          _buildIdHeader(title: "Product ID"),
          Expanded(
            child: _buildHeader(title: "Product Name"),
          ),
          Expanded(
            child: _buildHeader(title: "Variant Name"),
          ),
          _buildHeader(title: "Stocks"),
        ],
      ),

      for (var product in listProducts) ...[
        for (var variant in product.variants) ...[
          _buildVariantRow(
            id: product.id,
            name: product.name,
            variantName: variant['variant_name'],
            stocks: variant['stocks'],
          )
        ]
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
        ],
      ),

      for (var material in listMaterials) ...[
        _buildResourceRow(
          id: material.id,
          name: material.material,
          stocks: material.stocks,
        )
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
        ],
      ),

      for (var color in listColors) ...[
        _buildResourceRow(
          id: color.id,
          name: color.color,
          stocks: color.stocks.toInt(),
        )
      ]
    ],
  ));

  // sized box
  widgets.add(SizedBox(height: 20));

  pdf.addPage(MultiPage(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      build: (context) => widgets));

  return pdf.save();
}

TableRow _buildVariantRow({
  required String id,
  required String name,
  required String variantName,
  required int stocks,
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              id,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: PdfColors.black,
                fontSize: 11,
              ),
            ),
          ),
        ),

        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: PdfColors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                variantName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: PdfColors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              stocks.toString(),
              style: const TextStyle(
                color: PdfColors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ]);
}

TableRow _buildResourceRow({
  required String id,
  required String name,
  required int stocks,
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
