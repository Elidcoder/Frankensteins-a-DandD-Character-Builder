import 'item.dart';

class Weapon extends Item {
  List<String> properties;

  // Formatted as [["poison","1d8"]...]
  List<List<String>> damageDiceAndType;

  Weapon({
    required super.name,
    required super.sourceBook,
    required super.cost,
    required super.stackable,
    required super.weight,
    required super.equipmentType,
    required this.damageDiceAndType,
    required this.properties
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data["DamageDiceAndType"] = damageDiceAndType;
    data["Properties"] = properties;
    return data;
  }

  factory Weapon.fromJson(Map<String, dynamic> data) {
    return Weapon(
      name: data["Name"],
      sourceBook: data["SourceBook"],
      cost: data["Cost"],
      weight: data["Weight"],
      stackable: data["Stackable"] ?? false,
      properties: data["Properties"].cast<String>() as List<String>,
      equipmentType: data["EquipmentType"].cast<String>() as List<String>,
      damageDiceAndType: (data["DamageDiceAndType"] as List).map((i) => List<String>.from(i)).toList());
  }
}
