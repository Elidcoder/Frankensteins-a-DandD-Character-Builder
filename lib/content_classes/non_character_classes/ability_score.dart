class AbilityScore {
  int value;
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
