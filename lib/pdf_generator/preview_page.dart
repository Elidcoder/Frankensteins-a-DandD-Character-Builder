//External Imports
import "package:flutter/material.dart";

// Project Imports
import "pdf_final_display.dart" show PdfPreviewPage;
import "../content_classes/character/character.dart";

class DetailPage extends StatelessWidget {
  final Character character;
  const DetailPage({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PdfPreviewPage(character: character),
            ),
          );
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
      appBar: AppBar(title: Text(character.characterDescription.name)),
    );
  }
}
