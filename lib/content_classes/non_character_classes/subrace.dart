import 'proficiency.dart';

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
  final List<String>? toolProficiencies;
  Map<String, dynamic> toJson() => {
        "Name": name,
        "AbilityScoreMap": subRaceScoreIncrease,
        "Languages": languages ?? [],
        "Darkvision": darkVision,
        "Sourcebook": sourceBook,
        "Resistances": resistances ?? [],
        "Abilities": abilities ?? [],
        "GainedProficiencies": proficienciesGained
                ?.map((proficiency) => proficiency.toString())
                .toList() ??
            [],
        "ToolProficiencies": toolProficiencies ?? [],
        "WalkingSpeed": walkingSpeed,
        "Mystery1S": mystery1S,
        "Mystery2S": mystery2S,
      };
  factory Subrace.fromJson(Map<String, dynamic> data) {
    final name = data["Name"] as String;
    final subRaceScoreIncrease =
        data["AbilityScoreMap"].cast<int>() as List<int>;
    final languages = data["Languages"]?.cast<String>() as List<String>?;
    final darkVision = data["Darkvision"] as int?;
    final sourceBook = data["Sourcebook"] as String;
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
      proficienciesGained: proficienciesGained,
      toolProficiencies: toolProficiencies,
    );
  }
  Subrace(
      {required this.name,
      required this.subRaceScoreIncrease,
      required this.darkVision,
      required this.walkingSpeed,
      required this.mystery1S,
      required this.mystery2S,
      required this.sourceBook,
      this.toolProficiencies,
      this.languages,
      this.resistances,
      this.abilities,
      this.proficienciesGained});
}