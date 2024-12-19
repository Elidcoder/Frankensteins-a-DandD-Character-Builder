// External Imports
import "dart:collection";
import 'dart:math';

// Project Import
import 'non_character_classes/all_non_character_classes.dart';

class Character implements Named {
  @override
  String get name => characterDescription.name;
  // make this final after removing the change UID in edit character
  int uniqueID ;
  
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
  Queue<int>? skillsSelected;
  
  String extraFeatures;
  //Basics
  Map<String, List<String>> speedBonuses;
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
  List<bool> backgroundSkillChoices;

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
  List<List<dynamic>> featsSelected;

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
  Map<String, dynamic> toJson() => {
    "ExtraFeatures": extraFeatures,
    "SkillBonusMap": skillBonusMap,
    "Group": group,
    "LanguagesKnown": languagesKnown,
    "FeaturesAndTraits": featuresAndTraits,
    "ClassList": classList,
    "Currency": currency,
    "UniqueID": uniqueID,
    "PlayerName": playerName,
    "ClassLevels": classLevels,
    "Inspired": inspired,
    "MainToolProficiencies": mainToolProficiencies,
    "SkillsSelected": skillsSelected?.toList(),
    "SpeedBonuses": speedBonuses,
    "ACList": ACList,
    "FeatsAllowed": featsAllowed,
    "AverageHitPoints": averageHitPoints,
    "Multiclassing": multiclassing,
    "MilestoneLevelling": milestoneLevelling,
    "UseCustomContent": useCustomContent,
    "OptionalClassFeatures": optionalClassFeatures,
    "CriticalRoleContent": criticalRoleContent,
    "EncumberanceRules": encumberanceRules,
    "IncludeCoinsForWeight": includeCoinsForWeight,
    "UnearthedArcanaContent": unearthedArcanaContent,
    "FirearmsUsable": firearmsUsable,
    "ExtraFeatAtLevel1": extraFeatAtLevel1,
    "SavingThrowProficiencies": savingThrowProficiencies,
    "SkillProficiencies": skillProficiencies,
    "MaxHealth": maxHealth,
    "CharacterExperience": characterExperience,
    "ClassSkillsSelected": classSkillsSelected,
    "Race": race,
    "Subrace": subrace,
    "OptionalOnesStates": optionalOnesStates,
    "OptionalTwosStates": optionalTwosStates,
    "RaceAbilityScoreIncreases": raceAbilityScoreIncreases,
    "Background": background,
    "BackgroundPersonalityTrait": backgroundPersonalityTrait,
    "BackgroundIdeal": backgroundIdeal,
    "BackgroundBond": backgroundBond,
    "BackgroundFlaw": backgroundFlaw,
    "BackgroundSkillChoices": backgroundSkillChoices,
    "Strength": strength,
    "Dexterity": dexterity,
    "Constitution": constitution,
    "Intelligence": intelligence,
    "Wisdom": wisdom,
    "Charisma": charisma,
    //"PointsRemaining": pointsRemaining,
    "LevelsPerClass": levelsPerClass,
    "AllSelected": allSelected,
    "ClassSubclassMapper": classSubclassMapper,
    "FeatsASIScoreIncreases": featsASIScoreIncreases,
    "FeatsSelected": featsSelected,
    "AllSpellsSelected": allSpellsSelected,
    "AllSpellsSelectedAsListsOfThings": allSpellsSelectedAsListsOfThings,
    "StackableEquipmentSelected": stackableEquipmentSelected,
    "UnstackableEquipmentSelected": unstackableEquipmentSelected,
    "ArmourList": armourList,
    "WeaponList": weaponList,
    "ItemList": itemList,
    "EquipmentSelectedFromChoices": equipmentSelectedFromChoices,
    "CharacterDescription": characterDescription
  };

  factory Character.fromJson(Map<String, dynamic> data) {
    final extraFeatures_ = data["ExtraFeatures"] as String;
    final group_ = data["Group"] as String?;
    final levelsPerClass_ = data["LevelsPerClass"].cast<int>() as List<int>;
    final allSelected_ = data["AllSelected"] as List<dynamic>;
    final classSubclassMapper_ = data["ClassSubclassMapper"]
        .cast<String, String>() as Map<String, String>;
    final skillBonusMap_ =
        data["SkillBonusMap"].cast<String, int>() as Map<String, int>;
    final ACList_ = data["ACList"].cast<List<dynamic>>() as List<List<dynamic>>;
    final uniqueID_ = data["UniqueID"] as int;

    final allSpellsSelected_ = [
      for (var x in data["AllSpellsSelected"]) Spell.fromJson(x)
    ];
    final allSpellsSelectedAsListsOfThings_ =
        data["AllSpellsSelectedAsListsOfThings"].cast<List<dynamic>>()
            as List<List<dynamic>>;
    final armourList_ = data["ArmourList"].cast<String>() as List<String>;
    final averageHitPoints_ = data["AverageHitPoints"] as bool;
    final backgroundSkillChoices_ =
        data["BackgroundSkillChoices"].cast<bool>() as List<bool>;
    final characterDescription_ = CharacterDescription.fromJson(data["CharacterDescription"]);

    final criticalRoleContent_ = data["CriticalRoleContent"] as bool;
    final encumberanceRules_ = data["EncumberanceRules"] as bool;
    final extraFeatAtLevel1_ = data["ExtraFeatAtLevel1"] as bool;
    final featsAllowed_ = data["FeatsAllowed"] as bool;
    final featsSelected_ =
        data["FeatsSelected"].cast<List<dynamic>>() as List<List<dynamic>>;
    final firearmsUsable_ = data["FirearmsUsable"] as bool;
    final includeCoinsForWeight_ = data["IncludeCoinsForWeight"] as bool;
    final itemList_ = data["ItemList"].cast<String>() as List<String>;
    final milestoneLevelling_ = data["MilestoneLevelling"];
    final multiclassing_ = data["Multiclassing"] as bool;
    final useCustomContent_ = data["UseCustomContent"] as bool;
    final equipmentSelectedFromChoices_ =
        (data["EquipmentSelectedFromChoices"] ?? []) as List<dynamic>;
    final optionalClassFeatures_ = data["OptionalClassFeatures"] as bool;
    final optionalOnesStates_ = (data["OptionalOnesStates"] as List<dynamic>)
        .map((row) =>
            (row as List<dynamic>).map((value) => value as bool).toList())
        .toList();
    final optionalTwosStates_ = (data["OptionalTwosStates"] as List<dynamic>)
        .map((row) =>
            (row as List<dynamic>).map((value) => value as bool).toList())
        .toList();
    //error
    final speedBonuses_ = (data["SpeedBonuses"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key,
            (value as List<dynamic>).map((item) => item as String).toList()));
    final unearthedArcanaContent_ = data["UnearthedArcanaContent"];
    final weaponList_ = data["WeaponList"].cast<String>() as List<String>;
    //error

    final featuresAndTraits_ =
        data["FeaturesAndTraits"].cast<String>() as List<String>;
    final classList_ = data["ClassList"].cast<String>() as List<String>;
    final classSkillsSelected_ =
        data["ClassSkillsSelected"].cast<bool>() as List<bool>;
    Subrace? subrace_;
    if (data["Subrace"] != null) {
      subrace_ = Subrace.fromJson(data["Subrace"]);
    }

    final skillsSelected_ = Queue<int>()
            .addAll(data["SkillsSelected"]?.cast<int>() as List<int>? ?? [])
        as Queue<int>?;
    final mainToolProficiencies_ =
        data["MainToolProficiencies"].cast<String>() as List<String>;
    final savingThrowProficiencies_ =
        data["SavingThrowProficiencies"].cast<String>() as List<String>;
    final skillProficiencies_ =
        data["SkillProficiencies"].cast<String>() as List<String>;
    final maxHealth_ = data["MaxHealth"] as int;

    final playerName_ = data["PlayerName"] as String;
    final currency_ = data["Currency"].cast<String, int>() as Map<String, int>;
    final classLevels_ = data["ClassLevels"].cast<int>() as List<int>;
    final race_ = Race.fromJson(data["Race"]);
    final background_ = Background.fromJson(data["Background"]);
    final backgroundFlaw_ = data["BackgroundFlaw"] as String;
    final backgroundPersonalityTrait_ =
        data["BackgroundPersonalityTrait"] as String;
    final backgroundBond_ = data["BackgroundBond"] as String;
    final backgroundIdeal_ = data["BackgroundIdeal"] as String;
    final characterExperience_ = data["CharacterExperience"] as double;
    final raceAbilityScoreIncreases_ =
        data["RaceAbilityScoreIncreases"].cast<int>() as List<int>;

    final strength_ = AbilityScore.fromJson(data["Strength"]);
    final dexterity_ = AbilityScore.fromJson(data["Dexterity"]);
    final constitution_ = AbilityScore.fromJson(data["Constitution"]);
    final intelligence_ = AbilityScore.fromJson(data["Intelligence"]);
    final wisdom_ = AbilityScore.fromJson(data["Wisdom"]);
    final charisma_ = AbilityScore.fromJson(data["Charisma"]);
    final featsASIScoreIncreases_ =
        data["FeatsASIScoreIncreases"].cast<int>() as List<int>;
    final inspired_ = data["Inspired"] as bool;
    final languagesKnown_ =
        data["LanguagesKnown"].cast<String>() as List<String>;
    final stackableEquipmentSelected_ = data["StackableEquipmentSelected"]
        .cast<String, int>() as Map<String, int>;
    final unstackableEquipmentSelected_ =
        data["UnstackableEquipmentSelected"] as List<dynamic>;

    Character charToReturn = Character(
      skillBonusMap: skillBonusMap_,
      extraFeatures: extraFeatures_,
      levelsPerClass: levelsPerClass_,
      allSelected: allSelected_,
      classSubclassMapper: classSubclassMapper_,
      ACList: ACList_,
      allSpellsSelected: allSpellsSelected_,
      allSpellsSelectedAsListsOfThings: allSpellsSelectedAsListsOfThings_,
      armourList: armourList_,
      averageHitPoints: averageHitPoints_,
      backgroundSkillChoices: backgroundSkillChoices_,
      group: group_,
      criticalRoleContent: criticalRoleContent_,
      encumberanceRules: encumberanceRules_,
      extraFeatAtLevel1: extraFeatAtLevel1_,
      featsAllowed: featsAllowed_,
      featsSelected: featsSelected_,
      firearmsUsable: firearmsUsable_,
      includeCoinsForWeight: includeCoinsForWeight_,
      itemList: itemList_,
      milestoneLevelling: milestoneLevelling_,
      multiclassing: multiclassing_,
      useCustomContent: useCustomContent_,
      equipmentSelectedFromChoices: equipmentSelectedFromChoices_,
      optionalClassFeatures: optionalClassFeatures_,
      optionalOnesStates: optionalOnesStates_,
      optionalTwosStates: optionalTwosStates_,
      speedBonuses: speedBonuses_,
      unearthedArcanaContent: unearthedArcanaContent_,
      weaponList: weaponList_,
      languagesKnown: languagesKnown_,
      featuresAndTraits: featuresAndTraits_,
      skillsSelected: skillsSelected_,
      stackableEquipmentSelected: stackableEquipmentSelected_,
      unstackableEquipmentSelected: unstackableEquipmentSelected_,
      subrace: subrace_,
      classSkillsSelected: classSkillsSelected_,
      classList: classList_,
      savingThrowProficiencies: savingThrowProficiencies_,
      mainToolProficiencies: mainToolProficiencies_,
      inspired: inspired_,
      skillProficiencies: skillProficiencies_,
      maxHealth: maxHealth_,
      playerName: playerName_,
      background: background_,
      classLevels: classLevels_,
      race: race_,
      characterExperience: characterExperience_,
      currency: currency_,
      backgroundPersonalityTrait: backgroundPersonalityTrait_,
      backgroundIdeal: backgroundIdeal_,
      backgroundBond: backgroundBond_,
      backgroundFlaw: backgroundFlaw_,
      strength: strength_,
      dexterity: dexterity_,
      constitution: constitution_,
      intelligence: intelligence_,
      wisdom: wisdom_,
      charisma: charisma_,
      raceAbilityScoreIncreases: raceAbilityScoreIncreases_,
      featsASIScoreIncreases: featsASIScoreIncreases_,
      characterDescription: characterDescription_
    );
    charToReturn.uniqueID = uniqueID_;
    return charToReturn;
  }
  
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
      required this.backgroundSkillChoices,
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
      }
    ):
      uniqueID = int.parse([ 
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
      backgroundSkillChoices: backgroundSkillChoices,
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
      characterDescription: characterDescription
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
      levelsPerClass: List.filled(CLASSLIST.length, 0),
      allSelected: [],
      classSubclassMapper: {},
      ACList: [
        ["10 + dexterity"]
      ],
      allSpellsSelected: [],
      allSpellsSelectedAsListsOfThings: [],
      armourList: [],
      backgroundSkillChoices: (List.filled(BACKGROUNDLIST.first.numberOfSkillChoices ?? 0, true) +
          List.filled(
              (BACKGROUNDLIST.first.optionalSkillProficiencies?.length ?? 0) -
                  (BACKGROUNDLIST.first.numberOfSkillChoices ?? 0),
              false)),
      featsSelected: [],
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
      skillsSelected: Queue<int>.from(
      Iterable.generate(BACKGROUNDLIST.first.numberOfSkillChoices ?? 0)),
      mainToolProficiencies: [],
      savingThrowProficiencies: [],
      languagesKnown: ["Common"],
      featuresAndTraits: [],
      skillProficiencies: [],
      background: BACKGROUNDLIST.first,
      classLevels: List.filled(CLASSLIST.length, 0),
      race: RACELIST.first,
      currency: {
        "Copper Pieces": 0,
        "Silver Pieces": 0,
        "Electrum Pieces": 0,
        "Gold Pieces": 0,
        "Platinum Pieces": 0
      },
      backgroundPersonalityTrait: BACKGROUNDLIST.first.personalityTrait.first,
      backgroundIdeal: BACKGROUNDLIST.first.ideal.first,
      backgroundBond: BACKGROUNDLIST.first.bond.first,
      backgroundFlaw: BACKGROUNDLIST.first.flaw.first,
      raceAbilityScoreIncreases: RACELIST.first.raceScoreIncrease,
      featsASIScoreIncreases: [0, 0, 0, 0, 0, 0],
      strength: AbilityScore(name: "Strength", value: 8),
      dexterity: AbilityScore(name: "Dexterity", value: 8),
      constitution: AbilityScore(name: "Constitution", value: 8),
      intelligence: AbilityScore(name: "Intelligence", value: 8),
      wisdom: AbilityScore(name: "Wisdom", value: 8),
      charisma: AbilityScore(name: "Charisma", value: 8),
    );
  }
}
