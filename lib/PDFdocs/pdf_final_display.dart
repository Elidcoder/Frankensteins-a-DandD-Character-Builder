import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
//import 'package:makepdfs/models/invoice.dart';
//import 'package:makepdfs/pages/pdfexport/pdf/pdfexport.dart';
//import 'package:frankenstein/PDFdocs/pdf_export.dart';
//import 'package:printing/printing.dart';
import 'package:frankenstein/character_globals.dart';
import 'package:frankenstein/PDFdocs/pdf_export.dart';

//import 'package:frankenstein/PDFdocs/preview_page.dart';
class PdfPreviewPage extends StatelessWidget {
  final Character character;
  const PdfPreviewPage({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(character),
      ),
    );
  }
}
