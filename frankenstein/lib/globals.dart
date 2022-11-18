import 'dart:convert';
import "dart:collection";
import 'dart:io';

class Subrace {
  final String name;
  final List<int> subRaceScoreIncrease;
  //final String sourceBook;
  final List<String>? languages;
  final List<String>? resistances;
  final List<String>? abilities;
  final List<String>? proficiencies;
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
    //final sourceBook = data["Sourcebook"];
    final resistances = data["Resistances"]?.cast<String>() as List<String>?;
    final abilities = data['Abilities']?.cast<String>() as List<String>?;
    final proficiencies =
        data['Proficiencies']?.cast<String>() as List<String>?;
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
        //sourceBook: sourceBook,
        resistances: resistances,
        abilities: abilities,
        proficiencies: proficiencies);
  }
  Subrace(
      {required this.name,
      required this.subRaceScoreIncrease,
      required this.darkVision,
      required this.walkingSpeed,
      required this.mystery1S,
      required this.mystery2S,
      //required this.sourcebook,
      this.languages,
      this.resistances,
      this.abilities,
      this.proficiencies});
}

class Race {
  final String name;
  final List<int> raceScoreIncrease;
  //final String sourceBook;
  final List<String> languages;
  final List<Subrace>? subRaces;
  final List<String>? resistances;
  final List<String>? abilities;
  final List<String>? proficiencies;
  final int darkVision;
  final int walkingSpeed;
  final int mystery1S;
  final int mystery2S;
  factory Race.fromJson(Map<String, dynamic> data) {
    final name = data['Name'] as String;
    final raceScoreIncrease = data['AbilityScoreMap'].cast<int>() as List<int>;
    final languages = data['Languages'].cast<String>() as List<String>?;
    final darkVision = data['Darkvision'] as int?;
    //final sourceBook = data["Sourcebook"]?;
    final subRaceData = data['Subraces'] as List<dynamic>?;
    final subRaces = subRaceData
        ?.map((subRaceData) => Subrace.fromJson(subRaceData))
        .toList();
    final resistances = data["Resistances"]?.cast<String>() as List<String>?;
    final abilities = data['Abilities']?.cast<String>() as List<String>?;
    final proficiencies =
        data['Proficiencies']?.cast<String>() as List<String>?;
    final walkingSpeed = data["WalkingSpeed"];
    final mystery1S = data["Mystery1S"] as int;
    final mystery2S = data["Mystery2S"] as int;

    return Race(
      name: name,
      raceScoreIncrease: raceScoreIncrease,
      languages: languages ?? ["Common"],
      darkVision: darkVision ?? 0,
      walkingSpeed: walkingSpeed ?? 30,
      //sourceBook: sourceBook ?? "N/A",
      subRaces: subRaces,
      resistances: resistances,
      abilities: abilities,
      proficiencies: proficiencies,
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
      //required this.sourcebook,
      this.subRaces,
      this.resistances,
      this.abilities,
      this.proficiencies});
}

class Spell {
  //ADD SPELL TYPE THINGY
  final String name;
  final String effect;
  final int level;
  final String? verbal;
  final String? somatic;
  final String? material;
  factory Spell.fromJson(Map<String, dynamic> data) {
    // note the explicit cast to String
    // this is required if robust lint rules are enabled
    //COULD GO THROUGH EVERY DATA[SPELL[X,Y,Z*]] TO ALLOW LESS FILES TO BE ADDED WITH CONTENT
    final name = data['Name'] as String;
    final effect = data['Effect'] as String;
    final level = data['Level'] as int?;
    final verbal = data['Verbal'] as String?;
    final somatic = data['Somatic'] as String?;
    final material = data['Material'] as String?;
    return Spell(
        name: name,
        effect: effect,
        level: level ?? 0,
        verbal: verbal ?? "None",
        somatic: somatic ?? "None",
        material: material ?? "None");
  }
  Spell(
      {required this.name,
      required this.level,
      required this.effect,
      this.material,
      this.somatic,
      this.verbal});
}

//NO CASE SHOULD HAVE NUMBEROFSKILLCHOICES>OPTIONALSKILLPROFICIENCIES.LENGTH
//shoev question marks to make bond/flawetc optional
class Background {
  final String name;
  final int? numberOfSkillChoices;
  final int? numberOfLanguageChoices;
  final List<String>? features;
  final List<String>? initialSkillProficiencies;
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
    final initialSkillProficiencies =
        data['InitialSkillProficiencies']?.cast<String>() as List<String>?;
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
      initialSkillProficiencies: initialSkillProficiencies,
      //sourceBook: sourceBook,
      features: features,
    );
  }
  Background({
    required this.name,
    required this.personalityTrait,
    required this.ideal,
    required this.bond,
    required this.flaw,
    this.numberOfSkillChoices,
    this.numberOfLanguageChoices,
    this.initialSkillProficiencies,
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
const String filepath =
    "C:\\Users\\arieh\\OneDrive\\Documents\\Dartwork\\frankenstein\\lib\\SRD.json";

///file loaded as a string 'jsonString'
String jsonString = File(filepath).readAsStringSync();

///file decoded into 'jsonmap'
final dynamic jsonmap = decoder.convert(jsonString);

// ignore: non_constant_identifier_names
List<Race> RACELIST = [for (var x in jsonmap["Races"]) Race.fromJson(x)];
List<Spell> list = [for (var x in jsonmap["Spells"]) Spell.fromJson(x)];
// ignore: non_constant_identifier_names
List<Background> BACKGROUNDLIST = [
  for (var x in jsonmap["Background"]) Background.fromJson(x)
];
// ignore: non_constant_identifier_names
List<String> LANGUAGELIST = jsonmap["Languages"].cast<String>() as List<String>;
