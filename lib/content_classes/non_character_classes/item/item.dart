import "../content.dart";
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item implements Content {
  @override
  @JsonKey(name: 'Name')
  String name;
  @override
  @JsonKey(name: 'SourceBook')
  final String sourceBook;
  //[10,"gold"]
  @JsonKey(name: 'Cost')
  List<dynamic> cost;
  @JsonKey(name: 'Weight')
  double weight;
  @JsonKey(name: 'Stackable', defaultValue: false)
  bool stackable;
  @JsonKey(name: 'Description', defaultValue: null)
  String? description;
  @JsonKey(name: 'EquipmentType')
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

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

}

List<Item> ITEMLIST = [];
