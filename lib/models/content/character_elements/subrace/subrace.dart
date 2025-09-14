import 'package:frankenstein/core/services/global_list_manager.dart' show GlobalListManager;
import 'package:json_annotation/json_annotation.dart';

import "../../base/content.dart";
import '../proficiency.dart';

part 'subrace.g.dart';

@JsonSerializable()
class Subrace implements Content {
  @override
  final String name;
  @override
  final String sourceBook;
  final List<int> subRaceScoreIncrease;
  @JsonKey(defaultValue: <String>[])
  final List<String>? languages;
  @JsonKey(defaultValue: <String>[])
  final List<String>? resistances;
  @JsonKey(defaultValue: <String>[])
  final List<String>? abilities;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<Proficiency>? proficienciesGained;
  @JsonKey(defaultValue: 0)
  final int darkVision;
  @JsonKey(defaultValue: 30)
  final int walkingSpeed;
  final int mystery1S;
  final int mystery2S;
  @JsonKey(defaultValue: <String>[])
  final List<String>? toolProficiencies;
  // Use generated toJson with custom proficiency handling
  Map<String, dynamic> toJson() {
    final json = _$SubraceToJson(this);
    // Add custom proficiency serialization
    json["gainedProficiencies"] = proficienciesGained
            ?.map((proficiency) => proficiency.toString())
            .toList() ??
        [];
    return json;
  }

  // Use generated fromJson with custom proficiency handling
  factory Subrace.fromJson(Map<String, dynamic> data) {
    // Handle custom proficiency deserialization
    final proficienciesGainedNames =
        data["gainedProficiencies"]?.cast<String>() as List<String>?;
    final proficienciesGained = (proficienciesGainedNames?.map((thisprof) =>
            (GlobalListManager().proficiencyList.singleWhere(
                (listprof) => listprof.proficiencyTree.last == thisprof))))
        ?.toList();
    
    // Use generated fromJson for all other fields with proper defaults
    final subrace = _$SubraceFromJson(data);
    
    // Return new instance with custom proficienciesGained
    return Subrace(
      mystery2S: subrace.mystery2S,
      mystery1S: subrace.mystery1S,
      name: subrace.name,
      subRaceScoreIncrease: subrace.subRaceScoreIncrease,
      languages: subrace.languages,
      darkVision: subrace.darkVision,
      walkingSpeed: subrace.walkingSpeed,
      sourceBook: subrace.sourceBook,
      resistances: subrace.resistances,
      abilities: subrace.abilities,
      proficienciesGained: proficienciesGained, // Custom logic
      toolProficiencies: subrace.toolProficiencies,
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
