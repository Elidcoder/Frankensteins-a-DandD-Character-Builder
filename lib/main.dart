///Imports
//import 'dart:ffi';
import 'package:flutter/material.dart';
//import 'dart:convert';
//add this back if there are errors:
//import 'package:flutter/services.dart';
//import 'dart:io';
import 'pages/custom_content.dart';
import 'pages/create_a_character.dart';
import 'pages/my_characters.dart';
//import 'pages/roll_dice.dart';
import 'pages/search_for_content.dart';
import 'pages/custom_content_options/spells.dart';
import 'pages/custom_content_options/items.dart';
import 'pages/custom_content_options/weapons.dart';
//import "package:frankenstein/globals.dart";
import 'package:frankenstein/SRD_globals.dart';
import 'package:frankenstein/character_globals.dart';
import "dart:convert";
import "dart:io";
import 'package:file_picker/file_picker.dart';

// ignore: non_constant_identifier_names
final Map<String, Widget> PAGELINKER = {
  "Main Menu": const MainMenu(),
  "Create a Character": CreateACharacter(),
  "Search for Content": const SearchForContent(),
  "My Characters": MyCharacters(),
  //"Roll Dice": RollDice(),
  "Custom Content": const CustomContent(),
  "Create spells": MakeASpell(),
  "Create Items": MakeAnItem(),
  "Create weapons": MakeAWeapon(),
};

//get rid of this later{

void main() {
  //updateSRDGlobals();
  runApp(const Homepage());
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  //String jsonString = File(filepath).readAsStringSync();
  //late final Map<String, dynamic> jsonmap = decoder.convert(jsonString);

  static const String _title = 'Frankenstein\'s - a D&D 5e character builder';

  @override
  Widget build(BuildContext context) {
    updateGlobals();
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.image),
              tooltip: 'Put logo here',
              onPressed: () {}),
          title: const Center(child: Text(_title)),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'settings??',
                onPressed: () {}),
          ],
        ),
        //appBar: AppBar(title: const Text(_title)),

        //appBar: AppBar(title: new Center(child: const Text(_title))),
        body: const MainMenu(),
      ),
    );
  }
}

class ScreenTop extends StatelessWidget {
  final String? pagechoice;
  const ScreenTop({Key? key, this.pagechoice}) : super(key: key);
  static const String _title = 'Frankenstein\'s - a D&D 5e character builder';

  @override
  Widget build(BuildContext context) {
    updateGlobals();
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: (pagechoice == "Main Menu")
                  ? const Icon(Icons.image)
                  : const Icon(Icons.home),
              tooltip: (pagechoice == "Main Menu")
                  ? "Put logo here"
                  : "Return to the main menu",
              onPressed: () {
                if (pagechoice != "Main Menu") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScreenTop(pagechoice: "Main Menu")));
                }
              }),
          title: const Center(child: Text(_title)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Return to the previous page',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings??',
                onPressed: () {}),
          ],
        ),
        //pick relevent call
        body: PAGELINKER[pagechoice],
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    updateGlobals();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'Main Menu',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
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
                backgroundColor: Colors.blue,
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
                          const ScreenTop(pagechoice: "Create a Character")),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Create a \ncharacter',
                style: TextStyle(
                    fontSize: 35,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ScreenTop(pagechoice: "Search for Content")),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Search for\ncontent',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 100),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    (CHARACTERLIST.isNotEmpty) ? Colors.blue : Colors.grey,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                if (CHARACTERLIST.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ScreenTop(pagechoice: "My Characters")),
                  );
                }
              },
              child: const Text(
                textAlign: TextAlign.center,
                'My \ncharacters',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
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
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(45, 25, 45, 25),
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
                'Download\n Content',
                style: TextStyle(
                    fontSize: 35,
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
                      builder: (context) =>
                          const ScreenTop(pagechoice: "Custom Content")),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Create \ncontent',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
