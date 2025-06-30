// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Class _$ClassFromJson(Map<String, dynamic> json) => Class(
      multiclassingRequirements:
          (json['multiclassingRequirements'] as List<dynamic>)
              .map((e) => (e as num).toInt())
              .toList(),
      name: json['name'] as String,
      mainOrSpellcastingAbility: json['mainOrSpellcastingAbility'] as String,
      classType: json['classType'] as String,
      maxHitDiceRoll: (json['maxHitDiceRoll'] as num).toInt(),
      roundDown: json['roundDown'] as bool?,
      spellsAndSpellSlots: (json['spellsAndSpellSlots'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      spellsKnownFormula: json['spellsKnownFormula'] as String?,
      spellsKnownPerLevel: (json['spellsKnownPerLevel'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      numberOfSkillChoices: (json['numberOfSkillChoices'] as num).toInt(),
      optionsForSkillProficiencies:
          (json['optionsForSkillProficiencies'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      sourceBook: json['sourceBook'] as String,
      savingThrowProficiencies:
          (json['savingThrowProficiencies'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      equipmentOptions: (json['equipmentOptions'] as List<dynamic>)
          .map((e) => e as List<dynamic>)
          .toList(),
      gainAtEachLevel: (json['gainAtEachLevel'] as List<dynamic>)
          .map((e) => e as List<dynamic>)
          .toList(),
      proficienciesGained: (json['proficienciesGained'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ClassToJson(Class instance) => <String, dynamic>{
      'spellsKnownFormula': instance.spellsKnownFormula,
      'spellsKnownPerLevel': instance.spellsKnownPerLevel,
      'name': instance.name,
      'sourceBook': instance.sourceBook,
      'classType': instance.classType,
      'maxHitDiceRoll': instance.maxHitDiceRoll,
      'roundDown': instance.roundDown,
      'mainOrSpellcastingAbility': instance.mainOrSpellcastingAbility,
      'multiclassingRequirements': instance.multiclassingRequirements,
      'numberOfSkillChoices': instance.numberOfSkillChoices,
      'optionsForSkillProficiencies': instance.optionsForSkillProficiencies,
      'spellsAndSpellSlots': instance.spellsAndSpellSlots,
      'savingThrowProficiencies': instance.savingThrowProficiencies,
      'equipmentOptions': instance.equipmentOptions,
      'proficienciesGained': instance.proficienciesGained,
      'gainAtEachLevel': instance.gainAtEachLevel,
    };
