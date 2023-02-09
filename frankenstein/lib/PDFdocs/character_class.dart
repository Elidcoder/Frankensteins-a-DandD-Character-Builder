//import "package:frankenstein/globals.dart";

class AbilityScore {
  int value;
  String name;

  AbilityScore({required this.name, required this.value});
}

class Character {
  final String name;
  //Races
  List<int> raceAbilityScoreIncreases;

  //Ability scores
  final AbilityScore strength;
  final AbilityScore dexterity;
  final AbilityScore constitution;
  final AbilityScore intelligence;
  final AbilityScore wisdom;
  final AbilityScore charisma;

  //ASI feats
  final List<int> featsASIScoreIncreases;

  factory Character.fromJson(Map<String, dynamic> data) {
    final name = data["Name"] as String;

    final raceAbilityScoreIncreases =
        data["RaceAbilityScoreIncreases"].cast<int>() as List<int>;

    final strength = data["Strength"] as AbilityScore;
    final dexterity = data["Dexterity"] as AbilityScore;
    final constitution = data["Constitution"] as AbilityScore;
    final intelligence = data["Intelligence"] as AbilityScore;
    final wisdom = data["Wisdom"] as AbilityScore;
    final charisma = data["Charisma"] as AbilityScore;
    final featsASIScoreIncreases =
        data["FeatsASIScoreIncreases"].cast<int>() as List<int>;
    return Character(
      name: name,
      strength: strength,
      dexterity: dexterity,
      constitution: constitution,
      intelligence: intelligence,
      wisdom: wisdom,
      charisma: charisma,
      raceAbilityScoreIncreases: raceAbilityScoreIncreases,
      featsASIScoreIncreases: featsASIScoreIncreases,
    );
  }
  Character({
    required this.name,
    required this.raceAbilityScoreIncreases,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.featsASIScoreIncreases,
  });
}
