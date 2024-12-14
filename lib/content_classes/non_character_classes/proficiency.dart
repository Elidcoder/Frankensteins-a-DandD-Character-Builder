class Proficiency {
  final List<String> proficiencyTree;

  Proficiency({
    required this.proficiencyTree,
  });

  factory Proficiency.fromJson(Map<String, dynamic> data) {
    final proficiencyTree = data["ProficiencyTree"].cast<String>();
    return Proficiency(proficiencyTree: proficiencyTree);
  }

  Map<String, dynamic> toJson() {
    return {
      "ProficiencyTree": [...proficiencyTree],
    };
  }
}

List<Proficiency> PROFICIENCYLIST = [];
