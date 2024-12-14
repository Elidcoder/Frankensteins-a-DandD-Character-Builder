class Subclass {
  final String name;
  final String classType;
  final bool? roundDown;
  final String mainOrSpellcastingAbility;
  final List<List<List<String>>>
      gainAtEachLevel; //replace string with something?
  final String sourceBook;
  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "ClassType": classType,
      "RoundDown": roundDown,
      "MainOrSpellcastingAbility": mainOrSpellcastingAbility,
      "GainAtEachLevel": gainAtEachLevel,
      "Sourcebook": sourceBook,
    };
  }

  factory Subclass.fromJson(Map<String, dynamic> data) {
    final name = data["Name"] as String;
    final mainOrSpellcastingAbility =
        data["MainOrSpellcastingAbility"] as String;
    final classType = data["ClassType"] as String;
    final roundDown = data["RoundDown"] as bool?;
    final sourceBook = data["Sourcebook"] as String;
    final gainAtEachLevel = data["GainAtEachLevel"].cast<List<List<String>>>()
        as List<List<List<String>>>;
    return Subclass(
        classType: classType,
        name: name,
        roundDown: roundDown,
        sourceBook: sourceBook,
        gainAtEachLevel: gainAtEachLevel,
        mainOrSpellcastingAbility: mainOrSpellcastingAbility);
  }
  Subclass(
      {required this.name,
      required this.classType,
      required this.mainOrSpellcastingAbility,
      this.roundDown,
      required this.sourceBook,
      required this.gainAtEachLevel});
}