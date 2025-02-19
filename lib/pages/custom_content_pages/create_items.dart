import "package:flutter/material.dart";
import 'package:frankenstein/content_classes/all_content_classes.dart';
import "dart:convert";
import "dart:io";
import 'package:file_picker/file_picker.dart';
import "../../file_manager.dart";

//TODO(Implement this)
class MakeAnItem extends StatefulWidget {
  const MakeAnItem({super.key});

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
                //writeJsonToFile(jsonData, "userContent");

                updateGlobals();

                // do something with the parsed JSON data
              }
            },
            child: const Text('Select JSON file'),
          ),
        ]));
  }
}
