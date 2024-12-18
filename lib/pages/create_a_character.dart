// External Imports
import 'package:flutter/material.dart';
import "dart:collection";
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'dart:math';

// Project Imports
import "../main.dart";
import '../content_classes/all_content_classes.dart';
import "../file_manager.dart";
import '../pdf_generator/pdf_final_display.dart';

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
                if (character.optionalOnesStates![i][index]) {
                  character.raceAbilityScoreIncreases[index] -= 1;
                } else {
                  character.raceAbilityScoreIncreases[index] += 1;
                  for (int buttonIndex = 0;
                      buttonIndex < character.optionalOnesStates![i].length;
                      buttonIndex++) {
                    if (character.optionalOnesStates![i][buttonIndex]) {
                      character.optionalOnesStates![i][buttonIndex] = false;
                      character.raceAbilityScoreIncreases[buttonIndex] -= 1;
                    }
                  }
                }
                character.optionalOnesStates![i][index] = !character.optionalOnesStates![i][index];
              });
            },
            isSelected: character.optionalOnesStates![i],
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

// TODO(Implement this function) 
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
  // TODO(ADD SOMETHING FOR FAILED COMPARISONS)
  return SPELLLIST[0];
}

class CreateACharacter extends StatefulWidget {
  @override
  MainCreateCharacter createState() => MainCreateCharacter();
}

class SpellSelections extends StatefulWidget {
  //final Class? classSelected;
  List<dynamic> thisDescription;
  List<Spell> allSpells;
  SpellSelections(this.allSpells, this.thisDescription, {super.key});
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

  ChoiceRow({super.key, this.x, this.allSelected});
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

class MainCreateCharacter extends State<CreateACharacter>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Text editing controllers
  /// Basics 
  TextEditingController nameEnterController = TextEditingController();
  TextEditingController playerNameEnterController = TextEditingController();
  TextEditingController genderEnterController = TextEditingController();
  /// Backstory
  //// Short answers 
  TextEditingController ageEnterController = TextEditingController();
  TextEditingController heightEnterController = TextEditingController();
  TextEditingController weightEnterController = TextEditingController();
  TextEditingController eyeColourController = TextEditingController();
  TextEditingController skinEnterController = TextEditingController();
  TextEditingController hairEnterController = TextEditingController();
  //// Long answers
  TextEditingController backstoryEnterController = TextEditingController();
  TextEditingController additionalFeaturesEnterController =
      TextEditingController();
  /// Character group
  TextEditingController groupEnterController = TextEditingController();
  
  // Stores the widgets generated by class levels
  List<Widget> widgetsInPlay = []; 
  List<String> tabLabels = [
    "Basics",
    "Race",
    "Class",
    "Background",
    "Ability Scores",
    "ASIs and Feats",
    "Spells",
    "Equipment",
    "Backstory",
    "Boons and magic items",
    "Finishing up"
    ];
  String? levellingMethod;
  String? characterLevel = "1";
  int pointsRemaining = 27;
  String? coinTypeSelected = "Gold";
  bool halfFeats = true;
  bool fullFeats = true;
  int numberOfRemainingFeatOrASIs = 0;
  bool remainingAsi = false;

  // TODO(Implement an experience levelling alternative using enteredExperience)
  String enteredExperience = "";
  
  // TODO(Implement a better skill proficiency section using skillProficienciesMap and adding a second field
    /// then delete this)
  List<String> skillProficiencies = [];

  Character character = Character.createDefault();

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
      length: tabLabels.length,
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
            tabs: tabLabels.map((e) => tabLabel(e)).toList(),
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
                                character.characterDescription.name = characterNameEnteredValue;
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
                                  character.playerName = playerNameEnteredValue;
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
                                  character.characterDescription.gender = characterGenderEnteredValue;
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
                                value: character.featsAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (character.featsSelected.isEmpty) {
                                      character.featsAllowed = value;
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
                                value: character.averageHitPoints,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.averageHitPoints = value;
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
                                value: character.multiclassing,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.multiclassing = value;
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
                                value: character.milestoneLevelling,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.milestoneLevelling = value;
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
                                value: character.useCustomContent,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.useCustomContent = value;
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
                                value: character.optionalClassFeatures,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.optionalClassFeatures = value;
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
                                value: character.criticalRoleContent,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.criticalRoleContent = value;
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
                                value: character.encumberanceRules,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.encumberanceRules = value;
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
                                value: character.includeCoinsForWeight,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.includeCoinsForWeight = value;
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
                                value: character.unearthedArcanaContent,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.unearthedArcanaContent = value;
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
                                value: character.firearmsUsable,
                                onChanged: (bool? value) {
                                  setState(() {
                                    character.firearmsUsable = value;
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
                                value: character.extraFeatAtLevel1,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (character.classList.isNotEmpty) {
                                      if (character.extraFeatAtLevel1 ?? false) {
                                        if (numberOfRemainingFeatOrASIs > 0) {
                                          numberOfRemainingFeatOrASIs--;
                                          character.extraFeatAtLevel1 = false;
                                        }
                                      } else {
                                        character.extraFeatAtLevel1 = true;
                                        numberOfRemainingFeatOrASIs++;
                                      }
                                    } else {
                                      character.extraFeatAtLevel1 =
                                          !(character.extraFeatAtLevel1 ?? false);
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
                        character.raceAbilityScoreIncreases = [0, 0, 0, 0, 0, 0];
                        character.race =
                            RACELIST.singleWhere((x) => x.name == value);
                        character.subrace = character.race.subRaces?.first;
                        for (int i = 0; i < 6; i++) {
                          character.raceAbilityScoreIncreases[i] += character.race
                                  .raceScoreIncrease[i] +
                              ((character.subrace?.subRaceScoreIncrease[i]) ?? 0);

                          character.optionalOnesStates = [
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false]
                          ];
                          character.optionalTwosStates = [
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false]
                          ];
                        }
                      });
                    },
                    value: character.race.name,
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
              if (character.race.subRaces != null)
                SizedBox(
                    height: 25,
                    child: Text("Select a subrace:",
                        style: TextStyle(
                            color: Homepage.backingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800))),
              if (character.race.subRaces != null) const SizedBox(height: 10),
              if (character.race.subRaces != null)
                Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Homepage.backingColor,
                    ),
                    child: DropdownButton<String>(
                      alignment: Alignment.center,
                      value: character.subrace?.name,
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
                          character.raceAbilityScoreIncreases = [0, 0, 0, 0, 0, 0];

                          character.subrace = character.race.subRaces
                              ?.singleWhere((x) => x.name == value);
                          for (int i = 0; i < 6; i++) {
                            character.raceAbilityScoreIncreases[i] +=
                                (character.subrace?.subRaceScoreIncrease[i] ?? 0) +
                                    character.race.raceScoreIncrease[i];
                          }
                          character.optionalOnesStates = [
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false]
                          ];
                          character.optionalTwosStates = [
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false]
                          ];
                        });
                      },
                      items: character.race.subRaces
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
              if (character.race.subRaces != null) const SizedBox(height: 10),
              if (character.race.mystery1S + (character.subrace?.mystery1S ?? 0) != 0)
                SizedBox(
                    height: 40,
                    child: Text("Choose which score(s) to increase by 1",
                        style: TextStyle(
                            color: Homepage.backingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800))),
              if (character.race.mystery1S + (character.subrace?.mystery1S ?? 0) != 0)
                SizedBox(
                    height: (character.race.mystery1S +
                                (character.subrace?.mystery1S ?? 0)) *
                            62 -
                        10,
                    child: ListView.separated(
                      itemCount: (character.race.mystery1S +
                          (character.subrace?.mystery1S ?? 0)),
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
                                  if (character.optionalOnesStates![choiceNumber]
                                      [index]) {
                                    character.raceAbilityScoreIncreases[index] -= 1;
                                  } else {
                                    character.raceAbilityScoreIncreases[index] += 1;
                                    for (int buttonIndex = choiceNumber;
                                        buttonIndex <
                                            character.optionalOnesStates![choiceNumber]
                                                .length;
                                        buttonIndex++) {
                                      if (character.optionalOnesStates![choiceNumber]
                                          [buttonIndex]) {
                                        character.optionalOnesStates![choiceNumber]
                                            [buttonIndex] = false;
                                        character.raceAbilityScoreIncreases[buttonIndex] -= 1;
                                      }
                                    }
                                  }
                                  character.optionalOnesStates![choiceNumber][index] =
                                      !character.optionalOnesStates![choiceNumber][index];
                                });
                              },
                              isSelected: character.optionalOnesStates![choiceNumber],
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
              if (character.race.mystery2S + (character.subrace?.mystery2S ?? 0) != 0)
                SizedBox(
                    height: 40,
                    child: Text("Choose which score(s) to increase by 2",
                        style: TextStyle(
                            color: Homepage.backingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800))),
              if (character.race.mystery2S + (character.subrace?.mystery2S ?? 0) != 0)
                SizedBox(
                    height: (character.race.mystery2S +
                                (character.subrace?.mystery2S ?? 0)) *
                            62 -
                        10,
                    child: ListView.separated(
                      itemCount: (character.race.mystery2S +
                          (character.subrace?.mystery2S ?? 0)),
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
                                  if (character.optionalTwosStates![choiceNumber]
                                      [index]) {
                                    character.raceAbilityScoreIncreases[index] -= 1;
                                  } else {
                                    character.raceAbilityScoreIncreases[index] += 1;
                                    for (int buttonIndex = choiceNumber;
                                        buttonIndex <
                                            character.optionalTwosStates![choiceNumber]
                                                .length;
                                        buttonIndex++) {
                                      if (character.optionalTwosStates![choiceNumber]
                                          [buttonIndex]) {
                                        character.optionalTwosStates![choiceNumber]
                                            [buttonIndex] = false;
                                        character.raceAbilityScoreIncreases[buttonIndex] -= 1;
                                      }
                                    }
                                  }
                                  character.optionalTwosStates![choiceNumber][index] =
                                      !character.optionalTwosStates![choiceNumber][index];
                                });
                              },
                              isSelected: character.optionalTwosStates![choiceNumber],
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
                            "${int.parse(characterLevel ?? "1") - character.classLevels.reduce((value, element) => value + element)} class level(s) available but unselected", //and ${widgetsInPlay.length - levelsPerClass.reduce((value, element) => value + element) - allSelected.length} choice(s)
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: Homepage.textColor),
                            textAlign: TextAlign.center)),
                    character.classList.isNotEmpty
                        ? Text(
                            "Classes and your levels in them: ${CLASSLIST.asMap().entries.where((entry) => character.classLevels[entry.key] != 0).map((entry) => "${entry.value.name} - ${character.classLevels[entry.key]}").join(", ")}",
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
                                                        character.classLevels.reduce(
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
                                                  character.classList.length &&
                                              (multiclassingPossible(
                                                  CLASSLIST[index]))) {
                                            character.classList
                                                .add(CLASSLIST[index].name);

                                            if ((CLASSLIST[index]
                                                    .gainAtEachLevel[
                                                        character.classLevels[index]]
                                                    .where((element) =>
                                                        element[0] == "Choice")
                                                    .toList())
                                                .isEmpty) {
                                              widgetsInPlay.add(Text(
                                                "No choices needed for ${CLASSLIST[index].name} level ${CLASSLIST[index].gainAtEachLevel[character.classLevels[index]][0][1]}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        Homepage.backingColor),
                                              ));
                                            } else {
                                              widgetsInPlay.add(Text(
                                                "${CLASSLIST[index].name} Level ${CLASSLIST[index].gainAtEachLevel[character.classLevels[index]][0][1]} choice(s):",
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
                                                    character.classLevels[index]]) {
                                              if (x[0] == "Choice") {
                                                widgetsInPlay.add(SizedBox(
                                                    height: 80,
                                                    child: ChoiceRow(
                                                      x: x.sublist(1),
                                                      allSelected: character.allSelected,
                                                    )));
                                              } else {
                                                levelGainParser(
                                                    x, CLASSLIST[index]);
                                              }
                                            }

                                            //level 1 bonuses
                                            if (character.classList.length == 1) {
                                              if (character.extraFeatAtLevel1 ?? false) {
                                                numberOfRemainingFeatOrASIs++;
                                              }
                                              character.maxHealth += CLASSLIST[index]
                                                  .maxHitDiceRoll;
                                              //gain saving throw proficiencies
                                              character.savingThrowProficiencies =
                                                  CLASSLIST[index]
                                                      .savingThrowProficiencies;

                                              //equipmentSelectedFromChoices =
                                              //CLASSLIST[index].equipmentOptions;
                                              character.equipmentSelectedFromChoices
                                                  .addAll(CLASSLIST[index]
                                                      .equipmentOptions);
                                              character.classSkillsSelected = List.filled(
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
                                                        if (character.classSkillsSelected
                                                                .where((b) => b)
                                                                .length <
                                                            CLASSLIST[index]
                                                                .numberOfSkillChoices) {
                                                          character.classSkillsSelected[
                                                                  subIndex] =
                                                              !character.classSkillsSelected[
                                                                  subIndex];
                                                        } else {
                                                          if (character.classSkillsSelected[
                                                              subIndex]) {
                                                            character.classSkillsSelected[
                                                                    subIndex] =
                                                                false;
                                                          }
                                                        }
                                                      });
                                                    },
                                                    isSelected:
                                                        character.classSkillsSelected,
                                                    children: CLASSLIST[index]
                                                        .optionsForSkillProficiencies
                                                        .map((x) => Text(" $x "))
                                                        .toList()),
                                              ]);
                                            } //run if not level 1
                                            else {
                                              if (character.averageHitPoints ?? false) {
                                                character.maxHealth += ((CLASSLIST[index]
                                                            .maxHitDiceRoll) /
                                                        2)
                                                    .ceil();
                                              } else {
                                                character.maxHealth += 1 +
                                                    (Random().nextDouble() *
                                                            CLASSLIST[index]
                                                                .maxHitDiceRoll)
                                                        .floor();
                                              }
                                            }

                                            //check if it's a spellcaster
                                            if (CLASSLIST[index].classType !=
                                                "Martial") {
                                              if (character.classList
                                                      .where((element) =>
                                                          element ==
                                                          CLASSLIST[index].name)
                                                      .length ==
                                                  1) {
                                                character.allSpellsSelectedAsListsOfThings
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
                                                var a = character.classSubclassMapper[
                                                    CLASSLIST[index].name];
                                                for (var x = 0;
                                                    x <
                                                        character.allSpellsSelectedAsListsOfThings
                                                            .length;
                                                    x++) {
                                                  if (character.allSpellsSelectedAsListsOfThings[
                                                          x][0] ==
                                                      CLASSLIST[index].name) {
                                                    character.allSpellsSelectedAsListsOfThings[
                                                            x][2] =
                                                        getSpellsKnown(
                                                            index,
                                                            character.allSpellsSelectedAsListsOfThings[
                                                                x]);
                                                  } else if (a != null) {
                                                    if (character.allSpellsSelectedAsListsOfThings[
                                                            x][0] ==
                                                        a) {
                                                      character.allSpellsSelectedAsListsOfThings[
                                                              x][2] =
                                                          getSpellsKnown(
                                                              index,
                                                              character.allSpellsSelectedAsListsOfThings[
                                                                  x]);
                                                    }
                                                  }
                                                }
                                              }
                                            }

                                            character.classLevels[index]++;
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
                              character.background = BACKGROUNDLIST
                                  .singleWhere((x) => x.name == value);
                              character.backgroundPersonalityTrait =
                                  character.background.personalityTrait.first;
                              character.backgroundIdeal = character.background.ideal.first;
                              character.backgroundBond = character.background.bond.first;
                              character.backgroundFlaw = character.background.flaw.first;
                              character.backgroundSkillChoices = List.filled(
                                      character.background.numberOfSkillChoices ??
                                          0,
                                      true) +
                                  List.filled(
                                      (character.background
                                                  .optionalSkillProficiencies
                                                  ?.length ??
                                              0) -
                                          (character.background
                                                  .numberOfSkillChoices ??
                                              0),
                                      false);
                              character.skillsSelected = Queue<int>.from(
                                  Iterable.generate(
                                      character.background.numberOfSkillChoices ??
                                          0));
                              //
                            });
                          },
                          value: character.background.name,
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
                            character.backgroundPersonalityTrait = character.background
                                .personalityTrait
                                .singleWhere((x) => x == value);
                          });
                        },
                        value: character.backgroundPersonalityTrait,
                        icon: Icon(Icons.arrow_downward,
                            color: Homepage.textColor),
                        items: character.background.personalityTrait
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
                            character.backgroundIdeal = character.background.ideal
                                .singleWhere((x) => x == value);
                          });
                        },
                        value: character.backgroundIdeal,
                        icon: Icon(Icons.arrow_downward,
                            color: Homepage.textColor),
                        items: character.background.ideal
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
                              character.backgroundBond = character.background.bond
                                  .singleWhere((x) => x == value);
                            });
                          },
                          value: character.backgroundBond,
                          icon: Icon(Icons.arrow_downward,
                              color: Homepage.textColor),
                          items: character.background.bond
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
                              character.backgroundFlaw = character.background.flaw
                                  .singleWhere((x) => x == value);
                            });
                          },
                          value: character.backgroundFlaw,
                          icon: Icon(Icons.arrow_downward,
                              color: Homepage.textColor),
                          items: character.background.flaw
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
                  if (character.background.numberOfSkillChoices != null)
                    Text(
                        "Pick ${(character.background.numberOfSkillChoices)} skill(s) to gain proficiency in",
                        style: TextStyle(
                            color: Homepage.backingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 7,
                  ),
                  if (character.background.numberOfSkillChoices != null)
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
                            if (character.skillsSelected!.contains(index)) {
                              character.skillsSelected!.remove(index);
                              character.backgroundSkillChoices[index] = false;
                            } else {
                              if (character.skillsSelected!.length ==
                                  character.background.numberOfSkillChoices) {
                                int removed = character.skillsSelected!.removeFirst();
                                character.backgroundSkillChoices[removed] = false;
                              }
                              character.skillsSelected!.add(index);
                              character.backgroundSkillChoices[index] = true;
                            }
                          });
                        },
                        isSelected: character.backgroundSkillChoices,
                        children: character.background.optionalSkillProficiencies!
                            .map((x) => Text(" $x "))
                            .toList()),
                  /*if (character.background.numberOfSkillChoices != null)
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
                            character.background.numberOfSkillChoices,
                        items: [
                          for (var x
                              in character.background.optionalSkillProficiencies ??
                                  [])
                            MultiSelectCard(value: x, label: x)
                        ],
                        onChange: (allSelectedItems, selectedItem) {}),*/
                  if (character.background.numberOfLanguageChoices != null)
                    Text(
                        "Pick ${(character.background.numberOfLanguageChoices)} language(s) to learn",
                        style: TextStyle(
                            color: Homepage.backingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 7,
                  ),
                  if (character.background.numberOfLanguageChoices != null)
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
                            character.background.numberOfLanguageChoices,
                        items: [
                          for (var x in LANGUAGELIST)
                            MultiSelectCard(value: x, label: x)
                        ],
                        onChange: (allSelectedItems, selectedItem) {
                          if (allSelectedItems.contains(selectedItem)) {
                            character.languagesKnown.add(selectedItem as String);
                          } else {
                            character.languagesKnown.remove(selectedItem as String);
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
                              character.strength.name,
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
                                  character.strength.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < character.strength.value && character.strength.value < 15)
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
                                                if (character.strength.value > 8) {
                                                  character.strength.value--;
                                                  if (character.strength.value < 13) {
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
                                    (character.strength.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              character.strength.value) >
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
                                                if (character.strength.value < 15) {
                                                  if (abilityScoreCost(
                                                          character.strength.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            character.strength.value);
                                                    character.strength.value++;
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
                                                character.strength.value--;
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
                                      " (+${character.raceAbilityScoreIncreases[0]}) ",
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      )),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${character.featsASIScoreIncreases[0]}) ",
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
                                (character.strength.value +
                                        character.raceAbilityScoreIncreases[0] +
                                        character.featsASIScoreIncreases[0])
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
                              character.dexterity.name,
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
                                  character.dexterity.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < character.dexterity.value &&
                                            character.dexterity.value < 15)
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
                                                if (character.dexterity.value > 8) {
                                                  character.dexterity.value--;
                                                  if (character.dexterity.value < 13) {
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
                                    (character.dexterity.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              character.dexterity.value) >
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
                                                if (character.dexterity.value < 15) {
                                                  if (abilityScoreCost(
                                                          character.dexterity.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            character.dexterity.value);
                                                    character.dexterity.value++;
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
                                                character.dexterity.value--;
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
                                    " (+${character.raceAbilityScoreIncreases[1]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${character.featsASIScoreIncreases[1]}) ",
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
                                (character.dexterity.value +
                                        character.raceAbilityScoreIncreases[1] +
                                        character.featsASIScoreIncreases[1])
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
                              character.constitution.name,
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
                                  character.constitution.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < character.constitution.value &&
                                            character.constitution.value < 15)
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
                                                if (character.constitution.value > 8) {
                                                  character.constitution.value--;
                                                  if (character.constitution.value < 13) {
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
                                    (character.constitution.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(character.constitution
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
                                                if (character.constitution.value < 15) {
                                                  if (abilityScoreCost(
                                                          character.constitution.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            character.constitution.value);
                                                    character.constitution.value++;
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
                                                character.constitution.value--;
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
                                    " (+${character.raceAbilityScoreIncreases[2]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${character.featsASIScoreIncreases[2]}) ",
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
                                (character.constitution.value +
                                        character.raceAbilityScoreIncreases[2] +
                                        character.featsASIScoreIncreases[2])
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
                              character.intelligence.name,
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
                                  character.intelligence.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < character.intelligence.value &&
                                            character.intelligence.value < 15)
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
                                                if (character.intelligence.value > 8) {
                                                  character.intelligence.value--;
                                                  if (character.intelligence.value < 13) {
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
                                    (character.intelligence.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(character.intelligence
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
                                                if (character.intelligence.value < 15) {
                                                  if (abilityScoreCost(
                                                          character.intelligence.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            character.intelligence.value);
                                                    character.intelligence.value++;
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
                                                character.intelligence.value--;
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
                                    " (+${character.raceAbilityScoreIncreases[3]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${character.featsASIScoreIncreases[3]}) ",
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
                                (character.intelligence.value +
                                        character.raceAbilityScoreIncreases[3] +
                                        character.featsASIScoreIncreases[3])
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
                              character.wisdom.name,
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
                                  character.wisdom.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < character.wisdom.value && character.wisdom.value < 15)
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
                                                if (character.wisdom.value > 8) {
                                                  character.wisdom.value--;
                                                  if (character.wisdom.value < 13) {
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
                                    (character.wisdom.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              character.wisdom.value) >
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
                                                if (character.wisdom.value < 15) {
                                                  if (abilityScoreCost(
                                                          character.wisdom.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            character.wisdom.value);
                                                    character.wisdom.value++;
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
                                                character.wisdom.value--;
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
                                    " (+${character.raceAbilityScoreIncreases[4]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${character.featsASIScoreIncreases[4]}) ",
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
                                (character.wisdom.value +
                                        character.raceAbilityScoreIncreases[4] +
                                        character.featsASIScoreIncreases[4])
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
                              character.charisma.name,
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
                                  character.charisma.value.toString(),
                                  style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700,
                                      color: Homepage.textColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (8 < character.charisma.value && character.charisma.value < 15)
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
                                                if (character.charisma.value > 8) {
                                                  character.charisma.value--;
                                                  if (character.charisma.value < 13) {
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
                                    (character.charisma.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              character.charisma.value) >
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
                                                if (character.charisma.value < 15) {
                                                  if (abilityScoreCost(
                                                          character.charisma.value) <=
                                                      pointsRemaining) {
                                                    pointsRemaining -=
                                                        abilityScoreCost(
                                                            character.charisma.value);
                                                    character.charisma.value++;
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
                                                character.charisma.value--;
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
                                    " (+${character.raceAbilityScoreIncreases[5]}) ",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    " (+${character.featsASIScoreIncreases[5]}) ",
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
                                (character.charisma.value +
                                        character.raceAbilityScoreIncreases[5] +
                                        character.featsASIScoreIncreases[5])
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
                                  if (remainingAsi)
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
                                            "+${character.featsASIScoreIncreases[0]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!remainingAsi &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(character.strength.value +
                                                                character.featsASIScoreIncreases[0] <
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
                                                  if (character.strength.value +
                                                          character.featsASIScoreIncreases[0] <
                                                      20) {
                                                    if (remainingAsi) {
                                                      remainingAsi = false;
                                                      character.featsASIScoreIncreases[0]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      remainingAsi = true;
                                                      character.featsASIScoreIncreases[0]++;
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
                                            "+${character.featsASIScoreIncreases[3]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!remainingAsi &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(character.intelligence.value +
                                                                character.featsASIScoreIncreases[3] <
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
                                                  if (character.intelligence.value +
                                                          character.featsASIScoreIncreases[3] <
                                                      20) {
                                                    if (remainingAsi) {
                                                      remainingAsi = false;
                                                      character.featsASIScoreIncreases[3]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      remainingAsi = true;
                                                      character.featsASIScoreIncreases[3]++;
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
                                            "+${character.featsASIScoreIncreases[1]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: ((!remainingAsi &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0) ||
                                                        !(character.dexterity.value +
                                                                character.featsASIScoreIncreases[1] <
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
                                                  if (character.dexterity.value +
                                                          character.featsASIScoreIncreases[1] <
                                                      20) {
                                                    if (remainingAsi) {
                                                      remainingAsi = false;
                                                      character.featsASIScoreIncreases[1]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      remainingAsi = true;
                                                      character.featsASIScoreIncreases[1]++;
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
                                            "+${character.featsASIScoreIncreases[4]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!remainingAsi &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(character.wisdom.value +
                                                                character.featsASIScoreIncreases[4] <
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
                                                  if (character.wisdom.value +
                                                          character.featsASIScoreIncreases[4] <
                                                      20) {
                                                    if (remainingAsi) {
                                                      remainingAsi = false;
                                                      character.featsASIScoreIncreases[4]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      remainingAsi = true;
                                                      character.featsASIScoreIncreases[4]++;
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
                                            "+${character.featsASIScoreIncreases[2]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!remainingAsi &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(character.constitution.value +
                                                                character.featsASIScoreIncreases[2] <
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
                                                  if (character.constitution.value +
                                                          character.featsASIScoreIncreases[2] <
                                                      20) {
                                                    if (remainingAsi) {
                                                      remainingAsi = false;
                                                      character.featsASIScoreIncreases[2]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      remainingAsi = true;
                                                      character.featsASIScoreIncreases[2]++;
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
                                            "+${character.featsASIScoreIncreases[5]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: Homepage.textColor),
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: (!remainingAsi &&
                                                            numberOfRemainingFeatOrASIs ==
                                                                0 ||
                                                        !(character.charisma.value +
                                                                character.featsASIScoreIncreases[5] <
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
                                                  if (character.charisma.value +
                                                          character.featsASIScoreIncreases[5] <
                                                      20) {
                                                    if (remainingAsi) {
                                                      remainingAsi = false;
                                                      character.featsASIScoreIncreases[5]++;
                                                    } else if (numberOfRemainingFeatOrASIs >
                                                        0) {
                                                      numberOfRemainingFeatOrASIs--;
                                                      remainingAsi = true;
                                                      character.featsASIScoreIncreases[5]++;
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
                      if (character.featsAllowed ?? false)
                        Expanded(
                            child: SizedBox(
                                height: 550,
                                child: Column(
                                  children: [
                                    if (character.featsSelected.isNotEmpty)
                                      Text(
                                          "${character.featsSelected.length} Feats selected:",
                                          style: TextStyle(
                                              color: Homepage.backingColor,
                                              fontSize: 33,
                                              fontWeight: FontWeight.w800)),
                                    if (character.featsSelected.isNotEmpty)
                                      SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: character.featsSelected.length,
                                            itemBuilder: (context, index) {
                                              return OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white),
                                                onPressed: () {},
                                                child: Text(
                                                    character.featsSelected[index][0]
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
                                                      backgroundColor: (character.featsSelected
                                                              .where((element) =>
                                                                  element[0].name ==
                                                                  FEATLIST[index]
                                                                      .name)
                                                              .isNotEmpty)
                                                          ? Color.fromARGB(
                                                              100 +
                                                                  (((character.featsSelected.where((element) => element[0].name == FEATLIST[index].name).length) / FEATLIST[index].numberOfTimesTakeable) * 155)
                                                                      .ceil(),
                                                              0,
                                                              50 +
                                                                  (((character.featsSelected.where((element) => element[0].name == FEATLIST[index].name).length) / FEATLIST[index].numberOfTimesTakeable) *
                                                                          205)
                                                                      .ceil(),
                                                              0)
                                                          : Colors.white),
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        if (numberOfRemainingFeatOrASIs >
                                                            0) {
                                                          if (character.featsSelected
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
                                                            character.featsSelected.add([
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
                                                                              character.allSelected,
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
                if (character.allSpellsSelected
                    .where((element) => element.level == 0)
                    .toList()
                    .isNotEmpty)
                  const Text("Cantrips:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 0)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 0)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
                                .where((element) => element.level == 0)
                                .toList()[index]
                                .name),
                          );
                        },
                      )),
                if (character.allSpellsSelected
                    .where((element) => element.level == 1)
                    .toList()
                    .isNotEmpty)
                  const Text("Level 1 Spells:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 1)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 1)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
                                .where((element) => element.level == 1)
                                .toList()[index]
                                .name),
                          );
                        },
                      )),
                if (character.allSpellsSelected
                    .where((element) => element.level == 2)
                    .toList()
                    .isNotEmpty)
                  const Text("Level 2 Spells:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 2)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 2)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
                                .where((element) => element.level == 2)
                                .toList()[index]
                                .name),
                          );
                        },
                      )),
                if (character.allSpellsSelected
                    .where((element) => element.level == 3)
                    .toList()
                    .isNotEmpty)
                  const Text("Level 3 Spells:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 3)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 3)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
                                .where((element) => element.level == 3)
                                .toList()[index]
                                .name),
                          );
                        },
                      )),
                if (character.allSpellsSelected
                    .where((element) => element.level == 4)
                    .toList()
                    .isNotEmpty)
                  const Text("Level 4 Spells:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 4)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 4)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
                                .where((element) => element.level == 4)
                                .toList()[index]
                                .name),
                          );
                        },
                      )),
                if (character.allSpellsSelected
                    .where((element) => element.level == 5)
                    .toList()
                    .isNotEmpty)
                  const Text("Level 5 Spells:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 5)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 5)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
                                .where((element) => element.level == 5)
                                .toList()[index]
                                .name),
                          );
                        },
                      )),
                if (character.allSpellsSelected
                    .where((element) => element.level == 6)
                    .toList()
                    .isNotEmpty)
                  const Text("Level 6 Spells:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 6)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 6)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
                                .where((element) => element.level == 6)
                                .toList()[index]
                                .name),
                          );
                        },
                      )),
                if (character.allSpellsSelected
                    .where((element) => element.level == 7)
                    .toList()
                    .isNotEmpty)
                  const Text("Level 7 Spells:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 7)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 7)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
                                .where((element) => element.level == 7)
                                .toList()[index]
                                .name),
                          );
                        },
                      )),
                if (character.allSpellsSelected
                    .where((element) => element.level == 8)
                    .toList()
                    .isNotEmpty)
                  const Text("Level 8 Spells:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 8)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 8)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
                                .where((element) => element.level == 8)
                                .toList()[index]
                                .name),
                          );
                        },
                      )),
                if (character.allSpellsSelected
                    .where((element) => element.level == 9)
                    .toList()
                    .isNotEmpty)
                  const Text("Level 9 Spells:"),
                if (character.allSpellsSelected
                    .where((element) => element.level == 9)
                    .toList()
                    .isNotEmpty)
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: character.allSpellsSelected
                            .where((element) => element.level == 9)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(character.allSpellsSelected
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
                  children: character.allSpellsSelectedAsListsOfThings
                      .map((s) => SpellSelections(character.allSpellsSelected, s))
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
                                    "You have ${character.currency["Platinum Pieces"]} platinum, ${character.currency["Gold Pieces"]} gold, ${character.currency["Electrum Pieces"]} electrum, ${character.currency["Silver Pieces"]} silver and ${character.currency["Copper Pieces"]} copper pieces to spend",
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
                                              (character.armourList.length == 4)
                                                  ? Homepage.backingColor
                                                  : const Color.fromARGB(
                                                      247, 56, 53, 52)),
                                      onPressed: () {
                                        setState(() {
                                          if (character.armourList.length == 4) {
                                            character.armourList.clear();
                                          } else {
                                            character.armourList = [
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
                                                            (character.armourList.contains(
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
                                                        if (character.armourList.contains(
                                                            "Light")) {
                                                          character.armourList
                                                              .remove("Light");
                                                        } else {
                                                          character.armourList
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
                                                          backgroundColor: (character.armourList
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
                                                          if (character.armourList
                                                              .contains(
                                                                  "Medium")) {
                                                            character.armourList.remove(
                                                                "Medium");
                                                          } else {
                                                            character.armourList
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
                                                            (character.armourList.contains(
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
                                                        if (character.armourList.contains(
                                                            "Heavy")) {
                                                          character.armourList
                                                              .remove("Heavy");
                                                        } else {
                                                          character.armourList
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
                                                          backgroundColor: (character.armourList
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
                                                          if (character.armourList
                                                              .contains(
                                                                  "Shield")) {
                                                            character.armourList.remove(
                                                                "Shield");
                                                          } else {
                                                            character.armourList
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
                                              (character.weaponList.length == 2)
                                                  ? Homepage.backingColor
                                                  : const Color.fromARGB(
                                                      247, 56, 53, 52)),
                                      onPressed: () {
                                        setState(() {
                                          if (character.weaponList.length == 2) {
                                            character.weaponList.clear();
                                          } else {
                                            character.weaponList = ["Ranged", "Melee"];
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
                                                            (character.weaponList.contains(
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
                                                        if (character.weaponList.contains(
                                                            "Ranged")) {
                                                          character.weaponList
                                                              .remove("Ranged");
                                                        } else {
                                                          character.weaponList
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
                                                          backgroundColor: (character.weaponList
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
                                                          if (character.weaponList
                                                              .contains(
                                                                  "Melee")) {
                                                            character.weaponList.remove(
                                                                "Melee");
                                                          } else {
                                                            character.weaponList
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
                                              (character.itemList.length == 2)
                                                  ? Homepage.backingColor
                                                  : const Color.fromARGB(
                                                      247, 56, 53, 52)),
                                      onPressed: () {
                                        setState(() {
                                          if (character.itemList.length == 2) {
                                            character.itemList.clear();
                                          } else {
                                            character.itemList = [
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
                                                        backgroundColor: (character.itemList
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
                                                        if (character.itemList.contains(
                                                            "Stackable")) {
                                                          character.itemList.remove(
                                                              "Stackable");
                                                        } else {
                                                          character.itemList
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
                                                          backgroundColor: (character.itemList
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
                                                          if (character.itemList.contains(
                                                              "Unstackable")) {
                                                            character.itemList.remove(
                                                                "Unstackable");
                                                          } else {
                                                            character.itemList.add(
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
                                                      ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) ||
                                                          (element.equipmentType.contains("Weapon") &&
                                                              element.equipmentType
                                                                  .any((item) =>
                                                                      character.weaponList.contains(
                                                                          item))) ||
                                                          (element.equipmentType
                                                                  .contains(
                                                                      "Item") &&
                                                              ((character.itemList.contains("Stackable") && element.stackable) ||
                                                                  (character.itemList.contains("Unstackable") &&
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
                                                              ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) ||
                                                                  (element.equipmentType.contains("Weapon") &&
                                                                      element
                                                                          .equipmentType
                                                                          .any((item) => character.weaponList.contains(
                                                                              item))) ||
                                                                  (element.equipmentType
                                                                          .contains(
                                                                              "Item") &&
                                                                      ((character.itemList.contains("Stackable") && element.stackable) ||
                                                                          (character.itemList.contains("Unstackable") &&
                                                                              !element
                                                                                  .stackable)))) &&
                                                              element.cost[1] ==
                                                                  coinTypeSelected)
                                                          .toList()[index]
                                                          .cost[0] <=
                                                      character.currency[
                                                          "${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => character.weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((character.itemList.contains("Stackable") && element.stackable) || (character.itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[1]} Pieces"]) {
                                                    character.currency[
                                                        "${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => character.weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((character.itemList.contains("Stackable") && element.stackable) || (character.itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[1]} Pieces"] = character.currency[
                                                            "${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => character.weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((character.itemList.contains("Stackable") && element.stackable) || (character.itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[1]} Pieces"]! -
                                                        (ITEMLIST
                                                            .where((element) =>
                                                                ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) ||
                                                                    (element.equipmentType.contains("Weapon") &&
                                                                        element
                                                                            .equipmentType
                                                                            .any((item) => character.weaponList.contains(
                                                                                item))) ||
                                                                    (element.equipmentType.contains("Item") &&
                                                                        ((character.itemList.contains("Stackable") && element.stackable) ||
                                                                            (character.itemList.contains("Unstackable") && !element.stackable)))) &&
                                                                element.cost[1] == coinTypeSelected)
                                                            .toList()[index]
                                                            .cost[0] as int);
                                                    if (ITEMLIST
                                                        .where((element) =>
                                                            ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) ||
                                                                (element.equipmentType
                                                                        .contains(
                                                                            "Weapon") &&
                                                                    element
                                                                        .equipmentType
                                                                        .any((item) =>
                                                                            character.weaponList.contains(
                                                                                item))) ||
                                                                (element.equipmentType
                                                                        .contains(
                                                                            "Item") &&
                                                                    ((character.itemList.contains("Stackable") && element.stackable) ||
                                                                        (character.itemList.contains("Unstackable") &&
                                                                            !element
                                                                                .stackable)))) &&
                                                            element.cost[1] ==
                                                                coinTypeSelected)
                                                        .toList()[index]
                                                        .stackable) {
                                                      if (character.stackableEquipmentSelected.containsKey(ITEMLIST
                                                          .where((element) =>
                                                              ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) ||
                                                                  (element.equipmentType.contains("Weapon") &&
                                                                      element.equipmentType.any((item) =>
                                                                          character.weaponList.contains(
                                                                              item))) ||
                                                                  (element.equipmentType.contains(
                                                                          "Item") &&
                                                                      ((character.itemList.contains("Stackable") && element.stackable) ||
                                                                          (character.itemList.contains("Unstackable") &&
                                                                              !element
                                                                                  .stackable)))) &&
                                                              element.cost[1] ==
                                                                  coinTypeSelected)
                                                          .toList()[index]
                                                          .name)) {
                                                        character.stackableEquipmentSelected[ITEMLIST
                                                            .where((element) =>
                                                                ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => character.weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((character.itemList.contains("Stackable") && element.stackable) || (character.itemList.contains("Unstackable") && !element.stackable)))) &&
                                                                element.cost[1] ==
                                                                    coinTypeSelected)
                                                            .toList()[index]
                                                            .name] = character.stackableEquipmentSelected[ITEMLIST
                                                                .where((element) =>
                                                                    ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) ||
                                                                        (element.equipmentType.contains("Weapon") &&
                                                                            element.equipmentType.any((item) => character.weaponList.contains(item))) ||
                                                                        (element.equipmentType.contains("Item") && ((character.itemList.contains("Stackable") && element.stackable) || (character.itemList.contains("Unstackable") && !element.stackable)))) &&
                                                                    element.cost[1] == coinTypeSelected)
                                                                .toList()[index]
                                                                .name]! +
                                                            1;
                                                        //add it in
                                                      } else {
                                                        character.stackableEquipmentSelected[ITEMLIST
                                                            .where((element) =>
                                                                ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) ||
                                                                    (element.equipmentType.contains(
                                                                            "Weapon") &&
                                                                        element.equipmentType.any((item) =>
                                                                            character.weaponList.contains(
                                                                                item))) ||
                                                                    (element.equipmentType.contains(
                                                                            "Item") &&
                                                                        ((character.itemList.contains("Stackable") && element.stackable) ||
                                                                            (character.itemList.contains("Unstackable") &&
                                                                                !element
                                                                                    .stackable)))) &&
                                                                element.cost[1] ==
                                                                    coinTypeSelected)
                                                            .toList()[index]
                                                            .name] = 1;
                                                      }
                                                    } else {
                                                      character.unstackableEquipmentSelected.add(ITEMLIST
                                                          .where((element) =>
                                                              ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) ||
                                                                  (element.equipmentType.contains("Weapon") &&
                                                                      element.equipmentType.any((item) =>
                                                                          character.weaponList.contains(
                                                                              item))) ||
                                                                  (element.equipmentType.contains(
                                                                          "Item") &&
                                                                      ((character.itemList.contains("Stackable") && element.stackable) ||
                                                                          (character.itemList.contains("Unstackable") &&
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
                                                  "${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => character.weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((character.itemList.contains("Stackable") && element.stackable) || (character.itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].name}: ${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => character.weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((character.itemList.contains("Stackable") && element.stackable) || (character.itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[0]}x${ITEMLIST.where((element) => ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => character.armourList.contains(item))) || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => character.weaponList.contains(item))) || (element.equipmentType.contains("Item") && ((character.itemList.contains("Stackable") && element.stackable) || (character.itemList.contains("Unstackable") && !element.stackable)))) && element.cost[1] == coinTypeSelected).toList()[index].cost[1]}",
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
                              if (character.equipmentSelectedFromChoices != [])
                                SizedBox(
                                  height: 300,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: /*[const Text(
                                                          "Please choose between the following options:"),...*/
                                          [
                                        for (var i = 0;
                                            i <
                                                character.equipmentSelectedFromChoices
                                                    .length;
                                            i++)
                                          (character.equipmentSelectedFromChoices[i]
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
                                                            character.equipmentSelectedFromChoices[
                                                                i] = [
                                                              character.equipmentSelectedFromChoices[
                                                                  i][0]
                                                            ];
                                                          });
                                                        },
                                                        child: Text(
                                                          produceEquipmentOptionDescription(
                                                              character.equipmentSelectedFromChoices[
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
                                                            character.equipmentSelectedFromChoices[
                                                                i] = [
                                                              character.equipmentSelectedFromChoices[
                                                                  i][1]
                                                            ];
                                                          });
                                                        },
                                                        child: Text(
                                                          produceEquipmentOptionDescription(
                                                              character.equipmentSelectedFromChoices[
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
                                                      character.equipmentSelectedFromChoices[
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
                                  character.characterDescription.age = characterAgeEnteredValue;
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
                                  character.characterDescription.eyes = characterEyeEnteredValue;
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
                                  character.characterDescription.height = characterHeightEnteredValue;
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
                                  character.characterDescription.skin = characterSkinEnteredValue;
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
                                  character.characterDescription.weight = characterWeightEnteredValue;
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
                                  character.characterDescription.hair = characterHairEnteredValue;
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
                          character.characterDescription.backstory = backstoryEnteredValue;
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
                          character.extraFeatures = extraFeaturesEnteredValue;
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
                          character: character),
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
                                    character.group = value!;
                                  });
                                },
                                value: GROUPLIST.contains(character.group) ? character.group : null,
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
                                    character.group = groupNameEnteredValue;
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
                                          !remainingAsi &&
                                          int.parse(characterLevel ?? "1") <=
                                              character.classList.length &&
                                          (character.equipmentSelectedFromChoices == [] ||
                                              character.equipmentSelectedFromChoices
                                                  .where((element) =>
                                                      element.length == 2)
                                                  .toList()
                                                  .isEmpty) &&
                                          (character.allSpellsSelectedAsListsOfThings
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
                                      !remainingAsi &&
                                      int.parse(characterLevel ?? "1") <=
                                          character.classList.length &&
                                      (character.equipmentSelectedFromChoices == [] ||
                                          character.equipmentSelectedFromChoices
                                              .where((element) =>
                                                  element.length == 2)
                                              .toList()
                                              .isEmpty) &&
                                      (character.allSpellsSelectedAsListsOfThings
                                          .where((element) => element[2] != 0)
                                          .isEmpty)) {
                                    setState(() {
                                      CHARACTERLIST.add(character);
                                      if ((!GROUPLIST.contains(character.group)) &&
                                          character.group != null &&
                                          character.group!.replaceAll(" ", "") != "") {
                                        GROUPLIST.add(character.group!);
                                      }
                                      saveChanges();
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
                      (character.characterDescription.name.replaceAll(" ", "") != "" &&
                              character.characterDescription.gender.replaceAll(" ", "") != "" &&
                              character.playerName.replaceAll(" ", "") != "" &&
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
                          ? (remainingAsi == false)
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
                      (int.parse(characterLevel ?? "1") <= character.classList.length)
                          ? const Text("Made all level selections",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))
                          : Text(
                              "${int.parse(characterLevel ?? "1") - character.classList.length} unused levels",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      //Equipment
                      (character.equipmentSelectedFromChoices == [] ||
                              character.equipmentSelectedFromChoices
                                  .where((element) => element.length == 2)
                                  .toList()
                                  .isEmpty)
                          ? const Text("Made all equipment selections",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))
                          : Text(
                              "Missed ${character.equipmentSelectedFromChoices.where((element) => element.length == 2).toList().length} equipment choice(s)",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      //spells
                      //if the user has multiple classes with spells

                      //All spell sections have 0 remaining options (all spells selected)
                      (character.allSpellsSelectedAsListsOfThings
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
                          : (character.allSpellsSelectedAsListsOfThings.length == 1)
                              //if they only have 1 way to choose spells (as the reduce only works on lists of length >1,
                              // otherwise it just returns the whole element which would break the code)
                              ? Text(
                                  //number remaining
                                  "Missed ${(character.allSpellsSelectedAsListsOfThings[0][2])} spells",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700))
                              : Text(
                                  //number remaining with multiple ways to choose spells
                                  "Missed ${(character.allSpellsSelectedAsListsOfThings.reduce((a, b) => a[2] + b[2]) as int)} spells",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700)),

                      const SizedBox(height: 20),
                      (character.characterDescription.age.replaceAll(" ", "") != "" &&
                              character.characterDescription.height.replaceAll(" ", "") != "" &&
                              character.characterDescription.weight.replaceAll(" ", "") != "" &&
                              character.characterDescription.eyes.replaceAll(" ", "") != "" &&
                              character.characterDescription.skin.replaceAll(" ", "") != "" &&
                              character.characterDescription.hair.replaceAll(" ", "") != "" &&
                              character.characterDescription.backstory.replaceAll(" ", "") != "" &&
                              character.extraFeatures.replaceAll(" ", "") != "")
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

  Tab tabLabel(String label) {
    return Tab(child: Text(label, style: TextStyle(color: Homepage.textColor)));
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
    if (character.classList.isEmpty) {
      return true;
    }
    if (!(character.multiclassing ?? false)) {
      return false;
    }
    List<int> requirements = selectedClass.multiclassingRequirements;
    //check if they already have a level in the class
    if (character.classList.contains(selectedClass.name)) {
      return true;
    }
    //check the class they want to take
    int count = 0;
    if (character.strength.value + character.raceAbilityScoreIncreases[0] + character.featsASIScoreIncreases[0] >=
        requirements[0]) count++;
    if (character.dexterity.value + character.raceAbilityScoreIncreases[1] + character.featsASIScoreIncreases[1] >=
        requirements[1]) count++;
    if (character.constitution.value + character.raceAbilityScoreIncreases[2] + character.featsASIScoreIncreases[2] >=
        requirements[2]) count++;
    if (character.intelligence.value + character.raceAbilityScoreIncreases[3] + character.featsASIScoreIncreases[3] >=
        requirements[3]) count++;
    if (character.wisdom.value + character.raceAbilityScoreIncreases[4] + character.featsASIScoreIncreases[4] >=
        requirements[4]) count++;
    if (character.charisma.value + character.raceAbilityScoreIncreases[5] + character.featsASIScoreIncreases[5] >=
        requirements[5]) count++;

    if (count < requirements[6]) {
      return false;
    }
    //check all other classes they have a level in
    for (var i = 0; i < character.classList.length; i++) {
      requirements = CLASSLIST
          .firstWhere((element) => element.name == character.classList[i])
          .multiclassingRequirements;
      int count = 0;
      if (character.strength.value + character.raceAbilityScoreIncreases[0] + character.featsASIScoreIncreases[0] >=
          requirements[0]) count++;
      if (character.dexterity.value + character.raceAbilityScoreIncreases[1] + character.featsASIScoreIncreases[1] >=
          requirements[1]) count++;
      if (character.constitution.value + character.raceAbilityScoreIncreases[2] + character.featsASIScoreIncreases[2] >=
          requirements[2]) count++;
      if (character.intelligence.value + character.raceAbilityScoreIncreases[3] + character.featsASIScoreIncreases[3] >=
          requirements[3]) count++;
      if (character.wisdom.value + character.raceAbilityScoreIncreases[4] + character.featsASIScoreIncreases[4] >=
          requirements[4]) count++;
      if (character.charisma.value + character.raceAbilityScoreIncreases[5] + character.featsASIScoreIncreases[5] >=
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
      character.featuresAndTraits.add(x[1] + ": " + x[2]);
    } else if (x[0] == "AC") {
      // ("AC","intelligence + 2", "RQUIREMENT")
      character.ACList.add([x[1], x[2]]);
    } else if (x[0] == "Speed") {
      //note base speed is given by race
      //("speed", (w/s/c/f/h), numb/expression")
      character.speedBonuses[x[1]]?.add(x[2]);
    } else if (x[0] == "AttributeBoost") {
      if (x[1] == "Intelligence") {
        character.intelligence.value += int.parse(x[2]);
      } else if (x[1] == "Strength") {
        character.strength.value += int.parse(x[2]);
      } else if (x[1] == "Constitution") {
        character.constitution.value += int.parse(x[2]);
      } else if (x[1] == "Dexterity") {
        character.dexterity.value += int.parse(x[2]);
      } else if (x[1] == "Wisdom") {
        character.wisdom.value += int.parse(x[2]);
      } else if (x[1] == "charisma") {
        character.charisma.value += int.parse(x[2]);
      }
      //do this later
    } else if (x[0] == "Gained") {
      character.skillBonusMap[x[1]] = character.skillBonusMap[x[1]]! + int.parse(x[2]);
      //do this later
    } else if (x[0] == "ASI") {
      numberOfRemainingFeatOrASIs++;
    }
    //TODO(Implement further parsing for: proficiencies, languages, equipment )

    /*else if (x[0] == "Equipment") {
    //note base speed is given by race
    //("speed", "10", "(w/s/c/f)")
    SPEEDLIST.append([x[1], x[2]]);
  }*/
    else if (x[0] == "Money") {
      //("Money", "Copper Pieces", "10")
      character.currency[x[1]] = character.currency[x[1]]! + int.parse(x[2]);
    }
    return null;
  }

  int levelZeroGetSpellsKnown(int index) {
    if (CLASSLIST[index].spellsKnownFormula == null) {
      return CLASSLIST[index].spellsKnownPerLevel![character.classLevels[index]];
    }
    //decode as zero
    return 3;
  }

  int getSpellsKnown(int index, List<dynamic> thisStuff) {
    if (CLASSLIST[index].spellsKnownFormula == null) {
      return (CLASSLIST[index].spellsKnownPerLevel![character.classLevels[index]] -
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
