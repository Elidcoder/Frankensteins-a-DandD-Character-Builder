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

/* UpdateGlobals reads the JSON and uses it to update the LISTS. */
Future<bool> updateGlobals() async {
  try {
    /* Ensure the local file exists */
    await copyAssetFileToLocal();
    final path = await getLocalFilePath();
    final file = File(path);

    /* Read the file */
    final jsonString = await file.readAsString();
    final jsonmap = jsonDecode(jsonString);

     /* Parse the data into the lists*/
    LANGUAGELIST = List<String>.from(jsonmap["Languages"]);
    PROFICIENCYLIST = List<Proficiency>.from(
      jsonmap["Proficiencies"].map((x) => Proficiency.fromJson(x)),
    );
    RACELIST = List<Race>.from(
      jsonmap["Races"].map((x) => Race.fromJson(x)),
    );
    BACKGROUNDLIST = List<Background>.from(
      jsonmap["Backgrounds"].map((x) => Background.fromJson(x)),
    );
    CLASSLIST = List<Class>.from(
      jsonmap["Classes"].map((x) => Class.fromJson(x)),
    );
    SPELLLIST = List<Spell>.from(
      jsonmap["Spells"].map((x) => Spell.fromJson(x)),
    );
    FEATLIST = List<Feat>.from(
      jsonmap["Feats"].map((x) => Feat.fromJson(x)),
    );
    ITEMLIST = List<Item>.from(
      (jsonmap["Equipment"] ?? []).map((x) => mapEquipment(x)),
    );
    GROUPLIST = List<String>.from(jsonmap["Groups"]);
    CHARACTERLIST = List<Character>.from(
      jsonmap["Characters"].map((x) => Character.fromJson(x)),
    );
    COLORLIST = List<List<Color>>.from(
      jsonmap["Colours"].map((x) => [colorFromJson(x[0]), colorFromJson(x[1]), colorFromJson(x[2])]),
    );
  /* Update faliure */
  } catch (e) {
    debugPrint("Error in updateGlobals: $e");
    return false;
  }
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
