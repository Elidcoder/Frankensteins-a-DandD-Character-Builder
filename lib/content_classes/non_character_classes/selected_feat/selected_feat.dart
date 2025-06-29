import '../feat.dart';

import 'package:json_annotation/json_annotation.dart';

part 'selected_feat.g.dart';

@JsonSerializable()
class SelectedFeat {
  final Feat feat;
  int timesTaken;

  SelectedFeat({
    required this.feat,
    required this.timesTaken,
  });

  /// Deserialization: creates a `SelectedFeat` from JSON
  factory SelectedFeat.fromJson(Map<String, dynamic> json) =>
      _$SelectedFeatFromJson(json);

  /// Serialization: converts this `SelectedFeat` into JSON
  Map<String, dynamic> toJson() => _$SelectedFeatToJson(this);
}
