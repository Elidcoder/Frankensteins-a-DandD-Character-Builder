///Imports
//import 'dart:ffi';
import "package:flutter/material.dart";
//import 'dart:convert';
//add this back if there are errors:
//import 'package:flutter/services.dart';
//import 'dart:io';
import "pages/custom_content.dart";
import "pages/create_a_character.dart";
import "pages/my_characters.dart";
//import "pages/roll_dice.dart";
import "pages/search_for_content.dart";
import "pages/custom_content_options/spells.dart";
import "pages/custom_content_options/items.dart";
import "pages/custom_content_options/weapons.dart";
//import "package:frankenstein/globals.dart";
import "package:frankenstein/SRD_globals.dart";
import "package:frankenstein/character_globals.dart";
import "dart:convert";
import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:flutter_colorpicker/flutter_colorpicker.dart";

// ignore: non_constant_identifier_names
final Map<String, Widget> PAGELINKER = {
  "Main Menu": MainMenu(),
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
  runApp(MaterialApp(
    home: Homepage(),
  ));
}

class Homepage extends StatefulWidget {
  static Color textColor = COLORLIST.isEmpty ? Colors.white : COLORLIST.last[0];
  static Color backingColor =
      COLORLIST.isEmpty ? Colors.blue : COLORLIST.last[1];
  static Color backgroundColor =
      COLORLIST.isEmpty ? Colors.white : COLORLIST.last[2];
  @override
  MainHomepage createState() => MainHomepage();
}

class MainHomepage extends State<Homepage> {
  Color currentTextColor = Homepage.textColor;
  Color currentBackingColor = Homepage.backingColor;
  Color currentBackgroundColor = Homepage.backgroundColor;

  static const String _title = "Frankenstein's - a D&D 5e character builder";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      //load globals
      future: updateGlobals(),
      //keep running until my app is built
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // if updateGlobals is done successfully, return MaterialApp
          if (COLORLIST.isNotEmpty) {
            Homepage.backgroundColor = COLORLIST.last[2];
            Homepage.backingColor = COLORLIST.last[1];
            Homepage.textColor = COLORLIST.last[0];
            currentTextColor = COLORLIST.last[0];
            currentBackingColor = COLORLIST.last[1];
            currentBackgroundColor = COLORLIST.last[2];
          }
          return MaterialApp(
            theme: ThemeData(
              primaryColor: Homepage.textColor,
            ),
            title: _title,
            home: Scaffold(
              appBar: AppBar(
                foregroundColor: Homepage.textColor,
                backgroundColor: Homepage.backingColor,
                leading: IconButton(
                    icon: const Icon(Icons.image),
                    tooltip: "Put logo here",
                    onPressed: () {}),
                title: const Center(child: Text(_title)),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: "Settings",
                    onPressed: () {
                      _showColorPicker(context);
                    },
                  ),
                ],
              ),
              body: MainMenu(),
            ),
          );
        } else {
          // if updateGlobals is still loading, output some text to let the user know
          return const Center(
            child: Text(
              "Please wait while the application saves or loads data",
              style: TextStyle(color: Colors.blue, fontSize: 30),
            ),
          );
        }
      },
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
              title: const Text("Settings",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              content: SingleChildScrollView(
                  child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    const Text(
                      "Select box colours:",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    ColorPicker(
                      pickerColor: currentBackingColor,
                      onColorChanged: (color) {
                        currentBackingColor = color;
                      },
                    ),
                    const Text(
                      "Select text colour:",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    ColorPicker(
                      pickerColor: currentTextColor,
                      onColorChanged: (color) {
                        currentTextColor = color;
                      },
                    ),
                    const Text(
                      "Select background colour:",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    ColorPicker(
                      pickerColor: currentBackgroundColor,
                      onColorChanged: (color) {
                        //setState(() {
                        currentBackgroundColor = color;
                        //});
                      },
                    ),
                  ])),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Homepage.textColor = currentTextColor;
                      Homepage.backingColor = currentBackingColor;
                      Homepage.backgroundColor = currentBackgroundColor;
                      Navigator.of(context).pop();
                      final Map<String, dynamic> json =
                          jsonDecode(jsonString ?? "");
                      List<dynamic> colors = json["Colours"];
                      if (!colors.contains([
                        colorToJson(Homepage.textColor),
                        colorToJson(Homepage.backingColor),
                        colorToJson(Homepage.backgroundColor)
                      ])) {
                        colors.add([
                          colorToJson(Homepage.textColor),
                          colorToJson(Homepage.backingColor),
                          colorToJson(Homepage.backgroundColor)
                        ]);
                        writeJsonToFile(json, "userContent");
                        updateGlobals();
                      }
                    });
                  },
                  child: const Text("Save settings"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class ScreenTop extends StatelessWidget {
  final String? pagechoice;
  static Color textColor = Homepage.textColor;
  static Color backingColor = Homepage.backingColor;
  static Color backgroundColor = Homepage.backgroundColor;
  const ScreenTop({Key? key, this.pagechoice}) : super(key: key);
  static const String _title = "Frankenstein's - a D&D 5e character builder";

  @override
  Widget build(BuildContext context) {
    updateGlobals();
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Homepage.textColor,
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
              tooltip: "Return to the previous page",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
                icon: const Icon(Icons.settings),
                tooltip: "Settings??",
                onPressed: () {}),
          ],
        ),
        //pick relevent call
        body: PAGELINKER[pagechoice],
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  @override
  MainMenupage createState() => MainMenupage();
}

class MainMenupage extends State<MainMenu> {
  //const MainMenupage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Homepage.backgroundColor,
        floatingActionButton: FloatingActionButton(
          tooltip: "Help and guidance",
          foregroundColor: Homepage.textColor,
          backgroundColor: Homepage.backingColor,
          onPressed: () {
            _showInfoAndHelp(context);
          },
          child: const Icon(
            Icons.info,
          ),
        ),
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
                      "Main Menu",
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
                          builder: (context) => const ScreenTop(
                              pagechoice: "Create a Character")),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    "Create a \ncharacter",
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
                          builder: (context) => const ScreenTop(
                              pagechoice: "Search for Content")),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    "Search for\ncontent",
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
                              const ScreenTop(pagechoice: "My Characters")),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    "My \ncharacters",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Homepage.textColor),
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
                      dialogTitle:
                          "Navigate to and select a Json file to download the contents from, this content can then be used in your characters",
                      type: FileType.custom,
                      allowedExtensions: ["json"],
                    );
                    if (result != null) {
                      final file = File(
                          result.files.single.path ?? "Never going to happen");
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

                      final List<dynamic> proficiencies =
                          jsonData["Proficiencies"];
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
                    "Download\n Content",
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
                        color: Homepage.textColor),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void _showInfoAndHelp(BuildContext context) {
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
              title: const Text("Help and information",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              content: SingleChildScrollView(
                  child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    const Text(
                      "App overview",
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
                      "Report a bug or ask for help:",
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
                  ])),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Json format incorrect, reformat and try again!",
            style: TextStyle(
                color: Colors.red, fontSize: 45, fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
