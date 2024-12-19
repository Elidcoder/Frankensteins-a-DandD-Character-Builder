import "named.dart";

//NO CASE SHOULD HAVE NUMBEROFSKILLCHOICES>OPTIONALSKILLPROFICIENCIES.LENGTH
// TODO(make bond/flawetc optional)
class Background implements Named {
  @override
  final String name;
  final int? numberOfSkillChoices;
  final String sourceBook;

  final int? numberOfLanguageChoices;
  final List<String>? features;
  final List<String>? initialProficiencies;
  final List<String>? optionalSkillProficiencies;
  final List<String>? toolProficiencies;
  final List<String> personalityTrait;
  final List<String> ideal;
  final List<String> bond;
  final List<String> flaw;
  //make classes for every equipment type
  final List<String>? equipment;
  Map<String, dynamic> toJson() => {
        "Name": name,
        "NumberOfSkillChoices": numberOfSkillChoices,
        "Sourcebook": sourceBook,
        "NumberOfLanguageChoices": numberOfLanguageChoices,
        "Features": features,
        "InitialProficiencies": initialProficiencies,
        "OptionalSkillProficiencies": optionalSkillProficiencies,
        "ToolProficiencies": toolProficiencies,
        "PersonalityTrait": personalityTrait,
        "Ideal": ideal,
        "Bond": bond,
        "Flaw": flaw,
        "Equipment": equipment,
      };
  factory Background.fromJson(Map<String, dynamic> data) {
    final name = data["Name"] as String;
    final sourceBook = data["Sourcebook"] as String;

    final personalityTrait =
        data["PersonalityTrait"].cast<String>() as List<String>;
    final ideal = data["Ideal"].cast<String>() as List<String>;
    final bond = data["Bond"].cast<String>() as List<String>;
    final flaw = data["Flaw"].cast<String>() as List<String>;

    final numberOfSkillChoices = data["NumberOfSkillChoices"] as int?;
    final numberOfLanguageChoices = data["NumberOfLanguageChoices"] as int?;
    //final sourceBook = data["Sourcebook"];
    final features = data["Features"]?.cast<String>() as List<String>?;
    final equipment = data["Equipment"]?.cast<String>() as List<String>?;

    final toolProficiencies =
        data["ToolProficiencies"]?.cast<String>() as List<String>?;
    final intialProficiencies =
        data["InitialProficiencies"]?.cast<String>() as List<String>?;
    /*final proficienciesGainedNames =
        data["InitialProficiencies"]?.cast<String>() as List<String>?;
        
    final initialProficiencies = (proficienciesGainedNames?.map((thisprof) =>
            (PROFICIENCYLIST.singleWhere(
                (listprof) => listprof.proficiencyTree.last == thisprof))))
        ?.toList();*/
    final optionalSkillProficiencies =
        data["OptionalSkillProficiencies"]?.cast<String>() as List<String>?;
    return Background(
      name: name,
      personalityTrait: personalityTrait,
      ideal: ideal,
      sourceBook: sourceBook,
      bond: bond,
      flaw: flaw,
      equipment: equipment,
      optionalSkillProficiencies: optionalSkillProficiencies,
      numberOfLanguageChoices: numberOfLanguageChoices,
      numberOfSkillChoices: numberOfSkillChoices,
      toolProficiencies: toolProficiencies,
      initialProficiencies: intialProficiencies,
      features: features,
    );
  }
  Background(
      {required this.sourceBook,
      required this.name,
      required this.personalityTrait,
      required this.ideal,
      required this.bond,
      required this.flaw,
      this.numberOfSkillChoices,
      this.numberOfLanguageChoices,
      this.initialProficiencies,
      this.features,
      this.equipment,
      this.optionalSkillProficiencies,
      this.toolProficiencies});
}

List<Background> BACKGROUNDLIST = [];
