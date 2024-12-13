import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/material.dart'; // For Color class
import 'package:frankenstein/SRD_globals.dart';
import "character_globals.dart";

List<Character> CHARACTERLIST = [];
List<String> GROUPLIST = [];
/*
Move here later
// Global variables to store your data
List<String> languageList = [];
List<Proficiency> proficiencyList = [];
List<Race> raceList = [];
List<Background> backgroundList = [];
List<Class> classList = [];
List<Spell> spellList = [];
List<Feat> featList = [];
List<Item> itemList = [];
List<String> groupList = [];
List<Character> characterList = [];
List<List<Color>> colorList = [];


 */



Future<bool> updateGlobals() async {
  try {
     // Ensure the local file exists
    await copyAssetFileToLocal();
    final path = await getLocalFilePath();
    final file = File(path);

    // Read the file
    final jsonString = await file.readAsString();
    final jsonmap = jsonDecode(jsonString);


     // Parse the data
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
    //ITEMLIST = [for (var x in jsonmap["Equipment"] ?? []) mapEquipment(x)];
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
  } catch (e, stacktrace) {
    debugPrint("Error in updateGlobals: $e");
    debugPrint("Stacktrace: $stacktrace");
    return false;
  }

  return true;
}

Future<String> getLocalFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/userContent.json';
}

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

Future<void> saveChanges() async {
  try {
    final path = await getLocalFilePath();
    final file = File(path);
    List<dynamic> equipmen = ITEMLIST.map((x) => x.toJson()).toList();
    List<Map<String, dynamic>> equipment = List<Map<String, dynamic>>.from(equipmen);

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
      "Equipment": equipment,
      };

    final jsonStringy = jsonEncode(data);
    await file.writeAsString(jsonStringy);
  } catch (e, stacktrace) {
    debugPrint("Error in saveGlobals: $e");
    debugPrint("Stacktrace: $stacktrace");
  }
}

