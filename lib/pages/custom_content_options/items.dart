import "package:flutter/material.dart";

//import "package:frankenstein/character_creation_globals.dart";
import 'package:frankenstein/SRD_globals.dart';
import "dart:collection";
import "package:flutter_multi_select_items/flutter_multi_select_items.dart";
import 'package:frankenstein/character_globals.dart';
import "package:frankenstein/PDFdocs/pdf_final_display.dart";
import "dart:math";
import "dart:convert";
import "dart:io";
import 'package:file_picker/file_picker.dart';

class JsonFilePicker extends StatefulWidget {
  @override
  _JsonFilePickerState createState() => _JsonFilePickerState();
}

class _JsonFilePickerState extends State<JsonFilePicker> {
  String? _fileName;
  dynamic _fileContents;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      final file = File(result.files.single.path ?? "this'll never happen");
      final String importedContent = await file.readAsString();
      final data = json.decode(importedContent);
      setState(() {
        _fileName = file.path.split('/').last;
        _fileContents = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          child: Text('Select JSON file'),
        ),
        if (_fileName != null && _fileContents != null) ...[
          SizedBox(height: 16),
          Text('File name: $_fileName'),
          SizedBox(height: 8),
          Text(
            json.encode(_fileContents),
            style: TextStyle(
              fontFamily: 'Courier New',
            ),
          ),
        ],
      ],
    );
  }
}

class MakeAnItem extends StatefulWidget {
  @override
  MainMakeAnItem createState() => MainMakeAnItem();
}

class MainMakeAnItem extends State<MakeAnItem> {
  //MainMakeAnItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              textAlign: TextAlign.center,
              "Download content",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['json'],
              );
              if (result != null) {
                final file =
                    File(result.files.single.path ?? "Never going to happen");
                final contents = await file.readAsString();
                final jsonData2 = json.decode(contents);

                updateGlobals();
                //final String jsonContent =
                //  File("assets/Characters.json").readAsStringSync();

                //final String jsonContents =
                //  File("assets/SRD.json").readAsStringSync();
                final Map<String, dynamic> jsonData =
                    jsonDecode(jsonString ?? "");

                //at some point actually check for dupes
                final List<dynamic> characters = jsonData["Spells"];
                characters.addAll(jsonData2["Spells"] ?? []);

                final List<dynamic> classes = jsonData["Classes"];
                classes.addAll(jsonData2["Classes"] ?? []);

                final List<dynamic> sourceBooks = jsonData["Sourcebooks"];
                sourceBooks.addAll(jsonData2["Sourcebooks"] ?? []);

                final List<dynamic> proficiencies = jsonData["Proficiencies"];
                proficiencies.addAll(jsonData2["Proficiencies"] ?? []);

                final List<dynamic> equipment = jsonData["Equipment"];
                equipment.addAll(jsonData2["Equipment"] ?? []);

                final List<dynamic> languages = jsonData["Languages"];
                languages.addAll(jsonData2["Languages"] ?? []);

                final List<dynamic> races = jsonData["Races"];
                races.addAll(jsonData2["Races"] ?? []);

                final List<dynamic> backgrounds = jsonData["Backgrounds"];
                backgrounds.addAll(jsonData2["Backgrounds"] ?? []);

                final List<dynamic> feats = jsonData["Feats"];
                feats.addAll(jsonData2["Feats"] ?? []);

                //File("assets/SRD.json").writeAsStringSync(jsonEncode(json));
                writeJsonToFile(jsonData, "userContent");

                updateGlobals();

                // do something with the parsed JSON data
              }
            },
            child: const Text('Select JSON file'),
          ),
        ]));
  }
}
