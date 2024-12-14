import 'item.dart';

class Weapon extends Item {
  //[["poison","1d8"]...]
  List<List<String>> damageDiceAndType;
  List<String> properties;
  Weapon(
      {required super.name,
      required super.cost,
      required super.stackable,
      required super.weight,
      required super.equipmentType,
      required this.damageDiceAndType,
      required this.properties});
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data["DamageDiceAndType"] = damageDiceAndType;
    data["Properties"] = properties;
    return data;
  }

  factory Weapon.fromJson(Map<String, dynamic> data) {
    List<dynamic> damage_DiceAndType_ = data["DamageDiceAndType"];
    List<List<String>> damage_DiceAndType = damage_DiceAndType_.map((i)=>List<String>.from(i)).toList();
    return Weapon(
        name: data["Name"],
        cost: data["Cost"],
        weight: data["Weight"],
        stackable: data["Stackable"] ?? false,
        damageDiceAndType: damage_DiceAndType,
        equipmentType: data["EquipmentType"].cast<String>() as List<String>,
        properties: data["Properties"].cast<String>() as List<String>);
  }
}