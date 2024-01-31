import 'package:flutter/material.dart';
import 'package:furniverse_admin/sales_pdf_export.dart';
import 'package:printing/printing.dart';

class SalesPDFPage extends StatelessWidget {
  const SalesPDFPage(
      {super.key,
      required this.year,
      required this.fromDate,
      required this.toDate});
  final int year;
  final DateTime fromDate;
  final DateTime toDate;

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
          'Sales PDF Preview',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PdfPreview(
        canChangeOrientation: false,
        canDebug: false,

        // pdfPreviewPageDecoration: const BoxDecoration(color: Colors.white),
        build: (context) => makeSalesPDF(year, fromDate, toDate),
        pdfPreviewPageDecoration: const BoxDecoration(color: Colors.white),
      ),
    );
  }
}
