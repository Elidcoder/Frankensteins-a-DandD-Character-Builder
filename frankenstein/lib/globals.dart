import 'dart:convert';
import 'dart:io';

class Proficiency {
  final List<String> proficiencyTree;
  //final String sourceBook;
  factory Proficiency.fromJson(Map<String, dynamic> data) {
    final proficiencyTree =
        data['ProficiencyTree'].cast<String>() as List<String>;

    return Proficiency(proficiencyTree: proficiencyTree
        //sourceBook: sourceBook,
        );
  }
  Proficiency({
    required this.proficiencyTree,
    //required this.sourcebook,});
  });
}

///file loaded as a string 'jsonString'
String jsonString = File("assets/SRD.json").readAsStringSync();
//String data =  rootBundle.loadString('assets/$path.json')
///file decoded into 'jsonmap'
final dynamic jsonmap = decoder.convert(jsonString);
// ignore: non_constant_identifier_names
List<String> LANGUAGELIST = jsonmap["Languages"].cast<String>() as List<String>;
// ignore: non_constant_identifier_names
List<Proficiency> PROFICIENCYLIST =
    jsonmap["Proficiencies"].cast<Proficiency>() as List<Proficiency>;

class Subrace {
  final String name;
  final List<int> subRaceScoreIncrease;
  final String sourceBook;
  final List<String>? languages;
  final List<String>? resistances;
  final List<String>? abilities;
  final List<Proficiency>? proficienciesGained;
  final int darkVision;
  final int walkingSpeed;
  final int mystery1S;
  final int mystery2S;
  factory Subrace.fromJson(Map<String, dynamic> data) {
    final name = data['Name'] as String;
    final subRaceScoreIncrease =
        data['AbilityScoreMap'].cast<int>() as List<int>;
    final languages = data['Languages']?.cast<String>() as List<String>?;
    final darkVision = data['Darkvision'] as int?;
    final sourceBook = data["Sourcebook"] as String;
    final resistances = data["Resistances"]?.cast<String>() as List<String>?;
    final abilities = data['Abilities']?.cast<String>() as List<String>?;
    final proficienciesGainedNames =
        data["GainedProficiencies"]?.cast<String>() as List<String>?;
    final proficienciesGained = (proficienciesGainedNames?.map((thisprof) =>
            (PROFICIENCYLIST.singleWhere(
                (listprof) => listprof.proficiencyTree.last == thisprof))))
        ?.toList();
    final walkingSpeed = data["WalkingSpeed"];
    final mystery1S = data["Mystery1S"] as int;
    final mystery2S = data["Mystery2S"] as int;
    return Subrace(
        mystery2S: mystery2S,
        mystery1S: mystery1S,
        name: name,
        subRaceScoreIncrease: subRaceScoreIncrease,
        languages: languages,
        darkVision: darkVision ?? 0,
        walkingSpeed: walkingSpeed ?? 30,
        sourceBook: sourceBook,
        resistances: resistances,
        abilities: abilities,
        proficienciesGained: proficienciesGained);
  }
  Subrace(
      {required this.name,
      required this.subRaceScoreIncrease,
      required this.darkVision,
      required this.walkingSpeed,
      required this.mystery1S,
      required this.mystery2S,
      required this.sourceBook,
      this.languages,
      this.resistances,
      this.abilities,
      this.proficienciesGained});
}

class Race {
  final String name;
  final List<int> raceScoreIncrease;
  final String sourceBook;
  final List<String> languages;
  final List<Subrace>? subRaces;
  final List<String>? resistances;
  final List<String>? abilities;
  final List<Proficiency>? proficienciesGained;
  final int darkVision;
  final int walkingSpeed;
  final int mystery1S;
  final int mystery2S;
  factory Race.fromJson(Map<String, dynamic> data) {
    final name = data['Name'] as String;
    final raceScoreIncrease = data['AbilityScoreMap'].cast<int>() as List<int>;
    final languages = data['Languages'].cast<String>() as List<String>?;
    final darkVision = data['Darkvision'] as int?;
    final sourceBook = data["Sourcebook"] as String?;
    final subRaceData = data['Subraces'] as List<dynamic>?;
    final subRaces = subRaceData
        ?.map((subRaceData) => Subrace.fromJson(subRaceData))
        .toList();
    final resistances = data["Resistances"]?.cast<String>() as List<String>?;
    final abilities = data['Abilities']?.cast<String>() as List<String>?;
    final proficienciesGainedNames =
        data["GainedProficiencies"]?.cast<String>() as List<String>?;
    final proficienciesGained = (proficienciesGainedNames?.map((thisprof) =>
            (PROFICIENCYLIST.singleWhere(
                (listprof) => listprof.proficiencyTree.last == thisprof))))
        ?.toList();
    final walkingSpeed = data["WalkingSpeed"];
    final mystery1S = data["Mystery1S"] as int;
    final mystery2S = data["Mystery2S"] as int;

    return Race(
      name: name,
      raceScoreIncrease: raceScoreIncrease,
      languages: languages ?? ["Common"],
      darkVision: darkVision ?? 0,
      walkingSpeed: walkingSpeed ?? 30,
      sourceBook: sourceBook ?? "N/A",
      subRaces: subRaces,
      resistances: resistances,
      abilities: abilities,
      proficienciesGained: proficienciesGained,
      mystery2S: mystery2S,
      mystery1S: mystery1S,
    );
  }
  Race(
      {required this.name,
      required this.raceScoreIncrease,
      required this.languages,
      required this.darkVision,
      required this.walkingSpeed,
      required this.mystery1S,
      required this.mystery2S,
      required this.sourceBook,
      this.subRaces,
      this.resistances,
      this.abilities,
      this.proficienciesGained});
}

//classes - PROFICIENCY LIST NEEDS FIXING
class Class {
  final String? spellsKnownFormula;
  final List<int>? spellsKnownPerLevel;
  final String name;
  final String classType;
  final int maxHitDiceRoll;
  final bool? roundDown;
  final String mainOrSpellcastingAbility;

  final int numberOfSkillChoices;
  final List<String> optionsForSkillProficiencies;
  final List<String>? spellsAndSpellSlots; //replace with list both or 2 lists

  final List<String> savingThrowProficiencies;
  final List<List<String>>
      equipmentOptions; //replace string => equipment//2 options for every one
  //Wrong change later
  final List<String>?
      proficienciesGained; //replace string with equipment (parent of) armour/tools/weapons

  final List<List<dynamic>> gainAtEachLevel; //replace string with something?
  final String sourceBook;

  factory Class.fromJson(Map<String, dynamic> data) {
    final name = data['Name'] as String;
    final mainOrSpellcastingAbility =
        data["MainOrSpellcastingAbility"] as String;
    final classType = data['ClassType'] as String;
    final maxHitDiceRoll = data['MaxHitDiceRoll'] as int;
    final roundDown = data['RoundDown'] as bool?;
    final numberOfSkillChoices = data['NumberOfSkillChoices'] as int;
    final sourceBook = data["Sourcebook"] as String;

    final spellsAndSpellSlots =
        data["SpellsAndSpellSlots"]?.cast<String>() as List<String>?;
    final optionsForSkillProficiencies =
        data["OptionsForSkillProficiencies"].cast<String>() as List<String>;
    final savingThrowProficiencies =
        data["SavingThrowProficiencies"].cast<String>() as List<String>;

    final equipmentOptions =
        data['EquipmentOptions'].cast<List<String>>() as List<List<String>>;
    final proficienciesGained =
        data["GainedProficiencies"]?.cast<String>() as List<String>?;
    return Class(
        mainOrSpellcastingAbility: mainOrSpellcastingAbility,
        classType: classType,
        maxHitDiceRoll: maxHitDiceRoll,
        name: name,
        roundDown: roundDown,
        numberOfSkillChoices: numberOfSkillChoices,
        optionsForSkillProficiencies: optionsForSkillProficiencies,
        savingThrowProficiencies: savingThrowProficiencies,
        spellsAndSpellSlots: spellsAndSpellSlots,
        sourceBook: sourceBook,
        equipmentOptions: equipmentOptions,
        gainAtEachLevel: (data['GainAtEachLevel'].cast<List<dynamic>>()),
        proficienciesGained: proficienciesGained,
        spellsKnownFormula: data["SpellKnownFormula"],
        spellsKnownPerLevel: data["SpellsKnownPerLevel"]?.cast<int>());
  }
  Class(
      {required this.name,
      required this.mainOrSpellcastingAbility,
      required this.classType,
      required this.maxHitDiceRoll,
      this.roundDown,
      this.spellsAndSpellSlots,
      this.spellsKnownFormula,
      this.spellsKnownPerLevel,
      required this.numberOfSkillChoices,
      required this.optionsForSkillProficiencies,
      required this.sourceBook,
      required this.savingThrowProficiencies,
      required this.equipmentOptions,
      required this.gainAtEachLevel,
      required this.proficienciesGained});
}

class Subclass {
  final String name;
  final String classType;
  final bool? roundDown;
  final String mainOrSpellcastingAbility;
  final List<List<List<String>>>
      gainAtEachLevel; //replace string with something?
  final String sourceBook;
  factory Subclass.fromJson(Map<String, dynamic> data) {
    final name = data['Name'] as String;
    final mainOrSpellcastingAbility =
        data["MainOrSpellcastingAbility"] as String;
    final classType = data['ClassType'] as String;
    final roundDown = data['RoundDown'] as bool?;
    final sourceBook = data["Sourcebook"] as String;
    final gainAtEachLevel = data['GainAtEachLevel'].cast<List<List<String>>>()
        as List<List<List<String>>>;
    return Subclass(
        classType: classType,
        name: name,
        roundDown: roundDown,
        sourceBook: sourceBook,
        gainAtEachLevel: gainAtEachLevel,
        mainOrSpellcastingAbility: mainOrSpellcastingAbility);
  }
  Subclass(
      {required this.name,
      required this.classType,
      required this.mainOrSpellcastingAbility,
      this.roundDown,
      required this.sourceBook,
      required this.gainAtEachLevel});
}

class Spell {
  //ADD SPELL TYPE THINGY
  final String name;
  final String effect;
  final String spellSchool;
  final int level;
  final bool? verbal;
  final bool? somatic;
  final String? material;
  final List<dynamic> castingTime;
  final List<String> availableTo;
  factory Spell.fromJson(Map<String, dynamic> data) {
    // note the explicit cast to String
    // this is required if robust lint rules are enabled
    //COULD GO THROUGH EVERY DATA[SPELL[X,Y,Z*]] TO ALLOW LESS FILES TO BE ADDED WITH CONTENT
    final level = data['Level'] as int?;
    final verbal = data['Verbal'] as bool?;
    final somatic = data['Somatic'] as bool?;
    final material = data['Material'] as String?;
    return Spell(
        name: data['Name'],
        effect: data['Effect'],
        level: level ?? 0,
        verbal: verbal ?? false,
        somatic: somatic ?? false,
        material: material ?? "None",
        spellSchool: data["SpellSchool"],
        castingTime: data["CastingTime"].cast<dynamic>(),
        availableTo: data["AvailableTo"].cast<String>());
  }
  Spell(
      {required this.name,
      required this.level,
      required this.effect,
      required this.castingTime,
      required this.availableTo,
      required this.spellSchool,
      this.material,
      this.somatic,
      this.verbal});
}

//NO CASE SHOULD HAVE NUMBEROFSKILLCHOICES>OPTIONALSKILLPROFICIENCIES.LENGTH
//shoev question marks to make bond/flawetc optional
class Background {
  final String name;
  final int? numberOfSkillChoices;
  final String sourceBook;

  final int? numberOfLanguageChoices;
  final List<String>? features;
  final List<Proficiency>? initialProficiencies;
  final List<String>? optionalSkillProficiencies;
  final List<String>? toolProficiencies;
  final List<String> personalityTrait;
  final List<String> ideal;
  final List<String> bond;
  final List<String> flaw;
  //make classes for every equipment type
  final List<String>? equipment;
  factory Background.fromJson(Map<String, dynamic> data) {
    final name = data['Name'] as String;
    final sourceBook = data["Sourcebook"] as String;

    final personalityTrait =
        data['PersonalityTrait'].cast<String>() as List<String>;
    final ideal = data['Ideal'].cast<String>() as List<String>;
    final bond = data['Bond'].cast<String>() as List<String>;
    final flaw = data['Flaw'].cast<String>() as List<String>;

    final numberOfSkillChoices = data['NumberOfSkillChoices'] as int?;
    final numberOfLanguageChoices = data['NumberOfLanguageChoices'] as int?;
    //final sourceBook = data["Sourcebook"];
    final features = data["Features"]?.cast<String>() as List<String>?;
    final equipment = data["Equipment"]?.cast<String>() as List<String>?;

    final toolProficiencies =
        data['ToolProficiencies']?.cast<String>() as List<String>?;
    final proficienciesGainedNames =
        data["InitialProficiencies"]?.cast<String>() as List<String>?;
    final initialProficiencies = (proficienciesGainedNames?.map((thisprof) =>
            (PROFICIENCYLIST.singleWhere(
                (listprof) => listprof.proficiencyTree.last == thisprof))))
        ?.toList();
    final optionalSkillProficiencies =
        data['OptionalSkillProficiencies']?.cast<String>() as List<String>?;
    return Background(
      name: name,
      personalityTrait: personalityTrait,
      ideal: ideal,
      bond: bond,
      flaw: flaw,
      equipment: equipment,
      optionalSkillProficiencies: optionalSkillProficiencies,
      numberOfLanguageChoices: numberOfLanguageChoices,
      numberOfSkillChoices: numberOfSkillChoices,
      toolProficiencies: toolProficiencies,
      initialProficiencies: initialProficiencies,
      sourceBook: sourceBook,
      features: features,
    );
  }
  Background({
    required this.sourceBook,
    required this.name,
    required this.personalityTrait,
    required this.ideal,
    required this.bond,
    required this.flaw,
    this.numberOfSkillChoices,
    this.numberOfLanguageChoices,
    this.initialProficiencies,
    this.features,
    this.equipment,
    this.optionalSkillProficiencies,
    this.toolProficiencies,
    //required this.sourcebook,});
  });
}

//WIP
/*
class Weapon {
  final String name;
  final String? range;
  final List<String>? tags;
  final String damage;
  final int weight;

  ///MAY REMOVE AND COMBINE WITH TAGS AND SET TO STRENGTH
  Weapon(
      {required this.name,
      this.range,
      this.tags,
      required this.damage,
      required this.weight});
}
*/
const JsonDecoder decoder = JsonDecoder();
//make this maintainable
//const String filepath =
//  "C:\\Users\\arieh\\OneDrive\\Documents\\Dartwork\\frankenstein\\lib\\SRD.json";

//for every background,race(sub),class(sub)
// ignore: non_constant_identifier_names
List<Race> RACELIST = [for (var x in jsonmap["Races"]) Race.fromJson(x)];
List<Spell> list = [for (var x in jsonmap["Spells"]) Spell.fromJson(x)];
// ignore: non_constant_identifier_names
List<Background> BACKGROUNDLIST = [
  //There is large issue IDK and cant remember what else wsas in the fix
  for (var x in jsonmap["Background"]) Background.fromJson(x)
];
// ignore: non_constant_identifier_names
List<Class> CLASSLIST = [for (var x in jsonmap["Classes"]) Class.fromJson(x)];
// ignore: non_constant_identifier_names
List<Spell> SPELLLIST = [for (var x in jsonmap["Spells"]) Spell.fromJson(x)];
