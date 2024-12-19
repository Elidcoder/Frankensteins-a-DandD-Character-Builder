import "named.dart";

class Item implements Named {
  @override
  String name;
  //[10,"gold"]
  List<dynamic> cost;
  double weight;
  bool stackable;
  String? description;
  List<String> equipmentType;
  Item(
      {required this.name,
      required this.equipmentType,
      required this.cost,
      required this.weight,
      required this.stackable,
      this.description});
  Map<String, dynamic> toJson() => {
        "EquipmentType": equipmentType,
        "Name": name,
        "Cost": cost,
        "Weight": weight,
        "Stackable": stackable,
        "Description": description,
      };

  factory Item.fromJson(Map<String, dynamic> data) {
    return Item(
        equipmentType: data["EquipmentType"].cast<String>() as List<String>,
        name: data["Name"],
        cost: data["Cost"],
        weight: data["Weight"],
        stackable: data["Stackable"] ?? false,
        description: data["Description"]);
  }

}

List<dynamic> ITEMLIST = [];
