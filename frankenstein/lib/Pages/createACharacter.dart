import 'package:flutter/material.dart';
import "package:frankenstein/globals.dart";

int abilityScoreCost(int x) {
  if (x > 12) {
    return 2;
  }
  return 1;
}

Spell listgetter(String spellname) {
  //huge issue with adding content WITH DUPLICATE NAME AND (TYPE)
  for (int x = 0; x < list.length; x++) {
    if (list[x].name == spellname) {
      return list[x];
    }
  }
  //ADD SOMETHING FOR FAILED COMPARISONS
  ///fix really  really really
  return list[0];
} //}

class AbilityScore {
  int value;
  String name;

  AbilityScore({required this.name, required this.value});
}

class CreateACharacter extends StatefulWidget {
  @override
  MainCreateCharacter createState() => MainCreateCharacter();
}

//null op here to locate if called by editor (to edit char so will contain info) or otherwise
class MainCreateCharacter extends State<CreateACharacter> {
  AbilityScore strength = AbilityScore(name: "Strength", value: 8);
  AbilityScore dexterity = AbilityScore(name: "Dexterity", value: 8);
  AbilityScore constitution = AbilityScore(name: "Constitution", value: 8);
  AbilityScore intelligence = AbilityScore(name: "Intelligence", value: 8);
  AbilityScore wisdom = AbilityScore(name: "Wisdom", value: 8);
  AbilityScore charisma = AbilityScore(name: "Charisma", value: 8);
  int pointsRemaining = 27;
  //STR/DEX/CON/INT/WIS/CHAR

  //const MainCreateCharacter({Key? key}) //: super(key: key);
  Spell spellExample = list.first;
  String? levellingMethod;
  Race initialRace = RACELIST.first;
  List<int> abilityScoreIncreases = RACELIST.first.raceScoreIncrease;
  Subrace? subraceExample;

  //options in the initial menu initialised

  bool? featsAllowed = false;
  bool? averageHitPoints = false;
  bool? multiclassing = false;
  bool? milestoneLevelling = false;
  bool? myCustomContent = false;
  bool? optionalClassFeatures = false;
  bool? criticalRoleContent = false;
  bool? encumberanceRules = false;
  bool? includeCoinsForWeight = false;
  bool? unearthedArcanaContent = false;
  bool? firearmsUsable = false;
  bool? extraFeatAtLevel1 = false;
  String? characterLevel = "1";
  List<List<bool>>? optionalOnesStates = [
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false]
  ];
  List<List<bool>>? optionalTwosStates = [
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false]
  ];
  List<Widget> mystery1slist = [];
  List<Widget> mystery2slist = [];
  //List<Widget> listings =List<Widget>.filled(RACELIST.first.mystery1S, const Text("jklfjkgj"));
  List<bool> isSelected = [false, false, false, false, false, false];
  @override
  initState() {
    // this is called when the class is initialized or called for the first time
    super.initState();

    // this is the material super constructor for init state to link your instance initState to the global initState context
  }

  @override
  Widget build(BuildContext context) {
    mystery1slist = [
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
    mystery2slist = [
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
      length: 10,
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
              Tab(child: Text("Spells")),
              Tab(child: Text("Equipment")),
              Tab(child: Text("Boons and magic items")),
              Tab(child: Text("Backstory")),
              Tab(child: Text("Finishing up")),
            ],
          ),
        ),
        body: TabBarView(children: [
          //basics
          Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                children: [
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
                        const SizedBox(
                            width: 250,
                            height: 50,
                            child: TextField(
                                cursorColor: Colors.blue,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Enter character's name",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 208, 224)),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 124, 112, 112),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)))))),
                        //ask level or exp
                        //add switch + list tittle stuff for lvl/exp
                        const SizedBox(height: 15),
                        const SizedBox(
                            width: 250,
                            height: 50,
                            child: TextField(
                                cursorColor: Colors.blue,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Enter the player's name",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 208, 224)),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 124, 112, 112),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)))))),
                        const SizedBox(height: 15),
                        const SizedBox(
                            width: 250,
                            height: 50,
                            child: TextField(
                                cursorColor: Colors.blue,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Enter the character's gender",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 208, 224)),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                              title: const Text("Use levels"),
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
                                                  fontWeight: FontWeight.w800,
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
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
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
                              value: myCustomContent,
                              onChanged: (bool? value) {
                                setState(() {
                                  myCustomContent = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Use optional class features'),
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
                              title: const Text('Use critical role content'),
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
                              title: const Text('Give an extra feat at lvl 1'),
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
          ),
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

                    /*
                    for (int i = 0; i < 6; i++) {
                      abilityScoreIncreases[i] -=
                          (initialRace.raceScoreIncrease[i] +
                              ((subraceExample?.subRaceScoreIncrease[i]) ?? 0));
                    }
*/
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
              initialRace.mystery1S + (subraceExample?.mystery1S ?? 0) == 0
                  ? const SizedBox(height: 0)
                  : Expanded(
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
          Column(children: [
            DropdownButton<String>(
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  spellExample = listgetter(value!);
                });
              },
              value: spellExample.name,
              icon: const Icon(Icons.arrow_downward),
              items: list.map<DropdownMenuItem<String>>((Spell value) {
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
            DropdownButton<String>(
              value: characterLevel,
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
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: Text(value)),
                );
              }).toList(),
            )
          ]),
          const Icon(Icons.directions_bike),
          //ability scores
          Column(children: [
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                          backgroundColor: (abilityScoreCost(
                                                      strength.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                (8 < dexterity.value && dexterity.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                          backgroundColor: (abilityScoreCost(
                                                      dexterity.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                          backgroundColor: (abilityScoreCost(
                                                      constitution.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                          backgroundColor: (abilityScoreCost(
                                                      intelligence.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                              (abilityScoreCost(wisdom.value) >
                                                      pointsRemaining)
                                                  ? const Color.fromARGB(
                                                      247, 56, 53, 52)
                                                  : const Color.fromARGB(
                                                      150, 61, 33, 243),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
                                          backgroundColor: (abilityScoreCost(
                                                      charisma.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
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
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
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
          ]),
          //spells
          const Icon(Icons.directions_car),
          const Icon(Icons.directions_car),
          const Icon(Icons.directions_transit),
          const Icon(Icons.directions_bike),
          const Icon(Icons.directions_car),
        ]),
      ),
    );
  }
}
