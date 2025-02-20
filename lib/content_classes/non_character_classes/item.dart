import "content.dart";

class Item implements Content {
  @override
  String name;
  @override
  final String sourceBook;
  //[10,"gold"]
  List<dynamic> cost;
  double weight;
  bool stackable;
  String? description;
  List<String> equipmentType;

  Item({
    required this.name,
    required this.sourceBook,
    required this.equipmentType,
    required this.cost,
    required this.weight,
    required this.stackable,
    this.description
  });

  Map<String, dynamic> toJson() => {
    "Name": name,
    "SourceBook": sourceBook,
    "EquipmentType": equipmentType,
    "Cost": cost,
    "Weight": weight,
    "Stackable": stackable,
    "Description": description,
  };

  factory Item.fromJson(Map<String, dynamic> data) {
    return Item(
      name: data["Name"],
      sourceBook: data["SourceBook"],
      equipmentType: data["EquipmentType"].cast<String>() as List<String>,
      cost: data["Cost"],
      weight: data["Weight"],
      stackable: data["Stackable"] ?? false,
      description: data["Description"]);
  }

}

List<Item> ITEMLIST = [];
