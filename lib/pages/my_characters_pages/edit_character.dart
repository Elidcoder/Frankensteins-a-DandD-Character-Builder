// External Imports
import "package:flutter/material.dart";

// Project Imports
import "../create_a_character_pages/edit_tabs.dart";
import "../create_a_character_pages/finishing_up_tab.dart";
import "../create_a_character_pages/backstory_tab.dart";
import "../../content_classes/all_content_classes.dart";
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
  List<Widget> widgetsInPlay = [];
  bool remainingAsi = false;
  int numberOfRemainingFeatOrASIs = 0;
  String? characterLevel = "1";
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
    
    // Initialize group text controller with character's existing group
    groupEnterController.text = editableCharacter.group ?? "";
    
    // Initialize ASI/Feats state based on character level and existing selections
    // Calculate how many ASI/Feats the character should have based on their class levels
    int expectedFeatOrASIs = 0;
    int count = 0;
    Set<String> classNames = {};
    for (int i = 0; i < editableCharacter.classList.length; i++) {
      int classIndex = CLASSLIST.indexWhere((cls) => cls.name == editableCharacter.classList[i]);
      if (classIndex != -1 && !classNames.contains(editableCharacter.classList[i])) {
        for (int level = 0; level < editableCharacter.levelsPerClass[count]; level++) {
          if (CLASSLIST[classIndex].gainAtEachLevel[level].any((advancement) => advancement[0] == "ASI")) {
            expectedFeatOrASIs++;
          }
        }
        count ++;
        classNames.add(editableCharacter.classList[i]);
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
      length: 8,
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
                  child: Text("Backstory",
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
                  "${character.characterDescription.name} is level ${int.parse(characterLevel ?? "1")} with ${editableCharacter.characterExperience} experience",
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      color: InitialTop.colourScheme.backingColour)),
              if (int.parse(characterLevel ?? "1") > character.classLevels.fold(0, (val, acc) => val + acc)) ...[
                const SizedBox(height: 16),
                Text("${character.characterDescription.name} has at least one unused level!!",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: InitialTop.colourScheme.backingColour)),
              ],

              const SizedBox(height: 16),
              Text("Increase level by 1:  ",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: InitialTop.colourScheme.backingColour)),
              const SizedBox(height: 8),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: (int.parse(characterLevel ?? "1") < 20)
                        ? InitialTop.colourScheme.backingColour
                        : const Color.fromARGB(247, 56, 53, 52),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    side: const BorderSide(
                        width: 3, color: Color.fromARGB(255, 27, 155, 10)),
                  ),
                  onPressed: () {
                    setState(() {
                      if (int.parse(characterLevel ?? "1") < 20) {
                        characterLevel = (int.parse(characterLevel ?? "1") + 1).toString();
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
          //Backstory
          BackstoryTab(
            character: editableCharacter,
            onCharacterChanged: () {
              setState(() {
                // Character changes are handled by the BackstoryTab internally
              });
            },
          ),
          //Finishing up
          FinishingUpTab(
            character: editableCharacter,
            groupEnterController: groupEnterController,
            canCreateCharacter: (numberOfRemainingFeatOrASIs == 0 &&
                !remainingAsi &&
                charLevel <= editableCharacter.classList.length &&
                editableCharacter.chosenAllEqipment &&
                editableCharacter.chosenAllSpells),
            pointsRemaining: 0, // Edit mode doesn't have point buy
            numberOfRemainingFeatOrASIs: numberOfRemainingFeatOrASIs,
            remainingAsi: remainingAsi,
            charLevel: charLevel,
            isEditMode: true, // This is edit mode
            onCharacterChanged: () {
              setState(() {
                // Group changes are handled by the FinishingUpTab internally
              });
            },
            onSaveCharacter: () {
              // Custom save logic for edit mode
              Character char = Character(
                languageChoices: character.languageChoices,
                characterDescription: CharacterDescription(
                  age: editableCharacter.characterDescription.age,
                  height: editableCharacter.characterDescription.height,
                  weight: editableCharacter.characterDescription.weight,
                  eyes: editableCharacter.characterDescription.eyes,
                  skin: editableCharacter.characterDescription.skin,
                  hair: editableCharacter.characterDescription.hair,
                  backstory: editableCharacter.characterDescription.backstory,
                  name: editableCharacter.characterDescription.name,
                  gender: editableCharacter.characterDescription.gender
                ),
                skillBonusMap: character.skillBonusMap,
                extraFeatures: editableCharacter.extraFeatures,
                group: editableCharacter.group,
                levelsPerClass: editableCharacter.levelsPerClass,
                allSelected: editableCharacter.allSelected,
                classSubclassMapper: editableCharacter.classSubclassMapper,
                ACList: editableCharacter.ACList,
                allSpellsSelected: editableCharacter.allSpellsSelected,
                allSpellsSelectedAsListsOfThings: editableCharacter.allSpellsSelectedAsListsOfThings,
                armourList: editableCharacter.armourList,
                playerName: character.playerName,
                characterExperience: editableCharacter.characterExperience,
                featsAllowed: character.featsAllowed,
                averageHitPoints: character.averageHitPoints,
                multiclassing: character.multiclassing,
                milestoneLevelling: character.milestoneLevelling,
                useCustomContent: character.useCustomContent,
                optionalClassFeatures: character.optionalClassFeatures,
                criticalRoleContent: character.criticalRoleContent,
                encumberanceRules: character.encumberanceRules,
                includeCoinsForWeight: character.includeCoinsForWeight,
                unearthedArcanaContent: character.unearthedArcanaContent,
                firearmsUsable: character.firearmsUsable,
                extraFeatAtLevel1: character.extraFeatAtLevel1,
                featsSelected: editableCharacter.featsSelected,
                itemList: editableCharacter.itemList,
                equipmentSelectedFromChoices: editableCharacter.equipmentSelectedFromChoices,
                optionalOnesStates: character.optionalOnesStates,
                optionalTwosStates: character.optionalTwosStates,
                speedBonuses: editableCharacter.speedBonuses,
                weaponList: editableCharacter.weaponList,
                classList: editableCharacter.classList,
                stackableEquipmentSelected: editableCharacter.stackableEquipmentSelected,
                unstackableEquipmentSelected: editableCharacter.unstackableEquipmentSelected,
                classSkillsSelected: editableCharacter.classSkillsSelected,
                skillsSelected: character.skillsSelected,
                subrace: character.subrace,
                mainToolProficiencies: editableCharacter.mainToolProficiencies,
                savingThrowProficiencies: editableCharacter.savingThrowProficiencies,
                languagesKnown: character.languagesKnown,
                featuresAndTraits: editableCharacter.featuresAndTraits,
                inspired: editableCharacter.inspired,
                skillProficiencies: editableCharacter.skillProficiencies,
                maxHealth: editableCharacter.maxHealth,
                background: character.background,
                classLevels: editableCharacter.levelsPerClass,
                race: character.race,
                currency: editableCharacter.currency,
                backgroundPersonalityTrait: character.backgroundPersonalityTrait,
                backgroundIdeal: character.backgroundIdeal,
                backgroundBond: character.backgroundBond,
                backgroundFlaw: character.backgroundFlaw,
                raceAbilityScoreIncreases: character.raceAbilityScoreIncreases,
                featsASIScoreIncreases: editableCharacter.featsASIScoreIncreases,
                strength: editableCharacter.strength,
                dexterity: editableCharacter.dexterity,
                constitution: editableCharacter.constitution,
                intelligence: editableCharacter.intelligence,
                wisdom: editableCharacter.wisdom,
                charisma: editableCharacter.charisma
              );
              char.uniqueID = character.uniqueID;
              
              // Update the character in the list
              int characterIndex = CHARACTERLIST.indexWhere((c) => c.uniqueID == character.uniqueID);
              if (characterIndex != -1) {
                CHARACTERLIST[characterIndex] = char;
              } else {
                CHARACTERLIST.add(char);
              }
              
              // Update group list
              GROUPLIST = GROUPLIST.where((element) => [
                for (var x in CHARACTERLIST) x.group
              ].contains(element)).toList();
              if ((!GROUPLIST.contains(editableCharacter.group)) &&
                  editableCharacter.group != null &&
                  editableCharacter.group!.replaceAll(" ", "") != "") {
                GROUPLIST.add(editableCharacter.group!);
              }
              saveChanges();
              
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InitialTop()),
              );
            },
            showCongratulationsDialog: showCongratulationsDialog,
          ),
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
}
