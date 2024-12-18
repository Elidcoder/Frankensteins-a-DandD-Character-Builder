// External Imports
import "dart:collection";
import 'dart:math';

// Project Import
import 'non_character_classes/all_non_character_classes.dart';

class Character {
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
  Map<String, List<dynamic>> selections;
  List<dynamic> allSelected;
  Map<String, String> classSubclassMapper;
  //ASI feats
  List<int> featsASIScoreIncreases;
  List<List<dynamic>> featsSelected;
  bool ASIRemaining;
  int numberOfRemainingFeatOrASIs;
  bool halfFeats;
  bool fullFeats;
  //Spells
  List<Spell> allSpellsSelected;
  List<List<dynamic>> allSpellsSelectedAsListsOfThings;
  //Equipment
  Map<String, int> stackableEquipmentSelected;
  List<dynamic> unstackableEquipmentSelected;
  List<String> armourList;
  List<String> weaponList;
  List<String> itemList;
  String? coinTypeSelected;
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
    "Selections": selections,
    "AllSelected": allSelected,
    "ClassSubclassMapper": classSubclassMapper,
    "FeatsASIScoreIncreases": featsASIScoreIncreases,
    "FeatsSelected": featsSelected,
    "ASIRemaining": ASIRemaining,
    "NumberOfRemainingFeatOrASIs": numberOfRemainingFeatOrASIs,
    "HalfFeats": halfFeats,
    "FullFeats": fullFeats,
    "AllSpellsSelected": allSpellsSelected,
    "AllSpellsSelectedAsListsOfThings": allSpellsSelectedAsListsOfThings,
    "StackableEquipmentSelected": stackableEquipmentSelected,
    "UnstackableEquipmentSelected": unstackableEquipmentSelected,
    "ArmourList": armourList,
    "WeaponList": weaponList,
    "ItemList": itemList,
    "CoinTypeSelected": coinTypeSelected,
    "EquipmentSelectedFromChoices": equipmentSelectedFromChoices,
    "CharacterDescription": characterDescription
  };

  factory Character.fromJson(Map<String, dynamic> data) {
    final _extraFeatures = data["ExtraFeatures"] as String;
    final _group = data["Group"] as String?;
    final _levelsPerClass = data["LevelsPerClass"].cast<int>() as List<int>;
    final _selections = data["Selections"].cast<String, List<dynamic>>()
        as Map<String, List<dynamic>>;
    final _allSelected = data["AllSelected"] as List<dynamic>;
    final _classSubclassMapper = data["ClassSubclassMapper"]
        .cast<String, String>() as Map<String, String>;
    final _skillBonusMap =
        data["SkillBonusMap"].cast<String, int>() as Map<String, int>;
    final _ACList = data["ACList"].cast<List<dynamic>>() as List<List<dynamic>>;
    final _ASIRemaining = data["ASIRemaining"] as bool;
    final _uniqueID = data["UniqueID"] as int;

    final _allSpellsSelected = [
      for (var x in data["AllSpellsSelected"]) Spell.fromJson(x)
    ];
    final _allSpellsSelectedAsListsOfThings =
        data["AllSpellsSelectedAsListsOfThings"].cast<List<dynamic>>()
            as List<List<dynamic>>;
    final _armourList = data["ArmourList"].cast<String>() as List<String>;
    final _averageHitPoints = data["AverageHitPoints"] as bool;
    final _backgroundSkillChoices =
        data["BackgroundSkillChoices"].cast<bool>() as List<bool>;
    final _characterDescription = CharacterDescription.fromJson(data["CharacterDescription"]);

    final _coinTypeSelected = data["CoinTypeSelected"] as String;
    final _criticalRoleContent = data["CriticalRoleContent"] as bool;
    final _encumberanceRules = data["EncumberanceRules"] as bool;
    final _extraFeatAtLevel1 = data["ExtraFeatAtLevel1"] as bool;
    final _featsAllowed = data["FeatsAllowed"] as bool;
    final _featsSelected =
        data["FeatsSelected"].cast<List<dynamic>>() as List<List<dynamic>>;
    final _firearmsUsable = data["FirearmsUsable"] as bool;
    final _fullFeats = data["FullFeats"] as bool;
    final _halfFeats = data["HalfFeats"] as bool;
    final _includeCoinsForWeight = data["IncludeCoinsForWeight"] as bool;
    final _itemList = data["ItemList"].cast<String>() as List<String>;
    final _milestoneLevelling = data["MilestoneLevelling"];
    final _multiclassing = data["Multiclassing"] as bool;
    final _useCustomContent = data["UseCustomContent"] as bool;
    final _equipmentSelectedFromChoices =
        (data["EquipmentSelectedFromChoices"] ?? []) as List<dynamic>;
    final _optionalClassFeatures = data["OptionalClassFeatures"] as bool;
    final _optionalOnesStates = (data["OptionalOnesStates"] as List<dynamic>)
        .map((row) =>
            (row as List<dynamic>).map((value) => value as bool).toList())
        .toList();
    final _optionalTwosStates = (data["OptionalTwosStates"] as List<dynamic>)
        .map((row) =>
            (row as List<dynamic>).map((value) => value as bool).toList())
        .toList();
    //error
    final _speedBonuses = (data["SpeedBonuses"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key,
            (value as List<dynamic>).map((item) => item as String).toList()));
    final _unearthedArcanaContent = data["UnearthedArcanaContent"];
    final _weaponList = data["WeaponList"].cast<String>() as List<String>;
    final _numberOfRemainingFeatOrASIs =
        data["NumberOfRemainingFeatOrASIs"] as int;
    //error

    final _featuresAndTraits =
        data["FeaturesAndTraits"].cast<String>() as List<String>;
    final _classList = data["ClassList"].cast<String>() as List<String>;
    final _classSkillsSelected =
        data["ClassSkillsSelected"].cast<bool>() as List<bool>;
    Subrace? _subrace;
    if (data["Subrace"] != null) {
      _subrace = Subrace.fromJson(data["Subrace"]);
    }

    final _skillsSelected = Queue<int>()
            .addAll(data["SkillsSelected"]?.cast<int>() as List<int>? ?? [])
        as Queue<int>?;
    final _mainToolProficiencies =
        data["MainToolProficiencies"].cast<String>() as List<String>;
    final _savingThrowProficiencies =
        data["SavingThrowProficiencies"].cast<String>() as List<String>;
    final _skillProficiencies =
        data["SkillProficiencies"].cast<String>() as List<String>;
    final _maxHealth = data["MaxHealth"] as int;

    final _playerName = data["PlayerName"] as String;
    final _currency = data["Currency"].cast<String, int>() as Map<String, int>;
    final _classLevels = data["ClassLevels"].cast<int>() as List<int>;
    final _race = Race.fromJson(data["Race"]);
    final _background = Background.fromJson(data["Background"]);
    final _backgroundFlaw = data["BackgroundFlaw"] as String;
    final _backgroundPersonalityTrait =
        data["BackgroundPersonalityTrait"] as String;
    final _backgroundBond = data["BackgroundBond"] as String;
    final _backgroundIdeal = data["BackgroundIdeal"] as String;
    final _characterExperience = data["CharacterExperience"] as double;
    final _raceAbilityScoreIncreases =
        data["RaceAbilityScoreIncreases"].cast<int>() as List<int>;

    final _strength = AbilityScore.fromJson(data["Strength"]);
    final _dexterity = AbilityScore.fromJson(data["Dexterity"]);
    final _constitution = AbilityScore.fromJson(data["Constitution"]);
    final _intelligence = AbilityScore.fromJson(data["Intelligence"]);
    final _wisdom = AbilityScore.fromJson(data["Wisdom"]);
    final _charisma = AbilityScore.fromJson(data["Charisma"]);
    final _featsASIScoreIncreases =
        data["FeatsASIScoreIncreases"].cast<int>() as List<int>;
    final _inspired = data["Inspired"] as bool;
    final _languagesKnown =
        data["LanguagesKnown"].cast<String>() as List<String>;
    final _stackableEquipmentSelected = data["StackableEquipmentSelected"]
        .cast<String, int>() as Map<String, int>;
    final _unstackableEquipmentSelected =
        data["UnstackableEquipmentSelected"] as List<dynamic>;

    Character charToReturn = Character(
      skillBonusMap: _skillBonusMap,
      extraFeatures: _extraFeatures,
      levelsPerClass: _levelsPerClass,
      selections: _selections,
      allSelected: _allSelected,
      classSubclassMapper: _classSubclassMapper,
      ACList: _ACList,
      ASIRemaining: _ASIRemaining,
      allSpellsSelected: _allSpellsSelected,
      allSpellsSelectedAsListsOfThings: _allSpellsSelectedAsListsOfThings,
      armourList: _armourList,
      averageHitPoints: _averageHitPoints,
      backgroundSkillChoices: _backgroundSkillChoices,
      group: _group,
      coinTypeSelected: _coinTypeSelected,
      criticalRoleContent: _criticalRoleContent,
      encumberanceRules: _encumberanceRules,
      extraFeatAtLevel1: _extraFeatAtLevel1,
      featsAllowed: _featsAllowed,
      featsSelected: _featsSelected,
      firearmsUsable: _firearmsUsable,
      fullFeats: _fullFeats,
      halfFeats: _halfFeats,
      includeCoinsForWeight: _includeCoinsForWeight,
      itemList: _itemList,
      milestoneLevelling: _milestoneLevelling,
      multiclassing: _multiclassing,
      useCustomContent: _useCustomContent,
      equipmentSelectedFromChoices: _equipmentSelectedFromChoices,
      optionalClassFeatures: _optionalClassFeatures,
      optionalOnesStates: _optionalOnesStates,
      optionalTwosStates: _optionalTwosStates,
      speedBonuses: _speedBonuses,
      unearthedArcanaContent: _unearthedArcanaContent,
      weaponList: _weaponList,
      numberOfRemainingFeatOrASIs: _numberOfRemainingFeatOrASIs,
      languagesKnown: _languagesKnown,
      featuresAndTraits: _featuresAndTraits,
      skillsSelected: _skillsSelected,
      stackableEquipmentSelected: _stackableEquipmentSelected,
      unstackableEquipmentSelected: _unstackableEquipmentSelected,
      subrace: _subrace,
      classSkillsSelected: _classSkillsSelected,
      classList: _classList,
      savingThrowProficiencies: _savingThrowProficiencies,
      mainToolProficiencies: _mainToolProficiencies,
      inspired: _inspired,
      skillProficiencies: _skillProficiencies,
      maxHealth: _maxHealth,
      playerName: _playerName,
      background: _background,
      classLevels: _classLevels,
      race: _race,
      characterExperience: _characterExperience,
      currency: _currency,
      backgroundPersonalityTrait: _backgroundPersonalityTrait,
      backgroundIdeal: _backgroundIdeal,
      backgroundBond: _backgroundBond,
      backgroundFlaw: _backgroundFlaw,
      strength: _strength,
      dexterity: _dexterity,
      constitution: _constitution,
      intelligence: _intelligence,
      wisdom: _wisdom,
      charisma: _charisma,
      raceAbilityScoreIncreases: _raceAbilityScoreIncreases,
      featsASIScoreIncreases: _featsASIScoreIncreases,
      characterDescription: _characterDescription
    );
    charToReturn.uniqueID = _uniqueID;
    return charToReturn;
  }
  
  Character(
      {required this.skillBonusMap,
      required this.levelsPerClass,
      required this.extraFeatures,
      required this.selections,
      required this.allSelected,
      required this.classSubclassMapper,
      required this.ACList,
      required this.ASIRemaining,
      required this.allSpellsSelected,
      required this.allSpellsSelectedAsListsOfThings,
      required this.armourList,
      required this.averageHitPoints,
      required this.backgroundSkillChoices,
      required this.coinTypeSelected,
      required this.criticalRoleContent,
      required this.encumberanceRules,
      required this.extraFeatAtLevel1,
      required this.featsAllowed,
      required this.featsSelected,
      required this.firearmsUsable,
      required this.fullFeats,
      required this.halfFeats,
      required this.includeCoinsForWeight,
      required this.itemList,
      required this.milestoneLevelling,
      required this.multiclassing,
      required this.useCustomContent,
      required this.equipmentSelectedFromChoices,
      required this.optionalClassFeatures,
      required this.optionalOnesStates,
      required this.optionalTwosStates,
      required this.speedBonuses,
      required this.unearthedArcanaContent,
      required this.weaponList,
      required this.numberOfRemainingFeatOrASIs,
      //added stuff
      required this.unstackableEquipmentSelected,
      required this.featuresAndTraits,
      required this.languagesKnown,
      required this.classList,
      required this.stackableEquipmentSelected,
      required this.skillsSelected,
      required this.mainToolProficiencies,
      required this.savingThrowProficiencies,
      required this.skillProficiencies,
      required this.inspired,
      required this.maxHealth,
      required this.characterExperience,
      required this.playerName,
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
      this.subrace,
      this.group
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
      selections: selections,
      allSelected: allSelected,
      classSubclassMapper: classSubclassMapper,
      featsASIScoreIncreases: featsASIScoreIncreases,
      featsSelected: featsSelected,
      ASIRemaining: ASIRemaining,
      numberOfRemainingFeatOrASIs: numberOfRemainingFeatOrASIs,
      halfFeats: halfFeats,
      fullFeats: fullFeats,
      allSpellsSelected: allSpellsSelected,
      allSpellsSelectedAsListsOfThings: allSpellsSelectedAsListsOfThings,
      stackableEquipmentSelected: stackableEquipmentSelected,
      unstackableEquipmentSelected: unstackableEquipmentSelected,
      armourList: armourList,
      weaponList: weaponList,
      itemList: itemList,
      coinTypeSelected: coinTypeSelected,
      equipmentSelectedFromChoices: equipmentSelectedFromChoices,
      extraFeatures: extraFeatures,
      group: group,
      characterDescription: characterDescription
    );
  }
}
