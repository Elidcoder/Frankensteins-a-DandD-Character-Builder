import 'package:frankenstein/core/services/global_list_manager.dart' show GlobalListManager;
import 'package:json_annotation/json_annotation.dart';

import "../../base/content.dart";

part 'background.g.dart';

// FUTUREPLAN(Use asserts to ensure NUMBEROFSKILLCHOICES <= OPTIONALSKILLPROFICIENCIES.LENGTH)
// FUTUREPLAN(make bond/flaw etc optional)
@JsonSerializable()
class Background implements Content {
  @override
  @JsonKey(name: 'Name')
  final String name;
  @override
  @JsonKey(name: 'SourceBook')
  final String sourceBook;
  @JsonKey(name: 'NumberOfSkillChoices', defaultValue: 0)
  final int numberOfSkillChoices;

  @JsonKey(name: 'NumberOfLanguageChoices', defaultValue: 0)
  final int numberOfLanguageChoices;
  @JsonKey(name: 'Features', defaultValue: <String>[])
  final List<String> features;
  @JsonKey(name: 'InitialProficiencies', defaultValue: <String>[])
  final List<String> initialProficiencies;
  @JsonKey(name: 'OptionalSkillProficiencies', defaultValue: <String>[])
  final List<String> optionalSkillProficiencies;
  // Options from which language choices are made, all languages available if empty
  @JsonKey(name: 'LanguageOptions', defaultValue: <String>[])
  final List<String> languageOptions;
  @JsonKey(name: 'ToolProficiencies', defaultValue: <String>[])
  final List<String> toolProficiencies;
  @JsonKey(name: 'PersonalityTrait')
  final List<String> personalityTrait;
  @JsonKey(name: 'Ideal')
  final List<String> ideal;
  @JsonKey(name: 'Bond')
  final List<String> bond;
  @JsonKey(name: 'Flaw')
  final List<String> flaw;
  // FUTUREPLAN(Make classes for every equipment type)
  @JsonKey(name: 'Equipment', defaultValue: <String>[])
  final List<String> equipment;

  // Use generated toJson
  Map<String, dynamic> toJson() => _$BackgroundToJson(this);

  // Use generated fromJson
  factory Background.fromJson(Map<String, dynamic> json) => _$BackgroundFromJson(json);
  Background({
    required this.sourceBook,
    required this.name,
    required this.personalityTrait,
    required this.ideal,
    required this.bond,
    required this.flaw,
    required this.languageOptions,
    required this.initialProficiencies,
    required this.features,
    required this.equipment,
    required this.optionalSkillProficiencies,
    required this.toolProficiencies,
    this.numberOfSkillChoices = 0,
    this.numberOfLanguageChoices = 0,
  });
  
  List<String> getLanguageOptions() {
    if (languageOptions.isEmpty) {
      return GlobalListManager().languageList;
    }
    return languageOptions;
  }
}
