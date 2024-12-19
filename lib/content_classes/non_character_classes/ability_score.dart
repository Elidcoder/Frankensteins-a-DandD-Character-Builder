import "named.dart";

class AbilityScore implements Named {
  int value;
  @override
  String name;

  AbilityScore({required this.name, required this.value});

  factory AbilityScore.fromJson(Map<String, dynamic> json) => AbilityScore(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}

int abilityScoreCost(int x) {
  if (x > 12) {
    return 2;
  }
  return 1;
}

