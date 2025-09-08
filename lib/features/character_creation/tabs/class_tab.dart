import "dart:math";

import "package:flutter/material.dart";
import "package:frankenstein/utils/helpers.dart" show sum;

import "../../../models/index.dart";
import "../../../storage/global_list_manager.dart";
import "../../../theme/theme_manager.dart";
import "../../../utils/style_utils.dart";
import "spell_handling.dart"; // For ChoiceRow

/// Class tab widget for character creation
/// Handles class selection, level progression, and level-based choices
class ClassTab extends StatefulWidget {
  final Character character;
  final int charLevel;
  final String? characterLevel;
  final List<Widget> widgetsInPlay;
  final int numberOfRemainingFeatOrASIs;
  final ValueNotifier<int> tabRebuildNotifier;
  final VoidCallback onCharacterChanged;
  final void Function(String?) onCharacterLevelChanged;
  final void Function(List<Widget>) onWidgetsInPlayChanged;
  final void Function(int) onNumberOfRemainingFeatOrASIsChanged;

  const ClassTab({
    super.key,
    required this.character,
    required this.charLevel,
    required this.characterLevel,
    required this.widgetsInPlay,
    required this.numberOfRemainingFeatOrASIs,
    required this.tabRebuildNotifier,
    required this.onCharacterChanged,
    required this.onCharacterLevelChanged,
    required this.onWidgetsInPlayChanged,
    required this.onNumberOfRemainingFeatOrASIsChanged,
  });

  @override
  State<ClassTab> createState() => _ClassTabState();
}

class _ClassTabState extends State<ClassTab> {
  late Future<void> _initialisedClasses;

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
    if (widget.character.classList.isEmpty || widget.character.classList.contains(selectedClass.name)) {
      return true;
    }

    // Check if multiclassing is allowed
    if (!(widget.character.multiclassing ?? false)) {
      return false;
    }

    // Check they satisfy the class they want to take
    if (scoresFailRequirement(widget.character, selectedClass.multiclassingRequirements)) {
      return false;
    }

    // Check they satisfy their last added class's requirements
    return scoresFailRequirement(widget.character, GlobalListManager().classList.last.multiclassingRequirements);
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
      widget.character.featuresAndTraits.add("${x[1]}: ${x[2]}");
    } else if (x[0] == "AC") {
      // ("AC","intelligence + 2", "RQUIREMENT")
      widget.character.ACList.add([x[1], x[2]]);
    } else if (x[0] == "Speed") {
      //note base speed is given by race
      //("speed", (w/s/c/f/h), numb/expression")
      widget.character.speedBonuses[x[1]]?.add(x[2]);
    } else if (x[0] == "AttributeBoost") {
      if (x[1] == "Intelligence") {
        widget.character.intelligence.value += int.parse(x[2]);
      } else if (x[1] == "Strength") {
        widget.character.strength.value += int.parse(x[2]);
      } else if (x[1] == "Constitution") {
        widget.character.constitution.value += int.parse(x[2]);
      } else if (x[1] == "Dexterity") {
        widget.character.dexterity.value += int.parse(x[2]);
      } else if (x[1] == "Wisdom") {
        widget.character.wisdom.value += int.parse(x[2]);
      } else if (x[1] == "charisma") {
        widget.character.charisma.value += int.parse(x[2]);
      }
      //do this later
    } else if (x[0] == "Gained") {
      widget.character.skillBonusMap[x[1]] = widget.character.skillBonusMap[x[1]]! + int.parse(x[2]);
      //do this later
    } else if (x[0] == "ASI") {
      widget.onNumberOfRemainingFeatOrASIsChanged(widget.numberOfRemainingFeatOrASIs + 1);
    }
    //FUTUREPLAN(Implement further parsing for: proficiencies, languages, equipment )

    /*else if (x[0] == "Equipment") {
    //note base speed is given by race
    //("speed", "10", "(w/s/c/f)")
    SPEEDLIST.append([x[1], x[2]]);
  }*/
    else if (x[0] == "Money") {
      //("Money", "Copper Pieces", "10")
      widget.character.currency[x[1]] = widget.character.currency[x[1]]! + int.parse(x[2]);
    }
    return null;
  }

  int levelZeroGetSpellsKnown(int index) {
    if (GlobalListManager().classList[index].spellsKnownFormula == null) {
      return GlobalListManager().classList[index].spellsKnownPerLevel![widget.character.classLevels[index]];
    }
    //decode as zero
    return 3;
  }

  int getSpellsKnown(int index, List<dynamic> thisStuff) {
    if (GlobalListManager().classList[index].spellsKnownFormula == null) {
      return (GlobalListManager().classList[index].spellsKnownPerLevel![widget.character.classLevels[index]] -
          thisStuff[1].length) as int;
    }
    //decode as level + 1 and then take away [1].length
    return 3;
  }

  @override
  void initState() {
    super.initState();
    _initialisedClasses = GlobalListManager().initialiseClassList();
  }
  
  @override
  Widget build(BuildContext context) {
    return StyleUtils.styledFutureBuilder(
      future: _initialisedClasses,
      builder: (context) => DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ThemeManager.instance.currentScheme.backgroundColour,
        floatingActionButton: FloatingActionButton(
          tooltip: "Increase character level by 1",
          foregroundColor: ThemeManager.instance.currentScheme.textColour,
          backgroundColor: (widget.charLevel < 20)
            ? ThemeManager.instance.currentScheme.backingColour
            : unavailableColor,
          onPressed: () {
            if (widget.charLevel < 20) {
              widget.onCharacterLevelChanged("${widget.charLevel + 1}");
            }
          },
          child: const Icon(Icons.exposure_plus_1),
        ),
        appBar: StyleUtils.buildStyledAppBar(
          title: "${widget.charLevel - widget.character.classLevels.reduce(sum)} class level(s) unselected",
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Column(
              children: [
                /* Class choices available and taken to/by the user. */
                Center(child: StyleUtils.buildStyledSmallTextBox(
                  text: widget.character.classList.isNotEmpty
                    ? "Levels in Classes: ${GlobalListManager().classList.asMap().entries.where((entry) => widget.character.classLevels[entry.key] != 0).map((entry) => "${entry.value.name} - ${widget.character.classLevels[entry.key]}").join(", ")}"
                    : "No levels selected in any class"
                )),
                    
                const SizedBox(height: 3),
                TabBar(
                  tabs: [
                    StyleUtils.tabLabel("Choose your classes"),
                    StyleUtils.tabLabel("Make your selections for each level in your class")
                  ],
                  indicatorColor: ThemeManager.instance.currentScheme.textColour,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(children: [
          /* Generates a set of cards (1 for each class) with buttons allowing 
           * users to view and select each class */
          Container(
              padding: const EdgeInsets.only(top: 17),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: List.generate(GlobalListManager().classList.length, (index) {
                    return Container(
                      width: 240,
                      height: 175,
                      decoration: BoxDecoration(
                        color: ThemeManager.instance.currentScheme.backingColour,
                        border: Border.all(color: Colors.black, width: 1.8),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        children: [
                          /* Information about the class */
                          Text(GlobalListManager().classList[index].name,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: ThemeManager.instance.currentScheme.textColour)),
                          StyleUtils.buildStyledTinyTextBox(
                            text: "Class type: ${GlobalListManager().classList[index].classType}", 
                            color: ThemeManager.instance.currentScheme.textColour
                          ),
                          StyleUtils.buildStyledTinyTextBox(
                            text: (["Martial", "Third Caster"].contains(GlobalListManager().classList[index].classType))
                              ? "Main ability: ${GlobalListManager().classList[index].mainOrSpellcastingAbility}"
                              : "Spellcasting ability: ${GlobalListManager().classList[index].mainOrSpellcastingAbility}", 
                            color: ThemeManager.instance.currentScheme.textColour
                          ),
                          StyleUtils.buildStyledTinyTextBox(
                            text: "Hit die: D${GlobalListManager().classList[index].maxHitDiceRoll}", 
                            color: ThemeManager.instance.currentScheme.textColour
                          ),
                          StyleUtils.buildStyledTinyTextBox(
                            text: "Saves: ${GlobalListManager().classList[index].savingThrowProficiencies.join(", ")}", 
                            color: ThemeManager.instance.currentScheme.textColour
                          ),
                          const SizedBox(height: 7),

                          /* Button to take a level in the class */
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: (widget.charLevel <= widget.character.classLevels.reduce(sum) || (!multiclassingPossible(GlobalListManager().classList[index])))
                                ? unavailableColor
                                : ThemeManager.instance.currentScheme.backingColour,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                              side: const BorderSide(width: 3, color: positiveColor)
                            ),
                            onPressed: () {
                              setState(() {
                                List<Widget> newWidgetsInPlay = List.from(widget.widgetsInPlay);

                                // Check if the character can level up in the class
                                if (widget.charLevel > widget.character.classList.length && (multiclassingPossible(GlobalListManager().classList[index]))) {
                                  widget.character.classList.add(GlobalListManager().classList[index].name);

                                  if (GlobalListManager().classList[index].gainAtEachLevel[widget.character.classLevels[index]]
                                          .where((element) => element[0] == "Choice").isEmpty) {
                                    newWidgetsInPlay.add(StyleUtils.buildStyledSmallTextBox(text: "No choices needed for ${GlobalListManager().classList[index].name} level ${GlobalListManager().classList[index].gainAtEachLevel[widget.character.classLevels[index]][0][1]}"));
                                  } else {
                                    newWidgetsInPlay.add(StyleUtils.buildStyledMediumTextBox(text: "${GlobalListManager().classList[index].name} Level ${GlobalListManager().classList[index].gainAtEachLevel[widget.character.classLevels[index]][0][1]} choice(s):"));
                                  }

                                  for (List<dynamic> x in GlobalListManager().classList[index].gainAtEachLevel[widget.character.classLevels[index]]) {
                                    if (x[0] == "Choice") {
                                      newWidgetsInPlay.add(SizedBox(
                                          height: 85,
                                          child: ChoiceRow(
                                            x: x.sublist(1),
                                            allSelected: widget.character.allSelected,
                                          )));
                                    } else {
                                      levelGainParser(x, GlobalListManager().classList[index]);
                                    }
                                  }

                                  // Level 1 treated differently for levelling
                                  if (widget.character.classList.length == 1) {
                                    // Bonus feat if that option was selected
                                    if (widget.character.extraFeatAtLevel1 ?? false) {
                                      widget.onNumberOfRemainingFeatOrASIsChanged(widget.numberOfRemainingFeatOrASIs + 1);
                                    }

                                    // Gain hit points (max die roll at lvl 1)
                                    widget.character.maxHealth += GlobalListManager().classList[index].maxHitDiceRoll;
                                    
                                    // Gain saving throw proficiencies
                                    widget.character.savingThrowProficiencies = GlobalListManager().classList[index].savingThrowProficiencies;

                                    // Gain the equipment choices
                                    widget.character.equipmentSelectedFromChoices.addAll(GlobalListManager().classList[index].equipmentOptions);

                                    // Gain the skill proficiencies
                                    widget.character.classSkillsSelected = List.filled(GlobalListManager().classList[index].optionsForSkillProficiencies.length,false);

                                    // Add any further choices needed
                                    newWidgetsInPlay.addAll([
                                      StyleUtils.buildStyledSmallTextBox(text: "Pick ${(GlobalListManager().classList[index].numberOfSkillChoices)} skill(s) to gain proficiency in"),
                                      const SizedBox(height: 7),
                                      StatefulBuilder(
                                        builder: (context, setState) { return StyleUtils.buildStyledToggleSelector(
                                        itemLabels: GlobalListManager().classList[index].optionsForSkillProficiencies,
                                        isSelected: widget.character.classSkillsSelected,
                                        onPressed: (int subIndex, bool _) {
                                          setState(() {
                                          // Gain background skill choices
                                          if (widget.character.classSkillsSelected.where((b) => b).length <
                                              GlobalListManager().classList[index].numberOfSkillChoices) {
                                            widget.character.classSkillsSelected[subIndex] = !widget.character.classSkillsSelected[subIndex];
                                          } else {
                                            if (widget.character.classSkillsSelected[subIndex]) {
                                              widget.character.classSkillsSelected[subIndex] = false;
                                            }
                                          }
                                          widget.tabRebuildNotifier.value++;
                                        });}
                                      );})
                                    ]);
                                  }
                                  // Health calculated in a normal way if not level 1
                                  else {
                                    if (widget.character.averageHitPoints ?? false) {
                                      widget.character.maxHealth += ((GlobalListManager().classList[index].maxHitDiceRoll) / 2).ceil();
                                    } else {
                                      widget.character.maxHealth += 1 + (Random().nextDouble() * GlobalListManager().classList[index].maxHitDiceRoll).floor();
                                    }
                                  }

                                  // Check if it's a spellcaster, if so add the necessary spell info
                                  if (GlobalListManager().classList[index].classType != "Martial") {
                                    if (widget.character.classList.where((element) => element == GlobalListManager().classList[index].name).length == 1) {
                                      widget.character.allSpellsSelectedAsListsOfThings.add([
                                        GlobalListManager().classList[index].name,
                                        [],
                                        levelZeroGetSpellsKnown(index),
                                        GlobalListManager().classList[index].spellsKnownFormula ?? GlobalListManager().classList[index].spellsKnownPerLevel
                                      ]); 
                                    } else {
                                      var a = widget.character.classSubclassMapper[GlobalListManager().classList[index].name];
                                      for (var x = 0; x < widget.character.allSpellsSelectedAsListsOfThings.length; x++) {
                                        if (widget.character.allSpellsSelectedAsListsOfThings[x][0] == GlobalListManager().classList[index].name) {
                                          widget.character.allSpellsSelectedAsListsOfThings[x][2] =
                                              getSpellsKnown(
                                                  index,
                                                  widget.character.allSpellsSelectedAsListsOfThings[x]);
                                        } else if (a != null) {
                                          if (widget.character.allSpellsSelectedAsListsOfThings[x][0] == a) {
                                            widget.character.allSpellsSelectedAsListsOfThings[x][2] =
                                              getSpellsKnown(
                                                index,
                                                widget.character.allSpellsSelectedAsListsOfThings[x]
                                              );
                                          }
                                        }
                                      }
                                    }
                                  }

                                  // Increment the class level
                                  widget.character.classLevels[index]++;
                                  
                                  // Update widgets list
                                  widget.onWidgetsInPlayChanged(newWidgetsInPlay);
                                }
                              });
                              widget.onCharacterChanged();
                            },
                            child: Icon(Icons.add, color: ThemeManager.instance.currentScheme.textColour, size: 35))
                        ],
                      ));
                  }),
                ),
              )),
          Column(children: widget.widgetsInPlay)
        ]),
      ),
    ));    
  }
}
