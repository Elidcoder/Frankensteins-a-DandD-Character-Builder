// External Imports
import "package:flutter/material.dart";
import "package:printing/printing.dart" show PdfPreview;

// Project Imports
import "../../../models/character/character.dart";
import "../../../utils/style_utils.dart";
import "../services/pdf_generator_service.dart";

class PdfDisplay extends StatelessWidget {
  final Character character;
  final bool isPreview;
  const PdfDisplay({
    super.key,
    required this.character,
    this.isPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleUtils.buildStyledAppBar(
        title: "${character.characterDescription.name} - PDF${isPreview ? " Preview" : ""}",
      ),
      body: PdfPreview(
        build: (context) => makePdf(character),
      ),
    );
  }
}
