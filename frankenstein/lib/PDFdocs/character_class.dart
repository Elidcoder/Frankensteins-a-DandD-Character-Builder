import "package:frankenstein/globals.dart";
import "dart:collection";

class AbilityScore {
  int value;
  String name;

  AbilityScore({required this.name, required this.value});

  factory AbilityScore.fromJson(Map<String, dynamic> json) => AbilityScore(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}

class Character {
  //general
  final List<String> languagesKnown;
  final List<String> featuresAndTraits;
  final List<String> classList;
  final Map<String, int> currency;
  final String name;
  final String playerName;
  final List<int> classLevels;
  final bool inspired;
  final List<String> mainToolProficiencies;
  final Queue<int>? skillsSelected;
  //Basics
  final Map<String, List<String>> speedBonuses;
  final List<List<dynamic>> ACList;
  final String gender;
  final bool? featsAllowed;
  final bool? averageHitPoints;
  final bool? multiclassing;
  final bool? milestoneLevelling;
  final bool? useCustomContent;
  final bool? optionalClassFeatures;
  final bool? criticalRoleContent;
  final bool? encumberanceRules;
  final bool? includeCoinsForWeight;
  final bool? unearthedArcanaContent;
  final bool? firearmsUsable;
  final bool? extraFeatAtLevel1;

  final List<String> savingThrowProficiencies;
  final List<String> skillProficiencies;
  final int maxHealth;

  final int characterExperience;
  final List<bool> classSkillsSelected;

  final Race race;
  final Subrace? subrace;
  //Races
  final List<List<bool>>? optionalOnesStates;
  final List<List<bool>>? optionalTwosStates;

  final List<int> raceAbilityScoreIncreases;
  //Background
  final Background background;
  final String backgroundPersonalityTrait;
  final String backgroundIdeal;
  final String backgroundBond;
  final String backgroundFlaw;
  final List<bool> backgroundSkillChoices;
  //Ability scores
  final AbilityScore strength;
  final AbilityScore dexterity;
  final AbilityScore constitution;
  final AbilityScore intelligence;
  final AbilityScore wisdom;
  final AbilityScore charisma;
  final int pointsRemaining;
  //Class
  final List<int> levelsPerClass;
  final Map<String, List<dynamic>> selections;
  final List<dynamic> allSelected;
  final Map<String, String> classSubclassMapper;
  //ASI feats
  final List<int> featsASIScoreIncreases;
  final List<List<dynamic>> featsSelected;
  final bool ASIRemaining;
  final int numberOfRemainingFeatOrASIs;
  final bool halfFeats;
  final bool fullFeats;
  //Spells
  final List<Spell> allSpellsSelected;
  final List<List<dynamic>> allSpellsSelectedAsListsOfThings;
  //Equipment
  final Map<String, int> stackableEquipmentSelected;
  final List<dynamic> unstackableEquipmentSelected;
  final List<String> armourList;
  final List<String> weaponList;
  final List<String> itemList;
  final String? coinTypeSelected;
  final List<dynamic>? equipmentSelectedFromChoices;
  //Background
  final String characterAge;
  final String characterHeight;
  final String characterWeight;
  final String characterEyes;
  final String characterSkin;
  final String characterHair;
  Map<String, dynamic> toJson() => {
        "languagesKnown": languagesKnown,
        "featuresAndTraits": featuresAndTraits,
        "classList": classList,
        "currency": currency,
        "name": name,
        "playerName": playerName,
        "classLevels": classLevels,
        "inspired": inspired,
        "mainToolProficiencies": mainToolProficiencies,
        "skillsSelected": skillsSelected?.toList(),
        "speedBonuses": speedBonuses,
        "ACList": ACList,
        "gender": gender,
        "featsAllowed": featsAllowed,
        "averageHitPoints": averageHitPoints,
        "multiclassing": multiclassing,
        "milestoneLevelling": milestoneLevelling,
        "useCustomContent": useCustomContent,
        "optionalClassFeatures": optionalClassFeatures,
        "criticalRoleContent": criticalRoleContent,
        "encumberanceRules": encumberanceRules,
        "includeCoinsForWeight": includeCoinsForWeight,
        "unearthedArcanaContent": unearthedArcanaContent,
        "firearmsUsable": firearmsUsable,
        "extraFeatAtLevel1": extraFeatAtLevel1,
        "savingThrowProficiencies": savingThrowProficiencies,
        "skillProficiencies": skillProficiencies,
        "maxHealth": maxHealth,
        "characterExperience": characterExperience,
        "classSkillsSelected": classSkillsSelected,
        "race": race,
        "subrace": subrace,
        "optionalOnesStates": optionalOnesStates,
        "optionalTwosStates": optionalTwosStates,
        "raceAbilityScoreIncreases": raceAbilityScoreIncreases,
        "background": background,
        "backgroundPersonalityTrait": backgroundPersonalityTrait,
        "backgroundIdeal": backgroundIdeal,
        "backgroundBond": backgroundBond,
        "backgroundFlaw": backgroundFlaw,
        "backgroundSkillChoices": backgroundSkillChoices,
        "strength": strength,
        "dexterity": dexterity,
        "constitution": constitution,
        "intelligence": intelligence,
        "wisdom": wisdom,
        "charisma": charisma,
        "pointsRemaining": pointsRemaining,
        "levelsPerClass": levelsPerClass,
        "selections": selections,
        "allSelected": allSelected,
        "classSubclassMapper": classSubclassMapper,
        "featsASIScoreIncreases": featsASIScoreIncreases,
        "featsSelected": featsSelected,
        "ASIRemaining": ASIRemaining,
        "numberOfRemainingFeatOrASIs": numberOfRemainingFeatOrASIs,
        "halfFeats": halfFeats,
        "fullFeats": fullFeats,
        "allSpellsSelected": allSpellsSelected,
        "allSpellsSelectedAsListsOfThings": allSpellsSelectedAsListsOfThings,
        "stackableEquipmentSelected": stackableEquipmentSelected,
        "unstackableEquipmentSelected": unstackableEquipmentSelected,
        "armourList": armourList,
        "weaponList": weaponList,
        "itemList": itemList,
        "coinTypeSelected": coinTypeSelected,
        "equipmentSelectedFromChoices": equipmentSelectedFromChoices,
        "characterAge": characterAge,
        "characterHeight": characterHeight,
        "characterWeight": characterWeight,
        "characterEyes": characterEyes,
      };

  factory Character.fromJson(Map<String, dynamic> data) {
    final levelsPerClass = data["LevelsPerClass"].cast<int>() as List<int>;
    final selections = data["Selections"].cast<String, List<dynamic>>()
        as Map<String, List<dynamic>>;
    final allSelected = data["AllSelected"] as List<dynamic>;
    final classSubclassMapper = data["ClassSubclassMapper"]
        .cast<String, String>() as Map<String, String>;

    final ACList = data["ACList"].cast<List<dynamic>>() as List<List<dynamic>>;
    final ASIRemaining = data["ASIRemaining"] as bool;
    final allSpellsSelected =
        data["AllSpellsSelected"].cast<Spell>() as List<Spell>;
    final allSpellsSelectedAsListsOfThings =
        data["AllSpellsSelectedAsListsOfThings"].cast<List<dynamic>>()
            as List<List<dynamic>>;
    final armourList = data["ArmourList"].cast<String>() as List<String>;
    final averageHitPoints = data["AverageHitPoints"] as bool;
    final backgroundSkillChoices =
        data["BackgroundSkillChoices"].cast<bool>() as List<bool>;
    final characterAge = data["CharacterAge"] as String;
    final characterEyes = data["CharacterEyes"] as String;
    final characterHair = data["CharacterHair"] as String;
    final characterHeight = data["CharacterHeight"] as String;
    final characterSkin = data["CharacterSkin"] as String;
    final characterWeight = data["CharacterWeight"] as String;
    final coinTypeSelected = data["CoinTypeSelected"] as String;
    final criticalRoleContent = data["CriticalRoleContent"] as bool;
    final encumberanceRules = data["EncumberanceRules"] as bool;
    final extraFeatAtLevel1 = data["ExtraFeatAtLevel1"] as bool;
    final featsAllowed = data["FeatsAllowed"] as bool;
    final featsSelected =
        data["FeatsSelected"].cast<List<dynamic>>() as List<List<dynamic>>;
    final firearmsUsable = data["FirearmsUsable"] as bool;
    final fullFeats = data["FullFeats"] as bool;
    final halfFeats = data["HalfFeats"] as bool;
    final gender = data["Gender"] as String;
    final includeCoinsForWeight = data["IncludeCoinsForWeight"] as bool;
    final itemList = data["ItemList"].cast<String>() as List<String>;
    final milestoneLevelling = data["MilestoneLevelling"];
    final multiclassing = data["Multiclassing"] as bool;
    final useCustomContent = data["UseCustomContent"] as bool;
    final equipmentSelectedFromChoices =
        data["EquipmentSelectedFromChoices"] as List<dynamic>;
    final optionalClassFeatures = data["OptionalClassFeatures"] as bool;
    final optionalOnesStates = (data["OptionalOnesStates"] as List<dynamic>)
        .map((row) =>
            (row as List<dynamic>).map((value) => value as bool).toList())
        .toList();
    final optionalTwosStates = (data["OptionalTwosStates"] as List<dynamic>)
        .map((row) =>
            (row as List<dynamic>).map((value) => value as bool).toList())
        .toList();
    final pointsRemaining = data["PointsRemaining"] as int;

    //error
    final speedBonuses = (data["SpeedBonuses"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key,
            (value as List<dynamic>).map((item) => item as String).toList()));
    final unearthedArcanaContent = data["UnearthedArcanaContent"];
    final weaponList = data["WeaponList"].cast<String>() as List<String>;
    final numberOfRemainingFeatOrASIs =
        data["NumberOfRemainingFeatOrASIs"] as int;
    //error

    final featuresAndTraits =
        data["FeaturesAndTraits"].cast<String>() as List<String>;
    final classList = data["ClassList"].cast<String>() as List<String>;
    final name = data["Name"] as String;
    final classSkillsSelected =
        data["ClassSkillsSelected"].cast<bool>() as List<bool>;
    final subrace = data["Subrace"] as Subrace;
    final skillsSelected = data["SkillsSelected"] as Queue<int>?;
    final mainToolProficiencies =
        data["MainToolProficiencies"].cast<String>() as List<String>;
    final savingThrowProficiencies =
        data["SavingThrowProficiencies"].cast<String>() as List<String>;
    final skillProficiencies =
        data["SkillProficiencies"].cast<String>() as List<String>;
    final maxHealth = data["MaxHealth"] as int;

    final playerName = data["PlayerName"] as String;
    final currency = data["Currency"] as Map<String, int>;
    final classLevels = data["ClassLevels"].cast<int>() as List<int>;
    final race = data["Race"] as Race;
    final background = data["Background"] as Background;
    final backgroundFlaw = data["BackgroundFlaw"] as String;
    final backgroundPersonalityTrait =
        data["BackgroundPersonalityTrait"] as String;
    final backgroundBond = data["BackgroundBond"] as String;
    final backgroundIdeal = data["BackgroundIdeal"] as String;
    final characterExperience = data["CharacterExperience"] as int;
    final raceAbilityScoreIncreases =
        data["RaceAbilityScoreIncreases"].cast<int>() as List<int>;

    final strength = data["Strength"] as AbilityScore;
    final dexterity = data["Dexterity"] as AbilityScore;
    final constitution = data["Constitution"] as AbilityScore;
    final intelligence = data["Intelligence"] as AbilityScore;
    final wisdom = data["Wisdom"] as AbilityScore;
    final charisma = data["Charisma"] as AbilityScore;
    final featsASIScoreIncreases =
        data["FeatsASIScoreIncreases"].cast<int>() as List<int>;
    final inspired = data["Inspired"] as bool;
    final languagesKnown =
        data["LanguagesKnown"].cast<String>() as List<String>;
    final stackableEquipmentSelected = data["StackableEquipmentSelected"]
        .cast<String, int>() as Map<String, int>;
    final unstackableEquipmentSelected =
        data["UnunstackableEquipmentSelected"] as List<dynamic>;
    return Character(
      levelsPerClass: levelsPerClass,
      selections: selections,
      allSelected: allSelected,
      classSubclassMapper: classSubclassMapper,
      ACList: ACList,
      ASIRemaining: ASIRemaining,
      allSpellsSelected: allSpellsSelected,
      allSpellsSelectedAsListsOfThings: allSpellsSelectedAsListsOfThings,
      armourList: armourList,
      averageHitPoints: averageHitPoints,
      backgroundSkillChoices: backgroundSkillChoices,
      characterAge: characterAge,
      characterEyes: characterEyes,
      characterHair: characterHair,
      characterHeight: characterHeight,
      characterSkin: characterSkin,
      characterWeight: characterWeight,
      coinTypeSelected: coinTypeSelected,
      criticalRoleContent: criticalRoleContent,
      encumberanceRules: encumberanceRules,
      extraFeatAtLevel1: extraFeatAtLevel1,
      featsAllowed: featsAllowed,
      featsSelected: featsSelected,
      firearmsUsable: firearmsUsable,
      fullFeats: fullFeats,
      halfFeats: halfFeats,
      gender: gender,
      includeCoinsForWeight: includeCoinsForWeight,
      itemList: itemList,
      milestoneLevelling: milestoneLevelling,
      multiclassing: multiclassing,
      useCustomContent: useCustomContent,
      equipmentSelectedFromChoices: equipmentSelectedFromChoices,
      optionalClassFeatures: optionalClassFeatures,
      optionalOnesStates: optionalOnesStates,
      optionalTwosStates: optionalTwosStates,
      pointsRemaining: pointsRemaining,
      speedBonuses: speedBonuses,
      unearthedArcanaContent: unearthedArcanaContent,
      weaponList: weaponList,
      numberOfRemainingFeatOrASIs: numberOfRemainingFeatOrASIs,
      languagesKnown: languagesKnown,
      featuresAndTraits: featuresAndTraits,
      skillsSelected: skillsSelected,
      stackableEquipmentSelected: stackableEquipmentSelected,
      unstackableEquipmentSelected: unstackableEquipmentSelected,
      subrace: subrace,
      classSkillsSelected: classSkillsSelected,
      classList: classList,
      savingThrowProficiencies: savingThrowProficiencies,
      mainToolProficiencies: mainToolProficiencies,
      inspired: inspired,
      skillProficiencies: skillProficiencies,
      maxHealth: maxHealth,
      name: name,
      playerName: playerName,
      background: background,
      classLevels: classLevels,
      race: race,
      characterExperience: characterExperience,
      currency: currency,
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
      raceAbilityScoreIncreases: raceAbilityScoreIncreases,
      featsASIScoreIncreases: featsASIScoreIncreases,
    );
  }
  Character(
      {required this.levelsPerClass,
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
      required this.characterAge,
      required this.characterEyes,
      required this.characterHair,
      required this.characterHeight,
      required this.characterSkin,
      required this.characterWeight,
      required this.coinTypeSelected,
      required this.criticalRoleContent,
      required this.encumberanceRules,
      required this.extraFeatAtLevel1,
      required this.featsAllowed,
      required this.featsSelected,
      required this.firearmsUsable,
      required this.fullFeats,
      required this.halfFeats,
      required this.gender,
      required this.includeCoinsForWeight,
      required this.itemList,
      required this.milestoneLevelling,
      required this.multiclassing,
      required this.useCustomContent,
      required this.equipmentSelectedFromChoices,
      required this.optionalClassFeatures,
      required this.optionalOnesStates,
      required this.optionalTwosStates,
      required this.pointsRemaining,
      required this.speedBonuses,
      required this.unearthedArcanaContent,
      required this.weaponList,
      required this.numberOfRemainingFeatOrASIs,
      //added stuff
      required this.name,
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
      this.subrace});
}
