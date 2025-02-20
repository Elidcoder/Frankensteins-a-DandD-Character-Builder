// External Imports
import "package:flutter/material.dart";

// Project Imports
import "../../main.dart" show InitialTop;
import "../../file_manager.dart" show saveChanges;
import "package:frankenstein/content_classes/all_content_classes.dart" show Spell, SPELLLIST;

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
        backgroundColor: InitialTop.colourScheme.backgroundColour,
        appBar: AppBar(
          foregroundColor: InitialTop.colourScheme.textColour,
          backgroundColor: InitialTop.colourScheme.backingColour,
          title: Center(
            child: Text(
              textAlign: TextAlign.center,
              "Create a Spell",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: InitialTop.colourScheme.textColour),
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
                              style: TextStyle(color: InitialTop.colourScheme.textColour),
                              decoration: InputDecoration(
                                  hintText: "Spell name here e.g. My Spell",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: InitialTop.colourScheme.textColour),
                                  filled: true,
                                  fillColor: (name.replaceAll(" ", "") != "")
                                      ? InitialTop.colourScheme.backingColour
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
                                          ? InitialTop.colourScheme.backingColour
                                          : Colors.red)),
                              DropdownButton<String>(
                                  value: spellSchool,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: InitialTop.colourScheme.backingColour),
                                  elevation: 16,
                                  style: TextStyle(
                                      color: InitialTop.colourScheme.textColour,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                  underline: Container(
                                    height: 2,
                                    color: InitialTop.colourScheme.backingColour,
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
                                            color: InitialTop.colourScheme.backingColour,
                                          ),
                                          width: 100,
                                          child: FittedBox(
                                              child: Text(value,
                                                  style: TextStyle(
                                                      color: InitialTop.colourScheme.textColour)))),
                                    );
                                  }).toList(),
                                  dropdownColor: InitialTop.colourScheme.backingColour)
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
                          style: TextStyle(color: InitialTop.colourScheme.textColour),
                          decoration: InputDecoration(
                              hintText:
                                  "Spell effect here e.g. A Magic shield appears, increasing your AC by 3 for the next minute",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: InitialTop.colourScheme.textColour),
                              filled: true,
                              fillColor: InitialTop.colourScheme.backingColour,
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
                                            ? InitialTop.colourScheme.backingColour
                                            : Colors.red)),
                                DropdownButton<String>(
                                    value: (level == null) ? null : "$level",
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: InitialTop.colourScheme.backingColour),
                                    elevation: 16,
                                    style: TextStyle(
                                        color: InitialTop.colourScheme.backingColour,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20),
                                    underline: Container(
                                      height: 2,
                                      color: InitialTop.colourScheme.backingColour,
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
                                              color: InitialTop.colourScheme.backingColour,
                                            ),
                                            width: 40,
                                            height: 27,
                                            child: FittedBox(
                                                child: Text(value,
                                                    style: TextStyle(
                                                        color: InitialTop.colourScheme.textColour)))),
                                      );
                                    }).toList(),
                                    dropdownColor: InitialTop.colourScheme.backingColour),
                              ]),
                            ),
                            Expanded(
                                child: CheckboxListTile(
                                    title: Text(" Somatic Component",
                                        style: TextStyle(
                                            color: InitialTop.colourScheme.backingColour)),
                                    value: somatic,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        somatic = value;
                                      });
                                    },
                                    activeColor: InitialTop.colourScheme.backingColour,
                                    secondary: Icon(Icons.auto_stories_outlined,
                                        color: InitialTop.colourScheme.backingColour))),
                            Expanded(
                              child: CheckboxListTile(
                                title: Text(" Verbal Component",
                                    style: TextStyle(
                                        color: InitialTop.colourScheme.backingColour)),
                                value: verbal,
                                onChanged: (bool? value) {
                                  setState(() {
                                    verbal = value;
                                  });
                                },
                                activeColor: InitialTop.colourScheme.backingColour,
                                secondary: Icon(Icons.auto_stories_outlined,
                                    color: InitialTop.colourScheme.backingColour),
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
                              style: TextStyle(color: InitialTop.colourScheme.textColour),
                              decoration: InputDecoration(
                                  hintText:
                                      "Materials required e.g. 3 diamonds worth 100gp",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: InitialTop.colourScheme.textColour),
                                  filled: true,
                                  fillColor: InitialTop.colourScheme.backingColour,
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
                              style: TextStyle(color: InitialTop.colourScheme.textColour),
                              decoration: InputDecoration(
                                  hintText:
                                      "Can be cast by: e.g. Wizard, Sorcerer, ...",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: InitialTop.colourScheme.textColour),
                                  filled: true,
                                  fillColor: InitialTop.colourScheme.backingColour,
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
                              style: TextStyle(color: InitialTop.colourScheme.textColour),
                              decoration: InputDecoration(
                                  hintText:
                                      "Casting requirement e.g. 1, Action",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: InitialTop.colourScheme.textColour),
                                  filled: true,
                                  fillColor: InitialTop.colourScheme.backingColour,
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
                              style: TextStyle(color: InitialTop.colourScheme.textColour),
                              decoration: InputDecoration(
                                  hintText: "Duration e.g. 2, Bonus Action",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: InitialTop.colourScheme.textColour),
                                  filled: true,
                                  fillColor: InitialTop.colourScheme.backingColour,
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
                                  style: TextStyle(color: InitialTop.colourScheme.textColour),
                                  decoration: InputDecoration(
                                      hintText: "Range: e.g. Touch / 60",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: InitialTop.colourScheme.textColour),
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
                                          ? InitialTop.colourScheme.backingColour
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
                                  style: TextStyle(color: InitialTop.colourScheme.textColour),
                                  decoration: InputDecoration(
                                      hintText: "Range unit e.g. ft",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: InitialTop.colourScheme.textColour),
                                      filled: true,
                                      fillColor: (rangeUnit.replaceAll(
                                                      " ", "") !=
                                                  "" ||
                                              (["SELF", "TOUCH"].contains(
                                                  (range ?? "").toUpperCase())))
                                          ? InitialTop.colourScheme.backingColour
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
                                      TextStyle(color: InitialTop.colourScheme.backingColour)),
                              value: ritual,
                              onChanged: (bool? value) {
                                setState(() {
                                  ritual = value;
                                });
                              },
                              activeColor: InitialTop.colourScheme.backingColour,
                              secondary: Icon(Icons.auto_stories_outlined,
                                  color: InitialTop.colourScheme.backingColour),
                            )),
                          ],
                        )),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: validateSpell()
                            ? InitialTop.colourScheme.backingColour
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
                              sourceBook: "MADE BY USER",
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
                              material: material)
                            );

                            //write the modified spell list to the Json
                            saveChanges();
                            
                            //display the popup and return home
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InitialTop()),
                              );
                              showCreationDialog(context);
                            });
                          }
                        }
                      },
                      child: Text(
                        textAlign: TextAlign.center,
                        "Save Spell",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: InitialTop.colourScheme.textColour),
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
