import "named.dart";

List<List<List<dynamic>>> parseJsonToMultiList(List jsonData) {
  List<List<List<dynamic>>> multiList = [];

  for (var outerList in jsonData) {
    if (outerList is List) {
      List<List<dynamic>> castedOuterList = [];
      for (var innerList in outerList) {
        if (innerList is List) {
          castedOuterList.add(innerList.cast<dynamic>());
        }
      }
      multiList.add(castedOuterList);
    }
  }

  return multiList;
}

//classes - PROFICIENCY LIST NEEDS FIXING
class Class implements Named {
  final String? spellsKnownFormula;
  final List<int>? spellsKnownPerLevel;
  @override
  final String name;
  final String classType;
  final int maxHitDiceRoll;
  final bool? roundDown;
  final String mainOrSpellcastingAbility;
  //starting gold
  //[STR/DEX/CON/INT/WIS/CHAR/numbrequired]
  final List<int> multiclassingRequirements;
  final int numberOfSkillChoices;
  final List<String> optionsForSkillProficiencies;
  final List<String>? spellsAndSpellSlots; //replace with list both or 2 lists

  final List<String> savingThrowProficiencies;
  final List<List<dynamic>>
      equipmentOptions; //replace string => equipment//2 options for every one
  //Wrong change later
  final List<String>?
      proficienciesGained; //replace string with equipment (parent of) armour/tools/weapons

  final List<List<dynamic>> gainAtEachLevel; //replace string with something?
  final String sourceBook;
  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "MulticlassingRequirements": multiclassingRequirements,
      "MainOrSpellcastingAbility": mainOrSpellcastingAbility,
      "ClassType": classType,
      "MaxHitDiceRoll": maxHitDiceRoll,
      "RoundDown": roundDown,
      "NumberOfSkillChoices": numberOfSkillChoices,
      "OptionsForSkillProficiencies": optionsForSkillProficiencies,
      "SavingThrowProficiencies": savingThrowProficiencies,
      "SpellsAndSpellSlots": spellsAndSpellSlots,
      "Sourcebook": sourceBook,
      "EquipmentOptions": equipmentOptions
          .map((option) =>
              option.map((innerList) => innerList.toList()).toList())
          .toList(),
      "GainedProficiencies": proficienciesGained,
      "GainAtEachLevel": gainAtEachLevel,
      "SpellsKnownFormula": spellsKnownFormula,
      "SpellsKnownPerLevel": spellsKnownPerLevel,
    };
  }

  factory Class.fromJson(Map<String, dynamic> data) {
    final multiclassingRequirements =
        data["MulticlassingRequirements"].cast<int>() as List<int>;
    final name = data["Name"] as String;
    final mainOrSpellcastingAbility =
        data["MainOrSpellcastingAbility"] as String;
    final classType = data["ClassType"] as String;
    final maxHitDiceRoll = data["MaxHitDiceRoll"] as int;
    final roundDown = data["RoundDown"] as bool?;
    final numberOfSkillChoices = data["NumberOfSkillChoices"] as int;
    final sourceBook = data["Sourcebook"] as String;

    final spellsAndSpellSlots =
        data["SpellsAndSpellSlots"]?.cast<String>() as List<String>?;
    final optionsForSkillProficiencies =
        data["OptionsForSkillProficiencies"].cast<String>() as List<String>;
    final savingThrowProficiencies =
        data["SavingThrowProficiencies"].cast<String>() as List<String>;

    final equipmentOptions = parseJsonToMultiList(data["EquipmentOptions"])
        .map((outerList) =>
            outerList.map((innerList) => innerList.cast<dynamic>()).toList())
        .toList();
    final proficienciesGained =
        data["GainedProficiencies"]?.cast<String>() as List<String>?;
    return Class(
        multiclassingRequirements: multiclassingRequirements,
        mainOrSpellcastingAbility: mainOrSpellcastingAbility,
        classType: classType,
        maxHitDiceRoll: maxHitDiceRoll,
        name: name,
        roundDown: roundDown,
        numberOfSkillChoices: numberOfSkillChoices,
        optionsForSkillProficiencies: optionsForSkillProficiencies,
        savingThrowProficiencies: savingThrowProficiencies,
        spellsAndSpellSlots: spellsAndSpellSlots,
        sourceBook: sourceBook,
        equipmentOptions: equipmentOptions,
        gainAtEachLevel: (data["GainAtEachLevel"].cast<List<dynamic>>()),
        proficienciesGained: proficienciesGained,
        spellsKnownFormula: data["SpellsKnownFormula"],
        spellsKnownPerLevel: data["SpellsKnownPerLevel"]?.cast<int>());
  }
  Class(
      {required this.multiclassingRequirements,
      required this.name,
      required this.mainOrSpellcastingAbility,
      required this.classType,
      required this.maxHitDiceRoll,
      this.roundDown,
      this.spellsAndSpellSlots,
      this.spellsKnownFormula,
      this.spellsKnownPerLevel,
      required this.numberOfSkillChoices,
      required this.optionsForSkillProficiencies,
      required this.sourceBook,
      required this.savingThrowProficiencies,
      required this.equipmentOptions,
      required this.gainAtEachLevel,
      required this.proficienciesGained});
}

List<Class> CLASSLIST = [];
