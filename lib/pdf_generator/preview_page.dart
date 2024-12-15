//External Imports
import 'package:flutter/material.dart';

// Project Imports
import 'pdf_final_display.dart';
import '../content_classes/character.dart';

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
          // rootBundle.
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
      appBar: AppBar(
        title: Text(character.characterDescription.name),
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
