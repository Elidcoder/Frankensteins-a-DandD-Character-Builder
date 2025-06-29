// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subclass _$SubclassFromJson(Map<String, dynamic> json) => Subclass(
      name: json['Name'] as String,
      classType: json['ClassType'] as String,
      mainOrSpellcastingAbility: json['MainOrSpellcastingAbility'] as String,
      roundDown: json['RoundDown'] as bool?,
      sourceBook: json['SourceBook'] as String,
      gainAtEachLevel: (json['GainAtEachLevel'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
              .toList())
          .toList(),
    );

Map<String, dynamic> _$SubclassToJson(Subclass instance) => <String, dynamic>{
      'Name': instance.name,
      'SourceBook': instance.sourceBook,
      'ClassType': instance.classType,
      'RoundDown': instance.roundDown,
      'MainOrSpellcastingAbility': instance.mainOrSpellcastingAbility,
      'GainAtEachLevel': instance.gainAtEachLevel,
    };
