// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Spell _$SpellFromJson(Map<String, dynamic> json) => Spell(
      name: json['name'] as String,
      sourceBook: json['sourceBook'] as String,
      level: (json['level'] as num?)?.toInt() ?? 0,
      effect: json['effect'] as String,
      timings: json['timings'] as List<dynamic>,
      availableTo: (json['availableTo'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      spellSchool: json['spellSchool'] as String,
      range: json['range'] as String,
      ritual: json['ritual'] as bool? ?? false,
      material: json['material'] as String? ?? 'None',
      somatic: json['somatic'] as bool? ?? false,
      verbal: json['verbal'] as bool? ?? false,
    );

Map<String, dynamic> _$SpellToJson(Spell instance) => <String, dynamic>{
      'name': instance.name,
      'sourceBook': instance.sourceBook,
      'effect': instance.effect,
      'spellSchool': instance.spellSchool,
      'level': instance.level,
      'ritual': instance.ritual,
      'range': instance.range,
      'verbal': instance.verbal,
      'somatic': instance.somatic,
      'material': instance.material,
      'availableTo': instance.availableTo,
      'timings': instance.timings,
    };
