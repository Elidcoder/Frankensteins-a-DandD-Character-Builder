//import "package:frankenstein/globals.dart";

class Character {
  final String name;

  factory Character.fromJson(Map<String, dynamic> data) {
    final name = data['Name'] as String;
    return Character(
      name: name,
    );
  }
  Character({
    required this.name,

    //required this.sourcebook,});
  });
}
