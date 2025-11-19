import 'package:json_annotation/json_annotation.dart';

import "../../base/content.dart";

part 'subclass.g.dart';

@JsonSerializable()
class Subclass implements Content {
  @override
  @JsonKey(name: 'Name')
  final String name;
  @override
  @JsonKey(name: 'SourceBook')
  final String sourceBook;
  @JsonKey(name: 'ClassType')
  final String classType;
  @JsonKey(name: 'RoundDown', defaultValue: null)
  final bool? roundDown;
  @JsonKey(name: 'MainOrSpellcastingAbility')
  final String mainOrSpellcastingAbility;
  @JsonKey(name: 'GainAtEachLevel')
  final List<List<List<String>>> gainAtEachLevel;

  factory Subclass.fromJson(Map<String, dynamic> json) =>
      _$SubclassFromJson(json);

  Map<String, dynamic> toJson() => _$SubclassToJson(this);

  Subclass(
      {required this.name,
      required this.classType,
      required this.mainOrSpellcastingAbility,
      this.roundDown,
      required this.sourceBook,
      required this.gainAtEachLevel});
}
