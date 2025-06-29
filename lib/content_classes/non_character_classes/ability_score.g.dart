// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbilityScore _$AbilityScoreFromJson(Map<String, dynamic> json) => AbilityScore(
      name: json['name'] as String,
      value: (json['value'] as num).toInt(),
    );

Map<String, dynamic> _$AbilityScoreToJson(AbilityScore instance) =>
    <String, dynamic>{
      'value': instance.value,
      'name': instance.name,
    };
