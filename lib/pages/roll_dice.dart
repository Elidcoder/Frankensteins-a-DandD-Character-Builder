import "package:flutter/material.dart";
import 'package:frankenstein/SRD_globals.dart';
import "dart:convert";
import "dart:io";
import 'package:file_picker/file_picker.dart';
import "../file_manager.dart";
class JsonFilePicker extends StatefulWidget {
  const JsonFilePicker({super.key});

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
          child: const Text('Select JSON file'),
        ),
        if (_fileName != null && _fileContents != null) ...[
          const SizedBox(height: 16),
          Text('File name: $_fileName'),
          const SizedBox(height: 8),
          Text(
            json.encode(_fileContents),
            style: const TextStyle(
              fontFamily: 'Courier New',
            ),
          ),
        ],
      ],
    );
  }
}

class RollDice extends StatefulWidget {
  const RollDice({super.key});

  @override
  MainRollDice createState() => MainRollDice();
}

class MainRollDice extends State<RollDice> {
  //MainRollDice({Key? key}) : super(key: key);

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

                await updateGlobals();

                final Map<String, dynamic> jsonData =
                    jsonDecode(jsonString ?? "");

                //TODO(CHECK FOR DUPLICATES AT SOME POINT)
                final List<dynamic> characters = jsonData["Characters"];
                characters.addAll(jsonData2["Characters"] ?? []);

                final List<dynamic> spells = jsonData["Spells"];
                spells.addAll(jsonData2["Spells"] ?? []);

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
                //TODO(IMPLEMENT THE REMAINING SECTIONS OF THE CODE TO BE COPIED IN)
                await saveChanges();
                await updateGlobals();

                // do something with the parsed JSON data
              }
            },
            child: const Text('Select JSON file'),
          ),
        ]));
  }
}
