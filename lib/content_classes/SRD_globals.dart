// External Imports
import "dart:convert";

// Project Imports
import 'non_character_classes/all_non_character_classes.dart';

String? jsonString;
const JsonDecoder decoder = JsonDecoder();
final dynamic jsonmap = decoder.convert(jsonString ?? "{}");


T sum<T extends num>(T lhs, T rhs) => (lhs + rhs) as T;
List<Feat> FEATLIST = [];


dynamic mapEquipment(x) {
  if (x["EquipmentType"].contains("Magic")) {
    ///run through magic subtypes
  } else if (x["EquipmentType"].contains("Armour")) {
    return Armour.fromJson(x);
  } else if (x["EquipmentType"].contains("Weapon")) {
    return Weapon.fromJson(x);
  }
  return Item.fromJson(x);
}
