import "package:flutter/material.dart";
import 'package:frankenstein/SRD_globals.dart';
import "dart:convert";
import "dart:io";
import 'package:file_picker/file_picker.dart';
import 'package:frankenstein/main.dart';
import "../../file_manager.dart";

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

class MakeASpell extends StatefulWidget {
  const MakeASpell({super.key});

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
        backgroundColor: Homepage.backgroundColor,
        appBar: AppBar(
          foregroundColor: Homepage.textColor,
          backgroundColor: Homepage.backingColor,
          title: Center(
            child: Text(
              textAlign: TextAlign.center,
              "Create a Spell",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: Homepage.textColor),
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
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText: "Spell name here e.g. My Spell",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: (name.replaceAll(" ", "") != "")
                                      ? Homepage.backingColor
                                      : Colors.red,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (groupNameEnteredValue) {
                                setState(() {
                                  name = groupNameEnteredValue;
                                });
                              }),
                        ),

                        SizedBox(
                            width: 170,
                            height: 70,
                            child: Column(children: [
                              Text("Select spell school:",
                                  style: TextStyle(
                                      color: (spellSchool != null)
                                          ? Homepage.backingColor
                                          : Colors.red)),
                              DropdownButton<String>(
                                  value: spellSchool,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Homepage.backingColor),
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Homepage.textColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                  underline: Container(
                                    height: 2,
                                    color: Homepage.backingColor,
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            color: Homepage.backingColor,
                                          ),
                                          width: 100,
                                          child: FittedBox(
                                              child: Text(value,
                                                  style: TextStyle(
                                                      color: Homepage
                                                          .textColor)))),
                                    );
                                  }).toList(),
                                  dropdownColor: Homepage.backingColor)
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
                          style: TextStyle(color: Homepage.textColor),
                          decoration: InputDecoration(
                              hintText:
                                  "Spell effect here e.g. A Magic shield appears, increasing your AC by 3 for the next minute",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Homepage.textColor),
                              filled: true,
                              fillColor: Homepage.backingColor,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)))),
                          onChanged: (effectEnteredValue) {
                            setState(() {
                              effect = effectEnteredValue;
                            });
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
                                Text("Select spell level:",
                                    style: TextStyle(
                                        color: (level != null)
                                            ? Homepage.backingColor
                                            : Colors.red)),
                                DropdownButton<String>(
                                    value: (level == null) ? null : "$level",
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Homepage.backingColor),
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Homepage.backingColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20),
                                    underline: Container(
                                      height: 2,
                                      color: Homepage.backingColor,
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
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              color: Homepage.backingColor,
                                            ),
                                            width: 40,
                                            height: 27,
                                            child: FittedBox(
                                                child: Text(value,
                                                    style: TextStyle(
                                                        color: Homepage
                                                            .textColor)))),
                                      );
                                    }).toList(),
                                    dropdownColor: Homepage.backingColor),
                              ]),
                            ),
                            Expanded(
                                child: CheckboxListTile(
                                    title: Text(" Somatic Component",
                                        style: TextStyle(
                                            color: Homepage.backingColor)),
                                    value: somatic,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        somatic = value;
                                      });
                                    },
                                    activeColor: Homepage.backingColor,
                                    secondary: Icon(Icons.auto_stories_outlined,
                                        color: Homepage.backingColor))),
                            Expanded(
                              child: CheckboxListTile(
                                title: Text(" Verbal Component",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: verbal,
                                onChanged: (bool? value) {
                                  setState(() {
                                    verbal = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.auto_stories_outlined,
                                    color: Homepage.backingColor),
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
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText:
                                      "Materials required e.g. 3 diamonds worth 100gp",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (materialsEnteredValue) {
                                setState(() {
                                  material = materialsEnteredValue;
                                });
                              }),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 305,
                          height: 70,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText:
                                      "Can be cast by: e.g. Wizard, Sorcerer, ...",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (castableByEnteredValue) {
                                setState(() {
                                  availableTo = castableByEnteredValue;
                                });
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
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText:
                                      "Casting requirement e.g. 1, Action",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (castingEnteredValue) {
                                setState(() {
                                  casting = castingEnteredValue;
                                });
                              }),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 305,
                          height: 70,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText: "Duration e.g. 2, Bonus Action",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (durationEnteredValue) {
                                setState(() {
                                  duration = durationEnteredValue;
                                });
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
                                  style: TextStyle(color: Homepage.textColor),
                                  decoration: InputDecoration(
                                      hintText: "Range: e.g. Touch / 60",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Homepage.textColor),
                                      filled: true,
                                      fillColor: (range != null &&
                                              ((double.tryParse(range ?? "") !=
                                                      null) ||
                                                  (["SELF", "TOUCH"].contains(
                                                          range!
                                                              .toUpperCase()) ||
                                                      (double.tryParse(
                                                              range ?? "") !=
                                                          null))))
                                          ? Homepage.backingColor
                                          : Colors.red,
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)))),
                                  onChanged: (rangeEnteredValue) {
                                    setState(() {
                                      range = rangeEnteredValue;
                                    });
                                  }),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 192.5,
                              height: 70,
                              child: TextField(
                                  cursorColor: Colors.blue,
                                  style: TextStyle(color: Homepage.textColor),
                                  decoration: InputDecoration(
                                      hintText: "Range unit e.g. ft",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Homepage.textColor),
                                      filled: true,
                                      fillColor: (rangeUnit.replaceAll(
                                                      " ", "") !=
                                                  "" ||
                                              (["SELF", "TOUCH"].contains(
                                                  (range ?? "").toUpperCase())))
                                          ? Homepage.backingColor
                                          : Colors.red,
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)))),
                                  onChanged: (rangeUnitEnteredValue) {
                                    setState(() {
                                      rangeUnit = rangeUnitEnteredValue;
                                    });
                                  }),
                            ),
                            Expanded(
                                child: CheckboxListTile(
                              title: Text(" Ritual ",
                                  style:
                                      TextStyle(color: Homepage.backingColor)),
                              value: ritual,
                              onChanged: (bool? value) {
                                setState(() {
                                  ritual = value;
                                });
                              },
                              activeColor: Homepage.backingColor,
                              secondary: Icon(Icons.auto_stories_outlined,
                                  color: Homepage.backingColor),
                            )),
                          ],
                        )),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: validateSpell()
                            ? Homepage.backingColor
                            : Colors.grey,
                        padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        side: const BorderSide(
                            width: 5, color: Color.fromARGB(255, 7, 26, 239)),
                      ),
                      onPressed: () {
                        //check the spell is in an accepted form
                        if (validateSpell()) {
                          //check it doesn't have the same name as another spell
                          if (SPELLLIST
                              .where((element) => element.name == name)
                              .toList()
                              .isEmpty) {

                            //add the new spell to the list of spells
                            SPELLLIST.add(Spell(
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

                            //write the modified spell list to the Json
                            saveChanges();
                            
                            //display the popup and return home
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()),
                              );
                              showCreationDialog(context);
                            });

                            //update globals to update the spell list with its new member
                            updateGlobals();
                          }
                        }
                      },
                      child: Text(
                        textAlign: TextAlign.center,
                        'Save Spell',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Homepage.textColor),
                      ),
                    ),
                    //const SizedBox(height: 100),
                  ])
            ]));
  }

  void showCreationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Spell created correctly!',
            style: TextStyle(
                color: Colors.green,
                fontSize: 50,
                fontWeight: FontWeight.w800)),
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
