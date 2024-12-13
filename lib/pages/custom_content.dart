///Imports
//import 'dart:ffi';
import 'package:flutter/material.dart';
//import 'dart:convert';
//add this back if there are errors:
//import 'package:flutter/services.dart';
//import 'dart:io';
import "../file_manager.dart";
import "package:frankenstein/main.dart";
import 'package:frankenstein/character_globals.dart';

// ignore: non_constant_identifier_names

//get rid of this later{

void main() {
  //updateSRDGlobals();
  runApp(const CustomContent());
}

class CustomContent extends StatelessWidget {
  const CustomContent({super.key});
  @override
  Widget build(BuildContext context) {
    updateGlobals();
    return Scaffold(
        backgroundColor: Homepage.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Homepage.backingColor,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Create content',
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                          color: Homepage.textColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Homepage.backingColor,
                    padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    side: const BorderSide(
                        width: 5, color: Color.fromARGB(255, 7, 26, 239)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScreenTop(pagechoice: "Create spells")),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    'Create a\nspell',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Homepage.textColor),
                  ),
                ),
                const SizedBox(width: 100),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Homepage.backingColor,
                    padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    side: const BorderSide(
                        width: 5, color: Color.fromARGB(255, 7, 26, 239)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScreenTop(pagechoice: "Create items")),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    'Create an\nItem',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Homepage.textColor),
                  ),
                ),
                const SizedBox(width: 100),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Homepage.backingColor,
                    padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    side: const BorderSide(
                        width: 5, color: Color.fromARGB(255, 7, 26, 239)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScreenTop(pagechoice: "Create weapons")),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    'Create a\n weapon',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Homepage.textColor),
                  ),
                ),
              ],
            ),
            /*const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(30, 42, 30, 42),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
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
              /*
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 4)),
                );
              },*/
              child: const Text(
                'Roll dice',
                style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 100),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                //()
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 5)),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Custom \ncontent',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),*/
          ],
        ));
  }
}
