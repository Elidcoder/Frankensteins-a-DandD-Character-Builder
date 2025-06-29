// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Background _$BackgroundFromJson(Map<String, dynamic> json) => Background(
      sourceBook: json['SourceBook'] as String,
      name: json['Name'] as String,
      personalityTrait: (json['PersonalityTrait'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      ideal: (json['Ideal'] as List<dynamic>).map((e) => e as String).toList(),
      bond: (json['Bond'] as List<dynamic>).map((e) => e as String).toList(),
      flaw: (json['Flaw'] as List<dynamic>).map((e) => e as String).toList(),
      languageOptions: (json['LanguageOptions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      initialProficiencies: (json['InitialProficiencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      features: (json['Features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      equipment: (json['Equipment'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      optionalSkillProficiencies:
          (json['OptionalSkillProficiencies'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              [],
      toolProficiencies: (json['ToolProficiencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      numberOfSkillChoices:
          (json['NumberOfSkillChoices'] as num?)?.toInt() ?? 0,
      numberOfLanguageChoices:
          (json['NumberOfLanguageChoices'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BackgroundToJson(Background instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'SourceBook': instance.sourceBook,
      'NumberOfSkillChoices': instance.numberOfSkillChoices,
      'NumberOfLanguageChoices': instance.numberOfLanguageChoices,
      'Features': instance.features,
      'InitialProficiencies': instance.initialProficiencies,
      'OptionalSkillProficiencies': instance.optionalSkillProficiencies,
      'LanguageOptions': instance.languageOptions,
      'ToolProficiencies': instance.toolProficiencies,
      'PersonalityTrait': instance.personalityTrait,
      'Ideal': instance.ideal,
      'Bond': instance.bond,
      'Flaw': instance.flaw,
      'Equipment': instance.equipment,
    };
