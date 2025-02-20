// ignore_for_file: deprecated_member_use
// Reason: The deprecated member makes the code far more readable.
import "package:flutter/material.dart" show Color;

class ColourScheme {
  Color textColour;
  Color backingColour;
  Color backgroundColour;

  ColourScheme({required this.textColour, required this.backingColour, required this.backgroundColour});

  Map<String, dynamic> toJson() {
    return {
      "textColour": textColour.value,
      "backingColour": backingColour.value,
      "backgroundColour": backgroundColour.value,
    };
  }

  factory ColourScheme.fromJson(Map<String, dynamic> json) {
    return ColourScheme(
      textColour: Color(json["textColour"] as int),
      backingColour: Color(json["backingColour"] as int),
      backgroundColour: Color(json["backgroundColour"] as int),
    );
  }

  bool isSameColourScheme(ColourScheme other) {
    return textColour == other.textColour && backingColour == other.backingColour && backgroundColour == other.backgroundColour;
  }
}

List<ColourScheme> THEMELIST = [];
