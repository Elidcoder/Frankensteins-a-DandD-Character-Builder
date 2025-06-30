// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colour_scheme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColourScheme _$ColourSchemeFromJson(Map<String, dynamic> json) => ColourScheme(
      textColour: _colorFromJson((json['textColour'] as num).toInt()),
      backingColour: _colorFromJson((json['backingColour'] as num).toInt()),
      backgroundColour:
          _colorFromJson((json['backgroundColour'] as num).toInt()),
    );

Map<String, dynamic> _$ColourSchemeToJson(ColourScheme instance) =>
    <String, dynamic>{
      'textColour': _colorToJson(instance.textColour),
      'backingColour': _colorToJson(instance.backingColour),
      'backgroundColour': _colorToJson(instance.backgroundColour),
    };
