// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_description.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterDescription _$CharacterDescriptionFromJson(
        Map<String, dynamic> json) =>
    CharacterDescription(
      age: json['age'] as String? ?? "",
      height: json['height'] as String? ?? "",
      weight: json['weight'] as String? ?? "",
      eyes: json['eyes'] as String? ?? "",
      skin: json['skin'] as String? ?? "",
      hair: json['hair'] as String? ?? "",
      backstory: json['backstory'] as String? ?? "",
      name: json['name'] as String? ?? "",
      gender: json['gender'] as String? ?? "",
    );

Map<String, dynamic> _$CharacterDescriptionToJson(
        CharacterDescription instance) =>
    <String, dynamic>{
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'eyes': instance.eyes,
      'skin': instance.skin,
      'hair': instance.hair,
      'backstory': instance.backstory,
      'name': instance.name,
      'gender': instance.gender,
    };
