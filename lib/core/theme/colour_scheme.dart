// ignore_for_file: deprecated_member_use
// Reason: The deprecated member makes the code far more readable.
import "package:flutter/material.dart" show Color;
import 'package:json_annotation/json_annotation.dart';

part 'colour_scheme.g.dart';

// Helper functions for Color serialization
Color _colorFromJson(int value) => Color(value);
int _colorToJson(Color color) => color.value;

// Reusable JsonKey for Color fields
const _colorJsonKey = JsonKey(fromJson: _colorFromJson, toJson: _colorToJson);

@JsonSerializable()
class ColourScheme {
  @_colorJsonKey
  Color textColour;
  @_colorJsonKey
  Color backingColour;
  @_colorJsonKey
  Color backgroundColour;

  ColourScheme(
      {required this.textColour,
      required this.backingColour,
      required this.backgroundColour});

  // Use generated methods
  factory ColourScheme.fromJson(Map<String, dynamic> json) =>
      _$ColourSchemeFromJson(json);
  Map<String, dynamic> toJson() => _$ColourSchemeToJson(this);

  bool isSameColourScheme(ColourScheme other) {
    return textColour == other.textColour &&
        backingColour == other.backingColour &&
        backgroundColour == other.backgroundColour;
  }

  get name =>
      "Custom Theme: backing: $backingColour, text: $textColour, background: $backgroundColour";
}
