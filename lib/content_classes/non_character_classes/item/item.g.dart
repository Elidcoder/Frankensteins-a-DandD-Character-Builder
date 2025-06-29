// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      name: json['Name'] as String,
      sourceBook: json['SourceBook'] as String,
      equipmentType: (json['EquipmentType'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      cost: json['Cost'] as List<dynamic>,
      weight: (json['Weight'] as num).toDouble(),
      stackable: json['Stackable'] as bool? ?? false,
      description: json['Description'] as String?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'Name': instance.name,
      'SourceBook': instance.sourceBook,
      'Cost': instance.cost,
      'Weight': instance.weight,
      'Stackable': instance.stackable,
      'Description': instance.description,
      'EquipmentType': instance.equipmentType,
    };
