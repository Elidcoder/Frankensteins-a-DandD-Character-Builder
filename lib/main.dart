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
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
  runApp(MaterialApp(
    home: Homepage(),
  ));
}

class Homepage extends StatefulWidget {
  static Color primaryColor = Colors.white;
  static Color backingColor = Colors.blue;
  @override
  MainHomepage createState() => MainHomepage();
}

class MainHomepage extends State<Homepage> {
  Color currentColor = Colors.blue;
  Color currentBackingColor = Colors.blue;
  static const String _title = 'Frankenstein\'s - a D&D 5e character builder';

  @override
  Widget build(BuildContext context) {
    updateGlobals();
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Homepage.primaryColor,
        // other theme configuration options
      ),
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Homepage.primaryColor,
          backgroundColor: Homepage.backingColor,
          leading: IconButton(
              icon: const Icon(Icons.image),
              tooltip: 'Put logo here',
              onPressed: () {}),
          title: const Center(child: Text(_title)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Help, feedback and settings?',
              onPressed: () {
                setState(() {
                  _showColorPicker(context);
                });
              },
            ),
          ],
        ),
        //appBar: AppBar(title: const Text(_title)),

        //appBar: AppBar(title: new Center(child: const Text(_title))),
        body: MainMenu(),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.grey,
              ),
            ),
            AlertDialog(
              title: const Text('Help, information and settings',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              content: SingleChildScrollView(
                  child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    const Text(
                      'App overview',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Main Menu - This is the section you are currently in, 
it allows you to navigate between every section.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Create a Character - This is the section to build your character, 
it contains tabs which will guide you through the creation process.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Search for Content - This is the section to look through your content, 
it allows you to search through and edit much of that content.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• My Characters -  This is the section to look through your characters, 
it allows you to search through, delete, edit and fight with them.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Download Content -  This is a button to install content, 
it allows you to select content to install from your computer.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Create Content -  This is the section to create new content, 
it takes you to another page to select the type of content. Once there,
you can create that type of content, saving it to your app.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    const SizedBox(
                      height: 9,
                    ),
                    const Text(
                      'Report a bug or ask for help:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    const Text(
                      '''This is an open source project, to report bugs, 
ask for help or suggest improvements please go to:
https://github.com/Elidcoder/frankensteins2
''',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'Select app colors:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    const Text(
                      'Select background colors:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    ColorPicker(
                      pickerColor: currentBackingColor,
                      onColorChanged: (color) {
                        setState(() {
                          currentBackingColor = color;
                        });
                      },
                    ),
                    const Text(
                      'Select text colors:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    ColorPicker(
                      pickerColor: currentColor,
                      onColorChanged: (color) {
                        setState(() {
                          currentColor = color;
                        });
                      },
                    ),
                  ])),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Homepage.primaryColor = currentColor;
                      Homepage.backingColor = currentBackingColor;
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _saveColor() {
    // Save the selected color to a storage or database
    // and update the app's primary color
    // For example, to update the primary color of the app:
    Homepage.primaryColor = currentColor;
  }
}

class ScreenTop extends StatelessWidget {
  final String? pagechoice;
  static Color primaryColor = Colors.white;
  static Color backingColor = Colors.blue;
  const ScreenTop({Key? key, this.pagechoice}) : super(key: key);
  static const String _title = 'Frankenstein\'s - a D&D 5e character builder';

  @override
  Widget build(BuildContext context) {
    updateGlobals();
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Homepage.primaryColor,
          backgroundColor: Homepage.backingColor,
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
                color: Homepage.backingColor,
                child: Text(
                  textAlign: TextAlign.center,
                  'Main Menu',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Homepage.primaryColor),
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
                          const ScreenTop(pagechoice: "Create a Character")),
                );
              },
              child: Text(
                textAlign: TextAlign.center,
                'Create a \ncharacter',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Homepage.primaryColor),
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
                          const ScreenTop(pagechoice: "Search for Content")),
                );
              },
              child: Text(
                textAlign: TextAlign.center,
                'Search for\ncontent',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Homepage.primaryColor),
              ),
            ),
            const SizedBox(width: 100),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: (CHARACTERLIST.isNotEmpty)
                    ? Homepage.backingColor
                    : Colors.grey,
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
              child: Text(
                textAlign: TextAlign.center,
                'My \ncharacters',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Homepage.primaryColor),
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
                  writeJsonToFile(jsonData, "userContent");
                  updateGlobals();

                  //File("assets/SRD.json").writeAsStringSync(jsonEncode(json));

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
              child: Text(
                'Download\n Content',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Homepage.primaryColor),
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
                //()
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ScreenTop(pagechoice: "Custom Content")),
                );
              },
              child: Text(
                textAlign: TextAlign.center,
                'Create \ncontent',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Homepage.primaryColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Json format incorrect, reformat and try again!',
            style: TextStyle(
                color: Colors.red, fontSize: 45, fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
