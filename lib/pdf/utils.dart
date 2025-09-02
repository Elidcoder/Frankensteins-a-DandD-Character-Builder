// Utility functions for PDF generation
String formatNumber(int number) {
  return (number >= 0) ? "+$number" : "$number";
}

/* Takes in for example [2, "Arrow", "Dagger"] 
 * Outputs: 2xArrow, Dagger */
String formatList(List list) {
  String result = "";

  /* Iterate through the list adding number-string pairs or just strings */
  for (int i = 0; i < list.length; i++) {
    // Current element is a number, so append the number and the next string
    if (list[i] is num) {
      result += "${list[i]}x${list[i + 1]}";
      i++;

    // Append just the current string to the result string
    } else {
      result += "${list[i]}";
    }

    /* If this is not the last element, add a comma and space separator */
    if (i != list.length - 1) result += ", ";
  }
  return result;
}

/* Takes in a list of bonuses to a speed and works out the total bonus */
int decodeBonus(List<String> x) {
  return 0;
}

// Proficiency bonus mapping
final Map<int, int> proficiencyBonus = {
  0: 0,
  1: 2,
  2: 2,
  3: 2,
  4: 2,
  5: 3,
  6: 3,
  7: 3,
  8: 3,
  9: 4,
  10: 4,
  11: 4,
  12: 4,
  13: 5,
  14: 5,
  15: 5,
  16: 5,
  17: 6,
  18: 6,
  19: 6,
  20: 6,
};

// Ability score to modifier mapping
final Map<int, int> modifierFromAbilityScore = {
  0: -5,
  1: -5,
  2: -4,
  3: -4,
  4: -3,
  5: -3,
  6: -2,
  7: -2,
  8: -1,
  9: -1,
  10: 0,
  11: 0,
  12: 1,
  13: 1,
  14: 2,
  15: 2,
  16: 3,
  17: 3,
  18: 4,
  19: 4,
  20: 5,
  21: 5,
  22: 6,
  23: 6,
  24: 7,
  25: 7,
  26: 8,
  27: 8,
  28: 9,
  29: 9,
  30: 10,
  31: 10,
  32: 11,
  33: 11,
  34: 12,
  35: 12,
  36: 13,
  37: 13,
  38: 14,
  39: 14,
  40: 15,
  41: 15,
  42: 16,
  43: 16,
  44: 17,
  45: 17,
  46: 18,
  47: 18,
  48: 19,
  49: 19,
  50: 20
};
