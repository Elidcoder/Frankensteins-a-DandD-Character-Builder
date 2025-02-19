// External Imports
import 'package:flutter/material.dart';

// Project Imports
import '../content_classes/all_content_classes.dart';

// TODO(MODIFY THE IMPELEMTNATION OF SPELL SELECTION TO BE SPELL SLOT DEPENDENT)

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
