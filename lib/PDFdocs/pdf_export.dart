import 'dart:typed_data';
//import 'package:makepdfs/models/invoice.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:frankenstein/character_globals.dart';
import 'package:frankenstein/SRD_globals.dart';

//1038xidk
//ARGB => 0x(AA)(RR)(GG)(BB)
String formatNumber(int number) {
  return number >= 0 ? "+$number" : "$number";
}

int decodeBonus(List<String> x) {
  return 0;
}

//color: const PdfColor.fromInt(0xffEBA834),
Future<Uint8List> makePdf(Character userCharacter) async {
  final pdf = Document();

  final classSkills = (userCharacter.classList.isNotEmpty)
      ? CLASSLIST
          .firstWhere((element) =>
              userCharacter.classList.isNotEmpty &&
              element.name == userCharacter.classList.first)
          .optionsForSkillProficiencies
          .where((element) => userCharacter.classSkillsSelected[CLASSLIST
              .firstWhere((element) =>
                  userCharacter.classList.isNotEmpty &&
                  element.name == userCharacter.classList.first)
              .optionsForSkillProficiencies
              .indexOf(element)])
          .toList()
      : [];
  final List<String> skillsSelected = [
    for (var x in userCharacter.skillsSelected?.toList() ?? [])
      userCharacter.background.optionalSkillProficiencies?[x] ??
          "ERROR LINE 18 pdf_export.dart"
  ];
  //var a = CLASSLIST[0];
  Map<int, int> proficiencyBonus = {
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
  pdf.addPage(
    Page(
      build: (context) {
        return Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    height: 80.0,
                    width: 500.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.8),
                    ),
                    child: Row(children: [
                      SizedBox(width: 20),
                      Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          width: 145.0,
                          child: Column(children: [
                            Container(
                                alignment: Alignment.center,
                                height: 14.0,
                                width: 140.0,
                                child: Text(
                                  "DUNGEONS & DRAGONS",
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                height: 14.0,
                                width: 90.0,
                                child: Text(
                                  "Character name:",
                                  style: const TextStyle(fontSize: 8.0),
                                )),
                            Container(
                              alignment: Alignment.center,
                              height: 15.0,
                              width: 140.0,

                              //child: Text(" ${userCharacter.name}")
                              child: (userCharacter.name.replaceAll(" ", "") ==
                                      "")
                                  ? Text(
                                      "No data to display",
                                    )
                                  : Text(
                                      userCharacter.name,
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                            ),
                          ])),
                      Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: 105.0,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 15),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    child: Text(
                                      "Class and Level:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                    alignment: Alignment.center,
                                    height: 17.0,
                                    width: 90.0,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: (userCharacter.classLevels
                                              .any((x) => x != 0))
                                          ? Text(
                                              CLASSLIST
                                                  .asMap()
                                                  .entries
                                                  .where((entry) =>
                                                      userCharacter.classLevels[
                                                          entry.key] !=
                                                      0)
                                                  .map((entry) =>
                                                      "${entry.value.name}: ${userCharacter.classLevels[entry.key]}")
                                                  .join(", "),
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            )
                                          : Text(
                                              "No data to display",
                                            ),
                                    )),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    child: Text(
                                      "Race:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                    alignment: Alignment.center,
                                    height: 17.0,
                                    width: 90.0,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                          (userCharacter.subrace == null)
                                              ? userCharacter.race.name
                                              : "${userCharacter.race.name} (${userCharacter.subrace!.name})",
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline)),
                                    )),
                              ])),
                      Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: 105.0,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 15),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    child: Text(
                                      "Background:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 90.0,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(userCharacter.background.name,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline)),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    child: Text(
                                      "Alignment:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 90.0,
                                    child: Text("N/A",
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline))),
                              ])),
                      Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: 105.0,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 15),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    child: Text(
                                      "Player name:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 90.0,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: (userCharacter.playerName
                                                .replaceAll(" ", "") ==
                                            "")
                                        ? Text(
                                            "No data to display",
                                          )
                                        : Text(
                                            userCharacter.playerName,
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    child: Text(
                                      "Experience points:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 90.0,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                        "${userCharacter.characterExperience}",
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline)),
                                  ),
                                ),
                              ])),
                    ])),
                SizedBox(height: 10),
                Container(
                    alignment: Alignment.center,
                    //margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    height: 628.0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //column one
                          Container(
                              alignment: Alignment.center,
                              width: 155.0,
                              child: Column(children: [
                                //Top box
                                Container(
                                    alignment: Alignment.center,
                                    height: 448.0,
                                    child: Row(children: [
                                      //Ability Scores
                                      Container(
                                          alignment: Alignment.center,
                                          width: 60.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: const PdfColor.fromInt(
                                                0xff9c9995),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                    height: 63,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                          width: 0.8),
                                                      color: const PdfColor
                                                          .fromInt(0xffffffff),
                                                    ),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text("Strength",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          10)),
                                                          Text(
                                                              "${userCharacter.strength.value + userCharacter.raceAbilityScoreIncreases[0] + userCharacter.featsASIScoreIncreases[0]}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          23)),
                                                          Container(
                                                              height: 13,
                                                              padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 0, 5, 1),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          0.8)),
                                                              child: Text(formatNumber(modifierFromAbilityScore[userCharacter
                                                                          .strength
                                                                          .value +
                                                                      userCharacter
                                                                          .raceAbilityScoreIncreases[0] +
                                                                      userCharacter.featsASIScoreIncreases[0]] ??
                                                                  0)))
                                                        ])),
                                                Container(
                                                    height: 63,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text("Dexterity",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          10)),
                                                          Text(
                                                              "${userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          23)),
                                                          Container(
                                                              height: 13,
                                                              padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 0, 5, 1),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          0.8)),
                                                              child: Text(formatNumber(modifierFromAbilityScore[userCharacter
                                                                          .dexterity
                                                                          .value +
                                                                      userCharacter
                                                                          .raceAbilityScoreIncreases[1] +
                                                                      userCharacter.featsASIScoreIncreases[1]] ??
                                                                  0)))
                                                        ])),
                                                Container(
                                                    height: 63,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text("Constitution",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          8)),
                                                          Text(
                                                              "${userCharacter.constitution.value + userCharacter.raceAbilityScoreIncreases[2] + userCharacter.featsASIScoreIncreases[2]}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          23)),
                                                          Container(
                                                              height: 13,
                                                              padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 0, 5, 1),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          0.8)),
                                                              child: Text(formatNumber(modifierFromAbilityScore[userCharacter
                                                                          .constitution
                                                                          .value +
                                                                      userCharacter
                                                                          .raceAbilityScoreIncreases[2] +
                                                                      userCharacter.featsASIScoreIncreases[2]] ??
                                                                  0)))
                                                        ])),
                                                Container(
                                                    height: 63,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text("Intelligence",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          9)),
                                                          Text(
                                                              "${userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          23)),
                                                          Container(
                                                              height: 13,
                                                              padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 0, 5, 1),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          0.8)),
                                                              child: Text(formatNumber(modifierFromAbilityScore[userCharacter
                                                                          .intelligence
                                                                          .value +
                                                                      userCharacter
                                                                          .raceAbilityScoreIncreases[3] +
                                                                      userCharacter.featsASIScoreIncreases[3]] ??
                                                                  0)))
                                                        ])),
                                                Container(
                                                    height: 63,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text("Wisdom",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          10)),
                                                          Text(
                                                              "${userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          23)),
                                                          Container(
                                                              height: 13,
                                                              padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 0, 5, 1),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          0.8)),
                                                              child: Text(formatNumber(modifierFromAbilityScore[userCharacter
                                                                          .wisdom
                                                                          .value +
                                                                      userCharacter
                                                                          .raceAbilityScoreIncreases[4] +
                                                                      userCharacter.featsASIScoreIncreases[4]] ??
                                                                  0)))
                                                        ])),
                                                Container(
                                                    height: 63,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text("Charisma",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          10)),
                                                          Text(
                                                              "${userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          23)),
                                                          Container(
                                                              height: 13,
                                                              padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 0, 5, 1),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          0.8)),
                                                              child: Text(formatNumber(modifierFromAbilityScore[userCharacter
                                                                          .charisma
                                                                          .value +
                                                                      userCharacter
                                                                          .raceAbilityScoreIncreases[5] +
                                                                      userCharacter.featsASIScoreIncreases[5]] ??
                                                                  0)))
                                                        ])),
                                              ])),
                                      //Other stuff
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 3, 3, 0),
                                          alignment: Alignment.center,
                                          width: 95.0,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    height: 22,
                                                    child: Row(children: [
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 22,
                                                          height: 22,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2.0),
                                                              border:
                                                                  Border.all(
                                                                      width:
                                                                          0.8)),
                                                          child: Text(
                                                              (userCharacter
                                                                      .inspired)
                                                                  ? ""
                                                                  : "X",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13))),
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 68,
                                                          height: 16,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            2.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            2.0),
                                                                  ),
                                                                  border: Border
                                                                      .all(
                                                                          width:
                                                                              0.8)),
                                                          child: Text(
                                                              " Inspiration",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          9.4))),
                                                    ])),
                                                Container(
                                                    height: 26,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              alignment: Alignment
                                                                  .center,
                                                              width: 22,
                                                              height: 22,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          2.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          0.8)),
                                                              child: Text(
                                                                  formatNumber(proficiencyBonus[userCharacter
                                                                          .classLevels
                                                                          .reduce(
                                                                              (value, element) => value + element)]
                                                                      as int),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13))),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 68,
                                                              height: 16,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .only(
                                                                        topRight:
                                                                            Radius.circular(2.0),
                                                                        bottomRight:
                                                                            Radius.circular(2.0),
                                                                      ),
                                                                      border: Border.all(
                                                                          width:
                                                                              0.8)),
                                                              child: Text(
                                                                  " Proficiency Bonus",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          7.6))),
                                                        ])),
                                                Container(
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Container(
                                                          height: 16,
                                                          child: Center(
                                                              child: Text(
                                                                  "Saving throws",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12)))),
                                                      Container(
                                                          height: 14,
                                                          child: Row(children: [
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Strength"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Strength"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.strength.value + userCharacter.raceAbilityScoreIncreases[0] + userCharacter.featsASIScoreIncreases[0]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.strength.value + userCharacter.raceAbilityScoreIncreases[0] + userCharacter.featsASIScoreIncreases[0]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Strength ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                          ])),
                                                      Container(
                                                          height: 14,
                                                          child: Row(children: [
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Dexterity"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Dexterity"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Dexterity ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                          ])),
                                                      Container(
                                                          height: 14,
                                                          child: Row(children: [
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Constitution"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Constitution"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.constitution.value + userCharacter.raceAbilityScoreIncreases[2] + userCharacter.featsASIScoreIncreases[2]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.constitution.value + userCharacter.raceAbilityScoreIncreases[2] + userCharacter.featsASIScoreIncreases[2]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(
                                                                " Constitution ",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 14,
                                                          child: Row(children: [
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Intelligence"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Intelligence"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(
                                                                " Intelligence ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                          ])),
                                                      Container(
                                                          height: 14,
                                                          child: Row(children: [
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Wisdom"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Wisdom"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Wisdom ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                          ])),
                                                      Container(
                                                          height: 14,
                                                          child: Row(children: [
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Charisma"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            (userCharacter
                                                                    .savingThrowProficiencies
                                                                    .contains(
                                                                        "Charisma"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Charisma ",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                    ])),
                                                Container(
                                                    height: 260,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Container(
                                                          height: 23,
                                                          child: Center(
                                                              child: Text(
                                                                  "Skills",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14)))),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Acrobatics"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Acrobatics"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Acrobatics ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Dex)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Animal Handling"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Animal Handling"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(
                                                                " Animal Handling ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Wis)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Arcana"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Arcana"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Arcana ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Int)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Athletics"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Athletics"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.strength.value + userCharacter.raceAbilityScoreIncreases[0] + userCharacter.featsASIScoreIncreases[0]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.strength.value + userCharacter.raceAbilityScoreIncreases[0] + userCharacter.featsASIScoreIncreases[0]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Athletics ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Str)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Deception"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Deception"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Deception ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Cha)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "History"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "History"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" History ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Int)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Insight"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Insight"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Insight ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Wis)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Intimidation"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Intimidation"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(
                                                                " Intimidation ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Cha)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Investigation"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Investigation"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(
                                                                " Investigation ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Int)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Medicine"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Medicine"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Medicine ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Wis)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Nature"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Nature"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Nature ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Int)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Perception"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Perception"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Perception ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Wis)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Performance"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Performance"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(
                                                                " Performance ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Cha)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Persuasion"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Persuasion"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Persuasion ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Cha)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Religion"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Religion"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Religion ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Int)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Sleight of Hand"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Sleight of Hand"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(
                                                                " Sleight of Hand ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Dex)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Stealth"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Stealth"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Stealth ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text("(Dex)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                      Container(
                                                          height: 13,
                                                          child: Row(children: [
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Survival"))
                                                                ? Text("  X ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                                : Text("  O ",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6.4)),
                                                            ([
                                                              ...userCharacter
                                                                  .skillProficiencies,
                                                              ...userCharacter
                                                                      .background
                                                                      .initialProficiencies ??
                                                                  [],
                                                              ...classSkills,
                                                              ...skillsSelected
                                                            ].contains(
                                                                    "Survival"))
                                                                ? Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4))
                                                                : Text(
                                                                    "${formatNumber(modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0)} ",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            6.4)),
                                                            Text(" Survival ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        6.4)),
                                                            Text(" (Wis)",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            6.4))
                                                          ])),
                                                    ])),
                                              ]))
                                    ])),
                                //Middle small box
                                Container(
                                    alignment: Alignment.center,
                                    height: 48.0,
                                    child: Container(
                                        height: 26.0,
                                        child: Row(children: [
                                          Container(
                                              alignment: Alignment.center,
                                              width: 26,
                                              height: 26,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  border:
                                                      Border.all(width: 0.8)),
                                              child: (userCharacter
                                                      .skillProficiencies
                                                      .contains("Perception"))
                                                  ? Text(
                                                      "${10 + (modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))}",
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    )
                                                  : Text(
                                                      "${10 + (modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0)}",
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    )),
                                          Container(
                                              alignment: Alignment.center,
                                              width: 129,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(2.0),
                                                    bottomRight:
                                                        Radius.circular(2.0),
                                                  ),
                                                  border:
                                                      Border.all(width: 0.8)),
                                              child: Text(
                                                  " Passive Perception (Wisdom) ",
                                                  style: const TextStyle(
                                                      fontSize: 8.8))),
                                        ]))),
                                //Bottom box
                                Container(
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                    height: 132.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.8)),
                                    child: Column(children: [
                                      Text("Other proficiencies & languages:",
                                          style:
                                              const TextStyle(fontSize: 10.5)),
                                      Container(
                                          height: 117,
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 0),
                                          child: Text(
                                              "Other proficiencies - ${[
                                                ...userCharacter.background
                                                        .toolProficiencies ??
                                                    [],
                                                ...userCharacter.race
                                                        .toolProficiencies ??
                                                    [],
                                                ...userCharacter.subrace
                                                        ?.toolProficiencies ??
                                                    [],
                                                ...userCharacter
                                                    .mainToolProficiencies
                                              ].join(", ")}\nLanguages Known - ${userCharacter.languagesKnown.join(", ")}",
                                              style:
                                                  const TextStyle(fontSize: 8)))
                                    ]))
                              ])),
                          //Column two
                          Container(
                              alignment: Alignment.center,
                              width: 155.0,
                              child: Column(children: [
                                //topbox
                                Container(
                                    alignment: Alignment.center,
                                    height: 244.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: const PdfColor.fromInt(0xff9c9995),
                                    ),
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 4, 5, 0),
                                    child: Column(children: [
                                      SizedBox(height: 9),
                                      Container(
                                          alignment: Alignment.center,
                                          height: 47.0,
                                          child: Row(children: [
                                            Container(
                                                alignment: Alignment.center,
                                                width: 45,
                                                height: 47,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 2, 5, 0),
                                                decoration: BoxDecoration(
                                                  color: const PdfColor.fromInt(
                                                      0xffffffff),
                                                  border:
                                                      Border.all(width: 0.8),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(24),
                                                    bottomRight:
                                                        Radius.circular(24),
                                                  ),
                                                ),
                                                child: Column(children: [
                                                  Text("Armour\nClass:",
                                                      style: const TextStyle(
                                                          fontSize: 9.5)),
                                                  Container(
                                                    width: 155,
                                                    //child:
                                                  ),
                                                ])),
                                            SizedBox(width: 5),
                                            Container(
                                                //alignment: Alignment.center,
                                                height: 47,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        1, 4, 1, 0),
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const PdfColor.fromInt(
                                                            0xffffffff),
                                                    border:
                                                        Border.all(width: 0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0)),
                                                child: Column(children: [
                                                  Text("Initiative:",
                                                      style: const TextStyle(
                                                          fontSize: 9.5)),
                                                  SizedBox(height: 3),
                                                  Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(1, 0, 0, 0),
                                                      child: ([
                                                        ...userCharacter
                                                            .skillProficiencies,
                                                        ...userCharacter
                                                                .background
                                                                .initialProficiencies ??
                                                            [],
                                                        ...classSkills,
                                                        ...skillsSelected
                                                      ].contains("Initiative"))
                                                          ? Text(
                                                              "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0 + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18))
                                                          : Text(
                                                              "${formatNumber(modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0)} ",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18)))
                                                ])),
                                            SizedBox(width: 5),
                                            Container(
                                                //alignment: Alignment.center,
                                                height: 47,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        1, 4, 1, 0),
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const PdfColor.fromInt(
                                                            0xffffffff),
                                                    border:
                                                        Border.all(width: 0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0)),
                                                child: Column(children: [
                                                  Text("Speed",
                                                      style: const TextStyle(
                                                          fontSize: 9.5)),
                                                  SizedBox(height: 3),
                                                  Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(1, 0, 0, 0),
                                                      child: (userCharacter
                                                                  .subrace ==
                                                              null)
                                                          ? Text(
                                                              "${userCharacter.race.walkingSpeed + decodeBonus(userCharacter.speedBonuses["Walking"] ?? [])}ft",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18))
                                                          : Text(
                                                              "${userCharacter.subrace!.walkingSpeed + decodeBonus(userCharacter.speedBonuses["Walking"] ?? [])}ft",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18))),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(1, 0, 0, 0),
                                                    //child:
                                                  ),
                                                ]))
                                          ])),
                                      SizedBox(height: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 56.0,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 1, 0, 0),
                                        decoration: BoxDecoration(
                                          color: const PdfColor.fromInt(
                                              0xffffffff),
                                          border: Border.all(width: 0.8),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            topRight: Radius.circular(6),
                                            bottomLeft: Radius.circular(2),
                                            bottomRight: Radius.circular(2),
                                          ),
                                        ),
                                        child: Column(children: [
                                          Text("Health:"),
                                          Container(
                                              width: 155,
                                              child: Row(children: [
                                                SizedBox(width: 26),
                                                Text("Hit point maximum: ",
                                                    style: TextStyle(
                                                        fontSize: 9.6,
                                                        fontItalic: Font
                                                            .timesBoldItalic(),
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xff6B6E73))),
                                                Text(
                                                    " ${userCharacter.maxHealth}",
                                                    style: const TextStyle(
                                                        fontSize: 10.6,
                                                        decoration:
                                                            TextDecoration
                                                                .underline))
                                              ]))
                                        ]),
                                      ),
                                      SizedBox(height: 7),
                                      Container(
                                          width: 155,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 2, 0, 0),
                                          height: 44.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                                bottomLeft: Radius.circular(6),
                                                bottomRight: Radius.circular(6),
                                              ),
                                              color: const PdfColor.fromInt(
                                                  0xffffffff),
                                              border: Border.all(width: 0.8)),
                                          child: Text(
                                              "           Temporary hit points:",
                                              style: const TextStyle(
                                                  fontSize: 9.5))),
                                      SizedBox(height: 7),
                                      Row(children: [
                                        Container(
                                            alignment: Alignment.center,
                                            width: 70,
                                            height: 54.0,
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 2, 5, 0),
                                            decoration: BoxDecoration(
                                                color: const PdfColor.fromInt(
                                                    0xffffffff),
                                                border: Border.all(width: 0.8),
                                                borderRadius:
                                                    BorderRadius.circular(4.0)),
                                            child: Column(children: [
                                              Text("Hit Dice:",
                                                  style: const TextStyle(
                                                      fontSize: 10.5)),
                                              Container(
                                                height: 54,
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Text("Total: ",
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              fontItalic: Font
                                                                  .timesBoldItalic(),
                                                              color: const PdfColor
                                                                      .fromInt(
                                                                  0xff6B6E73))),
                                                      Text(
                                                          CLASSLIST
                                                              .where((car) => userCharacter
                                                                  .classList
                                                                  .contains(
                                                                      car.name))
                                                              .fold<Map<String, int>>(
                                                                  {},
                                                                  (map, car) => map
                                                                    ..update(car.name, (count) => count + 1,
                                                                        ifAbsent: () =>
                                                                            1))
                                                              .entries
                                                              .where((entry) =>
                                                                  entry.value >
                                                                  0)
                                                              .map((entry) =>
                                                                  "${(userCharacter.classList.where((car) => car == entry.key).length)}D${CLASSLIST.firstWhere((car) => car.name == entry.key).maxHitDiceRoll}")
                                                              .join(", "),
                                                          style: const TextStyle(
                                                              fontSize: 9,
                                                              decoration: TextDecoration.underline)),
                                                      SizedBox(width: 5),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ])),
                                        SizedBox(width: 5),
                                        Container(
                                            //alignment: Alignment.center,
                                            height: 54.0,
                                            padding: const EdgeInsets.fromLTRB(
                                                1, 3, 1, 0),
                                            width: 70,
                                            decoration: BoxDecoration(
                                                color: const PdfColor.fromInt(
                                                    0xffffffff),
                                                border: Border.all(width: 0.8),
                                                borderRadius:
                                                    BorderRadius.circular(4.0)),
                                            child: Column(children: [
                                              Text(" Death Saves:",
                                                  style: const TextStyle(
                                                      fontSize: 9.5)),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        1, 0, 0, 0),
                                                child: Row(children: [
                                                  Text("Successes:",
                                                      style: TextStyle(
                                                          fontSize: 7,
                                                          fontItalic: Font
                                                              .timesBoldItalic(),
                                                          color: const PdfColor
                                                                  .fromInt(
                                                              0xff6B6E73))),
                                                  Text(" O-O-O",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9.5))
                                                ]),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        1, 0, 0, 0),
                                                child: Row(children: [
                                                  Text("Fails:",
                                                      style: TextStyle(
                                                          fontSize: 7,
                                                          fontItalic: Font
                                                              .timesBoldItalic(),
                                                          color: const PdfColor
                                                                  .fromInt(
                                                              0xff6B6E73))),
                                                  Text(" O-O-O",
                                                      style: TextStyle(
                                                          fontSize: 9.5,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ]),
                                              )
                                            ]))
                                      ]),
                                    ])),
                                //middle box
                                Container(
                                    alignment: Alignment.center,
                                    height: 203.5,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 16.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.8)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 16.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.8)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 16.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.8)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 130.5,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.8)),
                                          ),
                                        ])),
                                //bottom box
                                Container(
                                    alignment: Alignment.center,
                                    height: 180.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.8)),
                                    child: Row(children: [
                                      //Coin options
                                      Container(
                                          alignment: Alignment.center,
                                          width: 45.0,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                    alignment: Alignment.center,
                                                    height: 27.0,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Platinum",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 8)),
                                                      Text(
                                                          "${userCharacter.currency["Platinum Pieces"] ?? "ERROR"}")
                                                    ])),
                                                Container(
                                                    alignment: Alignment.center,
                                                    height: 27.0,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Gold",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 8)),
                                                      Text(
                                                          "${userCharacter.currency["Gold Pieces"] ?? "ERROR"}")
                                                    ])),
                                                Container(
                                                    alignment: Alignment.center,
                                                    height: 27.0,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Electrum",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 8)),
                                                      Text(
                                                          "${userCharacter.currency["Electrum Pieces"] ?? "ERROR"}")
                                                    ])),
                                                Container(
                                                    alignment: Alignment.center,
                                                    height: 27.0,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Silver",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 8)),
                                                      Text(
                                                          "${userCharacter.currency["Silver Pieces"] ?? "ERROR"}")
                                                    ])),
                                                Container(
                                                    alignment: Alignment.center,
                                                    height: 27.0,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Copper",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 8)),
                                                      Text(
                                                          "${userCharacter.currency["Copper Pieces"] ?? "ERROR"}")
                                                    ])),
                                              ])),
                                      //Equipment?
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              2, 2, 2, 0),
                                          alignment: Alignment.center,
                                          width: 110.0,
                                          child: Column(children: [
                                            Text("Equipment"),
                                            Container(
                                                child: Text(
                                                    [
                                                      ...userCharacter
                                                          .unstackableEquipmentSelected
                                                          .map((entry) =>
                                                              entry.name),
                                                      ...userCharacter
                                                          .stackableEquipmentSelected
                                                          .entries
                                                          .map((entry) =>
                                                              "${entry.value}x${entry.key}"),
                                                      ...userCharacter
                                                              .background
                                                              .equipment ??
                                                          []
                                                    ].join(", "),
                                                    style: const TextStyle(
                                                        fontSize: 8)))
                                          ]))
                                    ]))
                              ])),
                          //Column three
                          Container(
                              alignment: Alignment.center,
                              width: 155.0,
                              child: Column(children: [
                                Container(
                                    alignment: Alignment.center,
                                    height: 244.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                        7.5, 9, 7.5, 0),
                                    child: Column(children: [
                                      Container(
                                          alignment: Alignment.center,
                                          height: 66.0,
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2, 5, 0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(7),
                                                topRight: Radius.circular(7),
                                                bottomLeft: Radius.circular(7),
                                                bottomRight: Radius.circular(7),
                                              ),
                                              color: const PdfColor.fromInt(
                                                  0xffffffff),
                                              border: Border.all(width: 0.8)),
                                          child: Column(children: [
                                            Text("Personality Trait:",
                                                style: const TextStyle(
                                                    fontSize: 10)),
                                            Text(
                                                userCharacter
                                                    .backgroundPersonalityTrait,
                                                style: const TextStyle(
                                                    fontSize: 7)),
                                          ])),
                                      SizedBox(height: 9),
                                      Container(
                                          alignment: Alignment.center,
                                          height: 46.5,
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2, 5, 0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(7),
                                                topRight: Radius.circular(7),
                                                bottomLeft: Radius.circular(3),
                                                bottomRight: Radius.circular(3),
                                              ),
                                              color: const PdfColor.fromInt(
                                                  0xffffffff),
                                              border: Border.all(width: 0.8)),
                                          child: Column(children: [
                                            Text("Ideals:",
                                                style: const TextStyle(
                                                    fontSize: 10)),
                                            Text(userCharacter.backgroundIdeal,
                                                style: const TextStyle(
                                                    fontSize: 6)),
                                          ])),
                                      SizedBox(height: 9),
                                      Container(
                                          alignment: Alignment.center,
                                          height: 43.5,
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2, 5, 0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                                bottomLeft: Radius.circular(2),
                                                bottomRight: Radius.circular(2),
                                              ),
                                              color: const PdfColor.fromInt(
                                                  0xffffffff),
                                              border: Border.all(width: 0.8)),
                                          child: Column(children: [
                                            Text("Bonds:",
                                                style: const TextStyle(
                                                    fontSize: 10)),
                                            Text(userCharacter.backgroundBond,
                                                style: const TextStyle(
                                                    fontSize: 6))
                                          ])),
                                      SizedBox(height: 9),
                                      Container(
                                          alignment: Alignment.center,
                                          height: 46.5,
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2, 5, 0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(3),
                                                topRight: Radius.circular(3),
                                                bottomLeft: Radius.circular(7),
                                                bottomRight: Radius.circular(7),
                                              ),
                                              color: const PdfColor.fromInt(
                                                  0xffffffff),
                                              border: Border.all(width: 0.8)),
                                          child: Column(children: [
                                            Text("Flaws:",
                                                style: const TextStyle(
                                                    fontSize: 10)),
                                            Text(userCharacter.backgroundFlaw,
                                                style: const TextStyle(
                                                    fontSize: 6))
                                          ])),
                                    ])),
                                SizedBox(height: 8),
                                Container(
                                    alignment: Alignment.center,
                                    height: 375.5,
                                    padding:
                                        const EdgeInsets.fromLTRB(3, 2, 3, 0),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.8)),
                                    child: Column(children: [
                                      Text("Features & traits:"),
                                      Container(
                                          height: 359,
                                          child: Text(
                                              userCharacter.featuresAndTraits
                                                  .join(",\n"),
                                              style:
                                                  const TextStyle(fontSize: 6)))
                                    ])),
                              ])),
                        ])),
                //Text(userCharacter.name)
              ],
            ));
      },
    ),
  );
  return pdf.save();
}
