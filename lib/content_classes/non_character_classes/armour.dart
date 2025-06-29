import "item/item.dart";

class Armour extends Item {
  String armourFormula;
  bool imposeStealthDisadvantage;
  bool strengthRequirement;
  String armourType;

  Armour({
    required super.name,
    required super.sourceBook,
    required super.cost,
    required super.weight,
    required super.stackable,
    required super.equipmentType,
    required this.armourFormula,
    required this.imposeStealthDisadvantage,
    required this.strengthRequirement,
    required this.armourType
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data["ArmourFormula"] = armourFormula;
    data["ImposeStealthDisadvantage"] = imposeStealthDisadvantage;
    data["StrengthRequirement"] = strengthRequirement;
    data["armourType"] = armourType;
    return data;
  }

  factory Armour.fromJson(Map<String, dynamic> data) {
    return Armour(
      name: data["Name"],
      sourceBook: data["SourceBook"],
      cost: data["Cost"],
      weight: data["Weight"],
      strengthRequirement: data["StrengthRequirement"] ?? false,
      imposeStealthDisadvantage: data["ImposeStealthDisadvantage"] ?? false,
      stackable: data["Stackable"] ?? false,
      armourFormula: data["ArmourFormula"],
      equipmentType: data["EquipmentType"].cast<String>() as List<String>,
      armourType: data["armourType"]);
  }
}
