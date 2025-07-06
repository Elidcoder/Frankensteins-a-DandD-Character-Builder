import "package:flutter/material.dart";
import "../main.dart";
import "../content_classes/non_character_classes/content.dart";

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

  /* Used in: Basics */
  static Container buildSectionHeader(String title) {
    return Container(
      width: 330,
      height: 65,
      decoration: BoxDecoration(
        color: InitialTop.colourScheme.backingColour,
        border: Border.all(color: Colors.black, width: 2.1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w700,
            color: InitialTop.colourScheme.textColour,
          ),
        ),
      ),
    );
  }

  /* Used in: Basics */
  static CheckboxListTile buildStyledCheckboxListTile({
    required String title,
    required bool? value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(title, style: TextStyle(color: InitialTop.colourScheme.backingColour)),
      value: value,
      onChanged: onChanged,
      activeColor: InitialTop.colourScheme.backingColour,
      secondary: Icon(Icons.insert_photo, color: InitialTop.colourScheme.backingColour),
    );
  }

  /* Used in: Basics */
  static RadioListTile buildStyledRadioListTile({
    required String title,
    required String value,
    required String? groupValue,
    required ValueChanged<dynamic> onChanged,
  }) {
    return RadioListTile(
      activeColor: InitialTop.colourScheme.backingColour,
      title: Text(title,
          style: TextStyle(
              color:
                  InitialTop.colourScheme.backingColour)),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }

  /* Helper function */
  static DropdownButton<String> buildBaseDropdownButton({
  required String? value,
  required List<String>? items,
  required ValueChanged<String?> onChanged,
  String hintText = "Select an option"
  }) {
    return DropdownButton<String>(
      alignment: Alignment.center,
      dropdownColor: InitialTop.colourScheme.backingColour,
      hint: Center(
        child: Text(
          hintText,
          textAlign: TextAlign.center,
            style: TextStyle(
              color: InitialTop.colourScheme.textColour,
              decoration: TextDecoration.underline,
            ),
      )),
      value: value,
      underline: SizedBox(),
      icon: Icon(Icons.arrow_drop_down, color: InitialTop.colourScheme.textColour,),
      style: TextStyle(
        color: InitialTop.colourScheme.textColour,
        fontWeight: FontWeight.w700,
      ),
      onChanged: onChanged,
      items: items?.map<DropdownMenuItem<String>>((String itemValue) {
        return DropdownMenuItem<String>(
          value: itemValue,
          child: Align(
            child: Text(
              itemValue,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: InitialTop.colourScheme.textColour,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /* Used in: Races, Background */
  static Container buildStyledDropDown({
    required String? initialValue,
    required List<Content>? items,
    required ValueChanged<String?> onChanged,
  }) {
    final itemNames = items?.map((e) => e.name).toList() ?? [];
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: InitialTop.colourScheme.backingColour,
      ),
      height: 45,
      child: buildBaseDropdownButton(value: initialValue, items: itemNames, onChanged: onChanged)
    );
  }

  /*Used in Background
  Takes a title and items (List<String>) and creates a dropdown of the items with the title given */
  static Widget buildLabeledDropdown({
    required String labelText,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      children: [
        const SizedBox(height: 10),
        buildStyledSmallTextBox(text: labelText),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: InitialTop.colourScheme.backingColour,
          ),
          height: 45,
          child: buildBaseDropdownButton(value: selectedValue, items: items, onChanged: onChanged),
        ),
      ],
    );
  }

  /* Used in: Races, Background */
  static ToggleButtons buildStyledToggleSelector({
  required List<bool> isSelected,
  required void Function(int index, bool currentlySelected) onPressed,
  required List<String> itemLabels,
  }) {
    return ToggleButtons(
      selectedColor: InitialTop.colourScheme.textColour,
      color: InitialTop.colourScheme.backingColour,
      fillColor: InitialTop.colourScheme.backingColour,
      textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
      borderColor: InitialTop.colourScheme.backingColour,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      borderWidth: 1.5,
      onPressed: (int index) {
        bool currentlySelected = isSelected[index];
        onPressed(index, currentlySelected);
      },
      isSelected: isSelected,
      children: itemLabels.map((label) => Text(" $label ")).toList(),
    );
        
  }

  /* Used in: Races */
  static SizedBox buildNStyledAsiSelectors({
    required int numbItems,
    required void Function(int choiceNumber, int index, bool isSelected) onPressed,
    required List<List<bool>> optionalStates,
  }) {
    assert(numbItems <= optionalStates.length, 
    "itemCount should not exceed the length of optionalStates");
    assert(numbItems >= 0, 
    "itemCount should not be negative");
    return SizedBox(
      height:  numbItems * 62 - 10,
      child: ListView.separated(
        itemCount: numbItems,
        separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 10.0, color: InitialTop.colourScheme.backgroundColour),
        itemBuilder: (BuildContext context, int choiceNumber) {
          return Align(
            alignment: Alignment.center,
            child: buildStyledToggleSelector(
              isSelected: optionalStates[choiceNumber],
              onPressed: (index, currentlySelected) {
                onPressed(choiceNumber, index, currentlySelected);
              },
              itemLabels: abilityScores
            )  
          );
        },
      )
    );
  }

  /* Helper function for text with conditional coloring */
  static Text makePossibleText({
    required Color colorFalse,
    required bool condition,
    required String trueText,
    required String falseText,
  }) {
    return buildStyledMediumTextBox(
      text: condition ? trueText : falseText, 
      color: condition ? positiveColor : colorFalse
    );
  }

  static Text makeRequiredText({
    required bool condition,
    required String trueText,
    required String falseText,
  }) {
    return makePossibleText(
      colorFalse: negativeColor, 
      condition: condition, 
      trueText: trueText, 
      falseText: falseText
    );
  }

  static Text makeOptionalText({
    required bool condition,
    required String trueText,
    required String falseText,
  }) {
    return makePossibleText(
      colorFalse: notIdealColor, 
      condition: condition, 
      trueText: trueText, 
      falseText: falseText
    );
  }

  static ElevatedButton makeStyledFilterToggle(String label, List<String> filters, VoidCallback onToggle) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: (filters.contains(label)) ? InitialTop.colourScheme.backingColour : unavailableColor
      ),
      onPressed: onToggle,
      child: Text(label, style: TextStyle(color: InitialTop.colourScheme.textColour, fontSize: 15))
    );
  }

  static OutlinedButton buildBinarySelectorButton({
    required String key,
    required Map<String, bool> filterMap,
    required VoidCallback onToggle
  }) {
    assert(filterMap.containsKey(key), "Key must be a valid key in filterMap");
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: (filterMap[key]!) ? InitialTop.colourScheme.backingColour : unavailableColor),
      onPressed: onToggle,
      child: buildStyledTinyTextBox(text: key, color: InitialTop.colourScheme.textColour)
    );
  }

  static OutlinedButton buildStyledButton({
    required Widget child,
    required VoidCallback? onPressed,
    bool enabled = true,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 3.0,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: enabled 
          ? (backgroundColor ?? InitialTop.colourScheme.backingColour)
          : unavailableColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))
        ),
        side: BorderSide(
          width: borderWidth, 
          color: borderColor ?? const Color.fromARGB(255, 27, 155, 10)
        ),
      ),
      onPressed: enabled ? onPressed : null,
      child: child,
    );
  }

  static String produceEquipmentOptionDescription(List list) {
    // Initialize an empty string to store the result
    String result = '';

    // Iterate through the list
    for (int i = 0; i < list.length; i++) {
      // Check if the current element is a number
      if (list[i] is num) {
        // Append the current number and string pair to the result string
        result += '${list[i]}x${list[i + 1]}';

        // Skip over the next element (the string)
        i++;
      } else {
        // Append just the current string to the result string
        result += '${list[i]}';
      }

      // If this is not the last element, add a comma and space separator
      if (i != list.length - 1) result += ', ';
    }

    // Return the final formatted string
    return result;
  }

  static Tab tabLabel(String label) {
    return Tab(child: Text(label, style: TextStyle(color: InitialTop.colourScheme.textColour)));
  }
}
