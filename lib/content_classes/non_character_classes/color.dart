import 'package:flutter/material.dart';

Color colorFromJson(Map<String, dynamic> json) {
  return Color(json["value"] as int);
}

Map<String, dynamic> colorToJson(Color color) {
  return {
    "value": color.value,
  };
}

List<List<Color>> COLORLIST = [];