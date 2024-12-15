/* This class stores the physical description of a character. 
It is used in the character creation process and contains information that's
independent of anything else in the character. */
class CharacterDescription {
  final String characterAge;
  final String characterHeight;
  final String characterWeight;
  final String characterEyes;
  final String characterSkin;
  final String characterHair;
  final String backstory;
  final String name;
  final String gender;

  /* Constructor */
  CharacterDescription(
    {
      required this.characterAge,
      required this.characterHeight,
      required this.characterWeight,
      required this.characterEyes,
      required this.characterSkin,
      required this.characterHair,
      required this.backstory,
      required this.name,
      required this.gender
    }
  );

  /* Method that returns this class as a valid JSON entry. */
  Map<String, dynamic> toJson() => {
    "CharacterAge": characterAge,
    "CharacterHeight": characterHeight,
    "CharacterWeight": characterWeight,
    "CharacterEyes": characterEyes,
    "CharacterHair": characterHair,
    "CharacterSkin": characterSkin,
    "Backstory": backstory,
    "Name": name,
    "Gender": gender,
  };

  /* Method that creates a new instance of this class from a JSON entry. */
  factory CharacterDescription.fromJson(Map<String, dynamic> data) {
    return CharacterDescription(
      characterAge: data["CharacterAge"] as String,
      characterHeight: data["CharacterHeight"] as String,
      characterWeight: data["CharacterWeight"] as String,
      characterEyes: data["CharacterEyes"] as String,
      characterHair: data["CharacterHair"] as String,
      characterSkin: data["CharacterSkin"] as String,
      backstory: data["Backstory"] as String,
      name: data["Name"] as String,
      gender: data["Gender"] as String
      );
  }
}
