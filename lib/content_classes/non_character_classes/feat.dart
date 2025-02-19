import "named.dart";

class Feat implements Named {
  @override
  final String name;
  final List<List<dynamic>> abilites;
  final String sourceBook;
  final int numberOfTimesTakeable;
  final String description;
  final bool isHalfFeat;

  String display() {
    return "$name: \n •  ${abilites.where((element) => element[0] == "Bonus").toList().map((sublist) => sublist[2]).toList().join('\n •  ')}";
  }

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Abilities": abilites,
      "SourceBook": sourceBook,
      "NumberOfTimesTakeable": numberOfTimesTakeable,
      "Description": description,
      "IsHalfFeat": isHalfFeat
    };
  }

  factory Feat.fromJson(Map<String, dynamic> data) {
    return Feat(
        name: data["Name"],
        sourceBook: data["SourceBook"],
        abilites: data["Abilities"].cast<List<dynamic>>(),
        description: data["Description"],
        numberOfTimesTakeable: data["NumberOfTimesTakeable"],
        isHalfFeat: data["IsHalfFeat"],
        );
  }

  Feat({
    required this.name,
    required this.sourceBook,
    required this.abilites,
    required this.description,
    required this.numberOfTimesTakeable,
    required this.isHalfFeat
  });
}
