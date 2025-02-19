import "content.dart";

class Feat implements Content {
  @override
  final String name;
  @override
  final String sourceBook;

  final bool isHalfFeat;
  final String description;
  final List<List<dynamic>> abilities;
  final int numberOfTimesTakeable;

  Feat({
    required this.name,
    required this.sourceBook,
    required this.isHalfFeat,
    required this.description,
    required this.abilities,
    required this.numberOfTimesTakeable
  });

  String display() {
    return "$name: \n •  ${abilities.where((element) => element[0] == "Bonus").toList().map((sublist) => sublist[2]).toList().join('\n •  ')}";
  }

  Map<String, dynamic> toJson() => {
    "Name": name,
    "SourceBook": sourceBook,
    "IsHalfFeat": isHalfFeat,
    "Description": description,
    "Abilities": abilities,
    "NumberOfTimesTakeable": numberOfTimesTakeable
  };

  factory Feat.fromJson(Map<String, dynamic> data) {
    return Feat(
      name: data["Name"],
      sourceBook: data["SourceBook"],
      isHalfFeat: data["IsHalfFeat"],
      description: data["Description"],
      abilities: data["Abilities"].cast<List<dynamic>>(),
      numberOfTimesTakeable: data["NumberOfTimesTakeable"]
    );
  }
}
