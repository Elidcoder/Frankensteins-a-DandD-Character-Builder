/* This class stores the physical description of a character. 
It is used in the character creation process and contains information that's
independent of anything else in the character. */
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
    {
      this.age = "",
      this.height = "",
      this.weight = "",
      this.eyes = "",
      this.skin = "",
      this.hair = "",
      this.backstory = "",
      this.name = "",
      this.gender = ""
    }
  );

  /* Method that returns this class as a valid JSON entry. */
  Map<String, dynamic> toJson() => {
    "CharacterAge": age,
    "CharacterHeight": height,
    "CharacterWeight": weight,
    "CharacterEyes": eyes,
    "CharacterHair": hair,
    "CharacterSkin": skin,
    "Backstory": backstory,
    "Name": name,
    "Gender": gender,
  };

  /* Method that creates a new instance of this class from a JSON entry. */
  factory CharacterDescription.fromJson(Map<String, dynamic> data) {
    return CharacterDescription(
      age: data["CharacterAge"] as String,
      height: data["CharacterHeight"] as String,
      weight: data["CharacterWeight"] as String,
      eyes: data["CharacterEyes"] as String,
      hair: data["CharacterHair"] as String,
      skin: data["CharacterSkin"] as String,
      backstory: data["Backstory"] as String,
      name: data["Name"] as String,
      gender: data["Gender"] as String
      );
  }
}
