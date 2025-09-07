// External Imports
import "dart:collection" show Queue;
import "dart:math" show Random;

import "package:frankenstein/models/character/ability_score/ability_score.dart" show AbilityScore;
import "package:frankenstein/models/character/character_description.dart" show CharacterDescription;
import 'package:json_annotation/json_annotation.dart';

import "../../storage/global_list_manager.dart";
// Project Import
import "../content/index.dart";

part 'character.g.dart';

// Helper functions for Queue serialization
Queue<String> _queueFromJson(List<dynamic>? json) => Queue<String>.from((json ?? []).cast<String>());
List<String> _queueToJson(Queue<String> queue) => queue.toList();

// Helper functions for Map<Feat, int> serialization
Map<Feat, int> _featsSelectedFromJson(List<dynamic>? json) {
  if (json == null) return {};
  Map<Feat, int> result = {};
  for (var item in json) {
    if (item is Map<String, dynamic> && item.containsKey('feat') && item.containsKey('count')) {
      try {
        Feat feat = Feat.fromJson(item['feat']);
        int count = item['count'] as int;
        result[feat] = count;
      } catch (e) {
        // Skip invalid entries
        continue;
      }
    }
  }
  return result;
}

List<Map<String, dynamic>> _featsSelectedToJson(Map<Feat, int> featsSelected) {
  return featsSelected.entries.map((entry) => {
    'feat': entry.key.toJson(),
    'count': entry.value,
  }).toList();
}

@JsonSerializable()
class Character {
  String get name => characterDescription.name;
  // make this final after removing the change UID in edit character
  int uniqueID;
  
  // Character information
  List<String> languagesKnown;
  List<String> featuresAndTraits;

  //general
  List<String> classList;
  Map<String, int> currency;
  String playerName;
  List<int> classLevels;
  bool inspired;
  List<String> mainToolProficiencies;
  Map<String, int> skillBonusMap;

  // Gained bonuses from background
  @JsonKey(fromJson: _queueFromJson, toJson: _queueToJson)
  Queue<String> skillsSelected;
  @JsonKey(fromJson: _queueFromJson, toJson: _queueToJson)
  Queue<String> languageChoices;

  String extraFeatures;
  //Basics
  Map<String, List<String>> speedBonuses;
  @JsonKey(name: 'ACList')
  List<List<dynamic>> ACList;

  // Build parameters
  bool? featsAllowed;
  bool? averageHitPoints;
  bool? multiclassing;
  bool? milestoneLevelling;
  bool? useCustomContent;
  bool? optionalClassFeatures;
  bool? criticalRoleContent;
  bool? encumberanceRules;
  bool? includeCoinsForWeight;
  bool? unearthedArcanaContent;
  bool? firearmsUsable;
  bool? extraFeatAtLevel1;

  List<String> savingThrowProficiencies;
  List<String> skillProficiencies;
  int maxHealth;

  double characterExperience;
  List<bool> classSkillsSelected;

  Race race;
  Subrace? subrace;
  //Races
  List<List<bool>>? optionalOnesStates;
  List<List<bool>>? optionalTwosStates;

  List<int> raceAbilityScoreIncreases;
  //Background
  Background background;
  String backgroundPersonalityTrait;
  String backgroundIdeal;
  String backgroundBond;
  String backgroundFlaw;

  //Ability scores
  AbilityScore strength;
  AbilityScore dexterity;
  AbilityScore constitution;
  AbilityScore intelligence;
  AbilityScore wisdom;
  AbilityScore charisma;
  //int pointsRemaining;
  //Class
  List<int> levelsPerClass;
  List<dynamic> allSelected;
  Map<String, String> classSubclassMapper;
  //ASI feats
  List<int> featsASIScoreIncreases;
  @JsonKey(fromJson: _featsSelectedFromJson, toJson: _featsSelectedToJson)
  Map<Feat, int> featsSelected;
  //Spells
  List<Spell> allSpellsSelected;
  List<List<dynamic>> allSpellsSelectedAsListsOfThings;
  //Equipment
  Map<String, int> stackableEquipmentSelected;
  List<dynamic> unstackableEquipmentSelected;
  List<String> armourList;
  List<String> weaponList;
  List<String> itemList;
  List<dynamic> equipmentSelectedFromChoices;

  // Backstory & character description information
  CharacterDescription characterDescription;

  //finishing up variables
  String? group;
  
  // Use generated methods with custom uniqueID handling
  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
  
  Map<String, dynamic> toJson() => _$CharacterToJson(this);
  
  Character(
      {required this.skillBonusMap,
      required this.levelsPerClass,
      required this.allSelected,
      required this.classSubclassMapper,
      required this.ACList,
      required this.allSpellsSelected,
      required this.allSpellsSelectedAsListsOfThings,
      required this.armourList,
      required this.featsSelected,
      required this.itemList,
      required this.equipmentSelectedFromChoices,
      required this.optionalOnesStates,
      required this.optionalTwosStates,
      required this.speedBonuses,
      required this.weaponList,
      required this.unstackableEquipmentSelected,
      required this.featuresAndTraits,
      required this.languagesKnown,
      required this.classList,
      required this.stackableEquipmentSelected,
      required this.skillsSelected,
      required this.languageChoices,
      required this.mainToolProficiencies,
      required this.savingThrowProficiencies,
      required this.skillProficiencies,
      required this.background,
      required this.classLevels,
      required this.race,
      required this.backgroundIdeal,
      required this.backgroundPersonalityTrait,
      required this.backgroundBond,
      required this.backgroundFlaw,
      required this.raceAbilityScoreIncreases,
      required this.strength,
      required this.dexterity,
      required this.classSkillsSelected,
      required this.constitution,
      required this.intelligence,
      required this.wisdom,
      required this.charisma,
      required this.featsASIScoreIncreases,
      required this.currency,
      required this.characterDescription,

      this.maxHealth = 0,
      this.characterExperience = 0,
      this.extraFeatures = "",
      this.playerName = "",
      this.multiclassing = true,
      this.featsAllowed = true,
      this.criticalRoleContent = false,
      this.encumberanceRules = false,
      this.extraFeatAtLevel1 = false,
      this.averageHitPoints = false,
      this.firearmsUsable = false,
      this.includeCoinsForWeight = false,
      this.unearthedArcanaContent = false,
      this.milestoneLevelling = false,
      this.useCustomContent = false,
      this.optionalClassFeatures = false,
      this.inspired = false,
      this.subrace,
      this.group,
      int? uniqueID,
      }) : uniqueID = uniqueID ?? int.parse([ 
        for(
          var i in List.generate(
            15, (_) => Random().nextInt(
              10
            )
          )
        )
        i.toString()
        ].join()
      );
  
  Character getCopy() {
    return Character(
      languagesKnown: languagesKnown,
      featuresAndTraits: featuresAndTraits,
      classList: classList,
      currency: currency,
      playerName: playerName,
      classLevels: classLevels,
      inspired: inspired,
      mainToolProficiencies: mainToolProficiencies,
      skillBonusMap: skillBonusMap,
      skillsSelected: skillsSelected, 
      languageChoices: languageChoices,
      speedBonuses: speedBonuses,
      ACList: ACList,
      featsAllowed: featsAllowed,
      averageHitPoints: averageHitPoints,
      multiclassing: multiclassing,
      milestoneLevelling: milestoneLevelling,
      useCustomContent: useCustomContent,
      optionalClassFeatures: optionalClassFeatures,
      criticalRoleContent: criticalRoleContent,
      encumberanceRules: encumberanceRules,
      includeCoinsForWeight: includeCoinsForWeight,
      unearthedArcanaContent: unearthedArcanaContent,
      firearmsUsable: firearmsUsable,
      extraFeatAtLevel1: extraFeatAtLevel1,
      savingThrowProficiencies: savingThrowProficiencies,
      skillProficiencies: skillProficiencies,
      maxHealth: maxHealth,
      characterExperience: characterExperience,
      classSkillsSelected: classSkillsSelected,
      race: race,
      subrace: subrace,
      optionalOnesStates: optionalOnesStates,
      optionalTwosStates: optionalTwosStates,
      raceAbilityScoreIncreases: raceAbilityScoreIncreases,
      background: background,
      backgroundPersonalityTrait: backgroundPersonalityTrait,
      backgroundIdeal: backgroundIdeal,
      backgroundBond: backgroundBond,
      backgroundFlaw: backgroundFlaw,
      strength: strength,
      dexterity: dexterity,
      constitution: constitution,
      intelligence: intelligence,
      wisdom: wisdom,
      charisma: charisma,
      levelsPerClass: levelsPerClass,
      allSelected: allSelected,
      classSubclassMapper: classSubclassMapper,
      featsASIScoreIncreases: featsASIScoreIncreases,
      featsSelected: featsSelected,
      allSpellsSelected: allSpellsSelected,
      allSpellsSelectedAsListsOfThings: allSpellsSelectedAsListsOfThings,
      stackableEquipmentSelected: stackableEquipmentSelected,
      unstackableEquipmentSelected: unstackableEquipmentSelected,
      armourList: armourList,
      weaponList: weaponList,
      itemList: itemList,
      equipmentSelectedFromChoices: equipmentSelectedFromChoices,
      extraFeatures: extraFeatures,
      group: group,
      characterDescription: characterDescription,
      // Generate new unique ID for the copy automatically
    );
  }

  factory Character.createDefault() {
    return Character(
      characterDescription: CharacterDescription(),
      skillBonusMap: {
        "Acrobatics": 0,
        "Animal Handling": 0,
        "Arcana": 0,
        "Athletics": 0,
        "Deception": 0,
        "History": 0,
        "Insight": 0,
        "Intimidation": 0,
        "Investigation": 0,
        "Medicine": 0,
        "Nature": 0,
        "Perception": 0,
        "Performance": 0,
        "Persuasion": 0,
        "Religion": 0,
        "Sleight of Hand": 0,
        "Stealth": 0,
        "Survival": 0,
        "Strength Saving Throw": 0,
        "Dexterity Saving Throw": 0,
        "Constitution Saving Throw": 0,
        "Intelligence Saving Throw": 0,
        "Wisdom Saving Throw": 0,
        "Charisma Saving Throw": 0,
        "Passive Perception": 0,
        "Initiative": 0,
      },
      levelsPerClass: List.filled(GlobalListManager().classList.length, 0),
      allSelected: [],
      classSubclassMapper: {},
      ACList: [
        ["10 + dexterity"]
      ],
      allSpellsSelected: [],
      allSpellsSelectedAsListsOfThings: [],
      armourList: [],
      featsSelected: {},
      itemList: [],
      equipmentSelectedFromChoices: [],
      optionalOnesStates: [
        [false, false, false, false, false, false],
        [false, false, false, false, false, false],
        [false, false, false, false, false, false],
        [false, false, false, false, false, false],
        [false, false, false, false, false, false]
      ],
      optionalTwosStates: [
        [false, false, false, false, false, false],
        [false, false, false, false, false, false],
        [false, false, false, false, false, false],
        [false, false, false, false, false, false],
        [false, false, false, false, false, false]
      ],
      speedBonuses: {
        "Hover": [],
        "Flying": [],
        "Walking": [],
        "Swimming": [],
        "Climbing": []
      },
      weaponList: [],
      classList: [],
      stackableEquipmentSelected: {},
      unstackableEquipmentSelected: [],
      classSkillsSelected: [],
      skillsSelected: Queue(),
      languageChoices: Queue(),
      mainToolProficiencies: [],
      savingThrowProficiencies: [],
      languagesKnown: ["Common"],
      featuresAndTraits: [],
      skillProficiencies: [],
      background: GlobalListManager().backgroundList.first,
      classLevels: List.filled(GlobalListManager().classList.length, 0),
      race: GlobalListManager().raceList.first,
      currency: {
        "Copper Pieces": 0,
        "Silver Pieces": 0,
        "Electrum Pieces": 0,
        "Gold Pieces": 0,
        "Platinum Pieces": 0
      },
      backgroundPersonalityTrait: GlobalListManager().backgroundList.first.personalityTrait.first,
      backgroundIdeal: GlobalListManager().backgroundList.first.ideal.first,
      backgroundBond: GlobalListManager().backgroundList.first.bond.first,
      backgroundFlaw: GlobalListManager().backgroundList.first.flaw.first,
      raceAbilityScoreIncreases: GlobalListManager().raceList.first.raceScoreIncrease,
      featsASIScoreIncreases: [0, 0, 0, 0, 0, 0],
      strength: AbilityScore(name: "Strength", value: 8),
      dexterity: AbilityScore(name: "Dexterity", value: 8),
      constitution: AbilityScore(name: "Constitution", value: 8),
      intelligence: AbilityScore(name: "Intelligence", value: 8),
      wisdom: AbilityScore(name: "Wisdom", value: 8),
      charisma: AbilityScore(name: "Charisma", value: 8),
    );
  }

  // Helper functions for checking creation status
  bool get basicsComplete => (
    characterDescription.name.replaceAll(" ", "") != "" &&
    characterDescription.gender.replaceAll(" ", "") != "" &&
    playerName.replaceAll(" ", "") != ""
    // FUTUREPLAN(When experience is implemented, implement this)
    /* &&(enteredExperience.replaceAll(" ", "") != "" || levellingMethod != "Experience")*/
  );

  bool get backstoryComplete => (
    characterDescription.age.replaceAll(" ", "") != "" &&
    characterDescription.height.replaceAll(" ", "") != "" &&
    characterDescription.weight.replaceAll(" ", "") != "" &&
    characterDescription.eyes.replaceAll(" ", "") != "" &&
    characterDescription.skin.replaceAll(" ", "") != "" &&
    characterDescription.hair.replaceAll(" ", "") != "" &&
    characterDescription.backstory.replaceAll(" ", "") != "" &&
    extraFeatures.replaceAll(" ", "") != ""
  );

  bool get chosenAllSpells => (allSpellsSelectedAsListsOfThings.where((element) => element[2] != 0).isEmpty);

  bool get chosenAllEqipment => (equipmentSelectedFromChoices.where((element) => element.length == 2).isEmpty);

  @override
  int get hashCode => uniqueID.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character && runtimeType == other.runtimeType && uniqueID == other.uniqueID;

  List<AbilityScore> get abilityScores => [
    strength,
    dexterity,
    constitution,
    intelligence,
    wisdom,
    charisma
  ];
}
