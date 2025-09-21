import 'package:json_annotation/json_annotation.dart';

part 'character_description.g.dart';

/* This class stores the physical description of a character.
It is used in the character creation process and contains information that's
independent of anything else in the character. */
@JsonSerializable()
class CharacterDescription {
  String age;
  String height;
  String weight;
  String eyes;
  String skin;
  String hair;
  String backstory;
  String name;
  String gender;

  /* Constructor */
  CharacterDescription(
      {this.age = "",
      this.height = "",
      this.weight = "",
      this.eyes = "",
      this.skin = "",
      this.hair = "",
      this.backstory = "",
      this.name = "",
      this.gender = ""});

  /* Method that returns this class as a valid JSON entry. */
  Map<String, dynamic> toJson() => _$CharacterDescriptionToJson(this);

  /* Method that creates a new instance of this class from a JSON entry. */
  factory CharacterDescription.fromJson(Map<String, dynamic> json) =>
      _$CharacterDescriptionFromJson(json);
}
