import 'package:json_annotation/json_annotation.dart';

import "../../base/content.dart";

part 'spell.g.dart';

@JsonSerializable()
class Spell implements Content {
  @override
  final String name;
  @override
  final String sourceBook;

  final String effect;
  final String spellSchool;
  @JsonKey(defaultValue: 0)
  final int level;
  @JsonKey(defaultValue: false)
  final bool? ritual;
  final String range;
  @JsonKey(defaultValue: false)
  final bool? verbal;
  @JsonKey(defaultValue: false)
  final bool? somatic;
  @JsonKey(defaultValue: 'None')
  final String? material;
  final List<String> availableTo;

  // Formatted as [casting time type, casting multiple, duration time type, duration multiple]
  final List<dynamic> timings;

  Spell({
    required this.name,
    required this.sourceBook,
    required this.level,
    required this.effect,
    required this.timings,
    required this.availableTo,
    required this.spellSchool,
    required this.range,
    this.ritual,
    this.material,
    this.somatic,
    this.verbal
  });

  // Use generated methods
  factory Spell.fromJson(Map<String, dynamic> json) => _$SpellFromJson(json);
  Map<String, dynamic> toJson() => _$SpellToJson(this);
}
