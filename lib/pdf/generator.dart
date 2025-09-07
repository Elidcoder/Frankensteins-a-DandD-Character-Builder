// External Imports
import "dart:typed_data" show Uint8List;

import "package:frankenstein/pdf/first_page/page.dart" show generatePage1;
import "package:pdf/widgets.dart";

// Project Import
import "../models/character/character.dart";

/* Takes in a character and generates the PDF for it. */
Future<Uint8List> makePdf(Character userCharacter) async {
  final pdf = Document();

  pdf.addPage(generatePage1(userCharacter));
  
  return pdf.save();
}
