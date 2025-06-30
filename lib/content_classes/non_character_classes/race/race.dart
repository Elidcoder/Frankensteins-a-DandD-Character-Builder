import "../subrace/subrace.dart";
import "../proficiency.dart";
import "../content.dart";
import 'package:json_annotation/json_annotation.dart';

part 'race.g.dart';

@JsonSerializable()
class Race implements Content {
  @override
  final String name;
  @override
  @JsonKey(defaultValue: 'N/A')
  final String sourceBook;

  @JsonKey(name: 'abilityScoreMap')
  final List<int> raceScoreIncrease;
  @JsonKey(defaultValue: ['Common'])
  final List<String> languages;
  final List<String>? toolProficiencies;
  final List<Subrace>? subRaces;
  final List<String>? resistances;
  final List<String>? abilities;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<Proficiency>? proficienciesGained;
  @JsonKey(defaultValue: 0)
  final int darkVision;
  @JsonKey(defaultValue: 30)
  final int walkingSpeed;
  final int mystery1S;
  final int mystery2S;

  // Use generated toJson with custom proficiency handling
  Map<String, dynamic> toJson() {
    final json = _$RaceToJson(this);
    // Add custom proficiency serialization
    json["gainedProficiencies"] = proficienciesGained
        ?.map((prof) => prof.proficiencyTree.last)
        .toList();
    return json;
  }

  // Use generated fromJson with custom proficiency handling
  factory Race.fromJson(Map<String, dynamic> data) {
    // Handle custom proficiency deserialization
    final proficienciesGainedNames =
        data["gainedProficiencies"]?.cast<String>() as List<String>?;
    final proficienciesGained = (proficienciesGainedNames?.map((thisprof) =>
            (PROFICIENCYLIST.singleWhere(
                (listprof) => listprof.proficiencyTree.last == thisprof))))
        ?.toList();
    
    // Use generated fromJson for all other fields
    final race = _$RaceFromJson(data);
    
    // Return new instance with custom proficienciesGained
    return Race(
      name: race.name,
      raceScoreIncrease: race.raceScoreIncrease,
      languages: race.languages,
      darkVision: race.darkVision,
      walkingSpeed: race.walkingSpeed,
      mystery1S: race.mystery1S,
      mystery2S: race.mystery2S,
      sourceBook: race.sourceBook,
      subRaces: race.subRaces,
      resistances: race.resistances,
      abilities: race.abilities,
      proficienciesGained: proficienciesGained, // Custom logic
      toolProficiencies: race.toolProficiencies,
    );
  }
  Race({
    required this.name,
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
    this.toolProficiencies,
  });
}

List<Race> RACELIST = [];
