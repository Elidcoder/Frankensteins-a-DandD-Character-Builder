// External imports
import "package:flutter/material.dart";
import "package:printing/printing.dart" show PdfPreview;

// Project imports:
import "../content_classes/character/character.dart";
import "../utils/style_utils.dart";
import "pdf_export.dart";

class PdfPreviewPage extends StatelessWidget {
  final Character character;
  const PdfPreviewPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleUtils.buildStyledAppBar(
        title: "PDF Preview",
      ),
      body: PdfPreview(
        build: (context) => makePdf(character),
      ),
    );
  }
}
