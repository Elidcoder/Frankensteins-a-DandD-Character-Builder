import "package:flutter/material.dart";
import "../theme/theme_manager.dart";

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
        backingColor: ThemeManager.instance.currentScheme.backingColour,
        textColor: ThemeManager.instance.currentScheme.textColour, 
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
        textColor: ThemeManager.instance.currentScheme.backingColour, 
        backingColor: ThemeManager.instance.currentScheme.backingColour,
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
        color: color ?? ThemeManager.instance.currentScheme.backingColour,
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

  /* Used in: */
  static SizedBox buildStyledElevatedButton({
    required String text,
    required Color backingColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backingColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          side: BorderSide(
            width: 2,
            color: textColor,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }

  /* Used in: Race */
  static SwitchListTile buildStyledSwitchListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(color: ThemeManager.instance.currentScheme.backingColour)),
      value: value,
      onChanged: onChanged,
      activeColor: ThemeManager.instance.currentScheme.backingColour,
      secondary: Icon(Icons.insert_photo, color: ThemeManager.instance.currentScheme.backingColour),
    );
  }

  /* Used in:  */
  static SwitchListTile buildStyledSwitchListTileWithCallback({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(color: ThemeManager.instance.currentScheme.backingColour)),
      value: value,
      onChanged: onChanged,
      activeColor: ThemeManager.instance.currentScheme.backingColour,
      secondary: Icon(Icons.insert_photo, color: ThemeManager.instance.currentScheme.backingColour),
    );
  }

  /* Used in: Background */
  static DropdownButton<String> buildStyledDropdownButton({
    required String? selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required String hintText,
  }) {
    return DropdownButton<String>(
      value: selectedValue,
      dropdownColor: ThemeManager.instance.currentScheme.backingColour,
      hint: Text(
        hintText,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: ThemeManager.instance.currentScheme.textColour,
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: ThemeManager.instance.currentScheme.textColour),
      underline: Container(height: 2, color: ThemeManager.instance.currentScheme.textColour),
      onChanged: onChanged,
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ThemeManager.instance.currentScheme.textColour,
            ),
          ),
        );
      }).toList(),
    );
  }

  /* Used in: Ability Scores */
  static Text buildStyledAbilityScoreText({
    required int score,
    required String label,
    Color? color
  }) {
    return Text(
      "$label: $score",
      style: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        color: color ?? ThemeManager.instance.currentScheme.backingColour,
      ),
    );
  }

  /* Used in: Create A Character */
  static ElevatedButton buildStyledMainButton({
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ThemeManager.instance.currentScheme.backingColour,
        padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textColor ?? ThemeManager.instance.currentScheme.textColour,
        ),
      ),
    );
  }

  /* Used in: Multiple */
  static CheckboxListTile buildStyledCheckboxListTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(title, style: TextStyle(color: ThemeManager.instance.currentScheme.backingColour)),
      value: value,
      onChanged: onChanged,
      fillColor: WidgetStateProperty.all(ThemeManager.instance.currentScheme.backingColour),
      side: BorderSide(
        width: 2,
        color: ThemeManager.instance.currentScheme.backingColour,
      ),
    );
  }

  /* Used in: Multiple */
  static List<Widget> buildStyledSeperatedText(String text){
    return [
      Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 9),
    ];
  }

  /* Used in: Multiple */
  static Widget buildStyledSeperatedTextWithDivider({required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: ThemeManager.instance.currentScheme.backingColour,
          ),
        ),
        const SizedBox(height: 9),
        Divider(height: 10.0, color: ThemeManager.instance.currentScheme.backgroundColour),
      ],
    );
  }

  /* Used in: Multiple */
  static Widget buildStyledFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? positiveColor : unavailableColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /* Used in: Multiple */
  static Widget buildStyledFilterOption({
    required String label,
    required List<String> filters,
    required ValueChanged<String> onToggle,
  }) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (filters.contains(label)) ? ThemeManager.instance.currentScheme.backingColour : unavailableColor
        ),
        onPressed: () => onToggle(label),
        child: Text(label, style: TextStyle(color: ThemeManager.instance.currentScheme.textColour, fontSize: 15))
      ),
    );
  }

  /* Used in: Multiple */
  static Widget buildStyledFilterOptionWithMap({
    required String key,
    required Map<String, bool> filterMap,
    required ValueChanged<String> onToggle,
  }) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (filterMap[key]!) ? ThemeManager.instance.currentScheme.backingColour : unavailableColor
        ),
        onPressed: () => onToggle(key),
        child: buildStyledTinyTextBox(text: key, color: ThemeManager.instance.currentScheme.textColour)
      ),
    );
  }

  /* Used in: Multiple */
  static Widget buildStyledCounterButton({
    required String text,
    required VoidCallback onPressed,
    required bool isEnabled,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
          ? (backgroundColor ?? ThemeManager.instance.currentScheme.backingColour)
          : unavailableColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: isEnabled ? onPressed : null,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor ?? ThemeManager.instance.currentScheme.textColour,
        ),
      ),
    );
  }

  /* Used in: Multiple */
  static String formatList(List<dynamic> list) {
    // Initialize an empty string to store the result
    String result = "";

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
    return Tab(child: Text(label, style: TextStyle(color: ThemeManager.instance.currentScheme.textColour)));
  }

  /// Creates a dropdown button with consistent styling
  static Widget buildBaseDropdownButton({
    required String? value,
    required List<String>? items,
    required ValueChanged<String?> onChanged,
    required String hintText,
  }) {
    return DropdownButton<String>(
      value: value,
      hint: Text(
        hintText,
        style: TextStyle(
          color: ThemeManager.instance.currentScheme.textColour,
          fontWeight: FontWeight.w700,
        ),
      ),
      dropdownColor: ThemeManager.instance.currentScheme.backingColour,
      style: TextStyle(
        color: ThemeManager.instance.currentScheme.textColour,
        fontWeight: FontWeight.w700,
      ),
      items: items?.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  /// Creates text with optional styling (green if true, orange if false)
  static Widget makeOptionalText({
    required bool condition,
    required String trueText,
    required String falseText,
  }) {
    return buildStyledMediumTextBox(
      text: condition ? trueText : falseText,
      color: condition ? positiveColor : notIdealColor,
    );
  }

  /// Creates text with required styling (green if true, red if false)
  static Widget makeRequiredText({
    required bool condition,
    required String trueText,
    required String falseText,
  }) {
    return buildStyledMediumTextBox(
      text: condition ? trueText : falseText,
      color: condition ? positiveColor : negativeColor,
    );
  }

  // Now let me add the missing methods that are still needed
  
  /// Creates a section header with consistent styling
  static Widget buildSectionHeader(String text) {
    return buildStyledLargeTextBox(text: text, color: ThemeManager.instance.currentScheme.backingColour);
  }

  /// Creates a styled radio list tile
  static Widget buildStyledRadioListTile<T>({
    required String title,
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    return RadioListTile<T>(
      title: Text(title, style: TextStyle(color: ThemeManager.instance.currentScheme.backingColour)),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: ThemeManager.instance.currentScheme.backingColour,
    );
  }

  /// Creates a labeled dropdown
  static Widget buildLabeledDropdown({
    required String label,
    required String? selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildStyledSmallTextBox(text: label),
        const SizedBox(height: 5),
        buildStyledDropDown(
          selectedValue: selectedValue,
          options: options,
          onChanged: onChanged,
          hintText: "Select $label",
        ),
      ],
    );
  }

  /// Creates a binary selector button
  static Widget buildBinarySelectorButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? ThemeManager.instance.currentScheme.backingColour : unavailableColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: ThemeManager.instance.currentScheme.textColour,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Creates a styled filter toggle - now supporting old calling pattern
  static Widget makeStyledFilterToggle(
    String label,
    List<String> filters,
    VoidCallback onToggle,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: filters.contains(label) ? ThemeManager.instance.currentScheme.backingColour : unavailableColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      onPressed: onToggle,
      child: Text(
        label,
        style: TextStyle(
          color: ThemeManager.instance.currentScheme.textColour,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Original version with named parameters (keeping both for compatibility)
  static Widget makeStyledFilterToggleNamed({
    required String label,
    required bool isActive,
    required VoidCallback onToggle,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? ThemeManager.instance.currentScheme.backingColour : unavailableColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      onPressed: onToggle,
      child: Text(
        label,
        style: TextStyle(
          color: ThemeManager.instance.currentScheme.textColour,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Creates a styled dropdown - supporting old parameter names
  static Widget buildStyledDropDown({
    String? selectedValue,
    String? initialValue, // alias for selectedValue
    List<String>? options,
    List<dynamic>? items, // alias for options  
    required ValueChanged<String?> onChanged,
    String? hintText,
  }) {
    // Handle parameter aliases
    String? actualSelectedValue = selectedValue ?? initialValue;
    List<String> actualOptions = options ?? (items?.map((e) => e is String ? e : e.name.toString()).toList() ?? []);
    
    return buildStyledDropdownButton(
      selectedValue: actualSelectedValue,
      options: actualOptions,
      onChanged: onChanged,
      hintText: hintText ?? "Select option",
    );
  }

  /// Creates multiple styled ASI selectors - supporting old parameter names
  static Widget buildNStyledAsiSelectors({
    int? count,
    int? numbItems, // alias for count
    List<String>? selectedValues,
    List<bool>? optionalStates, // for compatibility - single list
    List<List<bool>>? optionalStatesList, // for compatibility - nested list
    ValueChanged<String>? onToggle,
    Function? onPressed, // for compatibility with (int choiceNumber, int index, bool isSelected)
  }) {
    // Handle the old pattern with nested lists and complex callback
    if (optionalStatesList != null && onPressed != null) {
      int actualCount = numbItems ?? count ?? 1;
      List<Widget> widgets = [];
      
      for (int choiceNumber = 0; choiceNumber < actualCount; choiceNumber++) {
        widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int index = 0; index < abilityScores.length; index++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (choiceNumber < optionalStatesList.length && 
                                       index < optionalStatesList[choiceNumber].length &&
                                       optionalStatesList[choiceNumber][index]) 
                        ? ThemeManager.instance.currentScheme.backingColour 
                        : unavailableColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    onPressed: () => onPressed(choiceNumber, index, 
                                               choiceNumber < optionalStatesList.length && 
                                               index < optionalStatesList[choiceNumber].length &&
                                               optionalStatesList[choiceNumber][index]),
                    child: Text(
                      abilityScores[index],
                      style: TextStyle(
                        color: ThemeManager.instance.currentScheme.textColour,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
        if (choiceNumber < actualCount - 1) {
          widgets.add(const SizedBox(height: 8));
        }
      }
      
      return Column(children: widgets);
    }
    
    // Handle the new pattern with string list and simple callback
    if (selectedValues != null && onToggle != null) {
      return buildStyledToggleSelector(
        options: abilityScores,
        selectedValues: selectedValues,
        onToggle: onToggle,
      );
    }
    
    // Fallback
    return const SizedBox.shrink();
  }

  /// Creates a styled toggle selector - supporting old parameter names  
  static Widget buildStyledToggleSelector({
    List<String>? options,
    List<String>? itemLabels, // alias for options
    List<String>? selectedValues,
    List<bool>? isSelected, // for compatibility
    ValueChanged<String>? onToggle,
    Function? onPressed, // for compatibility with (int index, bool isSelected)
  }) {
    // Handle parameter aliases
    List<String> actualOptions = itemLabels ?? options ?? [];
    
    // Handle the old pattern with List<bool> and onPressed callback
    if (isSelected != null && onPressed != null) {
      return Wrap(
        spacing: 8,
        children: actualOptions.asMap().entries.map((entry) {
          int index = entry.key;
          String option = entry.value;
          bool isOptionSelected = index < isSelected.length ? isSelected[index] : false;
          
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isOptionSelected ? ThemeManager.instance.currentScheme.backingColour : unavailableColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: () => onPressed(index, isOptionSelected),
            child: Text(
              option,
              style: TextStyle(
                color: ThemeManager.instance.currentScheme.textColour,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      );
    }
    
    // Handle the new pattern with List<String> and onToggle callback
    if (selectedValues != null && onToggle != null) {
      return Wrap(
        spacing: 8,
        children: actualOptions.map((option) {
          final isOptionSelected = selectedValues.contains(option);
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isOptionSelected ? ThemeManager.instance.currentScheme.backingColour : unavailableColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: () => onToggle(option),
            child: Text(
              option,
              style: TextStyle(
                color: ThemeManager.instance.currentScheme.textColour,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      );
    }
    
    // Fallback
    return const SizedBox.shrink();
  }
}
