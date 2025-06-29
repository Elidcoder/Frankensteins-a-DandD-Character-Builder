// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feat _$FeatFromJson(Map<String, dynamic> json) => Feat(
      name: json['Name'] as String,
      sourceBook: json['SourceBook'] as String,
      isHalfFeat: json['IsHalfFeat'] as bool,
      description: json['Description'] as String,
      abilities: (json['Abilities'] as List<dynamic>)
          .map((e) => e as List<dynamic>)
          .toList(),
      numberOfTimesTakeable: (json['NumberOfTimesTakeable'] as num).toInt(),
    );

Map<String, dynamic> _$FeatToJson(Feat instance) => <String, dynamic>{
      'Name': instance.name,
      'SourceBook': instance.sourceBook,
      'IsHalfFeat': instance.isHalfFeat,
      'Description': instance.description,
      'Abilities': instance.abilities,
      'NumberOfTimesTakeable': instance.numberOfTimesTakeable,
    };
