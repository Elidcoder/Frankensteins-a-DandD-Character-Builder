// External Imports
import "package:frankenstein/pdf/generator.dart" show formatList;
import "package:frankenstein/pdf/utils.dart" show modifierFromAbilityScore, decodeBonus, proficiencyBonus, formatNumber, PDF_DARK_GREY, PDF_WHITE, PDF_LIGHT_GREY;
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
    padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
    decoration: BoxDecoration(
      color: PDF_WHITE,
      border: Border.all(width: 0.8),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
    child: Column(children: [
      Text("ARMOUR", style: const TextStyle(fontSize: 7.6)),
      Text("CLASS", style: const TextStyle(fontSize: 7.6)),
      Text(
        "${10 + (modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0)}",
        style: const TextStyle(fontSize: 18)
      ),
    ])
  );
}

Container buildDisplayBox(Text label, Text value) {
  return Container(
    height: 47,
    padding: const EdgeInsets.fromLTRB(1, 4, 1, 0),
    width: 45,
    decoration: BoxDecoration(
      color: PDF_WHITE,
      border: Border.all(width: 0.8),
      borderRadius: BorderRadius.circular(6.0)
    ),
    child: Column(children: [
      label,
      SizedBox(height: 3),
      Container(child: value)
    ])
  );
}

Container buildInitiativeBox(Character userCharacter) {
  // TODO(SHOULD I CHECK THE OTHER 2?)
  bool hasInitiativeProficiency = ([
      ...userCharacter
          .skillProficiencies,
      ...userCharacter
              .background
              .initialProficiencies,
      // ...classSkills,
      // ...skillsSelected
    ].contains("Initiative"));
  return buildDisplayBox(
    Text("Initiative:", style: const TextStyle(fontSize: 9.5)), 
    Text(
      "${formatNumber((modifierFromAbilityScore[userCharacter.dexterity.value + userCharacter.raceAbilityScoreIncreases[1] + userCharacter.featsASIScoreIncreases[1]] ?? 0) + (userCharacter.skillBonusMap["Initiative"] ?? 0) + (hasInitiativeProficiency ? 1 : 0) * (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
      style: const TextStyle(fontSize: 18)
    )
  );
}

Container buildSpeedBox(Character userCharacter) {
  // TODO(THIS BEHAVIOUR MAY NOT BE CORRECT IF A BONUS IS PROVIDED BY BOTH)
  int raceRelatedBonus = (userCharacter.subrace == null) ? userCharacter.race.walkingSpeed : userCharacter.subrace!.walkingSpeed;
  return buildDisplayBox(
    Text("Speed", style: const TextStyle(fontSize: 9.5)), 
    Text(
      "${raceRelatedBonus + decodeBonus(userCharacter.speedBonuses["Walking"] ?? [])}ft",
      style: const TextStyle(fontSize: 18)
    )
  );
}

Container buildHealthBox(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    height: 56.0,
    padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
    decoration: BoxDecoration(
      color: PDF_WHITE,
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
          Text(
            "Hit point maximum: ",
            style: TextStyle(fontSize: 9.6, fontItalic: Font.timesBoldItalic(), color: PDF_LIGHT_GREY),
          ),
          Text(
            " ${userCharacter.maxHealth}",
            style: const TextStyle(fontSize: 10.6, decoration: TextDecoration.underline)
          )
        ]))
    ]),
  );
}

Container buildTemporaryHealthBox(Character userCharacter) {
  return Container(
    width: 155,
    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
    height: 44.0,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(2),
        topRight: Radius.circular(2),
        bottomLeft: Radius.circular(6),
        bottomRight: Radius.circular(6),
      ),
      color: PDF_WHITE,
      border: Border.all(width: 0.8)
    ),
    child: Text(
      "           Temporary hit points:",
      style: const TextStyle(fontSize: 9.5)
    )
  );
}

Container buildHitDiceBox(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    width: 70,
    height: 54.0,
    padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
    decoration: BoxDecoration(
      color: PDF_WHITE,
      border: Border.all(width: 0.8),
      borderRadius: BorderRadius.circular(4.0)
    ),
    child: Column(children: [
      Text("Hit Dice:", style: const TextStyle(fontSize: 10.5)),
      Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            children: [
              SizedBox(width: 5),
              Text(
                "Total: ",
                style: TextStyle(fontSize: 8, fontItalic: Font.timesBoldItalic(), color: PDF_LIGHT_GREY)
              ),
              Text(
                // Note this is generating the nDk for each class selected by the user to support multiclassing across hit die types 
                GlobalListManager().classList.where(
                  (clas) => userCharacter.classList.contains(clas.name)
                ).fold<Map<String, int>>(
                  {},
                  (map, clas) => map..update(clas.name, (count) => count + 1, ifAbsent: () => 1)).entries.where(
                    (entry) => entry.value > 0
                  ).map(
                    (entry) => "${(userCharacter.classList.where((car) => car == entry.key).length)}D${GlobalListManager().classList.firstWhere((car) => car.name == entry.key).maxHitDiceRoll}"
                  ).join(", "),
                style: const TextStyle(fontSize: 9, decoration: TextDecoration.underline)),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    ]));
}

Container buildDeathSavesBox(Character userCharacter) {
  Container buildTripleMarkable(String label) {
    return Container(
      padding: const EdgeInsets.fromLTRB(1, 0, 0, 0),
      child: Row(children: [
        Text(
          "$label:",
          style: TextStyle(fontSize: 7, fontItalic: Font.timesBoldItalic(), color: PDF_LIGHT_GREY)
        ),
        Text(" O-O-O", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5))
      ]),
    );
  }
  return Container(
    height: 54.0,
    padding: const EdgeInsets.fromLTRB(1, 3, 1, 0),
    width: 70,
    decoration: BoxDecoration(
      color: PDF_WHITE,
      border: Border.all(width: 0.8),
      borderRadius: BorderRadius.circular(4.0)
    ),
    child: Column(children: [
      Text(" Death Saves:", style: const TextStyle(fontSize: 9.5)),
      buildTripleMarkable("Successes"),
      buildTripleMarkable("Fails")
    ]));
}

List<Container> buildCentralBoxes(Character userCharacter) {
  Container buildHighlightBox() {
    return Container(
      alignment: Alignment.center,
      height: 16.0,
      decoration: BoxDecoration(border: Border.all(width: 0.8)),
    );
  }
  return [
    buildHighlightBox(),
    buildHighlightBox(),
    buildHighlightBox(),
    Container(
      alignment: Alignment.center,
      height: 130.5,
      decoration: BoxDecoration(border: Border.all(width: 0.8)),
      child: ListView.builder(
        itemCount: userCharacter.allSpellsSelected.length,
        itemBuilder: (context, index) {
          return Text(userCharacter.allSpellsSelected[index].name);
        },
      ),
    ),
  ];
}

Container buildCoinsBoxes(Character userCharacter) {
  Container buildCoinBox(String coinName) {
    return Container(
      alignment: Alignment.center,
      height: 27.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 0.8)
      ),
      child: Column(children: [
        Text(coinName, style: const TextStyle(fontSize: 8)),
        Text("${userCharacter.currency["$coinName Pieces"] ?? "ERROR"}")
      ])
    );
  }

  return Container(
    alignment: Alignment.center,
    width: 45.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildCoinBox("Platinum"),
        buildCoinBox("Gold"),
        buildCoinBox("Electrum"),
        buildCoinBox("Silver"),
        buildCoinBox("Copper")
      ]
    )
  );
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
          style: const TextStyle(fontSize: 8)
        )
      )
    ])
  );                                    
}
