import 'dart:typed_data';
//import 'package:makepdfs/models/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:frankenstein/PDFdocs/character_class.dart';

Future<Uint8List> makePdf(Character userCharacter) async {
  final pdf = Document();
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          children: [Text(userCharacter.name)],
        );
      },
    ),
  );
  return pdf.save();
}
