import 'subrace.dart';
import 'proficiency.dart';
import "content.dart";

class Race implements Content {
  @override
  final String name;
  @override
  final String sourceBook;
  final List<int> raceScoreIncrease;
  final List<String> languages;
  final List<String>? toolProficiencies;
  final List<Subrace>? subRaces;
  final List<String>? resistances;
  final List<String>? abilities;
  final List<Proficiency>? proficienciesGained;
  final int darkVision;
  final int walkingSpeed;
  final int mystery1S;
  final int mystery2S;
  Map<String, dynamic> toJson() => {
        "Name": name,
        "AbilityScoreMap": raceScoreIncrease,
        "Languages": languages,
        "Darkvision": darkVision,
        "SourceBook": sourceBook,
        "Subraces": subRaces?.map((subrace) => subrace.toJson()).toList(),
        "Resistances": resistances,
        "Abilities": abilities,
        "GainedProficiencies": proficienciesGained
            ?.map((prof) => prof.proficiencyTree.last)
            .toList(),
        "ToolProficiencies": toolProficiencies,
        "WalkingSpeed": walkingSpeed,
        "Mystery1S": mystery1S,
        "Mystery2S": mystery2S,
      };
  factory Race.fromJson(Map<String, dynamic> data) {
    final name = data["Name"] as String;
    final raceScoreIncrease = data["AbilityScoreMap"].cast<int>() as List<int>;
    final languages = data["Languages"].cast<String>() as List<String>?;
    final darkVision = data["Darkvision"] as int?;
    final sourceBook = data["SourceBook"] as String?;
    final subRaceData = data["Subraces"] as List<dynamic>?;
    final subRaces = subRaceData
        ?.map((subRaceData) => Subrace.fromJson(subRaceData))
        .toList();
    final resistances = data["Resistances"]?.cast<String>() as List<String>?;
    final abilities = data["Abilities"]?.cast<String>() as List<String>?;
    final proficienciesGainedNames =
        data["GainedProficiencies"]?.cast<String>() as List<String>?;
    final proficienciesGained = (proficienciesGainedNames?.map((thisprof) =>
            (PROFICIENCYLIST.singleWhere(
                (listprof) => listprof.proficiencyTree.last == thisprof))))
        ?.toList();
    final toolProficiencies =
        data["ToolProficiencies"]?.cast<String>() as List<String>?;
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
      toolProficiencies: toolProficiencies,
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
      this.proficienciesGained,
      this.toolProficiencies});
}

List<Race> RACELIST = [];
