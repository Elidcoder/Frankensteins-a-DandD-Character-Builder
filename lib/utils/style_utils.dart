import "package:flutter/material.dart";
import "../main.dart";

/* Define colours that will be used a lot. */
const Color unavailableColor = Color.fromARGB(247, 56, 53, 52);
const Color positiveColor = Color.fromARGB(255, 10, 126, 54);
const Color negativeColor = Color.fromARGB(255, 172, 46, 46);
const Color notIdealColor = Colors.orange;

const List<String> abilityScores = [
  "Strength",
  "Dexterity",
  "Constitution",
  "Intelligence",
  "Wisdom",
  "Charisma"
];

/// Styling utility functions extracted from create_a_character.dart
/// These functions provide consistent UI styling across all tabs
class StyleUtils {
  /* Helper function */
  static TextField buildStyledTextField({
    required String hintText,
    required TextEditingController textController,
    required ValueChanged<String> onChanged,
    required Color textColor,
    required Color backingColor,
    int lineMax = 1,
    int? lineMin,
    bool filled = false,
  }) {
    return TextField(
      controller: textController,
      maxLines: lineMax,
      minLines: lineMin,
      cursorColor: textColor,
      style: TextStyle(
          fontWeight: FontWeight.w700,
          color: textColor),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w700,
              color: textColor),
          filled: filled,
          fillColor: backingColor,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: backingColor),
              borderRadius:
                  const BorderRadius.all(Radius.circular(12)))),
      onChanged: onChanged
    );
  }
  
  /* Used in: Basics, Backstory */
  static SizedBox buildStyledSmallTextField({
    required String hintText,
    required TextEditingController textController,
    required ValueChanged<String> onChanged,
    double width = 250
  }) {
    return SizedBox(
      width: width,
      height: 50,
      child: buildStyledTextField(
        backingColor: InitialTop.colourScheme.backingColour,
        textColor: InitialTop.colourScheme.textColour, 
        textController: textController, 
        hintText: hintText, 
        onChanged: onChanged, 
        filled: true
      )
    );
  }

  /* Used in: Basics, Backstory */
  static SizedBox buildStyledLargeTextField({
    required String hintText,
    required TextEditingController textController,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 1000,
      height: 100,
      child: buildStyledTextField(
        hintText: hintText, 
        textController: textController, 
        onChanged: onChanged,
        textColor: InitialTop.colourScheme.backingColour, 
        backingColor: InitialTop.colourScheme.backingColour,
        lineMax: 100,
        lineMin: 4
      )
    );
  }

  /* Used in: Race */
  static Text buildStyledTextBox({
    required String text,
    required double size,
    Color? color,
  }) {
    return Text(text,
      style: TextStyle(
        color: color ?? InitialTop.colourScheme.backingColour,
        fontSize: size,
        fontWeight: FontWeight.w700));
  }

  /* Used in: Race */
  static Text buildStyledTinyTextBox({
    required String text,
    Color? color
  }) {
    return buildStyledTextBox(text: text, size: 15, color: color);
  }
  
  /* Used in: Race */
  static Text buildStyledSmallTextBox({
    required String text,
    Color? color
  }) {
    return buildStyledTextBox(text: text, size: 20, color: color);
  }

  /* Used in: Race */
  static Text buildStyledMediumTextBox({
    required String text,
    Color? color
  }) {
    return buildStyledTextBox(text: text, size: 25, color: color);
  }

  /* Used in:  */
  static Text buildStyledLargeTextBox({
    required String text,
    Color? color
  }) {
    return buildStyledTextBox(text: text, size: 30, color: color);
  }

  /* Used in:  */
  static Text buildStyledHugeTextBox({
    required String text,
    Color? color
  }) {
    return buildStyledTextBox(text: text, size: 35, color: color);
  }
}
