import 'package:json_annotation/json_annotation.dart';

part 'ability_score.g.dart';

@JsonSerializable()
class AbilityScore{
  int value;
  String name;

  int get abilityScoreCost  => (value > 12) ? 2 : 1;

  AbilityScore({required this.name, required this.value});

  factory AbilityScore.fromJson(Map<String, dynamic> json) => _$AbilityScoreFromJson(json);

  Map<String, dynamic> toJson() => _$AbilityScoreToJson(this);
}
