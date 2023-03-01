import 'package:flutter/material.dart';
//import 'package:frankenstein/character_creation_globals.dart';
import 'package:frankenstein/SRD_globals.dart';
import "dart:collection";
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:frankenstein/character_globals.dart';
import 'package:frankenstein/PDFdocs/pdf_final_display.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';

int abilityScoreCost(int x) {
  if (x > 12) {
    return 2;
  }
  return 1;
}

//would love to pass in a character class here
//Many parts remain unfinished but should be completed as their relevent tabs are
//value, ACLIST, SPEEDMAP, INT, WIS, STR, DEX,CAR,CON,CURRENCY
Widget? leveGainParser(
    List<dynamic> x,
    List<List<dynamic>> ACLIST,
    Map<String, List<String>> SPEEDMAP,
    AbilityScore INT,
    AbilityScore WIS,
    AbilityScore STR,
    AbilityScore DEX,
    AbilityScore CAR,
    AbilityScore CON,
    Map<String, int> CURRENCY,
    Class SELECTEDCLASS,
    List<String> FEATURESANDTRAITS) {
  //Levelup(class?)
  if (x[0] == "Level") {
    // ("Level", "numb")
    return Text(
      "${SELECTEDCLASS.name} Level ${x[1]} choice(s):",
      style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Color.fromARGB(255, 0, 168, 252)),
    );
  } else if (x[0] == "Nothing") {
    // ("Nothing", "numb")
    return Text(
      "No choices needed for ${SELECTEDCLASS.name} level ${x[1]}",
      style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Color.fromARGB(255, 0, 168, 252)),
    );
  } else if (x[0] == "Bonus") {
    // ("Bonus","String description")
    FEATURESANDTRAITS.add(x[1]);
  } else if (x[0] == "AC") {
    // ("AC","intelligence + 2", "RQUIREMENT")
    ACLIST.add([x[1], x[2]]);
  } /* else if (x[0] == "ACModifier") {
    //("ACModifier", "2/intelligence", "armour"(requirement))
    SPEEDLIST.append([x[1], x[2]]);
  }*/
  else if (x[0] == "Speed") {
    //note base speed is given by race
    //("speed", (w/s/c/f/h), numb/expression")
    SPEEDMAP[x[1]]?.add(x[2]);
  } else if (x[0] == "AttributeBoost") {
    if (x[1] == "Intelligence") {
      INT.value += int.parse(x[2]);
    } else if (x[1] == "Strength") {
      STR.value += int.parse(x[2]);
    } else if (x[1] == "Constitution") {
      CON.value += int.parse(x[2]);
    } else if (x[1] == "Dexterity") {
      DEX.value += int.parse(x[2]);
    } else if (x[1] == "Wisdom") {
      WIS.value += int.parse(x[2]);
    } else if (x[1] == "charisma") {
      CAR.value += int.parse(x[2]);
    }
    //do this later
  } /*else if (x[0] == "Equipment") {
    //note base speed is given by race
    //("speed", "10", "(w/s/c/f)")
    SPEEDLIST.append([x[1], x[2]]);
  }*/
  else if (x[0] == "Money") {
    //("Money", "Copper Pieces", "10")
    CURRENCY[x[1]] = CURRENCY[x[1]]! + int.parse(x[2]);
  } //deal with these later
  /*else if (x[0] == "Spell") {
    ///
  } else if (x[0] == "ASI") {
    ("ASI")
      ASINUMB ++;
  } else if (x[0] == "Feat") {
    ("Feat","Any/ featname")
    if (x[1]== "Any"){
      FEATNUMB ++;
    }
    else{
      FEATLIST.add(correct feat)
    }
      
  }*/
  /*else if (x[0] == "Choice") {
    List<Widget> temporaryWidgetList = [];
    //("choice", [option].....)
    /*for (List<dynamic> string in x.sublist(2)) {
      temporaryWidgetList.add(OutlinedButton(
        child: Text(string[1]),
        onPressed: () {
          // When the button is pressed, add the string to the outputStrings list
          setState(() => outputStrings.add(string));
        },
      ));
    }*/
    return Row(children: temporaryWidgetList);
  }*/
}

//fix this later
bool isAllowedContent(dynamic x) {
  return true;
}

//Map<String, String> characterTypeReturner = {0.0:"Martial",1.0:"Full Caster", 0.5: "Half Caster", 0.3:"Third caster"};
Spell listgetter(String spellname) {
  //huge issue with adding content WITH DUPLICATE NAME AND (TYPE)
  for (int x = 0; x < SPELLLIST.length; x++) {
    if (SPELLLIST[x].name == spellname) {
      return SPELLLIST[x];
    }
  }
  //ADD SOMETHING FOR FAILED COMPARISONS
  ///fix really  really really
  return SPELLLIST[0];
} //}

class CreateACharacter extends StatefulWidget {
  @override
  MainCreateCharacter createState() => MainCreateCharacter();
}

class SpellSelections extends StatefulWidget {
  //final Class? classSelected;
  List<dynamic> thisDescription;
  List<Spell> allSpells;
  SpellSelections(this.allSpells, this.thisDescription);
  @override
  _SpellSelectionsState createState() =>
      //_SpellSelectionsState(allSpells, classSelected: classSelected);
      _SpellSelectionsState(allSpells, thisDescription);
}

class _SpellSelectionsState extends State<SpellSelections> {
  // Declare the input list of strings or lists of strings
  //final Class? classSelected;
  List<Spell> allSpellsSelected;
  //CURENTLY: [name, [spelllist], numb, formula]
  List<dynamic> thisDescription;
  //_SpellSelectionsState(this.allSpellsSelected, {this.classSelected});
  _SpellSelectionsState(this.allSpellsSelected, this.thisDescription);

  List<String> spellSchoolsSelected = [
    "Abjuration",
    "Conjuration",
    "Divination",
    "Enchantment",
    "Evocation",
    "Illusion",
    "Necromancy",
    "Transmutation"
  ];
  List<int> spellLevelsSelected = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<String> castingTimesSelected = [
    "Action",
    "Reaction",
    "Bonus Action",
    "Other",
    "Ritual"
  ];
  bool ritualsSelected = true;
  //filter if class available
  static List<Spell> allAvailableSpells = [
    for (var x in SPELLLIST
        /*.where((element) => element.availableTo.contains(classSelected))
        .toList()*/
        )
      if (isAllowedContent(x)) x
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 281,
        width: 485,
        child: MaterialApp(
            home: Scaffold(
                body: Column(children: [
          //REPLACE
          Text("${thisDescription[0]} spell choices",
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          //Spell Schools (Abjuration,Conjuration,Divination,Enchantment)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor:
                        (spellSchoolsSelected.contains("Abjuration")
                            ? Colors.blue
                            : Colors.grey)),
                onPressed: () {
                  setState(() {
                    if (spellSchoolsSelected.contains("Abjuration")) {
                      spellSchoolsSelected.remove("Abjuration");
                    } else {
                      spellSchoolsSelected.add("Abjuration");
                    }
                  });
                },
                child: const Text("Abjuration",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700))),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor:
                        (spellSchoolsSelected.contains("Conjuration")
                            ? Colors.blue
                            : Colors.grey)),
                onPressed: () {
                  setState(() {
                    if (spellSchoolsSelected.contains("Conjuration")) {
                      spellSchoolsSelected.remove("Conjuration");
                    } else {
                      spellSchoolsSelected.add("Conjuration");
                    }
                  });
                },
                child: const Text("Conjuration",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700))),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor:
                        (spellSchoolsSelected.contains("Divination")
                            ? Colors.blue
                            : Colors.grey)),
                onPressed: () {
                  setState(() {
                    if (spellSchoolsSelected.contains("Divination")) {
                      spellSchoolsSelected.remove("Divination");
                    } else {
                      spellSchoolsSelected.add("Divination");
                    }
                  });
                },
                child: const Text("Divination",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700))),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor:
                        (spellSchoolsSelected.contains("Enchantment")
                            ? Colors.blue
                            : Colors.grey)),
                onPressed: () {
                  setState(() {
                    if (spellSchoolsSelected.contains("Enchantment")) {
                      spellSchoolsSelected.remove("Enchantment");
                    } else {
                      spellSchoolsSelected.add("Enchantment");
                    }
                  });
                },
                child: const Text("Enchantment",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700))),
          ]),
          //Spell Schools (Evocation,Illusion,Necromancy,Transmutation)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: (spellSchoolsSelected.contains("Evocation")
                        ? Colors.blue
                        : Colors.grey)),
                onPressed: () {
                  setState(() {
                    if (spellSchoolsSelected.contains("Evocation")) {
                      spellSchoolsSelected.remove("Evocation");
                    } else {
                      spellSchoolsSelected.add("Evocation");
                    }
                  });
                },
                child: const Text("Evocation",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700))),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: (spellSchoolsSelected.contains("Illusion")
                        ? Colors.blue
                        : Colors.grey)),
                onPressed: () {
                  setState(() {
                    if (spellSchoolsSelected.contains("Illusion")) {
                      spellSchoolsSelected.remove("Illusion");
                    } else {
                      spellSchoolsSelected.add("Illusion");
                    }
                  });
                },
                child: const Text("Illusion",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700))),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor:
                        (spellSchoolsSelected.contains("Necromancy")
                            ? Colors.blue
                            : Colors.grey)),
                onPressed: () {
                  setState(() {
                    if (spellSchoolsSelected.contains("Necromancy")) {
                      spellSchoolsSelected.remove("Necromancy");
                    } else {
                      spellSchoolsSelected.add("Necromancy");
                    }
                  });
                },
                child: const Text("Necromancy",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700))),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor:
                        (spellSchoolsSelected.contains("Transmutation")
                            ? Colors.blue
                            : Colors.grey)),
                onPressed: () {
                  setState(() {
                    if (spellSchoolsSelected.contains("Transmutation")) {
                      spellSchoolsSelected.remove("Transmutation");
                    } else {
                      spellSchoolsSelected.add("Transmutation");
                    }
                  });
                },
                child: const Text("Transmutation",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)))
          ]),
          //Levels 0-9 and main space
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //levels 0-4
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(0)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(0)) {
                          spellLevelsSelected.remove(0);
                        } else {
                          spellLevelsSelected.add(0);
                        }
                      });
                    },
                    child: const Text("0",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(1)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(1)) {
                          spellLevelsSelected.remove(1);
                        } else {
                          spellLevelsSelected.add(1);
                        }
                      });
                    },
                    child: const Text("1",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(2)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(2)) {
                          spellLevelsSelected.remove(2);
                        } else {
                          spellLevelsSelected.add(2);
                        }
                      });
                    },
                    child: const Text("2",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(3)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(3)) {
                          spellLevelsSelected.remove(3);
                        } else {
                          spellLevelsSelected.add(3);
                        }
                      });
                    },
                    child: const Text("3",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(4)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(4)) {
                          spellLevelsSelected.remove(4);
                        } else {
                          spellLevelsSelected.add(4);
                        }
                      });
                    },
                    child: const Text("4",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)))
              ],
            ),
            //main space
            Container(
              height: 140,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: allAvailableSpells.length,
                itemBuilder: (context, index) {
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (thisDescription[1]
                                .contains(allAvailableSpells[index])
                            ? Colors.green
                            : (allSpellsSelected
                                    .contains(allAvailableSpells[index])
                                ? Colors.grey
                                : Colors.white))),
                    onPressed: () {
                      setState(
                        () {
                          if (thisDescription[1]
                              .contains(allAvailableSpells[index])) {
                            thisDescription[1]
                                .remove(allAvailableSpells[index]);
                            allSpellsSelected.remove(allAvailableSpells[index]);
                            thisDescription[2]++;
                          } else {
                            if (thisDescription[2] > 0) {
                              if (!allSpellsSelected
                                  .contains(allAvailableSpells[index])) {
                                thisDescription[1]
                                    .add(allAvailableSpells[index]);
                                allSpellsSelected
                                    .add(allAvailableSpells[index]);
                                thisDescription[2]--;
                              }
                            }
                          }
                        },
                      );
                      // Code to handle button press
                    },
                    child: Text(allAvailableSpells[index].name),
                  );
                },
              ),
            ),
            //levels 5-9
            Column(
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(5)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(5)) {
                          spellLevelsSelected.remove(5);
                        } else {
                          spellLevelsSelected.add(5);
                        }
                      });
                    },
                    child: const Text("5",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(6)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(6)) {
                          spellLevelsSelected.remove(6);
                        } else {
                          spellLevelsSelected.add(6);
                        }
                      });
                    },
                    child: const Text("6",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(7)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(7)) {
                          spellLevelsSelected.remove(7);
                        } else {
                          spellLevelsSelected.add(7);
                        }
                      });
                    },
                    child: const Text("7",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(8)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(8)) {
                          spellLevelsSelected.remove(8);
                        } else {
                          spellLevelsSelected.add(8);
                        }
                      });
                    },
                    child: const Text("8",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: (spellLevelsSelected.contains(9)
                            ? Colors.blue
                            : Colors.grey)),
                    onPressed: () {
                      setState(() {
                        if (spellLevelsSelected.contains(9)) {
                          spellLevelsSelected.remove(9);
                        } else {
                          spellLevelsSelected.add(9);
                        }
                      });
                    },
                    child: const Text("9",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)))
              ],
            )
          ]),
          //casting time, rituals and select all/none
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Unselect all
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.lightBlue),
                  onPressed: () {
                    setState(() {
                      ritualsSelected = false;
                      castingTimesSelected.clear();
                      spellSchoolsSelected.clear();
                      spellLevelsSelected.clear();
                    });
                  },
                  child: const Text("Unpick\n    all",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700))),

              //Casting time and rituals
              Column(children: [
//Action, BA and reaction
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor:
                              (castingTimesSelected.contains("Action")
                                  ? Colors.blue
                                  : Colors.grey)),
                      onPressed: () {
                        setState(() {
                          if (castingTimesSelected.contains("Action")) {
                            castingTimesSelected.remove("Action");
                          } else {
                            castingTimesSelected.add("Action");
                          }
                        });
                      },
                      child: const Text("Action",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700))),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor:
                              (castingTimesSelected.contains("Bonus Action")
                                  ? Colors.blue
                                  : Colors.grey)),
                      onPressed: () {
                        setState(() {
                          if (castingTimesSelected.contains("Bonus Action")) {
                            castingTimesSelected.remove("Bonus Action");
                          } else {
                            castingTimesSelected.add("Bonus Action");
                          }
                        });
                      },
                      child: const Text("Bonus Action",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700))),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor:
                              (castingTimesSelected.contains("Reaction")
                                  ? Colors.blue
                                  : Colors.grey)),
                      onPressed: () {
                        setState(() {
                          if (castingTimesSelected.contains("Reaction")) {
                            castingTimesSelected.remove("Reaction");
                          } else {
                            castingTimesSelected.add("Reaction");
                          }
                        });
                      },
                      child: const Text("Reaction",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700))),
                ]),
                //Other options and rituals
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor:
                              (castingTimesSelected.contains("Other")
                                  ? Colors.blue
                                  : Colors.grey)),
                      onPressed: () {
                        setState(() {
                          if (castingTimesSelected.contains("Other")) {
                            castingTimesSelected.remove("Other");
                          } else {
                            castingTimesSelected.add("Other");
                          }
                        });
                      },
                      child: const Text("Other Casting Times",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700))),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor:
                              (ritualsSelected ? Colors.blue : Colors.grey)),
                      onPressed: () {
                        setState(() {
                          ritualsSelected = !ritualsSelected;
                        });
                      },
                      child: const Text("Ritual",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)))
                ])
              ]),

              //Select all
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.lightBlue),
                  onPressed: () {
                    setState(() {
                      ritualsSelected = true;
                      castingTimesSelected = [
                        "Action",
                        "Reaction",
                        "Bonus Action",
                        "Other",
                        "Ritual"
                      ];
                      spellSchoolsSelected = [
                        "Abjuration",
                        "Conjuration",
                        "Divination",
                        "Enchantment",
                        "Evocation",
                        "Illusion",
                        "Necromancy",
                        "Transmutation"
                      ];
                      spellLevelsSelected = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
                    });
                  },
                  child: const Center(
                      child: Text("Select\n   all",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)))),
            ],
          )
        ]))));
  }
}

class ChoiceRow extends StatefulWidget {
  // Declare the input list of strings or lists of strings
  final List<dynamic>? x;

  ChoiceRow({this.x, this.allSelected});
  dynamic selected;
  final List<dynamic>? allSelected;
  @override
  _ChoiceRowState createState() =>
      _ChoiceRowState(x: x, allSelected: allSelected);
}

class _ChoiceRowState extends State<ChoiceRow> {
  // Declare the input list of strings or lists of strings
  final List<dynamic>? x;
  dynamic selected;
  final List<dynamic>? allSelected;

  _ChoiceRowState({this.x, this.allSelected});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: SizedBox(
      height: 100,
      child: Column(children: [
        Text(x![0],
            style: const TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w700)),
        SizedBox(
            height: 50,
            child: Center(
                child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                // Call the buildRows method to create a row of buttons for each element in the x list
                ...buildRows(context, x?.sublist(1)),
              ],
            )))
      ]),
    )
            //),
            ));
  }

  List<Widget> buildRows(
      BuildContext context, List<dynamic>? inputStringLists) {
    return [
      for (var input in inputStringLists!)
        //check it isn't a choice
        if (!["Choice"].contains(input![0]))
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: (selected == input)
                    ? const Color.fromARGB(255, 73, 244, 113)
                    : null, //<-- SEE HERE
              ),
              onPressed: () {
                setState(() {
                  if (selected != null) {
                    //unparse selected
                    allSelected?.remove(input);
                    if (selected == input) {
                      selected = null;
                    } else {
                      selected = input;
                      allSelected?.add(input);
                    }
                  } else {
                    selected = input;
                    allSelected?.add(input);
                  }
                });
              },
              child: Text(input[1]))
        else
          Container(
            height: 40,
            decoration: BoxDecoration(
              //color: Colors.pink,
              border: Border.all(
                color: const Color.fromARGB(255, 7, 26, 239),
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(children: [
              Text(input[1],
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              Row(
                children: [
                  ...buildRows(context, input.sublist(2)),
                ],
              )
            ]),
          )
    ];
  }
}

//null op here to locate if called by editor (to edit char so will contain info) or otherwise
class MainCreateCharacter extends State<CreateACharacter>
    with AutomaticKeepAliveClientMixin {
  //random stsuff
  @override
  bool get wantKeepAlive => true;
  List<String> featuresAndTraits = [];
  List<String> toolProficiencies = [];
  bool inspired = false;
  Map<String, List<String>> speedBonusMap = {
    "Hover": [],
    "Flying": [],
    "Walking": [],
    "Swimming": [],
    "Climbing": []
  };
  Map<String, int> currencyStored = {
    "Copper Pieces": 0,
    "Silver Pieces": 0,
    "Electrum Pieces": 0,
    "Gold Pieces": 100,
    "Platinum Pieces": 0
  };
  // ignore: non_constant_identifier_names
  List<List<dynamic>> ACList = [
    ["10 + dexterity"]
  ];
  //Spell spellExample = list.first;
  String? levellingMethod;
  //Basics variables initialised
  String? characterLevel = "1";
  String characterName = "";
  String playerName = "";
  String characterGender = "";
  int characterExperience = 0;
  //bools representing the states of the checkboxes (basics)
  bool? featsAllowed = true;
  bool? averageHitPoints = false;
  bool? multiclassing = true;
  bool? milestoneLevelling = false;
  bool? useCustomContent = false;
  bool? optionalClassFeatures = false;
  bool? criticalRoleContent = false;
  bool? encumberanceRules = false;
  bool? includeCoinsForWeight = false;
  bool? unearthedArcanaContent = false;
  bool? firearmsUsable = false;
  bool? extraFeatAtLevel1 = false;

  Subrace? subraceExample;
  //Race variables initialised
  Race initialRace = RACELIST.first;
  List<int> abilityScoreIncreases = RACELIST.first.raceScoreIncrease;
  static List<List<bool>>? optionalOnesStates = [
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false]
  ];
  static List<List<bool>>? optionalTwosStates = [
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false]
  ];
  List<Widget> mystery1slist = [];
  List<Widget> mystery2slist = [];

  //Class variables initialised
  //Class? classSelectedAtLevel1;
  List<bool> classSkillChoices = [];
  List<String>? savingThrowProficiencies;
  List<String> skillProficiencies = [];
  int maxHealth = 0;

  List<String> classList = [];

  List<Widget> widgetsInPlay = []; //added to each time a class is selected
  List<int> levelsPerClass = List.filled(CLASSLIST.length, 0);
  Map<String, List<dynamic>> selections = {};
  List<dynamic> allSelected = [];
  Map<String, String> classSubclassMapper = {};

  //Background variables initialised
  Background currentBackground = BACKGROUNDLIST.first;
  String backgroundPersonalityTrait =
      BACKGROUNDLIST.first.personalityTrait.first;
  String backgroundIdeal = BACKGROUNDLIST.first.ideal.first;
  String backgroundBond = BACKGROUNDLIST.first.bond.first;
  String backgroundFlaw = BACKGROUNDLIST.first.flaw.first;
  List<String> languagesKnown = ["Common"];
  //creates an array where it auto selects the first (n) possible skills initially
  List<bool> backgroundSkillChoices =
      List.filled(BACKGROUNDLIST.first.numberOfSkillChoices ?? 0, true) +
          List.filled(
              (BACKGROUNDLIST.first.optionalSkillProficiencies?.length ?? 0) -
                  (BACKGROUNDLIST.first.numberOfSkillChoices ?? 0),
              false);

  Queue<int>? selectedSkillsQ = Queue<int>.from(
      Iterable.generate(BACKGROUNDLIST.first.numberOfSkillChoices ?? 0));
  //Ability score variables initialised
  AbilityScore strength = AbilityScore(name: "Strength", value: 8);
  AbilityScore dexterity = AbilityScore(name: "Dexterity", value: 8);
  AbilityScore constitution = AbilityScore(name: "Constitution", value: 8);
  AbilityScore intelligence = AbilityScore(name: "Intelligence", value: 8);
  AbilityScore wisdom = AbilityScore(name: "Wisdom", value: 8);
  AbilityScore charisma = AbilityScore(name: "Charisma", value: 8);
  int pointsRemaining = 27;
  //STR/DEX/CON/INT/WIS/CHAR
  //ASIS AND FEAT variables
  List<int> ASIBonuses = [0, 0, 0, 0, 0, 0];
  List<List<dynamic>> featsSelected = [];
  bool ASIRemaining = false;
  int numberOfRemainingFeatOrASIs = 1;
  bool halfFeats = true;
  bool fullFeats = true;
  //Spell variables
  List<Spell> allSpellsSelected = [];
  List<List<dynamic>> allSpellsSelectedAsListsOfThings = [];
  //Equipment variables
  List<String> armourList = [];
  List<String> weaponList = [];
  List<String> itemList = [];
  String? coinTypeSelected = "Gold Pieces";
  List<dynamic>? equipmentSelectedFromChoices;
  //{thing:numb,...}
  Map<String, int> stackableEquipmentSelected = {};
  List<dynamic> unstackableEquipmentSelected = [];
  //BackgroundVariables
  String characterAge = "";
  String characterHeight = "";
  String characterWeight = "";
  String characterEyes = "";
  String characterSkin = "";
  String characterHair = "";
  //finishing up variables
  String? group;
  @override
  void initState() {
    super.initState();
    updateGlobals();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    super.build(context);
    final mystery1slist = [
      const SizedBox(
          height: 30,
          child: Text("Choose which score(s) to increase by 1",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w800))),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![0][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![0].length;
                  buttonIndex++) {
                if (optionalOnesStates![0][buttonIndex]) {
                  optionalOnesStates![0][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![0][index] = !optionalOnesStates![0][index];
          });
        },
        isSelected: optionalOnesStates![0],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![1][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![1].length;
                  buttonIndex++) {
                if (optionalOnesStates![1][buttonIndex]) {
                  optionalOnesStates![1][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![1][index] = !optionalOnesStates![1][index];
          });
        },
        isSelected: optionalOnesStates![1],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![2][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![2].length;
                  buttonIndex++) {
                if (optionalOnesStates![2][buttonIndex]) {
                  optionalOnesStates![2][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![2][index] = !optionalOnesStates![2][index];
          });
        },
        isSelected: optionalOnesStates![2],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![3][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![3].length;
                  buttonIndex++) {
                if (optionalOnesStates![3][buttonIndex]) {
                  optionalOnesStates![3][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![3][index] = !optionalOnesStates![3][index];
          });
        },
        isSelected: optionalOnesStates![3],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![4][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![4].length;
                  buttonIndex++) {
                if (optionalOnesStates![4][buttonIndex]) {
                  optionalOnesStates![4][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![4][index] = !optionalOnesStates![4][index];
          });
        },
        isSelected: optionalOnesStates![4],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
    ];
    final mystery2slist = [
      const SizedBox(
          height: 30,
          child: Text("Choose which score(s) to increase by 2",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w800))),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![0][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![0].length;
                  buttonIndex++) {
                if (optionalTwosStates![0][buttonIndex]) {
                  optionalTwosStates![0][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![0][index] = !optionalTwosStates![0][index];
          });
        },
        isSelected: optionalTwosStates![0],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![1][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![1].length;
                  buttonIndex++) {
                if (optionalTwosStates![1][buttonIndex]) {
                  optionalTwosStates![1][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![1][index] = !optionalTwosStates![1][index];
          });
        },
        isSelected: optionalTwosStates![1],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![2][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![2].length;
                  buttonIndex++) {
                if (optionalTwosStates![2][buttonIndex]) {
                  optionalTwosStates![2][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![2][index] = !optionalTwosStates![2][index];
          });
        },
        isSelected: optionalTwosStates![2],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![3][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![3].length;
                  buttonIndex++) {
                if (optionalTwosStates![3][buttonIndex]) {
                  optionalTwosStates![3][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![3][index] = !optionalTwosStates![3][index];
          });
        },
        isSelected: optionalTwosStates![3],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![4][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![4].length;
                  buttonIndex++) {
                if (optionalTwosStates![4][buttonIndex]) {
                  optionalTwosStates![4][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![4][index] = !optionalTwosStates![4][index];
          });
        },
        isSelected: optionalTwosStates![4],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      )
    ];

    return DefaultTabController(
      length: 11,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              textAlign: TextAlign.center,
              'Create a character',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("Basics")),
              Tab(child: Text("Race")),
              Tab(child: Text("Class")),
              Tab(child: Text("Backround")),
              Tab(child: Text("Ability scores")),
              Tab(child: Text("ASI's and Feats")),
              Tab(child: Text("Spells")),
              Tab(child: Text("Equipment")),
              Tab(child: Text("Backstory")),
              Tab(child: Text("Boons and magic items")),
              Tab(child: Text("Finishing up")),
            ],
          ),
        ),
        body: TabBarView(children: [
          //basics
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                //mainAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    children: [
                      //decide on the color of T.boxes
                      Expanded(
                          child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                            Container(
                              width: 280,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: const Center(
                                  child: Text(
                                textAlign: TextAlign.center,
                                "Character info",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              )),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 250,
                              height: 50,
                              child: TextField(
                                  cursorColor: Colors.blue,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      hintText: "Enter character's name",
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
                                  onChanged: (characterNameEnteredValue) {
                                    characterName = characterNameEnteredValue;
                                  }),
                            ),
                            //ask level or exp
                            //add switch + list tittle stuff for lvl/exp
                            const SizedBox(height: 15),
                            SizedBox(
                                width: 250,
                                height: 50,
                                child: TextField(
                                    cursorColor: Colors.blue,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        hintText: "Enter the player's name",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 212, 208, 224)),
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 124, 112, 112),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)))),
                                    onChanged: (playerNameEnteredValue) {
                                      playerName = playerNameEnteredValue;
                                    })),
                            const SizedBox(height: 15),
                            const SizedBox(
                                width: 250,
                                height: 50,
                                child: TextField(
                                    cursorColor: Colors.blue,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintText:
                                            "Enter the character's gender",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 212, 208, 224)),
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 124, 112, 112),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)))))),
                            const SizedBox(height: 15),
                            SizedBox(
                                width: 300,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RadioListTile(
                                        title: const Text("Use experience"),
                                        value: "Experience",
                                        groupValue: levellingMethod,
                                        onChanged: (value) {
                                          setState(() {
                                            levellingMethod = value.toString();
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      Container(
                                          child: levellingMethod == "Experience"
                                              ? SizedBox(
                                                  width: 250,
                                                  height: 50,
                                                  child: TextField(
                                                      cursorColor: Colors.blue,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Enter the character's exp",
                                                          hintStyle: const TextStyle(
                                                              color:
                                                                  Color.fromARGB(
                                                                      255,
                                                                      212,
                                                                      208,
                                                                      224)),
                                                          filled: true,
                                                          fillColor:
                                                              const Color.fromARGB(
                                                                  255,
                                                                  124,
                                                                  112,
                                                                  112),
                                                          border: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius.circular(12)))))
                                              : RadioListTile(
                                                  title:
                                                      const Text("Use levels"),
                                                  value: "Levels",
                                                  groupValue: levellingMethod,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      levellingMethod =
                                                          value.toString();
                                                    });
                                                  },
                                                )),
                                      const SizedBox(height: 5),
                                      Container(
                                        child: levellingMethod == "Experience"
                                            ? RadioListTile(
                                                title: const Text("Use levels"),
                                                value: "Levels",
                                                groupValue: levellingMethod,
                                                onChanged: (value) {
                                                  setState(() {
                                                    levellingMethod =
                                                        value.toString();
                                                  });
                                                },
                                              )
                                            : SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: DropdownButton<String>(
                                                  value: characterLevel,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Color.fromARGB(
                                                          255, 7, 26, 239)),
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 20),
                                                  underline: Container(
                                                    height: 2,
                                                    color: const Color.fromARGB(
                                                        255, 7, 26, 239),
                                                  ),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      characterLevel = value!;
                                                    });
                                                  },
                                                  items: [
                                                    "1",
                                                    "2",
                                                    "3",
                                                    "4",
                                                    "5",
                                                    "6",
                                                    "7",
                                                    "8",
                                                    "9",
                                                    "10",
                                                    "11",
                                                    "12",
                                                    "13",
                                                    "14",
                                                    "15",
                                                    "16",
                                                    "17",
                                                    "18",
                                                    "19",
                                                    "20"
                                                  ]
                                                      .where((element) =>
                                                          int.parse(element) >=
                                                          int.parse(
                                                              characterLevel ??
                                                                  "1"))
                                                      .toList()
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Center(
                                                          child: Text(value)),
                                                    );
                                                  }).toList(),
                                                )),
                                      ),
                                      const SizedBox(height: 10),
                                    ]))
                          ])),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            width: 325,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(
                                color: const Color.fromARGB(255, 7, 26, 239),
                                width: 2,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: const Center(
                                child: Text(
                              textAlign: TextAlign.center,
                              "Build Parameters",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            )),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 325,
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  title: const Text('Feats in use'),
                                  value: featsAllowed,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      featsAllowed = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text('Use average for hit dice'),
                                  value: averageHitPoints,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      averageHitPoints = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text('Allow multiclassing'),
                                  value: multiclassing,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      multiclassing = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text('Use milestone levelling'),
                                  value: milestoneLevelling,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      milestoneLevelling = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text('Use created content'),
                                  value: useCustomContent,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      useCustomContent = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title:
                                      const Text('Use optional class features'),
                                  value: optionalClassFeatures,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      optionalClassFeatures = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            width: 325,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(
                                color: const Color.fromARGB(255, 7, 26, 239),
                                width: 2,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: const Center(
                                child: Text(
                              textAlign: TextAlign.center,
                              "Rarer Parameters",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            )),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 325,
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  title:
                                      const Text('Use critical role content'),
                                  value: criticalRoleContent,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      criticalRoleContent = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text('Use encumberance rules'),
                                  value: encumberanceRules,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      encumberanceRules = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text("Incude coins' weights"),
                                  value: includeCoinsForWeight,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      includeCoinsForWeight = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text('Use UA content'),
                                  value: unearthedArcanaContent,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      unearthedArcanaContent = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text('Allow firearms'),
                                  value: firearmsUsable,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      firearmsUsable = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 15),
                                CheckboxListTile(
                                  title:
                                      const Text('Give an extra feat at lvl 1'),
                                  value: extraFeatAtLevel1,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      extraFeatAtLevel1 = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.insert_photo),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  )
                ],
              )),
          //race
          Column(
            children: [
              const SizedBox(height: 20),
              DropdownButton<String>(
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    //efficient this up at some point so ASI[i] isn't accessed twice
                    //can actually speed this up but only if asi isn't used elsewhere
                    abilityScoreIncreases = [0, 0, 0, 0, 0, 0];
                    initialRace = RACELIST.singleWhere((x) => x.name == value);
                    subraceExample = initialRace.subRaces?.first;
                    for (int i = 0; i < 6; i++) {
                      abilityScoreIncreases[i] +=
                          initialRace.raceScoreIncrease[i] +
                              ((subraceExample?.subRaceScoreIncrease[i]) ?? 0);

                      optionalOnesStates = [
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false]
                      ];
                      optionalTwosStates = [
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false]
                      ];
                    }
                  });
                },
                value: initialRace.name,
                icon: const Icon(Icons.arrow_downward),
                items: RACELIST.map<DropdownMenuItem<String>>((Race value) {
                  return DropdownMenuItem<String>(
                    value: value.name,
                    child: Text(value.name),
                  );
                }).toList(),
                elevation: 2,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.w700),
                underline: Container(
                  height: 1,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              initialRace.subRaces != null
                  ? DropdownButton<String>(
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          //may cauase issues later
                          abilityScoreIncreases = [0, 0, 0, 0, 0, 0];
                          /*for (int i = 0; i < 6; i++) {
                            abilityScoreIncreases[i] -=
                                subraceExample?.subRaceScoreIncrease[i] ?? 0;
                          }*/
                          subraceExample = initialRace.subRaces
                              ?.singleWhere((x) => x.name == value);
                          for (int i = 0; i < 6; i++) {
                            abilityScoreIncreases[i] +=
                                (subraceExample?.subRaceScoreIncrease[i] ?? 0) +
                                    initialRace.raceScoreIncrease[i];
                          }
                          optionalOnesStates = [
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false]
                          ];
                          optionalTwosStates = [
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false]
                          ];
                        });
                      },
                      value: subraceExample?.name,
                      icon: const Icon(Icons.arrow_downward),
                      items: initialRace.subRaces
                          ?.map<DropdownMenuItem<String>>((Subrace value) {
                        return DropdownMenuItem<String>(
                          value: value.name,
                          child: Text(value.name),
                        );
                      }).toList(),
                      elevation: 2,
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w700),
                      underline: Container(
                        height: 1,
                        color: Colors.deepPurpleAccent,
                      ),
                    )
                  : const SizedBox(),
              //codebook
              if (initialRace.mystery1S + (subraceExample?.mystery1S ?? 0) != 0)
                Expanded(
                  child: Column(
                    children: mystery1slist.sublist(
                        0,
                        2 *
                                (initialRace.mystery1S +
                                    (subraceExample?.mystery1S ?? 0)) +
                            1),
                  ),
                ),
              initialRace.mystery2S + (subraceExample?.mystery2S ?? 0) == 0
                  ? const SizedBox(height: 2)
                  : Expanded(
                      child: Column(
                        children: mystery2slist.sublist(
                            0,
                            2 *
                                    (initialRace.mystery2S +
                                        (subraceExample?.mystery2S ?? 0)) +
                                1),
                      ),
                    ),

              /*
              Expanded(
                child: Column(
                  children: [Text("List: $optionalOnesStates")],
                ),
              ),*/
            ],
          ),
          //class
          DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text(
                      '${int.parse(characterLevel ?? "1") - levelsPerClass.reduce((value, element) => value + element)} class level(s) available but unselected', //and ${widgetsInPlay.length - levelsPerClass.reduce((value, element) => value + element) - allSelected.length} choice(s)
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(child: Text("Choose your classes")),
                    Tab(
                        child: Text(
                            "Make your selections for each level in your class")),
                  ],
                ),
              ),
              body: TabBarView(children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.center,
                    children:
                        // This is the list of buttons
                        List.generate(CLASSLIST.length, (index) {
                      return Container(
                          width: (["Martial", "Third Caster"]
                                  .contains(CLASSLIST[index].classType))
                              ? 210
                              : 225,
                          height: 168,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            children: [
                              Text(CLASSLIST[index].name,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              Text("Class type: ${CLASSLIST[index].classType}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              (["Martial", "Third Caster"]
                                      .contains(CLASSLIST[index].classType))
                                  ? Text(
                                      "Main ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))
                                  : Text(
                                      "Spellcasting ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                              Text(
                                  "Hit die: D${CLASSLIST[index].maxHitDiceRoll}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              Text(
                                  "Saves: ${CLASSLIST[index].savingThrowProficiencies.join(",")}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              const SizedBox(height: 7),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: (int.parse(
                                                characterLevel ?? "1") <=
                                            levelsPerClass.reduce(
                                                (value, element) =>
                                                    value + element))
                                        ? const Color.fromARGB(247, 56, 53, 52)
                                        : const Color.fromARGB(
                                            150, 61, 33, 243),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    side: const BorderSide(
                                        width: 3,
                                        color:
                                            Color.fromARGB(255, 10, 126, 54)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (int.parse(characterLevel ?? "1") >
                                          levelsPerClass.reduce(
                                              (value, element) =>
                                                  value + element)) {
                                        classList.add(CLASSLIST[index].name);
                                        if ((CLASSLIST[index]
                                                .gainAtEachLevel[
                                                    levelsPerClass[index]]
                                                .where((element) =>
                                                    element[0] == "Choice")
                                                .toList())
                                            .isEmpty) {
                                          widgetsInPlay.add(Text(
                                            "No choices needed for ${CLASSLIST[index].name} level ${CLASSLIST[index].gainAtEachLevel[levelsPerClass[index]][0][1]}",
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 0, 168, 252)),
                                          ));
                                        } else {
                                          widgetsInPlay.add(Text(
                                            "${CLASSLIST[index].name} Level ${CLASSLIST[index].gainAtEachLevel[levelsPerClass[index]][0][1]} choice(s):",
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 0, 168, 252)),
                                          ));
                                          for (List<dynamic> x
                                              in CLASSLIST[index]
                                                      .gainAtEachLevel[
                                                  levelsPerClass[index]]) {
                                            if (x[0] == "Choice") {
                                              widgetsInPlay.add(SizedBox(
                                                  height: 80,
                                                  child: ChoiceRow(
                                                    x: x.sublist(1),
                                                    allSelected: allSelected,
                                                  )));
                                            } else {
                                              levelGainParser(
                                                  x, CLASSLIST[index]);
                                            }
                                          }
                                        }
                                        //level 1 bonuses
                                        if (levelsPerClass.reduce(
                                                (value, element) =>
                                                    value + element) ==
                                            0) {
                                          //gain saving throw proficiencies
                                          savingThrowProficiencies =
                                              CLASSLIST[index]
                                                  .savingThrowProficiencies;
                                          maxHealth +=
                                              CLASSLIST[index].maxHitDiceRoll;
                                          equipmentSelectedFromChoices =
                                              CLASSLIST[index].equipmentOptions;
                                          classSkillChoices = List.filled(
                                              CLASSLIST[index]
                                                  .optionsForSkillProficiencies
                                                  .length,
                                              false);
                                          widgetsInPlay.addAll([
                                            Text(
                                                "Pick ${(CLASSLIST[index].numberOfSkillChoices)} skill(s) to gain proficiency in",
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            ToggleButtons(
                                                selectedColor:
                                                    const Color.fromARGB(
                                                        255, 0, 79, 206),
                                                color: Colors.blue,
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.white),
                                                //color: Color.fromARGB(255, 15, 124, 174)
                                                fillColor: const Color.fromARGB(
                                                    162, 0, 255, 8),
                                                borderColor:
                                                    const Color.fromARGB(
                                                        255, 7, 26, 239),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                borderWidth: 1.5,
                                                onPressed: (int subIndex) {
                                                  setState(() {
                                                    //bsckgroundskillchoices
                                                    if (classSkillChoices
                                                            .where((b) => b)
                                                            .length <
                                                        CLASSLIST[index]
                                                            .numberOfSkillChoices) {
                                                      classSkillChoices[
                                                              subIndex] =
                                                          !classSkillChoices[
                                                              subIndex];
                                                    } else {
                                                      if (classSkillChoices[
                                                          subIndex]) {
                                                        classSkillChoices[
                                                            subIndex] = false;
                                                      }
                                                    }
                                                  });
                                                },
                                                isSelected: classSkillChoices,
                                                children: CLASSLIST[index]
                                                    .optionsForSkillProficiencies
                                                    .map((x) => Text(" $x "))
                                                    .toList()),
                                          ]);

                                          //run first level functions := proficiencies, equipment health bonus
                                        } else {
                                          if (averageHitPoints ?? false) {
                                            maxHealth += ((CLASSLIST[index]
                                                        .maxHitDiceRoll) /
                                                    2)
                                                .ceil();
                                          } else {
                                            maxHealth += 1 +
                                                (Random().nextDouble() *
                                                        CLASSLIST[index]
                                                            .maxHitDiceRoll)
                                                    .floor();
                                          }
                                        }

                                        //check if it's a spellcaster
                                        if (CLASSLIST[index].classType !=
                                            "Martial") {
                                          if (levelsPerClass[index] == 0) {
                                            allSpellsSelectedAsListsOfThings
                                                .add([
                                              CLASSLIST[index].name,
                                              [],
                                              levelZeroGetSpellsKnown(index),
                                              CLASSLIST[index]
                                                      .spellsKnownFormula ??
                                                  CLASSLIST[index]
                                                      .spellsKnownPerLevel
                                            ]);
                                          } else {
                                            var a = classSubclassMapper[
                                                CLASSLIST[index].name];
                                            for (var x = 0;
                                                x <
                                                    allSpellsSelectedAsListsOfThings
                                                        .length;
                                                x++) {
                                              if (allSpellsSelectedAsListsOfThings[
                                                      x][0] ==
                                                  CLASSLIST[index].name) {
                                                allSpellsSelectedAsListsOfThings[
                                                        x][2] =
                                                    getSpellsKnown(
                                                        index,
                                                        allSpellsSelectedAsListsOfThings[
                                                            x]);
                                              } else if (a != null) {
                                                if (allSpellsSelectedAsListsOfThings[
                                                        x][0] ==
                                                    a) {
                                                  allSpellsSelectedAsListsOfThings[
                                                          x][2] =
                                                      getSpellsKnown(
                                                          index,
                                                          allSpellsSelectedAsListsOfThings[
                                                              x]);
                                                }
                                              }
                                            }

                                            allSpellsSelectedAsListsOfThings
                                                .add([
                                              CLASSLIST[index].name,
                                              [],
                                              levelZeroGetSpellsKnown(index),
                                              CLASSLIST[index]
                                                      .spellsKnownFormula ??
                                                  CLASSLIST[index]
                                                      .spellsKnownPerLevel
                                            ]);
                                          }
                                        }

                                        levelsPerClass[index]++;
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.add,
                                      color: Colors.white, size: 35))
                            ],
                          ));
                    }),
                  ),
                ),
                Column(children: widgetsInPlay)
              ]),
            ),
          ),
          //Background
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        currentBackground =
                            BACKGROUNDLIST.singleWhere((x) => x.name == value);
                        backgroundPersonalityTrait =
                            currentBackground.personalityTrait.first;
                        backgroundIdeal = currentBackground.ideal.first;
                        backgroundBond = currentBackground.bond.first;
                        backgroundFlaw = currentBackground.flaw.first;
                        backgroundSkillChoices = List.filled(
                                currentBackground.numberOfSkillChoices ?? 0,
                                true) +
                            List.filled(
                                (currentBackground.optionalSkillProficiencies
                                            ?.length ??
                                        0) -
                                    (currentBackground.numberOfSkillChoices ??
                                        0),
                                false);
                        selectedSkillsQ = Queue<int>.from(Iterable.generate(
                            currentBackground.numberOfSkillChoices ?? 0));
                        //
                      });
                    },
                    value: currentBackground.name,
                    icon: const Icon(Icons.arrow_downward),
                    items: BACKGROUNDLIST
                        .map<DropdownMenuItem<String>>((Background value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child: Text(value.name),
                      );
                    }).toList(),
                    elevation: 2,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w700),
                    underline: Container(
                      height: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  //Personality Trait
                  const SizedBox(height: 10),
                  const Text("Select your character's personality trait",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        backgroundPersonalityTrait = currentBackground
                            .personalityTrait
                            .singleWhere((x) => x == value);
                      });
                    },
                    value: backgroundPersonalityTrait,
                    icon: const Icon(Icons.arrow_downward),
                    items: currentBackground.personalityTrait
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    elevation: 2,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w700),
                    underline: Container(
                      height: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),

                  //Ideal
                  const SizedBox(height: 10),
                  const Text("Select your character's ideal",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        backgroundIdeal = currentBackground.ideal
                            .singleWhere((x) => x == value);
                      });
                    },
                    value: backgroundIdeal,
                    icon: const Icon(Icons.arrow_downward),
                    items: currentBackground.ideal
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    elevation: 2,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w700),
                    underline: Container(
                      height: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  //Bond
                  const SizedBox(height: 10),
                  const Text("Select your character's bond",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        backgroundBond = currentBackground.bond
                            .singleWhere((x) => x == value);
                      });
                    },
                    value: backgroundBond,
                    icon: const Icon(Icons.arrow_downward),
                    items: currentBackground.bond
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    elevation: 2,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w700),
                    underline: Container(
                      height: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  //Flaw
                  const SizedBox(height: 10),
                  const Text("Select your character's flaw",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        backgroundFlaw = currentBackground.flaw
                            .singleWhere((x) => x == value);
                      });
                    },
                    value: backgroundFlaw,
                    icon: const Icon(Icons.arrow_downward),
                    items: currentBackground.flaw
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    elevation: 2,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w700),
                    underline: Container(
                      height: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  //really poor programming in general with the over use of ! - try fix although it isn't an issue this way
                  if (currentBackground.numberOfSkillChoices != null)
                    Text(
                        "Pick ${(currentBackground.numberOfSkillChoices)} skill(s) to gain proficiency in",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 7,
                  ),
                  if (currentBackground.numberOfSkillChoices != null)
                    ToggleButtons(
                        selectedColor: const Color.fromARGB(255, 0, 79, 206),
                        color: Colors.blue,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                        //color: Color.fromARGB(255, 15, 124, 174)
                        fillColor: const Color.fromARGB(162, 0, 255, 8),
                        borderColor: const Color.fromARGB(255, 7, 26, 239),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderWidth: 1.5,
                        onPressed: (int index) {
                          setState(() {
                            //bsckgroundskillchoices
                            if (selectedSkillsQ!.contains(index)) {
                              selectedSkillsQ!.remove(index);
                              backgroundSkillChoices[index] = false;
                            } else {
                              if (selectedSkillsQ!.length ==
                                  currentBackground.numberOfSkillChoices) {
                                int removed = selectedSkillsQ!.removeFirst();
                                backgroundSkillChoices[removed] = false;
                              }
                              selectedSkillsQ!.add(index);
                              backgroundSkillChoices[index] = true;
                            }
                          });
                        },
                        isSelected: backgroundSkillChoices,
                        children: currentBackground.optionalSkillProficiencies!
                            .map((x) => Text(" $x "))
                            .toList()),
                  if (currentBackground.numberOfSkillChoices != null)
                    MultiSelectContainer(
                        prefix: MultiSelectPrefix(
                            selectedPrefix: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.check,
                                color: Color.fromARGB(255, 0, 255, 8),
                                size: 20,
                              ),
                            ),
                            enabledPrefix: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                //Icons.do_disturb_alt_sharp,
                                Icons.close,
                                size: 20,
                                color: Color.fromARGB(255, 158, 154, 154),
                              ),
                            )),
                        textStyles: const MultiSelectTextStyles(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white),
                            selectedTextStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              //color: Color.fromARGB(255, 15, 124, 174)
                            )),
                        itemsDecoration: MultiSelectDecorations(
                          selectedDecoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(220, 52, 46, 243),
                                Color.fromARGB(220, 0, 242, 255)
                              ]),
                              border: Border.all(
                                  width: 0.8,
                                  color:
                                      const Color.fromARGB(220, 63, 254, 73)),
                              borderRadius: BorderRadius.circular(15)),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 124, 112, 112),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 61, 59, 59)),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        maxSelectableCount:
                            currentBackground.numberOfSkillChoices,
                        items: [
                          for (var x
                              in currentBackground.optionalSkillProficiencies ??
                                  [])
                            MultiSelectCard(value: x, label: x)
                        ],
                        onChange: (allSelectedItems, selectedItem) {}),
                  if (currentBackground.numberOfLanguageChoices != null)
                    Text(
                        "Pick ${(currentBackground.numberOfLanguageChoices)} language(s) to learn",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 7,
                  ),
                  if (currentBackground.numberOfLanguageChoices != null)
                    MultiSelectContainer(
                        prefix: MultiSelectPrefix(
                            selectedPrefix: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.check,
                                color: Color.fromARGB(255, 0, 255, 8),
                                size: 20,
                              ),
                            ),
                            enabledPrefix: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                //Icons.do_disturb_alt_sharp,
                                Icons.close,
                                size: 20,
                                color: Color.fromARGB(255, 158, 154, 154),
                              ),
                            )),
                        textStyles: const MultiSelectTextStyles(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white),
                            selectedTextStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              //color: Color.fromARGB(255, 15, 124, 174)
                            )),
                        itemsDecoration: MultiSelectDecorations(
                          selectedDecoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(220, 52, 46, 243),
                                Color.fromARGB(220, 0, 242, 255)
                              ]),
                              border: Border.all(
                                  width: 0.8,
                                  color:
                                      const Color.fromARGB(220, 63, 254, 73)),
                              borderRadius: BorderRadius.circular(15)),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 124, 112, 112),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 61, 59, 59)),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        maxSelectableCount:
                            currentBackground.numberOfLanguageChoices,
                        items: [
                          for (var x in LANGUAGELIST)
                            MultiSelectCard(value: x, label: x)
                        ],
                        onChange: (allSelectedItems, selectedItem) {
                          if (allSelectedItems.contains(selectedItem)) {
                            languagesKnown.add(selectedItem as String);
                          } else {
                            languagesKnown.remove(selectedItem as String);
                          }
                        }),
                ],
              )),
          //ability scores
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                const SizedBox(height: 40),
                Text(
                  textAlign: TextAlign.center,
                  "Points remaining: $pointsRemaining",
                  style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 168, 252)),
                ),
                const SizedBox(height: 60),
                Row(
                  children: [
                    const Expanded(flex: 12, child: SizedBox()),
                    Expanded(
                        flex: 11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              strength.name,
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 0, 168, 252)),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  strength.value.toString(),
                                  style: const TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < strength.value && strength.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (strength.value > 8) {
                                                  strength.value--;
                                                  if (strength.value < 13) {
                                                    pointsRemaining++;
                                                  } else {
                                                    pointsRemaining += 2;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white))
                                        : const SizedBox(height: 20, width: 29),
                                    (strength.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              strength.value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 10, 126, 54)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (strength.value < 15) {
                                                  if (abilityScoreCost(
                                                          strength.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            strength.value);
                                                    strength.value++;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.add,
                                                color: Colors.white))
                                        : OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                strength.value--;
                                                pointsRemaining += 2;
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white)),
                                  ],
                                )
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.center,
                              " (+${abilityScoreIncreases[0]})",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 7, 26, 239)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (strength.value + abilityScoreIncreases[0])
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              dexterity.name,
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 0, 168, 252)),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  dexterity.value.toString(),
                                  style: const TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < dexterity.value &&
                                            dexterity.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (dexterity.value > 8) {
                                                  dexterity.value--;
                                                  if (dexterity.value < 13) {
                                                    pointsRemaining++;
                                                  } else {
                                                    pointsRemaining += 2;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white))
                                        : const SizedBox(height: 20, width: 29),
                                    (dexterity.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              dexterity.value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 10, 126, 54)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (dexterity.value < 15) {
                                                  if (abilityScoreCost(
                                                          dexterity.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            dexterity.value);
                                                    dexterity.value++;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.add,
                                                color: Colors.white))
                                        : OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                dexterity.value--;
                                                pointsRemaining += 2;
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white)),
                                  ],
                                )
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.center,
                              " (+${abilityScoreIncreases[1]})",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 7, 26, 239)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (dexterity.value + abilityScoreIncreases[1])
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              constitution.name,
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 0, 168, 252)),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  constitution.value.toString(),
                                  style: const TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < constitution.value &&
                                            constitution.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (constitution.value > 8) {
                                                  constitution.value--;
                                                  if (constitution.value < 13) {
                                                    pointsRemaining++;
                                                  } else {
                                                    pointsRemaining += 2;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white))
                                        : const SizedBox(height: 20, width: 29),
                                    (constitution.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(constitution
                                                              .value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 10, 126, 54)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (constitution.value < 15) {
                                                  if (abilityScoreCost(
                                                          constitution.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            constitution.value);
                                                    constitution.value++;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.add,
                                                color: Colors.white))
                                        : OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                constitution.value--;
                                                pointsRemaining += 2;
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white)),
                                  ],
                                )
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.center,
                              " (+${abilityScoreIncreases[2]})",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 7, 26, 239)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (constitution.value + abilityScoreIncreases[2])
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 13,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              intelligence.name,
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 0, 168, 252)),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  intelligence.value.toString(),
                                  style: const TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < intelligence.value &&
                                            intelligence.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (intelligence.value > 8) {
                                                  intelligence.value--;
                                                  if (intelligence.value < 13) {
                                                    pointsRemaining++;
                                                  } else {
                                                    pointsRemaining += 2;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white))
                                        : const SizedBox(height: 20, width: 29),
                                    (intelligence.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(intelligence
                                                              .value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 10, 126, 54)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (intelligence.value < 15) {
                                                  if (abilityScoreCost(
                                                          intelligence.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            intelligence.value);
                                                    intelligence.value++;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.add,
                                                color: Colors.white))
                                        : OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                intelligence.value--;
                                                pointsRemaining += 2;
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white)),
                                  ],
                                )
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.center,
                              " (+${abilityScoreIncreases[3]})",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 7, 26, 239)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (intelligence.value + abilityScoreIncreases[3])
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              wisdom.name,
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 0, 168, 252)),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  wisdom.value.toString(),
                                  style: const TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < wisdom.value && wisdom.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (wisdom.value > 8) {
                                                  wisdom.value--;
                                                  if (wisdom.value < 13) {
                                                    pointsRemaining++;
                                                  } else {
                                                    pointsRemaining += 2;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white))
                                        : const SizedBox(height: 20, width: 29),
                                    (wisdom.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              wisdom.value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 10, 126, 54)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (wisdom.value < 15) {
                                                  if (abilityScoreCost(
                                                          wisdom.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            wisdom.value);
                                                    wisdom.value++;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.add,
                                                color: Colors.white))
                                        : OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                wisdom.value--;
                                                pointsRemaining += 2;
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white)),
                                  ],
                                )
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.center,
                              " (+${abilityScoreIncreases[4]})",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 7, 26, 239)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (wisdom.value + abilityScoreIncreases[4])
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              charisma.name,
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 0, 168, 252)),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  charisma.value.toString(),
                                  style: const TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < charisma.value && charisma.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (charisma.value > 8) {
                                                  charisma.value--;
                                                  if (charisma.value < 13) {
                                                    pointsRemaining++;
                                                  } else {
                                                    pointsRemaining += 2;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white))
                                        : const SizedBox(height: 20, width: 29),
                                    (charisma.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              charisma.value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 10, 126, 54)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (charisma.value < 15) {
                                                  if (abilityScoreCost(
                                                          charisma.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            charisma.value);
                                                    charisma.value++;
                                                  }
                                                }
                                              });
                                            },
                                            child: const Icon(Icons.add,
                                                color: Colors.white))
                                        : OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Color.fromARGB(
                                                      255, 172, 46, 46)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                charisma.value--;
                                                pointsRemaining += 2;
                                              });
                                            },
                                            child: const Icon(Icons.remove,
                                                color: Colors.white)),
                                  ],
                                )
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.center,
                              " (+${abilityScoreIncreases[5]})",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 7, 26, 239)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (charisma.value + abilityScoreIncreases[5])
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                    const Expanded(flex: 13, child: SizedBox()),
                  ],
                )
              ])),
          //ASI + FEAT
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text("$numberOfRemainingFeatOrASIs options remaining"),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 454,
                              child: Column(
                                children: [
                                  const Text("ASI's"),
                                  if (ASIRemaining)
                                    const Text("You have an unspent ASI"),
                                  SizedBox(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 132,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 7, 26, 239),
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          const Text(
                                            textAlign: TextAlign.center,
                                            "Strength",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[0]}",
                                            style: const TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(strength.value +
                                                                ASIBonuses[0] <
                                                            20))
                                                    ? Colors.grey
                                                    : const Color.fromARGB(
                                                        150, 61, 33, 243),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                side: const BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 10, 126, 54)),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (strength.value +
                                                          ASIBonuses[0] <
                                                      20) {
                                                    if (ASIRemaining) {
                                                      ASIRemaining = false;
                                                      ASIBonuses[0]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      ASIRemaining = true;
                                                      ASIBonuses[0]++;
                                                    }
                                                  }
                                                });
                                              },
                                              child: const Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 32)),
                                        ]),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        height: 132,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 7, 26, 239),
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          const Text(
                                            textAlign: TextAlign.center,
                                            "Intelligence",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[3]}",
                                            style: const TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(intelligence.value +
                                                                ASIBonuses[3] <
                                                            20))
                                                    ? Colors.grey
                                                    : const Color.fromARGB(
                                                        150, 61, 33, 243),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                side: const BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 10, 126, 54)),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (intelligence.value +
                                                          ASIBonuses[3] <
                                                      20) {
                                                    if (ASIRemaining) {
                                                      ASIRemaining = false;
                                                      ASIBonuses[3]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      ASIRemaining = true;
                                                      ASIBonuses[3]++;
                                                    }
                                                  }
                                                });
                                              },
                                              child: const Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 32)),
                                        ]),
                                      )
                                    ],
                                  )),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 132,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 7, 26, 239),
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          const Text(
                                            textAlign: TextAlign.center,
                                            "Dexterity",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[1]}",
                                            style: const TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: ((!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0) ||
                                                        !(dexterity.value +
                                                                ASIBonuses[1] <
                                                            20))
                                                    ? Colors.grey
                                                    : const Color.fromARGB(
                                                        150, 61, 33, 243),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                side: const BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 10, 126, 54)),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (dexterity.value +
                                                          ASIBonuses[1] <
                                                      20) {
                                                    if (ASIRemaining) {
                                                      ASIRemaining = false;
                                                      ASIBonuses[1]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      ASIRemaining = true;
                                                      ASIBonuses[1]++;
                                                    }
                                                  }
                                                });
                                              },
                                              child: const Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 32)),
                                        ]),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        height: 132,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 7, 26, 239),
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          const Text(
                                            textAlign: TextAlign.center,
                                            "Wisdom",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[4]}",
                                            style: const TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(wisdom.value +
                                                                ASIBonuses[4] <
                                                            20))
                                                    ? Colors.grey
                                                    : const Color.fromARGB(
                                                        150, 61, 33, 243),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                side: const BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 10, 126, 54)),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (wisdom.value +
                                                          ASIBonuses[4] <
                                                      20) {
                                                    if (ASIRemaining) {
                                                      ASIRemaining = false;
                                                      ASIBonuses[4]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      ASIRemaining = true;
                                                      ASIBonuses[4]++;
                                                    }
                                                  }
                                                });
                                              },
                                              child: const Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 32)),
                                        ]),
                                      )
                                    ],
                                  )),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 132,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 7, 26, 239),
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          const Text(
                                            textAlign: TextAlign.center,
                                            "Constitution",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[2]}",
                                            style: const TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(constitution.value +
                                                                ASIBonuses[2] <
                                                            20))
                                                    ? Colors.grey
                                                    : const Color.fromARGB(
                                                        150, 61, 33, 243),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                side: const BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 10, 126, 54)),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (constitution.value +
                                                          ASIBonuses[2] <
                                                      20) {
                                                    if (ASIRemaining) {
                                                      ASIRemaining = false;
                                                      ASIBonuses[2]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      ASIRemaining = true;
                                                      ASIBonuses[2]++;
                                                    }
                                                  }
                                                });
                                              },
                                              child: const Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 32)),
                                        ]),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        height: 132,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 7, 26, 239),
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          const Text(
                                            textAlign: TextAlign.center,
                                            "Charisma",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[5]}",
                                            style: const TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(charisma.value +
                                                                ASIBonuses[5] <
                                                            20))
                                                    ? Colors.grey
                                                    : const Color.fromARGB(
                                                        150, 61, 33, 243),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                side: const BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 10, 126, 54)),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (charisma.value +
                                                          ASIBonuses[5] <
                                                      20) {
                                                    if (ASIRemaining) {
                                                      ASIRemaining = false;
                                                      ASIBonuses[5]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      ASIRemaining = true;
                                                      ASIBonuses[5]++;
                                                    }
                                                  }
                                                });
                                              },
                                              child: const Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 32)),
                                        ]),
                                      )
                                    ],
                                  )),
                                ],
                              ))),
                      Expanded(
                          child: SizedBox(
                              height: 435,
                              child: Column(
                                children: [
                                  const Text("Feats"),
                                  if (featsSelected.isNotEmpty)
                                    Text(
                                        "${featsSelected.length} Feats selected:"),
                                  if (featsSelected.isNotEmpty)
                                    SizedBox(
                                        height: 50,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: featsSelected.length,
                                          itemBuilder: (context, index) {
                                            return OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.white),
                                              onPressed: () {},
                                              child: Text(
                                                  featsSelected[index][0].name),
                                            );
                                          },
                                        )),
                                  const Text("Select Feats:"),
                                  Row(children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: (fullFeats)
                                              ? Colors.blue
                                              : Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          fullFeats = !fullFeats;
                                        });
                                      },
                                      child: const Text("Full Feats",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    //text for search
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: (halfFeats)
                                              ? Colors.blue
                                              : Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          halfFeats = !halfFeats;
                                        });
                                      },
                                      child: const Text("Half Feats",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ]),
                                  Container(
                                    height: 140,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 3,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: FEATLIST.length,
                                      itemBuilder: (context, index) {
                                        return OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: (featsSelected
                                                            .where((element) =>
                                                                element[0]
                                                                    .name ==
                                                                FEATLIST[index]
                                                                    .name)
                                                            .length ==
                                                        FEATLIST[index]
                                                            .numberOfTimesTakeable)
                                                    ? Colors.green
                                                    : (featsSelected
                                                            .where((element) =>
                                                                element[0]
                                                                    .name ==
                                                                FEATLIST[index]
                                                                    .name)
                                                            .isEmpty)
                                                        ? Colors.white
                                                        : Colors.lightGreen),
                                            onPressed: () {
                                              setState(
                                                () {
                                                  if (numberOfRemainingFeatOrASIs >
                                                      0) {
                                                    if (featsSelected
                                                            .where((element) =>
                                                                element[0]
                                                                    .name ==
                                                                FEATLIST[index]
                                                                    .name)
                                                            .length <
                                                        FEATLIST[index]
                                                            .numberOfTimesTakeable) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      //call up the selection page
                                                      featsSelected.add(
                                                          [FEATLIST[index]]);
                                                    }
                                                  }
                                                },
                                              );
                                              // Code to handle button press
                                            },
                                            child: Text(FEATLIST[index].name));
                                      },
                                    ),
                                  ),
                                ],
                              ))),
                    ],
                  )
                ],
              )),
          //spells
          DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Center(
                  child: Text(" X spells available",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(
                        child: Text(
                            "Choose your spells from regular progression")),
                    Tab(
                        child: Text(
                            "Make your selections for bonus spells gained elsewhere")),
                  ],
                ),
              ),
              body: TabBarView(children: [
                Row(children: [
                  Expanded(
                      child: Column(children: [
                    if (allSpellsSelected
                            .where((element) => element.level == 0)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Cantrips:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 0)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 0)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 0)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                    if (allSpellsSelected
                            .where((element) => element.level == 1)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Level 1 Spells:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 1)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 1)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 1)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                    if (allSpellsSelected
                            .where((element) => element.level == 2)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Level 2 Spells:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 2)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 2)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 2)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                    if (allSpellsSelected
                            .where((element) => element.level == 3)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Level 3 Spells:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 3)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 3)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 3)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                    if (allSpellsSelected
                            .where((element) => element.level == 4)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Level 4 Spells:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 4)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 4)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 4)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                    if (allSpellsSelected
                            .where((element) => element.level == 5)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Level 5 Spells:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 5)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 5)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 5)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                    if (allSpellsSelected
                            .where((element) => element.level == 6)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Level 6 Spells:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 6)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 6)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 6)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                    if (allSpellsSelected
                            .where((element) => element.level == 7)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Level 7 Spells:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 7)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 7)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 7)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                    if (allSpellsSelected
                            .where((element) => element.level == 8)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Level 8 Spells:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 8)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 8)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 8)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                    if (allSpellsSelected
                            .where((element) => element.level == 9)
                            .toList()
                            .isEmpty ==
                        false)
                      const Text("Level 9 Spells:"),
                    if (allSpellsSelected
                            .where((element) => element.level == 9)
                            .toList()
                            .isEmpty ==
                        false)
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: allSpellsSelected
                                .where((element) => element.level == 9)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(allSpellsSelected
                                    .where((element) => element.level == 9)
                                    .toList()[index]
                                    .name),
                              );
                            },
                          )),
                  ])),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                      children: allSpellsSelectedAsListsOfThings
                          .map((s) => SpellSelections(allSpellsSelected, s))
                          .toList(),
                    )),
                  )
                ]),
                const Text("PAGE")
              ]),
            ),
          ),
          //Equipment
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                          height: 435,
                          child: Column(children: [
                            const Text("Purchase Equipment"),
                            Text(
                                "You have ${currencyStored["Platinum Pieces"]} platinum, ${currencyStored["Gold Pieces"]} gold, ${currencyStored["Electrum Pieces"]} electrum, ${currencyStored["Silver Pieces"]} silver and ${currencyStored["Copper Pieces"]} copper pieces to spend with"),
                            Row(children: [
                              //armour
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: (armourList.length == 4)
                                        ? Colors.blue
                                        : Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    if (armourList.length == 4) {
                                      armourList.clear();
                                    } else {
                                      armourList = [
                                        "Heavy",
                                        "Light",
                                        "Medium",
                                        "Shield"
                                      ];
                                    }
                                  });
                                },
                                child: SizedBox(
                                    width: 305,
                                    height: 57,
                                    child: Column(
                                      children: [
                                        const Text("Armour",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22)),
                                        Row(
                                          children: [
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: (armourList
                                                          .contains("Light"))
                                                      ? Colors.blue
                                                      : Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  if (armourList
                                                      .contains("Light")) {
                                                    armourList.remove("Light");
                                                  } else {
                                                    armourList.add("Light");
                                                  }
                                                });
                                              },
                                              child: const Text("Light",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15)),
                                            ),
                                            OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor: (armourList
                                                            .contains("Medium"))
                                                        ? Colors.blue
                                                        : Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    if (armourList
                                                        .contains("Medium")) {
                                                      armourList
                                                          .remove("Medium");
                                                    } else {
                                                      armourList.add("Medium");
                                                    }
                                                  });
                                                },
                                                child: const Text("Medium",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15))),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: (armourList
                                                          .contains("Heavy"))
                                                      ? Colors.blue
                                                      : Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  if (armourList
                                                      .contains("Heavy")) {
                                                    armourList.remove("Heavy");
                                                  } else {
                                                    armourList.add("Heavy");
                                                  }
                                                });
                                              },
                                              child: const Text("Heavy",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15)),
                                            ),
                                            OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor: (armourList
                                                            .contains("Shield"))
                                                        ? Colors.blue
                                                        : Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    if (armourList
                                                        .contains("Shield")) {
                                                      armourList
                                                          .remove("Shield");
                                                    } else {
                                                      armourList.add("Shield");
                                                    }
                                                  });
                                                },
                                                child: const Text("Shield",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15)))
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                              //weapons
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: (weaponList.length == 2)
                                        ? Colors.blue
                                        : Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    if (weaponList.length == 2) {
                                      weaponList.clear();
                                    } else {
                                      weaponList = ["Ranged", "Melee"];
                                    }
                                  });
                                },
                                child: SizedBox(
                                    width: 158,
                                    height: 57,
                                    child: Column(
                                      children: [
                                        const Text("Weapon",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22)),
                                        Row(
                                          children: [
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: (weaponList
                                                          .contains("Ranged"))
                                                      ? Colors.blue
                                                      : Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  if (weaponList
                                                      .contains("Ranged")) {
                                                    weaponList.remove("Ranged");
                                                  } else {
                                                    weaponList.add("Ranged");
                                                  }
                                                });
                                              },
                                              child: const Text("Ranged",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15)),
                                            ),
                                            OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor: (weaponList
                                                            .contains("Melee"))
                                                        ? Colors.blue
                                                        : Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    if (weaponList
                                                        .contains("Melee")) {
                                                      weaponList
                                                          .remove("Melee");
                                                    } else {
                                                      weaponList.add("Melee");
                                                    }
                                                  });
                                                },
                                                child: const Text("Melee",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15))),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                              //Items
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: (itemList.length == 2)
                                        ? Colors.blue
                                        : Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    if (itemList.length == 2) {
                                      itemList.clear();
                                    } else {
                                      itemList = ["Stackable", "Unstackable"];
                                    }
                                  });
                                },
                                child: SizedBox(
                                    width: 212,
                                    height: 57,
                                    child: Column(
                                      children: [
                                        const Text("Items",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22)),
                                        Row(
                                          children: [
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      (itemList.contains(
                                                              "Stackable"))
                                                          ? Colors.blue
                                                          : Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  if (itemList
                                                      .contains("Stackable")) {
                                                    itemList
                                                        .remove("Stackable");
                                                  } else {
                                                    itemList.add("Stackable");
                                                  }
                                                });
                                              },
                                              child: const Text("Stackable",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15)),
                                            ),
                                            OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (itemList.contains(
                                                                "Unstackable"))
                                                            ? Colors.blue
                                                            : Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    if (itemList.contains(
                                                        "Unstackable")) {
                                                      itemList.remove(
                                                          "Unstackable");
                                                    } else {
                                                      itemList
                                                          .add("Unstackable");
                                                    }
                                                  });
                                                },
                                                child: const Text("Unstackable",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15))),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ]),
                            Row(
                              children: [
                                //costs
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: SizedBox(
                                      width: 402,
                                      height: 57,
                                      child: Column(
                                        children: [
                                          const Text("Cost range:",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 22)),
                                          //box<X<box2
                                          Row(
                                            children: [
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Platinum")
                                                            ? Colors.blue
                                                            : Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    if (coinTypeSelected ==
                                                        "Platinum") {
                                                      coinTypeSelected = null;
                                                    } else {
                                                      coinTypeSelected =
                                                          "Platinum";
                                                    }
                                                  });
                                                },
                                                child: const Text("Platinum",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15)),
                                              ),
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Gold")
                                                            ? Colors.blue
                                                            : Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    if (coinTypeSelected ==
                                                        "Gold") {
                                                      coinTypeSelected = null;
                                                    } else {
                                                      coinTypeSelected = "Gold";
                                                    }
                                                  });
                                                },
                                                child: const Text("Gold",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15)),
                                              ),
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Electrum")
                                                            ? Colors.blue
                                                            : Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    if (coinTypeSelected ==
                                                        "Electrum") {
                                                      coinTypeSelected = null;
                                                    } else {
                                                      coinTypeSelected =
                                                          "Electrum";
                                                    }
                                                  });
                                                },
                                                child: const Text("Electrum",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15)),
                                              ),
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Silver")
                                                            ? Colors.blue
                                                            : Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    if (coinTypeSelected ==
                                                        "Silver") {
                                                      coinTypeSelected = null;
                                                    } else {
                                                      coinTypeSelected =
                                                          "Silver";
                                                    }
                                                  });
                                                },
                                                child: const Text("Silver",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15)),
                                              ),
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Copper")
                                                            ? Colors.blue
                                                            : Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    if (coinTypeSelected ==
                                                        "Copper") {
                                                      coinTypeSelected = null;
                                                    } else {
                                                      coinTypeSelected =
                                                          "Copper";
                                                    }
                                                  });
                                                },
                                                child: const Text("Copper",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15)),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 7, 26, 239),
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                ),
                                height: 200,
                                width: 600,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      alignment: WrapAlignment.center,
                                      children: List.generate(ITEMLIST.length,
                                          (index) {
                                        return OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.white),
                                          onPressed: () {
                                            setState(() {
                                              if (ITEMLIST[index].cost[0] <=
                                                  currencyStored[
                                                      "${ITEMLIST[index].cost[1]} Pieces"]) {
                                                currencyStored[
                                                        "${ITEMLIST[index].cost[1]} Pieces"] =
                                                    currencyStored[
                                                            "${ITEMLIST[index].cost[1]} Pieces"]! -
                                                        (ITEMLIST[index].cost[0]
                                                            as int);
                                                if (ITEMLIST[index].stackable) {
                                                  if (stackableEquipmentSelected
                                                      .containsKey(
                                                          ITEMLIST[index]
                                                              .name)) {
                                                    stackableEquipmentSelected[
                                                            ITEMLIST[index]
                                                                .name] =
                                                        stackableEquipmentSelected[
                                                                ITEMLIST[index]
                                                                    .name]! +
                                                            1;
                                                    //add it in
                                                  } else {
                                                    stackableEquipmentSelected[
                                                        ITEMLIST[index]
                                                            .name] = 1;
                                                  }
                                                } else {
                                                  unstackableEquipmentSelected
                                                      .add(ITEMLIST[index]);
                                                }
                                              }
                                            });

                                            //subtract cost
                                          },
                                          child: Text(ITEMLIST[index].name),
                                        );
                                      }),
                                    )))
                          ]))),
                  Expanded(
                      child: SizedBox(
                          height: 435,
                          child: Column(
                            children: [
                              const Text(
                                  "Pick your equipment from options gained:"),
                              if (equipmentSelectedFromChoices != null)
                                SizedBox(
                                  height: 300,
                                  width: 200,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: /*[const Text(
                                                          "Please choose between the following options:"),...*/
                                          [
                                        for (var i = 0;
                                            i <
                                                equipmentSelectedFromChoices!
                                                    .length;
                                            i++)
                                          (equipmentSelectedFromChoices![i]
                                                      .length ==
                                                  2)
                                              ? Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    children: [
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            equipmentSelectedFromChoices![
                                                                i] = [
                                                              equipmentSelectedFromChoices![
                                                                  i][0]
                                                            ];
                                                          });
                                                        },
                                                        child: Text(
                                                          produceEquipmentOptionDescription(
                                                              equipmentSelectedFromChoices![
                                                                  i][0]),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            equipmentSelectedFromChoices![
                                                                i] = [
                                                              equipmentSelectedFromChoices![
                                                                  i][1]
                                                            ];
                                                          });
                                                        },
                                                        //String produceEquipmentOptionDescription(List<dynamic> optionDescription)
                                                        child: Text(
                                                          produceEquipmentOptionDescription(
                                                              equipmentSelectedFromChoices![
                                                                  i][1]),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Text(produceEquipmentOptionDescription(
                                                  equipmentSelectedFromChoices![
                                                      i][0]))
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ))),
                ],
              )),
          //Boons and magic items

          //Backstory
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                const SizedBox(
                  height: 20,
                  width: 10,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Character Information:",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 168, 252)),
                ),
                const SizedBox(
                  height: 10,
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          textAlign: TextAlign.center,
                          "Age:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Enter character's age",
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
                              onChanged: (characterAgeEnteredValue) {
                                characterAge = characterAgeEnteredValue;
                              }),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          textAlign: TextAlign.center,
                          "Eyes:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Describe your character's eyes",
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
                              onChanged: (characterEyeEnteredValue) {
                                characterEyes = characterEyeEnteredValue;
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10, height: 100),
                    Column(
                      children: [
                        const Text(
                          textAlign: TextAlign.center,
                          "Height:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Enter character's height",
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
                              onChanged: (characterHeightEnteredValue) {
                                characterHeight = characterHeightEnteredValue;
                              }),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          textAlign: TextAlign.center,
                          "Skin:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Describe your character's skin",
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
                              onChanged: (characterSkinEnteredValue) {
                                characterSkin = characterSkinEnteredValue;
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10, height: 100),
                    Column(
                      children: [
                        const Text(
                          textAlign: TextAlign.center,
                          "Weight:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Enter character's weight",
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
                              onChanged: (characterWeightEnteredValue) {
                                characterWeight = characterWeightEnteredValue;
                              }),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          textAlign: TextAlign.center,
                          "Hair:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Describe your character's Hair",
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
                              onChanged: (characterHairEnteredValue) {
                                characterHair = characterHairEnteredValue;
                              }),
                        ),
                      ],
                    )
                  ],
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Backstory:",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 168, 252)),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 1000,
                  height: 100,
                  child: TextField(
                      maxLines: 10000,
                      minLines: 4,
                      cursorColor: Colors.blue,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 126, 122, 122)),
                      decoration: const InputDecoration(
                          hintText:
                              "Write out your character's backstory. This should be a description of their past, including but not limited to: Who raised them/ how were they raised, any serious traumas or achievements in their life and then linking to justify your/ having another, reason for being in the campaign.",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 126, 122, 122)),
                          filled: false,
                          //fillColor: Color.fromARGB(211, 42, 63, 226),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 126, 122, 122)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onChanged: (characterEyeEnteredValue) {
                        characterEyes = characterEyeEnteredValue;
                      }),
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Additional Features:",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 168, 252)),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 1000,
                  height: 100,
                  child: TextField(
                      maxLines: 10000,
                      minLines: 4,
                      cursorColor: Colors.blue,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 126, 122, 122)),
                      decoration: const InputDecoration(
                          hintText:
                              "Write any additional features, skills or abilities which are not a part of the character's race/class/background etc. These should have been agreed apon by your DM or whoever is running the game.",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 126, 122, 122)),
                          filled: false,
                          //fillColor: Color.fromARGB(211, 42, 63, 226),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 126, 122, 122)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onChanged: (characterEyeEnteredValue) {
                        characterEyes = characterEyeEnteredValue;
                      }),
                ),
              ])),
          //Boons and magic items
          const Icon(Icons.directions_bike),
          //Finishing up
          Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PdfPreviewPage(
                          invoice: Character(
                              group: group,
                              levelsPerClass: levelsPerClass,
                              selections: selections,
                              allSelected: allSelected,
                              classSubclassMapper: classSubclassMapper,
                              ACList: ACList,
                              ASIRemaining: ASIRemaining,
                              allSpellsSelected: allSpellsSelected,
                              allSpellsSelectedAsListsOfThings:
                                  allSpellsSelectedAsListsOfThings,
                              armourList: armourList,
                              averageHitPoints: averageHitPoints,
                              backgroundSkillChoices: backgroundSkillChoices,
                              characterAge: characterAge,
                              characterEyes: characterEyes,
                              characterHair: characterHair,
                              characterHeight: characterHeight,
                              characterSkin: characterSkin,
                              characterWeight: characterWeight,
                              coinTypeSelected: coinTypeSelected,
                              criticalRoleContent: criticalRoleContent,
                              encumberanceRules: encumberanceRules,
                              extraFeatAtLevel1: extraFeatAtLevel1,
                              featsAllowed: featsAllowed,
                              featsSelected: featsSelected,
                              firearmsUsable: firearmsUsable,
                              fullFeats: fullFeats,
                              halfFeats: halfFeats,
                              gender: characterGender,
                              includeCoinsForWeight: includeCoinsForWeight,
                              itemList: itemList,
                              milestoneLevelling: milestoneLevelling,
                              multiclassing: multiclassing,
                              useCustomContent: useCustomContent,
                              equipmentSelectedFromChoices:
                                  equipmentSelectedFromChoices,
                              optionalClassFeatures: optionalClassFeatures,
                              optionalOnesStates: optionalOnesStates,
                              optionalTwosStates: optionalTwosStates,
                              pointsRemaining: pointsRemaining,
                              speedBonuses: speedBonusMap,
                              unearthedArcanaContent: unearthedArcanaContent,
                              weaponList: weaponList,
                              numberOfRemainingFeatOrASIs:
                                  numberOfRemainingFeatOrASIs,
                              playerName: playerName,
                              classList: classList,
                              stackableEquipmentSelected:
                                  stackableEquipmentSelected,
                              unstackableEquipmentSelected:
                                  unstackableEquipmentSelected,
                              classSkillsSelected: classSkillChoices,
                              skillsSelected: selectedSkillsQ,
                              subrace: subraceExample,
                              mainToolProficiencies: toolProficiencies,
                              savingThrowProficiencies:
                                  savingThrowProficiencies ?? [],
                              languagesKnown: languagesKnown,
                              featuresAndTraits: featuresAndTraits,
                              inspired: inspired,
                              skillProficiencies: skillProficiencies,
                              maxHealth: maxHealth,
                              background: currentBackground,
                              classLevels: levelsPerClass,
                              race: initialRace,
                              characterExperience: characterExperience,
                              currency: currencyStored,
                              backgroundPersonalityTrait:
                                  backgroundPersonalityTrait,
                              backgroundIdeal: backgroundIdeal,
                              backgroundBond: backgroundBond,
                              backgroundFlaw: backgroundFlaw,
                              name: characterName,
                              raceAbilityScoreIncreases: abilityScoreIncreases,
                              featsASIScoreIncreases: ASIBonuses,
                              strength: strength,
                              dexterity: dexterity,
                              constitution: constitution,
                              intelligence: intelligence,
                              wisdom: wisdom,
                              charisma: charisma)),
                    ),
                  );
                  // rootBundle.
                },
                child: const Icon(Icons.picture_as_pdf),
              ),
              body: Row(children: [
                Expanded(
                    child: Column(children: [
                  const Text("Add your character to a group:"),
                  SizedBox(
                      width: 128,
                      height: 50,
                      child: DropdownButton<String>(
                        value: group,
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
                            group = value!;
                          });
                        },
                        items: GROUPLIST
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: SizedBox(
                                width: 100,
                                child: FittedBox(
                                    fit: BoxFit.scaleDown, child: Text(value))),
                          );
                        }).toList(),
                      )),
                  TextField(
                      cursorColor: Colors.blue,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          hintText: "Enter a group",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 212, 208, 224)),
                          filled: true,
                          fillColor: Color.fromARGB(211, 42, 63, 226),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onChanged: (groupNameEnteredValue) {
                        group = groupNameEnteredValue;
                      }),
                  OutlinedButton(
                    child: const Text("Save Character"),
                    onPressed: () {
                      setState(() {
                        updateGlobals();
                        //final String jsonContent =
                        //  File("assets/Characters.json").readAsStringSync();
                        final Map<String, dynamic> json =
                            jsonDecode(jsonString ?? "");
                        final List<dynamic> characters = json["Characters"];
                        final String curCharacterName = characterName;
                        final int index = characters.indexWhere((character) =>
                            character["Name"] == curCharacterName);

                        if (index != -1) {
                          characters.removeAt(index);
                        }

                        characters.add(Character(
                                levelsPerClass: levelsPerClass,
                                selections: selections,
                                allSelected: allSelected,
                                classSubclassMapper: classSubclassMapper,
                                ACList: ACList,
                                ASIRemaining: ASIRemaining,
                                allSpellsSelected: allSpellsSelected,
                                allSpellsSelectedAsListsOfThings:
                                    allSpellsSelectedAsListsOfThings,
                                armourList: armourList,
                                averageHitPoints: averageHitPoints,
                                backgroundSkillChoices: backgroundSkillChoices,
                                characterAge: characterAge,
                                characterEyes: characterEyes,
                                characterHair: characterHair,
                                characterHeight: characterHeight,
                                characterSkin: characterSkin,
                                characterWeight: characterWeight,
                                coinTypeSelected: coinTypeSelected,
                                criticalRoleContent: criticalRoleContent,
                                encumberanceRules: encumberanceRules,
                                extraFeatAtLevel1: extraFeatAtLevel1,
                                featsAllowed: featsAllowed,
                                featsSelected: featsSelected,
                                firearmsUsable: firearmsUsable,
                                fullFeats: fullFeats,
                                halfFeats: halfFeats,
                                gender: characterGender,
                                includeCoinsForWeight: includeCoinsForWeight,
                                itemList: itemList,
                                milestoneLevelling: milestoneLevelling,
                                multiclassing: multiclassing,
                                useCustomContent: useCustomContent,
                                equipmentSelectedFromChoices:
                                    equipmentSelectedFromChoices,
                                optionalClassFeatures: optionalClassFeatures,
                                optionalOnesStates: optionalOnesStates,
                                optionalTwosStates: optionalTwosStates,
                                pointsRemaining: pointsRemaining,
                                speedBonuses: speedBonusMap,
                                unearthedArcanaContent: unearthedArcanaContent,
                                weaponList: weaponList,
                                numberOfRemainingFeatOrASIs:
                                    numberOfRemainingFeatOrASIs,
                                playerName: playerName,
                                classList: classList,
                                stackableEquipmentSelected:
                                    stackableEquipmentSelected,
                                unstackableEquipmentSelected:
                                    unstackableEquipmentSelected,
                                classSkillsSelected: classSkillChoices,
                                skillsSelected: selectedSkillsQ,
                                subrace: subraceExample,
                                mainToolProficiencies: toolProficiencies,
                                savingThrowProficiencies:
                                    savingThrowProficiencies ?? [],
                                languagesKnown: languagesKnown,
                                featuresAndTraits: featuresAndTraits,
                                inspired: inspired,
                                skillProficiencies: skillProficiencies,
                                maxHealth: maxHealth,
                                background: currentBackground,
                                classLevels: levelsPerClass,
                                race: initialRace,
                                group: group,
                                characterExperience: characterExperience,
                                currency: currencyStored,
                                backgroundPersonalityTrait:
                                    backgroundPersonalityTrait,
                                backgroundIdeal: backgroundIdeal,
                                backgroundBond: backgroundBond,
                                backgroundFlaw: backgroundFlaw,
                                name: characterName,
                                raceAbilityScoreIncreases:
                                    abilityScoreIncreases,
                                featsASIScoreIncreases: ASIBonuses,
                                strength: strength,
                                dexterity: dexterity,
                                constitution: constitution,
                                intelligence: intelligence,
                                wisdom: wisdom,
                                charisma: charisma)
                            .toJson());
                        if ((!GROUPLIST.contains(group)) &&
                            group != null &&
                            group!.replaceAll(" ", "") != "") {
                          final List<dynamic> groupsList = json["Groups"];
                          groupsList.add(group);
                        }
                        writeJsonToFile(json, "userContent");
                        //File("assets/Characters.json")
                        //  .writeAsStringSync(jsonEncode(json));
                        //updateCharacterGlobals();
                      });
                    },
                  )
                ])),
                const Expanded(flex: 2, child: Text("Preview"))
              ])),
        ]),
      ),
    );
  }

  Widget? levelGainParser(List<dynamic> x, Class selectedClass) {
    //Levelup(class?)
    if (x[0] == "Level") {
      // ("Level", "numb")
      return Text(
        "${selectedClass.name} Level ${x[1]} choice(s):",
        style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 0, 168, 252)),
      );
    } else if (x[0] == "Nothing") {
      // ("Nothing", "numb")
      return Text(
        "No choices needed for ${selectedClass.name} level ${x[1]}",
        style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 0, 168, 252)),
      );
    } else if (x[0] == "Bonus") {
      // ("Bonus","String description")
      featuresAndTraits.add(x[1] + ": " + x[2]);
    } else if (x[0] == "AC") {
      // ("AC","intelligence + 2", "RQUIREMENT")
      ACList.add([x[1], x[2]]);
    } /* else if (x[0] == "ACModifier") {
    //("ACModifier", "2/intelligence", "armour"(requirement))
    SPEEDLIST.append([x[1], x[2]]);
  }*/
    else if (x[0] == "Speed") {
      //note base speed is given by race
      //("speed", (w/s/c/f/h), numb/expression")
      speedBonusMap[x[1]]?.add(x[2]);
    } else if (x[0] == "AttributeBoost") {
      if (x[1] == "Intelligence") {
        intelligence.value += int.parse(x[2]);
      } else if (x[1] == "Strength") {
        strength.value += int.parse(x[2]);
      } else if (x[1] == "Constitution") {
        constitution.value += int.parse(x[2]);
      } else if (x[1] == "Dexterity") {
        dexterity.value += int.parse(x[2]);
      } else if (x[1] == "Wisdom") {
        wisdom.value += int.parse(x[2]);
      } else if (x[1] == "charisma") {
        charisma.value += int.parse(x[2]);
      }
      //do this later
    } /*else if (x[0] == "Equipment") {
    //note base speed is given by race
    //("speed", "10", "(w/s/c/f)")
    SPEEDLIST.append([x[1], x[2]]);
  }*/
    else if (x[0] == "Money") {
      //("Money", "Copper Pieces", "10")
      currencyStored[x[1]] = currencyStored[x[1]]! + int.parse(x[2]);
    } //deal with these later
    /*else if (x[0] == "Spell") {
    ///
  } else if (x[0] == "ASI") {
    ("ASI")
      ASINUMB ++;
  } else if (x[0] == "Feat") {
    ("Feat","Any/ featname")
    if (x[1]== "Any"){
      FEATNUMB ++;
    }
    else{
      FEATLIST.add(correct feat)
    }
      
  }*/
    /*else if (x[0] == "Choice") {
    List<Widget> temporaryWidgetList = [];
    //("choice", [option].....)
    /*for (List<dynamic> string in x.sublist(2)) {
      temporaryWidgetList.add(OutlinedButton(
        child: Text(string[1]),
        onPressed: () {
          // When the button is pressed, add the string to the outputStrings list
          setState(() => outputStrings.add(string));
        },
      ));
    }*/
    return Row(children: temporaryWidgetList);
  }*/
  }

  int levelZeroGetSpellsKnown(int index) {
    if (CLASSLIST[index].spellsKnownFormula == null) {
      return CLASSLIST[index].spellsKnownPerLevel![levelsPerClass[index]];
    }
    //decode as zero
    return 3;
  }

  int getSpellsKnown(int index, List<dynamic> thisStuff) {
    if (CLASSLIST[index].spellsKnownFormula == null) {
      return (CLASSLIST[index].spellsKnownPerLevel![levelsPerClass[index]] -
          thisStuff[1].length) as int;
    }
    //decode as level + 1 and then take away [1].length
    return 3;
  }

  String produceEquipmentOptionDescription(List<dynamic> optionDescription) {
    return optionDescription[0] as String;
  }
}
