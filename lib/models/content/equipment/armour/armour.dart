import 'package:json_annotation/json_annotation.dart';

import "../item/item.dart";

part 'armour.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)
class Armour extends Item {
  @JsonKey(name: 'ArmourFormula')
  String armourFormula;
  @JsonKey(name: 'ImposeStealthDisadvantage')
  bool imposeStealthDisadvantage;
  @JsonKey(name: 'StrengthRequirement')
  bool strengthRequirement;
  @JsonKey(name: 'armourType')
  String armourType;

  Armour({
    required super.name,
    required super.sourceBook,
    required super.cost,
    required super.weight,
    required super.stackable,
    required super.equipmentType,
    super.description,
    required this.armourFormula,
    required this.imposeStealthDisadvantage,
    required this.strengthRequirement,
    required this.armourType
  });

  factory Armour.fromJson(Map<String, dynamic> json) {
    return Armour(
      name: json["Name"],
      sourceBook: json["SourceBook"],
      cost: json["Cost"],
      weight: json["Weight"],
      stackable: json["Stackable"] ?? false,
      equipmentType: json["EquipmentType"].cast<String>() as List<String>,
      description: json["Description"],
      armourFormula: json["ArmourFormula"],
      imposeStealthDisadvantage: json["ImposeStealthDisadvantage"] ?? false,
      strengthRequirement: json["StrengthRequirement"] ?? false,
      armourType: json["armourType"],
    );
  }

  @override
  Map<String, dynamic> toJson() => _$ArmourToJson(this);
}
