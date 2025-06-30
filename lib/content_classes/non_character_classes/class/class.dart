import "../content.dart";
import 'package:json_annotation/json_annotation.dart';

part 'class.g.dart';

//classes - PROFICIENCY LIST NEEDS FIXING
@JsonSerializable()
class Class implements Content {
  final String? spellsKnownFormula;
  final List<int>? spellsKnownPerLevel;
  @override
  final String name;
  @override
  final String sourceBook;
  final String classType;
  final int maxHitDiceRoll;
  final bool? roundDown;
  final String mainOrSpellcastingAbility;
  //starting gold
  //[STR/DEX/CON/INT/WIS/CHAR/numbrequired]
  final List<int> multiclassingRequirements;
  final int numberOfSkillChoices;
  final List<String> optionsForSkillProficiencies;
  final List<String>? spellsAndSpellSlots; //replace with list both or 2 lists

  final List<String> savingThrowProficiencies;
  final List<List<dynamic>>
      equipmentOptions; //replace string => equipment//2 options for every one
  //Wrong change later
  final List<String>?
      proficienciesGained; //replace string with equipment (parent of) armour/tools/weapons

  final List<List<dynamic>> gainAtEachLevel; //replace string with something?
  
  // Use generated methods for serialization
  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);

  Map<String, dynamic> toJson() => _$ClassToJson(this);

  Class(
      {required this.multiclassingRequirements,
      required this.name,
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

List<Class> CLASSLIST = [];
