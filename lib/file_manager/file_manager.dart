// External Imports
import "dart:io" show File;
import "dart:convert" show jsonDecode, jsonEncode;
import "package:flutter/foundation.dart" show debugPrint;
import "package:flutter/services.dart" show rootBundle;
import "package:path_provider/path_provider.dart" show getApplicationDocumentsDirectory;

// Project Import
import "../colour_scheme_class/colour_scheme.dart";
import "../content_classes/all_content_classes.dart";
import "../services/character_migration_helper.dart";

List<Character> CHARACTERLIST = [];
List<String> GROUPLIST = [];

/* initialiseGlobals reads the JSON and uses it to update the LISTS. */
Future<bool> initialiseGlobals() async {
  if (CHARACTERLIST.isNotEmpty) {
    bool myvar =  true;
    return myvar;
  }
    
  try {
    /* Ensure the local file exists */
    await copyAssetFileToLocal();
    final path = await getLocalFilePath();
    final file = File(path);

    /* Add the information stored in the apps JSON to the LISTS. */
    return await addToGlobalsFromFile(file);

  /* Update faluire */
  } catch (e) {
    return false;
  }
}

/* Helper function that takes in a file, reads it, decodes the JSON,
 * and updates the LISTS accordingly. 
 * May throw an error, !!THE ERROR MUST BE HANDLED BY THE CALLER!!, 
 * returns true if no error was thrown by completion of updates to lists. */
Future<bool> addToGlobalsFromFile(File file) async {
  /* Read the file */
  final jsonString = await file.readAsString();
  final jsonMap = jsonDecode(jsonString);

  /* Add the data into the correct lists. */
  GROUPLIST.addAll(List<String>.from((jsonMap["Groups"]?? [])));
  LANGUAGELIST.addAll(List<String>.from((jsonMap["Languages"]?? [])));
  FEATLIST.addAll(List<Feat>.from((jsonMap["Feats"]?? []).map((x) => Feat.fromJson(x))));
  RACELIST.addAll(List<Race>.from((jsonMap["Races"]?? []).map((x) => Race.fromJson(x))));
  SPELLLIST.addAll(List<Spell>.from((jsonMap["Spells"]?? []).map((x) => Spell.fromJson(x))));
  CLASSLIST.addAll(List<Class>.from((jsonMap["Classes"]?? []).map((x) => Class.fromJson(x))));
  ITEMLIST.addAll(List<Item>.from((jsonMap["Equipment"]?? []).map((x) => mapEquipment(x))));
  CHARACTERLIST.addAll(List<Character>.from((jsonMap["Characters"]?? []).map((x) => Character.fromJson(x))));
  BACKGROUNDLIST.addAll(List<Background>.from((jsonMap["Backgrounds"]?? []).map((x) => Background.fromJson(x))));
  THEMELIST.addAll(List<ColourScheme>.from((jsonMap["ColourSchemes"]?? []).map((x) => ColourScheme.fromJson(x))));
  PROFICIENCYLIST.addAll(List<Proficiency>.from((jsonMap["Proficiencies"]?? []).map((x) => Proficiency.fromJson(x))));

  /* If there were no errors thrown, true is returned. */
  return true;
}

/* Get the file path to the content JSON. */
Future<String> getLocalFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return "${directory.path}/userContent.json";
}

/* Copy the JSON file from the project into the correct location. */
Future<void> copyAssetFileToLocal() async {
  final path = await getLocalFilePath();
  final file = File(path);

  if (!(await file.exists())) {
    /* Load the JSON from assets. */
    final byteData = await rootBundle.load("assets/userContent.json");

    /* Write it locally. */
    await file.writeAsBytes(byteData.buffer.asUint8List());
  }
}

/* Save the changes to the JSON file. */
Future<void> saveChanges() async {
  try {
    /* Ensure the JSON exists in filesys and get the file */
    final path = await getLocalFilePath();
    final file = File(path);

    /* Create the JSON */
    final Map<String, dynamic> data = {
      "Languages": LANGUAGELIST,
      "Proficiencies": PROFICIENCYLIST.map((x) => x.toJson()).toList(),
      "Races": RACELIST.map((x) => x.toJson()).toList(),
      "Backgrounds": BACKGROUNDLIST.map((x) => x.toJson()).toList(),
      "Classes": CLASSLIST.map((x) => x.toJson()).toList(),
      "Spells": SPELLLIST.map((x) => x.toJson()).toList(),
      "Feats": FEATLIST.map((x) => x.toJson()).toList(),
      "Groups": GROUPLIST,
      "Characters": CHARACTERLIST.map((x) => x.toJson()).toList(),
      "ColourSchemes": THEMELIST.map((x) => x.toJson()).toList(),
      "Equipment": List<Map<String, dynamic>>.from(ITEMLIST.map((x) => x.toJson()).toList()),
    };

    /* Write the JSON */
    final jsonStringy = jsonEncode(data);
    await file.writeAsString(jsonStringy);

  /* Error in saving changes, reset globals to undo bad change. */
  } catch (e) {
    GROUPLIST.clear();
    LANGUAGELIST.clear();
    FEATLIST.clear();
    RACELIST.clear();
    SPELLLIST.clear();
    CLASSLIST.clear();
    ITEMLIST.clear();
    CHARACTERLIST.clear();
    BACKGROUNDLIST.clear();
    THEMELIST.clear();
    PROFICIENCYLIST.clear();
    initialiseGlobals();
  }
}

/* Update GROUPLIST from the new character storage system */
Future<void> updateGroupListFromNewSystem() async {
  try {
    // Get all characters from the new system
    final characters = await CharacterMigrationHelper.getAllCharacters();
    
    // Extract unique groups from characters efficiently
    final groups = characters
      .map((c) => c.group)
      .where((group) => group != null && group.trim().isNotEmpty)
      .cast<String>()
      .toSet()
      .toList()
      ..sort();
    
    // Update the global GROUPLIST
    GROUPLIST.clear();
    GROUPLIST.addAll(groups);
    
    // Debug output for verification
    debugPrint('Updated GROUPLIST with ${GROUPLIST.length} groups from ${characters.length} characters');
  } catch (e) {
    debugPrint('Error updating GROUPLIST from new system: $e');
    // Keep existing GROUPLIST if update fails
  }
}
