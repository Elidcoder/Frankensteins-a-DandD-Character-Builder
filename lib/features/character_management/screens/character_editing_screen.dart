// External Imports
import "package:flutter/material.dart";
import "package:frankenstein/features/character_creation/tabs/asi_feat_tab.dart" show AsiFeatTab;
import "package:frankenstein/features/character_creation/tabs/class_tab.dart" show ClassTab;
import "package:frankenstein/features/character_creation/tabs/equipment_tab.dart" show EquipmentTab;
import "package:frankenstein/features/character_creation/tabs/spells_tab.dart" show SpellsTab;

// Project Imports
import "../../../core/services/global_list_manager.dart";
import "../../../core/theme/theme_manager.dart";
import "../../../core/utils/style_utils.dart";
import "../../../models/core/character/character.dart";
import "../../../shared/widgets/top_bar.dart";
import "../../character_creation/tabs/backstory_tab.dart";
import "../../character_creation/tabs/finishing_up_tab.dart";
import "../../home/widgets/initial_top.dart" show InitialTopKey;
import "../tabs/quick_edits_tab.dart";

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
        appBar: StyleUtils.buildStyledAppBar(
          smallTitle: true,
          title: title,
          leading: IconButton(
            icon: const Icon(Icons.home),
            tooltip: "Return to the main menu",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegularTop(pagechoice: "Main Menu")));
            }),
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
  late Future<void> _initialisedCharacters;
  List<String> coinTypesSelected = ["Gold Pieces"];

  EditCharacter({required this.character});
  List<Widget> widgetsInPlay = [];
  bool remainingAsi = false;
  int numberOfRemainingFeatOrASIs = 0;
  String? characterLevel = "1";
  ValueNotifier<int> tabRebuildNotifier = ValueNotifier<int>(0);
  TextEditingController groupEnterController = TextEditingController();

  static const List<String> tabLabels = [
    "Quick edits",
    "Class",
    "ASIs and Feats",
    "Spells",
    "Equipment",
    "Boons and magic items",
    "Backstory",
    "Finishing up"
  ];

  int get charLevel {
    return int.parse(characterLevel ?? "1");
  }

  @override
  void initState() {
    super.initState();
    ThemeManager.instance.addListener(_onThemeChanged);
    _initialisedCharacters = GlobalListManager().initialiseCharacterList();
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
      int classIndex = GlobalListManager().classList.indexWhere((cls) => cls.name == editableCharacter.classList[i]);
      if (classIndex != -1 && !classNames.contains(editableCharacter.classList[i])) {
        for (int level = 0; level < editableCharacter.levelsPerClass[count]; level++) {
          if (GlobalListManager().classList[classIndex].gainAtEachLevel[level].any((advancement) => advancement[0] == "ASI")) {
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
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    super.dispose();
  }
  
  void _onThemeChanged() {
    setState(() {
      // Rebuild when theme changes
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
      return StyleUtils.styledFutureBuilder(
        future: _initialisedCharacters, 
        builder: (context) => DefaultTabController(
          length: tabLabels.length,
          child: Scaffold(
            backgroundColor: ThemeManager.instance.currentScheme.backgroundColour,
            appBar: StyleUtils.buildStyledAppBar(
              title: 'Edit ${character.characterDescription.name}',
              titleStyle: TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.w700,
                color: ThemeManager.instance.currentScheme.textColour,
              ),
              bottom: TabBar(
                tabs: tabLabels.map((e) => StyleUtils.tabLabel(e)).toList(),
                indicatorColor: ThemeManager.instance.currentScheme.textColour,
              ),
            ),
            body: TabBarView(children: [
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

              SpellsTab(
                character: editableCharacter,
                onCharacterChanged: () {
                  setState(() {
                    // Character changes are handled by the SpellsTab internally
                  });
                },
              ),

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
              
              BackstoryTab(
                character: editableCharacter,
                onCharacterChanged: () {
                  setState(() {
                    // Character changes are handled by the BackstoryTab internally
                  });
                },
              ),

              FinishingUpTab(
                character: editableCharacter,
                groupEnterController: groupEnterController,
                canCreateCharacter: (numberOfRemainingFeatOrASIs == 0 &&
                    !remainingAsi &&
                    charLevel <= editableCharacter.classList.length &&
                    editableCharacter.chosenAllEqipment &&
                    editableCharacter.chosenAllSpells),
                // Edit mode doesn't have point buy
                pointsRemaining: 0, 
                numberOfRemainingFeatOrASIs: numberOfRemainingFeatOrASIs,
                remainingAsi: remainingAsi,
                charLevel: charLevel,
                isEditMode: true, // This is edit mode
                onCharacterChanged: () {
                  setState(() {
                    // Group changes are handled by the FinishingUpTab internally
                  });
                },
                congratulationsTitle: 'Character edit saved!',
              ),
            ]),
          ),
        ));
  }
}
