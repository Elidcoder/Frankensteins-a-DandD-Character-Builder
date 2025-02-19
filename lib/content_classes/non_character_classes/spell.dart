import "content.dart";

class Spell implements Content {
  @override
  final String name;
  @override
  final String sourceBook;

  final String effect;
  final String spellSchool;
  final int level;
  final bool? ritual;
  final String range;
  final bool? verbal;
  final bool? somatic;
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

  Map<String, dynamic> toJson() => {
    "Name": name,
    "SourceBook": sourceBook,
    "Effect": effect,
    "SpellSchool": spellSchool,
    "Level": level,
    "Ritual": ritual,
    "Range": range,
    "Verbal": verbal,
    "Somatic": somatic,
    "Material": material,
    "Timings": timings,
    "AvailableTo": availableTo
  };

  factory Spell.fromJson(Map<String, dynamic> data) {
    return Spell(
      range: data["Range"] as String,
      sourceBook: data["SourceBook"],
      name: data["Name"] as String,
      effect: data["Effect"],
      ritual: (data["Ritual"] as bool?) ?? false,
      level: (data["Level"] as int?) ?? 0,
      verbal: (data["Verbal"] as bool?) ?? false,
      somatic: (data["Somatic"] as bool?) ?? false,
      material: (data["Material"] as String?) ?? "None",
      spellSchool: data["SpellSchool"] as String,
      timings: data["Timings"].cast<dynamic>(),
      availableTo: data["AvailableTo"].cast<String>());
  }
}

List<Spell> SPELLLIST = [];
