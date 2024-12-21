import "named.dart";

// TODO(Use asserts to ensure NUMBEROFSKILLCHOICES <= OPTIONALSKILLPROFICIENCIES.LENGTH)
// TODO(make bond/flaw etc optional)
class Background implements Named {
  @override
  final String name;
  final int numberOfSkillChoices;
  final String sourceBook;

  final int numberOfLanguageChoices;
  final List<String> features;
  final List<String> initialProficiencies;
  final List<String> optionalSkillProficiencies;
  // Options from which language choices are made, all languages available if empty
  final List<String> languageOptions;
  final List<String> toolProficiencies;
  final List<String> personalityTrait;
  final List<String> ideal;
  final List<String> bond;
  final List<String> flaw;
  // TODO(Make classes for every equipment type)
  final List<String> equipment;

  Map<String, dynamic> toJson() => {
    "Name": name,
    "NumberOfSkillChoices": numberOfSkillChoices,
    "Sourcebook": sourceBook,
    "NumberOfLanguageChoices": numberOfLanguageChoices,
    "Features": features,
    "InitialProficiencies": initialProficiencies,
    "OptionalSkillProficiencies": optionalSkillProficiencies,
    "LanguageOptions": languageOptions,
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
    
    final personalityTrait = data["PersonalityTrait"].cast<String>() as List<String>;
    final ideal = data["Ideal"].cast<String>() as List<String>;
    final bond = data["Bond"].cast<String>() as List<String>;
    final flaw = data["Flaw"].cast<String>() as List<String>;


    final features = (data["Features"]??[]).cast<String>() as List<String>;
    final equipment = (data["Equipment"]??[]).cast<String>() as List<String>;
    final toolProficiencies = (data["ToolProficiencies"]??[]).cast<String>() as List<String>;
    final intialProficiencies = (data["InitialProficiencies"]??[]).cast<String>() as List<String>;

    final numberOfSkillChoices = (data["NumberOfSkillChoices"] ?? 0) as int;
    final numberOfLanguageChoices = (data["NumberOfLanguageChoices"] ?? 0) as int;
    final optionalSkillProficiencies =
        (data["OptionalSkillProficiencies"]??[]).cast<String>() as List<String>;
    final languageOptions_ = (data["LanguageOptions"]?? []).cast<String>() as List<String>;
    return Background(
      name: name,
      personalityTrait: personalityTrait,
      ideal: ideal,
      sourceBook: sourceBook,
      bond: bond,
      flaw: flaw,
      equipment: equipment,
      optionalSkillProficiencies: optionalSkillProficiencies,
      languageOptions: languageOptions_,
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
      required this.languageOptions,
      required this.initialProficiencies,
      required this.features,
      required this.equipment,
      required this.optionalSkillProficiencies,
      required this.toolProficiencies,
      this.numberOfSkillChoices = 0,
      this.numberOfLanguageChoices = 0});
  
  List<String> getLanguageOptions() {
    if (languageOptions.isEmpty) {
      return LANGUAGELIST;
    }
    return languageOptions;
  }
}

List<Background> BACKGROUNDLIST = [];
List<String> LANGUAGELIST = [];