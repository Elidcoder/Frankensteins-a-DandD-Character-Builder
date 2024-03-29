import 'package:flutter/material.dart';
//import 'package:frankenstein/character_creation_globals.dart';
import 'package:frankenstein/SRD_globals.dart';
import "dart:collection";
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:frankenstein/character_globals.dart';
import 'package:frankenstein/PDFdocs/pdf_final_display.dart';
import 'dart:math';
import 'dart:convert';
import "package:frankenstein/main.dart";

/*ListView.builder(
  itemCount: 3,
  itemBuilder: (BuildContext context, int index) {
    if (index < 2) {
      return Column(
        children: [
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
            borderColor: Colors.black,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderWidth: 1.5,
            onPressed: (int index) {
              setState(() {
                if (optionalOnesStates![i][index]) {
                  abilityScoreIncreases[index] -= 1;
                } else {
                  abilityScoreIncreases[index] += 1;
                  for (int buttonIndex = 0;
                      buttonIndex < optionalOnesStates![i].length;
                      buttonIndex++) {
                    if (optionalOnesStates![i][buttonIndex]) {
                      optionalOnesStates![i][buttonIndex] = false;
                      abilityScoreIncreases[buttonIndex] -= 1;
                    }
                  }
                }
                optionalOnesStates![i][index] = !optionalOnesStates![i][index];
              });
            },
            isSelected: optionalOnesStates![i],
            children: const <Widget>[
              Text(" Strength "),
              Text(" Dexterity "),
              Text(" Constitution "),
              Text(" Intelligence "),
              Text(" Wisdom "),
              Text(" Charisma ")
            ],
          ),
        ],
      );
    } else {
      return TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter some text',
        ),
      );
    }
  },
)*/

int abilityScoreCost(int x) {
  if (x > 12) {
    return 2;
  }
  return 1;
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
          Text(
              "${thisDescription[2]} remaining ${thisDescription[0]} spell choices",
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                        : const Color.fromARGB(247, 56, 53, 52))),
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
                        : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                color: const Color.fromARGB(247, 56, 53, 52),
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
                                ? const Color.fromARGB(247, 56, 53, 52)
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
                                thisDescription[2] -= 1;
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                            : const Color.fromARGB(247, 56, 53, 52))),
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
                                  : const Color.fromARGB(247, 56, 53, 52))),
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
                                  : const Color.fromARGB(247, 56, 53, 52))),
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
                                  : const Color.fromARGB(247, 56, 53, 52))),
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
                                  : const Color.fromARGB(247, 56, 53, 52))),
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
                          backgroundColor: (ritualsSelected
                              ? Colors.blue
                              : const Color.fromARGB(247, 56, 53, 52))),
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
                color: Colors.black,
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
  //Text editing controllers
  ////Basics
  TextEditingController nameEnterController = TextEditingController();
  TextEditingController playerNameEnterController = TextEditingController();
  TextEditingController genderEnterController = TextEditingController();
  ////Backstory
  //////short answers
  TextEditingController ageEnterController = TextEditingController();
  TextEditingController heightEnterController = TextEditingController();
  TextEditingController weightEnterController = TextEditingController();
  TextEditingController eyeColourController = TextEditingController();
  TextEditingController skinEnterController = TextEditingController();
  TextEditingController hairEnterController = TextEditingController();
  //////long answers
  TextEditingController backstoryEnterController = TextEditingController();
  TextEditingController additionalFeaturesEnterController =
      TextEditingController();
  ////Finishing up
  TextEditingController groupEnterController = TextEditingController();

  List<String> featuresAndTraits = [];
  List<String> toolProficiencies = [];
  bool inspired = false;
  Map<String, int> skillBonusMap = {
    "Acrobatics": 0,
    "Animal Handling": 0,
    "Arcana": 0,
    "Athletics": 0,
    "Deception": 0,
    "History": 0,
    "Insight": 0,
    "Intimidation": 0,
    "Investigation": 0,
    "Medicine": 0,
    "Nature": 0,
    "Perception": 0,
    "Performance": 0,
    "Persuasion": 0,
    "Religion": 0,
    "Sleight of Hand": 0,
    "Stealth": 0,
    "Survival": 0,
    "Strength Saving Throw": 0,
    "Dexterity Saving Throw": 0,
    "Constitution Saving Throw": 0,
    "Intelligence Saving Throw": 0,
    "Wisdom Saving Throw": 0,
    "Charisma Saving Throw": 0,
    "Passive Perception": 0,
    "Initiative": 0,
  };
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
    "Gold Pieces": 0,
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
  double characterExperience = 0;
  String enteredExperience = "";
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
  int numberOfRemainingFeatOrASIs = 0;
  bool halfFeats = true;
  bool fullFeats = true;
  //Spell variables
  List<Spell> allSpellsSelected = [];
  List<List<dynamic>> allSpellsSelectedAsListsOfThings = [];
  //Equipment variables
  List<String> armourList = [];
  List<String> weaponList = [];
  List<String> itemList = [];
  String? coinTypeSelected = "Gold";
  List<dynamic> equipmentSelectedFromChoices = [];
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
  String backstory = "";
  String extraFeatures = "";
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
    return DefaultTabController(
      length: 11,
      child: Scaffold(
        backgroundColor: Homepage.backgroundColor,
        appBar: AppBar(
          foregroundColor: Homepage.textColor,
          backgroundColor: Homepage.backingColor,
          title: const Center(
            child: Text(
              textAlign: TextAlign.center,
              "Create a character",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Text("Basics",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("Race",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("Class",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("Backround",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("Ability scores",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("ASI's and Feats",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("Spells",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("Equipment",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("Backstory",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("Boons and magic items",
                      style: TextStyle(color: Homepage.textColor))),
              Tab(
                  child: Text("Finishing up",
                      style: TextStyle(color: Homepage.textColor))),
            ],
            indicatorColor: Homepage.textColor,
          ),
        ),
        body: TabBarView(children: [
          //basics
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                        child: Column(children: [
                      //title
                      Container(
                        width: 330,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Homepage.backingColor,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                          textAlign: TextAlign.center,
                          "Character info",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                              color: Homepage.textColor),
                        )),
                      ),
                      const SizedBox(height: 25),
                      //Character name input
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: TextField(
                            controller: nameEnterController,
                            cursorColor: Homepage.textColor,
                            style: TextStyle(
                              color: Homepage.textColor,
                            ),
                            decoration: InputDecoration(
                                hintText: "Enter character's name",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Homepage.textColor),
                                filled: true,
                                fillColor: Homepage.backingColor,
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)))),
                            onChanged: (characterNameEnteredValue) {
                              setState(() {
                                characterName = characterNameEnteredValue;
                              });
                            }),
                      ),
                      const SizedBox(height: 15),
                      //Player name input
                      SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              controller: playerNameEnterController,
                              cursorColor: Homepage.textColor,
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText: "Enter the player's name",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (playerNameEnteredValue) {
                                setState(() {
                                  playerName = playerNameEnteredValue;
                                });
                              })),
                      const SizedBox(height: 15),
                      //Character gender input
                      SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              controller: genderEnterController,
                              cursorColor: Homepage.textColor,
                              style: TextStyle(
                                color: Homepage.textColor,
                              ),
                              decoration: InputDecoration(
                                  hintText: "Enter the character's gender",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterGenderEnteredValue) {
                                setState(() {
                                  characterGender = characterGenderEnteredValue;
                                });
                              })),
                      const SizedBox(height: 15),
                      //exp/levels section
                      SizedBox(
                          width: 300,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //use experience
                                RadioListTile(
                                  activeColor: Homepage.backingColor,
                                  title: Text("Use experience",
                                      style: TextStyle(
                                          color: Homepage.backingColor)),
                                  value: "Experience",
                                  groupValue: levellingMethod,
                                  onChanged: (value) {
                                    setState(() {
                                      levellingMethod = value.toString();
                                    });
                                  },
                                ),
                                const SizedBox(height: 15),
                                //Experience enterence option if experience is selected
                                //otherwise display the use levels radio tile
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
                                                        color: Color.fromARGB(
                                                            255,
                                                            212,
                                                            208,
                                                            224)),
                                                    filled: true,
                                                    fillColor:
                                                        const Color.fromARGB(
                                                            255, 124, 112, 112),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)))))
                                        : RadioListTile(
                                            activeColor: Homepage.backingColor,
                                            title: Text("Use levels",
                                                style: TextStyle(
                                                    color:
                                                        Homepage.backingColor)),
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
                                //levels radio tile if experience is selected
                                //otherwise the levels selection option
                                Container(
                                  child: levellingMethod == "Experience"
                                      ? RadioListTile(
                                          activeColor: Homepage.backingColor,
                                          title: Text("Use levels",
                                              style: TextStyle(
                                                  color:
                                                      Homepage.backingColor)),
                                          value: "Levels",
                                          groupValue: levellingMethod,
                                          onChanged: (value) {
                                            setState(() {
                                              levellingMethod =
                                                  value.toString();
                                            });
                                          },
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            color: Homepage.backingColor,
                                          ),
                                          height: 45,
                                          child: DropdownButton<String>(
                                              alignment: Alignment.center,
                                              value: characterLevel,
                                              icon: Icon(Icons.arrow_drop_down,
                                                  color: Homepage.textColor),
                                              elevation: 16,
                                              style: TextStyle(
                                                  color: Homepage.textColor,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 20),
                                              underline: const SizedBox(),
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
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Align(
                                                      child: Text(value,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Homepage
                                                                .textColor,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ))),
                                                );
                                              }).toList(),
                                              dropdownColor:
                                                  Homepage.backingColor),
                                        ),
                                ),
                                const SizedBox(height: 10),
                              ]))
                    ])),
                    Expanded(
                        child: Column(
                      children: [
                        Container(
                          width: 335,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Homepage.backingColor,
                            border: Border.all(
                              color: Colors.black,
                              width: 2.1,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                              child: Text(
                            textAlign: TextAlign.center,
                            "Build Parameters",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                                color: Homepage.textColor),
                          )),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: 325,
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: Text("Feats in use",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: featsAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (featsSelected.isEmpty) {
                                      featsAllowed = value;
                                    }
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Use average for hit dice",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: averageHitPoints,
                                onChanged: (bool? value) {
                                  setState(() {
                                    averageHitPoints = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Allow multiclassing",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: multiclassing,
                                onChanged: (bool? value) {
                                  setState(() {
                                    multiclassing = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Use milestone levelling",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: milestoneLevelling,
                                onChanged: (bool? value) {
                                  setState(() {
                                    milestoneLevelling = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Use created content",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: useCustomContent,
                                onChanged: (bool? value) {
                                  setState(() {
                                    useCustomContent = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Use optional class features",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: optionalClassFeatures,
                                onChanged: (bool? value) {
                                  setState(() {
                                    optionalClassFeatures = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
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
                          width: 335,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Homepage.backingColor,
                            border: Border.all(
                              color: Colors.black,
                              width: 2.1,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                              child: Text(
                            textAlign: TextAlign.center,
                            "Rarer Parameters",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                                color: Homepage.textColor),
                          )),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: 325,
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: Text("Use critical role content",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: criticalRoleContent,
                                onChanged: (bool? value) {
                                  setState(() {
                                    criticalRoleContent = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Use encumberance rules",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: encumberanceRules,
                                onChanged: (bool? value) {
                                  setState(() {
                                    encumberanceRules = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Incude coins' weights",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: includeCoinsForWeight,
                                onChanged: (bool? value) {
                                  setState(() {
                                    includeCoinsForWeight = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Use UA content",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: unearthedArcanaContent,
                                onChanged: (bool? value) {
                                  setState(() {
                                    unearthedArcanaContent = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Allow firearms",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: firearmsUsable,
                                onChanged: (bool? value) {
                                  setState(() {
                                    firearmsUsable = value;
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
                              ),
                              const SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text("Give an extra feat at lvl 1",
                                    style: TextStyle(
                                        color: Homepage.backingColor)),
                                value: extraFeatAtLevel1,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (classList.isNotEmpty) {
                                      if (extraFeatAtLevel1 ?? false) {
                                        if (numberOfRemainingFeatOrASIs > 0) {
                                          numberOfRemainingFeatOrASIs--;
                                          extraFeatAtLevel1 = false;
                                        }
                                      } else {
                                        extraFeatAtLevel1 = true;
                                        numberOfRemainingFeatOrASIs++;
                                      }
                                    } else {
                                      extraFeatAtLevel1 =
                                          !(extraFeatAtLevel1 ?? false);
                                    }
                                  });
                                },
                                activeColor: Homepage.backingColor,
                                secondary: Icon(Icons.insert_photo,
                                    color: Homepage.backingColor),
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
            ),
          ),
          //race
          Column(
            children: [
              const SizedBox(height: 24),
              SizedBox(
                  height: 35,
                  child: Text("Select a race:",
                      style: TextStyle(
                          color: Homepage.backingColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800))),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Homepage.backingColor,
                  ),
                  height: 45,
                  child: DropdownButton<String>(
                    alignment: Alignment.center,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        //efficient this up at some point so ASI[i] isn't accessed twice
                        //can actually speed this up but only if asi isn't used elsewhere
                        abilityScoreIncreases = [0, 0, 0, 0, 0, 0];
                        initialRace =
                            RACELIST.singleWhere((x) => x.name == value);
                        subraceExample = initialRace.subRaces?.first;
                        for (int i = 0; i < 6; i++) {
                          abilityScoreIncreases[i] += initialRace
                                  .raceScoreIncrease[i] +
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
                    icon: Icon(Icons.arrow_downward, color: Homepage.textColor),
                    items: RACELIST.map<DropdownMenuItem<String>>((Race value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child: Align(
                            child: Text(value.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Homepage.textColor,
                                  decoration: TextDecoration.underline,
                                ))),
                      );
                    }).toList(),
                    dropdownColor: Homepage.backingColor,
                    elevation: 2,
                    style: TextStyle(
                        color: Homepage.textColor, fontWeight: FontWeight.w700),
                    underline: const SizedBox(),
                  )),
              const SizedBox(height: 10),
              if (initialRace.subRaces != null)
                SizedBox(
                    height: 25,
                    child: Text("Select a subrace:",
                        style: TextStyle(
                            color: Homepage.backingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800))),
              if (initialRace.subRaces != null) const SizedBox(height: 10),
              if (initialRace.subRaces != null)
                Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Homepage.backingColor,
                    ),
                    child: DropdownButton<String>(
                      alignment: Alignment.center,
                      value: subraceExample?.name,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Homepage.textColor),
                      elevation: 16,
                      style: TextStyle(
                          color: Homepage.textColor,
                          fontWeight: FontWeight.w700),
                      underline: const SizedBox(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          abilityScoreIncreases = [0, 0, 0, 0, 0, 0];

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
                      items: initialRace.subRaces
                          ?.map<DropdownMenuItem<String>>((Subrace value) {
                        return DropdownMenuItem<String>(
                          value: value.name,
                          child: Align(
                              child: Text(value.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Homepage.textColor,
                                    decoration: TextDecoration.underline,
                                  ))),
                        );
                      }).toList(),
                      dropdownColor: Homepage.backingColor,
                    )),
              if (initialRace.subRaces != null) const SizedBox(height: 10),
              if (initialRace.mystery1S + (subraceExample?.mystery1S ?? 0) != 0)
                SizedBox(
                    height: 40,
                    child: Text("Choose which score(s) to increase by 1",
                        style: TextStyle(
                            color: Homepage.backingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800))),
              if (initialRace.mystery1S + (subraceExample?.mystery1S ?? 0) != 0)
                SizedBox(
                    height: (initialRace.mystery1S +
                                (subraceExample?.mystery1S ?? 0)) *
                            62 -
                        10,
                    child: ListView.separated(
                      itemCount: (initialRace.mystery1S +
                          (subraceExample?.mystery1S ?? 0)),
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        height: 10.0, // amount of pixels
                        color: Homepage.backgroundColor,
                      ),
                      itemBuilder: (BuildContext context, int choiceNumber) {
                        return Align(
                            alignment: Alignment.center,
                            child: ToggleButtons(
                              selectedColor: Homepage.textColor,
                              color: Homepage.backingColor,
                              fillColor: Homepage.backingColor,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                              borderColor: Homepage.backingColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              borderWidth: 1.5,
                              onPressed: (int index) {
                                setState(() {
                                  if (optionalOnesStates![choiceNumber]
                                      [index]) {
                                    abilityScoreIncreases[index] -= 1;
                                  } else {
                                    abilityScoreIncreases[index] += 1;
                                    for (int buttonIndex = choiceNumber;
                                        buttonIndex <
                                            optionalOnesStates![choiceNumber]
                                                .length;
                                        buttonIndex++) {
                                      if (optionalOnesStates![choiceNumber]
                                          [buttonIndex]) {
                                        optionalOnesStates![choiceNumber]
                                            [buttonIndex] = false;
                                        abilityScoreIncreases[buttonIndex] -= 1;
                                      }
                                    }
                                  }
                                  optionalOnesStates![choiceNumber][index] =
                                      !optionalOnesStates![choiceNumber][index];
                                });
                              },
                              isSelected: optionalOnesStates![choiceNumber],
                              children: const <Widget>[
                                Text(" Strength "),
                                Text(" Dexterity "),
                                Text(" Constitution "),
                                Text(" Intelligence "),
                                Text(" Wisdom "),
                                Text(" Charisma ")
                              ],
                            ));
                      },
                    )),
              if (initialRace.mystery2S + (subraceExample?.mystery2S ?? 0) != 0)
                SizedBox(
                    height: 40,
                    child: Text("Choose which score(s) to increase by 2",
                        style: TextStyle(
                            color: Homepage.backingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800))),
              if (initialRace.mystery2S + (subraceExample?.mystery2S ?? 0) != 0)
                SizedBox(
                    height: (initialRace.mystery2S +
                                (subraceExample?.mystery2S ?? 0)) *
                            62 -
                        10,
                    child: ListView.separated(
                      itemCount: (initialRace.mystery2S +
                          (subraceExample?.mystery2S ?? 0)),
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        height: 10.0, // amount of pixels
                        color: Homepage.backgroundColor,
                      ),
                      itemBuilder: (BuildContext context, int choiceNumber) {
                        return Align(
                            alignment: Alignment.center,
                            child: ToggleButtons(
                              selectedColor: Homepage.textColor,
                              color: Homepage.backingColor,
                              fillColor: Homepage.backingColor,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                              borderColor: Homepage.backingColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              borderWidth: 1.5,
                              onPressed: (int index) {
                                setState(() {
                                  if (optionalTwosStates![choiceNumber]
                                      [index]) {
                                    abilityScoreIncreases[index] -= 1;
                                  } else {
                                    abilityScoreIncreases[index] += 1;
                                    for (int buttonIndex = choiceNumber;
                                        buttonIndex <
                                            optionalTwosStates![choiceNumber]
                                                .length;
                                        buttonIndex++) {
                                      if (optionalTwosStates![choiceNumber]
                                          [buttonIndex]) {
                                        optionalTwosStates![choiceNumber]
                                            [buttonIndex] = false;
                                        abilityScoreIncreases[buttonIndex] -= 1;
                                      }
                                    }
                                  }
                                  optionalTwosStates![choiceNumber][index] =
                                      !optionalTwosStates![choiceNumber][index];
                                });
                              },
                              isSelected: optionalTwosStates![choiceNumber],
                              children: const <Widget>[
                                Text(" Strength "),
                                Text(" Dexterity "),
                                Text(" Constitution "),
                                Text(" Intelligence "),
                                Text(" Wisdom "),
                                Text(" Charisma ")
                              ],
                            ));
                      },
                    )),
            ],
          ),
          //class
          DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Homepage.backgroundColor,
              floatingActionButton: FloatingActionButton(
                tooltip: "Increase character level by 1",
                foregroundColor: Homepage.textColor,
                backgroundColor: (int.parse(characterLevel ?? "1") < 20)
                    ? Homepage.backingColor
                    : const Color.fromARGB(247, 56, 53, 52),
                onPressed: () {
                  if (int.parse(characterLevel ?? "1") < 20) {
                    setState(() {
                      characterLevel =
                          "${int.parse(characterLevel ?? "1") + 1}";
                    });
                  }
                },
                child: const Icon(
                  Icons.exposure_plus_1,
                ),
              ),
              appBar: AppBar(
                foregroundColor: Homepage.textColor,
                backgroundColor: Homepage.backingColor,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                            "${int.parse(characterLevel ?? "1") - levelsPerClass.reduce((value, element) => value + element)} class level(s) available but unselected", //and ${widgetsInPlay.length - levelsPerClass.reduce((value, element) => value + element) - allSelected.length} choice(s)
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: Homepage.textColor),
                            textAlign: TextAlign.center)),
                    classList.isNotEmpty
                        ? Text(
                            "Classes and your levels in them: ${CLASSLIST.asMap().entries.where((entry) => levelsPerClass[entry.key] != 0).map((entry) => "${entry.value.name} - ${levelsPerClass[entry.key]}").join(", ")}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Homepage.textColor),
                            textAlign: TextAlign.center)
                        : Text("You have no levels in any class",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Homepage.textColor),
                            textAlign: TextAlign.center)
                  ],
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(
                        child: Text("Choose your classes",
                            style: TextStyle(color: Homepage.textColor))),
                    Tab(
                        child: Text(
                            "Make your selections for each level in your class",
                            style: TextStyle(color: Homepage.textColor))),
                  ],
                  indicatorColor: Homepage.textColor,
                ),
              ),
              body: TabBarView(children: [
                Container(
                    padding: const EdgeInsets.only(top: 17),
                    child: SingleChildScrollView(
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
                              height: 170,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.8,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                children: [
                                  Text(CLASSLIST[index].name,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color: Homepage.textColor)),
                                  Text(
                                      "Class type: ${CLASSLIST[index].classType}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Homepage.textColor)),
                                  (["Martial", "Third Caster"]
                                          .contains(CLASSLIST[index].classType))
                                      ? Text(
                                          "Main ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Homepage.textColor))
                                      : Text(
                                          "Spellcasting ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Homepage.textColor)),
                                  Text(
                                      "Hit die: D${CLASSLIST[index].maxHitDiceRoll}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Homepage.textColor)),
                                  Text(
                                      "Saves: ${CLASSLIST[index].savingThrowProficiencies.join(",")}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Homepage.textColor)),
                                  const SizedBox(height: 7),
                                  ElevatedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            (int.parse(characterLevel ?? "1") <=
                                                        levelsPerClass.reduce(
                                                            (value, element) =>
                                                                value +
                                                                element) ||
                                                    (!multiclassingPossible(
                                                        CLASSLIST[index])))
                                                ? const Color.fromARGB(
                                                    247, 56, 53, 52)
                                                : Homepage.backingColor,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        side: const BorderSide(
                                            width: 3,
                                            color: Color.fromARGB(
                                                255, 10, 126, 54)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (int.parse(characterLevel ?? "1") >
                                                  classList.length &&
                                              (multiclassingPossible(
                                                  CLASSLIST[index]))) {
                                            classList
                                                .add(CLASSLIST[index].name);

                                            if ((CLASSLIST[index]
                                                    .gainAtEachLevel[
                                                        levelsPerClass[index]]
                                                    .where((element) =>
                                                        element[0] == "Choice")
                                                    .toList())
                                                .isEmpty) {
                                              widgetsInPlay.add(Text(
                                                "No choices needed for ${CLASSLIST[index].name} level ${CLASSLIST[index].gainAtEachLevel[levelsPerClass[index]][0][1]}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        Homepage.backingColor),
                                              ));
                                            } else {
                                              widgetsInPlay.add(Text(
                                                "${CLASSLIST[index].name} Level ${CLASSLIST[index].gainAtEachLevel[levelsPerClass[index]][0][1]} choice(s):",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        Homepage.backingColor),
                                              ));
                                            }
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

                                            //level 1 bonuses
                                            if (classList.length == 1) {
                                              if (extraFeatAtLevel1 ?? false) {
                                                numberOfRemainingFeatOrASIs++;
                                              }
                                              maxHealth += CLASSLIST[index]
                                                  .maxHitDiceRoll;
                                              //gain saving throw proficiencies
                                              savingThrowProficiencies =
                                                  CLASSLIST[index]
                                                      .savingThrowProficiencies;

                                              //equipmentSelectedFromChoices =
                                              //CLASSLIST[index].equipmentOptions;
                                              equipmentSelectedFromChoices
                                                  .addAll(CLASSLIST[index]
                                                      .equipmentOptions);
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                    //color: Color.fromARGB(255, 15, 124, 174)
                                                    fillColor:
                                                        const Color.fromARGB(
                                                            162, 0, 255, 8),
                                                    borderColor:
                                                        const Color.fromARGB(
                                                            255, 7, 26, 239),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
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
                                                                    subIndex] =
                                                                false;
                                                          }
                                                        }
                                                      });
                                                    },
                                                    isSelected:
                                                        classSkillChoices,
                                                    children: CLASSLIST[index]
                                                        .optionsForSkillProficiencies
                                                        .map((x) => Text(" $x "))
                                                        .toList()),
                                              ]);
                                            } //run if not level 1
                                            else {
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
                                              if (classList
                                                      .where((element) =>
                                                          element ==
                                                          CLASSLIST[index].name)
                                                      .length ==
                                                  1) {
                                                allSpellsSelectedAsListsOfThings
                                                    .add([
                                                  CLASSLIST[index].name,
                                                  [],
                                                  levelZeroGetSpellsKnown(
                                                      index),
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
                                              }
                                            }

                                            levelsPerClass[index]++;
                                          }
                                        });
                                      },
                                      child: Icon(Icons.add,
                                          color: Homepage.textColor, size: 35))
                                ],
                              ));
                        }),
                      ),
                    )),
                Column(children: widgetsInPlay)
              ]),
            ),
          ),
          //Background
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text("Select your character's race",
                      style: TextStyle(
                          color: Homepage.backingColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: Homepage.backingColor,
                      ),
                      height: 45,
                      child: DropdownButton<String>(
                          hint: const Center(
                            child: Text("Select an option"),
                          ),
                          alignment: Alignment.center,
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              currentBackground = BACKGROUNDLIST
                                  .singleWhere((x) => x.name == value);
                              backgroundPersonalityTrait =
                                  currentBackground.personalityTrait.first;
                              backgroundIdeal = currentBackground.ideal.first;
                              backgroundBond = currentBackground.bond.first;
                              backgroundFlaw = currentBackground.flaw.first;
                              backgroundSkillChoices = List.filled(
                                      currentBackground.numberOfSkillChoices ??
                                          0,
                                      true) +
                                  List.filled(
                                      (currentBackground
                                                  .optionalSkillProficiencies
                                                  ?.length ??
                                              0) -
                                          (currentBackground
                                                  .numberOfSkillChoices ??
                                              0),
                                      false);
                              selectedSkillsQ = Queue<int>.from(
                                  Iterable.generate(
                                      currentBackground.numberOfSkillChoices ??
                                          0));
                              //
                            });
                          },
                          value: currentBackground.name,
                          icon: Icon(Icons.arrow_downward,
                              color: Homepage.textColor),
                          items: BACKGROUNDLIST.map<DropdownMenuItem<String>>(
                              (Background value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: Align(
                                  child: Text(value.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Homepage.textColor,
                                        decoration: TextDecoration.underline,
                                      ))),
                            );
                          }).toList(),
                          dropdownColor: Homepage.backingColor,
                          elevation: 2,
                          underline: const SizedBox(),
                          style: TextStyle(
                              color: Homepage.textColor,
                              fontWeight: FontWeight.w700))),
                  //Personality Trait
                  const SizedBox(height: 10),
                  Text("Select your character's personality trait",
                      style: TextStyle(
                          color: Homepage.backingColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: Homepage.backingColor,
                      ),
                      height: 45,
                      child: DropdownButton<String>(
                        alignment: Alignment.center,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            backgroundPersonalityTrait = currentBackground
                                .personalityTrait
                                .singleWhere((x) => x == value);
                          });
                        },
                        value: backgroundPersonalityTrait,
                        icon: Icon(Icons.arrow_downward,
                            color: Homepage.textColor),
                        items: currentBackground.personalityTrait
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Align(
                                child: Text(value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Homepage.textColor,
                                        decoration: TextDecoration.underline))),
                          );
                        }).toList(),
                        dropdownColor: Homepage.backingColor,
                        elevation: 2,
                        underline: const SizedBox(),
                        style: TextStyle(
                            color: Homepage.textColor,
                            fontWeight: FontWeight.w700),
                      )),

                  //Ideal
                  const SizedBox(height: 10),
                  Text("Select your character's ideal",
                      style: TextStyle(
                          color: Homepage.backingColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: Homepage.backingColor,
                      ),
                      height: 45,
                      child: DropdownButton<String>(
                        alignment: Alignment.center,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            backgroundIdeal = currentBackground.ideal
                                .singleWhere((x) => x == value);
                          });
                        },
                        value: backgroundIdeal,
                        icon: Icon(Icons.arrow_downward,
                            color: Homepage.textColor),
                        items: currentBackground.ideal
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                                child: Text(" $value",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: Homepage.textColor))),
                          );
                        }).toList(),
                        dropdownColor: Homepage.backingColor,
                        elevation: 2,
                        underline: const SizedBox(),
                        style: TextStyle(
                            color: Homepage.textColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700),
                      )),
                  //Bond
                  const SizedBox(height: 10),
                  Text("Select your character's bond",
                      style: TextStyle(
                          color: Homepage.backingColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: Homepage.backingColor,
                      ),
                      height: 45,
                      child: DropdownButton<String>(
                          alignment: Alignment.center,
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              backgroundBond = currentBackground.bond
                                  .singleWhere((x) => x == value);
                            });
                          },
                          value: backgroundBond,
                          icon: Icon(Icons.arrow_downward,
                              color: Homepage.textColor),
                          items: currentBackground.bond
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                  child: Text(" $value",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Homepage.textColor))),
                            );
                          }).toList(),
                          dropdownColor: Homepage.backingColor,
                          elevation: 2,
                          underline: const SizedBox(),
                          style: TextStyle(
                            color: Homepage.textColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700,
                          ))),
                  //Flaw
                  const SizedBox(height: 10),
                  Text("Select your character's flaw",
                      style: TextStyle(
                          color: Homepage.backingColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: Homepage.backingColor,
                      ),
                      height: 45,
                      child: DropdownButton<String>(
                          alignment: Alignment.center,
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              backgroundFlaw = currentBackground.flaw
                                  .singleWhere((x) => x == value);
                            });
                          },
                          value: backgroundFlaw,
                          icon: Icon(Icons.arrow_downward,
                              color: Homepage.textColor),
                          items: currentBackground.flaw
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                  child: Text(" $value",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Homepage.textColor))),
                            );
                          }).toList(),
                          dropdownColor: Homepage.backingColor,
                          elevation: 2,
                          underline: const SizedBox(),
                          style: TextStyle(
                            color: Homepage.textColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700,
                          ))),
                  //really poor programming in general with the over use of ! - try fix although it isn't an issue this way
                  if (currentBackground.numberOfSkillChoices != null)
                    Text(
                        "Pick ${(currentBackground.numberOfSkillChoices)} skill(s) to gain proficiency in",
                        style: TextStyle(
                            color: Homepage.backingColor,
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
                        borderColor: Colors.black,
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
                  /*if (currentBackground.numberOfSkillChoices != null)
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
                        onChange: (allSelectedItems, selectedItem) {}),*/
                  if (currentBackground.numberOfLanguageChoices != null)
                    Text(
                        "Pick ${(currentBackground.numberOfLanguageChoices)} language(s) to learn",
                        style: TextStyle(
                            color: Homepage.backingColor,
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
                const SizedBox(height: 29),
                Text(
                  textAlign: TextAlign.center,
                  "Points remaining: $pointsRemaining",
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Homepage.backingColor),
                ),
                const SizedBox(height: 50),
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
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Homepage.backingColor),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  strength.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < strength.value && strength.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Homepage.backingColor,
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
                                                      : Homepage.backingColor,
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
                                                  Homepage.backingColor,
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
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 19),
                                  Text(
                                      textAlign: TextAlign.center,
                                      " (+${abilityScoreIncreases[0]}) ",
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      )),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${ASIBonuses[0]}) ",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Homepage.backingColor),
                                  ),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (strength.value +
                                        abilityScoreIncreases[0] +
                                        ASIBonuses[0])
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Homepage.textColor),
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
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Homepage.backingColor),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  dexterity.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < dexterity.value &&
                                            dexterity.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Homepage.backingColor,
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
                                                      : Homepage.backingColor,
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
                                                  Homepage.backingColor,
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
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 19),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${abilityScoreIncreases[1]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${ASIBonuses[1]}) ",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Homepage.backingColor),
                                  ),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (dexterity.value +
                                        abilityScoreIncreases[1] +
                                        ASIBonuses[1])
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Homepage.textColor),
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
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Homepage.backingColor),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  constitution.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < constitution.value &&
                                            constitution.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Homepage.backingColor,
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
                                                      : Homepage.backingColor,
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
                                                  Homepage.backingColor,
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
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 50),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${abilityScoreIncreases[2]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${ASIBonuses[2]}) ",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Homepage.backingColor),
                                  ),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (constitution.value +
                                        abilityScoreIncreases[2] +
                                        ASIBonuses[2])
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Homepage.textColor),
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
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Homepage.backingColor),
                            ),
                            const SizedBox(height: 22),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  intelligence.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < intelligence.value &&
                                            intelligence.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Homepage.backingColor,
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
                                                      : Homepage.backingColor,
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
                                                  Homepage.backingColor,
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
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 37),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${abilityScoreIncreases[3]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${ASIBonuses[3]}) ",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Homepage.backingColor),
                                  ),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (intelligence.value +
                                        abilityScoreIncreases[3] +
                                        ASIBonuses[3])
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Homepage.textColor),
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
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Homepage.backingColor),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  wisdom.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < wisdom.value && wisdom.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Homepage.backingColor,
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
                                                      : Homepage.backingColor,
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
                                                  Homepage.backingColor,
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
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 12),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${abilityScoreIncreases[4]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${ASIBonuses[4]}) ",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Homepage.backingColor),
                                  ),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (wisdom.value +
                                        abilityScoreIncreases[4] +
                                        ASIBonuses[4])
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Homepage.textColor),
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
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Homepage.backingColor),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 110,
                              width: 116,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  charisma.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < charisma.value && charisma.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Homepage.backingColor,
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
                                                      : Homepage.backingColor,
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
                                                  Homepage.backingColor,
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
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 19),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${abilityScoreIncreases[5]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${ASIBonuses[5]}) ",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Homepage.backingColor),
                                  ),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Homepage.backingColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.6,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                (charisma.value +
                                        abilityScoreIncreases[5] +
                                        ASIBonuses[5])
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    color: Homepage.textColor),
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
                  const SizedBox(height: 24),
                  Text("$numberOfRemainingFeatOrASIs options remaining",
                      style: TextStyle(
                          color: Homepage.backingColor,
                          fontSize: 35,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 550,
                              child: Column(
                                children: [
                                  Text("ASI's",
                                      style: TextStyle(
                                          color: Homepage.backingColor,
                                          fontSize: 33,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 8),
                                  if (ASIRemaining)
                                    Text("You have an unspent ASI",
                                        style: TextStyle(
                                            color: Homepage.backingColor,
                                            fontSize: 27,
                                            fontWeight: FontWeight.w800)),
                                  SizedBox(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 132,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Homepage.backingColor,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.6,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Strength",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Homepage.textColor),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[0]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(strength.value +
                                                                ASIBonuses[0] <
                                                            20))
                                                    ? const Color.fromARGB(
                                                        247, 56, 53, 52)
                                                    : Homepage.backingColor,
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
                                          color: Homepage.backingColor,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.6,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Intelligence",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Homepage.textColor),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[3]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(intelligence.value +
                                                                ASIBonuses[3] <
                                                            20))
                                                    ? const Color.fromARGB(
                                                        247, 56, 53, 52)
                                                    : Homepage.backingColor,
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
                                          color: Homepage.backingColor,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.6,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Dexterity",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Homepage.textColor),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[1]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: ((!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0) ||
                                                        !(dexterity.value +
                                                                ASIBonuses[1] <
                                                            20))
                                                    ? const Color.fromARGB(
                                                        247, 56, 53, 52)
                                                    : Homepage.backingColor,
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
                                          color: Homepage.backingColor,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.6,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Wisdom",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Homepage.textColor),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[4]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(wisdom.value +
                                                                ASIBonuses[4] <
                                                            20))
                                                    ? const Color.fromARGB(
                                                        247, 56, 53, 52)
                                                    : Homepage.backingColor,
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
                                          color: Homepage.backingColor,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.6,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Constitution",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Homepage.textColor),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[2]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(constitution.value +
                                                                ASIBonuses[2] <
                                                            20))
                                                    ? const Color.fromARGB(
                                                        247, 56, 53, 52)
                                                    : Homepage.backingColor,
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
                                          color: Homepage.backingColor,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.6,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Charisma",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                                color: Homepage.textColor),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[5]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!ASIRemaining &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(charisma.value +
                                                                ASIBonuses[5] <
                                                            20))
                                                    ? const Color.fromARGB(
                                                        247, 56, 53, 52)
                                                    : Homepage.backingColor,
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
                      if (featsAllowed ?? false)
                        Expanded(
                            child: SizedBox(
                                height: 550,
                                child: Column(
                                  children: [
                                    if (featsSelected.isNotEmpty)
                                      Text(
                                          "${featsSelected.length} Feats selected:",
                                          style: TextStyle(
                                              color: Homepage.backingColor,
                                              fontSize: 33,
                                              fontWeight: FontWeight.w800)),
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
                                                    featsSelected[index][0]
                                                        .name,
                                                    style: TextStyle(
                                                        color: Homepage
                                                            .backingColor)),
                                              );
                                            },
                                          )),
                                    Text("Select Feats:",
                                        style: TextStyle(
                                            color: Homepage.backingColor,
                                            fontSize: 33,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: (fullFeats)
                                                    ? Homepage.backingColor
                                                    : const Color.fromARGB(
                                                        247, 56, 53, 52)),
                                            onPressed: () {
                                              setState(() {
                                                fullFeats = !fullFeats;
                                              });
                                            },
                                            child: Text("Full Feats",
                                                style: TextStyle(
                                                    color: Homepage.textColor)),
                                          ),
                                          //text for search
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: (halfFeats)
                                                    ? Homepage.backingColor
                                                    : const Color.fromARGB(
                                                        247, 56, 53, 52)),
                                            onPressed: () {
                                              setState(() {
                                                halfFeats = !halfFeats;
                                              });
                                            },
                                            child: Text("Half Feats",
                                                style: TextStyle(
                                                    color: Homepage.textColor)),
                                          ),
                                        ])),
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 140,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            247, 56, 53, 52),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 3,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: FEATLIST.length,
                                        itemBuilder: (context, index) {
                                          return Tooltip(
                                              message:
                                                  "${FEATLIST[index].name}: \n •  ${FEATLIST[index].abilites.where((element) => element[0] == "Bonus").toList().map((sublist) => sublist[2]).toList().join('\n • ')}",
                                              child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                      backgroundColor: (featsSelected
                                                              .where((element) =>
                                                                  element[0].name ==
                                                                  FEATLIST[index]
                                                                      .name)
                                                              .isNotEmpty)
                                                          ? Color.fromARGB(
                                                              100 +
                                                                  (((featsSelected.where((element) => element[0].name == FEATLIST[index].name).length) / FEATLIST[index].numberOfTimesTakeable) * 155)
                                                                      .ceil(),
                                                              0,
                                                              50 +
                                                                  (((featsSelected.where((element) => element[0].name == FEATLIST[index].name).length) / FEATLIST[index].numberOfTimesTakeable) *
                                                                          205)
                                                                      .ceil(),
                                                              0)
                                                          : Colors.white),
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        if (numberOfRemainingFeatOrASIs >
                                                            0) {
                                                          if (featsSelected
                                                                  .where((element) =>
                                                                      element[0]
                                                                          .name ==
                                                                      FEATLIST[
                                                                              index]
                                                                          .name)
                                                                  .length <
                                                              FEATLIST[index]
                                                                  .numberOfTimesTakeable) {
                                                            numberOfRemainingFeatOrASIs--;
                                                            //call up the selection page
                                                            featsSelected.add([
                                                              FEATLIST[index]
                                                            ]);
                                                            for (List<dynamic> x
                                                                in FEATLIST[
                                                                        index]
                                                                    .abilites) {
                                                              if (x[0] ==
                                                                  "Choice") {
                                                                widgetsInPlay.add(
                                                                    SizedBox(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            ChoiceRow(
                                                                          x: x.sublist(
                                                                              1),
                                                                          allSelected:
                                                                              allSelected,
                                                                        )));
                                                              } else {
                                                                levelGainParser(
                                                                    x,
                                                                    CLASSLIST[
                                                                        index]);
                                                              }
                                                            }
                                                          }
                                                        }
                                                      },
                                                    );
                                                    // Code to handle button press
                                                  },
                                                  child: Text(FEATLIST[index].name,
                                                      style: TextStyle(
                                                          color: Homepage.backingColor,
                                                          fontWeight: FontWeight.w900))));
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
          Column(children: [
            Text("Choose your spells from regular progression",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Homepage.backingColor)),
            Row(children: [
              Expanded(
                  child: Column(children: [
                if (allSpellsSelected
                    .where((element) => element.level == 0)
                    .toList()
                    .isNotEmpty)
                  const Text("Cantrips:"),
                if (allSpellsSelected
                    .where((element) => element.level == 0)
                    .toList()
                    .isNotEmpty)
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
                    .isNotEmpty)
                  const Text("Level 1 Spells:"),
                if (allSpellsSelected
                    .where((element) => element.level == 1)
                    .toList()
                    .isNotEmpty)
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
                    .isNotEmpty)
                  const Text("Level 2 Spells:"),
                if (allSpellsSelected
                    .where((element) => element.level == 2)
                    .toList()
                    .isNotEmpty)
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
                    .isNotEmpty)
                  const Text("Level 3 Spells:"),
                if (allSpellsSelected
                    .where((element) => element.level == 3)
                    .toList()
                    .isNotEmpty)
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
                    .isNotEmpty)
                  const Text("Level 4 Spells:"),
                if (allSpellsSelected
                    .where((element) => element.level == 4)
                    .toList()
                    .isNotEmpty)
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
                    .isNotEmpty)
                  const Text("Level 5 Spells:"),
                if (allSpellsSelected
                    .where((element) => element.level == 5)
                    .toList()
                    .isNotEmpty)
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
                    .isNotEmpty)
                  const Text("Level 6 Spells:"),
                if (allSpellsSelected
                    .where((element) => element.level == 6)
                    .toList()
                    .isNotEmpty)
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
                    .isNotEmpty)
                  const Text("Level 7 Spells:"),
                if (allSpellsSelected
                    .where((element) => element.level == 7)
                    .toList()
                    .isNotEmpty)
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
                    .isNotEmpty)
                  const Text("Level 8 Spells:"),
                if (allSpellsSelected
                    .where((element) => element.level == 8)
                    .toList()
                    .isNotEmpty)
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
                    .isNotEmpty)
                  const Text("Level 9 Spells:"),
                if (allSpellsSelected
                    .where((element) => element.level == 9)
                    .toList()
                    .isNotEmpty)
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
          ]),
          //Equipment
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                          height: 435,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 9),
                                Text("Purchase Equipment",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w700,
                                        color: Homepage.backingColor)),
                                const SizedBox(height: 6),
                                Text(
                                    "You have ${currencyStored["Platinum Pieces"]} platinum, ${currencyStored["Gold Pieces"]} gold, ${currencyStored["Electrum Pieces"]} electrum, ${currencyStored["Silver Pieces"]} silver and ${currencyStored["Copper Pieces"]} copper pieces to spend",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Homepage.backingColor)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 775,
                                  child: Row(children: [
                                    //armour big button
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              (armourList.length == 4)
                                                  ? Homepage.backingColor
                                                  : const Color.fromARGB(
                                                      247, 56, 53, 52)),
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
                                              Text("Armour",
                                                  style: TextStyle(
                                                      color: Homepage.textColor,
                                                      fontSize: 22)),
                                              Row(
                                                children: [
                                                  //suboptions for armour
                                                  ElevatedButton(
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor:
                                                            (armourList.contains(
                                                                    "Light"))
                                                                ? Homepage
                                                                    .backingColor
                                                                : const Color
                                                                        .fromARGB(
                                                                    247,
                                                                    56,
                                                                    53,
                                                                    52)),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (armourList.contains(
                                                            "Light")) {
                                                          armourList
                                                              .remove("Light");
                                                        } else {
                                                          armourList
                                                              .add("Light");
                                                        }
                                                      });
                                                    },
                                                    child: Text("Light",
                                                        style: TextStyle(
                                                            color: Homepage
                                                                .textColor,
                                                            fontSize: 15)),
                                                  ),
                                                  ElevatedButton(
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor: (armourList
                                                                  .contains(
                                                                      "Medium"))
                                                              ? Homepage
                                                                  .backingColor
                                                              : const Color
                                                                      .fromARGB(
                                                                  247,
                                                                  56,
                                                                  53,
                                                                  52)),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (armourList
                                                              .contains(
                                                                  "Medium")) {
                                                            armourList.remove(
                                                                "Medium");
                                                          } else {
                                                            armourList
                                                                .add("Medium");
                                                          }
                                                        });
                                                      },
                                                      child: Text("Medium",
                                                          style: TextStyle(
                                                              color: Homepage
                                                                  .textColor,
                                                              fontSize: 15))),
                                                  ElevatedButton(
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor:
                                                            (armourList.contains(
                                                                    "Heavy"))
                                                                ? Homepage
                                                                    .backingColor
                                                                : const Color
                                                                        .fromARGB(
                                                                    247,
                                                                    56,
                                                                    53,
                                                                    52)),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (armourList.contains(
                                                            "Heavy")) {
                                                          armourList
                                                              .remove("Heavy");
                                                        } else {
                                                          armourList
                                                              .add("Heavy");
                                                        }
                                                      });
                                                    },
                                                    child: Text("Heavy",
                                                        style: TextStyle(
                                                            color: Homepage
                                                                .textColor,
                                                            fontSize: 15)),
                                                  ),
                                                  ElevatedButton(
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor: (armourList
                                                                  .contains(
                                                                      "Shield"))
                                                              ? Homepage
                                                                  .backingColor
                                                              : const Color
                                                                      .fromARGB(
                                                                  247,
                                                                  56,
                                                                  53,
                                                                  52)),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (armourList
                                                              .contains(
                                                                  "Shield")) {
                                                            armourList.remove(
                                                                "Shield");
                                                          } else {
                                                            armourList
                                                                .add("Shield");
                                                          }
                                                        });
                                                      },
                                                      child: Text("Shield",
                                                          style: TextStyle(
                                                              color: Homepage
                                                                  .textColor,
                                                              fontSize: 15)))
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                    const SizedBox(width: 2),
                                    //weapons
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              (weaponList.length == 2)
                                                  ? Homepage.backingColor
                                                  : const Color.fromARGB(
                                                      247, 56, 53, 52)),
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
                                              Text("Weapon",
                                                  style: TextStyle(
                                                      color: Homepage.textColor,
                                                      fontSize: 22)),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor:
                                                            (weaponList.contains(
                                                                    "Ranged"))
                                                                ? Homepage
                                                                    .backingColor
                                                                : const Color
                                                                        .fromARGB(
                                                                    247,
                                                                    56,
                                                                    53,
                                                                    52)),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (weaponList.contains(
                                                            "Ranged")) {
                                                          weaponList
                                                              .remove("Ranged");
                                                        } else {
                                                          weaponList
                                                              .add("Ranged");
                                                        }
                                                      });
                                                    },
                                                    child: Text("Ranged",
                                                        style: TextStyle(
                                                            color: Homepage
                                                                .textColor,
                                                            fontSize: 15)),
                                                  ),
                                                  ElevatedButton(
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor: (weaponList
                                                                  .contains(
                                                                      "Melee"))
                                                              ? Homepage
                                                                  .backingColor
                                                              : const Color
                                                                      .fromARGB(
                                                                  247,
                                                                  56,
                                                                  53,
                                                                  52)),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (weaponList
                                                              .contains(
                                                                  "Melee")) {
                                                            weaponList.remove(
                                                                "Melee");
                                                          } else {
                                                            weaponList
                                                                .add("Melee");
                                                          }
                                                        });
                                                      },
                                                      child: Text("Melee",
                                                          style: TextStyle(
                                                              color: Homepage
                                                                  .textColor,
                                                              fontSize: 15))),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                    const SizedBox(width: 2),
                                    //Items
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              (itemList.length == 2)
                                                  ? Homepage.backingColor
                                                  : const Color.fromARGB(
                                                      247, 56, 53, 52)),
                                      onPressed: () {
                                        setState(() {
                                          if (itemList.length == 2) {
                                            itemList.clear();
                                          } else {
                                            itemList = [
                                              "Stackable",
                                              "Unstackable"
                                            ];
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                          width: 212,
                                          height: 57,
                                          child: Column(
                                            children: [
                                              Text("Items",
                                                  style: TextStyle(
                                                      color: Homepage.textColor,
                                                      fontSize: 22)),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor: (itemList
                                                                .contains(
                                                                    "Stackable"))
                                                            ? Homepage
                                                                .backingColor
                                                            : const Color
                                                                    .fromARGB(
                                                                247,
                                                                56,
                                                                53,
                                                                52)),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (itemList.contains(
                                                            "Stackable")) {
                                                          itemList.remove(
                                                              "Stackable");
                                                        } else {
                                                          itemList
                                                              .add("Stackable");
                                                        }
                                                      });
                                                    },
                                                    child: Text("Stackable",
                                                        style: TextStyle(
                                                            color: Homepage
                                                                .textColor,
                                                            fontSize: 15)),
                                                  ),
                                                  ElevatedButton(
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor: (itemList
                                                                  .contains(
                                                                      "Unstackable"))
                                                              ? Homepage
                                                                  .backingColor
                                                              : const Color
                                                                      .fromARGB(
                                                                  247,
                                                                  56,
                                                                  53,
                                                                  52)),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (itemList.contains(
                                                              "Unstackable")) {
                                                            itemList.remove(
                                                                "Unstackable");
                                                          } else {
                                                            itemList.add(
                                                                "Unstackable");
                                                          }
                                                        });
                                                      },
                                                      child: Text("Unstackable",
                                                          style: TextStyle(
                                                              color: Homepage
                                                                  .textColor,
                                                              fontSize: 15))),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  ]),
                                ), //Row(
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                //children: [
                                const SizedBox(height: 4),
                                //costs
                                Container(
                                  decoration: BoxDecoration(
                                    color: Homepage.backgroundColor,
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(247, 56, 53, 52),
                                      width: 1.6,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: SizedBox(
                                      width: 402,
                                      height: 57,
                                      child: Column(
                                        children: [
                                          Text("Cost range:",
                                              style: TextStyle(
                                                  color: Homepage.textColor,
                                                  fontSize: 22)),
                                          //box<X<box2
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Platinum")
                                                            ? Homepage
                                                                .backingColor
                                                            : const Color
                                                                    .fromARGB(
                                                                247,
                                                                56,
                                                                53,
                                                                52)),
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
                                                child: Text("Platinum",
                                                    style: TextStyle(
                                                        color:
                                                            Homepage.textColor,
                                                        fontSize: 15)),
                                              ),
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Gold")
                                                            ? Homepage
                                                                .backingColor
                                                            : const Color
                                                                    .fromARGB(
                                                                247,
                                                                56,
                                                                53,
                                                                52)),
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
                                                child: Text("Gold",
                                                    style: TextStyle(
                                                        color:
                                                            Homepage.textColor,
                                                        fontSize: 15)),
                                              ),
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Electrum")
                                                            ? Homepage
                                                                .backingColor
                                                            : const Color
                                                                    .fromARGB(
                                                                247,
                                                                56,
                                                                53,
                                                                52)),
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
                                                child: Text("Electrum",
                                                    style: TextStyle(
                                                        color:
                                                            Homepage.textColor,
                                                        fontSize: 15)),
                                              ),
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Silver")
                                                            ? Homepage
                                                                .backingColor
                                                            : const Color
                                                                    .fromARGB(
                                                                247,
                                                                56,
                                                                53,
                                                                52)),
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
                                                child: Text("Silver",
                                                    style: TextStyle(
                                                        color:
                                                            Homepage.textColor,
                                                        fontSize: 15)),
                                              ),
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Copper")
                                                            ? Homepage
                                                                .backingColor
                                                            : const Color
                                                                    .fromARGB(
                                                                247,
                                                                56,
                                                                53,
                                                                52)),
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
                                                child: Text("Copper",
                                                    style: TextStyle(
                                                        color:
                                                            Homepage.textColor,
                                                        fontSize: 15)),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                                //],
                                //),
                                const SizedBox(height: 4),
                                Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: Homepage.backgroundColor,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.6,
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
                                          children: List.generate(
                                              ITEMLIST
                                                  .where((element) =>
                                                      ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) ||
                                                          (element.equipmentType.contains("Weapon") &&
                                                              element.equipmentType
                                                                  .any((item) =>
                                                                      weaponList.contains(
                                                                          item))) ||
                                                          (element.equipmentType
                                                                  .contains(
                                                                      "Item") &&
                                                              ((itemList.contains("Stackable") && element.stackable) ||
                                                                  (itemList.contains("Unstackable") &&
                                                                      !element
                                                                          .stackable)))) &&
                                                      element.cost[1] ==
                                                          coinTypeSelected)
                                                  .toList()
                                                  .length, (index) {
                                            return OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      Homepage.backingColor),
                                              onPressed: () {
                                                setState(() {
                                                  if (ITEMLIST
                                                          .where((element) =>
                                                              ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) ||
                                                                  (element.equipmentType.contains("Weapon") &&
                                                                      element
                                                                          .equipmentType
                                                                          .any((item) => weaponList.contains(
                                                                              item))) ||
                                                                  (element.equipmentType
                                                                          .contains(
                                                                              "Item") &&
                                                                      ((itemList.contains("Stackable") && element.stackable) ||
                                                                          (itemList.contains("Unstackable") &&
                                                                              !element
                                                                                  .stackable)))) &&
                                                              element.cost[1] ==
                                                                  coinTypeSelected)
                                                          .toList()[index]
                                                          .cost[0] <=
                                                      currencyStored[
                                                          "${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((itemList.contains("Stackable") && element.stackable) || (itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[1]} Pieces"]) {
                                                    currencyStored[
                                                        "${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((itemList.contains("Stackable") && element.stackable) || (itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[1]} Pieces"] = currencyStored[
                                                            "${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((itemList.contains("Stackable") && element.stackable) || (itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[1]} Pieces"]! -
                                                        (ITEMLIST
                                                            .where((element) =>
                                                                ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) ||
                                                                    (element.equipmentType.contains("Weapon") &&
                                                                        element
                                                                            .equipmentType
                                                                            .any((item) => weaponList.contains(
                                                                                item))) ||
                                                                    (element.equipmentType.contains("Item") &&
                                                                        ((itemList.contains("Stackable") && element.stackable) ||
                                                                            (itemList.contains("Unstackable") && !element.stackable)))) &&
                                                                element.cost[1] == coinTypeSelected)
                                                            .toList()[index]
                                                            .cost[0] as int);
                                                    if (ITEMLIST
                                                        .where((element) =>
                                                            ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) ||
                                                                (element.equipmentType
                                                                        .contains(
                                                                            "Weapon") &&
                                                                    element
                                                                        .equipmentType
                                                                        .any((item) =>
                                                                            weaponList.contains(
                                                                                item))) ||
                                                                (element.equipmentType
                                                                        .contains(
                                                                            "Item") &&
                                                                    ((itemList.contains("Stackable") && element.stackable) ||
                                                                        (itemList.contains("Unstackable") &&
                                                                            !element
                                                                                .stackable)))) &&
                                                            element.cost[1] ==
                                                                coinTypeSelected)
                                                        .toList()[index]
                                                        .stackable) {
                                                      if (stackableEquipmentSelected.containsKey(ITEMLIST
                                                          .where((element) =>
                                                              ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) ||
                                                                  (element.equipmentType.contains("Weapon") &&
                                                                      element.equipmentType.any((item) =>
                                                                          weaponList.contains(
                                                                              item))) ||
                                                                  (element.equipmentType.contains(
                                                                          "Item") &&
                                                                      ((itemList.contains("Stackable") && element.stackable) ||
                                                                          (itemList.contains("Unstackable") &&
                                                                              !element
                                                                                  .stackable)))) &&
                                                              element.cost[1] ==
                                                                  coinTypeSelected)
                                                          .toList()[index]
                                                          .name)) {
                                                        stackableEquipmentSelected[ITEMLIST
                                                            .where((element) =>
                                                                ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((itemList.contains("Stackable") && element.stackable) || (itemList.contains("Unstackable") && !element.stackable)))) &&
                                                                element.cost[1] ==
                                                                    coinTypeSelected)
                                                            .toList()[index]
                                                            .name] = stackableEquipmentSelected[ITEMLIST
                                                                .where((element) =>
                                                                    ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) ||
                                                                        (element.equipmentType.contains("Weapon") &&
                                                                            element.equipmentType.any((item) => weaponList.contains(item))) ||
                                                                        (element.equipmentType.contains("Item") && ((itemList.contains("Stackable") && element.stackable) || (itemList.contains("Unstackable") && !element.stackable)))) &&
                                                                    element.cost[1] == coinTypeSelected)
                                                                .toList()[index]
                                                                .name]! +
                                                            1;
                                                        //add it in
                                                      } else {
                                                        stackableEquipmentSelected[ITEMLIST
                                                            .where((element) =>
                                                                ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) ||
                                                                    (element.equipmentType.contains(
                                                                            "Weapon") &&
                                                                        element.equipmentType.any((item) =>
                                                                            weaponList.contains(
                                                                                item))) ||
                                                                    (element.equipmentType.contains(
                                                                            "Item") &&
                                                                        ((itemList.contains("Stackable") && element.stackable) ||
                                                                            (itemList.contains("Unstackable") &&
                                                                                !element
                                                                                    .stackable)))) &&
                                                                element.cost[1] ==
                                                                    coinTypeSelected)
                                                            .toList()[index]
                                                            .name] = 1;
                                                      }
                                                    } else {
                                                      unstackableEquipmentSelected.add(ITEMLIST
                                                          .where((element) =>
                                                              ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) ||
                                                                  (element.equipmentType.contains("Weapon") &&
                                                                      element.equipmentType.any((item) =>
                                                                          weaponList.contains(
                                                                              item))) ||
                                                                  (element.equipmentType.contains(
                                                                          "Item") &&
                                                                      ((itemList.contains("Stackable") && element.stackable) ||
                                                                          (itemList.contains("Unstackable") &&
                                                                              !element
                                                                                  .stackable)))) &&
                                                              element.cost[1] ==
                                                                  coinTypeSelected)
                                                          .toList()[index]);
                                                    }
                                                  }
                                                });
                                              },
                                              child: Text(
                                                  "${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((itemList.contains("Stackable") && element.stackable) || (itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].name}: ${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((itemList.contains("Stackable") && element.stackable) || (itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[0]}x${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((itemList.contains("Stackable") && element.stackable) || (itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[1]}",
                                                  style: TextStyle(
                                                      color:
                                                          Homepage.textColor)),
                                            );
                                          }),
                                        )))
                              ]))),
                  Expanded(
                      child: SizedBox(
                          height: 435,
                          child: Column(
                            children: [
                              const SizedBox(height: 9),
                              Text("Pick your equipment from options gained:",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.backingColor)),
                              const SizedBox(height: 6),
                              if (equipmentSelectedFromChoices != [])
                                SizedBox(
                                  height: 300,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: /*[const Text(
                                                          "Please choose between the following options:"),...*/
                                          [
                                        for (var i = 0;
                                            i <
                                                equipmentSelectedFromChoices
                                                    .length;
                                            i++)
                                          (equipmentSelectedFromChoices[i]
                                                      .length ==
                                                  2)
                                              ? SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      ElevatedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Homepage
                                                                        .backingColor),
                                                        onPressed: () {
                                                          setState(() {
                                                            equipmentSelectedFromChoices[
                                                                i] = [
                                                              equipmentSelectedFromChoices[
                                                                  i][0]
                                                            ];
                                                          });
                                                        },
                                                        child: Text(
                                                          produceEquipmentOptionDescription(
                                                              equipmentSelectedFromChoices[
                                                                  i][0]),
                                                          style: TextStyle(
                                                            color: Homepage
                                                                .textColor,
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Homepage
                                                                        .backingColor),
                                                        onPressed: () {
                                                          setState(() {
                                                            equipmentSelectedFromChoices[
                                                                i] = [
                                                              equipmentSelectedFromChoices[
                                                                  i][1]
                                                            ];
                                                          });
                                                        },
                                                        child: Text(
                                                          produceEquipmentOptionDescription(
                                                              equipmentSelectedFromChoices[
                                                                  i][1]),
                                                          style: TextStyle(
                                                            color: Homepage
                                                                .textColor,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Text(
                                                  produceEquipmentOptionDescription(
                                                      equipmentSelectedFromChoices[
                                                          i][0]),
                                                  style: TextStyle(
                                                      color:
                                                          Homepage.backingColor,
                                                      fontWeight:
                                                          FontWeight.w700))
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ))),
                ],
              )),
          //Backstory
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                const SizedBox(
                  height: 20,
                  width: 10,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Character Information:",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Homepage.backingColor),
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
                        //age text
                        Text(
                          textAlign: TextAlign.center,
                          "Age:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Homepage.backingColor),
                        ),
                        const SizedBox(height: 10),
                        //age input
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              controller: ageEnterController,
                              cursorColor: Homepage.textColor,
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText: "Enter character's age",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterAgeEnteredValue) {
                                setState(() {
                                  characterAge = characterAgeEnteredValue;
                                });
                              }),
                        ),
                        const SizedBox(height: 10),
                        //eye text
                        Text(
                          textAlign: TextAlign.center,
                          "Eyes:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Homepage.backingColor),
                        ),
                        const SizedBox(height: 10),
                        //eye input
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              controller: eyeColourController,
                              cursorColor: Homepage.textColor,
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText: "Describe your character's eyes",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterEyeEnteredValue) {
                                setState(() {
                                  characterEyes = characterEyeEnteredValue;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10, height: 100),
                    Column(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "Height:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Homepage.backingColor),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              controller: heightEnterController,
                              cursorColor: Homepage.textColor,
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText: "Enter character's height",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterHeightEnteredValue) {
                                setState(() {
                                  characterHeight = characterHeightEnteredValue;
                                });
                              }),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          "Skin:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Homepage.backingColor),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              controller: skinEnterController,
                              cursorColor: Homepage.textColor,
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText: "Describe your character's skin",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterSkinEnteredValue) {
                                setState(() {
                                  characterSkin = characterSkinEnteredValue;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10, height: 100),
                    Column(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "Weight:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Homepage.backingColor),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              controller: weightEnterController,
                              cursorColor: Homepage.textColor,
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText: "Enter character's weight",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterWeightEnteredValue) {
                                setState(() {
                                  characterWeight = characterWeightEnteredValue;
                                });
                              }),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          "Hair:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Homepage.backingColor),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              controller: hairEnterController,
                              cursorColor: Homepage.textColor,
                              style: TextStyle(color: Homepage.textColor),
                              decoration: InputDecoration(
                                  hintText: "Describe your character's hair",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                  filled: true,
                                  fillColor: Homepage.backingColor,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterHairEnteredValue) {
                                setState(() {
                                  characterHair = characterHairEnteredValue;
                                });
                              }),
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Backstory:",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Homepage.backingColor),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 1000,
                  height: 100,
                  child: TextField(
                      controller: backstoryEnterController,
                      maxLines: 10000,
                      minLines: 4,
                      cursorColor: Homepage.textColor,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Homepage.backingColor),
                      decoration: InputDecoration(
                          hintText:
                              "Write out your character's backstory. This should be a description of their past, including but not limited to: Who raised them/ how were they raised, any serious traumas or achievements in their life and then linking to justify your/ having another, reason for being in the campaign.",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Homepage.backingColor),
                          filled: false,
                          //fillColor: Color.fromARGB(211, 42, 63, 226),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Homepage.backingColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)))),
                      onChanged: (backstoryEnteredValue) {
                        setState(() {
                          backstory = backstoryEnteredValue;
                        });
                      }),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Additional Features:",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Homepage.backingColor),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 1000,
                  height: 100,
                  child: TextField(
                      controller: additionalFeaturesEnterController,
                      maxLines: 10000,
                      minLines: 4,
                      cursorColor: Homepage.textColor,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Homepage.backingColor),
                      decoration: InputDecoration(
                          hintText:
                              "Write any additional features, skills or abilites which are not a part of the character's race/class/background etc. These should have been agreed apon by your DM or whoever is running the game.",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Homepage.backingColor),
                          filled: false,
                          //fillColor: Color.fromARGB(211, 42, 63, 226),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Homepage.backingColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)))),
                      onChanged: (extraFeaturesEnteredValue) {
                        setState(() {
                          extraFeatures = extraFeaturesEnteredValue;
                        });
                      }),
                ),
              ])),
          //Boons and magic items
          const Icon(Icons.directions_bike),
          //Finishing up
          Scaffold(
              backgroundColor: Homepage.backgroundColor,
              floatingActionButton: FloatingActionButton(
                tooltip: "Generate a PDF",
                foregroundColor: Homepage.textColor,
                backgroundColor: Homepage.backingColor,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PdfPreviewPage(
                          character: Character(
                              skillBonusMap: skillBonusMap,
                              group: group,
                              backstory: backstory,
                              extraFeatures: extraFeatures,
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
                              uniqueID: int.parse([
                                for (var i in List.generate(
                                    15, (_) => Random().nextInt(10)))
                                  i.toString()
                              ].join()),
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
              body:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Expanded(child: SizedBox()),
                Expanded(
                    flex: 5,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Text("Add your character to a group:",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Homepage.backingColor)),
                          const SizedBox(height: 20),
                          Text("Select an existing group:",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Homepage.backingColor)),
                          const SizedBox(height: 20),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: (GROUPLIST.isNotEmpty)
                                    ? Homepage.backingColor
                                    : const Color.fromARGB(247, 56, 53, 52),
                              ),
                              height: 45,
                              child: DropdownButton<String>(
                                hint: Text(
                                    (GROUPLIST.isNotEmpty)
                                        ? " No matching group selected "
                                        : " No groups available ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Homepage.textColor,
                                      decoration: TextDecoration.underline,
                                    )),
                                alignment: Alignment.center,
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    group = value!;
                                  });
                                },
                                value: GROUPLIST.contains(group) ? group : null,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Homepage.textColor),
                                items: (GROUPLIST != [])
                                    ? GROUPLIST.map<DropdownMenuItem<String>>(
                                        (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Align(
                                              child: Text(value,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Homepage.textColor,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ))),
                                        );
                                      }).toList()
                                    : null,
                                dropdownColor: Homepage.backingColor,
                                elevation: 2,
                                style: TextStyle(
                                    color: Homepage.textColor,
                                    fontWeight: FontWeight.w700),
                                underline: const SizedBox(),
                              )),
                          const SizedBox(height: 20),
                          Text("Or create a new one:",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Homepage.backingColor)),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 300,
                            child: TextField(
                                controller: groupEnterController,
                                cursorColor: Homepage.textColor,
                                style: TextStyle(color: Homepage.textColor),
                                decoration: InputDecoration(
                                    hintText: "Enter a group",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Homepage.textColor),
                                    filled: true,
                                    fillColor: Homepage.backingColor,
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)))),
                                onChanged: (groupNameEnteredValue) {
                                  setState(() {
                                    group = groupNameEnteredValue;
                                  });
                                }),
                          ),
                          const SizedBox(height: 30),
                          Tooltip(
                              message:
                                  "This button will save your character putting it into the Json and then send you back to the main menu.",
                              child: ElevatedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: (pointsRemaining == 0 &&
                                          numberOfRemainingFeatOrASIs == 0 &&
                                          !ASIRemaining &&
                                          int.parse(characterLevel ?? "1") <=
                                              classList.length &&
                                          (equipmentSelectedFromChoices == [] ||
                                              equipmentSelectedFromChoices
                                                  .where((element) =>
                                                      element.length == 2)
                                                  .toList()
                                                  .isEmpty) &&
                                          (allSpellsSelectedAsListsOfThings
                                              .where(
                                                  (element) => element[2] != 0)
                                              .isEmpty))
                                      ? Homepage.backingColor
                                      : const Color.fromARGB(247, 56, 53, 52),
                                  padding:
                                      const EdgeInsets.fromLTRB(45, 20, 45, 20),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  side: const BorderSide(
                                      width: 3, color: Colors.black),
                                ),
                                child: Text("Save Character",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Homepage.textColor,
                                    )),
                                onPressed: () {
                                  if (pointsRemaining == 0 &&
                                      numberOfRemainingFeatOrASIs == 0 &&
                                      !ASIRemaining &&
                                      int.parse(characterLevel ?? "1") <=
                                          classList.length &&
                                      (equipmentSelectedFromChoices == [] ||
                                          equipmentSelectedFromChoices
                                              .where((element) =>
                                                  element.length == 2)
                                              .toList()
                                              .isEmpty) &&
                                      (allSpellsSelectedAsListsOfThings
                                          .where((element) => element[2] != 0)
                                          .isEmpty)) {
                                    setState(() {
                                      final Map<String, dynamic> json =
                                          jsonDecode(jsonString ?? "");
                                      final List<dynamic> characters =
                                          json["Characters"];
                                      final String curCharacterName =
                                          characterName;
                                      final int index = characters.indexWhere(
                                          (character) =>
                                              character["Name"] ==
                                              curCharacterName);
                                      if (index != -1) {
                                        characters.removeAt(index);
                                      }
                                      characters.add(Character(
                                              skillBonusMap: skillBonusMap,
                                              uniqueID: int.parse([
                                                for (var i in List.generate(
                                                    15,
                                                    (_) =>
                                                        Random().nextInt(10)))
                                                  i.toString()
                                              ].join()),
                                              backstory: backstory,
                                              extraFeatures: extraFeatures,
                                              levelsPerClass: levelsPerClass,
                                              selections: selections,
                                              allSelected: allSelected,
                                              classSubclassMapper:
                                                  classSubclassMapper,
                                              ACList: ACList,
                                              ASIRemaining: ASIRemaining,
                                              allSpellsSelected:
                                                  allSpellsSelected,
                                              allSpellsSelectedAsListsOfThings:
                                                  allSpellsSelectedAsListsOfThings,
                                              armourList: armourList,
                                              averageHitPoints:
                                                  averageHitPoints,
                                              backgroundSkillChoices:
                                                  backgroundSkillChoices,
                                              characterAge: characterAge,
                                              characterEyes: characterEyes,
                                              characterHair: characterHair,
                                              characterHeight: characterHeight,
                                              characterSkin: characterSkin,
                                              characterWeight: characterWeight,
                                              coinTypeSelected:
                                                  coinTypeSelected,
                                              criticalRoleContent:
                                                  criticalRoleContent,
                                              encumberanceRules:
                                                  encumberanceRules,
                                              extraFeatAtLevel1:
                                                  extraFeatAtLevel1,
                                              featsAllowed: featsAllowed,
                                              featsSelected: featsSelected,
                                              firearmsUsable: firearmsUsable,
                                              fullFeats: fullFeats,
                                              halfFeats: halfFeats,
                                              gender: characterGender,
                                              includeCoinsForWeight:
                                                  includeCoinsForWeight,
                                              itemList: itemList,
                                              milestoneLevelling:
                                                  milestoneLevelling,
                                              multiclassing: multiclassing,
                                              useCustomContent:
                                                  useCustomContent,
                                              equipmentSelectedFromChoices:
                                                  equipmentSelectedFromChoices,
                                              optionalClassFeatures:
                                                  optionalClassFeatures,
                                              optionalOnesStates:
                                                  optionalOnesStates,
                                              optionalTwosStates:
                                                  optionalTwosStates,
                                              speedBonuses: speedBonusMap,
                                              unearthedArcanaContent:
                                                  unearthedArcanaContent,
                                              weaponList: weaponList,
                                              numberOfRemainingFeatOrASIs:
                                                  numberOfRemainingFeatOrASIs,
                                              playerName: playerName,
                                              classList: classList,
                                              stackableEquipmentSelected:
                                                  stackableEquipmentSelected,
                                              unstackableEquipmentSelected:
                                                  unstackableEquipmentSelected,
                                              classSkillsSelected:
                                                  classSkillChoices,
                                              skillsSelected: selectedSkillsQ,
                                              subrace: subraceExample,
                                              mainToolProficiencies:
                                                  toolProficiencies,
                                              savingThrowProficiencies:
                                                  savingThrowProficiencies ??
                                                      [],
                                              languagesKnown: languagesKnown,
                                              featuresAndTraits:
                                                  featuresAndTraits,
                                              inspired: inspired,
                                              skillProficiencies:
                                                  skillProficiencies,
                                              maxHealth: maxHealth,
                                              background: currentBackground,
                                              classLevels: levelsPerClass,
                                              race: initialRace,
                                              group: group,
                                              characterExperience:
                                                  characterExperience,
                                              currency: currencyStored,
                                              backgroundPersonalityTrait:
                                                  backgroundPersonalityTrait,
                                              backgroundIdeal: backgroundIdeal,
                                              backgroundBond: backgroundBond,
                                              backgroundFlaw: backgroundFlaw,
                                              name: characterName,
                                              raceAbilityScoreIncreases:
                                                  abilityScoreIncreases,
                                              featsASIScoreIncreases:
                                                  ASIBonuses,
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
                                        final List<dynamic> groupsList =
                                            json["Groups"];
                                        groupsList.add(group);
                                      }
                                      writeJsonToFile(json, "userContent");
                                      updateGlobals();
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Homepage()),
                                      );
                                      showCongratulationsDialog(context);
                                    });
                                  }
                                },
                              ))
                        ])),
                Expanded(
                    flex: 7,
                    child: Column(children: [
                      //Basics

                      const SizedBox(height: 40),
                      Text("Build checklist:",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Homepage.backingColor)),
                      const SizedBox(height: 20),
                      (characterName.replaceAll(" ", "") != "" &&
                              characterGender.replaceAll(" ", "") != "" &&
                              playerName.replaceAll(" ", "") != "" &&
                              (enteredExperience.replaceAll(" ", "") != "" ||
                                  levellingMethod != "Experience"))
                          ? const Text("Filled in all necessary basics:",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ))
                          : const Text("Filled in all necessary basics:",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange)),
                      //Ability Scores
                      const SizedBox(height: 20),
                      (pointsRemaining == 0)
                          ? const Text("Used all ability score points",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))
                          : Text(
                              "$pointsRemaining unspent ability score points",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                      //ASI+feats
                      const SizedBox(height: 20),
                      (numberOfRemainingFeatOrASIs == 0)
                          ? (ASIRemaining == false)
                              ? const Text("Made all ASI/Feats choices",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700))
                              : const Text("You have an ASI remaining",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700))
                          : Text(
                              "You have $numberOfRemainingFeatOrASIs ASI/Feat (s) remaining",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                      //Class
                      const SizedBox(height: 20),
                      (int.parse(characterLevel ?? "1") <= classList.length)
                          ? const Text("Made all level selections",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))
                          : Text(
                              "${int.parse(characterLevel ?? "1") - classList.length} unused levels",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      //Equipment
                      (equipmentSelectedFromChoices == [] ||
                              equipmentSelectedFromChoices
                                  .where((element) => element.length == 2)
                                  .toList()
                                  .isEmpty)
                          ? const Text("Made all equipment selections",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))
                          : Text(
                              "Missed ${equipmentSelectedFromChoices.where((element) => element.length == 2).toList().length} equipment choice(s)",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      //spells
                      //if the user has multiple classes with spells

                      //All spell sections have 0 remaining options (all spells selected)
                      (allSpellsSelectedAsListsOfThings
                              .where((element) => element[2] != 0)
                              .isEmpty)
                          ?
                          //if they selected every spell available
                          const Text("Chose all spells",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))
                          //if not
                          : (allSpellsSelectedAsListsOfThings.length == 1)
                              //if they only have 1 way to choose spells (as the reduce only works on lists of length >1,
                              // otherwise it just returns the whole element which would break the code)
                              ? Text(
                                  //number remaining
                                  "Missed ${(allSpellsSelectedAsListsOfThings[0][2])} spells",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700))
                              : Text(
                                  //number remaining with multiple ways to choose spells
                                  "Missed ${(allSpellsSelectedAsListsOfThings.reduce((a, b) => a[2] + b[2]) as int)} spells",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700)),

                      const SizedBox(height: 20),
                      (characterAge.replaceAll(" ", "") != "" &&
                              characterHeight.replaceAll(" ", "") != "" &&
                              characterWeight.replaceAll(" ", "") != "" &&
                              characterEyes.replaceAll(" ", "") != "" &&
                              characterSkin.replaceAll(" ", "") != "" &&
                              characterHair.replaceAll(" ", "") != "" &&
                              backstory.replaceAll(" ", "") != "" &&
                              extraFeatures.replaceAll(" ", "") != "")
                          ? const Text("Completed backstory",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))
                          : const Text("Completed backstory",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                    ]))
              ])),
        ]),
      ),
    );
  }

  void showCongratulationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Character created!',
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

  bool multiclassingPossible(Class selectedClass) {
    //check if it is their first class
    if (classList.isEmpty) {
      return true;
    }
    if (!(multiclassing ?? false)) {
      return false;
    }
    List<int> requirements = selectedClass.multiclassingRequirements;
    //check if they already have a level in the class
    if (classList.contains(selectedClass.name)) {
      return true;
    }
    //check the class they want to take
    int count = 0;
    if (strength.value + abilityScoreIncreases[0] + ASIBonuses[0] >=
        requirements[0]) count++;
    if (dexterity.value + abilityScoreIncreases[1] + ASIBonuses[1] >=
        requirements[1]) count++;
    if (constitution.value + abilityScoreIncreases[2] + ASIBonuses[2] >=
        requirements[2]) count++;
    if (intelligence.value + abilityScoreIncreases[3] + ASIBonuses[3] >=
        requirements[3]) count++;
    if (wisdom.value + abilityScoreIncreases[4] + ASIBonuses[4] >=
        requirements[4]) count++;
    if (charisma.value + abilityScoreIncreases[5] + ASIBonuses[5] >=
        requirements[5]) count++;

    if (count < requirements[6]) {
      return false;
    }
    //check all other classes they have a level in
    for (var i = 0; i < classList.length; i++) {
      requirements = CLASSLIST
          .firstWhere((element) => element.name == classList[i])
          .multiclassingRequirements;
      int count = 0;
      if (strength.value + abilityScoreIncreases[0] + ASIBonuses[0] >=
          requirements[0]) count++;
      if (dexterity.value + abilityScoreIncreases[1] + ASIBonuses[1] >=
          requirements[1]) count++;
      if (constitution.value + abilityScoreIncreases[2] + ASIBonuses[2] >=
          requirements[2]) count++;
      if (intelligence.value + abilityScoreIncreases[3] + ASIBonuses[3] >=
          requirements[3]) count++;
      if (wisdom.value + abilityScoreIncreases[4] + ASIBonuses[4] >=
          requirements[4]) count++;
      if (charisma.value + abilityScoreIncreases[5] + ASIBonuses[5] >=
          requirements[5]) count++;

      if (count < requirements[6]) {
        return false;
      }
    }

    return true;
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
    } else if (x[0] == "Speed") {
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
    } else if (x[0] == "Gained") {
      skillBonusMap[x[1]] = skillBonusMap[x[1]]! + int.parse(x[2]);
      //do this later
    } else if (x[0] == "ASI") {
      numberOfRemainingFeatOrASIs++;
    }

    /*else if (x[0] == "Equipment") {
    //note base speed is given by race
    //("speed", "10", "(w/s/c/f)")
    SPEEDLIST.append([x[1], x[2]]);
  }*/
    else if (x[0] == "Money") {
      //("Money", "Copper Pieces", "10")
      currencyStored[x[1]] = currencyStored[x[1]]! + int.parse(x[2]);
    } //deal
    return null;
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

  String produceEquipmentOptionDescription(List list) {
    // Initialize an empty string to store the result
    String result = '';

    // Iterate through the list
    for (int i = 0; i < list.length; i++) {
      // Check if the current element is a number
      if (list[i] is num) {
        // Append the current number and string pair to the result string
        result += '${list[i]}x${list[i + 1]}';

        // Skip over the next element (the string)
        i++;
      } else {
        // Append just the current string to the result string
        result += '${list[i]}';
      }

      // If this is not the last element, add a comma and space separator
      if (i != list.length - 1) result += ', ';
    }

    // Return the final formatted string
    return result;
  }
}
