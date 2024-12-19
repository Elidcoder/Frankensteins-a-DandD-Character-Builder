import "named.dart";

class Spell implements Named {
  //ADD SPELL TYPE THINGY
  @override
  final String name;
  final String effect;
  final String spellSchool;
  final int level;
  final bool? ritual;
  final String range;
  final bool? verbal;
  final bool? somatic;
  final String? material;
  //[casting 1, number, duration 1, number]
  final List<dynamic> timings;
  final List<String> availableTo;
  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Effect": effect,
      "SpellSchool": spellSchool,
      "Level": level,
      "Ritual": ritual,
      "Range": range,
      "Verbal": verbal,
      "Somatic": somatic,
      "Material": material,
      "Timings": timings,
      "AvailableTo": availableTo,
    };
  }

  factory Spell.fromJson(Map<String, dynamic> data) {
    // note the explicit cast to String
    // this is required if robust lint rules are enabled
    //COULD GO THROUGH EVERY DATA[SPELL[X,Y,Z*]] TO ALLOW LESS FILES TO BE ADDED WITH CONTENT
    final level = data["Level"] as int?;
    final verbal = data["Verbal"] as bool?;
    final somatic = data["Somatic"] as bool?;
    final material = data["Material"] as String?;
    final ritual = data["Ritual"] as bool?;
    return Spell(
        range: data["Range"] as String,
        name: data["Name"] as String,
        effect: data["Effect"],
        ritual: ritual ?? false,
        level: level ?? 0,
        verbal: verbal ?? false,
        somatic: somatic ?? false,
        material: material ?? "None",
        spellSchool: data["SpellSchool"] as String,
        timings: data["Timings"].cast<dynamic>(),
        availableTo: data["AvailableTo"].cast<String>());
  }
  Spell(
      {required this.name,
      required this.level,
      required this.effect,
      required this.timings,
      required this.availableTo,
      required this.spellSchool,
      required this.range,
      this.ritual,
      this.material,
      this.somatic,
      this.verbal});
}

List<Spell> SPELLLIST = [];
