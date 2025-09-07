import 'package:json_annotation/json_annotation.dart';

import '../item/item.dart';

part 'weapon.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)
class Weapon extends Item {
  @JsonKey(name: 'Properties')
  List<String> properties;

  // Formatted as [["poison","1d8"]...]
  @JsonKey(name: 'DamageDiceAndType')
  List<List<String>> damageDiceAndType;

  Weapon({
    required super.name,
    required super.sourceBook,
    required super.cost,
    required super.stackable,
    required super.weight,
    required super.equipmentType,
    super.description,
    required this.damageDiceAndType,
    required this.properties
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      name: json["Name"],
      sourceBook: json["SourceBook"],
      cost: json["Cost"],
      weight: json["Weight"],
      stackable: json["Stackable"] ?? false,
      equipmentType: json["EquipmentType"].cast<String>() as List<String>,
      description: json["Description"],
      properties: json["Properties"].cast<String>() as List<String>,
      damageDiceAndType: (json["DamageDiceAndType"] as List).map((i) => List<String>.from(i)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => _$WeaponToJson(this);
}
