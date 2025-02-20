// External Imports
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart'; 

// Project Import
import 'content_classes/all_content_classes.dart';

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
    debugPrint("Error in initialiseGlobals: $e");
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
  LANGUAGELIST.addAll(List<String>.from(jsonMap["Languages"]));
  PROFICIENCYLIST.addAll(List<Proficiency>.from(
    jsonMap["Proficiencies"].map((x) => Proficiency.fromJson(x)),
  ));
  RACELIST.addAll(List<Race>.from(
    jsonMap["Races"].map((x) => Race.fromJson(x)),
  ));
  BACKGROUNDLIST.addAll(List<Background>.from(
    jsonMap["Backgrounds"].map((x) => Background.fromJson(x)),
  ));
  CLASSLIST.addAll(List<Class>.from(
    jsonMap["Classes"].map((x) => Class.fromJson(x)),
  ));
  SPELLLIST.addAll(List<Spell>.from(
    jsonMap["Spells"].map((x) => Spell.fromJson(x)),
  ));
  FEATLIST.addAll(List<Feat>.from(
    jsonMap["Feats"].map((x) => Feat.fromJson(x)),
  ));
  ITEMLIST.addAll(List<Item>.from(
    (jsonMap["Equipment"] ?? []).map((x) => mapEquipment(x)),
  ));
  GROUPLIST.addAll(List<String>.from(jsonMap["Groups"]));
  CHARACTERLIST.addAll(List<Character>.from(
    jsonMap["Characters"].map((x) => Character.fromJson(x)),
  ));
  COLORLIST.addAll(List<List<Color>>.from(
    jsonMap["Colours"].map((x) => [
      colorFromJson(x[0]),
      colorFromJson(x[1]),
      colorFromJson(x[2]),
    ]),
  ));

  /* If there were no errors thrown, true is returned. */
  return true;
}

/* Get the file path to the content JSON. */
Future<String> getLocalFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/userContent.json';
}

/* Copy the JSON file from the project into the correct location. */
Future<void> copyAssetFileToLocal() async {
  final path = await getLocalFilePath();
  final file = File(path);

  if (!(await file.exists())) {
    // Load the asset
    final byteData = await rootBundle.load('assets/userContent.json');

    // Write the file
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
      "Colours":  List<List<Map<String, dynamic>>>.from(COLORLIST.map((colours) => colours.map((colour) => colorToJson(colour)).toList()).toList()),
      "Equipment": List<Map<String, dynamic>>.from(ITEMLIST.map((x) => x.toJson()).toList()),
      };

    /* Write the JSON */
    final jsonStringy = jsonEncode(data);
    await file.writeAsString(jsonStringy);

  /* Error in saving changes */
  } catch (e) {
    debugPrint("Error in saveGlobals: $e");
  }
}
