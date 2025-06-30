// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Race _$RaceFromJson(Map<String, dynamic> json) => Race(
      name: json['name'] as String,
      raceScoreIncrease: (json['abilityScoreMap'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ['Common'],
      darkVision: (json['darkVision'] as num?)?.toInt() ?? 0,
      walkingSpeed: (json['walkingSpeed'] as num?)?.toInt() ?? 30,
      mystery1S: (json['mystery1S'] as num).toInt(),
      mystery2S: (json['mystery2S'] as num).toInt(),
      sourceBook: json['sourceBook'] as String? ?? 'N/A',
      subRaces: (json['subRaces'] as List<dynamic>?)
          ?.map((e) => Subrace.fromJson(e as Map<String, dynamic>))
          .toList(),
      resistances: (json['resistances'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      abilities: (json['abilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      toolProficiencies: (json['toolProficiencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RaceToJson(Race instance) => <String, dynamic>{
      'name': instance.name,
      'sourceBook': instance.sourceBook,
      'abilityScoreMap': instance.raceScoreIncrease,
      'languages': instance.languages,
      'toolProficiencies': instance.toolProficiencies,
      'subRaces': instance.subRaces,
      'resistances': instance.resistances,
      'abilities': instance.abilities,
      'darkVision': instance.darkVision,
      'walkingSpeed': instance.walkingSpeed,
      'mystery1S': instance.mystery1S,
      'mystery2S': instance.mystery2S,
    };
