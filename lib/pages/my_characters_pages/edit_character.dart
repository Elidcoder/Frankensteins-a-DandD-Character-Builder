// External Imports
import "dart:math";
import "package:flutter/material.dart";

// Project Imports
import "../create_a_character_pages/spell_handling.dart";
import "../../content_classes/all_content_classes.dart";
import "../../pdf_generator/pdf_final_display.dart";
import "../../main.dart" show InitialTop, InitialTopKey;
import "../../top_bar.dart";
import "../../file_manager/file_manager.dart";

class EditTop extends StatelessWidget {
  final Character character;
  const EditTop(this.character, {super.key});
  static const String title= "Frankenstein's - a D&D 5e character builder";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: InitialTop.colourScheme.textColour,
          backgroundColor: InitialTop.colourScheme.backingColour,
          leading: IconButton(
            icon: const Icon(Icons.home),
            tooltip: "Return to the main menu",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegularTop(pagechoice: "Main Menu")));
            }),
          title: const Center(child: Text(title)),
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
                tooltip: "Settings",
                onPressed: () {
                  InitialTopKey.currentState?.showColorPicker(context);
                }),
          ],
        ),
        body: EditACharacter(character: character),
      ),
    );
  }
}

class EditACharacter extends StatefulWidget {
  final Character character;

  const EditACharacter({super.key, required this.character});
  @override
  EditCharacter createState() => EditCharacter(character: character);
}

class EditCharacter extends State<EditACharacter> {
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
  List<List<dynamic>> ACList = [
    ["10 + dexterity"]
  ];
  String? levellingMethod;

  //Class variables initialised
  List<bool> classSkillChoices = [];
  List<String>? savingThrowProficiencies;
  List<String> skillProficiencies = [];
  int maxHealth = 0;

  List<String> classList = [];

  List<Widget> widgetsInPlay = [];
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
  String? coinTypeSelected = "Gold Pieces";
  List<dynamic> equipmentSelectedFromChoices = [];

  // Formatted as {thing:numb,...}
  Map<String, int> stackableEquipmentSelected = {};
  List<dynamic> unstackableEquipmentSelected = [];

  // finishing up variables
  TextEditingController groupEnterController = TextEditingController();
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
    ACList = character.ACList;

    //Class variables initialised
    classSkillChoices = character.classSkillsSelected;
    savingThrowProficiencies = character.savingThrowProficiencies;
    skillProficiencies = character.skillProficiencies;
    maxHealth = character.maxHealth;

    classList = character.classList;

    levelsPerClass = character.levelsPerClass;
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

    //Spell variables
    allSpellsSelected = character.allSpellsSelected;
    allSpellsSelectedAsListsOfThings = character.allSpellsSelectedAsListsOfThings;
    
    //Equipment variables
    armourList = character.armourList;
    weaponList = character.weaponList;
    itemList = character.itemList;
    equipmentSelectedFromChoices = character.equipmentSelectedFromChoices;
    
    // Formatted as {thing:numb,...}
    stackableEquipmentSelected = character.stackableEquipmentSelected;
    unstackableEquipmentSelected = character.unstackableEquipmentSelected;
    
    //finishing up variables
    group = character.group;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    //super.build(context);
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: InitialTop.colourScheme.backgroundColour,
        appBar: AppBar(
          foregroundColor: InitialTop.colourScheme.textColour,
          backgroundColor: InitialTop.colourScheme.backingColour,
          title: Center(
            child: Text(
              textAlign: TextAlign.center,
              'Edit ${character.characterDescription.name}',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Text("Quick edits",
                      style: TextStyle(color: InitialTop.colourScheme.textColour))),
              Tab(
                  child: Text("Class",
                      style: TextStyle(color: InitialTop.colourScheme.textColour))),
              Tab(
                  child: Text("ASI's and Feats",
                      style: TextStyle(color: InitialTop.colourScheme.textColour))),
              Tab(
                  child: Text("Spells",
                      style: TextStyle(color: InitialTop.colourScheme.textColour))),
              Tab(
                  child: Text("Equipment",
                      style: TextStyle(color: InitialTop.colourScheme.textColour))),
              Tab(
                  child: Text("Boons and magic items",
                      style: TextStyle(color: InitialTop.colourScheme.textColour))),
              Tab(
                  child: Text("Finishing up",
                      style: TextStyle(color: InitialTop.colourScheme.textColour))),
            ],
            indicatorColor: InitialTop.colourScheme.textColour,
          ),
        ),
        body: TabBarView(children: [
          //Quick edits

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                  "${character.characterDescription.name} is level $level with $experience experience",
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      color: InitialTop.colourScheme.backingColour)),
              const SizedBox(height: 16),
              Text("Increase level by 1:  ",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: InitialTop.colourScheme.backingColour)),
              const SizedBox(height: 8),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: (level < 20)
                        ? InitialTop.colourScheme.backingColour
                        : const Color.fromARGB(247, 56, 53, 52),
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
                  child: Icon(Icons.add, color: InitialTop.colourScheme.textColour, size: 37)),
              const SizedBox(height: 16),
              Text("Experience amount to add:  ",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: InitialTop.colourScheme.backingColour)),
              const SizedBox(height: 8),
              SizedBox(
                width: 320,
                height: 50,
                child: TextField(
                    cursorColor: InitialTop.colourScheme.backingColour,
                    style: TextStyle(
                      color: InitialTop.colourScheme.textColour,
                    ),
                    decoration: InputDecoration(
                        hintText: "Amount of experience to add (number)",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: InitialTop.colourScheme.textColour),
                        filled: true,
                        fillColor: InitialTop.colourScheme.backingColour,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12)))),
                    onChanged: (experienceIncreaseEnteredValue) {
                      setState(() {
                        experienceIncrease = experienceIncreaseEnteredValue;
                      });
                    }),
              ),
              const SizedBox(height: 20),
              Text("Confirm adding experience",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: InitialTop.colourScheme.backingColour)),
              const SizedBox(height: 8),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        (double.tryParse(experienceIncrease ?? "NOT NUMBER") !=
                                null)
                            ? InitialTop.colourScheme.backingColour
                            : const Color.fromARGB(247, 56, 53, 52),
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
                                experienceIncrease ?? "NOT NUMBER") ??
                            0;
                        //validate level
                      }
                    });
                  },
                  child: Icon(Icons.add, color: InitialTop.colourScheme.textColour, size: 37))
            ],
          ),
          //class - updated to color scheme
          DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: InitialTop.colourScheme.backgroundColour,
              floatingActionButton: FloatingActionButton(
                tooltip: "Increase character level by 1",
                foregroundColor: InitialTop.colourScheme.textColour,
                backgroundColor: (level < 20)
                    ? InitialTop.colourScheme.backingColour
                    : const Color.fromARGB(247, 56, 53, 52),
                onPressed: () {
                  if (level < 20) {
                    setState(() {
                      level++;
                    });
                  }
                },
                child: const Icon(
                  Icons.exposure_plus_1,
                ),
              ),
              appBar: AppBar(
                foregroundColor: InitialTop.colourScheme.textColour,
                backgroundColor: InitialTop.colourScheme.backingColour,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                            '${level - levelsPerClass.reduce((value, element) => value + element)} class level(s) available but unselected', //and ${widgetsInPlay.length - levelsPerClass.reduce((value, element) => value + element) - allSelected.length} choice(s)
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: InitialTop.colourScheme.textColour),
                            textAlign: TextAlign.center)),
                    classList.isNotEmpty
                        ? Text(
                            "Classes and your levels in them: ${CLASSLIST.asMap().entries.where((entry) => levelsPerClass[entry.key] != 0).map((entry) => "${entry.value.name} - ${levelsPerClass[entry.key]}").join(", ")}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: InitialTop.colourScheme.textColour),
                            textAlign: TextAlign.center)
                        : Text("You have no levels in any class",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: InitialTop.colourScheme.textColour),
                            textAlign: TextAlign.center)
                  ],
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(
                        child: Text("Choose your classes",
                            style: TextStyle(color: InitialTop.colourScheme.textColour))),
                    Tab(
                        child: Text(
                            "Make your selections for each level in your class",
                            style: TextStyle(color: InitialTop.colourScheme.textColour))),
                  ],
                  indicatorColor: InitialTop.colourScheme.textColour,
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
                                color: InitialTop.colourScheme.backingColour,
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
                                          color: InitialTop.colourScheme.textColour)),
                                  Text(
                                      "Class type: ${CLASSLIST[index].classType}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: InitialTop.colourScheme.textColour)),
                                  (["Martial", "Third Caster"]
                                          .contains(CLASSLIST[index].classType))
                                      ? Text(
                                          "Main ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: InitialTop.colourScheme.textColour))
                                      : Text(
                                          "Spellcasting ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: InitialTop.colourScheme.textColour)),
                                  Text(
                                      "Hit die: D${CLASSLIST[index].maxHitDiceRoll}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: InitialTop.colourScheme.textColour)),
                                  Text(
                                      "Saves: ${CLASSLIST[index].savingThrowProficiencies.join(",")}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: InitialTop.colourScheme.textColour)),
                                  const SizedBox(height: 7),
                                  ElevatedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: (level <=
                                                    levelsPerClass.reduce(
                                                        (value, element) =>
                                                            value + element) ||
                                                (!multiclassingPossible(
                                                    CLASSLIST[index])))
                                            ? const Color.fromARGB(
                                                247, 56, 53, 52)
                                            : InitialTop.colourScheme.backingColour,
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
                                          if (level > classList.length &&
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

                                            //No level 1 bonuses

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

                                                /*allSpellsSelectedAsListsOfThings
                                                .add([
                                              CLASSLIST[index].name,
                                              [],
                                              levelZeroGetSpellsKnown(index),
                                              CLASSLIST[index]
                                                      .spellsKnownFormula ??
                                                  CLASSLIST[index]
                                                      .spellsKnownPerLevel
                                            ]);*/
                                              }
                                            }

                                            levelsPerClass[index]++;
                                          }
                                        });
                                      },
                                      child: Icon(Icons.add,
                                          color: InitialTop.colourScheme.textColour, size: 35))
                                ],
                              ));
                        }),
                      ),
                    )),
                Column(children: widgetsInPlay)
              ]),
            ),
          ),
          //ASI + FEAT- updated to new color Scheme
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text("$numberOfRemainingFeatOrASIs options remaining",
                      style: TextStyle(
                          color: InitialTop.colourScheme.backingColour,
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
                                          color: InitialTop.colourScheme.backingColour,
                                          fontSize: 33,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 8),
                                  if (ASIRemaining)
                                    Text("You have an unspent ASI",
                                        style: TextStyle(
                                            color: InitialTop.colourScheme.backingColour,
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
                                          color: InitialTop.colourScheme.backingColour,
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
                                                color: InitialTop.colourScheme.textColour),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[0]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: InitialTop.colourScheme.textColour),
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
                                                    : InitialTop.colourScheme.backingColour,
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
                                          color: InitialTop.colourScheme.backingColour,
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
                                                color: InitialTop.colourScheme.textColour),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[3]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: InitialTop.colourScheme.textColour),
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
                                                    : InitialTop.colourScheme.backingColour,
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
                                          color: InitialTop.colourScheme.backingColour,
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
                                                color: InitialTop.colourScheme.textColour),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[1]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: InitialTop.colourScheme.textColour),
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
                                                    : InitialTop.colourScheme.backingColour,
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
                                          color: InitialTop.colourScheme.backingColour,
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
                                                color: InitialTop.colourScheme.textColour),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[4]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: InitialTop.colourScheme.textColour),
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
                                                    : InitialTop.colourScheme.backingColour,
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
                                          color: InitialTop.colourScheme.backingColour,
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
                                                color: InitialTop.colourScheme.textColour),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[2]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: InitialTop.colourScheme.textColour),
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
                                                    : InitialTop.colourScheme.backingColour,
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
                                          color: InitialTop.colourScheme.backingColour,
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
                                                color: InitialTop.colourScheme.textColour),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "+${ASIBonuses[5]}",
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.w700,
                                                color: InitialTop.colourScheme.textColour),
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
                                                    : InitialTop.colourScheme.backingColour,
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
                      if (character.featsAllowed ?? false)
                        Expanded(
                            child: SizedBox(
                                height: 550,
                                child: Column(
                                  children: [
                                    if (featsSelected.isNotEmpty)
                                      Text(
                                          "${featsSelected.length} Feats selected:",
                                          style: TextStyle(
                                              color: InitialTop.colourScheme.backingColour,
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
                                                        color: InitialTop.colourScheme.backingColour)),
                                              );
                                            },
                                          )),
                                    Text("Select Feats:",
                                        style: TextStyle(
                                            color: InitialTop.colourScheme.backingColour,
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
                                                    ? InitialTop.colourScheme.backingColour
                                                    : const Color.fromARGB(
                                                        247, 56, 53, 52)),
                                            onPressed: () {
                                              setState(() {
                                                fullFeats = !fullFeats;
                                              });
                                            },
                                            child: Text("Full Feats",
                                                style: TextStyle(
                                                    color: InitialTop.colourScheme.textColour)),
                                          ),
                                          //text for search
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: (halfFeats)
                                                    ? InitialTop.colourScheme.backingColour
                                                    : const Color.fromARGB(
                                                        247, 56, 53, 52)),
                                            onPressed: () {
                                              setState(() {
                                                halfFeats = !halfFeats;
                                              });
                                            },
                                            child: Text("Half Feats",
                                                style: TextStyle(
                                                    color: InitialTop.colourScheme.textColour)),
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
                                                  "${FEATLIST[index].name}: \n •  ${FEATLIST[index].abilities.where((element) => element[0] == "Bonus").toList().map((sublist) => sublist[2]).toList().join('\n • ')}",
                                              child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                      backgroundColor: (featsSelected
                                                              .where((element) =>
                                                                  element[0].name ==
                                                                  FEATLIST[index]
                                                                      .name)
                                                              .isNotEmpty)
                                                          ? Color.fromARGB(
                                                              100 + (((featsSelected.where((element) => element[0].name == FEATLIST[index].name).length) / FEATLIST[index].numberOfTimesTakeable) * 155).ceil(),
                                                              0,
                                                              50 + (((featsSelected.where((element) => element[0].name == FEATLIST[index].name).length) / FEATLIST[index].numberOfTimesTakeable) * 205).ceil(),
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
                                                                    .abilities) {
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
                                                          color: InitialTop.colourScheme.backingColour,
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
          //spells - updated to new color Scheme
          Column(children: [
            Text("Choose your spells from regular progression",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: InitialTop.colourScheme.backingColour)),
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
          //Equipment- updated to new color Scheme
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
                                        color: InitialTop.colourScheme.backingColour)),
                                const SizedBox(height: 6),
                                Text(
                                    "You have ${currencyStored["Platinum Pieces"]} platinum, ${currencyStored["Gold Pieces"]} gold, ${currencyStored["Electrum Pieces"]} electrum, ${currencyStored["Silver Pieces"]} silver and ${currencyStored["Copper Pieces"]} copper pieces to spend",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: InitialTop.colourScheme.backingColour)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 775,
                                  child: Row(children: [
                                    //armour big button
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              (armourList.length == 4)
                                                  ? InitialTop.colourScheme.backingColour
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
                                                      color: InitialTop.colourScheme.textColour,
                                                      fontSize: 22)),
                                              Row(
                                                children: [
                                                  //suboptions for armour
                                                  ElevatedButton(
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor:
                                                            (armourList.contains(
                                                                    "Light"))
                                                                ? InitialTop.colourScheme.backingColour
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
                                                            color: InitialTop.colourScheme.textColour,
                                                            fontSize: 15)),
                                                  ),
                                                  ElevatedButton(
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor: (armourList
                                                                  .contains(
                                                                      "Medium"))
                                                              ? InitialTop.colourScheme.backingColour
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
                                                              color:  InitialTop.colourScheme.textColour,
                                                              fontSize: 15))),
                                                  ElevatedButton(
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor:
                                                            (armourList.contains(
                                                                    "Heavy"))
                                                                ? InitialTop.colourScheme.backingColour
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
                                                            color:  InitialTop.colourScheme.textColour,
                                                            fontSize: 15)),
                                                  ),
                                                  ElevatedButton(
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor: (armourList
                                                                  .contains(
                                                                      "Shield"))
                                                              ? InitialTop.colourScheme.backingColour
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
                                                              color:  InitialTop.colourScheme.textColour,
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
                                                  ? InitialTop.colourScheme.backingColour
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
                                                      color: InitialTop.colourScheme.textColour,
                                                      fontSize: 22)),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor:
                                                            (weaponList.contains(
                                                                    "Ranged"))
                                                                ? InitialTop.colourScheme.backingColour
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
                                                            color:  InitialTop.colourScheme.textColour,
                                                            fontSize: 15)),
                                                  ),
                                                  ElevatedButton(
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor: (weaponList
                                                                  .contains(
                                                                      "Melee"))
                                                              ? InitialTop.colourScheme.backingColour
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
                                                              color:  InitialTop.colourScheme.textColour,
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
                                                  ? InitialTop.colourScheme.backingColour
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
                                                      color: InitialTop.colourScheme.textColour,
                                                      fontSize: 22)),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor: (itemList
                                                                .contains(
                                                                    "Stackable"))
                                                            ? InitialTop.colourScheme.backingColour
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
                                                            color:  InitialTop.colourScheme.textColour,
                                                            fontSize: 15)),
                                                  ),
                                                  ElevatedButton(
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor: (itemList
                                                                  .contains(
                                                                      "Unstackable"))
                                                              ? InitialTop.colourScheme.backingColour
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
                                                              color:  InitialTop.colourScheme.textColour,
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
                                    color: InitialTop.colourScheme.backgroundColour,
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
                                                  color: InitialTop.colourScheme.textColour,
                                                  fontSize: 22)),
                                          //box<X<box2
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Platinum")
                                                            ? InitialTop.colourScheme.backingColour
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
                                                            InitialTop.colourScheme.textColour,
                                                        fontSize: 15)),
                                              ),
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Gold")
                                                            ? InitialTop.colourScheme.backingColour
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
                                                            InitialTop.colourScheme.textColour,
                                                        fontSize: 15)),
                                              ),
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Electrum")
                                                            ? InitialTop.colourScheme.backingColour
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
                                                            InitialTop.colourScheme.textColour,
                                                        fontSize: 15)),
                                              ),
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Silver")
                                                            ? InitialTop.colourScheme.backingColour
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
                                                            InitialTop.colourScheme.textColour,
                                                        fontSize: 15)),
                                              ),
                                              ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        (coinTypeSelected ==
                                                                "Copper")
                                                            ? InitialTop.colourScheme.backingColour
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
                                                            InitialTop.colourScheme.textColour,
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
                                      color: InitialTop.colourScheme.backgroundColour,
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
                                                      InitialTop.colourScheme.backingColour),
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
                                                          InitialTop.colourScheme.textColour)),
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
                                      color: InitialTop.colourScheme.backingColour)),
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
                                                                    InitialTop.colourScheme.backingColour),
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
                                                            color:  InitialTop.colourScheme.textColour,
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    InitialTop.colourScheme.backingColour),
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
                                                            color: InitialTop.colourScheme.textColour
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
                                                          InitialTop.colourScheme.backingColour,
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
          //Boons and magic items- updated to new color Scheme
          const Icon(Icons.directions_bike),
          //Finishing up
          Scaffold(
              backgroundColor: InitialTop.colourScheme.backgroundColour,
              floatingActionButton: FloatingActionButton(
                tooltip: "Generate a PDF",
                foregroundColor: InitialTop.colourScheme.textColour,
                backgroundColor: InitialTop.colourScheme.backingColour,
                onPressed: () {
                  Character char = Character(
                    languageChoices: character.languageChoices,
                      
                              skillBonusMap: character.skillBonusMap,
                              extraFeatures: character.extraFeatures,
                              group: group,
                              levelsPerClass: levelsPerClass,
                              allSelected: allSelected,
                              classSubclassMapper: classSubclassMapper,
                              ACList: ACList,
                              allSpellsSelected: allSpellsSelected,
                              allSpellsSelectedAsListsOfThings:
                                  allSpellsSelectedAsListsOfThings,
                              armourList: armourList,
                              characterDescription: CharacterDescription(age: character.characterDescription.age, height: character.characterDescription.height, weight: character.characterDescription.weight, eyes: character.characterDescription.eyes, skin: character.characterDescription.skin, hair: character.characterDescription.hair, backstory: character.characterDescription.backstory, name: character.characterDescription.name, gender: character.characterDescription.gender),
                              playerName: character.playerName,
                              characterExperience: experience,
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
                              itemList: itemList,
                              equipmentSelectedFromChoices:
                                  equipmentSelectedFromChoices,
                              optionalOnesStates: character.optionalOnesStates,
                              optionalTwosStates: character.optionalTwosStates,
                              speedBonuses: speedBonusMap,
                              weaponList: weaponList,
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
                              charisma: charisma);
                  char.uniqueID = character.uniqueID;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PdfPreviewPage(
                          character: char),
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
                                  color: InitialTop.colourScheme.backingColour)),
                          const SizedBox(height: 20),
                          Text("Select an existing group:",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: InitialTop.colourScheme.backingColour)),
                          const SizedBox(height: 20),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: (GROUPLIST.isNotEmpty)
                                    ? InitialTop.colourScheme.backingColour
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
                                      color: InitialTop.colourScheme.textColour,
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
                                    color: InitialTop.colourScheme.textColour),
                                items: (GROUPLIST != [])
                                    ? GROUPLIST.map<DropdownMenuItem<String>>(
                                        (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Align(
                                              child: Text(value,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: InitialTop.colourScheme.textColour,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ))),
                                        );
                                      }).toList()
                                    : null,
                                dropdownColor: InitialTop.colourScheme.backingColour,
                                elevation: 2,
                                style: TextStyle(
                                    color: InitialTop.colourScheme.textColour,
                                    fontWeight: FontWeight.w700),
                                underline: const SizedBox(),
                              )),
                          const SizedBox(height: 20),
                          Text("Or create a new one:",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: InitialTop.colourScheme.backingColour)),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 300,
                            child: TextField(
                                controller: groupEnterController,
                                cursorColor: InitialTop.colourScheme.textColour,
                                style: TextStyle(color: InitialTop.colourScheme.textColour),
                                decoration: InputDecoration(
                                    hintText: "Enter a group",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: InitialTop.colourScheme.textColour),
                                    filled: true,
                                    fillColor: InitialTop.colourScheme.backingColour,
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
                                  backgroundColor:
                                      (numberOfRemainingFeatOrASIs ==
                                                  0 &&
                                              !ASIRemaining &&
                                              level <= classList.length &&
                                              (equipmentSelectedFromChoices ==
                                                      [] ||
                                                  equipmentSelectedFromChoices
                                                      .where((element) =>
                                                          element.length == 2)
                                                      .toList()
                                                      .isEmpty) &&
                                              (allSpellsSelectedAsListsOfThings
                                                  .where(
                                                      (element) =>
                                                          element[2] != 0)
                                                  .isEmpty))
                                          ? InitialTop.colourScheme.backingColour
                                          : const Color.fromARGB(
                                              247, 56, 53, 52),
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
                                      color: InitialTop.colourScheme.textColour,
                                    )),
                                onPressed: () {
                                  if (numberOfRemainingFeatOrASIs == 0 &&
                                      !ASIRemaining &&
                                      level <= classList.length &&
                                      (equipmentSelectedFromChoices == [] ||
                                          equipmentSelectedFromChoices
                                              .where((element) =>
                                                  element.length == 2)
                                              .toList()
                                              .isEmpty) &&
                                      (allSpellsSelectedAsListsOfThings
                                          .where((element) => element[2] != 0)
                                          .isEmpty)) {
                                    Character char = Character(
                                      languageChoices: character.languageChoices,
                                            characterDescription: CharacterDescription(age: character.characterDescription.age, height: character.characterDescription.height, weight: character.characterDescription.weight, eyes: character.characterDescription.eyes, skin: character.characterDescription.skin, hair: character.characterDescription.hair, backstory: character.characterDescription.backstory, name: character.characterDescription.name, gender: character.characterDescription.gender),
                                            skillBonusMap:
                                                character.skillBonusMap,
                                            extraFeatures:
                                                character.extraFeatures,
                                            group: group,
                                            levelsPerClass: levelsPerClass,
                                            allSelected: allSelected,
                                            classSubclassMapper:
                                                classSubclassMapper,
                                            ACList: ACList,
                                            allSpellsSelected:
                                                allSpellsSelected,
                                            allSpellsSelectedAsListsOfThings:
                                                allSpellsSelectedAsListsOfThings,
                                            armourList: armourList,
                                            playerName: character.playerName,
                                            characterExperience: experience,
                                            //bools representing the states of the checkboxes (basics)
                                            featsAllowed:
                                                character.featsAllowed,
                                            averageHitPoints:
                                                character.averageHitPoints,
                                            multiclassing:
                                                character.multiclassing,
                                            milestoneLevelling:
                                                character.milestoneLevelling,
                                            useCustomContent:
                                                character.useCustomContent,
                                            optionalClassFeatures:
                                                character.optionalClassFeatures,
                                            criticalRoleContent:
                                                character.criticalRoleContent,
                                            encumberanceRules:
                                                character.encumberanceRules,
                                            includeCoinsForWeight:
                                                character.includeCoinsForWeight,
                                            unearthedArcanaContent: character
                                                .unearthedArcanaContent,
                                            firearmsUsable:
                                                character.firearmsUsable,
                                            extraFeatAtLevel1:
                                                character.extraFeatAtLevel1,
                                            featsSelected: featsSelected,
                                            itemList: itemList,
                                            equipmentSelectedFromChoices:
                                                equipmentSelectedFromChoices,
                                            optionalOnesStates:
                                                character.optionalOnesStates,
                                            optionalTwosStates:
                                                character.optionalTwosStates,
                                            speedBonuses: speedBonusMap,
                                            weaponList: weaponList,
                                            classList: classList,
                                            stackableEquipmentSelected:
                                                stackableEquipmentSelected,
                                            unstackableEquipmentSelected:
                                                unstackableEquipmentSelected,
                                            classSkillsSelected:
                                                classSkillChoices,
                                            skillsSelected:
                                                character.skillsSelected,
                                            subrace: character.subrace,
                                            mainToolProficiencies:
                                                toolProficiencies,
                                            savingThrowProficiencies:
                                                savingThrowProficiencies ?? [],
                                            languagesKnown:
                                                character.languagesKnown,
                                            featuresAndTraits:
                                                featuresAndTraits,
                                            inspired: inspired,
                                            skillProficiencies:
                                                skillProficiencies,
                                            maxHealth: maxHealth,
                                            background: character.background,
                                            classLevels: levelsPerClass,
                                            race: character.race,
                                            currency: currencyStored,
                                            backgroundPersonalityTrait:
                                                character
                                                    .backgroundPersonalityTrait,
                                            backgroundIdeal:
                                                character.backgroundIdeal,
                                            backgroundBond:
                                                character.backgroundBond,
                                            backgroundFlaw:
                                                character.backgroundFlaw,
                                            raceAbilityScoreIncreases: character
                                                .raceAbilityScoreIncreases,
                                            featsASIScoreIncreases: ASIBonuses,
                                            strength: strength,
                                            dexterity: dexterity,
                                            constitution: constitution,
                                            intelligence: intelligence,
                                            wisdom: wisdom,
                                            charisma: charisma);
                                    char.uniqueID = character.uniqueID;
                                    CHARACTERLIST.add(char);
                                    GROUPLIST = GROUPLIST
                                        .where((element) => [
                                              for (var x in CHARACTERLIST)
                                                x.group
                                            ].contains(element))
                                        .toList();
                                    if ((!GROUPLIST.contains(group)) &&
                                        group != null &&
                                        group!.replaceAll(" ", "") != "") {
                                      GROUPLIST.add(group!);
                                    }
                                    saveChanges();
                                    setState(() {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => InitialTop()),
                                      );

                                      showCongratulationsDialog(context);

                                      //Navigator.pop(context);
                                    });
                                  }
                                },
                              ))
                        ])),
                Expanded(
                    flex: 7,
                    child: Column(children: [
                      const SizedBox(height: 40),
                      Text("Build checklist:",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: InitialTop.colourScheme.backingColour)),
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
                      (level <= classList.length)
                          ? const Text("Made all level selections",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))
                          : Text("${level - classList.length} unused levels",
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
        content: const Text('Character edit saved!',
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

  bool scoresFailRequirement(Character character, List<int> requirements) {
    int count = 0;
    if (character.strength.value + character.raceAbilityScoreIncreases[0] + character.featsASIScoreIncreases[0] >= requirements[0]) count++;
    if (character.dexterity.value + character.raceAbilityScoreIncreases[1] + character.featsASIScoreIncreases[1] >= requirements[1]) count++;
    if (character.constitution.value + character.raceAbilityScoreIncreases[2] + character.featsASIScoreIncreases[2] >= requirements[2]) count++;
    if (character.intelligence.value + character.raceAbilityScoreIncreases[3] + character.featsASIScoreIncreases[3] >= requirements[3]) count++;
    if (character.wisdom.value + character.raceAbilityScoreIncreases[4] + character.featsASIScoreIncreases[4] >= requirements[4]) count++;
    if (character.charisma.value + character.raceAbilityScoreIncreases[5] + character.featsASIScoreIncreases[5] >= requirements[5]) count++;

    return count >= requirements[6];
  }
  
  bool multiclassingPossible(Class selectedClass) {
    // Check if it is their first class or they already have a level in the class
    if (character.classList.isEmpty || character.classList.contains(selectedClass.name)) {
      return true;
    }

    // Check if multiclassing is allowed
    if (!(character.multiclassing ?? false)) {
      return false;
    }

    // Check they satisfy the class they want to take
    if (scoresFailRequirement(character, selectedClass.multiclassingRequirements)) {
      return false;
    }

    // Check they satisfy their last added class's requirements
    return scoresFailRequirement(character, CLASSLIST.last.multiclassingRequirements);
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
      featuresAndTraits.add("${x[1]}: ${x[2]}");
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
      character.skillBonusMap[x[1]] =
          character.skillBonusMap[x[1]]! + int.parse(x[2]);
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
