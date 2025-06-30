// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subrace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subrace _$SubraceFromJson(Map<String, dynamic> json) => Subrace(
      name: json['name'] as String,
      subRaceScoreIncrease: (json['subRaceScoreIncrease'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      darkVision: (json['darkVision'] as num?)?.toInt() ?? 0,
      walkingSpeed: (json['walkingSpeed'] as num?)?.toInt() ?? 30,
      mystery1S: (json['mystery1S'] as num).toInt(),
      mystery2S: (json['mystery2S'] as num).toInt(),
      sourceBook: json['sourceBook'] as String,
      toolProficiencies: (json['toolProficiencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      resistances: (json['resistances'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      abilities: (json['abilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$SubraceToJson(Subrace instance) => <String, dynamic>{
      'name': instance.name,
      'sourceBook': instance.sourceBook,
      'subRaceScoreIncrease': instance.subRaceScoreIncrease,
      'languages': instance.languages,
      'resistances': instance.resistances,
      'abilities': instance.abilities,
      'darkVision': instance.darkVision,
      'walkingSpeed': instance.walkingSpeed,
      'mystery1S': instance.mystery1S,
      'mystery2S': instance.mystery2S,
      'toolProficiencies': instance.toolProficiencies,
    };
