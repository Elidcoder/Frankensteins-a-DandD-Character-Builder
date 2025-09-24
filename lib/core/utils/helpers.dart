import 'package:frankenstein/models/content/equipment/armour/armour.dart'
    show Armour;
import 'package:frankenstein/models/content/equipment/item/item.dart' show Item;
import 'package:frankenstein/models/content/equipment/weapon/weapon.dart'
    show Weapon;

// TODO(Implement this function)
bool isAllowedContent(dynamic x) {
  return true;
}

T sum<T extends num>(T lhs, T rhs) => (lhs + rhs) as T;

dynamic mapEquipment(Map<String, dynamic> x) {
  if (x["EquipmentType"].contains("Magic")) {
    ///run through magic subtypes
  } else if (x["EquipmentType"].contains("Armour")) {
    return Armour.fromJson(x);
  } else if (x["EquipmentType"].contains("Weapon")) {
    return Weapon.fromJson(x);
  }
  return Item.fromJson(x);
}

String displayPlural(List<dynamic> items) {
  if (items.length > 1) {
    return "s";
  }
  return "";
}
