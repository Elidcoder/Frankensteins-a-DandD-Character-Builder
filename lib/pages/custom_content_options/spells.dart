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

class MakeASpell extends StatefulWidget {
  @override
  MainMakeASpell createState() => MainMakeASpell();
}

class MainMakeASpell extends State<MakeASpell> {
  //MainMakeASpell({Key? key}) : super(key: key);
  String name = "";
  String effect = "";

  String? spellSchool;
  int? level;
  bool? verbal = false;
  bool? somatic = false;
  String? material;
  String? range;
  String rangeUnit = "";
  bool? ritual = false;
  String casting = "";
  String duration = "";
  List<dynamic> timings = [];
  String availableTo = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              textAlign: TextAlign.center,
              "Create a Spell",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        ),
        body: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //TextField(),

                        SizedBox(
                          width: 450,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Spell name here",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (groupNameEnteredValue) {
                                name = groupNameEnteredValue;
                              }),
                        ),

                        SizedBox(
                            width: 170,
                            height: 70,
                            child: Column(children: [
                              const Text("Select spell school:"),
                              DropdownButton<String>(
                                value: spellSchool,
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: Color.fromARGB(255, 7, 26, 239)),
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20),
                                underline: Container(
                                  height: 2,
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    spellSchool = value!;
                                  });
                                },
                                items: [
                                  "Abjuration",
                                  "Conjuration",
                                  "Divination",
                                  "Enchantment",
                                  "Evocation",
                                  "Illusion",
                                  "Necromancy",
                                  "Transmutation"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: SizedBox(
                                        width: 100,
                                        child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(value))),
                                  );
                                }).toList(),
                              )
                            ])),
                      ],
                    ),
                    SizedBox(
                      width: 620,
                      height: 70,
                      child: TextField(
                          maxLines: 4,
                          minLines: 4,
                          cursorColor: Colors.blue,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: "Spell effect here:",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 212, 208, 224)),
                              filled: true,
                              fillColor: Color.fromARGB(211, 42, 63, 226),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)))),
                          onChanged: (effectEnteredValue) {
                            effect = effectEnteredValue;
                          }),
                    ),
                    SizedBox(
                        width: 620,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 70,
                              child: Column(children: [
                                const Text("Select the spell level"),
                                DropdownButton<String>(
                                  value: (level == null) ? null : "$level",
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Color.fromARGB(255, 7, 26, 239)),
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                  underline: Container(
                                    height: 2,
                                    color:
                                        const Color.fromARGB(255, 7, 26, 239),
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      level = int.parse(value!);
                                    });
                                  },
                                  items: [
                                    "0",
                                    "1",
                                    "2",
                                    "3",
                                    "4",
                                    "5",
                                    "6",
                                    "7",
                                    "8",
                                    "9"
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: SizedBox(
                                          width: 100,
                                          child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(value))),
                                    );
                                  }).toList(),
                                ),
                              ]),
                            ),
                            Expanded(
                                child: CheckboxListTile(
                              title: const Text(' Somatic Component'),
                              value: somatic,
                              onChanged: (bool? value) {
                                setState(() {
                                  somatic = value;
                                });
                              },
                              secondary: const Icon(Icons.waving_hand),
                            )),
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text(' Verbal Component'),
                                value: verbal,
                                onChanged: (bool? value) {
                                  setState(() {
                                    verbal = value;
                                  });
                                },
                                secondary: const Icon(
                                  Icons.record_voice_over,
                                ),
                              ),
                            )
                          ],
                        )),
                    Row(
                      children: [
                        SizedBox(
                          width: 305,
                          height: 70,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Materials required:",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (materialsEnteredValue) {
                                material = materialsEnteredValue;
                              }),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 305,
                          height: 70,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Can be cast by:",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (castableByEnteredValue) {
                                availableTo = castableByEnteredValue;
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 305,
                          height: 70,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Casting requirement:",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (castingEnteredValue) {
                                casting = castingEnteredValue;
                              }),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 305,
                          height: 70,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Duration:",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (durationEnteredValue) {
                                duration = durationEnteredValue;
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                        width: 620,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 192.5,
                              height: 70,
                              child: TextField(
                                  cursorColor: Colors.blue,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      hintText: "Range:",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(
                                              255, 212, 208, 224)),
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(211, 42, 63, 226),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)))),
                                  onChanged: (rangeEnteredValue) {
                                    range = rangeEnteredValue;
                                  }),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 192.5,
                              height: 70,
                              child: TextField(
                                  cursorColor: Colors.blue,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      hintText: "Range unit:",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(
                                              255, 212, 208, 224)),
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(211, 42, 63, 226),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)))),
                                  onChanged: (rangeUnitEnteredValue) {
                                    rangeUnit = rangeUnitEnteredValue;
                                  }),
                            ),
                            Expanded(
                                child: CheckboxListTile(
                              title: const Text(' Ritual '),
                              value: ritual,
                              onChanged: (bool? value) {
                                setState(() {
                                  ritual = value;
                                });
                              },
                              secondary: const Icon(
                                Icons.auto_stories_outlined,
                              ),
                            )),
                          ],
                        )),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        side: const BorderSide(
                            width: 5, color: Color.fromARGB(255, 7, 26, 239)),
                      ),
                      onPressed: () async {
                        //check the spell is in an accepted form
                        if (validateSpell()) {
                          //check it doesn't have the same name as another spell
                          if (SPELLLIST
                              .where((element) => element.name == name)
                              .toList()
                              .isEmpty) {
                            updateGlobals();
                            final Map<String, dynamic> jsonData =
                                jsonDecode(jsonString ?? "");
                            //at some point actually check for dupes
                            final List<dynamic> characters = jsonData["Spells"];
                            characters.add(Spell(
                                name: name,
                                range:
                                    "$range ${rangeUnit.replaceAll(" ", "")}",
                                ritual: ritual,
                                spellSchool:
                                    spellSchool ?? "This should never run",
                                effect: effect,
                                availableTo: availableTo
                                    .replaceAll(", ", ",")
                                    .replaceAll(" ,", ",")
                                    .split(","),
                                level: level ?? 0,
                                timings: [
                                  ...casting.split(","),
                                  ...duration.split(",")
                                ],
                                somatic: somatic,
                                verbal: verbal,
                                material: material));
                            writeJsonToFile(jsonData, "userContent");
                            updateGlobals();
                          }
                        }
                      },
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Save Spell',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    //const SizedBox(height: 100),
                  ])
            ]));
  }

  bool validateSpell() {
    if (name.replaceAll(" ", "") != "" &&
        level != null &&
        spellSchool != null &&
        range != null &&
        (["SELF", "TOUCH"].contains(range!.toUpperCase()) ||
            (double.tryParse(range ?? "") != null))) {
      return true;
    }

    return false;
  }
}
/*ElevatedButton(
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
            child: Text('Select JSON file'),
          ),*/
