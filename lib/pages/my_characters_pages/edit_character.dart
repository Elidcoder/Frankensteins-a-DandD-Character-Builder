// External Imports
import "package:flutter/material.dart";

// Project Imports
import "../create_a_character_pages/edit_tabs.dart";
import "../create_a_character_pages/finishing_up_tab.dart";
import "../create_a_character_pages/backstory_tab.dart";
import "quick_edits_tab.dart";
import "../../content_classes/all_content_classes.dart";
import "../../main.dart" show InitialTop, InitialTopKey;
import "../../top_bar.dart";
import "../../utils/style_utils.dart";

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
    // Preserve the original character's uniqueID for edit mode
    editableCharacter.uniqueID = character.uniqueID;
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
              StyleUtils.tabLabel("Quick edits"),
              StyleUtils.tabLabel("Class"),
              StyleUtils.tabLabel("ASI's and Feats"),
              StyleUtils.tabLabel("Spells"),
              StyleUtils.tabLabel("Equipment"),
              StyleUtils.tabLabel("Boons and magic items"),
              StyleUtils.tabLabel("Backstory"),
              StyleUtils.tabLabel("Finishing up"),
            ],
            indicatorColor: InitialTop.colourScheme.textColour,
          ),
        ),
        body: TabBarView(children: [
          //Quick edits
          QuickEditsTab(
            character: editableCharacter,
            characterLevel: characterLevel ?? "1",
            onCharacterChanged: () {
              setState(() {
                // Character changes are handled by the QuickEditsTab internally
              });
            },
            onCharacterLevelChanged: (newLevel) {
              setState(() {
                characterLevel = newLevel;
              });
            },
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
