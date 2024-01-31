import 'package:flutter/material.dart';
import 'package:furniverse_admin/pdf_export.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  const PdfPreviewPage(
      {super.key,
      required this.ordersPerCity,
      required this.ordersPerProduct,
      required this.year});
  final Map<String, dynamic> ordersPerCity;
  final Map<String, dynamic> ordersPerProduct;
  final int year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'PDF Preview',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PdfPreview(
        canChangeOrientation: false,
        canDebug: false,

        // pdfPreviewPageDecoration: const BoxDecoration(color: Colors.white),
        build: (context) => makePDF(ordersPerCity, ordersPerProduct, year),
        pdfPreviewPageDecoration: const BoxDecoration(color: Colors.white),
      ),
    );
  }
}
