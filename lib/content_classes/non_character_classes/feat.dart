import "named.dart";

class Feat implements Named {
  @override
  final String name;
  final List<List<dynamic>> abilites;
  final String sourceBook;
  final int numberOfTimesTakeable;
  final String description;
  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Abilities": abilites,
      "SourceBook": sourceBook,
      "NumberOfTimesTakeable": numberOfTimesTakeable,
      "Description": description
    };
  }

  factory Feat.fromJson(Map<String, dynamic> data) {
    return Feat(
        name: data["Name"],
        sourceBook: data["SourceBook"],
        abilites: data["Abilities"].cast<List<dynamic>>(),
        description: data["Description"],
        numberOfTimesTakeable: data["NumberOfTimesTakeable"]
        //sourceBook: sourceBook,
        );
  }
  Feat({
    required this.name,
    required this.sourceBook,
    required this.abilites,
    required this.description,
    required this.numberOfTimesTakeable,
  });
}