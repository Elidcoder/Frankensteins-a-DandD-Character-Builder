import 'dart:typed_data';
//import 'package:makepdfs/models/invoice.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:frankenstein/PDFdocs/character_class.dart';

//1028xidk
//ARGB => 0x(AA)(RR)(GG)(BB)

Future<Uint8List> makePdf(Character userCharacter) async {
  final pdf = Document();
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
                  width: 400.0,
                  decoration: BoxDecoration(
                    color: const PdfColor.fromInt(0xff2196FD),
                    border: Border.all(
                        color: const PdfColor.fromInt(0xff214AFD), width: 0.8),
                  ),
                ),
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
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xff660202),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Strength"),
                                                      Text(
                                                          "${userCharacter.strength.value + userCharacter.raceAbilityScoreIncreases[0] + userCharacter.featsASIScoreIncreases[0]}"),
                                                      Container(
                                                          height: 13,
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                      width:
                                                                          0.8)),
                                                          child: Text(modifierFromAbilityScore[userCharacter
                                                                      .strength
                                                                      .value +
                                                                  userCharacter
                                                                          .raceAbilityScoreIncreases[
                                                                      0] +
                                                                  userCharacter
                                                                          .featsASIScoreIncreases[
                                                                      0]] ??
                                                              "0"))
                                                    ])),
                                                Container(
                                                    height: 63,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xff660202),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Dexterity"),
                                                      Text(
                                                          "${userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]}"),
                                                      Container(
                                                          height: 13,
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                      width:
                                                                          0.8)),
                                                          child: Text(modifierFromAbilityScore[userCharacter
                                                                      .dexterity
                                                                      .value +
                                                                  userCharacter
                                                                          .raceAbilityScoreIncreases[
                                                                      1] +
                                                                  userCharacter
                                                                          .featsASIScoreIncreases[
                                                                      1]] ??
                                                              "0"))
                                                    ])),
                                                Container(
                                                    height: 63,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xff660202),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Constitution"),
                                                      Text(
                                                          "${userCharacter.constitution.value + userCharacter.raceAbilityScoreIncreases[2] + userCharacter.featsASIScoreIncreases[2]}"),
                                                      Container(
                                                          height: 13,
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                      width:
                                                                          0.8)),
                                                          child: Text(modifierFromAbilityScore[userCharacter
                                                                      .constitution
                                                                      .value +
                                                                  userCharacter
                                                                          .raceAbilityScoreIncreases[
                                                                      2] +
                                                                  userCharacter
                                                                          .featsASIScoreIncreases[
                                                                      2]] ??
                                                              "0"))
                                                    ])),
                                                Container(
                                                    height: 63,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xff660202),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Intelligence"),
                                                      Text(
                                                          "${userCharacter.intelligence.value + userCharacter.raceAbilityScoreIncreases[3] + userCharacter.featsASIScoreIncreases[3]}"),
                                                      Container(
                                                          height: 13,
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                      width:
                                                                          0.8)),
                                                          child: Text(modifierFromAbilityScore[userCharacter
                                                                      .intelligence
                                                                      .value +
                                                                  userCharacter
                                                                          .raceAbilityScoreIncreases[
                                                                      3] +
                                                                  userCharacter
                                                                          .featsASIScoreIncreases[
                                                                      3]] ??
                                                              "0"))
                                                    ])),
                                                Container(
                                                    height: 63,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xff660202),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Wisdom"),
                                                      Text(
                                                          "${userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]}"),
                                                      Container(
                                                          height: 13,
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                      width:
                                                                          0.8)),
                                                          child: Text(modifierFromAbilityScore[userCharacter
                                                                      .wisdom
                                                                      .value +
                                                                  userCharacter
                                                                          .raceAbilityScoreIncreases[
                                                                      4] +
                                                                  userCharacter
                                                                          .featsASIScoreIncreases[
                                                                      4]] ??
                                                              "0"))
                                                    ])),
                                                Container(
                                                    height: 63,
                                                    decoration: BoxDecoration(
                                                        color: const PdfColor
                                                                .fromInt(
                                                            0xff660202),
                                                        border: Border.all(
                                                            width: 0.8)),
                                                    child: Column(children: [
                                                      Text("Charisma"),
                                                      Text(
                                                          "${userCharacter.charisma.value + userCharacter.raceAbilityScoreIncreases[5] + userCharacter.featsASIScoreIncreases[5]}"),
                                                      Container(
                                                          height: 13,
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                      width:
                                                                          0.8)),
                                                          child: Text(modifierFromAbilityScore[userCharacter
                                                                      .charisma
                                                                      .value +
                                                                  userCharacter
                                                                          .raceAbilityScoreIncreases[
                                                                      5] +
                                                                  userCharacter
                                                                          .featsASIScoreIncreases[
                                                                      5]] ??
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
                                                      color: const PdfColor
                                                          .fromInt(0xff660202),
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  height: 26,
                                                  decoration: BoxDecoration(
                                                      color: const PdfColor
                                                          .fromInt(0xff660202),
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      color: const PdfColor
                                                          .fromInt(0xff660202),
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  height: 260,
                                                  decoration: BoxDecoration(
                                                      color: const PdfColor
                                                          .fromInt(0xff660202),
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
                                          color: const PdfColor.fromInt(
                                              0xff660202),
                                          border: Border.all(width: 0.8)),
                                    )),
                                //Bottom box
                                Container(
                                  alignment: Alignment.center,
                                  height: 132.0,
                                  decoration: BoxDecoration(
                                      color: const PdfColor.fromInt(0xff660202),
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
                                                0xff660202),
                                            border: Border.all(width: 0.8)),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xff660202),
                                            border: Border.all(width: 0.8)),
                                      ),
                                      SizedBox(height: 7),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xff660202),
                                            border: Border.all(width: 0.8)),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xff660202),
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
                                                color: const PdfColor.fromInt(
                                                    0xff660202),
                                                border: Border.all(width: 0.8)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 16.0,
                                            decoration: BoxDecoration(
                                                color: const PdfColor.fromInt(
                                                    0xff660202),
                                                border: Border.all(width: 0.8)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 16.0,
                                            decoration: BoxDecoration(
                                                color: const PdfColor.fromInt(
                                                    0xff660202),
                                                border: Border.all(width: 0.8)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 130.5,
                                            decoration: BoxDecoration(
                                                color: const PdfColor.fromInt(
                                                    0xff660202),
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
                                                          .fromInt(0xff660202),
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 27.0,
                                                  decoration: BoxDecoration(
                                                      color: const PdfColor
                                                          .fromInt(0xff660202),
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 27.0,
                                                  decoration: BoxDecoration(
                                                      color: const PdfColor
                                                          .fromInt(0xff660202),
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 27.0,
                                                  decoration: BoxDecoration(
                                                      color: const PdfColor
                                                          .fromInt(0xff660202),
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 27.0,
                                                  decoration: BoxDecoration(
                                                      color: const PdfColor
                                                          .fromInt(0xff660202),
                                                      border: Border.all(
                                                          width: 0.8)),
                                                ),
                                              ])),
                                      //Equipment?
                                      Container(
                                        alignment: Alignment.center,
                                        width: 110.0,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xff660202),
                                            border: Border.all(width: 0.8)),
                                      )
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
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xff660202),
                                            border: Border.all(width: 0.8)),
                                      ),
                                      SizedBox(height: 9),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 46.5,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xff660202),
                                            border: Border.all(width: 0.8)),
                                      ),
                                      SizedBox(height: 9),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 43.5,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xff660202),
                                            border: Border.all(width: 0.8)),
                                      ),
                                      SizedBox(height: 9),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 46.5,
                                        decoration: BoxDecoration(
                                            color: const PdfColor.fromInt(
                                                0xff660202),
                                            border: Border.all(width: 0.8)),
                                      ),
                                    ])),
                                SizedBox(height: 8),
                                Container(
                                  alignment: Alignment.center,
                                  height: 375.5,
                                  decoration: BoxDecoration(
                                      color: const PdfColor.fromInt(0xff660202),
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
