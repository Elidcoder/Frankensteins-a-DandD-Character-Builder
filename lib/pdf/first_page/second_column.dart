// External Imports
import "package:frankenstein/pdf/generator.dart" show formatList;
import "package:frankenstein/pdf/utils.dart" show modifierFromAbilityScore, decodeBonus, proficiencyBonus, formatNumber, PDF_DARK_GREY;
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart";

// Project Import
import "../../content_classes/all_content_classes.dart";
import "../../storage/global_list_manager.dart";

Widget buildSecondColumn(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    width: 155.0,
    child: Column(children: [
      Container(
        alignment: Alignment.center,
        height: 244.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: PDF_DARK_GREY,
        ),
        padding: const EdgeInsets.fromLTRB(5, 13, 5, 0),
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            height: 47.0,
            child: Row(children: [
              buildArmourClassBox(userCharacter),
              SizedBox(width: 5),
              buildInitiativeBox(userCharacter),
              SizedBox(width: 5),
              buildSpeedBox(userCharacter)
            ])
          ),
          SizedBox(height: 10),
          buildHealthBox(userCharacter),
          SizedBox(height: 7),
          buildTemporaryHealthBox(userCharacter),
          SizedBox(height: 7),
          Row(children: [
            buildHitDiceBox(userCharacter),
            SizedBox(width: 5),
            buildDeathSavesBox(userCharacter)
          ]),
        ])),


      Container(
        alignment: Alignment.center,
        height: 203.5,
        child: Column(
          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
          children: buildCentralBoxes(userCharacter)
        )
      ),

      
      Container(
        alignment: Alignment.center,
        height: 180.0,
        decoration: BoxDecoration(border: Border.all(width: 0.8)),
        child: Row(
          children: [
            buildCoinsBoxes(userCharacter),
            buildEquipmentBox(userCharacter)
          ],
        ))
    ]));
}

Container buildArmourClassBox(Character userCharacter) {
  return Container(
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
      Text(
          "${10 + (modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0)}"),
      Container(
        width: 155,
        //child:
      ),
    ]));
}


Container buildInitiativeBox(Character userCharacter) {
  return Container(
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
                      .initialProficiencies,
              // ...classSkills,
              // ...skillsSelected
            ].contains("Initiative"))
                ? Text(
                    "${formatNumber((modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0) + (userCharacter.skillBonusMap["Initiative"] ?? 0) + (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
                    style:
                        const TextStyle(
                            fontSize:
                                18))
                : Text(
                    "${formatNumber((modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0) + (userCharacter.skillBonusMap["Initiative"] ?? 0))} ",
                    style:
                        const TextStyle(
                            fontSize:
                                18)))
      ]));
}


Container buildSpeedBox(Character userCharacter) {
  return Container(
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
    ]));
}


Container buildHealthBox(Character userCharacter) {
  return Container(
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
  );
}

Container buildTemporaryHealthBox(Character userCharacter) {
  return Container(
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
            fontSize: 9.5)));
}

Container buildHitDiceBox(Character userCharacter) {
  return Container(
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
                  GlobalListManager().classList
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
                          "${(userCharacter.classList.where((car) => car == entry.key).length)}D${GlobalListManager().classList.firstWhere((car) => car.name == entry.key).maxHitDiceRoll}")
                      .join(", "),
                  style: const TextStyle(
                      fontSize: 9,
                      decoration: TextDecoration.underline)),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    ]));
}

Container buildDeathSavesBox(Character userCharacter) {
  return Container(
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
    ]));
}

List<Container> buildCentralBoxes(Character userCharacter) {
  return [
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
      child: ListView.builder(
        itemCount: userCharacter
            .allSpellsSelected.length,
        itemBuilder: (context, index) {
          return Text(userCharacter
              .allSpellsSelected[index]
              .name);
        },
      ),
    ),
  ];
}

Container buildCoinsBoxes(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    width: 45.0,
    child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
        children: [
          //Platinum
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
          //Gold
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
          //Electrum
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
          //Silver
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
          //Copper
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
        ]));
}

Container buildEquipmentBox(Character userCharacter) {
  return Container(
    padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
    alignment: Alignment.center,
    width: 110.0,
    child: Column(children: [
      Text("Equipment"),
      Container(
        child: Text([
          ...[
            for (var x in userCharacter.equipmentSelectedFromChoices)
              formatList(x[0])
          ],
          ...userCharacter.unstackableEquipmentSelected.map(
            (entry) => entry.name
          ),
          ...userCharacter.stackableEquipmentSelected.entries.map(
            (entry) => "${entry.value}x${entry.key}"
          ),
          ...userCharacter.background.equipment
        ].join(", "),
        style: const TextStyle(fontSize: 8)))
    ]));
                                    
}