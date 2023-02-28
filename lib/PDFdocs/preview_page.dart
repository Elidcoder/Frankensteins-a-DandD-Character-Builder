import 'package:flutter/material.dart';
//import 'package:makepdfs/models/invoice.dart';
//import 'package:makepdfs/pages/pdfexport/pdf/pdfexport.dart';
import 'package:frankenstein/PDFdocs/pdf_final_display.dart';
//import 'package:printing/printing.dart';
import 'package:frankenstein/character_globals.dart';

//import 'package:frankenstein/PDFdocs/preview_page.dart';
class DetailPage extends StatelessWidget {
  final Character invoice;
  const DetailPage({
    Key? key,
    required this.invoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PdfPreviewPage(invoice: invoice),
            ),
          );
          // rootBundle.
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
      appBar: AppBar(
        title: Text(invoice.name),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Customer',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
