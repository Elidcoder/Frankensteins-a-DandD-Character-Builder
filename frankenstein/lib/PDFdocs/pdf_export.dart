import 'dart:typed_data';
//import 'package:makepdfs/models/invoice.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:frankenstein/PDFdocs/character_class.dart';
import "package:frankenstein/globals.dart";
//1038xidk
//ARGB => 0x(AA)(RR)(GG)(BB)

Future<Uint8List> makePdf(Character userCharacter) async {
  final pdf = Document();
  var a = CLASSLIST[0];
  final Map<int, String> modifierFromAbilityScore = {
    0: "-5",
    1: "-5",
    2: "-4",
    3: "-4",
    4: "-3",
    5: "-3",
    6: "-2",
    7: "-2",
    8: "-1",
    9: "-1",
    10: "0",
    11: "0",
    12: "+1",
    13: "+1",
    14: "+2",
    15: "+2",
    16: "+3",
    17: "+3",
    18: "+4",
    19: "+4",
    20: "+5",
    21: "+5",
    22: "+6",
    23: "+6",
    24: "+7",
    25: "+7",
    26: "+8",
    27: "+8",
    28: "+9",
    29: "+9",
    30: "+10",
    31: "+10",
    32: "+11",
    33: "+11",
    34: "+12",
    35: "+12",
    36: "+13",
    37: "+13",
    38: "+14",
    39: "+14",
    40: "+15",
    41: "+15",
    42: "+16",
    43: "+16",
    44: "+17",
    45: "+17",
    46: "+18",
    47: "+18",
    48: "+19",
    49: "+19",
    50: "+20"
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
                      color: const PdfColor.fromInt(0xff2196FD),
                      border: Border.all(
                          color: const PdfColor.fromInt(0xff214AFD),
                          width: 0.8),
                    ),
                    child: Row(children: [
                      Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: 185.0,
                          decoration: BoxDecoration(
                            color: const PdfColor.fromInt(0xff7602A1),
                            border: Border.all(
                                color: const PdfColor.fromInt(0xff214AFD),
                                width: 0.8),
                          ),
                          child: Column(children: [
                            Container(
                                alignment: Alignment.center,
                                height: 14.0,
                                width: 140.0,
                                decoration: BoxDecoration(
                                  color: const PdfColor.fromInt(0xffd902b9),
                                  border: Border.all(
                                      color: const PdfColor.fromInt(0xff214AFD),
                                      width: 0.8),
                                ),
                                child: Text(
                                  "DUNGEONS & DRAGONS",
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                height: 11.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                  color: const PdfColor.fromInt(0xffd902b9),
                                  border: Border.all(
                                      color: const PdfColor.fromInt(0xff214AFD),
                                      width: 0.8),
                                ),
                                child: Text(
                                  "Character name:",
                                  style: const TextStyle(fontSize: 8.0),
                                )),
                            Container(
                              alignment: Alignment.center,
                              height: 30.0,
                              width: 140.0,
                              decoration: BoxDecoration(
                                color: const PdfColor.fromInt(0xffd902b9),
                                border: Border.all(
                                    color: const PdfColor.fromInt(0xff214AFD),
                                    width: 0.8),
                              ),
                            ),
                          ])),
                      Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: 105.0,
                          decoration: BoxDecoration(
                            color: const PdfColor.fromInt(0xff7602A1),
                            border: Border.all(
                                color: const PdfColor.fromInt(0xff214AFD),
                                width: 0.8),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 15),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      color: const PdfColor.fromInt(0xffd902b9),
                                      border: Border.all(
                                          color: const PdfColor.fromInt(
                                              0xff214AFD),
                                          width: 0.8),
                                    ),
                                    child: Text(
                                      "Class and Level:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                    color: const PdfColor.fromInt(0xffd902b9),
                                    border: Border.all(
                                        color:
                                            const PdfColor.fromInt(0xff214AFD),
                                        width: 0.8),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      color: const PdfColor.fromInt(0xffd902b9),
                                      border: Border.all(
                                          color: const PdfColor.fromInt(
                                              0xff214AFD),
                                          width: 0.8),
                                    ),
                                    child: Text(
                                      "Race:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                    color: const PdfColor.fromInt(0xffd902b9),
                                    border: Border.all(
                                        color:
                                            const PdfColor.fromInt(0xff214AFD),
                                        width: 0.8),
                                  ),
                                ),
                              ])),
                      Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: 105.0,
                          decoration: BoxDecoration(
                            color: const PdfColor.fromInt(0xff7602A1),
                            border: Border.all(
                                color: const PdfColor.fromInt(0xff214AFD),
                                width: 0.8),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 15),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      color: const PdfColor.fromInt(0xffd902b9),
                                      border: Border.all(
                                          color: const PdfColor.fromInt(
                                              0xff214AFD),
                                          width: 0.8),
                                    ),
                                    child: Text(
                                      "Background:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                    color: const PdfColor.fromInt(0xffd902b9),
                                    border: Border.all(
                                        color:
                                            const PdfColor.fromInt(0xff214AFD),
                                        width: 0.8),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      color: const PdfColor.fromInt(0xffd902b9),
                                      border: Border.all(
                                          color: const PdfColor.fromInt(
                                              0xff214AFD),
                                          width: 0.8),
                                    ),
                                    child: Text(
                                      "Alignment:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                    color: const PdfColor.fromInt(0xffd902b9),
                                    border: Border.all(
                                        color:
                                            const PdfColor.fromInt(0xff214AFD),
                                        width: 0.8),
                                  ),
                                ),
                              ])),
                      Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: 105.0,
                          decoration: BoxDecoration(
                            color: const PdfColor.fromInt(0xff7602A1),
                            border: Border.all(
                                color: const PdfColor.fromInt(0xff214AFD),
                                width: 0.8),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 15),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      color: const PdfColor.fromInt(0xffd902b9),
                                      border: Border.all(
                                          color: const PdfColor.fromInt(
                                              0xff214AFD),
                                          width: 0.8),
                                    ),
                                    child: Text(
                                      "Player name:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                    color: const PdfColor.fromInt(0xffd902b9),
                                    border: Border.all(
                                        color:
                                            const PdfColor.fromInt(0xff214AFD),
                                        width: 0.8),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: 11.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      color: const PdfColor.fromInt(0xffd902b9),
                                      border: Border.all(
                                          color: const PdfColor.fromInt(
                                              0xff214AFD),
                                          width: 0.8),
                                    ),
                                    child: Text(
                                      "Experience points:",
                                      style: const TextStyle(fontSize: 8.0),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                    color: const PdfColor.fromInt(0xffd902b9),
                                    border: Border.all(
                                        color:
                                            const PdfColor.fromInt(0xff214AFD),
                                        width: 0.8),
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
                                                              child: Text(modifierFromAbilityScore[userCharacter
                                                                          .strength
                                                                          .value +
                                                                      userCharacter.raceAbilityScoreIncreases[
                                                                          0] +
                                                                      userCharacter
                                                                          .featsASIScoreIncreases[0]] ??
                                                                  "0"))
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
                                                              child: Text(modifierFromAbilityScore[userCharacter
                                                                          .dexterity
                                                                          .value +
                                                                      userCharacter.raceAbilityScoreIncreases[
                                                                          1] +
                                                                      userCharacter
                                                                          .featsASIScoreIncreases[1]] ??
                                                                  "0"))
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
                                                              child: Text(modifierFromAbilityScore[userCharacter
                                                                          .constitution
                                                                          .value +
                                                                      userCharacter.raceAbilityScoreIncreases[
                                                                          2] +
                                                                      userCharacter
                                                                          .featsASIScoreIncreases[2]] ??
                                                                  "0"))
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
                                                              child: Text(modifierFromAbilityScore[userCharacter
                                                                          .intelligence
                                                                          .value +
                                                                      userCharacter.raceAbilityScoreIncreases[
                                                                          3] +
                                                                      userCharacter
                                                                          .featsASIScoreIncreases[3]] ??
                                                                  "0"))
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
                                                              child: Text(modifierFromAbilityScore[userCharacter
                                                                          .wisdom
                                                                          .value +
                                                                      userCharacter.raceAbilityScoreIncreases[
                                                                          4] +
                                                                      userCharacter
                                                                          .featsASIScoreIncreases[4]] ??
                                                                  "0"))
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
                                                              child: Text(modifierFromAbilityScore[userCharacter
                                                                          .charisma
                                                                          .value +
                                                                      userCharacter.raceAbilityScoreIncreases[
                                                                          5] +
                                                                      userCharacter
                                                                          .featsASIScoreIncreases[5]] ??
                                                                  "0"))
                                                        ])),
                                              ])),
                                      //Other stuff
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 0, 3, 0),
                                          alignment: Alignment.center,
                                          width: 95.0,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 22,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  height: 26,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  height: 260,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                              ]))
                                    ])),
                                //Middle small box
                                Container(
                                    alignment: Alignment.center,
                                    height: 48.0,
                                    child: Container(
                                      height: 26.0,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.8)),
                                    )),
                                //Bottom box
                                Container(
                                  alignment: Alignment.center,
                                  height: 132.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.8)),
                                )
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
                                        const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Column(children: [
                                      SizedBox(height: 9),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 53.0,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xffffffff),
                                            border: Border.all(width: 0.8)),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xffffffff),
                                            border: Border.all(width: 0.8)),
                                      ),
                                      SizedBox(height: 7),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xffffffff),
                                            border: Border.all(width: 0.8)),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xffffffff),
                                            border: Border.all(width: 0.8)),
                                      )
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
                                          alignment: Alignment.center,
                                          width: 110.0)
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
                                      color: const PdfColor.fromInt(0xff9c9995),
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
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.8)),
                                ),
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
