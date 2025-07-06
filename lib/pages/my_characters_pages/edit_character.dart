// External Imports
import "package:flutter/material.dart";

// Project Imports
import "../create_a_character_pages/edit_tabs.dart";
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
  late Character editableCharacter;
  List<String> coinTypesSelected = ["Gold Pieces"];

  EditCharacter({required this.character});
  String? experienceIncrease;
  String? levellingMethod;
  List<Widget> widgetsInPlay = [];
  Map<String, List<dynamic>> selections = {};
  bool remainingAsi = false;
  int numberOfRemainingFeatOrASIs = 0;
  String? coinTypeSelected = "Gold Pieces";
  String? group;
  String? characterLevel = "1";
  List<dynamic> equipmentSelectedFromChoices = [];
  List<String> featuresAndTraits = [];
  List<List<dynamic>> ACList = [];
  Map<String, List<dynamic>> speedBonusMap = {};
  ValueNotifier<int> tabRebuildNotifier = ValueNotifier<int>(0);
  TextEditingController groupEnterController = TextEditingController();

  int get charLevel {
    return int.parse(characterLevel ?? "1");
  }
  @override
  void initState() {
    super.initState();
    editableCharacter = character.getCopy();
    characterLevel = editableCharacter.classList.length.toString();
    tabRebuildNotifier = ValueNotifier<int>(0);
    
    // Initialize ASI/Feats state based on character level and existing selections
    // Calculate how many ASI/Feats the character should have based on their class levels
    int expectedFeatOrASIs = 0;
    for (int i = 0; i < editableCharacter.classList.length; i++) {
      int classIndex = CLASSLIST.indexWhere((cls) => cls.name == editableCharacter.classList[i]);
      if (classIndex != -1) {
        for (int level = 1; level <= editableCharacter.levelsPerClass[i]; level++) {
          if (CLASSLIST[classIndex].gainAtEachLevel[level].any((advancement) => advancement[0] == "ASI")) {
            expectedFeatOrASIs++;
          }
        }
      }
    }
    
    // Add extra feat at level 1 if enabled
    if (editableCharacter.extraFeatAtLevel1 == true) {
      expectedFeatOrASIs++;
    }
    
    // Calculate how many have been used
    int usedFeatOrASIs = editableCharacter.featsSelected.length;
    int asiPointsUsed = editableCharacter.featsASIScoreIncreases.fold(0, (sum, increment) => sum + increment) ~/ 2; // Each ASI gives 2 points
    usedFeatOrASIs += asiPointsUsed;
    
    // Set remaining counts
    numberOfRemainingFeatOrASIs = (expectedFeatOrASIs - usedFeatOrASIs).clamp(0, expectedFeatOrASIs);
    remainingAsi = false; // Start with no pending ASI
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
                  "${character.characterDescription.name} is level ${editableCharacter.classList.length} with ${editableCharacter.characterExperience} experience",
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
                    backgroundColor: (editableCharacter.classList.length < 20)
                        ? InitialTop.colourScheme.backingColour
                        : const Color.fromARGB(247, 56, 53, 52),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    side: const BorderSide(
                        width: 3, color: Color.fromARGB(255, 27, 155, 10)),
                  ),
                  onPressed: () {
                    setState(() {
                      if (editableCharacter.classList.length < 20) {
                        editableCharacter.classList.add("");
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
                        editableCharacter.characterExperience += double.tryParse(
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
          ClassTab(
            character: editableCharacter,
            charLevel: charLevel,
            characterLevel: characterLevel,
            widgetsInPlay: widgetsInPlay,
            numberOfRemainingFeatOrASIs: numberOfRemainingFeatOrASIs,
            tabRebuildNotifier: tabRebuildNotifier,
            onCharacterChanged: () {
              setState(() {});
            },
            onCharacterLevelChanged: (newLevel) {
              setState(() {
                characterLevel = newLevel;
              });
            },
            onWidgetsInPlayChanged: (newWidgets) {
              setState(() {
                widgetsInPlay = newWidgets;
              });
            },
            onNumberOfRemainingFeatOrASIsChanged: (newCount) {
              setState(() {
                numberOfRemainingFeatOrASIs = newCount;
              });
            },
          ),
          //ASI + FEAT- updated to use AsiFeatTab widget
          AsiFeatTab(
            character: editableCharacter,
            numberOfRemainingFeatOrASIs: numberOfRemainingFeatOrASIs,
            remainingAsi: remainingAsi,
            widgetsInPlay: widgetsInPlay,
            onCharacterChanged: () {
              setState(() {});
            },
            onRemainingFeatOrASIsChanged: (newCount) {
              setState(() {
                numberOfRemainingFeatOrASIs = newCount;
              });
            },
            onRemainingAsiChanged: (newRemainingAsi) {
              setState(() {
                remainingAsi = newRemainingAsi;
              });
            },
            onWidgetsInPlayChanged: (newWidgets) {
              setState(() {
                widgetsInPlay = newWidgets;
              });
            },
          ),
          //spells - updated to new color Scheme
          SpellsTab(
            character: editableCharacter,
            onCharacterChanged: () {
              setState(() {
                // Character changes are handled by the SpellsTab internally
              });
            },
          ),
          //Equipment- updated to new color Scheme
          EquipmentTab(
            character: editableCharacter,
            coinTypesSelected: coinTypesSelected,
            onCharacterChanged: () {
              setState(() {
                // Character changes are handled by the EquipmentTab internally
              });
            },
            onCoinTypesChanged: (newCoinTypes) {
              setState(() {
                coinTypesSelected = newCoinTypes;
              });
            },
          ),
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
                  editableCharacter.uniqueID = character.uniqueID;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PdfPreviewPage(
                          character: editableCharacter),
                    ),
                  );
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
                                              !remainingAsi &&
                                              charLevel <= editableCharacter.classList.length &&
                                              (equipmentSelectedFromChoices ==
                                                      [] ||
                                                  equipmentSelectedFromChoices
                                                      .where((element) =>
                                                          element.length == 2)
                                                      .toList()
                                                      .isEmpty) &&
                                              (editableCharacter.allSpellsSelectedAsListsOfThings
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
                                      !remainingAsi &&
                                      charLevel <= editableCharacter.classList.length &&
                                      (equipmentSelectedFromChoices == [] ||
                                          equipmentSelectedFromChoices
                                              .where((element) =>
                                                  element.length == 2)
                                              .toList()
                                              .isEmpty) &&
                                      (editableCharacter.allSpellsSelectedAsListsOfThings
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
                                            levelsPerClass: editableCharacter.levelsPerClass,
                                            allSelected: editableCharacter.allSelected,
                                            classSubclassMapper:
                                                editableCharacter.classSubclassMapper,
                                            ACList: editableCharacter.ACList,
                                            allSpellsSelected:
                                                editableCharacter.allSpellsSelected,
                                            allSpellsSelectedAsListsOfThings:
                                                editableCharacter.allSpellsSelectedAsListsOfThings,
                                            armourList: editableCharacter.armourList,
                                            playerName: character.playerName,
                                            characterExperience: editableCharacter.characterExperience,
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
                                            featsSelected: editableCharacter.featsSelected,
                                            itemList: editableCharacter.itemList,
                                            equipmentSelectedFromChoices:
                                                editableCharacter.equipmentSelectedFromChoices,
                                            optionalOnesStates:
                                                character.optionalOnesStates,
                                            optionalTwosStates:
                                                character.optionalTwosStates,
                                            speedBonuses: editableCharacter.speedBonuses,
                                            weaponList: editableCharacter.weaponList,
                                            classList: editableCharacter.classList,
                                            stackableEquipmentSelected:
                                                editableCharacter.stackableEquipmentSelected,
                                            unstackableEquipmentSelected:
                                                editableCharacter.unstackableEquipmentSelected,
                                            classSkillsSelected:
                                                editableCharacter.classSkillsSelected,
                                            skillsSelected:
                                                character.skillsSelected,
                                            subrace: character.subrace,
                                            mainToolProficiencies:
                                                editableCharacter.mainToolProficiencies,
                                            savingThrowProficiencies:
                                                editableCharacter.savingThrowProficiencies,
                                            languagesKnown:
                                                character.languagesKnown,
                                            featuresAndTraits:
                                                editableCharacter.featuresAndTraits,
                                            inspired: editableCharacter.inspired,
                                            skillProficiencies:
                                                editableCharacter.skillProficiencies,
                                            maxHealth: editableCharacter.maxHealth,
                                            background: character.background,
                                            classLevels: editableCharacter.levelsPerClass,
                                            race: character.race,
                                            currency: editableCharacter.currency,
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
                                            featsASIScoreIncreases: editableCharacter.featsASIScoreIncreases,
                                            strength: editableCharacter.strength,
                                            dexterity: editableCharacter.dexterity,
                                            constitution: editableCharacter.constitution,
                                            intelligence: editableCharacter.intelligence,
                                            wisdom: editableCharacter.wisdom,
                                            charisma: editableCharacter.charisma);
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
                      (charLevel <= editableCharacter.classList.length)
                          ? const Text("Made all level selections",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))
                          : Text("${charLevel - editableCharacter.classList.length} unused levels",
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
                      (editableCharacter.allSpellsSelectedAsListsOfThings
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
                          : (editableCharacter.allSpellsSelectedAsListsOfThings.length == 1)
                              //if they only have 1 way to choose spells (as the reduce only works on lists of length >1,
                              // otherwise it just returns the whole element which would break the code)
                              ? Text(
                                  //number remaining
                                  "Missed ${(editableCharacter.allSpellsSelectedAsListsOfThings[0][2])} spells",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700))
                              : Text(
                                  //number remaining with multiple ways to choose spells
                                  "Missed ${(editableCharacter.allSpellsSelectedAsListsOfThings.reduce((a, b) => a[2] + b[2]) as int)} spells",
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
