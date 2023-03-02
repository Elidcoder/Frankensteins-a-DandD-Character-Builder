import 'package:flutter/material.dart';
//import 'package:frankenstein/character_creation_globals.dart';
import 'package:frankenstein/SRD_globals.dart';
import "dart:collection";
import 'package:frankenstein/character_globals.dart';
import 'package:frankenstein/PDFdocs/pdf_final_display.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:frankenstein/pages/create_a_character.dart';
import 'package:frankenstein/main.dart';

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

class Edittop extends StatelessWidget {
  final Character character;
  const Edittop(this.character, {Key? key}) : super(key: key);
  //String jsonString = File(filepath).readAsStringSync();
  //late final Map<String, dynamic> jsonmap = decoder.convert(jsonString);

  static const String _title = 'Frankenstein\'s - a D&D 5e character builder';

  @override
  Widget build(BuildContext context) {
    updateGlobals();
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.home),
              tooltip: "Return to the main menu",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ScreenTop(pagechoice: "Main Menu")));
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
        body: EditACharacter(
          character: character,
        ),
      ),
    );
  }
}

class EditACharacter extends StatefulWidget {
  final Character character;

  EditACharacter({Key? key, required this.character}) : super(key: key);
  @override
  EditCharacter createState() => EditCharacter(character: character);
}

//null op here to locate if called by editor (to edit char so will contain info) or otherwise
class EditCharacter extends State<EditACharacter> {
  //random stsuff

  final Character character;

  EditCharacter({required this.character});
  int level = 0;
  double experience = 0;
  String? experienceIncrease;
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

  //Class variables initialised
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

  //Ability score variables initialised
  AbilityScore strength = AbilityScore(name: "Strength", value: 8);
  AbilityScore dexterity = AbilityScore(name: "Dexterity", value: 8);
  AbilityScore constitution = AbilityScore(name: "Constitution", value: 8);
  AbilityScore intelligence = AbilityScore(name: "Intelligence", value: 8);
  AbilityScore wisdom = AbilityScore(name: "Wisdom", value: 8);
  AbilityScore charisma = AbilityScore(name: "Charisma", value: 8);

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

  //finishing up variables
  String? group;
  @override
  void initState() {
    super.initState();
    level = character.classList.length;
    experience = character.characterExperience;
    featuresAndTraits = character.featuresAndTraits;
    toolProficiencies = character.mainToolProficiencies;
    inspired = character.inspired;
    speedBonusMap = character.speedBonuses;
    currencyStored = character.currency;
    // ignore: non_constant_identifier_names
    ACList = character.ACList;

    //Basics variables initialised
    //characterLevel = "${character.classList.length}";

    //Class variables initialised
    //Class? classSelectedAtLevel1;
    classSkillChoices = character.classSkillsSelected;
    savingThrowProficiencies = character.savingThrowProficiencies;
    skillProficiencies = character.skillProficiencies;
    maxHealth = character.maxHealth;

    classList = character.classList;

    levelsPerClass = character.levelsPerClass;
    selections = character.selections;
    allSelected = character.allSelected;
    classSubclassMapper = character.classSubclassMapper;

    //Ability score variables initialised
    strength = character.strength;
    dexterity = character.strength;
    constitution = character.constitution;
    intelligence = character.intelligence;
    wisdom = character.wisdom;
    charisma = character.charisma;

    //STR/DEX/CON/INT/WIS/CHAR
    //ASIS AND FEAT variables
    ASIBonuses = character.featsASIScoreIncreases;
    featsSelected = character.featsSelected;
    ASIRemaining = character.ASIRemaining;
    numberOfRemainingFeatOrASIs = character.numberOfRemainingFeatOrASIs;
    halfFeats = character.halfFeats;
    fullFeats = character.fullFeats;
    //Spell variables
    allSpellsSelected = character.allSpellsSelected;
    allSpellsSelectedAsListsOfThings =
        character.allSpellsSelectedAsListsOfThings;
    //Equipment variables
    armourList = character.armourList;
    weaponList = character.weaponList;
    itemList = character.itemList;
    coinTypeSelected = character.coinTypeSelected;
    equipmentSelectedFromChoices = character.equipmentSelectedFromChoices;
    //{thing:numb,...}
    stackableEquipmentSelected = character.stackableEquipmentSelected;
    unstackableEquipmentSelected = character.unstackableEquipmentSelected;
    //finishing up variables
    group = character.group;
    updateGlobals();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    //super.build(context);
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              textAlign: TextAlign.center,
              'Edit ${character.name}',
              style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("Quick edits")),
              Tab(child: Text("Class")),
              Tab(child: Text("ASI's and Feats")),
              Tab(child: Text("Spells")),
              Tab(child: Text("Equipment")),
              Tab(child: Text("Boons and magic items")),
              Tab(child: Text("Finishing up")),
            ],
          ),
        ),
        body: TabBarView(children: [
          //Quick edits

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "${character.name} is level $level with $experience experience"),
              const SizedBox(height: 20),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text("Increase level by 1:  "),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: (level < 20) ? Colors.blue : Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      side: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 27, 155, 10)),
                    ),
                    onPressed: () {
                      setState(() {
                        if (level < 20) {
                          level++;
                        }
                      });
                    },
                    child: const Icon(Icons.add, color: Colors.white))
              ]),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text("Experience amount to add:  "),
                SizedBox(
                  width: 320,
                  height: 50,
                  child: TextField(
                      cursorColor: Colors.blue,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          hintText: "Amount of experience to add (number)",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 212, 208, 224)),
                          filled: true,
                          fillColor: Color.fromARGB(211, 42, 63, 226),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onChanged: (experienceIncreaseEnteredValue) {
                        setState(() {
                          experienceIncrease = experienceIncreaseEnteredValue;
                        });
                      }),
                ),
              ]),
              const Text("Confirm adding experience"),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        (double.tryParse(experienceIncrease ?? "NOT NUMBER") !=
                                null)
                            ? Colors.blue
                            : Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    side: const BorderSide(
                        width: 3, color: Color.fromARGB(255, 27, 155, 10)),
                  ),
                  onPressed: () {
                    setState(() {
                      if (double.tryParse(experienceIncrease ?? "NOT NUMBER") !=
                          null) {
                        experience += double.tryParse(
                                experienceIncrease ?? "NOTNUMBER") ??
                            0;
                        //validate level
                      }
                    });
                  },
                  child: const Icon(Icons.add, color: Colors.white))
            ],
          ),
          //class
          DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text(
                      '${level - character.classList.length} class level(s) available but unselected', //and ${widgetsInPlay.length - levelsPerClass.reduce((value, element) => value + element) - allSelected.length} choice(s)
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
                                    backgroundColor: (level <=
                                            character.classList.length)
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
                                      if (level > character.classList.length) {
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
                                        if (level == 0) {
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
                                          if (character.averageHitPoints ??
                                              false) {
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
          const Icon(Icons.directions_bike),
          //Finishing up
          Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PdfPreviewPage(
                          invoice: Character(
                              uniqueID: character.uniqueID,
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
                              backgroundSkillChoices:
                                  character.backgroundSkillChoices,
                              characterAge: character.characterAge,
                              characterEyes: character.characterEyes,
                              characterHair: character.characterHair,
                              characterHeight: character.characterHeight,
                              characterSkin: character.characterSkin,
                              characterWeight: character.characterWeight,
                              coinTypeSelected: coinTypeSelected,
                              name: character.name,
                              playerName: character.playerName,
                              gender: character.gender,
                              characterExperience:
                                  character.characterExperience,
                              //bools representing the states of the checkboxes (basics)
                              featsAllowed: character.featsAllowed,
                              averageHitPoints: character.averageHitPoints,
                              multiclassing: character.multiclassing,
                              milestoneLevelling: character.milestoneLevelling,
                              useCustomContent: character.useCustomContent,
                              optionalClassFeatures:
                                  character.optionalClassFeatures,
                              criticalRoleContent:
                                  character.criticalRoleContent,
                              encumberanceRules: character.encumberanceRules,
                              includeCoinsForWeight:
                                  character.includeCoinsForWeight,
                              unearthedArcanaContent:
                                  character.unearthedArcanaContent,
                              firearmsUsable: character.firearmsUsable,
                              extraFeatAtLevel1: character.extraFeatAtLevel1,
                              featsSelected: featsSelected,
                              fullFeats: fullFeats,
                              halfFeats: halfFeats,
                              itemList: itemList,
                              equipmentSelectedFromChoices:
                                  equipmentSelectedFromChoices,
                              optionalOnesStates: character.optionalOnesStates,
                              optionalTwosStates: character.optionalTwosStates,
                              speedBonuses: speedBonusMap,
                              weaponList: weaponList,
                              numberOfRemainingFeatOrASIs:
                                  numberOfRemainingFeatOrASIs,
                              classList: classList,
                              stackableEquipmentSelected:
                                  stackableEquipmentSelected,
                              unstackableEquipmentSelected:
                                  unstackableEquipmentSelected,
                              classSkillsSelected: classSkillChoices,
                              skillsSelected: character.skillsSelected,
                              subrace: character.subrace,
                              mainToolProficiencies: toolProficiencies,
                              savingThrowProficiencies:
                                  savingThrowProficiencies ?? [],
                              languagesKnown: character.languagesKnown,
                              featuresAndTraits: featuresAndTraits,
                              inspired: inspired,
                              skillProficiencies: skillProficiencies,
                              maxHealth: maxHealth,
                              background: character.background,
                              classLevels: levelsPerClass,
                              race: character.race,
                              currency: currencyStored,
                              backgroundPersonalityTrait:
                                  character.backgroundPersonalityTrait,
                              backgroundIdeal: character.backgroundIdeal,
                              backgroundBond: character.backgroundBond,
                              backgroundFlaw: character.backgroundFlaw,
                              raceAbilityScoreIncreases:
                                  character.raceAbilityScoreIncreases,
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
                        items: (GROUPLIST != [])
                            ? GROUPLIST
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: SizedBox(
                                      width: 100,
                                      child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(value))),
                                );
                              }).toList()
                            : null,
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
                        final List<dynamic> characters = json["Characters"]
                            .where((element) =>
                                element["UniqueID"] != character.uniqueID)
                            .toList();

                        characters.add(Character(
                                uniqueID: character.uniqueID,
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
                                backgroundSkillChoices:
                                    character.backgroundSkillChoices,
                                characterAge: character.characterAge,
                                characterEyes: character.characterEyes,
                                characterHair: character.characterHair,
                                characterHeight: character.characterHeight,
                                characterSkin: character.characterSkin,
                                characterWeight: character.characterWeight,
                                coinTypeSelected: coinTypeSelected,
                                name: character.name,
                                playerName: character.playerName,
                                gender: character.gender,
                                characterExperience:
                                    character.characterExperience,
                                //bools representing the states of the checkboxes (basics)
                                featsAllowed: character.featsAllowed,
                                averageHitPoints: character.averageHitPoints,
                                multiclassing: character.multiclassing,
                                milestoneLevelling:
                                    character.milestoneLevelling,
                                useCustomContent: character.useCustomContent,
                                optionalClassFeatures:
                                    character.optionalClassFeatures,
                                criticalRoleContent:
                                    character.criticalRoleContent,
                                encumberanceRules: character.encumberanceRules,
                                includeCoinsForWeight:
                                    character.includeCoinsForWeight,
                                unearthedArcanaContent:
                                    character.unearthedArcanaContent,
                                firearmsUsable: character.firearmsUsable,
                                extraFeatAtLevel1: character.extraFeatAtLevel1,
                                featsSelected: featsSelected,
                                fullFeats: fullFeats,
                                halfFeats: halfFeats,
                                itemList: itemList,
                                equipmentSelectedFromChoices:
                                    equipmentSelectedFromChoices,
                                optionalOnesStates:
                                    character.optionalOnesStates,
                                optionalTwosStates:
                                    character.optionalTwosStates,
                                speedBonuses: speedBonusMap,
                                weaponList: weaponList,
                                numberOfRemainingFeatOrASIs:
                                    numberOfRemainingFeatOrASIs,
                                classList: classList,
                                stackableEquipmentSelected:
                                    stackableEquipmentSelected,
                                unstackableEquipmentSelected:
                                    unstackableEquipmentSelected,
                                classSkillsSelected: classSkillChoices,
                                skillsSelected: character.skillsSelected,
                                subrace: character.subrace,
                                mainToolProficiencies: toolProficiencies,
                                savingThrowProficiencies:
                                    savingThrowProficiencies ?? [],
                                languagesKnown: character.languagesKnown,
                                featuresAndTraits: featuresAndTraits,
                                inspired: inspired,
                                skillProficiencies: skillProficiencies,
                                maxHealth: maxHealth,
                                background: character.background,
                                classLevels: levelsPerClass,
                                race: character.race,
                                currency: currencyStored,
                                backgroundPersonalityTrait:
                                    character.backgroundPersonalityTrait,
                                backgroundIdeal: character.backgroundIdeal,
                                backgroundBond: character.backgroundBond,
                                backgroundFlaw: character.backgroundFlaw,
                                raceAbilityScoreIncreases:
                                    character.raceAbilityScoreIncreases,
                                featsASIScoreIncreases: ASIBonuses,
                                strength: strength,
                                dexterity: dexterity,
                                constitution: constitution,
                                intelligence: intelligence,
                                wisdom: wisdom,
                                charisma: charisma)
                            .toJson());
                        List<dynamic> groupsList = json["Groups"];
                        groupsList = groupsList
                            .where((element) => [
                                  for (var x in characters) x["Group"]
                                ].contains(element))
                            .toList();
                        if ((!GROUPLIST.contains(group)) &&
                            group != null &&
                            group!.replaceAll(" ", "") != "") {
                          GROUPLIST.add(group ?? "Never happening");
                          groupsList.add(group);
                        }
                        json["Groups"] = groupsList;
                        json["Characters"] = characters;
                        writeJsonToFile(json, "userContent");
                        updateGlobals();
                        //Navigator.pop(context);
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
