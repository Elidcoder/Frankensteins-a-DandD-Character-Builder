import 'package:json_annotation/json_annotation.dart';

import "../../base/content.dart";

part 'feat.g.dart';

@JsonSerializable()
class Feat implements Content {
  @override
  @JsonKey(name: 'Name')
  final String name;
  @override
  @JsonKey(name: 'SourceBook')
  final String sourceBook;

  @JsonKey(name: 'IsHalfFeat')
  final bool isHalfFeat;
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'Abilities')
  final List<List<dynamic>> abilities;
  @JsonKey(name: 'NumberOfTimesTakeable')
  final int numberOfTimesTakeable;

  Feat({
    required this.name,
    required this.sourceBook,
    required this.isHalfFeat,
    required this.description,
    required this.abilities,
    required this.numberOfTimesTakeable
  });

  String get display => "$name: \n •  ${abilities.where((element) => element[0] == "Bonus").toList().map((sublist) => sublist[2]).toList().join('\n •  ')}";
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Feat) return false;
    return name == other.name &&
           sourceBook == other.sourceBook &&
           isHalfFeat == other.isHalfFeat &&
           description == other.description &&
           abilities.toString() == other.abilities.toString() &&
           numberOfTimesTakeable == other.numberOfTimesTakeable;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      sourceBook,
      isHalfFeat,
      description,
      abilities.toString(),
      numberOfTimesTakeable,
    );
  }
  
  factory Feat.fromJson(Map<String, dynamic> json) => _$FeatFromJson(json);

  Map<String, dynamic> toJson() => _$FeatToJson(this);
}
